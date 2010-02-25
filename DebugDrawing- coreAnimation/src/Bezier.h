//
//  Bezier.h
//  DebugDrawing
//
//  Created by steve hooley on 14/11/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "Graphic.h"


@interface Bezier : Graphic {

	NSBezierPath *_path;
}

@property (retain) NSBezierPath *path;

- (void)moveTo:(NSPoint)pt;
- (void)lineTo:(NSPoint)pt;
- (void)curveToTo:(NSPoint)pt controlPt:(NSPoint)cntrlPt;

@end
