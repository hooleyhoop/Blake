//
//  BKConfigurationLifecycleExtension.m
//  Blocks
//
//  Created by Jesse Grosjean on 1/30/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKConfigurationLifecycleExtension.h"
#import "BKConfigurationController.h"


@implementation BKConfigurationLifecycleExtension

- (void)applicationLaunching {
	UInt32 response;
	
    if ((Gestalt(gestaltSystemVersion, (SInt32 *) &response) == noErr) && (response < 0x1040)) {
		int currentVersion = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"] intValue];
		int dontShowVersion = [[NSUserDefaults standardUserDefaults] integerForKey:@"BKConfigurationDontShowIncompatibleVersionMessageForVersion"];

		if (currentVersion > dontShowVersion) {
			NSString *messageFormat = BKLocalizedString(@"%@ is designed for OS X 10.4 and later. You may try running it on an earlier version but you will likely run into problems.", nil);
			int choice = NSRunCriticalAlertPanel(BKLocalizedString(@"Requires OS X 10.4 (Tiger) or later", nil),
												 [NSString stringWithFormat:messageFormat, [[NSProcessInfo processInfo] processName]],
												 BKLocalizedString(@"Quit", nil),
												 BKLocalizedString(@"Run Anyway", nil),
												 BKLocalizedString(@"Don't Show Again", nil));
			if (choice == NSAlertDefaultReturn) {
				[NSApp terminate:nil]; // quit
			} else if (choice == NSAlertOtherReturn) {
				[[NSUserDefaults standardUserDefaults] setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"] forKey:@"BKConfigurationDontShowIncompatibleVersionMessageForVersion"];
			}
		}
	}
}

- (void)applicationWillFinishLaunching {
}

- (void)applicationDidFinishLaunching {
}

- (void)applicationWillTerminate {
	[[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:BKConfigurationLastRunDateKey];
	[[NSUserDefaults standardUserDefaults] setObject:[[[BKConfigurationController sharedInstance] currentRunVersion] description] forKey:BKConfigurationLastRunVersionKey];
}

@end
