//
//  BKCrashReporterLifecycleExtension.m
//  Blocks
//
//  Created by Jesse Grosjean on 5/16/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKCrashReporterLifecycleExtension.h"
#import "BKCrashReporterController.h"


@implementation BKCrashReporterLifecycleExtension

- (void)applicationLaunching {
}

- (void)applicationWillFinishLaunching {
}

- (void)applicationDidFinishLaunching {
	[[BKCrashReporterController sharedInstance] check:self];
}

- (void)applicationWillTerminate {
}

@end