//
//  ZoomToolIconTests.m
//  DebugDrawing
//
//  Created by steve hooley on 20/10/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//
#import "ZoomToolIcon.h"
#import "ZoomTool.h"
#import "ToolBarController.h"
#import "CALayerStarView.h"

@interface ZoomToolIconTests : SenTestCase {
	
	ZoomToolIcon		*_zoomToolIcn;
	OCMockObject		*_mockToolbarCntrl;
	OCMockObject		*_mockTool;
}

@end


@implementation ZoomToolIconTests

- (void)setUp {
	
	_mockToolbarCntrl = [MOCK(ToolBarController) retain];
	_mockTool = [MOCK(ZoomTool) retain];
	_zoomToolIcn = [[ZoomToolIcon alloc] initWithToolBarController:(id)_mockToolbarCntrl domainTool:(id)_mockTool];
}

- (void)tearDown {
	
	[_zoomToolIcn release];
	[_mockTool release];
	[_mockToolbarCntrl release];
}

- (void)test_mouseDownEventInStarView {
	// - (void)_mouseDownEvent:(NSEvent *)event inStarView:(CALayerStarView *)view
	// - (void)mouseUpAtPoint:(NSPoint)pt
	
	OCMockObject *mockEvent = MOCK(NSEvent);
	OCMockObject *mockView = MOCK(CALayerStarView);
	OCMockObject *mockWindow = MOCK(NSWindow);

	[[[mockView expect] andReturn:mockWindow] window];

	[[[mockEvent stub] andReturnValue:OCMOCK_VALUE(NSZeroPoint)] locationInWindow];
	
	[[[_mockToolbarCntrl stub] andReturnValue:OCMOCK_VALUE(NSZeroPoint)] eventPtToViewPoint:NSZeroPoint];
	[[[_mockToolbarCntrl stub] andReturnValue:OCMOCK_VALUE(CGPointZero)] eventPointToContentPoint:NSZeroPoint];
	[[[_mockToolbarCntrl stub] andReturnValue:OCMOCK_VALUE(CGPointZero)] viewPointToScenePoint:NSZeroPoint];

	[[_mockToolbarCntrl expect] addWidgetToView:_zoomToolIcn];
	[[_mockToolbarCntrl expect] removeWidgetFromView:_zoomToolIcn];
	
	NSEvent *mockEvent1 = [NSEvent mouseEventWithType:NSLeftMouseDragged location:NSZeroPoint modifierFlags:0 timestamp:0 windowNumber:0 context:nil eventNumber:0 clickCount:1 pressure:0];
	NSEvent *mockEvent3 = [NSEvent mouseEventWithType:NSLeftMouseUp location:NSZeroPoint modifierFlags:0 timestamp:0 windowNumber:0 context:nil eventNumber:0 clickCount:1 pressure:0];
	[[[mockWindow expect] andReturn:mockEvent1] nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask) untilDate:OCMOCK_ANY inMode:NSEventTrackingRunLoopMode dequeue:YES];
	[[[mockWindow expect] andReturn:mockEvent3] nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask) untilDate:OCMOCK_ANY inMode:NSEventTrackingRunLoopMode dequeue:YES];
	
	[[_mockTool expect] zoomFrom:NSZeroPoint to:NSZeroPoint];

	// do it
	[_zoomToolIcn _mouseDownEvent:(id)mockEvent inStarView:(id)mockView];
	[_zoomToolIcn mouseUpAtPoint:NSZeroPoint];
	
	// verify
	[_mockTool verify];
	[mockWindow verify];
	[_mockToolbarCntrl verify];
	[mockView verify];
}

@end
