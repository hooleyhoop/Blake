//
//  BKMenuController.h
//  Blocks
//
//  Created by Jesse Grosjean on 1/6/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Blocks/Blocks.h>
#import "BKApplicationProtocols.h"
#import "BKUserInterfaceProtocols.h"


@interface BKMenuController : NSObject <BKMenuControllerProtocol> {
    NSMenu *fMenu;
	NSView *fView;
	NSEvent *fEvent;
    NSString *fExtensionPoint;
    NSMutableDictionary *fPathToMenuLookup;
    NSMutableDictionary *fPathToMenuItemLookup;
	
	BKExtension *fCurrentLoadingExtension;
	NSMutableArray *fDeclaredMenuItems;
	int fDeclaredMenuItemOrder;
}

#pragma mark init

- (id)initWithMenu:(NSMenu *)menu view:(NSView *)view event:(NSEvent *)event extensionPoint:(NSString *)extensionPoint;

#pragma mark accessors

- (NSMenu *)menu;
- (NSView *)view;
- (NSEvent *)event;
- (NSString *)extensionPoint;

#pragma mark associating paths with menus

- (void)declareMenuItem:(NSMenuItem *)menuItem menuItemPath:(NSString *)path;
- (void)declareGroupItem:(NSMenuItem *)menuItem groupPath:(NSString *)path;
- (void)declareMenu:(NSMenu *)menu menuPath:(NSString *)path;
- (void)insertMenuItem:(NSMenuItem *)menuItem insertPath:(NSString *)path;
- (NSMenu *)menuForMenuPath:(NSString *)menuPath;
- (NSString *)menuPathForMenu:(NSMenu *)menu;
- (NSMenuItem *)menuItemForMenuItemPath:(NSString *)menuPath;
- (NSString *)menuItemPathForMenuItem:(NSMenuItem *)menuItem;
- (void)loadMenuContributers;
- (void)printMenuPathsToConsole:(NSMenu *)menu indent:(NSString *)indent;

@end