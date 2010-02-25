//
//  BKPreferencePaneMenuExtension.m
//  Blocks
//
//  Created by Jesse Grosjean on 1/7/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKPreferencesMenuExtension.h"
#import "BKPreferencesController.h"
#import "BKUserInterfaceController.h"


@implementation BKPreferencesMenuExtension

- (void)declareMenuItems:(id <BKMenuControllerProtocol>)menuController {
	NSMenuItem *preferencesGroup = [NSMenuItem separatorItem];
	[menuController insertMenuItem:preferencesGroup insertPath:@"/Application/TopGroup"];
	[menuController declareGroupItem:preferencesGroup groupPath:@"/Application/PreferencesGroup"];
	
    NSMenuItem *preferencesItem = [[[NSMenuItem alloc] initWithTitle:BKLocalizedString(@"Preferences...", nil) action:@selector(showWindow:) keyEquivalent:@","] autorelease];
    [preferencesItem setTarget:[BKPreferencesController sharedInstance]];
	[menuController insertMenuItem:preferencesItem insertPath:@"/Application/PreferencesGroup"];
	[menuController declareMenuItem:preferencesItem menuItemPath:@"/Application/PreferencesItem"];
}

- (void)menuController:(id <BKMenuControllerProtocol>)menuController addedItem:(NSMenuItem *)menuItem {
}

- (void)menuControllerFinishedLoadingMenu:(id <BKMenuControllerProtocol>)menuController {
}

@end
