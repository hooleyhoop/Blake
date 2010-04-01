//
//  BKConfigurationController.m
//  Blocks
//
//  Created by Jesse Grosjean on 2/3/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//


#import "BKConfigurationController.h"

 
@interface NSObject (BKConfigurationControllerPrivateApplicationDelegateAccess)

+ (id <BKConfigurationDelegateProtocol>)BKConfigurationProtocols_applicationDelegate;

@end

@implementation BKConfigurationController

#pragma mark class methods

+ (id)sharedInstance {
    static id sharedInstance = nil;
    if (sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

#pragma mark accessors

- (BKConfigurationLoggingLevel)loggingLevel {
    return [[NSUserDefaults standardUserDefaults] integerForKey:BKConfigurationLoggingLevelKey];
}

- (void)setLoggingLevel:(BKConfigurationLoggingLevel)level {
    logAssert(level >= 0 && level <= 99, @"out of range log level.");
	[BKLog setLoggingLevel:level];
    [[NSUserDefaults standardUserDefaults] setInteger:level forKey:BKConfigurationLoggingLevelKey];
}

- (NSDate *)lastRunDate {
	return [[NSUserDefaults standardUserDefaults] objectForKey:BKConfigurationLastRunDateKey];
}

- (NSNumber *)lastRunVersion {
	NSString *versionString = [[NSUserDefaults standardUserDefaults] stringForKey:BKConfigurationLastRunVersionKey];
	if (versionString) {
		return [NSNumberFormatter numberFromString:versionString];
	}
	return nil;
}

- (NSNumber *)currentRunVersion {
	NSString *versionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	if (versionString) {
		return [NSNumberFormatter numberFromString:versionString];
	}
	return nil;
}

#pragma mark actions

- (IBAction)showUserGuide:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[[NSApp delegate] applicationUserGuideURLString]]];
}

- (IBAction)visitWebPage:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[[NSApp delegate] applicationWebPageURLString]]];
}

- (IBAction)visitUserForums:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[[NSApp delegate] applicationUserForumsURLString]]];
}

- (IBAction)recoverLostLicense:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[[NSApp delegate] applicationRecoverLostLicenseURLString]]];
}

- (IBAction)pluginsAndScripts:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[[NSApp delegate] applicationPluginsAndScriptsURLString]]];
}

- (IBAction)showReleaseNotes:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[[NSApp delegate] applicationReleaseNotesURLString]]];
}

- (IBAction)requestNewFeatureOrReportBug:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[[NSApp delegate] applicationRequestsAndBugsURLString]]];
}

@end

@implementation NSObject (BKConfigurationControllerApplicationDelegateAccess)

+ (id <BKConfigurationDelegateProtocol>)BKConfigurationProtocols_applicationDelegate {
	id delegate = [[NSApplication sharedApplication] delegate];
	
	if ([delegate conformsToProtocol:@protocol(BKConfigurationDelegateProtocol)]) {
		return delegate;
	} else {
		logError((@"application delegate failed to conform to @protocol(BKConfigurationDelegateProtocol)"));
		return nil;
	}
}

@end

NSString *BKConfigurationLoggingLevelKey = @"BKConfigurationLoggingLevelKey";
NSString *BKConfigurationLastRunDateKey = @"BKConfigurationLastRunDateKey";
NSString *BKConfigurationLastRunVersionKey = @"BKConfigurationLastRunVersionKey";