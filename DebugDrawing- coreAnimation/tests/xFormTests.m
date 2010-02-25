//
//  xFormTests.m
//  DebugDrawing
//
//  Created by steve hooley on 08/07/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "XForm.h"
#import "BoundingGeometry.h"


static NSUInteger _needsRecalculatingCount;

@interface xFormTests : SenTestCase {
	
	BoundingGeometry	*_geom;
	XForm				*_xForm;
}

@end


@implementation xFormTests

- (void)resetCountingVariables {

	_needsRecalculatingCount = 0;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(NSObject *)observedObject change:(NSDictionary *)change context:(void *)vcontext {
	
	NSString *context = (NSString *)vcontext;
    if( [context isEqualToString:@"xFormTests"] )
	{
        if ([keyPath isEqualToString:@"needsRecalculating"])
        {
			_needsRecalculatingCount++;
			return;
		}
	}
	[super observeValueForKeyPath:keyPath ofObject:observedObject change:change context:vcontext];
}


- (void)setUp {

	_geom =[[BoundingGeometry alloc] init];
	CGRect srcRect = CGRectMake(0,0,2,2);
	_geom.geometryRect = srcRect;

	_xForm = [[XForm alloc] init];
	[_xForm enforceConsistentState];
}

- (void)tearDown {
	
	[_xForm release];
	[_geom release];
}

/*	Our transform matrix is componsated by the bounds offset 
	Hence we need the uncomponsated transform matrix ASWELL!
	Is there an easy way to go from one to the other?
 */
- (void)testDiffernceBetweenTransforms {
	
    [_xForm setScale:2.0f];
    [_xForm setPosition:CGPointMake(10.f,10.f)];
    [_xForm setAnchorPt:CGPointMake(5.f,3.f)];
	[_xForm enforceConsistentState];
	
//june09	CGAffineTransform offsetMatrix = _xForm.originCompensatedTransformMatrix;
	CGAffineTransform unCompensatedMatrix = [_xForm unCompensatedTransformMatrix];
	
//	CGAffineTransform newBoundsTransforMatrix = [NSAffineTransform transform];
//	[newBoundsTransforMatrix translateXBy:5 yBy:3];
	
//    CGAffineTransform newFinalTransform = [NSAffineTransform transform];
//	[newFinalTransform prependTransform:newBoundsTransforMatrix];
//	[newFinalTransform appendTransform:mat2];

	CGPoint testWorldPoint = CGPointMake(1,1);
	CGPoint newPos1 = CGPointApplyAffineTransform( testWorldPoint, unCompensatedMatrix );
//	newPos1 = [newBoundsTransforMatrix transformPoint:newPos1];

	// transformed by compensated matrix
//june09    CGPoint newPos2 = CGPointApplyAffineTransform( testWorldPoint, offsetMatrix );

// NB
//	I have found it impossible to transform the uncompensated matrix into the compensated one
//	I do not remember why they are needed!s
	
//	STAssertTrue( CGPointEqualToPoint( newPos1, newPos2 ), @"%@ - %@", NSStringWithCGPoint(newPos1), NSStringWithCGPoint(newPos2));
}

//- (void)testRecalcTransformMatrix {
//	// - (void)recalcTransformMatrix;
//	
//	// -- check that the transform is as should Be
//	_geom.geometryRect = CGRectMake(0,0,1,1);
//
//    [_xForm setScale:1.0];
//    [_xForm setPosition:CGPointMake(10,10)];
//    [_xForm setAnchorPt:CGPointMake(0,0)];
//
//	STAssertTrue( _xForm.needsRecalculating==YES, @"er");
//	[_xForm enforceConsistentState];
//	STAssertTrue( _xForm.needsRecalculating==NO, @"er");
//	
//	CGAffineTransform currentTransform = [_xForm originCompensatedTransformMatrix];
//
//	CGPoint xFormedPt = CGPointApplyAffineTransform( CGPointMake(0,0), currentTransform );
//	STAssertTrue( xFormedPt==);
//	
//	STAssertTrue( G3DCompareFloat( currentTransform.a, 1.0, 0.001)==0, @"eh");
//	STAssertTrue( G3DCompareFloat( currentTransform.b, 0.0, 0.001)==0, @"eh" );
//	STAssertTrue( G3DCompareFloat( currentTransform.c, 0.0, 0.001)==0, @"eh");
//	STAssertTrue( G3DCompareFloat( currentTransform.d, 1.0, 0.001)==0, @"eh");
//	STAssertTrue( G3DCompareFloat( currentTransform.tx, 10.0, 0.001)==0, @"eh");
//	STAssertTrue( G3DCompareFloat( currentTransform.ty, 10.0, 0.001)==0, @"eh");
//}

#pragma mark PROPER WAY
- (void)testResultantAffineXForm {
	// + (CGAffineTransform)resultantAffineXForm:(NSArray *)xForms
	
	XForm *xForm1 = [[[XForm alloc] init] autorelease];
	XForm *xForm2 = [[[XForm alloc] init] autorelease];
	XForm *xForm3 = [[[XForm alloc] init] autorelease];
	xForm1.position = CGPointMake( 5, 1 );
	xForm2.position = CGPointMake( 50, 20 );
	xForm3.position = CGPointMake( 3, 3 );
	
	//! need to make sure that each xform is uptodate - build it in!
	[xForm1 enforceConsistentState];
	[xForm2 enforceConsistentState];
	[xForm3 enforceConsistentState];

	CGAffineTransform finalXForm = [XForm resultantAffineXForm:[NSArray arrayWithObjects:xForm1, xForm2, xForm3, nil]];
    CGPoint resultPoint = CGPointApplyAffineTransform( CGPointMake(0,0), finalXForm );
	STAssertTrue( CGPointEqualToPoint( resultPoint, CGPointMake(58,24)), @"doh %@", NSStringWithCGPoint(resultPoint) );
}

- (void)testObservingNeedsRecalculating {

	[_xForm addObserver:self forKeyPath:@"needsRecalculating" options:0 context:@"xFormTests"];
	[self resetCountingVariables];
	
	[_xForm setScale:2.0f];
	STAssertTrue(_needsRecalculatingCount==1, @"hm %i", _needsRecalculatingCount );
	
	[_xForm setPosition:CGPointMake(2.0f,2.0f)];
	STAssertTrue(_needsRecalculatingCount==1, @"hm %i", _needsRecalculatingCount );

	[_xForm setRotation:2.0f];
	STAssertTrue(_needsRecalculatingCount==1, @"hm %i", _needsRecalculatingCount );

	[_xForm enforceConsistentState];
	STAssertTrue(_needsRecalculatingCount==1, @"hm %i", _needsRecalculatingCount );

	[_xForm removeObserver:self forKeyPath:@"needsRecalculating"];
}

- (void)testResultantReverseAffineXForm {
	//+ (CGAffineTransform)resultantReverseAffineXForm:(NSArray *)xForms

	XForm *xForm1 = [[[XForm alloc] init] autorelease];
	XForm *xForm2 = [[[XForm alloc] init] autorelease];
	XForm *xForm3 = [[[XForm alloc] init] autorelease];

	xForm1.position = CGPointMake( 5, 1 );
	xForm2.position = CGPointMake( 50, 20 );
	xForm3.position = CGPointMake( 3, 3 );

	//! need to make sure that each xform is uptodate - build it in!
	[xForm1 enforceConsistentState];
	[xForm2 enforceConsistentState];
	[xForm3 enforceConsistentState];

	CGAffineTransform finalXForm = [XForm resultantReverseAffineXForm:[NSArray arrayWithObjects:xForm1, xForm2, xForm3, nil]];

    CGPoint resultPoint = CGPointApplyAffineTransform( CGPointMake(58,24), finalXForm );
	STAssertTrue( CGPointEqualToPoint( resultPoint, CGPointMake(0,0)), @"doh %@", NSStringWithCGPoint(resultPoint) );
}

#pragma mark USELESS WAY
//- (void)testParentSpacePtToLocalSpace {
//	// - (CGPoint)parentSpacePtToLocalSpace:(CGPoint)value;
//	
//	CGRect srcRect1 = CGRectMake(0,0,1,1);
//
//	[_xForm setScale:1.0];
//	[_xForm setPosition:CGPointMake(0,0)];
//	[_xForm setAnchorPt:CGPointMake(0,0)];
//	[_xForm enforceConsistentState];
//	
//	// simple 1:1
//	CGPoint localPt1 = [_xForm parentSpacePtToLocalSpace: CGPointMake(0,0)];
//	STAssertTrue( CGPointEqualToPoint(localPt1, CGPointMake(0, 0)), @"%@", NSStringWithCGPoint(localPt1));
//	
//	// translate
//    [_xForm setPosition:CGPointMake(5,5)];
//	[_xForm enforceConsistentState];
//	CGPoint localPt2 = [_xForm parentSpacePtToLocalSpace: CGPointMake(5,5)];
//	STAssertTrue( CGPointEqualToPoint(localPt2, CGPointMake(0, 0)), @"%@", NSStringWithCGPoint(localPt2));
//	
//	// translate + anchor
//    [_xForm setAnchorPt:CGPointMake(5,5)];
//	[_xForm enforceConsistentState];
//	CGPoint localPt3 = [_xForm parentSpacePtToLocalSpace: CGPointMake(5,5)];
//	STAssertTrue( CGPointEqualToPoint(localPt3, CGPointMake(5, 5)), @"%@", NSStringWithCGPoint(localPt3));
//	
//	// add in some scale
//    [_xForm setScale:2.0];
//	[_xForm enforceConsistentState];
//	CGPoint localPt4 = [_xForm parentSpacePtToLocalSpace: CGPointMake(15,15)];
//	STAssertTrue( CGPointEqualToPoint(localPt4, CGPointMake(10, 10)), @"%@", NSStringWithCGPoint(localPt4));
//	
//	// add in some rotation
//    [_xForm setRotation:90.0f];
//	[_xForm enforceConsistentState];
//	CGPoint localPt5 = [_xForm parentSpacePtToLocalSpace: CGPointMake(15,15)];
//	STAssertTrue( G3DCompareFloat(localPt5.x,10.0,0.01)==0, @"%f", localPt5.x);
//	STAssertTrue( localPt5.y>-0.01f && localPt5.y<0.01f, @"%f", localPt5.y);
//	
//	_geom.geometryRect = srcRect1;
//
//	[_xForm setScale:2.0];
//	[_xForm setRotation:0.0];
//	[_xForm setPosition:CGPointMake(1,0)];
//	[_xForm setAnchorPt:CGPointMake(1, 0)];
//	[_xForm enforceConsistentState];
//
//	CGPoint testWorldPoint = CGPointMake(1,1);
//	CGPoint asLocalPoint = [_xForm parentSpacePtToLocalSpace:testWorldPoint];
//	STAssertTrue( CGPointEqualToPoint( asLocalPoint, CGPointMake(1.0,0.5)), @"Fucked this shit up! %@", NSStringWithCGPoint(asLocalPoint) );
//	
//	[_xForm setScale:1.0];
//	[_xForm setPosition:CGPointMake(0,0)];
//	[_xForm setAnchorPt:CGPointMake(0,0)];
//	[_xForm setRotation:180.0];
//	[_xForm enforceConsistentState];
//
//	asLocalPoint = [_xForm parentSpacePtToLocalSpace:testWorldPoint];
//	STAssertTrue( nearlyEqualCGPoints( asLocalPoint, CGPointMake(-1.0, -1.0)), @"Fucked this shit up! %@", NSStringWithCGPoint(asLocalPoint) );
//}
//
///* These tests are verified from after effects */
//- (void)testLocalPtToParentSpace {
//	// - (CGPoint)localPtToParentSpace:(CGPoint)value;
//	
//	// simple 1:1 case
//	CGRect srcRect = CGRectMake(0,0,1,1);
//	_geom.geometryRect = srcRect;
//
//    [_xForm setScale:1.0];
//    [_xForm setPosition:CGPointMake(0,0)];
//    [_xForm setAnchorPt:CGPointMake(0,0)];
//	[_xForm enforceConsistentState];
//	
//	CGPoint localPt = CGPointMake(5,5); 
//	CGPoint worldPt1 = [_xForm localPtToParentSpace:localPt];
//	STAssertTrue( CGPointEqualToPoint(worldPt1, CGPointMake(5, 5)), @"%@", NSStringWithCGPoint(worldPt1));
//	
//	// simple translation
//    [_xForm setPosition:CGPointMake(10,10)];
//    [_xForm setAnchorPt:CGPointMake(0,0)];
//	[_xForm enforceConsistentState];
//	CGPoint worldPt2 = [_xForm localPtToParentSpace:localPt];
//	STAssertTrue( CGPointEqualToPoint(worldPt2, CGPointMake(15, 15)), @"%@", NSStringWithCGPoint(worldPt2));
//	
//	// simple translation + anchor point
//    [_xForm setAnchorPt:CGPointMake(5,5)];
//	[_xForm enforceConsistentState];
//	CGPoint worldPt3 = [_xForm localPtToParentSpace:localPt];
//	STAssertTrue( CGPointEqualToPoint(worldPt3, CGPointMake(10, 10)), @"%@", NSStringWithCGPoint(worldPt3));
//	
//	CGPoint worldPt3_2 = [_xForm localPtToParentSpace:CGPointMake(0,0)];
//	STAssertTrue( CGPointEqualToPoint(worldPt3_2, CGPointMake(5, 5)), @"%@", NSStringWithCGPoint(worldPt3_2));
//	
//	// add some scale into the mix. scaling happens around the anchor point so that wont move
//    [_xForm setScale:2.0];
//	[_xForm enforceConsistentState];
//	CGPoint worldPt4 = [_xForm localPtToParentSpace:CGPointMake(5,5)];
//	STAssertTrue( CGPointEqualToPoint(worldPt4, CGPointMake(10, 10)), @"%@", NSStringWithCGPoint(worldPt4));
//	
//	// but things around it will move
//	CGPoint worldPt4_2 = [_xForm localPtToParentSpace:CGPointMake(0,0)];
//	STAssertTrue( CGPointEqualToPoint(worldPt4_2, CGPointMake(0, 0)), @"%@", NSStringWithCGPoint(worldPt4_2));	
//	
//	// Rrrrrotation
//    [_xForm setRotation:90];
//	[_xForm enforceConsistentState];
//	CGPoint worldPt5_1 = [_xForm localPtToParentSpace:CGPointMake(0,0)];
//	STAssertTrue( CGPointEqualToPoint(worldPt5_1, CGPointMake(20, 0)), @"%@", NSStringWithCGPoint(worldPt5_1));	
//	
//	CGPoint worldPt5_2= [_xForm localPtToParentSpace:CGPointMake(20,0)];
//	STAssertTrue( nearlyEqualCGPoints(worldPt5_2, CGPointMake(20.0f, 40.0f)), @"%@", NSStringWithCGPoint(worldPt5_2));
//	
//	// Try moving the bounds - moving the bounds should not effect coordinate space translations!
//	CGRect srcRect2 = CGRectMake(0,0,1,1);
//	_geom.geometryRect = srcRect2;
//	
//	[_xForm enforceConsistentState];
//	CGPoint worldPt5_3= [_xForm localPtToParentSpace:CGPointMake(0,0)];
//	STAssertTrue( CGPointEqualToPoint(worldPt5_3, CGPointMake(20, 0)), @"%@", NSStringWithCGPoint(worldPt5_3));
//	CGPoint worldPt5_4= [_xForm localPtToParentSpace:CGPointMake(20,0)];
//	STAssertTrue( nearlyEqualCGPoints(worldPt5_4, CGPointMake(20, 40)), @"%@", NSStringWithCGPoint(worldPt5_4));
//	
//    
//	CGRect srcRect1 = CGRectMake(0, 0, 1, 1);    
//	_geom.geometryRect = srcRect1; // only setting this to ENSURE IT DOESN'T affect the outcome
//
//    [_xForm setScale:2.0];
//    [_xForm setRotation:-180.0];
//    [_xForm setPosition:CGPointMake(10.0, 10.0)];
//    [_xForm setAnchorPt:CGPointMake(0.0, 0.0)];
//    [_xForm enforceConsistentState];
//	
//	/* HERE */
//    CGPoint testLocalPoint = CGPointMake(1.0, 1.0); // top right corner of bounds
//    CGPoint asLocalPoint = [_xForm localPtToParentSpace:testLocalPoint];
//    STAssertTrue( CGPointEqualToPoint(asLocalPoint, CGPointMake(8.0, 8.0)), @"Fucked this shit up! %@", NSStringWithCGPoint(asLocalPoint));
//	
//    [_xForm setAnchorPt:CGPointMake(1.0, 1.0)];
//    [_xForm enforceConsistentState];
//	
//    asLocalPoint = [_xForm localPtToParentSpace:testLocalPoint];
//    STAssertTrue( CGPointEqualToPoint(asLocalPoint, CGPointMake(10.0, 10.0)), @"Fucked this shit up! %@", NSStringWithCGPoint(asLocalPoint));
//	
//    [_xForm setRotation:180.0];
//    [_xForm enforceConsistentState];
//	
//    asLocalPoint = [_xForm localPtToParentSpace:testLocalPoint];
//    STAssertTrue( CGPointEqualToPoint(asLocalPoint, CGPointMake(10.0, 10.0)), @"Fucked this shit up! %@", NSStringWithCGPoint(asLocalPoint));
//	/* HERE */
//	
//	
//    [_xForm setScale:1.0];
//    [_xForm setPosition:CGPointMake(0,0)];
//    [_xForm setAnchorPt:CGPointMake(0,0)];
//    [_xForm setRotation:180];
//    [_xForm enforceConsistentState];
//	
//    asLocalPoint = [_xForm localPtToParentSpace:testLocalPoint];
//    STAssertTrue( nearlyEqualCGPoints(asLocalPoint, CGPointMake(-1.0, -1.0)), @"Fucked this shit up! %@", NSStringWithCGPoint(asLocalPoint));
//	
//	/* check it is reversible */
//    [_xForm setScale:4.0];
//    [_xForm setPosition:CGPointMake(123.0,456.0)];
//    [_xForm setAnchorPt:CGPointMake(12.0,13.0)];
//    [_xForm setRotation:33.0];
//    [_xForm enforceConsistentState];
//	
//	CGPoint testPoint = CGPointMake(125, 698);
//    CGPoint p1 = [_xForm localPtToParentSpace:testPoint];
//    CGPoint reversedLocalPoint = [_xForm parentSpacePtToLocalSpace:p1];
//    STAssertTrue( nearlyEqualCGPoints( testPoint, reversedLocalPoint ), @"Fucked this shit up! %@", NSStringWithCGPoint(reversedLocalPoint) );
//}

//- (void)testCrazyPtStuff {
//	
//	CGRect srcRect = CGRectMake(0,0,1,1);
//	_geom.geometryRect = srcRect;
//    [_xForm setScale:1.0];
//    [_xForm setPosition:CGPointMake(10,10)];
//    [_xForm setAnchorPt:CGPointMake(0,0)];
//    [_xForm enforceConsistentState];
//	
//    CGRect targetRect = CGRectMake(10,10,1,1);
//    STAssertTrue( CGRectEqualToRect( [_xForm didDrawAt], targetRect), @"eh? %@", NSStringFromCGRect([_xForm didDrawAt]) );
//    STAssertTrue( CGRectEqualToRect( [_xForm transformedGeometryRectBoundingBox], targetRect), @"eh? @", NSStringFromRect([_xForm transformedGeometryRectBoundingBox]) );
//	
//    [_xForm setScale:2.0];
//    [_xForm enforceConsistentState];
//    CGRect scaledTargetRect = CGRectMake(10,10,2,2);
//    STAssertTrue( CGRectEqualToRect([_xForm didDrawAt], scaledTargetRect), @"eh? %@", NSStringFromRect([_xForm didDrawAt]) );
//    STAssertTrue( CGRectEqualToRect( [_xForm transformedGeometryRectBoundingBox], scaledTargetRect), @"eh? @", NSStringFromRect([_xForm transformedGeometryRectBoundingBox]));
//    
//    [_xForm setScale:1.0];
//    [_xForm setPosition:CGPointMake(10,10)];
//    [_xForm setAnchorPt:CGPointMake(1,1)];
//    [_xForm enforceConsistentState];
//    CGRect targetRect2 = CGRectMake(9,9,1,1);
//    STAssertTrue( CGRectEqualToRect( [_xForm transformedGeometryRectBoundingBox], targetRect2), @"eh? %@", NSStringFromRect([_xForm transformedGeometryRectBoundingBox]) );
//    STAssertTrue( CGRectEqualToRect([_xForm didDrawAt], targetRect2), @"eh? %@", NSStringFromRect([_xForm didDrawAt]) );
//    
//    [_xForm setScale:2.0];
//    [_xForm setPosition:CGPointMake(10,10)];
//    [_xForm setAnchorPt:CGPointMake(1,1)];
//    [_xForm enforceConsistentState];
//    CGRect targetRect3 = CGRectMake(8,8,2,2);
//    STAssertTrue( CGRectEqualToRect([_xForm transformedGeometryRectBoundingBox], targetRect3), @"eh? %@", NSStringFromRect([_xForm transformedGeometryRectBoundingBox]) );
//    STAssertTrue( CGRectEqualToRect([_xForm didDrawAt], targetRect3), @"eh? %@", NSStringFromRect([_xForm didDrawAt]) );
//}

@end
