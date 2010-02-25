//
//  ToolBarControllerTests.m
//  DebugDrawing
//
//  Created by Steven Hooley on 1/11/09.
//  Copyright 2009 Bestbefore. All rights reserved.
//

#import "ToolBarController.h"
#import "CALayerStarView.h"
#import "StarScene.h"
#import "WidgetDisplay.h"
#import "HitTester.h"

#import "Tool.h"
#import "PanTool.h"
#import "ZoomTool.h"
#import "EditingWindow.h"
#import "EditingViewController.h"
#import "SelectionWand.h"

@interface ToolBarControllerTests : SenTestCase {
	
	ToolBarController	*_tBarController;
	
	OCMockObject		*_mockWindow;
	OCMockObject		*_mockViewController;
}

@end

@implementation ToolBarControllerTests

- (void)setUp {

	_mockWindow = [MOCK(EditingWindow) retain];
	_mockViewController = [MOCK(EditingViewController) retain];
	
	_tBarController = [[ToolBarController alloc] initWithWindow:(id)_mockWindow targetViewController:(id)_mockViewController];
}

- (void)tearDown {
	
	[_tBarController release];
	
	[_mockWindow release];
	[_mockViewController release];
}

- (void)testAddTools {
	// - (void)addTools:(NSMutableDictionary *)tools
	
	OCMockObject *panTool = MOCK(PanTool);
	OCMockObject *zoomTool = MOCK(ZoomTool);
	
	[[[panTool stub] andReturn:@"PanTool"] classAsString];
	[[[panTool stub] andReturn:@"PanTool"] identifier];

	[[[zoomTool stub] andReturn:@"ZoomTool"] classAsString];
	[[[zoomTool stub] andReturn:@"ZoomTool"] identifier];
	
	NSArray *viewTools = [[NSArray arrayWithObjects:
				   panTool,
				   zoomTool,
				   nil] retain];

	[_tBarController addTools:viewTools];
	
	NSArray *allKeys = [_tBarController toolKeys];
	STAssertTrue([allKeys count]==2, @"doh");
	STAssertTrue([allKeys containsObjectIdenticalTo:@"PanTool"], @"doh");
	STAssertTrue([allKeys containsObjectIdenticalTo:@"ZoomTool"], @"doh");

	[viewTools release];
}

- (void)testSetActiveTool {
	// - (void)setActiveToolRepresentation:(NSObject<EditingToolIconProtocol> *)value

	OCMockObject *mockTool1 = MOCKFORPROTOCOL(EditingToolIconProtocol);
	OCMockObject *mockTool2 = MOCKFORPROTOCOL(EditingToolIconProtocol);
	
	[[mockTool1 expect] toolWillBecomeActive]; 
	
	[_tBarController setActiveToolRepresentation:(id)mockTool1];
	STAssertTrue(_tBarController.activeToolRepresentation==(id)mockTool1, @"dfoh");
	[mockTool1 verify];

	[[mockTool1 expect] toolWillBecomeUnActive]; 
	[[mockTool2 expect] toolWillBecomeActive]; 

	[_tBarController setActiveToolRepresentation:(id)mockTool2];
	
	[mockTool1 verify];
	[mockTool2 verify];
	
	[[mockTool2 expect] toolWillBecomeUnActive]; 
	[_tBarController setActiveToolRepresentation:nil];
	
	[mockTool2 verify];
}

- (void)testEventPtToViewPoint {
	//- (NSPoint)eventPtToViewPoint:(NSPoint)pt
	
	[[_mockViewController expect] eventPtToViewPoint:NSZeroPoint];

	[_tBarController eventPtToViewPoint:NSZeroPoint];
	[_mockViewController verify];
}

- (void)testEventPointToContentPoint {
	//- (CGPoint)eventPointToContentPoint:(NSPoint)pt
	
	[[_mockViewController expect] eventPointToContentPoint:NSZeroPoint];

	[_tBarController eventPointToContentPoint:NSZeroPoint];
	[_mockViewController verify];
}

- (void)testviewPointToScenePoint {
	// - (CGPoint)viewPointToScenePoint:(NSPoint)pt
	
	[[_mockViewController expect] viewPointToScenePoint:NSZeroPoint];
	
	[_tBarController viewPointToScenePoint:NSZeroPoint];
	[_mockViewController verify];
}

- (void)testAddToolbarToWindow {
	// - (void)addToolbarToWindow
	
	// need to fake the default tool
	OCMockObject *selectTool = MOCK(SelectionWand);	
	[[[selectTool stub] andReturn:@"SelectionWand"] classAsString];
	[[[selectTool stub] andReturn:@"SKTSelectTool"] identifier];
	NSArray *tools = [[NSArray arrayWithObjects: selectTool, nil] retain];
	[_tBarController addTools:tools];

	[[_mockWindow expect] setToolbar:OCMOCK_ANY];
	[_tBarController addToolbarToWindow];
	
	[_mockWindow verify];
	
	[_tBarController setActiveToolRepresentation:nil];

	[tools release];	
}

- (void)testShiftAlt {
	// - (void)shift:(BOOL)value
	// - (void)alt:(BOOL)value

	OCMockObject *selectTool = MOCK(SelectionWand);
	OCMockObject *panTool = MOCK(PanTool);
	OCMockObject *zoomTool = MOCK(ZoomTool);
	
	[[[panTool stub] andReturn:@"PanTool"] classAsString];
	[[[zoomTool stub] andReturn:@"ZoomTool"] classAsString];
	[[[selectTool stub] andReturn:@"SelectionWand"] classAsString];

	[[[panTool stub] andReturn:@"SKTPanTool"] identifier];
	[[[zoomTool stub] andReturn:@"SKTZoomTool"] identifier];
	[[[selectTool stub] andReturn:@"SKTSelectTool"] identifier];
	
	NSArray *tools = [NSArray arrayWithObjects: selectTool, panTool, zoomTool, nil];
	[_tBarController addTools:tools];
	
	[_tBarController swapInTool:@"SKTSelectTool"];

	[_tBarController shift:YES];
	STAssertTrue( [[_tBarController.activeToolRepresentation classAsString] isEqualToString:@"SelectionWandIcon"], @"doh %@", [_tBarController.activeToolRepresentation classAsString]);
	
	[_tBarController alt:YES];
	STAssertTrue( [[_tBarController.activeToolRepresentation classAsString] isEqualToString:@"ZoomToolIcon"], @"ddoh %@", [_tBarController.activeToolRepresentation classAsString]);

	[_tBarController shift:NO];
	STAssertTrue( [[_tBarController.activeToolRepresentation classAsString] isEqualToString:@"PanToolIcon"], @"doh %@", [_tBarController.activeToolRepresentation classAsString]);

	[_tBarController alt:NO];
	STAssertTrue( [[_tBarController.activeToolRepresentation classAsString] isEqualToString:@"SelectionWandIcon"], @"doh %@", [_tBarController.activeToolRepresentation classAsString]);
	
	[_tBarController setActiveToolRepresentation:nil];
}

@end
