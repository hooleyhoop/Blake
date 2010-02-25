//
//  BKInspectorsMenuExtension.m
//  Blocks
//
//  Created by Jesse Grosjean on 12/2/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKInspectorsMenuExtension.h"
#import "BKInspectorPalettesController.h"


@implementation BKInspectorsMenuExtension

- (void)declareMenuItems:(id <BKMenuControllerProtocol>)menuController {	
//  NSMenuItem *inspectorsPaletteItem = [[[NSMenuItem alloc] initWithTitle:BKLocalizedString(@"Preferences...", nil) action:@selector(showWindow:) keyEquivalent:@"i"] autorelease];
//  [preferencesItem setTarget:[BKPreferencesController sharedInstance]];
//  [menuController insertMenuItem:preferencesItem insertPath:@"/Application/PreferencesGroup"];
//  [menuController declareMenuItem:preferencesItem menuItemPath:@"/Application/PreferencesItem"];
}

- (void)menuController:(id <BKMenuControllerProtocol>)menuController addedItem:(NSMenuItem *)menuItem {
}

- (void)menuControllerFinishedLoadingMenu:(id <BKMenuControllerProtocol>)menuController {
}

@end
