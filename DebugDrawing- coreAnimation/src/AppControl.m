//
//  AppControl.m
//  DebugDrawing
//
//  Created by steve hooley on 14/10/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "AppControl.h"
#import "Tool.h"
#import "CALayerStarView.h"
#import "DomainContext.h"
#import "EditingWindowController.h"
#import "EditingWindow.h"
#import "PanTool.h"
#import "ZoomTool.h"
#import "ToolBarController.h"
#import <FScript/FScript.h>


# pragma mark -
@implementation AppControl

static CGFloat frameRate = 1.0f/60.0f;

@synthesize editingWindow=_editingWindow;
@synthesize domainCntxt=_domainCntxt;

- (id)init {

    self = [super init];
    if (self) {
		
		[[NSApplication sharedApplication] setDelegate:self];
		
		_domainCntxt = [[DomainContext alloc] init];

	//june09		[model addGraphUpdatedCallback:self selector:@selector(graphDidUpdate)];

	//june09		BOOL isRunningTests = (NSClassFromString(@"StarTests")!=nil);
	//june09		NSLog(@"am runing tests? %i", isRunningTests);
	//june09		if(isRunningTests==NO){
	//june09		}
	//june09		[self play:nil];
    }
    return self;
}

- (void)dealloc {

	[_domainCntxt release];
	[_viewTools release];
	[super dealloc];
}

- (void)awakeFromNib {

	[[NSApp mainMenu] addItem:[[[FScriptMenuItem alloc] init] autorelease]];

	NSAssert(layerStarView!=nil, @"window not unarchived from nib");
	NSAssert(_editingWindow!=nil, @"window not unarchived from nib");

	_editWindowController = [[EditingWindowController alloc] initWithWindow:_editingWindow];
	
	// Hmm, i shouldn't do this - i need to tweak the nib set up
	_editWindowController.editingView = layerStarView;
	[_editWindowController windowDidLoad];


	PanTool *panTool = [[[PanTool alloc] initWithTarget:_editWindowController.editingViewController] autorelease];
	ZoomTool *zoomTool = [[[ZoomTool alloc] initWithTarget:_editWindowController.editingViewController] autorelease];
	
	// This is un-ordered
	_viewTools = [[NSArray arrayWithObjects:
					panTool, 
					zoomTool,
					nil] retain];

	[_editWindowController addToolBar];
	[_editWindowController addToolsToToolBar:[_domainCntxt modelTools]];
	[_editWindowController addToolsToToolBar:_viewTools];
	[_editWindowController.toolBarController addToolbarToWindow];
	
	[_editWindowController setDomainContext: _domainCntxt];
	
	[_editWindowController doZoomPopUp:zoomListButton];
}

- (void)updateGraph:(NSTimer *)theTimer {

	static CGFloat currentTime = 0.0f;

	[layerStarView.window disableFlushWindow];

	// actually we want to update each node and let each node mark a piece of the screen as dirty
//september09	[model updateForTime: currentTime];
	currentTime = currentTime+frameRate;
}

/* we need this because we are single threaded at the mo and the tools hijack the current runloop */
- (void)forceUpdateInHijackedEventLoop {

    [layerStarView.window disableFlushWindow];

//september09	[model enforceGraphConsistentState];
	[self graphDidUpdate];
}

- (void)graphDidUpdate {

	// bit hacky for now..
	[_editWindowController.editingViewController graphDidUpdate];
	[layerStarView.window enableFlushWindow];
}

- (void)setLayerStarView:(id)value {
	
	layerStarView = value;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	
	[self stop:nil];
	
	/* at the moment this is cleaning up the tool layers and stuff - messy */
//september09	SHNode *currentNode = model.currentNodeGroup;
//september09	[currentNode unSelectAllChildren];

	[_domainCntxt cleanup];
	
	// release top level items in the nib?
	[arrayController unbind:NSContentArrayBinding];
	[arrayController unbind:NSSelectionIndexesBinding];
	[arrayController release];
	arrayController = nil;
	

	
//june09	[model deleteChildren:(NSArray *)[model.rootNodeGroup allChildren] fromNode:model.rootNodeGroup];
	

	
	[[[NSApplication sharedApplication] windows] makeObjectsPerformSelector:@selector(close)];
	[[layerStarView window] release];
	
	[[NSApplication sharedApplication] setDelegate:nil];
}

#pragma mark Temp GUI stuff
- (IBAction)play:(id)sender {

	if(screenRefreshTimer==nil)
		screenRefreshTimer = [NSTimer scheduledTimerWithTimeInterval:frameRate target:self selector:@selector(updateGraph:) userInfo:nil repeats:YES];
}

- (IBAction)stop:(id)sender {

	[screenRefreshTimer invalidate];
	screenRefreshTimer = nil;
}

//TODO: Think about a clean domain layer!
- (IBAction)moveUp:(id)sender {

	[_domainCntxt.model moveUpAlevelToParentNodeGroup];
}

- (IBAction)moveDown:(id)sender {
	
	NSArray *currentNodeSelection = [[_domainCntxt.model currentNodeGroup] selectedChildNodes];
	if([currentNodeSelection count]==1){
		[_domainCntxt.model moveDownALevelIntoNodeGroup:[currentNodeSelection objectAtIndex:0]];
	}
}

- (IBAction)deleteSelected:(id)sender {
	
//september09	NodeProxy *currentNodeProxy = [starScene.filter currentNodeProxy];
//september09	NSArray *selectedItems = [starScene selectedItems];
//september09	if([selectedItems count]>0)
//september09	{
//september09		NSMutableArray *itemsToDelete = [NSMutableArray array];
//september09		for(NodeProxy *each in selectedItems){
//september09			[itemsToDelete addObject:[each originalNode]];
//september09		}
//september09		[model deleteChildren:itemsToDelete fromNode:currentNodeProxy.originalNode];
//september09	}
}

// should be in window controller
- (IBAction)homeView:(id)sender {
	[_editWindowController homeView:sender];
}

- (IBAction)setZoomToListValue:(id)sender {
	[_editWindowController setZoomToListValue:sender];
}


- (DomainContext *)domainCntxt {
	return _domainCntxt;
}

- (void)bind:(NSString *)binding toObject:(id)observableController withKeyPath:(NSString *)keyPath options:(NSDictionary *)options {
	[super bind:binding toObject:observableController withKeyPath:keyPath options:options];
}

@end
