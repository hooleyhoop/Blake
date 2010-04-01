//
//  ZoomToolTests.m
//  DebugDrawing
//
//  Created by steve hooley on 20/10/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//
#import "ZoomTool.h"


@interface ZoomToolTests : SenTestCase {
	
	ZoomTool		*_zoomTool;
	NSUInteger		_didZoomCount;
}

@end

@implementation ZoomToolTests

// callback
- (void)zoomFrom:(NSPoint)pt1 to:(NSPoint)pt2 {
	_didZoomCount++;
}

- (void)setUp {
	
	_zoomTool = [[ZoomTool alloc] initWithTarget:(id)self];
}

- (void)tearDown {
	
	[_zoomTool release];
}

- (void)testIdentifier {
	// - (NSString *)identifier
	
	STAssertTrue( [[_zoomTool identifier] isEqualToString:@"SKTZoomTool"], @"erm %@", [_zoomTool identifier] );
}

- (void)testZoomFromTo {
	// - (void)zoomFrom:(NSPoint)pt1 to:(NSPoint)pt2
	
	[_zoomTool zoomFrom:NSZeroPoint to:NSZeroPoint];
	STAssertTrue(_didZoomCount==1, @"doh");
}

@end
