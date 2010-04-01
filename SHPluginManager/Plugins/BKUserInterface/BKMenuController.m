//
//  BKMenuController.m
//  Blocks
//
//  Created by Jesse Grosjean on 1/6/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKMenuController.h"
#import "BKPluginRegistry.h"
#import "BKExtension.h"


static NSString *BKInsertPathKey = @"path";
static NSString *BKMenuItemKey = @"item";
static NSString *BKExtensionKey = @"extension";
static NSString *BKExtensionDelareOrderKey = @"order";

@interface BKMenuController (BKPrivate)
NSComparisonResult sortMenuItemAndPathByPath(id dictionary1, id dictionary2, void *context);
- (void)addMenuItem:(NSMenuItem *)menuItem path:(NSString *)path menuContributer:(id <BKMenuContributerProtocol>)menuContributer;
@end

@implementation BKMenuController

#pragma mark init

- (id)initWithMenu:(NSMenu *)menu view:(NSView *)view event:(NSEvent *)event extensionPoint:(NSString *)extensionPoint {
    if (self = [super init]) {
		fMenu = [menu retain];
		fView = [view retain];
		fEvent = [event retain];
		fExtensionPoint = [extensionPoint retain];
		fPathToMenuLookup = [[NSMutableDictionary alloc] init];
		fPathToMenuItemLookup = [[NSMutableDictionary alloc] init];
		[self declareMenu:menu menuPath:@"/"];
    }
    return self;
}

#pragma mark dealloc

- (void)dealloc {
    [fMenu release];
	[fView release];
	[fEvent release];
    [fExtensionPoint release];
    [fPathToMenuLookup release];
	[fPathToMenuItemLookup release];
	[fDeclaredMenuItems release];
    [super dealloc];
}

#pragma mark accessors

- (NSMenu *)menu {
    return fMenu;
}

- (NSView *)view {
	return fView;
}

- (NSEvent *)event {
	return fEvent;
}

- (NSString *)extensionPoint {
    return fExtensionPoint;
}

#pragma mark associating paths with menus

- (void)declareMenuItem:(NSMenuItem *)menuItem menuItemPath:(NSString *)path {
	
	if (menuItem != nil && path != nil) {
		[fPathToMenuItemLookup setObject:menuItem forKey:path];	
	} else {
		logError(@"declaredMenuItem and path must not be nil");
	}
}

- (void)declareGroupItem:(NSMenuItem *)menuItem groupPath:(NSString *)path {
	logAssert([menuItem isSeparatorItem], ([NSString stringWithFormat:@"menuItem %@ declared as group but isn't separator item, all items declared as group must be separator items.", menuItem]));
	
	if (menuItem != nil && path != nil) {
		[menuItem setRepresentedObject:[path lastPathComponent]];
	} else {
		logError(@"declaredMenuItem and path must not be nil");
	}
}

- (void)declareMenu:(NSMenu *)menu menuPath:(NSString *)path {
	if (menu != nil && path != nil) {
		[fPathToMenuLookup setObject:menu forKey:path];
	} else {
		logError(@"declaredMenu and path must not be nil");
	}
}

- (void)insertMenuItem:(NSMenuItem *)menuItem insertPath:(NSString *)path {
	[fDeclaredMenuItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:
		menuItem, BKMenuItemKey, 
		path, BKInsertPathKey, 
		fCurrentLoadingExtension, BKExtensionKey, 
		[NSNumber numberWithInt:fDeclaredMenuItemOrder++] ,BKExtensionDelareOrderKey, nil]];
}

- (NSMenu *)menuForMenuPath:(NSString *)menuPath {
	return [fPathToMenuLookup objectForKey:menuPath];
}

- (NSString *)menuPathForMenu:(NSMenu *)menu {
	NSEnumerator *keyEnumerator = [fPathToMenuLookup keyEnumerator];
	NSString *each;
	
	while (each = [keyEnumerator nextObject]) {
		if (menu == [self menuForMenuPath:each]) {
			return each;
		}
	}
	
	return nil;
}

- (NSMenuItem *)menuItemForMenuItemPath:(NSString *)menuPath {
	return [fPathToMenuItemLookup objectForKey:menuPath];
}

- (NSString *)menuItemPathForMenuItem:(NSMenuItem *)menuItem {
	NSEnumerator *keyEnumerator = [fPathToMenuItemLookup keyEnumerator];
	NSString *each;
	
	while (each = [keyEnumerator nextObject]) {
		if (menuItem == [self menuItemForMenuItemPath:each]) {
			return each;
		}
	}
	
	return nil;
}

- (void)loadMenuContributers {
	fDeclaredMenuItems = [[NSMutableArray alloc] init];
	fCurrentLoadingExtension = nil;
	fDeclaredMenuItemOrder = 0;

	// get declared items from extensions
    BKPluginRegistry *pluginRegistery = [BKPluginRegistry sharedInstance];
    NSEnumerator *extensionEnumerator = [[pluginRegistery loadedValidOrderedExtensionsFor:[self extensionPoint] protocol:@protocol(BKMenuContributerProtocol)] objectEnumerator];
	
    while (fCurrentLoadingExtension = [extensionEnumerator nextObject]) {
		[[fCurrentLoadingExtension extensionInstance] declareMenuItems:self];
	}

	// sort declared items
	[fDeclaredMenuItems sortUsingFunction:&sortMenuItemAndPathByPath context:nil];

	// build menu from declared items
	NSEnumerator *itemEnumerator = [fDeclaredMenuItems objectEnumerator];
    NSDictionary *eachItemDeclaration;
    
    while (eachItemDeclaration = [itemEnumerator nextObject]) {
		[self addMenuItem:[eachItemDeclaration objectForKey:BKMenuItemKey] path:[eachItemDeclaration objectForKey:BKInsertPathKey] menuContributer:[[eachItemDeclaration objectForKey:BKExtensionKey] extensionInstance]];
    }

	// let extensions post process loaded menu
	extensionEnumerator = [[pluginRegistery loadedValidOrderedExtensionsFor:[self extensionPoint] protocol:@protocol(BKMenuContributerProtocol)] objectEnumerator];
	
    while (fCurrentLoadingExtension = [extensionEnumerator nextObject]) {
		[[fCurrentLoadingExtension extensionInstance] menuControllerFinishedLoadingMenu:self];
	}

	fCurrentLoadingExtension = nil;
	[fDeclaredMenuItems release];
	fDeclaredMenuItems = nil;
}

- (void)printMenuPathsToConsole:(NSMenu *)menu indent:(NSString *)indent {
	NSString *menuPath = [self menuPathForMenu:menu];
	NSLog(@"%@%@ Menu (%@)", indent, [menu title], menuPath);
	indent = [indent stringByAppendingString:@"	"];
	
	NSEnumerator *enumerator = [[menu itemArray] objectEnumerator];
	NSMenuItem *each;
	
	while (each = [enumerator nextObject]) {
		NSString *menuItemPath = [self menuItemPathForMenuItem:each];
		
		if ([each isSeparatorItem]) {
			NSLog(@"%@%@ Separator (%@)", indent, [each representedObject], menuItemPath);
		} else {
			NSLog(@"%@%@ Item (%@)", indent, [each title], menuItemPath);
		}
		
		if ([each submenu]) {
			[self printMenuPathsToConsole:[each submenu] indent:indent];
		}
	}
}

#pragma mark private

NSComparisonResult sortMenuItemAndPathByPath(id dictionary1, id dictionary2, void *context) {
    NSString *path1 = [dictionary1 objectForKey:BKInsertPathKey];
    NSString *path2 = [dictionary2 objectForKey:BKInsertPathKey];
    
    int length1 = [[path1 pathComponents] count];
    int length2 = [[path2 pathComponents] count];
    
    if (length1 < length2) {
		return NSOrderedAscending;
    } else if (length1 > length2) {
		return NSOrderedDescending;
    } else {
		BKExtension *extension1 = [dictionary1 objectForKey:BKExtensionKey];
		BKExtension *extension2 = [dictionary2 objectForKey:BKExtensionKey];
		
		NSComparisonResult extensionCompare = [extension1 compareDeclarationOrder:extension2];
		
		if (extensionCompare == NSOrderedSame) {
			return [(NSNumber *)[dictionary1 objectForKey:BKExtensionDelareOrderKey] compare:[dictionary2 objectForKey:BKExtensionDelareOrderKey]];
		} else {
			return extensionCompare;
		}
    }
}

- (void)addMenuItem:(NSMenuItem *)menuItem path:(NSString *)path menuContributer:(id <BKMenuContributerProtocol>)menuContributer {
    NSString *menuPath = [path stringByDeletingLastPathComponent];
    NSMenu *menu = [self menuForMenuPath:menuPath];
	
	if (!menu) {
		logError(([NSString stringWithFormat:@"failed to find menu for path %@ skipping menu item %@", menuPath, menuItem]));
		return;
	}
	
    NSString *namedGroup = [[path lastPathComponent] stringByDeletingPathExtension];
	NSRange namedGroupRange = [menu rangeOfNamedGroup:namedGroup useAdditionsGroupIfNoNamedGroup:YES createAdditionsGroupIfNeeded:YES];
    NSString *groupOffsetString = [path pathExtension];    
    int groupOffset = [groupOffsetString intValue];
    
	if (groupOffset < 0) {
		groupOffset = namedGroupRange.length + (groupOffset + 1); // -1 insert last, -2 insert second to last.
	}
	
    if (groupOffset > namedGroupRange.length || [groupOffsetString length] == 0) {
		groupOffset = namedGroupRange.length;
    }

    [menu insertItem:menuItem atIndex:namedGroupRange.location + groupOffset];
	[menuContributer menuController:self addedItem:menuItem];
}

@end