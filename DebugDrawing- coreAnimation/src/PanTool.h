//
//  PanTool.h
//  DebugDrawing
//
//  Created by steve hooley on 23/09/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "ViewTool.h"


@interface PanTool : ViewTool {

	id _itemToPan;
}

- (id)initWithTarget:(id)value;

- (void)panByX:(CGFloat)xVal y:(CGFloat)yVal;

@end