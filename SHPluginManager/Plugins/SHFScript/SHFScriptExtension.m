//
//  SHFScriptExtension.m
//  SHPluginManager
//
//  Created by steve hooley on 13/06/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SHFScriptExtension.h"
#import <FScript/FScript.h>


@implementation SHFScriptExtension

#pragma mark notification methods
- (void)applicationLaunching {
}

- (void)applicationWillFinishLaunching {
	
	/* load FScript */
	[[NSApp mainMenu] addItem:[[[FScriptMenuItem alloc] init] autorelease]];
}

- (void)applicationDidFinishLaunching {
}

- (void)applicationWillTerminate {
}

@end
