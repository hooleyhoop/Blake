/*
	SKTRectangle.m
	Part of the Sketch Sample Code
*/


#import "SKTRectangle.h"


@implementation SKTRectangle


- (NSBezierPath *)bezierPathForDrawing {

    NSBezierPath *path = [NSBezierPath bezierPathWithRect:[self bounds]];
    return path;
}


@end