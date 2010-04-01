//
//  SKTTransformTool.h
//  BlakeLoader
//
//  Created by steve hooley on 09/05/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "SKTTool.h"


@interface SKTTransformTool : SKTTool {

	NSArray	*_movingGraphics;
}

- (void)selectAndTrackMouseWithEvent:(NSEvent *)event inSketchView:(SKTGraphicView *)view;
- (void)moveSelectedGraphicsWithEvent:(NSEvent *)event inSketchView:(SKTGraphicView *)view;

@end
