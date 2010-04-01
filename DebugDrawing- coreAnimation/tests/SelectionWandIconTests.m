//
//  SelectionWandIconTests.m
//  DebugDrawing
//
//  Created by steve hooley on 20/10/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//
#import "SelectionWandIcon.h"
#import "ToolBarController.h"
#import "CALayerStarView.h"
#import "SelectionWand.h"

@interface SelectionWandIconTests : SenTestCase {
	
	SelectionWandIcon	*_selWandIcn;
	OCMockObject		*_mockToolbarCntrl;
	OCMockObject		*_mockTool;
}

@end

@implementation SelectionWandIconTests

- (void)setUp {
	
	_mockToolbarCntrl = [MOCK(ToolBarController) retain];
	_mockTool = [MOCK(SelectionWand) retain];
	_selWandIcn = [[SelectionWandIcon alloc] initWithToolBarController:(id)_mockToolbarCntrl domainTool:(id)_mockTool];
}

- (void)tearDown {
	
	[_selWandIcn release];
	[_mockTool release];
	[_mockToolbarCntrl release];
}

// gee the is difficult to test, have to mock out everything in the superclass as well
- (void)test_mouseDownEventInStarView {
	// - (void)_mouseDownEvent:(NSEvent *)event inStarView:(CALayerStarView *)view
	// - (void)mouseUpAtPoint:(NSPoint)pt
	
	OCMockObject *mockEvent = MOCK(NSEvent);
	OCMockObject *mockView = MOCK(CALayerStarView);
	OCMockObject *mockWindow = MOCK(NSWindow);

	[[[mockEvent stub] andReturnValue:OCMOCK_VALUE(NSZeroPoint)] locationInWindow];
	[[[mockEvent expect] andReturnUIntValue:0] modifierFlags];
	
	[[[_mockToolbarCntrl stub] andReturnValue:OCMOCK_VALUE(NSZeroPoint)] eventPtToViewPoint:NSZeroPoint];
	[[[_mockToolbarCntrl stub] andReturnValue:OCMOCK_VALUE(CGPointZero)] eventPointToContentPoint:NSZeroPoint];
	[[[_mockToolbarCntrl stub] andReturnValue:OCMOCK_VALUE(CGPointZero)] viewPointToScenePoint:NSZeroPoint];

	[[_mockToolbarCntrl expect] addWidgetToView:_selWandIcn];
	[[_mockToolbarCntrl expect] removeWidgetFromView:_selWandIcn];

	[[[_mockTool expect] andReturn:nil] nodeUnderPoint:NSZeroPoint];	
	[[_mockTool expect] mouseDownInEmptySpaceModifyingExistingSelection:NO];
	[[_mockTool expect] beginModifyingSelectionWithMarquee];
	[[_mockTool expect] endModifyingSelectionWithMarquee];
	[[_mockTool expect] setMarqueeSelectionBounds:CGRectMake(-1,-1,4,4)]; // errrr, random!

	[[[mockView expect] andReturn:mockWindow] window];
	
	NSEvent *mockEvent1 = [NSEvent mouseEventWithType:NSLeftMouseDragged location:NSZeroPoint modifierFlags:0 timestamp:0 windowNumber:0 context:nil eventNumber:0 clickCount:1 pressure:0];
	NSEvent *mockEvent3 = [NSEvent mouseEventWithType:NSLeftMouseUp location:NSZeroPoint modifierFlags:0 timestamp:0 windowNumber:0 context:nil eventNumber:0 clickCount:1 pressure:0];
	
	[[[mockWindow expect] andReturn:mockEvent1] nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask) untilDate:OCMOCK_ANY inMode:NSEventTrackingRunLoopMode dequeue:YES];
	[[[mockWindow expect] andReturn:mockEvent3] nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask) untilDate:OCMOCK_ANY inMode:NSEventTrackingRunLoopMode dequeue:YES];

	[_selWandIcn _mouseDownEvent:(id)mockEvent inStarView:(id)mockView];
	[_selWandIcn mouseUpAtPoint:NSZeroPoint];
	
	[_mockToolbarCntrl expect];
	[_mockTool verify];
	[mockView verify];
	[mockWindow verify];
}


@end
