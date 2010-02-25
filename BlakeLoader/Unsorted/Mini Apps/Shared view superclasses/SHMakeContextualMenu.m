//
//  SHMakeContextualMenu.m
//  InterfaceTest
//
//  Created by Steve Hooley on Wed May 19 2004.
//  Copyright (c) 2004 HooleyHoop. All rights reserved.
//

#import "SHMakeContextualMenu.h"
//#import "SHCustomViewProtocol.h";


@implementation SHMakeContextualMenu



/*
 * make the standard contextual menu for
 * the basic swapable view
*/
+ (void) makeContextualMenu: (NSMenu*)contextualMenu on:(id<SHCustomViewProtocol>)aView
{
	NSMenuItem      *item1;
	contextualMenu  = [[NSMenu alloc]initWithTitle:@"View"];
	item1           = [[NSMenuItem alloc]init];
	[item1 setTitle: @"Zoom In"];
	[item1 setTarget: self];
	[item1 setAction: @selector(zoomIn)];
	[contextualMenu addItem: item1]; // The item is retained by the menu
	// NSLog(@"Retain Count %i", [item retainCount]);
	[item1 release];

	NSMenuItem      *item2;
	item2           = [[NSMenuItem alloc]init];
	[item2 setTitle: @"Zoom Out"];
	[item2 setTarget: self];
	[item2 setAction: @selector(zoomOut)];
	[contextualMenu addItem: item2]; // The item is retained by the menu
	// NSLog(@"Retain Count %i", [item retainCount]);
	[item2 release];

	NSMenuItem      *item3;
	item3           = [[NSMenuItem alloc]init];
	[item3 setTitle: @"Reset Zoom"];
	[item3 setTarget: self];
	[item3 setAction: @selector(resetZoom)];

	// SEL setWidthHeight;
	// setWidthHeight = @selector(setWidth:height:);

	[contextualMenu addItem: item3]; // The item is retained by the menu
	// NSLog(@"Retain Count %i", [item retainCount]);
	[item3 release];

	[(NSView*)aView setMenu: contextualMenu]; // The menu is retained by the view
	// [menu setMenuBarVisible:YES];
	[contextualMenu setAutoenablesItems:NO];
	[contextualMenu release];
}



@end
