//
//  SHAppControl.m
//  Pharm
//
//  Created by Steve Hooley on 01/04/2007.
//  Copyright 2007 HooleyHoop. All rights reserved.
//

#import "SHAppControl.h"

//#import <SHShared/BBLogger.h>
//#import <SHPluginManager/SHPluginManager.h>
//#import "BlakeController.h"
//#import "SHPythonSupport.h"
//#import "SHJavascriptSupport.h"
//#import "defs.h"
//#import <AvailabilityMacros.h>
#import <FScript/FScript.h>

//nov09 NSString *_UNITTEST_BUNDLE_TOLOAD __attribute__((weak));
static SHAppControl* _appControl;

/*
 *
*/
@implementation SHAppControl


#pragma mark -
#pragma mark class methods
+ (void)initialize {

	static BOOL isInitialized = NO;
	if( !isInitialized )
	{
		isInitialized=YES;
		NSString* compositionRoot = @"empty";
		NSString* CMSRoot = @"empty";
		NSString* resourceCache = @"empty";
		NSNumber* appleDockEnabled = [NSNumber numberWithBool:YES];
		NSMutableDictionary* settingsStore = [NSMutableDictionary dictionaryWithObjectsAndKeys:
			compositionRoot, @"CompositionRoot",			
			CMSRoot, @"CMSRoot",
			resourceCache, @"ResourceCache",
			appleDockEnabled, @"AppleDockIconEnabled",
			nil];

		// register the defaults version with ... defaults
		[[NSUserDefaults standardUserDefaults] registerDefaults:settingsStore];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

+ (SHAppControl *)appControl {
	
	if(_appControl==nil)
		_appControl = [[self alloc] init];
	NSAssert(_appControl!=nil, @"This can not be nil!");
	return _appControl;
}


#pragma mark init methods

- (id)init {

	self = [super init];
    if( self && _appControl==nil )
    {
		// NSBundle *aBundle = [[NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/ProKit.framework"]retain];
		//		NSBundle *aBundle = [[NSBundle bundleWithPath:@"Shared.framework"]retain];	
		//		if(aBundle!=nil){
		//			BOOL loadResult = [aBundle load];
		//			NSLog(@"SHAppControl.m: Bundle is not nil! But, has it loaded? %i", loadResult );
		//			Class aProWindow = [[aBundle classNamed: @"SHPlusOperator"]retain];
		//			NSLog(@"pro window superclass is %@", [aProWindow superclass] );
		//			NSRect a = NSMakeRect(50, 50, 200, 200);
		//			id anInstanceNSProWindow = [[aProWindow alloc]initWithContentRect:a  styleMask:NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask backing:NSBackingStoreBuffered defer:YES ];
		//			[anInstanceNSProWindow orderFront:nil];
		//			[anInstanceNSProWindow setTitle:@"A Pro Window"];
		//		[[anInstanceNSProWindow class] poseAsClass: [NSWindow class]];
		//		}
		_appControl = self;
		
//		[[SHGlobalVars alloc] init];
		_SHBundleLoader = [[SHBundleLoader alloc] init];
	} else {
		return _appControl;
	}
    return self;
}

- (void)dealloc {

    [_SHBundleLoader release];
	_appControl = nil;
    [super dealloc];
}

- (void)awakeFromNib {

	/* Try to dynamically load the frameworks we need */
	[_SHBundleLoader addAllPathsFrom:[[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Contents"] stringByAppendingPathComponent:@"Frameworks"] ];
	[_SHBundleLoader addAllPathsFrom:@"/Users/Shared/Library/PrivateFrameworks"];
	
	/* This is temporary while i can't get tests to work */
	//-- warning manullay inserting tests into app for debugging
//nov09	if(&_UNITTEST_BUNDLE_TOLOAD!=NULL) //-- test to see if the weakly linked symbol _UNITTEST_BUNDLE_TOLOAD exists
//nov09		if(_UNITTEST_BUNDLE_TOLOAD!=nil){ //-- test to see if it has been set
//nov09			NSString *appPath =[[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];	
//nov09			NSString *unitTestBundlePath = [appPath stringByAppendingPathComponent:_UNITTEST_BUNDLE_TOLOAD];
//nov09			[_SHBundleLoader loadUnitTestBundle:unitTestBundlePath];
//nov09		}
	
	[_SHBundleLoader loadPlugInFrameworks];
	BOOL success = [_SHBundleLoader checkAvailableClassesFor:[NSArray arrayWithObjects:@"BBExtension", @"FSObjectPointer", @"SHNodeGraphModel", nil]];
		
	if(success==NO){
		logError(@"SHAppControl.m: ERROR.. can't find vital components");
		[[NSApplication sharedApplication] terminate:self];
	}
	[[NSApp mainMenu] addItem:[[[FScriptMenuItem alloc] init] autorelease]];
}

#pragma mark accessor methods
- (NSString *)description {

    NSString *result = [NSString stringWithFormat:@"%@ Appcontrol", [super description]]; 
    return result;
}


@end