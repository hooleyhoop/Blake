//
//  CoordinateTransformTests.m
//  DebugDrawing
//
//  Created by steve hooley on 08/07/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "Graphic.h"
#import "HitTestContext.h"
#import "XForm.h"


@interface CoordinateTransformTests : SenTestCase {
	
}

@end


@implementation CoordinateTransformTests

- (void)setUp {
}

- (void)tearDown {
}

- (void)testWhatWouldHappenIf {
	
	/* First with layers */
	
	// root 'world layer' - no transform
	CALayer *rootLayer = [CALayer layer];

	// a child layer, moved a bit
	CALayer *childLayer1 = [CALayer layer];
	[rootLayer addSublayer:childLayer1];
	
	// a child of that moved a bit more
	CALayer *childLayer2 = [CALayer layer];
	[childLayer1 addSublayer:childLayer2];
	
	rootLayer.anchorPoint = CGPointMake(0,0);
	rootLayer.position = CGPointMake(0,0);
	rootLayer.bounds = CGRectMake(0,0,10,10);
	
	childLayer1.anchorPoint = CGPointMake(0,0);
	childLayer1.position = CGPointMake(10,10);
	childLayer1.bounds = CGRectMake(0,0,10,10);
	
	childLayer2.anchorPoint = CGPointMake(0,0);
	childLayer2.position = CGPointMake(10,10);
	childLayer2.bounds = CGRectMake(0,0,10,10);
	
	CGRect frame = childLayer2.frame;
	CGPoint worldOrigin = [childLayer2 convertPoint:CGPointMake(0,0) toLayer:rootLayer];
	
	// where is is it world space?
	STAssertTrue(CGPointEqualToPoint(worldOrigin, CGPointMake(20,20)), @"Fuck you %@", NSStringWithCGPoint(worldOrigin));
//	STAssertTrue(CGRectEqualToRect(frame, CGRectMake(0,0,10,10)), @"Fuck You %@", NSStringFromRect(NSRectFromCGRect(frame)));
	
	/* Now with Nodes */

	Graphic *rootGraphic = [Graphic makeChildWithName:@"root"];
	Graphic *childGraphic1 = [Graphic makeChildWithName:@"childGraphic1"];
	Graphic *childGraphic2 = [Graphic makeChildWithName:@"childGraphic1"];
	
	[rootGraphic addChild:childGraphic1 undoManager:nil];
	[childGraphic1 addChild:childGraphic2 undoManager:nil];

	rootGraphic.scale = 1.0f;
	rootGraphic.position = CGPointMake(0,0);
	rootGraphic.anchorPt = CGPointMake(0,0);
	rootGraphic.geometryRect = CGRectMake(0,0,10,10);
	[rootGraphic enforceConsistentState];
	
	childGraphic1.scale = 1.0f;
	childGraphic1.position = CGPointMake(10,10);
	childGraphic1.anchorPt = CGPointMake(0,0);
	childGraphic1.geometryRect = CGRectMake(0,0,10,10);
	[childGraphic1 enforceConsistentState];

	childGraphic2.scale = 1.0f;
	childGraphic2.position = CGPointMake(10,10);
	childGraphic2.anchorPt = CGPointMake(0,0);
	childGraphic2.geometryRect = CGRectMake(0,0,1000,1000);
	[childGraphic2 enforceConsistentState];

	CGPoint worldOrigin2 = [childGraphic2 convertPoint:CGPointMake(0,0) toGraphic:rootGraphic];
	STAssertTrue( CGPointEqualToPoint( worldOrigin2, CGPointMake(20,20) ), @"Fuck you %@", NSStringWithCGPoint(worldOrigin2));

	/* Mutha fucking hit testing! */
	HitTestContext *hitTestCntxt = [HitTestContext hitTestContextAtPoint: CGPointMake(20,20)];

	// node must be a parent of self
	NSArray *rev3 = [rootGraphic reverseNodeChainToNode:childGraphic2];

	for(NSUInteger i=[rev3 count]; i>0; i--)
	{
		SHNode *n = [rev3 objectAtIndex:i-1];
		if([n respondsToSelector:@selector(xForm)]){
			XForm *hmmmXForm = [(id)n xForm];
			CGAffineTransform cgaf = [hmmmXForm unCompensatedTransformMatrix];
			CGContextConcatCTM( [hitTestCntxt offScreenCntx], cgaf );
		}
	}

	-- dont apply matrix inside drawing
	[childGraphic2 _debugHitTestDrawing:[hitTestCntxt offScreenCntx]];
	
	[hitTestCntxt checkAndResetWithKey: @"--anyKey--"];
	STAssertTrue( [hitTestCntxt countOfHitObjects]==1, @"oops %i", [hitTestCntxt countOfHitObjects]);

	[hitTestCntxt cleanUpHitTesting];

}

@end
