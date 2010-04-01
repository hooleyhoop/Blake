//
//  SHAppControlTests.m
//  BlakeLoader
//
//  Created by steve hooley on 03/01/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "SHAppControlTests.h"
#import "SHAppControl.h"
#import <SHShared/SHDocumentController.h>
#import <SHShared/NSDocumentController_Extensions.h>

@implementation SHAppControlTests


- (void)setUp {
	
	/* this is managing our NSUserDefaults, our global variables, and loading some frameworks */
	appControl = [[SHAppControl alloc] init];
	STAssertNotNil(appControl, @"appControl");

	[[SHDocumentController sharedDocumentController] closeAll];
	NSArray* allDocs = [[SHDocumentController sharedDocumentController] documents];
	STAssertTrue([allDocs count]==0, @"closeAll docs broken? %i", [allDocs count]);
}


- (void)tearDown {
	
	[appControl release];
}

- (void)testInitialize {
// + (void)initialize 

	// test our user defaults..
	STFail(@"Not done yet");
}

- (void)testAwakeFromNib {
// - (void)awakeFromNib

	// globarvars should be made

	// frameworks should be loaded

	// Plugins should be loaded

	// fscript should be installed
	STFail(@"Not done yet");
}

- (void)testInstallPlugins {

	STFail(@"Not done yet");

//	plugIn1 = BBPlugin
//	plugIn2 = BBPlugin
//	plugIn3 = BBPlugin
//	plugIn4 = BBPlugin
//	plugIn5 = BBPlugin
//	
//	[[BBExtension alloc] initWithPlugin:nil extensionPointID:@"uk.co.stevehooley.SHPluginManager.main" extensionClassName:BKLifecyleMainExtension]
//
//	limitPluginsTo
//	@"FScript"
//	@"BlakeMain"
//	@"Sketch"
//	
//	NSString* pluginConfigPath = [[NSBundle mainBundle] pathForResource:@"pluginConfig" ofType:@"txt"];
//	if(pluginConfigPath!=nil)
//		[[BBPluginRegistry sharedInstance] limitPluginsTo:pluginConfigPath];
//	
//	allPlugins = @"mock1", @"mock2", @"mock3", @"mock4", @"mock5"
//	plugInsWeWant = @"mock1", @"mock3", @"mock5"
//	[appControl installPlugins: plugInsWeWant];
//	
//	STAssertTrue( mock1 didLoad );
//	STAssertTrue( mock3 didLoad );
//	STAssertTrue( mock5 didLoad );
//	
//	STAssertFalse( mock2 didLoad );
//	STAssertFalse( mock4 didLoad );
//	
//	fscript plugin
//	blakeMain plugin
//	sketchView Plugin
	
}

// -- limit which plugins we add before we scan
// -- automatically scan the app for any "plugin.xml"
// - (void)scanBundleForInternalPlugins

// # If you pass this file to the plugin manager (before loading plugins) you can limit which plugins are loaded.
// # If you dont pass this (or an equivalent) file, the plugin manager will attempt to load every found plugin.

// # THESE ARE THE MAIN PLUGINS

// # This is required for plugins to work
// tv.bestbefore.BBUtilities

// # Manages the lifecycle of the every other plugins, all plugins extend this
// #tv.bestbefore.BBViewMainPlugin

// # GUI plugins extend this
// #tv.bestbefore.BBViewGUIManager

//# Viewplayer data model
//#tv.bestbefore.BBSceneManager
//
//
//# THESE ARE THE PALETTES AND STUFF
//
//# Create and delete scenes, add and remove layers, edit input values - the main 'setup' component
//#tv.bestbefore.BBLayerPalette
//
//# Select which scene is currently playing, transition to another scene
//tv.bestbefore.BBSceneList
//
//# Edit 'visible' inputs of all layers in current playing scene
//# tv.bestbefore.BBInputInspector
//
//# save and load plugin data
//# tv.bestbefore.BBDocumentSaving
//
//# All layers, for debugging
//# tv.bestbefore.BBLayersList
//
//# Set the size and aspect ratio of Millicent view
//# tv.bestbefore.BBPlaybackSettings
//
//# Change the size of all layers
//# tv.bestbefore.BBSceneSettings
//
//# Have a qc file constantly on the background layer
//#tv.bestbefore.BBBackgroundLayer
//
//
//# DEBUGGING
//#tv.bestbefore.ThreadSafetyTests
//
//#tv.bestbefore.BBInputsList
//
//#tv.bestbefore.BBLayersList
//
//#tv.bestbefore.GLLogicOp






@end
