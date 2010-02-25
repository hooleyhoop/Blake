//
//  KBPalettePanel.h
//  ----------------
//
//  Created by Keith Blount on 09/04/2006.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//
//	Snapping behaviour based on SnappingWindow by Matt Gemmell.
//	Window resizing based on code posted on the Cocoa-dev lists by Jan Hülsmann.
//
//	A panel that snaps to the edges of the screen and of the app's main window. Also snaps
//	to other panel palettes which can join together, and has a disclosure triangle in the title
//	bar to hide the view. Emulates the behaviour of palettes in Mellel and Omni.
//

#import <Cocoa/Cocoa.h>
#import <Blocks/Blocks.h>
#import "BKApplicationProtocols.h"


@class KBPaletteHeaderView;

#define	KBCommandKeyCharacter		0x2318

extern NSString *KBPaletteResizeIndicatorStateDidChangeNotification;

@interface KBPalettePanel : NSPanel
{
	BOOL snapsToEdges;			// whether or not the window snaps to edges
    float snapTolerance;		// distance from edge within which snapping occurs
    BOOL snapping;				// whether we're currently snapping to an edge
    NSPoint dragStartLocation;	// keeps track of last drag's mousedown point
    float padding;				// how far from the edges we snap to
	BOOL isExpanded;
	
	BOOL isResizeOperation;
	NSRect initialWindowFrame;
	BOOL titleBarIsPressed;
	float precollapsedHeight;
	BOOL windowMoved;
	
	BOOL resizeAllowed;
	
	BOOL isExpanding;
	
	NSView *innerContentView;
	KBPaletteHeaderView *headerView;
	
	KBPalettePanel *paletteToAttachTo;
	KBPalettePanel *paletteToAttach;
	
	BOOL didFinishLoading;
}

// Accessors
- (void)setExpanded:(BOOL)flag;
- (void)setExpanded:(BOOL)flag animate:(BOOL)animate;
- (BOOL)isExpanded;
- (void)setSnapsToEdges:(BOOL)flag;
- (BOOL)snapsToEdges;
- (void)setSnapTolerance:(float)tolerance;
- (float)snapTolerance;
- (void)setPadding:(float)newPadding;
- (float)padding;
- (BOOL)titleBarIsPressed;
- (KBPalettePanel *)attachedPalette;
- (NSArray *)attachedPalettes;
- (void)attachToPalette:(KBPalettePanel *)anotherPalette;
- (KBPalettePanel *)firstPaletteInGroup;
- (KBPalettePanel *)lastPaletteInGroup;
- (void)detachChildPalettes;
- (void)setIcon:(NSImage *)newIcon;
- (NSImage *)icon;
- (void)setKeyEquivalentString:(NSString *)string;
- (NSString *)keyEquivalentString;

- (void)setGroupVisible:(BOOL)isVisible;

- (NSDictionary *)configurationDictionary;
- (void)setConfigurationFromDictionary:(NSDictionary *)configurationDictionary;

@end
