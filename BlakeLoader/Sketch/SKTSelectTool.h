//
//  SKTSelectTool.h
//  BlakeLoader
//
//  Created by steve hooley on 09/05/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "SKTTool.h"

@interface SKTSelectTool : SKTTool {

	// The bounds of the marquee selection, if marquee selection is being done right now, NSZeroRect otherwise.
    NSRect _marqueeSelectionBounds;
	NSRect _drawingBounds;
}

- (void)selectAndTrackMouseWithEvent:(NSEvent *)event inSketchView:(SKTGraphicView *)view;

- (void)marqueeSelectWithEvent:(NSEvent *)event inSketchView:(SKTGraphicView *)view;

@end
