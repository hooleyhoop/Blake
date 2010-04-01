//
//  ToolViewControllerTests.m
//  DebugDrawing
//
//  Created by steve hooley on 20/10/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//
#import "ToolViewController.h"
#import "ToolBarController.h"
#import "CALayerStarView.h"

@interface ToolViewControllerTests : SenTestCase {
	
	ToolViewController	*_toolIconViewCntrl;
	OCMockObject		*_mockToolbarCntrl;
	OCMockObject		*_mockTool;
}

@end

@implementation ToolViewControllerTests

- (void)setUp {

	_mockToolbarCntrl = [MOCK(ToolBarController) retain];
	_mockTool = [MOCKFORPROTOCOL(EditingToolProtocol) retain];
	_toolIconViewCntrl = [[ToolViewController alloc] initWithToolBarController:(id)_mockToolbarCntrl domainTool:(id)_mockTool];
}

- (void)tearDown {

	[_toolIconViewCntrl release];
	[_mockToolbarCntrl release];
	[_mockTool release];
}

#pragma mark Protocol Tests
- (void)testSetUpToolbarItem {
	// - (void)setUpToolbarItem:(NSToolbarItem *)item
	
	OCMockObject *item = MOCK(NSToolbarItem);
	[[item expect] setToolTip:OCMOCK_ANY];
	[[item expect] setLabel:OCMOCK_ANY];
	[[item expect] setPaletteLabel:OCMOCK_ANY];
	[[item expect] setImage:OCMOCK_ANY];
	[[item expect] setTarget:_toolIconViewCntrl];
	[[item expect] setAction:@selector(selectToolAction:)];

	[_toolIconViewCntrl setUpToolbarItem:(id)item];
	
	[item verify];
}

- (void)testSelectToolAction {
	//- (IBAction)selectToolAction:(id)sender
	
	[[_mockToolbarCntrl expect] setActiveToolRepresentation:_toolIconViewCntrl];
	[_toolIconViewCntrl selectToolAction:nil];
	[_mockToolbarCntrl verify];
}

- (void)testToolWillBecomeActive {
	//- (void)toolWillBecomeActive

	[_toolIconViewCntrl toolWillBecomeActive];
}

- (void)testToolWillBecomeUnActive {
	//- (void)toolWillBecomeUnActive

	[_toolIconViewCntrl toolWillBecomeUnActive];
}

- (void)test_mouseDownEventInStarView {
	// - (void)_mouseDownEvent:(NSEvent *)event inStarView:(CALayerStarView *)view
	// - (void)mouseUpAtPoint:(NSPoint)pt
	
	OCMockObject *mockEvent = MOCK(NSEvent);
	OCMockObject *mockView = MOCK(CALayerStarView);
	
	[[[mockEvent stub] andReturnValue:OCMOCK_VALUE(NSZeroPoint)] locationInWindow];
	[[[_mockToolbarCntrl expect] andReturnValue:OCMOCK_VALUE(NSZeroPoint)] eventPtToViewPoint:NSZeroPoint];
	[[[_mockToolbarCntrl expect] andReturnValue:OCMOCK_VALUE(CGPointZero)] eventPointToContentPoint:NSZeroPoint];
			
	[_toolIconViewCntrl _mouseDownEvent:(id)mockEvent inStarView:(id)mockView];
	[_toolIconViewCntrl mouseUpAtPoint:NSZeroPoint];
	
	[_mockToolbarCntrl expect];
	[_mockTool verify];
}

//#pragma mark Tests
//- (CGRect)didDrawAt:(CGContextRef)cntx;
//- (void)_setupDrawing:(CGContextRef)cntx;
//- (void)_tearDownDrawing:(CGContextRef)cntx;
//
//- (void)setWidgetBounds:(CGRect)value;
//- (void)setWidgetOrigin:(CGPoint)value;
//
//- (CGRect)geometryRect;
//- (CGAffineTransform)transformMatrix;

@end
