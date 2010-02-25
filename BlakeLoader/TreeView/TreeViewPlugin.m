//
//  TreeViewPlugin.m
//  BlakeLoader2
//
//  Created by steve hooley on 26/11/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "TreeViewPlugin.h"
#import "TreeViewMainWindowController.h"


@implementation TreeViewPlugin

static NSString *_menuItemTitle = @"TreeView";

- (void)installViewMenuItem 
{
	NSMenu *winMenu = [[NSApplication sharedApplication] windowsMenu];
	NSMenuItem *newItem = [winMenu insertItemWithTitle:_menuItemTitle action:@selector(showWindow:) keyEquivalent:@"" atIndex:4];
	[newItem setTarget:self];
}

- (void)showWindow:(id)sender {
	
	SHDocument *doc = [[[NSApplication sharedApplication] orderedDocuments] objectAtIndex:0];
    if( [doc hasWindowControllerOfClass:[TreeViewMainWindowController class]]==NO )
	{
		Class winCClass = [TreeViewMainWindowController class];
		SHWindowController* newWindowController = [[[winCClass alloc] initWithWindowNibName:[winCClass nibName]] autorelease];
		[doc addWindowController:newWindowController];
		[newWindowController setDocument:doc];
		/* we need the last window to close the document */
		[newWindowController setShouldCloseDocument:NO];
		[newWindowController showWindow:self];
	}
}
// use validateUserInterfaceItem
- (BOOL)validateMenuItem:(NSMenuItem *)item {
	
	SHDocument *doc = [[[NSApplication sharedApplication] orderedDocuments] objectAtIndex:0];
	if( [item action]==@selector(showWindow:) && [item target]==self ) {
		if( [doc hasWindowControllerOfClass:[TreeViewMainWindowController class]]==YES ){
			[item setState: NSOnState]; // add tick
			return NO;
		} else {
			[item setState: NSOffState]; // remove tick
			return YES;
		}
	}
	return YES;
}


@end
