//
//  StarLayerTests.m
//  DebugDrawing
//
//  Created by steve hooley on 28/07/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "StarLayer.h"

@interface StarLayerTests : SenTestCase {
	
	StarLayer *_starLayer;
}

@end


@implementation StarLayerTests

- (void)setUp {
	_starLayer = [[StarLayer layer] retain];
}

- (void)tearDown {
	[_starLayer release];
}

- (void)testAddSublayer {
	// - (void)addSublayer:(CALayer *)layer {

	OCMockObject *mockLayer = [OCMockObject mockForClass:[AbstractLayer class]];
	STAssertThrows([_starLayer addSublayer:(id)mockLayer], @"wha?");
}

@end
