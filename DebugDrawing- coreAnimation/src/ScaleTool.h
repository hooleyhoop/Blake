//
//  ScaleTool.h
//  DebugDrawing
//
//  Created by steve hooley on 08/11/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Widget_protocol.h"
#import "Tool.h"

@class SelectedItem;

@interface ScaleTool : Tool <Widget_protocol>  {

    NSRect _selectedObjectsBounds, _displayBounds;
}

//- (void)scaleSelectedItemsWithEvent:(NSEvent *)event inStarView:(CALayerStarView *)view;

@end