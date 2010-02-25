//
//  SHAppModel.m
//  InterfaceTest
//
//  Created by Steve Hool on Fri Dec 26 2003.
//  Copyright (c) 2003 HooleyHoop. All rights reserved.
//
#import "SHAppModel.h"
#import "SHAppControl.h"
#import "SHAppView.h"
#import "SHFScriptControl.h"
#import "SHFScriptModel.h"
//#import "SHBundleLoader.h"
#import "SHFScriptControl.h" 
//#import "SHFScriptNodeGraphLoader.h"
#import "SHPlugInViewManager.h"
#import "SHFScriptLoader.h"
#import <SHPluginManager/SHPluginManager.h>

// singleton type thing
static SHAppModel* _appModel;


@implementation SHAppModel
#pragma mark -
#pragma mark class methods

#pragma mark init methods

- (id)init
{
    if ((self = [super init]) != nil)
    {
		_appModel = self;

//pleasebuild		_viewPlugInManager	= [[SHPlugInViewManager alloc] initWithAppModel:self];
//pleasebuild		_fscriptLoader		= [[SHFScriptLoader alloc] initWithAppModel:self];
	}
    return self;
}


-(void)dealloc
{
	[_theSHAppControl release];
    _theSHAppControl = nil;
    [super dealloc];
}

- (void)setUpApp
{
	// dynamically load our plugins an store references in the globals object
	NSMutableDictionary* theDataTypePlugins		= [NSMutableDictionary dictionaryWithCapacity:5];
	NSMutableDictionary* theOperatorPlugins		= [NSMutableDictionary dictionaryWithCapacity:5];
	NSMutableDictionary* theViewPlugins			= [NSMutableDictionary dictionaryWithCapacity:5];

//26/05/06	[_SHBundleLoader loadPlugInDataTypes: theDataTypePlugins];
//26/05/06	[_SHBundleLoader loadPlugInOperators: theOperatorPlugins];
//26/05/06	[_SHBundleLoader loadPlugInViews: theViewPlugins];

//26/05/06	[[SHGlobalVars globals] setObject:theDataTypePlugins forKey:@"theDataTypePlugins" ];
//26/05/06	[[SHGlobalVars globals] setObject:theOperatorPlugins forKey:@"theOperatorPlugins" ];
//26/05/06	[[SHGlobalVars globals] setObject:theViewPlugins forKey:@"theViewPlugins" ];


    [NSApplication sharedApplication];
	
	
	// make the default root nodegroup
//pleasebuild	_nodeGraphModel	= [[SHNodeGraphModel alloc] init];
//pleasebuild	NSLog(@"SHAppModel.m: _nodeGraphModel %@", _nodeGraphModel);
	
	// temp test
	
//pleasebuild	SHNode* ob1 = [_nodeGraphModel newRootNodeWithName:@"node1"];
//pleasebuild	SHNode* child = [[SHNode alloc] init];
//pleasebuild	[ob1 NEW_addChild:child];

	// test adding an input attribute
//pleasebuild	SHInputAttribute* child1 = [[SHInputAttribute alloc] init];
//pleasebuild	[ob1 NEW_addChild:child1];

	// test adding an output attribute
//pleasebuild	SHOutputAttribute* child2 = [[SHOutputAttribute alloc] init];
//pleasebuild	[ob1 NEW_addChild:child2];

	// end temp test
	
	
	
	
	
	// create our plug in views
//26/05/06	[_viewPlugInManager createViewControllersFromLoadedPlugins];

//26/05/06	[_fscriptLoader doScript:@"startup.fscript"];
//26/05/06	NSAssert([_objectGraphModel theCurrentNodeGroup] != nil, @"ERROR.. a default root node hasnt been made");

	// theResourceManager = [[ResourceManager alloc] init];

	// put this in a startup script!
	// [fscripRunner runBundledScript@"startUp"];
	
//26/05/06	[_viewPlugInManager requestSetViewport:@"SHViewportBL" withViewControl: @"SHObjPaletteControl" ];
//26/05/06	[_viewPlugInManager requestSetViewport:@"SHViewportTR" withViewControl: @"SHNodeGraphInspector_C" ];
//	[_viewPlugInManager requestSetViewport:@"SHViewportBR" withViewControl: @"SHFScriptControl" ];
//26/05/06	[_viewPlugInManager requestSetViewport:@"SHViewportTL" withViewControl: @"SHObjectListControl" ];
//	[_viewPlugInManager requestSetViewport:@"SHViewportBR" withViewControl: @"SHNodeGraphTreeView_C" ];
//26/05/06	[_viewPlugInManager requestSetViewport:@"SHViewportBR" withViewControl: @"SHPropertyInspectorControl" ];

//	[_viewPlugInManager requestLaunchViewControlInOwnWindow:@"SHObjPaletteControl" ];
//	[_viewPlugInManager requestLaunchViewControlInOwnWindow:@"SHObjectListControl"];
	// [_viewPlugInManager requestLaunchViewControlInOwnWindow:_theFscriptScriptControl];

//26/05/06	[[SHFScriptModel fScriptModel] setObject:_objectGraphModel forIdentifier:@"graphModel"];
//26/05/06	[[SHFScriptModel fScriptModel] setObject:self forIdentifier:@"appModel"];
//	[[_theFscriptScriptControl theSHFScriptModel] setObject:_theSHAppControl forIdentifier:@"appControl"];
//	[[_theFscriptScriptControl theSHFScriptModel] setObject:[_theSHAppControl theSHAppView] forIdentifier:@"appView"];
	
//ns	[[_theFscriptScriptControl theSHFScriptModel] setObject:[_theSHObjPaletteControl theSHObjPaletteModel] forIdentifier:@"objPalleteModel"];
//ns	[[_theFscriptScriptControl theSHFScriptModel] setObject:[_theScriptControl theScriptModel] forIdentifier:@"scriptModel"];	// add variables
//ns	[[_theFscriptScriptControl theSHFScriptModel] setObject:[_theFscriptScriptControl theSHFScriptModel] forIdentifier:@"fsc"];	// add variables

	//aaa	[currentScript initEvaluationOfScriptAtFrame:0 ];

	// NSLog(@"AppModel.m: Finished initializing");
	// [self runTests];
//26/05/06	[[SHAppControl appControl] enableOpenViews];
//26/05/06	[[SHAppControl appControl] syncAllViewsWithModel];
	
	// sync main menu with nodegraph
//26/05/06	[[[NSApp mainMenu] delegate] initBindings];
	
}

@end

