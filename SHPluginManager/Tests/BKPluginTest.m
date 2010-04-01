//
//  BKPluginTest.m
//  Blocks
//
//  Created by Jesse Grosjean on 12/3/04.
//  Copyright 2004 Hog Bay Software. All rights reserved.
//

#import "BKPluginTest.h"
#import "BKUserInterfaceProtocols.h"
#import "BKPreferencesProtocols.h"

@implementation BKPluginTest

- (void)setUp {
	
	/* Find plugins on disk */
	[[BBPluginRegistry sharedInstance] scanPlugins];
	
	STAssertTrue([[[BBPluginRegistry sharedInstance] pluginFor:@"uk.co.stevehooley.BKLifecycle"] load], @"");
	STAssertTrue([[[BBPluginRegistry sharedInstance] pluginFor:@"uk.co.stevehooley.SHFScript"] load], @"");
	
//	STAssertTrue([[[BBPluginRegistry sharedInstance] pluginFor:@"uk.co.stevehooley.BKDocuments"] load], @"");
//	STAssertTrue([[[BBPluginRegistry sharedInstance] pluginFor:@"uk.co.stevehooley.BKUserInterface"] load], @"");
//	STAssertTrue([[[BBPluginRegistry sharedInstance] pluginFor:@"uk.co.stevehooley.BKConfiguration"] load], @"");
//	STAssertTrue([[[BBPluginRegistry sharedInstance] pluginFor:@"uk.co.stevehooley.BKPreferences"] load], @"");
//	STAssertTrue([[[BBPluginRegistry sharedInstance] pluginFor:@"uk.co.stevehooley.BKLicense"] load], @"");
//	STAssertTrue([[[BBPluginRegistry sharedInstance] pluginFor:@"uk.co.stevehooley.BKPlugins"] load], @"");
//	STAssertTrue([[[BBPluginRegistry sharedInstance] pluginFor:@"uk.co.stevehooley.BKScripts"] load], @"");
//	STAssertTrue([[[BBPluginRegistry sharedInstance] pluginFor:@"uk.co.stevehooley.BKSoftwareUpdate"] load], @"");
//	STAssertTrue([[[BBPluginRegistry sharedInstance] pluginFor:@"uk.co.stevehooley.BKCrashreporter"] load], @"");
	
	/* BBPlugin's represent bundles */
	/* BBExtension's represent instances of those plugins in the app */
	/* It is BBExtension's that we operate on */
    [BBPluginRegistry performSelector:@selector(applicationLaunching) forExtensionPoint:@"uk.co.stevehooley.BKLifecycle.lifecycle" protocol:NSProtocolFromString(@"BKLifecycleProtocol")];

	[[BBExtension alloc] initWithPlugin:nil extensionPointID:@"uk.co.stevehooley.SHPluginManager.main" extensionClassName:BKLifecyleMainExtension]

}

- (void)tearDown {

}

- (void)testInitWithBundle {
// - (id)initWithBundle:(NSBundle *)bundle

}

- (void)testInitWithXML {
// - (id)initWithXML:(NSString *)validXMLPath 

	NSBundle* thisBundle = [NSBundle bundleForClass:[self class]];
	NSString* mocDockPath = [thisBundle pathForResource:@"MockPlugin" ofType:@"xml"];
	BBPlugin *plugIn1 = [[[BBPlugin alloc] initWithXML: mocDockPath] autorelease];
	STAssertNotNil(plugIn1, @"eek");
	
	BOOL result = [[BBPluginRegistry sharedInstance] registerPlugin:plugIn1];
	STAssertTrue(result, @"waaaaa");
}

- (void)testPluginWithString {

	NSDictionary *plugInProperties = [NSDictionary dictionaryWithObjectsAndKeys:@"value1", @"key1", @"value2", @"key2", nil];
	BBPlugin *plugIn1 = [[[BBPlugin alloc] initWithProperties: plugInProperties] autorelease];
	
}

- (void)testPluginsLoaded {
	STAssertTrue([[[[NSApplication sharedApplication] BKPreferencesProtocols_preferencesController] paneIdentifiers] count] == 2, @"");
}

@end
