//
//  SKTDecorator_Bezier.m
//  BlakeLoader2
//
//  Created by steve hooley on 22/09/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "SKTDecorator_Bezier.h"
#import "SKTBezier.h"


@implementation SKTDecorator_Bezier

- (void)drawContentsInView:(NSView *)view preferredRepresentation:(enum SKTGraphicDrawingMode)preferredRepresentation {
	
	NSLog(@"SKTDecorator_Bezier");
//	[_originalGraphic drawContentsInView:view preferredRepresentation:preferredRepresentation];
	
	NSRect drawingBnds = [_originalGraphic drawingBounds];
	[[NSColor greenColor] set];
	
	[[(SKTBezier *)_originalGraphic path] setLineWidth:1];
	[[(SKTBezier *)_originalGraphic path] stroke];
	
	NSArray *cntrlPts = [_originalGraphic controlPts];

	for( NSValue *eachPt in cntrlPts ){
		NSPoint pt = [eachPt pointValue];
		NSLog(@"Draw Bez pt at %@", NSStringFromPoint(pt));
		[self drawHandleInView:view atPoint:pt];
	}
	
//	NSFrameRect(drawingBnds);
	
	// draw a little sq in each corner
//    [self drawHandleInView:view atPoint:NSMakePoint(NSMinX(drawingBnds), NSMinY(drawingBnds))];
//    [self drawHandleInView:view atPoint:NSMakePoint(NSMidX(drawingBnds), NSMinY(drawingBnds))];
//    [self drawHandleInView:view atPoint:NSMakePoint(NSMaxX(drawingBnds), NSMinY(drawingBnds))];
//    [self drawHandleInView:view atPoint:NSMakePoint(NSMinX(drawingBnds), NSMidY(drawingBnds))];
//    [self drawHandleInView:view atPoint:NSMakePoint(NSMaxX(drawingBnds), NSMidY(drawingBnds))];
//    [self drawHandleInView:view atPoint:NSMakePoint(NSMinX(drawingBnds), NSMaxY(drawingBnds))];
//    [self drawHandleInView:view atPoint:NSMakePoint(NSMidX(drawingBnds), NSMaxY(drawingBnds))];
//    [self drawHandleInView:view atPoint:NSMakePoint(NSMaxX(drawingBnds), NSMaxY(drawingBnds))];
}

- (NSRect)drawingBounds {
	
	NSRect drawingBnds = [_originalGraphic drawingBounds];
    NSRect drawingBounds = NSInsetRect( drawingBnds, -4.0, -4.0 );
	return drawingBounds;
}

@end
