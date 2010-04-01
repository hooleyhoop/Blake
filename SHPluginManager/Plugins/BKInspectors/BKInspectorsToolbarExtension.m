//
//  BKInspectorsToolbarExtension.m
//  Blocks
//
//  Created by Jesse Grosjean on 12/2/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKInspectorsToolbarExtension.h"
#import "BKInspectorPalettesController.h"


@implementation BKInspectorsToolbarExtension

- (void)declareToolbarItems:(id <BKToolbarControllerProtocol>)toolbarController {
	[toolbarController declareAllowedToolbarItemIdentifier:@"uk.co.stevehooley.BKInspectors.toolbaritem" selectable:NO];
}

- (NSToolbarItem *)toolbarController:(id <BKToolbarControllerProtocol>)toolbarController toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
	if ([itemIdentifier isEqualToString:@"uk.co.stevehooley.BKInspectors.toolbaritem"]) {
		NSToolbarItem *toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier] autorelease];
		[toolbarItem setLabel:BKLocalizedString(@"Inspect", nil)];
		[toolbarItem setToolTip:BKLocalizedString(@"Show/Hide Inspectors", nil)];
		[toolbarItem setPaletteLabel:BKLocalizedString(@"Inspect", nil)];
		[toolbarItem setImage:[NSImage imageNamed:@"ShowInspector.png" class:[self class]]];
		[toolbarItem setTarget:[BKInspectorPalettesController sharedInstance]];
		[toolbarItem setAction:@selector(toggleShowInspectorPalettes:)];
		return toolbarItem;
	}	
	return nil;
}

- (void)toolbarController:(id <BKToolbarControllerProtocol>)toolbarController toolbarWillAddItem:(NSNotification *)notification {
}

- (void)toolbarController:(id <BKToolbarControllerProtocol>)toolbarController toolbarDidRemoveItem:(NSNotification *)notification {
}

@end
