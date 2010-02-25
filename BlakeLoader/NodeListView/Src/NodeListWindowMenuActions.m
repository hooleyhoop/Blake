//
//  NodeListWindowMenuActions.m
//  BlakeLoader2
//
//  Created by steve hooley on 06/01/2010.
//  Copyright 2010 BestBefore Ltd. All rights reserved.
//

#import "NodeListWindowMenuActions.h"


@implementation NodeListWindowMenuActions

/* See if WindowController is in the responder chain? Test this shit */
- (BOOL)validateUserInterfaceItem:(id<NSValidatedUserInterfaceItem>)menuItem {
	
	// logInfo(@"Blake Command Centre: validateUserInterfaceItem %@", NSStringFromSelector([menuItem action]));
	BOOL validItem = NO;
	SEL userInterfaceItem = [menuItem action];
	
	/* File Menu */	
	if (userInterfaceItem == @selector(selectAllChildren:)) {
		// validItem = [self canSelectAllChildren];
		NSLog(@"woo yeh");
	} 	
	return validItem;
}

//TODO: 
/* Seems like it is.. great. Now add a test so it stays that way! */
- (IBAction)selectAllChildren:(id)sender {
	
	NSLog(@"This looks ok");
}

@end
