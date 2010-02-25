//
//  HitTestContextTests.m
//  DebugDrawing
//
//  Created by steve hooley on 21/07/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "HitTestContext.h"


@interface HitTestContextTests : SenTestCase {
	
	HitTestContext *_hitTest;
}

@end


@implementation HitTestContextTests

- (void)setUp {
}

- (void)tearDown {
}


- (void)testSetOrigin {
	//- (void)setOrigin:(CGPoint)value
	
	_hitTest = [[HitTestContext alloc] initWithContextSize:CGSizeMake(1,1)];
	CGPoint origin = CGPointMake(-10, -10);
	[_hitTest setOrigin:origin];
	CGContextRef offScreenCntx = [_hitTest offScreenCntx];
	CGPoint newPos1 = CGPointApplyAffineTransform( CGPointMake(0,0), CGContextGetCTM(offScreenCntx) );
	
	STAssertTrue( nearlyEqualCGPoints( newPos1, CGPointMake(10, 10) ), @"%@", NSStringWithCGPoint(newPos1)) ;

	STAssertTrue([_hitTest contextIsClean], @"context Isnt clean");
	[_hitTest cleanUpHitTesting];
	[_hitTest release];
}

- (void)testHitTestContextAt {
	//+ (id)hitTestContextAtPoint:(CGPoint)pt

	_hitTest = [HitTestContext hitTestContextAtPoint:CGPointMake( -10, -10 )];
	STAssertNotNil( _hitTest, @"bah" );
	
	STAssertTrue([_hitTest contextIsClean], @"context Isnt clean");

	// -- draw something
	CGContextSetRGBFillColor( [_hitTest offScreenCntx], 0.0f, 0.0f, 0.0f, 1.0f);
	CGContextFillRect( [_hitTest offScreenCntx], CGRectMake(-10, -10, 1, 1) );
	
	[_hitTest checkAndResetWithKey:@"rabbit"];
	STAssertTrue( [_hitTest countOfHitObjects]==1, @"doh %i", [_hitTest countOfHitObjects] );	
	STAssertTrue( [_hitTest containsKey:@"rabbit"], @"doh" );	
	
	STAssertTrue( [_hitTest contextIsClean], @"context Isnt clean" );

	[_hitTest cleanUpHitTesting];
}

- (void)testHitTestContextWithRect {
	//+ (id)hitTestContextWithRect:(CGRect)cntxRect

	_hitTest = [HitTestContext hitTestContextWithRect:CGRectMake( 0, 0, 10, 10 )];
	STAssertNotNil( _hitTest, @"bah" );

	STAssertTrue([_hitTest contextIsClean], @"context Isnt clean");

	// -- draw something
	CGContextSetRGBFillColor( [_hitTest offScreenCntx], 0.0f, 0.0f, 0.0f, 1.0f);
	CGContextFillRect( [_hitTest offScreenCntx], CGRectMake(9, 9, 2, 2) );
	
	[_hitTest checkAndResetWithKey:@"rabbit"];
	STAssertTrue( [_hitTest countOfHitObjects]==1, @"doh %i", [_hitTest countOfHitObjects]);	
	STAssertTrue([_hitTest contextIsClean], @"context Isnt clean");

	// -- draw something else
	CGContextSetRGBFillColor( [_hitTest offScreenCntx], 0.0f, 0.0f, 0.0f, 1.0f);
	CGContextFillRect( [_hitTest offScreenCntx], CGRectMake(11, 11, 2, 2) );
	[_hitTest checkAndResetWithKey:@"bobbb"];
	STAssertTrue( [_hitTest countOfHitObjects]==1, @"doh %i", [_hitTest countOfHitObjects]);	
	STAssertTrue([_hitTest contextIsClean], @"context Isnt clean");
	
	// -- draw something else
	CGContextSetRGBFillColor( [_hitTest offScreenCntx], 0.0f, 0.0f, 0.0f, 1.0f);
	CGContextFillRect( [_hitTest offScreenCntx], CGRectMake(1, 1, 2, 2) );
	[_hitTest checkAndResetWithKey:@"grr"];
	STAssertTrue( [_hitTest countOfHitObjects]==2, @"doh %i", [_hitTest countOfHitObjects]);	
	STAssertTrue([_hitTest contextIsClean], @"context Isnt clean");
	
	[_hitTest cleanUpHitTesting];
}

//TODO: I dont understand this at all - why is it negative of what you would expect? */
- (void)testRectIntersectsRect {
	// - (BOOL)rectIntersectsRect:(CGRect)rect
	
	_hitTest = [HitTestContext hitTestContextAtPoint:CGPointMake( 10, 10 )];
	STAssertTrue( [_hitTest rectIntersectsRect:CGRectMake(-10, -10, 2, 2)], @"doh");
	STAssertFalse( [_hitTest rectIntersectsRect:CGRectMake(10, 10, 2, 2)], @"doh");

	[_hitTest cleanUpHitTesting];	
}

- (void)testGetColourAtPixel {
	// - (void)getColourAtPixelAndClean:(CGFloat *)cols
	
	_hitTest = [HitTestContext hitTestContextAtPoint:CGPointMake( 0, 0 )];
	[_hitTest cleanContext];
	
	UInt8 pixelColours[4];
	[_hitTest getColourAtPixelAndClean:pixelColours];
	UInt8 red = pixelColours[0];
	UInt8 green = pixelColours[1];
	UInt8 blue = pixelColours[2];
	UInt8 alpha = pixelColours[3];
	
	// -- draw something
	CGColorRef redCol = CGColorCreateGenericRGB( 1.0f, 0.0f, 0.0f, 1.0f );
	CGContextSetFillColorWithColor( [_hitTest offScreenCntx], redCol );
	CGContextFillRect( [_hitTest offScreenCntx], CGRectMake( -1, -1, 2, 2 ) );
	
	[_hitTest getColourAtPixelAndClean:pixelColours];
	
	 red = pixelColours[0];
	 green = pixelColours[1];
	 blue = pixelColours[2];
	 alpha = pixelColours[3];
	
	STAssertTrue( red==255, @"doh %i",  red );
	STAssertTrue( green==0, @"doh %i", green );
	STAssertTrue( blue==0, @"doh %i", blue );
	STAssertTrue( alpha==255, @"doh %i", alpha );
	
	[_hitTest cleanUpHitTesting];
	
	CGColorRelease(redCol);
}

- (void)testReproducibleVersion {
	
	//create
	NSUInteger arbitraryPixSize = 10;
	size_t components = 4;
	size_t bitsPerComponent = 8;
	size_t bytesPerRow = (arbitraryPixSize * bitsPerComponent * components + 7)/8;
	size_t dataLength = bytesPerRow * arbitraryPixSize;
	UInt32 *bitmap = malloc( dataLength );
	memset( bitmap, 0, dataLength );
	
	CGColorSpaceRef colSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
	
	CGContextRef context = CGBitmapContextCreate (
												  bitmap,
												  arbitraryPixSize, arbitraryPixSize,
												  bitsPerComponent,
												  bytesPerRow,
												  colSpace,
												  kCGImageAlphaPremultipliedFirst
												  );
	
	CGContextSetFillColorSpace( context, colSpace );
	CGContextSetStrokeColorSpace( context, colSpace );

	// -- draw something
	//	CGContextSetRGBFillColor( context, 1.0f, 0.0f, 0.0f, 1.0f );
	CGColorRef redCol = CGColorCreateGenericRGB( 1.0f, 0.0f, 0.0f, 1.0f );
	CGContextSetFillColorWithColor( context, redCol );
	CGContextFillRect( context, CGRectMake( 0, 0, arbitraryPixSize, arbitraryPixSize ) );
	
	// test the first pixel
	UInt8 *baseAddr = (UInt8 *)CGBitmapContextGetData(context);
	UInt8 alpha = baseAddr[0]; //255
	UInt8 red = baseAddr[1];	//228
	UInt8 green = baseAddr[2];	//29
	UInt8 blue = baseAddr[3];	//29
	
	CGColorRelease(redCol);
	CGContextRelease(context);
	CGColorSpaceRelease(colSpace);
	free(bitmap);
}

@end
