//
//  ZoomTool.h
//  DebugDrawing
//
//  Created by steve hooley on 24/09/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "ViewTool.h"


@interface ZoomTool : ViewTool {
	
	id _itemToZoom;
}

- (id)initWithTarget:(id)value;

- (void)zoomFrom:(NSPoint)pt1 to:(NSPoint)pt2;

@end