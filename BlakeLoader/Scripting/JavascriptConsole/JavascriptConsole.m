//
//  JavascriptConsole.m
//  BlakeLoader2
//
//  Created by steve hooley on 14/10/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "JavascriptConsole.h"


@implementation JavascriptConsole

- (void)installViewMenuItem 
{
	NSMenu *winMenu = [[NSApplication sharedApplication] windowsMenu];
	NSMenuItem *newItem = [winMenu insertItemWithTitle:@"JavascriptConsole" action:@selector(showWindow:) keyEquivalent:@"" atIndex:4];
	[newItem setTarget:self];
}

- (void)showWindow:(id)sender {
	
	NSLog(@"Yay hey! - showing JavascriptConsole");
	NSWindow *newWindow = [[NSWindow alloc] initWithContentRect:NSMakeRect(150, 150, 300, 300) styleMask:NSTitledWindowMask backing: NSBackingStoreBuffered defer:NO];
	[newWindow makeKeyAndOrderFront:self];
}
// use validateUserInterfaceItem
- (BOOL)validateMenuItem:(NSMenuItem *)item {
    
    // int row = [tableView selectedRow];
    // if ([item action] == @selector(nextRecord) && (row == [countryKeys indexOfObject:[countryKeys lastObject]])) {
        return NO;
    // }
    // if ([item action] == @selector(priorRecord) && row == 0) {
    //     return NO;
    // }
    // return YES;
}
@end
