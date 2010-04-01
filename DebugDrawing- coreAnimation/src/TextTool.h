//
//  TextTool.h
//  DebugDrawing
//
//  Created by steve hooley on 28/10/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "Tool.h"
#import "Widget_protocol.h"

@class Text, Graphic;

@interface TextTool : Tool <Widget_protocol> {

	// The graphic that is being created right now, if a graphic is being created right now (not explicitly retained, 
	// because it's always allocated and forgotten about in the same method).
    Text *_creatingGraphic;
	
	// The bounds of the marquee selection, if marquee selection is being done right now, NSZeroRect otherwise.
    NSRect _marqueeSelectionBounds;
	NSRect _dirtyRect;
	NSView *_editingView;
	Text *_editingGraphic;
    NSRect _editingViewFrame;

}

- (void)createGraphicOfClass:(Class)graphicClass withEvent:(NSEvent *)event inStarView:(CALayerStarView *)view;

- (NSView *)newEditingViewForGraphic:(Graphic *)graphic withSuperviewBounds:(NSRect)superviewBounds;
- (void)stopEditingInSketchView:(CALayerStarView *)view;
- (void)startEditingGraphic:(Graphic *)graphic inSketchView:(CALayerStarView *)view;
- (void)finalizeEditingView:(NSView *)editingView;

@end
