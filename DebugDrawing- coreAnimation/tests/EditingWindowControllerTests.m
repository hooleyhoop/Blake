//
//  EditingWindowControllerTests.m
//  DebugDrawing
//
//  Created by steve hooley on 18/09/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "EditingWindowController.h"
#import "EditingWindow.h"
#import "EditingViewController.h"
#import "CALayerStarView.h"
#import "DomainContext.h"
#import "SwappedInIvar.h"
#import "Tool.h"
#import "ToolBarController.h"

@interface EditingWindowControllerTests : SenTestCase {
	
	EditingWindow *_stubWindow;
	OCMockObject *_mockWindow;
	EditingWindowController *_winController;
	
	_ROOT_OBJECT_ *_realBit;
	OCMockObject *_partialMockTest;
}

@end

@implementation EditingWindowControllerTests

static NSAutoreleasePool *pool;

- (void)setUp {
	

	_stubWindow = [[EditingWindow alloc] initWithContentRect:NSMakeRect(0,0,10,10) styleMask:NSTitledWindowMask backing:NSBackingStoreNonretained defer:YES];
//	[[NSApplication sharedApplication] _setVisibleInCache:NO forWindow:_stubWindow];
//	[[NSApplication sharedApplication] _removeWindowFromCache:_stubWindow];

	[_stubWindow setOneShot: YES];
	[_stubWindow setReleasedWhenClosed:YES];
	_mockWindow = [[OCMockObject partialMockForObject:_stubWindow] retain];
	_winController = [[EditingWindowController alloc] initWithWindow:(id)_mockWindow];
	
	_realBit = [[_ROOT_OBJECT_ alloc] init];
	_partialMockTest = [[OCMockObject partialMockForObject:_realBit] retain];
}

- (void)tearDown {

	[_realBit release];
	[_partialMockTest release];
	
	[_winController release];
	
//	[[NSApplication sharedApplication] _setVisibleInCache:NO forWindow:_stubWindow];
//	[[NSApplication sharedApplication] _removeWindowFromCache:_stubWindow];
	
	[_stubWindow release];
	[_mockWindow release];
}

- (void)testWindowDidLoad {
	// - (void)windowDidLoad
	
	[_winController windowDidLoad];

	// window hasn't really loaded from nib - there is no view or anything
	STAssertTrue( _winController.editingViewController!=nil, @"hmm" );
}

- (void)testAddToolBarWithTools {
	// - (void)addToolBar
	// - (void)addToolsToToolBar:(NSMutableDictionary *)someTools

	OCMockObject *mockViewController = MOCKFORCLASS( [EditingViewController class] );
	[[mockViewController expect] setInputController:OCMOCK_ANY];

	SwappedInIvar *swapIn = [SwappedInIvar swapFor:_winController :"_editingViewController" :mockViewController];
	
	[_winController addToolBar];
	STAssertTrue( _winController.toolBarController!=nil, @"hmm" );
	[mockViewController verify];
	
	// -- swap out the toolbarContrl
	OCMockObject *mockToolBarCntrl = MOCK(ToolBarController);
	
	SwappedInIvar *_swapInToolBarController = [SwappedInIvar swapFor:_winController :"_toolBarController" :mockToolBarCntrl];
	
	OCMockObject *mockTool1 = MOCK(Tool);
	OCMockObject *mockTool2 = MOCK(Tool);
	[[[mockTool1 stub] andReturn:@"mockTool1"] identifier];
	[[[mockTool2 stub] andReturn: @"mockTool2"] identifier];

	NSArray *mockTools = [NSArray arrayWithObjects:
									  mockTool1, 
									  mockTool2,
									  nil];
	
	[[mockToolBarCntrl expect] addTools:mockTools];

	[_winController addToolsToToolBar:mockTools];

	[mockToolBarCntrl verify];
	
	[_swapInToolBarController putBackOriginal];
	[swapIn putBackOriginal];
}

- (void)testSetDomainContext {
	// - (void)setDomainContext:(DomainContext *)cntx
	
	OCMockObject *mockDomainCntx = [OCMockObject mockForClass:[DomainContext class]];

	OCMockObject *mockViewController = MOCKFORCLASS( [EditingViewController class] );
	[[mockViewController expect] setupWithDomainContext:(id)mockDomainCntx];
	[[[mockViewController expect] andReturn:mockDomainCntx] domainContext];

	SwappedInIvar *swapIn = [SwappedInIvar swapFor:_winController :"_editingViewController" :mockViewController];

	[_winController setDomainContext:(id)mockDomainCntx];
	STAssertTrue(_winController.domainContext==(id)mockDomainCntx, @"hmm");
	[mockViewController verify];
	
	[swapIn putBackOriginal];
}

@end
