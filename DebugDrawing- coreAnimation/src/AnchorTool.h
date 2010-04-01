//
//  AnchorTool.h
//  DebugDrawing
//
//  Created by steve hooley on 06/11/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "Tool.h"
#import "Widget_protocol.h"

@class SelectedItem;

@interface AnchorTool : Tool <Widget_protocol> {

    NSRect			_selectedObjectsBounds, _displayBounds;
    SelectedItem	*_ownerOfAnchor;
	int				_clickHandle;
}

- (void)_drawAnchor:(SelectedItem *)each;

@end