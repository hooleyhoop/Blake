//
//  TemporarySwapableView.m
//  BlakeLoader
//
//  Created by steve hooley on 20/03/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "TemporarySwapableView.h"


@implementation TemporarySwapableView

- (void)drawRect:(NSRect)rect {

	const NSRect *rects;
    NSInteger count;
	[[NSColor colorWithDeviceRed:0.9f green:0.9f blue:0.9f alpha:1.0f] set]; // 230 230 230
    [self getRectsBeingDrawn:&rects count:&count];

	for( NSInteger i=0; i<count; i++) {
		NSRectFill(rects[i]);
	}
}

- (BOOL)isOpaque {
	return YES;
}

- (BOOL)wantsDefaultClipping { return NO; }

- (BOOL)preservesContentDuringLiveResize { return YES; }

- (void)setFrameSize:(NSSize)newSize {

    [super setFrameSize:newSize];
 
	NSPoint frameOrigin = [self frame].origin;
	
	NSAssert( G3DCompareFloat(frameOrigin.x, 0.0f, 0.001f)==0 && G3DCompareFloat(frameOrigin.y, 0.0f, 0.001f)==0, @"eek - view has moved");
	
    // A change in size has required the view to be invalidated.
    if ([self inLiveResize])
    {
        NSRect rects[4];
        int count;
        [self getRectsExposedDuringLiveResize:rects count:&count];
        while (count-- > 0)
        {
            [self setNeedsDisplayInRect:rects[count]];
        }
    }
    else
    {
        [self setNeedsDisplay:YES];
    }
}

@end
