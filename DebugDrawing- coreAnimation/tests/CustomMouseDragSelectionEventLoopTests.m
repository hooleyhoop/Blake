//
//  CustomMouseDragSelectionEventLoopTests.m
//  DebugDrawing
//
//  Created by steve hooley on 07/08/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "CustomMouseDragSelectionEventLoop.h"
#import "CALayerStarView.h"


@interface CustomMouseDragSelectionEventLoopTests : SenTestCase {
	
	OCMockObject						*_mockWindow;
	CustomMouseDragSelectionEventLoop	*_mouseDragLoop;
	NSDictionary						*_dataDict;
}

@end

static NSUInteger _callBackWasCalledCount = 0;

@implementation CustomMouseDragSelectionEventLoopTests

- (void)setUp {
	
	_mockWindow = [[OCMockObject mockForClass:[NSWindow class]] retain];
	_mouseDragLoop = [[CustomMouseDragSelectionEventLoop eventLoopWithWindow:(id)_mockWindow] retain];
	
	_dataDict = [[NSDictionary dictionaryWithObjectsAndKeys: _mouseDragLoop, @"eventLoop", nil] retain];

}

- (void)tearDown {
	
	[_dataDict release];
	[_mouseDragLoop release];
	[_mockWindow release];
}

- (void)_loopCallback:(NSDictionary *)data {
	
	NSParameterAssert( data==_dataDict );

	_callBackWasCalledCount++;
	
	NSPoint piv = [_mouseDragLoop eventPt];
	
	if(_callBackWasCalledCount==1)
		STAssertTrue( nearlyEqualNSPoints( piv, NSMakePoint(15,15) ), @"should always loop first time");
	else if(_callBackWasCalledCount==2)
		STAssertTrue( nearlyEqualNSPoints( piv, NSMakePoint(100,150) ), @"should always loop first time");
	else
		[NSException raise:@"we shouldnt loop more than twice" format:@"ddd"];
}

- (void)testMousePointInView {
	// - (void)loopWithCallbackObject:(id)ob method:(SEL)callback data:(NSDictionary *)callbackData {
	// - (NSPoint)eventPt
	
	NSPoint pointInWindow1 = NSMakePoint(15, 15);
	NSPoint pointInWindow2 = NSMakePoint(100, 150);
	NSPoint pointInWindow3 = NSMakePoint(200, 300);

	NSEvent *mockEvent1 = [NSEvent mouseEventWithType:NSLeftMouseDragged location:pointInWindow1 modifierFlags:0 timestamp:0 windowNumber:0 context:nil eventNumber:0 clickCount:1 pressure:0];
	NSEvent *mockEvent2 = [NSEvent mouseEventWithType:NSLeftMouseDragged location:pointInWindow2 modifierFlags:0 timestamp:0 windowNumber:0 context:nil eventNumber:0 clickCount:1 pressure:0];
	NSEvent *mockEvent3 = [NSEvent mouseEventWithType:NSLeftMouseUp location:pointInWindow3 modifierFlags:0 timestamp:0 windowNumber:0 context:nil eventNumber:0 clickCount:1 pressure:0];

	// first loop
	[[[_mockWindow expect] andReturn:mockEvent1] nextEventMatchingMask:( NSLeftMouseDraggedMask | NSLeftMouseUpMask ) untilDate:OCMOCK_ANY inMode:NSEventTrackingRunLoopMode dequeue:YES];
	
	// second loop
	[[[_mockWindow expect] andReturn:mockEvent2] nextEventMatchingMask:( NSLeftMouseDraggedMask | NSLeftMouseUpMask ) untilDate:OCMOCK_ANY inMode:NSEventTrackingRunLoopMode dequeue:YES];

	// A mouse up should stop it looping
	// third loop
	[[[_mockWindow expect] andReturn:mockEvent3] nextEventMatchingMask:( NSLeftMouseDraggedMask | NSLeftMouseUpMask ) untilDate:OCMOCK_ANY inMode:NSEventTrackingRunLoopMode dequeue:YES];

	
	_callBackWasCalledCount = 0;
	[_mouseDragLoop loopWithCallbackObject:self method:@selector(_loopCallback:) data:_dataDict];

	STAssertTrue( _callBackWasCalledCount==2, @"should have been called twice %i", _callBackWasCalledCount );
	
	NSPoint piv = [_mouseDragLoop eventPt];
	STAssertTrue( nearlyEqualNSPoints( piv, pointInWindow3 ), @"should always loop first time");
}


@end
