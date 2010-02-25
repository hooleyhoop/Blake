//
//  EdgeMoveTool.h
//  DebugDrawing
//
//  Created by steve hooley on 28/10/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "Tool.h"
#import "Widget_protocol.h"
@class SelectedItem;

@interface EdgeMoveTool : Tool <Widget_protocol> {
	
	int _edgeToDraw;
	SelectedItem *_ownerOfEdgeToDraw;
	NSRect _displayBounds;

}


- (void)moveEdge:(int)edge of:(SelectedItem *)item withEvent:(NSEvent *)event inStarView:(CALayerStarView *)view;

@end
