//
//  ToolLayerTests.m
//  DebugDrawing
//
//  Created by steve hooley on 28/07/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//
#import "ToolLayer.h"

@interface ToolLayerTests : SenTestCase {
	
	ToolLayer *_toolLayer;
}

@end


@implementation ToolLayerTests

- (void)setUp {
	_toolLayer = [[ToolLayer layer] retain];
}

- (void)tearDown {
	[_toolLayer release];
}

- (void)testHmm {
	
}
@end
