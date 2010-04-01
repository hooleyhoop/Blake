//
//  BKScriptsToolbarExtension.m
//  Blocks
//
//  Created by Jesse Grosjean on 2/8/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKScriptsToolbarExtension.h"
#import "BKScriptsController.h"


@implementation BKScriptsToolbarExtension

- (void)declareToolbarItems:(id <BKToolbarControllerProtocol>)toolbarController {
	NSEnumerator *enumerator = [[[BKScriptsController sharedInstance] scriptFilePaths] objectEnumerator];
	id each;
	
	while (each = [enumerator nextObject]) {
		[toolbarController declareAllowedToolbarItemIdentifier:each selectable:NO];
	}
}

- (NSToolbarItem *)toolbarController:(id <BKToolbarControllerProtocol>)toolbarController toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
	if (![[NSFileManager defaultManager] fileExistsAtPath:itemIdentifier]) return nil;
	
	id <BKScriptsFileControllerProtocol> contributer = [[BKScriptsController sharedInstance] fileControllerFor:itemIdentifier];
	
	if (contributer) {
		NSString *scriptName = [[[[itemIdentifier lastPathComponent] stringByDeletingPathExtension] componentsSeparatedByString:@"___"] objectAtIndex:0];
		NSToolbarItem *toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier] autorelease];
		[toolbarItem setLabel:scriptName];
		[toolbarItem setToolTip:scriptName];
		[toolbarItem setPaletteLabel:scriptName];
		[toolbarItem setImage:[contributer scriptToolbarImage]];
		[toolbarItem setTarget:[BKScriptsController sharedInstance]];
		[toolbarItem setAction:@selector(scriptMenuAction:)];
		return toolbarItem;
	}
	
	return nil;
}

- (void)toolbarController:(id <BKToolbarControllerProtocol>)toolbarController toolbarWillAddItem:(NSNotification *)notification {
}

- (void)toolbarController:(id <BKToolbarControllerProtocol>)toolbarController toolbarDidRemoveItem:(NSNotification *)notification {
}

@end
