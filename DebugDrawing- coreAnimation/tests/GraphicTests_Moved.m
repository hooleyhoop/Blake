//
//  GraphicTests_Moved.m
//  DebugDrawing
//
//  Created by steve hooley on 10/07/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "DirtyRectObserverProtocol.h"


@interface GraphicTests_Moved : SenTestCase {
	
}

- (void)graphic:(Graphic *)value becameDirtyInRect:(NSRect)dirtyRect;

@end


@implementation GraphicTests_Moved

static int _transformDidChangeCount;

+ (void)resetObservers {
	
	_transformDidChangeCount = 0;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)vcontext {
	
	NSString *context = (NSString *)vcontext;
	if(context==nil)
		[NSException raise:@"MUST SUPPLY A CONTEXT" format:@"MUST SUPPLY A CONTEXT"];
	
    if( [context isEqualToString:@"GraphicTests"] )
	{
		if( [keyPath isEqualToString:@"transformMatrix"] ){
			_transformDidChangeCount++;
		}
		
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

// make sure animations are disabled
- (void)testActionForLayer {
	
	// - (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)key {
	STAssertTrue( (NSNull *)[graphic actionForLayer:(id)self forKey:@"doesnt matter"]==[NSNull null], @"er");
}


- (void)testSetPhysicalBounds {
	// - (void)setPhysicalBounds:(NSRect)val;
	
	NSRect srcRect = NSMakeRect(0,0,1,1);
	[graphic setGeometryRect:srcRect];
    [graphic setScale:1.0];
    [graphic setPosition:NSMakePoint(10,10)];
    [graphic setAnchorPt:NSMakePoint(0,0)];
	
	[graphic setPhysicalBounds: NSMakeRect(10,10,2,2)];
	NSRect geom = [graphic geometryRect];
	STAssertTrue( NSEqualRects(geom, NSMakeRect(0,0,2,2)), @"%@", NSStringFromRect(geom));
}

- (void)testMoveAnchorByWorldAmountXByY {
	// - (void)moveAnchorByWorldAmountX:(CGFloat)x byY:(CGFloat)y;
	
	[graphic setAnchorPt:NSMakePoint(10, 10) ];
	[graphic moveAnchorByWorldAmountX:10 byY:10];
	CGPoint anchorP = [graphic anchorPt];
	STAssertTrue( NSEqualPoints(anchorP, NSMakePoint(20,20)), @"%@", NSStringWithCGPoint(anchorP));
}

- (void)testMoveEdgeByXByY {
	// - (void)moveEdge:(int)edge byX:(CGFloat)xamount byY:(CGFloat)yamount;
	
	NSRect srcRect = NSMakeRect(0,0,1,1);
	[graphic setGeometryRect:srcRect];
	[graphic setScale:1.0];
	[graphic setPosition:NSMakePoint(10,10)];
	[graphic setAnchorPt:NSMakePoint(0,0)];
	
	[graphic moveEdge:SKTGraphicLeftEdge byX:-1 byY:0];
	STAssertTrue( NSEqualPoints(NSPointFromCGPoint(graphic.geometryOrigin), NSMakePoint(-1,0)), @"%@", NSStringWithCGPoint(graphic.geometryOrigin));
	STAssertTrue( NSEqualSizes([graphic geometryRect].size, NSMakeSize(2,1)), @"%@", NSStringFromSize([graphic geometryRect].size));
	
	[graphic moveEdge:SKTGraphicRightEdge byX:1 byY:0];
	STAssertTrue( NSEqualPoints(NSPointFromCGPoint(graphic.geometryOrigin), NSMakePoint(-1,0)), @"%@", NSStringWithCGPoint(graphic.geometryOrigin));
	STAssertTrue( NSEqualSizes([graphic geometryRect].size, NSMakeSize(3,1)), @"%@", NSStringFromSize([graphic geometryRect].size));
	
	[graphic moveEdge:SKTGraphicTopEdge byX:0 byY:1];
	STAssertTrue( NSEqualPoints(NSPointFromCGPoint(graphic.geometryOrigin), NSMakePoint(-1,0)), @"%@", NSStringWithCGPoint(graphic.geometryOrigin));
	STAssertTrue( NSEqualSizes([graphic geometryRect].size, NSMakeSize(3,2)), @"%@", NSStringFromSize([graphic geometryRect].size));
	
	[graphic moveEdge:SKTGraphicBottomEdge byX:0 byY:-1];
	STAssertTrue( NSEqualPoints(NSPointFromCGPoint(graphic.geometryOrigin), NSMakePoint(-1,-1)), @"%@", NSStringWithCGPoint(graphic.geometryOrigin));
	STAssertTrue( NSEqualSizes([graphic geometryRect].size, NSMakeSize(3,3)), @"%@", NSStringFromSize([graphic geometryRect].size));
}

- (void)testTranslateByXByY {
	// - (void)translateByX:(CGFloat)x byY:(CGFloat)y;
	
	[graphic setPosition:NSMakePoint(10,10)];
	[graphic translateByX:1 byY:1];
	CGPoint pos = [graphic position];
	STAssertTrue( NSEqualPoints(pos, NSMakePoint(11,11)), @"%@", NSStringWithCGPoint(pos));
}


@end
