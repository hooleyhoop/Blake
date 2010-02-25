//
//  Star.h
//  DebugDrawing
//
//  Created by steve hooley on 23/09/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "Graphic.h"


@interface Star : Graphic {

	NSBezierPath *path;
}

@property (retain) NSBezierPath *path;

@end
