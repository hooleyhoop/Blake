//
//  TranslateTool.h
//  DebugDrawing
//
//  Created by steve hooley on 24/10/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "Tool.h"
#import "Widget_protocol.h"

@class ToolBarController, SelectedItem;


@interface TranslateTool : Tool <Widget_protocol> {

	NSRect _selectedObjectsBounds, _displayBounds;
    SelectedItem *_clickedOb;
}

+ (void)translateItems:(NSArray *)itemsToMove byX:(CGFloat)x byY:(CGFloat)y;

- (void)moveSelectedGraphicsWithEvent:(NSEvent *)event inMode:(int)mode inStarView:(CALayerStarView *)view;

- (void)_drawCentreRect;
- (void)_drawVerticalHandle;
- (void)_drawHorizantalHandle;

@end
