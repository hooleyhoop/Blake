//
//  SHAppControl.h
//  InterfaceTest
//
//  Created by Steve Hool on Fri Dec 26 2003.
//  Copyright (c) 2003 HooleyHoop. All rights reserved.
//


@class SHAppControl;


@interface SHAppControl : SHooleyObject
{

	IBOutlet SHAppModel			*_theSHAppModel;
	IBOutlet SHAppView			*_theSHAppView;
	
	IBOutlet SHAuxWindow		*_newestWindow;
	
	NSMutableArray				*_auxWindows;
//	IBOutlet id<CustomViewProtocol>	anSHObjPaletteView, anPropertyInspectorView, anOutputView, anScriptView;
	
}

#pragma mark -
#pragma mark class methods
+ (SHAppControl*)appControl;

#pragma mark init methods
- (id)init;

#pragma mark NSApplication delegate methods

#pragma mark action methods
- (void)launchInOwnWindow:(SHCustomViewController*)aViewController;

// when you load a graph the views wont have the right data..
- (void)syncAllViewsWithModel;

- (void)updateAllViewPorts;

- (void)disableOpenViews;
- (void)enableOpenViews;

- (void)spawnWindow;

- (IBAction)newRootNode:(id)sender;
- (IBAction)closeRootNode:(id)sender;

- (void)windowAdded:(NSWindow*)aWindow;
- (void)windowClosed:(NSWindow*)aWindow;

- (void)testFScript;

#pragma mark accessor methods
- (SHAppModel *)theSHAppModel;
- (void)setTheSHAppModel:(SHAppModel *)a_theSHAppModel;

- (SHAppView *)theSHAppView;
- (void)setTheSHAppView:(SHAppView *)a_theSHAppView;

- (SHAuxWindow *)newestWindow;
- (void)setNewestWindow:(SHAuxWindow *)a_window;

- (NSMutableArray *)auxWindows;
- (void)setAuxWindows: (NSMutableArray *)anAuxWindows;


@end
