//
//  BKUserInterfaceController.m
//  Blocks
//
//  Created by Jesse Grosjean on 1/7/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKUserInterfaceController.h"


@implementation BKUserInterfaceController

#pragma mark class methods

+ (id)sharedInstance {
    static id sharedInstance = nil;
    if (sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

#pragma mark init

- (id)init {
    if (self = [super init]) {
    }
    return self;
}

#pragma mark dealloc

- (void)dealloc {
    [fMainMenuController release];
    [fDockMenuController release];
    [super dealloc];
}

#pragma mark accessors

- (id <BKMenuControllerProtocol>)mainMenuController {
	return fMainMenuController;
}

- (id <BKMenuControllerProtocol>)dockMenuController {
	return fDockMenuController;
}

#pragma mark extensions

- (void)initMainMenuExtension:(NSMenu *)mainMenu {
	fMainMenuController = [[NSObject BKUserInterface_createMenuController:mainMenu view:nil event:nil extensionPoint:@"uk.co.stevehooley.BKUserInterface.mainmenu"] retain];
	
    NSMenu *applicationMenu = [[mainMenu itemWithTag:100] submenu];
    [fMainMenuController declareMenu:applicationMenu menuPath:@"/Application"];
	[fMainMenuController declareMenuItem:(NSMenuItem *)[applicationMenu itemWithTag:101] menuItemPath:@"/Application/AboutItem"];
	[fMainMenuController declareGroupItem:(NSMenuItem *)[applicationMenu itemWithTag:102] groupPath:@"/Application/ServicesGroup"];
	[fMainMenuController declareMenuItem:(NSMenuItem *)[applicationMenu itemWithTag:103] menuItemPath:@"/Application/ServicesItem"];
	[fMainMenuController declareGroupItem:(NSMenuItem *)[applicationMenu itemWithTag:104] groupPath:@"/Application/HideGroup"];
	[fMainMenuController declareMenuItem:(NSMenuItem *)[applicationMenu itemWithTag:105] menuItemPath:@"/Application/HideItem"];
	[fMainMenuController declareMenuItem:(NSMenuItem *)[applicationMenu itemWithTag:106] menuItemPath:@"/Application/HideOthersItem"];
	[fMainMenuController declareMenuItem:(NSMenuItem *)[applicationMenu itemWithTag:107] menuItemPath:@"/Application/ShowAllItem"];
	[fMainMenuController declareGroupItem:(NSMenuItem *)[applicationMenu itemWithTag:108] groupPath:@"/Application/QuitGroup"];
	[fMainMenuController declareMenuItem:(NSMenuItem *)[applicationMenu itemWithTag:109] menuItemPath:@"/Application/QuitItem"];

    NSMenu *fileMenu = [[mainMenu itemWithTag:200] submenu];
    [fMainMenuController declareMenu:fileMenu menuPath:@"/File"];
	[fMainMenuController declareMenuItem:(NSMenuItem *)[fileMenu itemWithTag:201] menuItemPath:@"/File/NewItem"];
	[fMainMenuController declareMenuItem:(NSMenuItem *)[fileMenu itemWithTag:202] menuItemPath:@"/File/OpenItem"];
	[fMainMenuController declareMenuItem:(NSMenuItem *)[fileMenu itemWithTag:203] menuItemPath:@"/File/OpenRecentItem"];
	[fMainMenuController declareGroupItem:(NSMenuItem *)[fileMenu itemWithTag:204] groupPath:@"/File/CloseGroup"];
	[fMainMenuController declareMenuItem:(NSMenuItem *)[fileMenu itemWithTag:205] menuItemPath:@"/File/CloseItem"];
	[fMainMenuController declareMenuItem:(NSMenuItem *)[fileMenu itemWithTag:206] menuItemPath:@"/File/SaveItem"];
	[fMainMenuController declareMenuItem:(NSMenuItem *)[fileMenu itemWithTag:207] menuItemPath:@"/File/SaveAsItem"];
	[fMainMenuController declareMenuItem:(NSMenuItem *)[fileMenu itemWithTag:208] menuItemPath:@"/File/RevertItem"];
	[fMainMenuController declareGroupItem:(NSMenuItem *)[fileMenu itemWithTag:209] groupPath:@"/File/PageSetupGroup"];
	[fMainMenuController declareMenuItem:(NSMenuItem *)[fileMenu itemWithTag:210] menuItemPath:@"/File/PageSetupItem"];
	[fMainMenuController declareMenuItem:(NSMenuItem *)[fileMenu itemWithTag:211] menuItemPath:@"/File/PrintItem"];
	
    NSMenu *editMenu = [[mainMenu itemWithTag:300] submenu];
    [fMainMenuController declareMenu:editMenu menuPath:@"/Edit"];
	[fMainMenuController declareMenuItem:(NSMenuItem *)[editMenu itemWithTag:301] menuItemPath:@"/Edit/UndoItem"];
	[fMainMenuController declareMenuItem:(NSMenuItem *)[editMenu itemWithTag:302] menuItemPath:@"/Edit/RedoItem"];
	[fMainMenuController declareGroupItem:(NSMenuItem *)[editMenu itemWithTag:303] groupPath:@"/Edit/CutGroup"];
	[fMainMenuController declareMenuItem:(NSMenuItem *)[editMenu itemWithTag:304] menuItemPath:@"/Edit/CutItem"];
	[fMainMenuController declareMenuItem:(NSMenuItem *)[editMenu itemWithTag:305] menuItemPath:@"/Edit/CopyItem"];
	[fMainMenuController declareMenuItem:(NSMenuItem *)[editMenu itemWithTag:306] menuItemPath:@"/Edit/PasteItem"];
	[fMainMenuController declareMenuItem:(NSMenuItem *)[editMenu itemWithTag:307] menuItemPath:@"/Edit/DeleteItem"];
	[fMainMenuController declareMenuItem:(NSMenuItem *)[editMenu itemWithTag:308] menuItemPath:@"/Edit/SelectAllItem"];
	[fMainMenuController declareGroupItem:(NSMenuItem *)[editMenu itemWithTag:309] groupPath:@"/Edit/FindGroup"];
	[fMainMenuController declareMenuItem:(NSMenuItem *)[editMenu itemWithTag:310] menuItemPath:@"/Edit/FindItem"]; // fill in submenu... ???

		NSMenu *findMenu = [[editMenu itemWithTag:310] submenu];
		[fMainMenuController declareMenu:findMenu menuPath:@"/Edit/Find"];
		[fMainMenuController declareMenuItem:(NSMenuItem *)[findMenu itemWithTag:1] menuItemPath:@"/Edit/Find/FindItem"];
		[fMainMenuController declareMenuItem:(NSMenuItem *)[findMenu itemWithTag:2] menuItemPath:@"/Edit/Find/FindNextItem"];
		[fMainMenuController declareMenuItem:(NSMenuItem *)[findMenu itemWithTag:3] menuItemPath:@"/Edit/Find/FindPreviousItem"];
		[fMainMenuController declareMenuItem:(NSMenuItem *)[findMenu itemWithTag:7] menuItemPath:@"/Edit/Find/UseSelectionForFindItem"];
		[fMainMenuController declareMenuItem:(NSMenuItem *)[findMenu itemWithTag:8] menuItemPath:@"/Edit/Find/JumpToSelectionItem"];

	[fMainMenuController declareMenuItem:(NSMenuItem *)[editMenu itemWithTag:311] menuItemPath:@"/Edit/SpellingItem"]; // fill in submenu... ???
	
    NSMenu *windowMenu = [[mainMenu itemWithTag:400] submenu];
    [fMainMenuController declareMenu:windowMenu menuPath:@"/Window"];
	[fMainMenuController declareMenuItem:(NSMenuItem *)[windowMenu itemWithTag:401] menuItemPath:@"/Window/ZoomItem"];
	[fMainMenuController declareMenuItem:(NSMenuItem *)[windowMenu itemWithTag:402] menuItemPath:@"/Edit/MinimizeItem"];
	[fMainMenuController declareGroupItem:(NSMenuItem *)[windowMenu itemWithTag:403] groupPath:@"/Window/BringToFrontGroup"];
	[fMainMenuController declareMenuItem:(NSMenuItem *)[windowMenu itemWithTag:404] menuItemPath:@"/Edit/BringToFrontItem"];
	
    NSMenu *helpMenu = [[mainMenu itemWithTag:500] submenu];
    [fMainMenuController declareMenu:helpMenu menuPath:@"/Help"];
		
    [fMainMenuController loadMenuContributers];
}

- (void)initDockMenuExtension:(NSMenu *)menu {
	[fDockMenuController autorelease];
	fDockMenuController = [[NSObject BKUserInterface_createMenuController:menu view:nil event:nil extensionPoint:@"uk.co.stevehooley.BKUserInterface.dockmenu"] retain];
	[fDockMenuController loadMenuContributers];
}

@end