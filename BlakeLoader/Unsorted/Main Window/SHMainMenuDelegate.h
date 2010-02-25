//
//  SHMainMenuDelegate.h
//  Pharm
//
//  Created by Steve Hooley on 20/02/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

// Instantiated in the nib
@interface SHMainMenuDelegate : SHooleyObject {
	
	BOOL				_isBound;
	IBOutlet NSMenu*	_nodeGraphMenu;
}

#pragma mark -
#pragma mark class methods
#pragma mark init methods
- (void)initBindings;

#pragma mark action methods

// the menu delegates seem good for doing dynamic menus

- (int)numberOfItemsInMenu:(NSMenu *)menu;
// Called when a menu is about to be displayed at the start of a tracking session so the delegate can specify the number of items in the menu.

// Populating a menu
- (BOOL)menu:(NSMenu *)menu updateItem:(NSMenuItem *)item atIndex:(int)index shouldCancel:(BOOL)shouldCancel;
// Called to let you update a menu item before it is displayed.

- (void)menuNeedsUpdate:(NSMenu *)menu;
// Called when a menu is about to be displayed at the start of a tracking session so the delegate can modify the menu.

// Handling key equivalents
- (BOOL)menuHasKeyEquivalent:(NSMenu *)menu forEvent:(NSEvent *)event target:(id *)target action:(SEL *)action;

- (IBAction)moveUp:(id)sender;
- (IBAction)moveDown:(id)sender;

- (IBAction)groupSelected:(id)sender;
- (IBAction)unGroupSelected:(id)sender;

- (IBAction)deleteNode:(id)sender;

- (IBAction)execute:(id)sender;
- (IBAction)play:(id)sender;
- (IBAction)stop:(id)sender;

@end
