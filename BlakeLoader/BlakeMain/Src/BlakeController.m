//
//  BlakeController.m
//  Pharm
//
//  Created by Steve Hooley on 06/03/2007.
//  Copyright 2007 HooleyHoop. All rights reserved.
//

#import "BlakeController.h"
#import "BlakeGlobalCommandController.h"
#import "BlakeDocumentController.h"

#import <SHPluginManager/BBPluginRegistry.h>
#import <FScript/FScript.h>


static BlakeController *_blakeControl;

/*
 *
*/
@implementation BlakeController

//@synthesize didFinishLaunching;

#pragma mark -
#pragma mark class methods
+ (BlakeController *)blakeController {
	return _blakeControl;
}

#pragma mark init methods

/* This is created by plugin manager before NSApplicationMain is called - so be careful */
- (id)init {

	if( nil==_blakeControl )
	{
		self = [super init];
		if( self )
		{
			_blakeControl = self;
//			didFinishLaunching = NO;

			//	BlakeDocumentController	// 1 per app			
			//	SHWindowController		// 1 per Document
			/*	The first instance of NSDocumentController to be allocated is used as the sharedDocumentController
			 so we must allocate 1 instance of our custom subclass early.*/
			BlakeDocumentController *sharedDocumentController = [BlakeDocumentController sharedDocumentController];
			
			/* This is a bit flakey, but what with injecting the tests and everything i have no idea when to do this definitively ONCE only */
			if(sharedDocumentController.isSetup==NO)
				[sharedDocumentController setupObserving];
			
			NSAssert(sharedDocumentController!=nil,@"app setup failed majorly");
			
			[(id<SHAppProtocol>)[NSApplication sharedApplication] setAboutPanelClass: NSClassFromString(@"BlakeAboutBoxController")];
		}
	}
    return _blakeControl;
}

- (void)dealloc {
	
	[_aboutBoxController release];
    [super dealloc];
}

- (void)installAllPluginSingletonViews {
	
	[BBPluginRegistry performSelector:@selector(installViewMenuItem) forExtensionPoint:@"uk.co.stevehooley.BlakeMain.singletonView" protocol:@protocol(SHSingletonViewExtensionProtocol)];
	[BBPluginRegistry performSelector:@selector(installViewMenuItem) forExtensionPoint:@"uk.co.stevehooley.BlakeMain.documentView" protocol:@protocol(SHDocumentViewExtensionProtocol)];
	
// get the highest priority window controller
//BBPluginRegistry *pluginRegistery = [BBPluginRegistry sharedInstance];
//NSArray *viewPlugins = [pluginRegistery loadedValidOrderedExtensionsFor:@"uk.co.stevehooley.BlakeMain.documentView" protocol:@protocol(BKLifecycleProtocol)]; 
//
//for( BBExtension *each in viewPlugins ) {
//	//		id <BKDocumentTypeProtocol> extension = [each extensionInstance];
//	//		[results addObject:extension];
//}
	
}

#pragma mark notification methods
/* BKLifecycleProtocol */
- (void)applicationLaunching {}

// A document has not been created yet
- (void)applicationWillFinishLaunching {

}

// A Document has been created at this point
- (void)applicationDidFinishLaunching {

	// A document has already been made by this point in -BlakeController init
	// NSAssert( [[BlakeDocumentController sharedDocumentController] frontDocument] !=nil, @"Not ready to make sketchView Yet!");
	
	BlakeGlobalCommandController *gcc = [BlakeGlobalCommandController sharedGlobalCommandController];
	NSApplication *sHApp = [NSApplication sharedApplication];

	// patch the responder chain - NO!
	// It is important to understand the path of Action messages from controls…
	// NSApp will include it's delegate in the chain even if it is not a responder
	[sHApp setDelegate:gcc];
	
	// Tool palettes etc, not built on a per-documnet basis
	[self installAllPluginSingletonViews];
	
//	didFinishLaunching = YES;
	
	[[NSApp mainMenu] addItem:[[[FScriptMenuItem alloc] init] autorelease]];
}

// Needed to conform 
- (void)applicationWillTerminate {

	// how many documents do we have left?
	[[BlakeDocumentController sharedDocumentController] closeAll];

	// clean up the plugins
	addDestructorCallback( [BBPluginRegistry class], @selector(tearDownPlugins) );
	addDestructorCallback( [BlakeGlobalCommandController class], @selector(cleanUpSharedGlobalCommandController) );
}


@end
