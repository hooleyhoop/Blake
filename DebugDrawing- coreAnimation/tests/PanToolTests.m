//
//  PanToolTests.m
//  DebugDrawing
//
//  Created by steve hooley on 20/10/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//
#import "PanTool.h"

@interface PanToolTests : SenTestCase {
	
	PanTool			*_panTool;
	
	NSUInteger		_didPanCount;
}

@end


@implementation PanToolTests

// callback
- (void)panByX:(CGFloat)xVal y:(CGFloat)yVal {
	_didPanCount++;
}


- (void)setUp {
	
	_panTool = [[PanTool alloc] initWithTarget:(id)self];
}

- (void)tearDown {
	
	[_panTool release];
}

- (void)testIdentifier {
	// - (NSString *)identifier
	
	STAssertTrue( [[_panTool identifier] isEqualToString:@"SKTPanTool"], @"erm %@", [_panTool identifier] );
}

- (void)testPanByXy {
// - (void)panByX:(CGFloat)xVal y:(CGFloat)yVal

	[_panTool panByX:1 y:2];
	STAssertTrue(_didPanCount==1, @"doh");
}

@end
