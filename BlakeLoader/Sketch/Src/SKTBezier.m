//
//  SKTBezier.m
//  BlakeLoader2
//
//  Created by steve hooley on 19/09/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "SKTBezier.h"


@implementation SKTBezier

@synthesize path = _path;

- (id)init {
	
    self = [super init];
    if (self) {
		self.path = [NSBezierPath bezierPath];
    }
    return self;
}

- (void)dealloc {
	
	self.path = nil;
    [super dealloc];
}

- (void)moveToPoint:(NSPoint)value {
    
    [_path moveToPoint:value];
}

- (void)lineToPoint:(NSPoint)value {

    [_path lineToPoint:value];
}

- (void)closePath {
	[_path closePath];
}

- (void)drawContentsInView:(NSView *)view preferredRepresentation:(enum SKTGraphicDrawingMode)preferredRepresentation {
		
	NSLog(@"Drawing bezier");
	[super drawContentsInView:view preferredRepresentation:preferredRepresentation];
}

- (NSBezierPath *)bezierPathForDrawing {
    	
	/* The path needs to be within the current bounds */
//	float x = NSMaxX([self bounds]);
//	float y = NSMaxY([self bounds]);
//	float maxx = 500.0;
//	float maxy = 160.0;
//	
//	NSBezierPath *path = [NSBezierPath bezierPath];
//	[path moveToPoint: NSMakePoint(451.9229/maxx*x, 140.4619/maxy*y)];
//	[path lineToPoint: NSMakePoint(260.8159/maxx*x, 140.4619/maxy*y)];
//	[path curveToPoint: NSMakePoint(235.7178/maxx*x, 153.9248/maxy*y) controlPoint1:	NSMakePoint(255.4175/maxx*x, 148.5752/maxy*y) controlPoint2:	NSMakePoint(246.1938/maxx*x, 153.9248/maxy*y)];
//	[path curveToPoint: NSMakePoint(210.6196/maxx*x, 140.4619/maxy*y) controlPoint1:	NSMakePoint(225.2417/maxx*x, 153.9248/maxy*y) controlPoint2:	NSMakePoint(216.0181/maxx*x, 148.5752/maxy*y)];
//	[path lineToPoint: NSMakePoint(20.7949/maxx*x, 140.4619/maxy*y)];
//	[path curveToPoint: NSMakePoint(8.79492/maxx*x, 128.4619/maxy*y) controlPoint1:	NSMakePoint(14.1675/maxx*x, 140.4619/maxy*y) controlPoint2:	NSMakePoint(8.79492/maxx*x, 135.0889/maxy*y)];
//	[path lineToPoint: NSMakePoint(8.79492/maxx*x, 50.5381/maxy*y)];
//	[path curveToPoint: NSMakePoint(20.7949/maxx*x, 38.5381/maxy*y) controlPoint1:	NSMakePoint(8.79492/maxx*x, 43.9111/maxy*y) controlPoint2:	NSMakePoint(14.1675/maxx*x, 38.5381/maxy*y)];
//	[path lineToPoint: NSMakePoint(216.8979/maxx*x, 38.5381/maxy*y)];
//	[path lineToPoint: NSMakePoint(226.9126/maxx*x, 28.5234/maxy*y)];
//	[path curveToPoint: NSMakePoint(243.8828/maxx*x, 28.5234/maxy*y) controlPoint1:	NSMakePoint(231.5981/maxx*x, 23.8369/maxy*y) controlPoint2:	NSMakePoint(239.1968/maxx*x, 23.8369/maxy*y)];
//	[path lineToPoint: NSMakePoint(253.8975/maxx*x, 38.5381/maxy*y)];
//	[path lineToPoint: NSMakePoint(451.9229/maxx*x, 38.5381/maxy*y)];
//	[path curveToPoint: NSMakePoint(463.9229/maxx*x, 50.5381/maxy*y) controlPoint1:	NSMakePoint(458.5498/maxx*x, 38.5381/maxy*y) controlPoint2:	NSMakePoint(463.9229/maxx*x, 43.9111/maxy*y)];
//	[path lineToPoint: NSMakePoint(463.9229/maxx*x, 128.4619/maxy*y)];
//	[path curveToPoint: NSMakePoint(451.9229/maxx*x, 140.4619/maxy*y) controlPoint1:	NSMakePoint(463.9229/maxx*x, 135.0889/maxy*y) controlPoint2:	NSMakePoint(458.5498/maxx*x, 140.4619/maxy*y)];
//	[path closePath];
	
    return _path;
}

- (BOOL)isContentsUnderPoint:(NSPoint)point {
    
    return [[self bezierPathForDrawing] containsPoint:point];
}

- (NSPoint)startPoint {

	NSPoint ptArray[3];
	NSPointArray ptData = &ptArray[0];
	NSBezierPathElement eleType = [_path elementAtIndex:0 associatedPoints:ptData];
	NSPoint startPt = ptArray[0];
	return startPt;
}

- (NSArray *)controlPts {
	
	NSMutableArray *curvePts = [NSMutableArray array];
	NSPoint ptArray[3];
	NSPointArray ptData = &ptArray[0];
	
	int numberOfElements = [_path elementCount];
	for( NSUInteger i=0; i<numberOfElements; i++ ){
		NSBezierPathElement eleType = [_path elementAtIndex:i associatedPoints:ptData];
		// if(eleType==NSMoveToBezierPathElement || eleType==NSMoveToBezierPathElement)  NSLineToBezierPathElement
		NSPoint cntrlPt = ptArray[0];
		[curvePts addObject:[NSValue valueWithPoint:cntrlPt]];
	}
	return curvePts;
}

- (int)countOfPoints {
	
	int numberOfElements = [_path elementCount];
	return numberOfElements;
}

- (NSRect)bounds {
    
    if([_path isEmpty])
        _bounds = NSMakeRect(0,0,10,10);
	else
		_bounds = _path.controlPointBounds;
	NSLog(@"Bezier bounds is %@", NSStringFromRect(_bounds));
    return _bounds;
}

- (void)setBounds:(NSRect)value {
    
    NSAffineTransform *transform = [NSAffineTransform transform];
	NSRect currentBounds = [self bounds];
	[transform scaleXBy:value.size.width/currentBounds.size.width yBy:value.size.height/currentBounds.size.height];
    [transform translateXBy: value.origin.x-currentBounds.origin.x yBy: value.origin.y-currentBounds.origin.y];
    [_path transformUsingAffineTransform: transform];
	
	// ?? set the _bounds ??
}


@end
