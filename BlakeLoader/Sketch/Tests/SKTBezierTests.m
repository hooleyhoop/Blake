//
//  SKTBezierTests.m
//  BlakeLoader2
//
//  Created by steve hooley on 21/09/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "SKTBezier.h"


@interface SKTBezierTests : SenTestCase {
	
    SKTBezier *_bezier;
}

@end

@implementation SKTBezierTests

- (void)setUp {
	
	_bezier = [[SKTBezier alloc] init];
}

- (void)tearDown {
	
	[_bezier release];

}

- (void)testSetStrokeWidth {

    // make a shape 200 wide and 200 high - bottom left at 10,10
    [_bezier moveToPoint:NSMakePoint(100,100)];
    [_bezier lineToPoint:NSMakePoint(210,210)];
    [_bezier lineToPoint:NSMakePoint(10,210)];
    [_bezier lineToPoint:NSMakePoint(10,10)];

    NSRect bnds = [_bezier bounds];
    NSPoint pos = bnds.origin;
    NSSize siz = bnds.size;
    STAssertTrue(pos.x==10 && pos.y==10, @"Bezier origin is incorrect %i, %i", pos.x, pos.y);
    STAssertTrue(siz.width==200 && siz.height==200, @"Bezier size is incorrect %i, %i", siz.width, siz.height);
	
	_bezier.strokeWidth = 5.0;
    NSRect drawbnds = [_bezier drawingBounds];
	NSRect expectedDrawingBnds = NSInsetRect(bnds, -2.5, -2.5);
    STAssertTrue(  NSEqualRects(drawbnds, expectedDrawingBnds), @"Bezier size is incorrect - %@ - %@", NSStringFromRect(drawbnds), NSStringFromRect(expectedDrawingBnds) );
}

- (void)testStartPoint {
	// - (NSPoint)startPoint;
	
    [_bezier moveToPoint:NSMakePoint(100,100)];
    [_bezier lineToPoint:NSMakePoint(210,210)];
    [_bezier lineToPoint:NSMakePoint(10,210)];
    [_bezier lineToPoint:NSMakePoint(10,10)];
	
	NSPoint sp = [_bezier startPoint];
	STAssertTrue( NSEqualPoints(sp, NSMakePoint(100,100)) , @"Fucker!");
}

- (void)testCountOfPoints {
	// - (int)countOfPoints;

    [_bezier moveToPoint:NSMakePoint(100,100)];
    [_bezier lineToPoint:NSMakePoint(210,210)];
    [_bezier lineToPoint:NSMakePoint(10,210)];
    [_bezier lineToPoint:NSMakePoint(10,10)];

	int pointCount = [_bezier countOfPoints];
	STAssertTrue( pointCount==4 , @"Fucker! %i", pointCount );
}

- (void)testControlPts {
	// - (NSArray *)controlPts;
	
	[_bezier moveToPoint:NSMakePoint(100,100)];
    [_bezier lineToPoint:NSMakePoint(210,210)];
    [_bezier lineToPoint:NSMakePoint(10,210)];
    [_bezier lineToPoint:NSMakePoint(10,10)];
	
	NSArray *pts = [_bezier controlPts];
	
	STAssertTrue( NSEqualPoints( [[pts objectAtIndex:0] pointValue], NSMakePoint(100,100)), @"Fucker!" );
	STAssertTrue( NSEqualPoints( [[pts objectAtIndex:1] pointValue], NSMakePoint(210,210)), @"Fucker!" );
	STAssertTrue( NSEqualPoints( [[pts objectAtIndex:2] pointValue], NSMakePoint(10,210)), @"Fucker!" );
	STAssertTrue( NSEqualPoints( [[pts objectAtIndex:3] pointValue], NSMakePoint(10,10)), @"Fucker!" );
}

- (void)testSetBounds {
	
	[_bezier moveToPoint:NSMakePoint(100,100)];
    [_bezier lineToPoint:NSMakePoint(210,210)];
    [_bezier lineToPoint:NSMakePoint(10,210)];
    [_bezier lineToPoint:NSMakePoint(10,10)];
	
    NSRect bnds = [_bezier bounds];
    NSPoint pos = bnds.origin;
    NSSize siz = bnds.size;
    STAssertTrue(pos.x==10.0 && pos.y==10.0, @"Bezier origin is incorrect %f, %f", pos.x, pos.y);
    STAssertTrue(siz.width==200.0 && siz.height==200.0, @"Bezier size is incorrect %f, %f", siz.width, siz.height);
	
	[_bezier setBounds: NSMakeRect( 20.0, 20.0, siz.width, siz.height)];
	 NSRect movedBnds = [_bezier bounds];
	 NSPoint movedPos = movedBnds.origin;
	 STAssertTrue( movedPos.x==20.0 && movedPos.y==20.0, @"Bezier origin is incorrect %f, %f", movedPos.x, movedPos.y );

	[_bezier setBounds: NSMakeRect( 0, 0, siz.width/2.0, siz.height/2.0 )];
	NSRect scaledBnds = [_bezier bounds];
	NSPoint scaledPos = scaledBnds.origin;
	NSSize scaledSize = scaledBnds.size;
	STAssertTrue( scaledPos.x==0.0 && scaledPos.y==0.0, @"Bezier origin is incorrect %f, %f", scaledPos.x, scaledPos.y );
	STAssertTrue( scaledSize.width==100.0 && scaledSize.height==100.0, @"Bezier size is incorrect %f, %f", scaledSize.width, scaledSize.height );	
}

@end
