//
//  BKScriptsMenuExtension.m
//  Blocks
//
//  Created by Jesse Grosjean on 1/26/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKScriptsMenuExtension.h"
#import "BKUserInterfaceController.h"
#import "BKMenuController.h"
#import "BKScriptsController.h"


@implementation BKScriptsMenuExtension

- (void)declareMenuItems:(id <BKMenuControllerProtocol>)menuController {
	NSMenu *scriptMenu = [[BKScriptsController sharedInstance] scriptMenu];
    NSMenuItem *scriptMenuItem = [[[NSMenuItem alloc] initWithTitle:@"" action:nil keyEquivalent:@""] autorelease];
	[scriptMenuItem setSubmenu:scriptMenu];
	
	[menuController insertMenuItem:scriptMenuItem insertPath:@"/TopGroup.-2"];
	[menuController declareMenuItem:scriptMenuItem menuItemPath:@"/ScriptItem"];

	[menuController declareMenu:scriptMenu menuPath:@"/Script"];
}

- (void)menuController:(id <BKMenuControllerProtocol>)menuController addedItem:(NSMenuItem *)menuItem {
	[[BKScriptsController sharedInstance] updateScriptsMenu:self];
}

- (void)menuControllerFinishedLoadingMenu:(id <BKMenuControllerProtocol>)menuController {
}

@end
