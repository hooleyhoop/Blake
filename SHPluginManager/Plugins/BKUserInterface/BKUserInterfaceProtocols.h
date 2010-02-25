/*
 *  BKUserInterfaceProtocols.h
 *  Blocks
 *
 *  Created by Jesse Grosjean on 2/2/05.
 *  Copyright 2006 Hog Bay Software Hog Bay Software. All rights reserved.
 *
 */

// menus

@protocol BKMenuControllerProtocol <NSObject>

- (NSMenu *)menu;
- (NSView *)view;
- (NSEvent *)event;
- (void)declareMenuItem:(NSMenuItem *)menuItem menuItemPath:(NSString *)path;
- (void)declareGroupItem:(NSMenuItem *)menuItem groupPath:(NSString *)path;
- (void)declareMenu:(NSMenu *)menu menuPath:(NSString *)path;
- (void)insertMenuItem:(NSMenuItem *)menuItem insertPath:(NSString *)path;
- (NSMenu *)menuForMenuPath:(NSString *)menuPath;
- (NSMenuItem *)menuItemForMenuItemPath:(NSString *)menuPath;
- (void)loadMenuContributers;
- (void)printMenuPathsToConsole:(NSMenu *)menu indent:(NSString *)indent;

@end

@protocol BKMenuContributerProtocol <NSObject>

- (void)declareMenuItems:(id <BKMenuControllerProtocol>)menuController;
- (void)menuController:(id <BKMenuControllerProtocol>)menuController addedItem:(NSMenuItem *)menuItem;
- (void)menuControllerFinishedLoadingMenu:(id <BKMenuControllerProtocol>)menuController;

@end

// toolbars

@protocol BKToolbarControllerProtocol <NSObject>

- (NSWindow *)window;
- (NSToolbar *)toolbar;
- (void)declareAllowedToolbarItemIdentifier:(NSString *)itemIdentifier selectable:(BOOL)selectable;
- (void)declareDefaultToolbarItemIdentifier:(NSString *)itemIdentifier insertPath:(NSString *)path;
- (void)declareDefaultGroupItemIdentifier:(NSString *)itemIdentifier groupPath:(NSString *)path;
- (void)loadToolbarContributers;

@end

@protocol BKToolbarContributerProtocol <NSObject>

- (void)declareToolbarItems:(id <BKToolbarControllerProtocol>)toolbarController;
- (NSToolbarItem *)toolbarController:(id <BKToolbarControllerProtocol>)toolbarController toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag;
- (void)toolbarController:(id <BKToolbarControllerProtocol>)toolbarController toolbarWillAddItem:(NSNotification *)notification;
- (void)toolbarController:(id <BKToolbarControllerProtocol>)toolbarController toolbarDidRemoveItem:(NSNotification *)notification;

@end

// controller factories

@interface NSObject (BKUserInterfaceControllerFactory)

+ (id <BKMenuControllerProtocol>)BKUserInterface_createMenuController:(NSMenu *)menu view:(NSView *)view event:(NSEvent *)event extensionPoint:(NSString *)extensionPoint;
+ (id <BKToolbarControllerProtocol>)BKUserInterface_createToolbarController:(NSWindow *)window toolbar:(NSToolbar *)toolbar extensionPoint:(NSString *)extensionPoint;

@end

// standard user interface controller

@protocol BKUserInterfaceControllerProtocol <NSObject>

- (id <BKMenuControllerProtocol>)mainMenuController;
- (id <BKMenuControllerProtocol>)dockMenuController;

@end

@interface NSApplication (BKUserInterfaceControllerProtocolAccess)

- (id <BKUserInterfaceControllerProtocol>)BKUserInterfaceProtocols_userInterfaceController; // exposed this way for applescript support

@end