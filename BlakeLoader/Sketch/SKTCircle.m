/*
	SKTCircle.m
	Part of the Sketch Sample Code
*/


#import "SKTCircle.h"


@implementation SKTCircle

- (NSBezierPath *)bezierPathForDrawing {
    
    NSBezierPath *path = [NSBezierPath bezierPathWithOvalInRect:[self bounds]];
    return path;
}

- (BOOL)isContentsUnderPoint:(NSPoint)point {
    
    return [[self bezierPathForDrawing] containsPoint:point];
}

@end