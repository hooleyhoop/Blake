//
//  BKSoftwareUpdateLifecycleExtension.m
//  Blocks
//
//  Created by Jesse Grosjean on 1/27/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKSoftwareUpdateLifecycleExtension.h"
#import "BKSoftwareUpdateController.h"


@implementation BKSoftwareUpdateLifecycleExtension

- (void)applicationLaunching {
}

- (void)applicationWillFinishLaunching {
}

- (void)applicationDidFinishLaunching {
	[[BKSoftwareUpdateController sharedInstance] checkForUpdateIfNeeded];
}

- (void)applicationWillTerminate {
}

@end
