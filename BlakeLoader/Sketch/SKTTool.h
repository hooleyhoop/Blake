//
//  SKTTool.h
//  BlakeLoader
//
//  Created by steve hooley on 19/05/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "SKTUserAdaptor.h"

@class SKTToolPaletteController, SKTGraphicView;


@interface SKTTool : SHooleyObject <SKTUserAdaptor> {

	SKTToolPaletteController	*_toolBarControl;
	
	NSString	*_identifier;
	NSString	*_labelString;
	NSString	*_iconPath;
	
    // The graphic that is being created right now, if a graphic is being created right now (not explicitly retained, 
	// because it's always allocated and forgotten about in the same method).
    SKTGraphic *_creatingGraphic;
	
    // The graphic that is being edited right now, the view that it gave us to present its editing interface, and the last known frame of that view, 
	// if a graphic is being edited right now. We have to record the editing view frame because when it changes we need its old value, 
	// and the old value isn't available when this view gets the NSViewFrameDidChangeNotification.
	// Also, the reserved thickness for the horizontal ruler accessory view before editing began, so we can restore it after editing is done.
	// (We could do the same for the vertical ruler, but so far in Sketch there are no vertical ruler accessory views.)
//    SKTGraphic	*_editingGraphic;	
//    NSView		*_editingView;
//    NSRect		_editingViewFrame;
}

- (id)initWithController:(SKTToolPaletteController *)value;

- (void)setUpToolbarItem:(NSToolbarItem *)item;

- (void)mouseDownEvent:(NSEvent *)event atPoint:(NSPoint)pt inSketchView:(SKTGraphicView *)view;

- (NSString *)identifier;
- (BOOL)identifierMatches:(NSString *)value;

// - (enum SKTGraphicDrawingMode)preferredDrawingStyleForGraphic:(SKTGraphic *)graphic;
- (void)willBecomeUnActive;

- (void)createGraphicOfClass:(Class)graphicClass withEvent:(NSEvent *)event inSketchView:(SKTGraphicView *)view;
- (void)resizeGraphic:(SKTGraphic *)graphic usingHandle:(NSInteger)handle withEvent:(NSEvent *)event inSketchView:(SKTGraphicView *)view;

//- (void)startEditingGraphic:(SKTGraphic *)graphic inSketchView:(SKTGraphicView *)view;
//- (SKTGraphic *)editingGraphic;
//- (void)stopEditingInSketchView:(SKTGraphicView *)view;

- (NSCursor *)defaultCursor;

@end
