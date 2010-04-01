//
//  BKUserInterfaceLifecycleExtension.m
//  Blocks
//
//  Created by Jesse Grosjean on 1/10/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKUserInterfaceLifecycleExtension.h"
#import "BKUserInterfaceController.h"


@implementation BKUserInterfaceLifecycleExtension

- (void)applicationLaunching {
}

- (void)applicationWillFinishLaunching {
    [[BKUserInterfaceController sharedInstance] initMainMenuExtension:[NSApp mainMenu]];
    [[BKUserInterfaceController sharedInstance] initDockMenuExtension:[[[NSMenu alloc] init] autorelease]];
}

- (void)applicationDidFinishLaunching {
}

- (void)applicationWillTerminate {
}

@end
