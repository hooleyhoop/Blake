//
//  PanToolIconTests.m
//  DebugDrawing
//
//  Created by steve hooley on 20/10/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//
#import "PanToolIcon.h"
#import "PanTool.h"
#import "ToolBarController.h"
#import "CALayerStarView.h"

@interface PanToolIconTests : SenTestCase {

	PanToolIcon			*_panToolIcn;
	OCMockObject		*_mockToolbarCntrl;
	OCMockObject		*_mockTool;
}

@end

@implementation PanToolIconTests

- (void)setUp {

	_mockToolbarCntrl = [MOCK(ToolBarController) retain];
	_mockTool = [MOCK(PanTool) retain];
	_panToolIcn = [[PanToolIcon alloc] initWithToolBarController:(id)_mockToolbarCntrl domainTool:(id)_mockTool];
}

- (void)tearDown {
	
	[_panToolIcn release];
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
	
	[[_mockTool expect] panByX:0 y:0];
	
	[[_mockToolbarCntrl expect] addWidgetToView:_panToolIcn];
	[[_mockToolbarCntrl expect] removeWidgetFromView:_panToolIcn];
	
	NSEvent *mockEvent1 = [NSEvent mouseEventWithType:NSLeftMouseDragged location:NSZeroPoint modifierFlags:0 timestamp:0 windowNumber:0 context:nil eventNumber:0 clickCount:1 pressure:0];
	NSEvent *mockEvent3 = [NSEvent mouseEventWithType:NSLeftMouseUp location:NSZeroPoint modifierFlags:0 timestamp:0 windowNumber:0 context:nil eventNumber:0 clickCount:1 pressure:0];
	[[[mockWindow expect] andReturn:mockEvent1] nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask) untilDate:OCMOCK_ANY inMode:NSEventTrackingRunLoopMode dequeue:YES];
	[[[mockWindow expect] andReturn:mockEvent3] nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask) untilDate:OCMOCK_ANY inMode:NSEventTrackingRunLoopMode dequeue:YES];
	
	// do it
	[_panToolIcn _mouseDownEvent:(id)mockEvent inStarView:(id)mockView];
	[_panToolIcn mouseUpAtPoint:NSZeroPoint];
	
	// verify
	[mockWindow verify];
	[_mockToolbarCntrl verify];
	[_mockTool verify];
	[mockEvent verify];
}

@end
