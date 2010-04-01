//
//  BKToolbarController.m
//  Blocks
//
//  Created by Jesse Grosjean on 1/7/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKToolbarController.h"


@interface BKToolbarController (BKPrivate)
- (NSEnumerator *)loadedValidOrderedToolbarExtensions;
@end

@implementation BKToolbarController

#pragma mark init

- (id)initWithWindow:(NSWindow *)window toolbar:(NSToolbar *)toolbar extensionPoint:(NSString *)extensionPoint {
	if (self = [super init]) {
		logAssert([[toolbar identifier] isEqualToString:extensionPoint], @"toolbar identifier must match extension point");
		fWindow = [window retain];
		fToolbar = [toolbar retain];
		fExtensionPoint = [extensionPoint retain];
	}
	return self;
}

#pragma mark dealloc

- (void)dealloc {
	[fToolbar setDelegate:nil];
	[fWindow release];
    [fToolbar release];
    [fExtensionPoint release];
	[fAllowedItemIdentifiers release];
	[fDefaultItemIdentifiers release];
    [super dealloc];
}

#pragma mark accessors

- (NSWindow *)window {
	return fWindow;
}

- (NSToolbar *)toolbar {
	return fToolbar;
}

- (NSString *)extensionPoint {
	return fExtensionPoint;
}

- (NSString *)allToolbarsExtensionPoint {
	return @"uk.co.stevehooley.BKUserInterface.alltoolbars";
}

#pragma mark loading extensions

- (void)declareAllowedToolbarItemIdentifier:(NSString *)itemIdentifier selectable:(BOOL)selectable {
	// 1. first remove, this allows plugins to reorder itemIdentifiers declared by other plugins.
	[fAllowedItemIdentifiers removeObject:itemIdentifier];
	[fSelectableItemIdentifiers removeObject:itemIdentifier];
	
	// 2. add itemIdentifier in order
	[fAllowedItemIdentifiers addObject:itemIdentifier];
	if (selectable) {
		[fSelectableItemIdentifiers addObject:itemIdentifier];
	}
}

- (void)declareDefaultToolbarItemIdentifier:(NSString *)itemIdentifier insertPath:(NSString *)path {
	if ([fAllowedItemIdentifiers containsObject:itemIdentifier]) {
		[fDefaultItemIdentifiers addObject:itemIdentifier];
	} else {
		logWarn(([NSString stringWithFormat:@"could not add %@ as a default toolbar item, must first declareAllowedToolbarItemIdentifier"], itemIdentifier));
	}
}

- (void)declareDefaultGroupItemIdentifier:(NSString *)itemIdentifier groupPath:(NSString *)path {
	
}

- (void)loadToolbarContributers {
	[fAllowedItemIdentifiers release];
	fAllowedItemIdentifiers = [[NSMutableArray alloc] init];
	[fDefaultItemIdentifiers release];
	fDefaultItemIdentifiers = [[NSMutableArray alloc] init];
	[fSelectableItemIdentifiers release];
	fSelectableItemIdentifiers = [[NSMutableArray alloc] init];

	// get declared items from extensions
    NSEnumerator *extensionEnumerator = [self loadedValidOrderedToolbarExtensions];
	<BKToolbarContributerProtocol> eachContributer;
	
    while (eachContributer = [[extensionEnumerator nextObject] extensionInstance]) {
		[eachContributer declareToolbarItems:self];
	}

	[self declareAllowedToolbarItemIdentifier:NSToolbarSeparatorItemIdentifier selectable:NO];
	[self declareAllowedToolbarItemIdentifier:NSToolbarSpaceItemIdentifier selectable:NO];
	[self declareAllowedToolbarItemIdentifier:NSToolbarFlexibleSpaceItemIdentifier selectable:NO];
	
	[fToolbar setDelegate:self];
}

#pragma mark toolbar delegate

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
	NSEnumerator *extensionEnumerator = [self loadedValidOrderedToolbarExtensions];
	<BKToolbarContributerProtocol> eachContributer;
	
    while (eachContributer = [[extensionEnumerator nextObject] extensionInstance]) {
		NSToolbarItem *toolbarItem = [eachContributer toolbarController:self toolbar:toolbar itemForItemIdentifier:itemIdentifier willBeInsertedIntoToolbar:flag];
		if (toolbarItem) {
			return toolbarItem;
		}
	}

	return nil;
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar*)toolbar {
	return fDefaultItemIdentifiers;
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar*)toolbar {
	return fAllowedItemIdentifiers;
}

- (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar {
	return fSelectableItemIdentifiers;
}

- (void)toolbarWillAddItem:(NSNotification *)notification {
	NSEnumerator *extensionEnumerator = [self loadedValidOrderedToolbarExtensions];
	<BKToolbarContributerProtocol> eachContributer;
	
    while (eachContributer = [[extensionEnumerator nextObject] extensionInstance]) {
		[eachContributer toolbarController:self toolbarWillAddItem:notification];
	}
}

- (void)toolbarDidRemoveItem:(NSNotification *)notification {
	NSEnumerator *extensionEnumerator = [self loadedValidOrderedToolbarExtensions];
	<BKToolbarContributerProtocol> eachContributer;
	
    while (eachContributer = [[extensionEnumerator nextObject] extensionInstance]) {
		[eachContributer toolbarController:self toolbarDidRemoveItem:notification];
	}
}

@end

@implementation BKToolbarController (BKPrivate)

- (NSEnumerator *)loadedValidOrderedToolbarExtensions {
	NSMutableArray *allExtensions = [NSMutableArray array];
	BKPluginRegistry *pluginRegistery = [BKPluginRegistry sharedInstance];
	[allExtensions addObjectsFromArray:[pluginRegistery loadedValidOrderedExtensionsFor:[self extensionPoint] protocol:@protocol(BKToolbarContributerProtocol)]];
	[allExtensions addObjectsFromArray:[pluginRegistery loadedValidOrderedExtensionsFor:[self allToolbarsExtensionPoint] protocol:@protocol(BKToolbarContributerProtocol)]];
	return [allExtensions objectEnumerator];
}

@end