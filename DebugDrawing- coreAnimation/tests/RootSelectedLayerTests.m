//
//  RootSelectedLayerTests.m
//  DebugDrawing
//
//  Created by steve hooley on 28/07/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "RootSelectedLayer.h"
#import "ColourUtilities.h"
#import "iAmTransformableProtocol.h"
#import "EditingViewController.h"
#import "CALayerStarView.h"
#import "Graphic.h"

@interface RootSelectedLayerTests : SenTestCase {
	
	RootSelectedLayer *_selectedLayer;
}

@end


@implementation RootSelectedLayerTests

- (void)setUp {

	_selectedLayer = [[RootSelectedLayer layer] retain];
}

- (void)tearDown {

	[_selectedLayer release];
}

- (void)testDrawInContext {
	// - (void)drawInContext:(CGContextRef)ctx {
	
	size_t components = 4;
	size_t bitsPerComponent = 8;
	size_t bytesPerRow = (20 * bitsPerComponent * components + 7)/8;
	
	// we have to manage the memory so we can iterate thru it
	size_t dataLength = bytesPerRow * 20;
	UInt32 *bitmap = malloc( dataLength );
	memset( bitmap, 0, dataLength );
	
	CGContextRef context = CGBitmapContextCreate (
												  bitmap,
												  20, 20,
												  bitsPerComponent,
												  bytesPerRow, // bytes per row
												  [ColourUtilities genericRGBSpace],
												  kCGImageAlphaPremultipliedFirst
												  );
	
	[_selectedLayer drawInContext:context];
	
	CGContextRelease( context );
	free(bitmap);
}

- (void)testWasAdded {
	// - (void)wasAdded
	// - (void)wasRemoved

	OCMockObject *mockDelegate = MOCKFORPROTOCOL(iAmGraphicNodeProtocol);
	OCMockObject *mockViewController = MOCK(EditingViewController);
	OCMockObject *mockView = MOCK(CALayerStarView);
	
	[_selectedLayer setContainerView:(id)mockView];
	[[[mockView stub] andReturn:mockViewController] viewController];
	
	[_selectedLayer setDelegate:mockDelegate];

	[[mockViewController expect] observeZoomMatrix:_selectedLayer withContext:@"RootSelectedLayer"];
	[[mockDelegate expect] addObserver:_selectedLayer forKeyPath:@"concatenatedMatrixNeedsRecalculating" options:0 context:@"RootSelectedLayer"];
	[[mockDelegate expect] addObserver:_selectedLayer forKeyPath:@"geometryRect" options:0 context: @"RootSelectedLayer"];

	[[[mockViewController expect] andReturnValue:OCMOCK_VALUE(CGAffineTransformIdentity)] zoomMatrix];
	[[[mockDelegate expect] andReturnValue:OCMOCK_VALUE(CGAffineTransformIdentity)] concatenatedMatrix];
	[[mockDelegate expect] enforceConsistentState];
	[[[mockDelegate expect] andReturnValue:OCMOCK_VALUE(CGRectZero)] geometryRect];

	[_selectedLayer wasAdded];
	[mockDelegate verify];
	[mockViewController verify];
	
	[[mockViewController expect] removeZoomMatrixObserver:_selectedLayer];
	[[mockDelegate expect] removeObserver:_selectedLayer forKeyPath:@"concatenatedMatrixNeedsRecalculating"];
	[[mockDelegate expect] removeObserver:_selectedLayer forKeyPath:@"geometryRect"];
	[_selectedLayer wasRemoved];
	[mockViewController verify];
	[mockDelegate verify];
}

@end
