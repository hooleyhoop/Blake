//
//  StarTests.m
//  DebugDrawing
//
//  Created by steve hooley on 23/09/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "Star.h"
#import "ColourUtilities.h"

static id lastDrawnOb;
static NSRect lastDrawnRect;

#import "DrawDestination_protocol.h"

@interface StarTests : SenTestCase { // <DrawDestination_protocol>
	
	Star *_testStar;
}

//june09- (void)graphic:(id)obj drewAt:(NSRect)dst;

@end


@implementation StarTests

//june09- (void)graphic:(id)obj drewAt:(NSRect)dst {
	
//june09	NSParameterAssert(obj!=nil);
//june09	lastDrawnOb = obj;
//june09	lastDrawnRect = dst;
//june09}

- (void)setUp {

	_testStar = [Star new];
}

- (void)tearDown {

	[_testStar release];
}

- (void)testSetPhysicalBounds {
	// - (void)setPhysicalBounds:(NSRect)val

//june09	_testStar.DEBUG_drawingDestination = self;

	NSRect srcRect = NSMakeRect(0,0,2,2);
//june09	[_testStar setGeometryRect:srcRect];
//june09	[testStar setScale:2.0];
//june09	[testStar setPosition:NSMakePoint(1,1)];
//june09	[testStar setAnchorPt:NSMakePoint( 1, 1 )];
//june09    [testStar enforceConsistentState];

//june09	NSRect targetRect = NSMakeRect(-1,-1,4,4);
//june09	STAssertTrue(NSEqualRects([testStar transformedGeometryRectBoundingBox],targetRect), @"eh? %@", NSStringFromRect([testStar transformedGeometryRectBoundingBox]) );

//june09	[testStar drawWithHint:SKTGraphicNormalFill];
//june09	STAssertTrue( NSEqualRects( lastDrawnRect, targetRect ) , @"%@", NSStringFromRect(lastDrawnRect));
//june09	STAssertTrue( NSEqualRects( [testStar didDrawAt], targetRect ) , @"%@", NSStringFromRect([testStar didDrawAt]));
		
	// try shortening the width by one
//june09	targetRect = NSMakeRect( -1, -1, 3, 4 ); // -0.5, 0, 1.5, 2.0
//june09	[testStar setPhysicalBounds:targetRect];
//june09	[testStar enforceConsistentState];

//june09	STAssertTrue(NSEqualRects([testStar transformedGeometryRectBoundingBox], targetRect), @"eh? %@", NSStringFromRect([testStar transformedGeometryRectBoundingBox]) );
//june09	[testStar drawWithHint:SKTGraphicNormalFill];
//june09	STAssertTrue( NSEqualRects( lastDrawnRect, targetRect ) , @"%@", NSStringFromRect(lastDrawnRect));
//june09	STAssertTrue( NSEqualRects( [testStar didDrawAt], targetRect ) , @"%@", NSStringFromRect([testStar didDrawAt]));
		
	// try shortening the height by one
//june09	targetRect = NSMakeRect( -1, -1, 3, 3 );
//june09	[testStar setPhysicalBounds:targetRect];
//june09	[testStar enforceConsistentState];

//june09	STAssertTrue(NSEqualRects([testStar transformedGeometryRectBoundingBox], targetRect), @"eh? %@", NSStringFromRect([testStar transformedGeometryRectBoundingBox]) );
//june09	[testStar drawWithHint:SKTGraphicNormalFill];
//june09	STAssertTrue( NSEqualRects( lastDrawnRect, targetRect ) , @"%@", NSStringFromRect(lastDrawnRect));
//june09	STAssertTrue( NSEqualRects( [testStar didDrawAt], targetRect ) , @"%@", NSStringFromRect([testStar didDrawAt]));
		
	// try moving origin.x
//june09	targetRect = NSMakeRect( 0, -1, 3, 3 );
//june09	[testStar setPhysicalBounds:targetRect];
//june09	[testStar enforceConsistentState];
	
//june09	[testStar drawWithHint:SKTGraphicNormalFill];
//june09	STAssertTrue(NSEqualRects([testStar transformedGeometryRectBoundingBox], targetRect), @"eh? %@", NSStringFromRect([testStar transformedGeometryRectBoundingBox]) );
//june09	STAssertTrue( NSEqualRects( lastDrawnRect, targetRect ) , @"%@", NSStringFromRect(lastDrawnRect));
//june09	STAssertTrue( NSEqualRects( [testStar didDrawAt], targetRect ) , @"%@", NSStringFromRect([testStar didDrawAt]));

	// try moving origin.y
//june09	targetRect = NSMakeRect( 0, 0, 3, 3 );
//june09	[testStar setPhysicalBounds:targetRect];
//june09	[testStar enforceConsistentState];

//june09	STAssertTrue(NSEqualRects([testStar transformedGeometryRectBoundingBox], targetRect), @"eh? %@", NSStringFromRect([testStar transformedGeometryRectBoundingBox]) );
//june09	[testStar drawWithHint:SKTGraphicNormalFill];
//june09	STAssertTrue( NSEqualRects( lastDrawnRect, targetRect ) , @"%@", NSStringFromRect(lastDrawnRect));
//june09	STAssertTrue( NSEqualRects( [testStar didDrawAt], targetRect ) , @"%@", NSStringFromRect([testStar didDrawAt]));
}

- (void)testDraw {
	// - (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx

	size_t components = 4;
	size_t bitsPerComponent = 8;
	size_t bytesPerRow = (20 * bitsPerComponent * components + 7)/8;
	size_t dataLength = bytesPerRow * 20;
	UInt32 *bitmap = malloc( dataLength );
	memset( bitmap, 0, dataLength );
	
	CGContextRef cntx = CGBitmapContextCreate (
											   bitmap,
											   20, 20,
											   bitsPerComponent,
											   bytesPerRow, // bytes per row
											   [ColourUtilities genericRGBSpace],
											   kCGImageAlphaPremultipliedFirst
											   );

	[_testStar drawLayer:nil inContext:cntx];
	
//june09	testStar.DEBUG_drawingDestination = self;
	
 //june09   NSRect srcRect = NSMakeRect(0,0,1,1);
//june09    [testStar setGeometryRect:srcRect];
//june09    [testStar setScale:1.0];
 //june09   [testStar setPosition:NSMakePoint(10,10)];
 //june09   [testStar setAnchorPt:NSMakePoint(0,0)];
//june09	[testStar enforceConsistentState];
//june09	[testStar drawWithHint:SKTGraphicNormalFill];
	
//june09	STAssertTrue( lastDrawnOb==testStar, @"oops %@", lastDrawnOb);
//june09	STAssertTrue( NSEqualRects( lastDrawnRect, NSMakeRect(10,10,1,1) ) , @"%@", NSStringFromRect(lastDrawnRect));
	
 //june09   [testStar setAnchorPt:NSMakePoint(1,1)];
//june09	[testStar enforceConsistentState];
//june09	[testStar drawWithHint:SKTGraphicNormalFill];
//june09	STAssertTrue( NSEqualRects( lastDrawnRect, NSMakeRect(9,9,1,1) ) , @"%@", NSStringFromRect(lastDrawnRect));
	
 //june09   [testStar setScale:2.0];
//june09	[testStar enforceConsistentState];
//june09	[testStar drawWithHint:SKTGraphicNormalFill];
//june09	STAssertTrue( NSEqualRects( lastDrawnRect, NSMakeRect(8,8,2,2) ) , @"%@", NSStringFromRect(lastDrawnRect));
}

@end
