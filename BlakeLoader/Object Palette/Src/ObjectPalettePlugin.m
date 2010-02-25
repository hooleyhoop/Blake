//
//  ObjectPalettePlugin.m
//  BlakeLoader2
//
//  Created by steve hooley on 26/11/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "ObjectPalettePlugin.h"
#import "ObjectPaletteWindowController.h"
#import "SHNodeRegister.h"



static NSString *_menuItemTitle = @"Object Palette";

@implementation ObjectPalettePlugin

@synthesize winController = _winController;

+ (NSMenuItem *)menuItem {
	
	NSMenu *winMenu = [[NSApplication sharedApplication] windowsMenu];
	NSMenuItem *mi = [winMenu itemWithTitle:_menuItemTitle];
	NSAssert( mi!=nil, @"bah" );
	return mi;
}

- (void)installViewMenuItem  {

	NSMenu *winMenu = [[NSApplication sharedApplication] windowsMenu];
	NSMenuItem *newItem = [winMenu insertItemWithTitle:_menuItemTitle action:@selector(showWindow:) keyEquivalent:@"" atIndex:4];
	[newItem setTarget:self];
}

- (void)dealloc {
	
	//! Bah, i hate singletons. Where is a good place to do this? eh?
	[SHNodeRegister cleanUpSharedNodeRegister];
	
	[super dealloc];
}

- (void)showWindow:(id)sender {

	if( self.winController==nil ) {
	
		Class winCClass = [ObjectPaletteWindowController class];
		SHWindowController* newWindowController = [[[winCClass alloc] initWithWindowNibName:[winCClass nibName]] autorelease];
		self.winController = (ObjectPaletteWindowController *)newWindowController;
		int ox = 0;
		int oy = 0;
		[newWindowController.window setFrame:NSMakeRect(ox, oy, 266,404) display:NO animate:NO];
		[newWindowController showWindow:self];
		// [newWindowController performSelector:@selector(showWindow:) withObject:self afterDelay:1.3];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMainWindowWillClose:) name:NSWindowWillCloseNotification object:[self.winController window]];
		
		// -- add a tick to the menu item
		[[[self class] menuItem] setState: NSOnState];
	} else {
		
		// -- we need to close the window
		NSWindow *win = self.winController.window;
		[win close];
	}
}

- (void)handleMainWindowWillClose:(NSNotification*)theNotification {

	NSAssert(self.winController, @"Doh!");
	
	// if the window is closed by the user using cmd-w or the close button on the window
	// release the window controller
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowWillCloseNotification object:[self.winController window]];
	self.winController = nil;
	[[[self class] menuItem] setState: NSOffState];
}
// use validateUserInterfaceItem
- (BOOL)validateMenuItem:(NSMenuItem *)item {
    
    // int row = [tableView selectedRow];
    // if ([item action] == @selector(nextRecord) && (row == [countryKeys indexOfObject:[countryKeys lastObject]])) {
    // return NO;
    // }
    // if ([item action] == @selector(priorRecord) && row == 0) {
    //     return NO;
    // }
	return YES;
}

#pragma mark accessor methods
- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
	return @"Object Palette";
}

@end
