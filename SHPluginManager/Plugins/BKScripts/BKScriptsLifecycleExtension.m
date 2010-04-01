//
//  BKScriptsLifecycleExtension.m
//  Blocks
//
//  Created by Jesse Grosjean on 3/17/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKScriptsLifecycleExtension.h"
#import "BKScriptsController.h"
#import "BKScriptsSetCommand.h"
#import "BKScriptsGetCommand.h"


@implementation BKScriptsLifecycleExtension

- (void)applicationLaunching {
	[BKScriptsSetCommand poseAsClass:[NSSetCommand class]];
	[BKScriptsGetCommand poseAsClass:[NSGetCommand class]];

	[[BKScriptsController sharedInstance] scriptFilesPerformCommand:@"applicationLaunching" withArguments:nil];
}

- (void)applicationWillFinishLaunching {
	[[BKScriptsController sharedInstance] scriptFilesPerformCommand:@"applicationWillFinishLaunching" withArguments:nil];
}

- (void)applicationDidFinishLaunching {
	[[BKScriptsController sharedInstance] scriptFilesPerformCommand:@"applicationDidFinishLaunching" withArguments:nil];
}

- (void)applicationWillTerminate {
	[[BKScriptsController sharedInstance] scriptFilesPerformCommand:@"applicationWillTerminate" withArguments:nil];
}

@end
