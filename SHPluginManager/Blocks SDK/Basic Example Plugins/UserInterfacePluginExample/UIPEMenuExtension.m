//
//  UIPEMenuExtension.m
//  Blocks SDK
//
//  Created by Jesse Grosjean on 5/19/05.
//  Copyright 2005 Hog Bay Software. All rights reserved.
//

#import "UIPEMenuExtension.h"


@implementation UIPEMenuExtension

- (void)declareMenuItems:(id <BKMenuControllerProtocol>)menuController {
    NSMenuItem *exampleItem = [[[NSMenuItem alloc] initWithTitle:@"Example Plugin Menu Item" action:@selector(doNothing:) keyEquivalent:@""] autorelease];

	// note, to see the list of posible insert paths for a blocks application go to 
	// the application "Plugins" preference pane and show the menu configuration from there.
	[menuController insertMenuItem:exampleItem insertPath:@"/Application/PreferencesGroup"];
	[menuController declareMenuItem:exampleItem menuItemPath:@"/Application/ExampleItem"];
}

- (void)menuController:(id <BKMenuControllerProtocol>)menuController addedItem:(NSMenuItem *)menuItem {
}

@end
