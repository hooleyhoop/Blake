//
//  SHCircle.m
//  BlakeLoader
//
//  Created by steve hooley on 09/05/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "SHCircle.h"


@implementation SHCircle

//- (NSRect)drawingBounds {
//
//    // Assume that -[SKTGraphic drawContentsInView:] and -[SKTGraphic drawHandlesInView:] will be doing the drawing. Start with the plain bounds of the graphic, then take drawing of handles at the corners of the bounds into account, then optional stroke drawing.
//    CGFloat outset = SKTGraphicHandleHalfWidth;
//    if ([self isDrawingStroke]) {
//		CGFloat strokeOutset = [self strokeWidth] / 2.0f;
//		if (strokeOutset>outset) {
//			outset = strokeOutset;
//		}
//    }
//    CGFloat inset = 0.0f - outset;
//    NSRect drawingBounds = NSInsetRect([self bounds], inset, inset);
//    
//    // -drawHandleInView:atPoint: draws a one-unit drop shadow too.
//    drawingBounds.size.width += 1.0f;
//    drawingBounds.size.height += 1.0f;
//    return drawingBounds;
//
//}

//- (void)setBounds:(NSRect)bounds {
//
//    _bounds = bounds;
//}

@end
