//
//  SHAppView.h
//  InterfaceTest
//
//  Created by Steve Hool on Fri Dec 26 2003.
//  Copyright (c) 2003 HooleyHoop. All rights reserved.
//
// #import "SHViewControllerProtocol.h"

@class SHAppControl, SHMainWindow, SHViewport, OutputView, OutputControl;
@class SHSwapableView, SHCustomViewController;


/*
 * SHAppView has a number of SHViewports. Each has
 * a menubarView and a swapable view.
 *
*/
/***** FROM NOW ON, the MainView Manager!!!!!   ***/ 

@interface SHAppView : SHooleyObject 
{
    IBOutlet SHAppControl		*_theSHAppControl;
    IBOutlet SHMainWindow		*_theMainWindow;

	NSMutableDictionary			*_theWindows;
			
	IBOutlet NSView				*_theAppLeftPanel, *_theAppStatusBar;
	IBOutlet NSSplitView		*_theSplitViewLevelOne_TopAndBottom, *_theSplitViewLevelTwoTop_LeftRight, *_theSplitViewLevelTwoBottom_LeftRight;
	
	// links to the SHViewports (4 max)
	IBOutlet SHViewport			*_SHViewportTL, *_SHViewportTR, *_SHViewportBL, *_SHViewportBR;
    SHViewport					*_currentSHViewport; 
    NSMutableDictionary			*_SHViewports;
    BOOL						_singleViewFlag, _fourViewFlag;
	
	
}

#pragma mark -
#pragma mark class methods
+ (SHAppView*)appView;

#pragma mark init methods
// - (id)initWithController:(SHAppControl*)controlArg;
- (id)init;

// - (SHAppView *)initWithFrame:(NSRect)frameRect Control: (SHAppControl*)controlArg;



#pragma mark action methods
- (void)setSHViewport:(NSString*)viewSpecifier withContent:(SHCustomViewController*) aViewController;

- (void)layOutAtNewSize;

- (void)setSingleView;

- (void)setFourView;

- (NSWindow *) theWindowNamed:(NSString*)windowName;

- (void)resizeAllViews;

 - (void)layOutQuadView;

 - (void)layOutSingleView;

- (void)removeSHViewports;

- (void) updateAllViewPorts;

#pragma mark accessor methods
- (SHMainWindow *) theMainWindow;
- (void) setTheMainWindow: (SHMainWindow *) aTheMainWindow;

- (SHAppControl *)theSHAppControl;
- (void)setTheSHAppControl:(SHAppControl *)a_theSHAppControl;

- (NSMutableDictionary*) SHViewports;



@end



