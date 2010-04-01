//
//  Star.m
//  DebugDrawing
//
//  Created by steve hooley on 23/09/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "Star.h"

@implementation Star

@synthesize path;

- (id)init {
		
	self = [super init];
	if(self){
		
		[self setGeometryRect: CGRectMake(0.0f, 0.0f, 50.0f, 50.0f) ];
		[self enforceConsistentState];
		_allowsSubpatches = NO;
	}
	return self;
}

- (void)dealloc {

	self.path = nil;
	[super dealloc];
}

/* Recalculate computed values. Only ever called from private evaluate once per frame */
- (BOOL)execute:(id)fp8 head:(id)np time:(CGFloat)timeKey arguments:(id)fp20 {

//	static int dir = 1;
//	NSRect movedBounds = physicalBounds;
//	if(movedBounds.origin.x == 500 )
//		dir = -1;
//	else if(movedBounds.origin.x == 0 )
//		dir = 1;
//	
//	[self translateByX:(5*dir) byY:0];
    
	return YES;
}

//june09- (void)recalculateDrawingBounds {

//june09	[super recalculateDrawingBounds];
	
	// -- how do we know what our drawing bounds are?

//june09	NSRect currentSelectedBounds = self.drawingBounds;
//june09	_drawingBounds = [self transformedGeometryRectBoundingBox];
	
	// add on our differences between drawing bounds and geometry here, eg stroke width, etc.
	
//june09	[self setDirtyRect:NSUnionRect(self.drawingBounds, currentSelectedBounds)]; // again make sure we use the decorator's drawing bounds
//june09}

//june09- (void)_customDrawing {

	// Fill the background
//june09	[[NSColor whiteColor] set];
//june09	[path fill];
	
	// draw the star
//june09	[[NSColor greenColor] set];
//june09	[[NSBezierPath bezierPathWithOvalInRect:NSRectFromCGRect([_layerFamiliar geometryRect])] fill];
//june09}

- (void)setGeometryRect:(CGRect)value {
	
	[super setGeometryRect:value];
	self.path = [NSBezierPath bezierPathWithRect:NSRectFromCGRect([_layerFamiliar geometryRect])];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
	
	CGRect bounds = CGContextGetClipBoundingBox(ctx); // This should be the clip rect

	//TODO: wrong colourspace
	CGContextSetRGBFillColor(ctx, 0.0f, 1.0f, 0.0f, 1.0f);
    CGRect circleRect = [_layerFamiliar geometryRect];
    CGContextFillEllipseInRect( ctx, circleRect );

//	float starRadius = (100 * 3.0) / 8.0;
//	
//	// Rearrange the coordinate system for the 
//	// DrawStar routine then call it to draw the star.
//	CGContextSaveGState(ctx);
//	CGContextTranslateCTM(ctx, 0, 0);
//	
//	CGContextScaleCTM(ctx,  10,  10);
//	CGContextRotateCTM(ctx, pi / 2);
//	
//	
//    // CGPoint starPoints[5];
//    const CGFloat starAngle = 2.0 * pi / 5.0;
//	// Begin a new path (any previous path is discarded)
//    CGContextBeginPath(ctx);
//	
//    // The point (1,0) is equivalent to (cos(0), sin(0))
//    CGContextMoveToPoint(ctx, 1, 0);	
//	
//    // nextPointIndex is used to find every 
//    // other point
//    short nextPointIndex = 2;	
//    for(short pointCounter = 1; pointCounter < 5; pointCounter++) {
//		
//        CGContextAddLineToPoint(ctx, cos( nextPointIndex * starAngle ), sin( nextPointIndex * starAngle ));
//        nextPointIndex = (nextPointIndex + 2) % 5;
//    }
//	
//    CGContextClosePath(ctx);
//    CGContextFillPath(ctx);	
//	
//	CGContextRestoreGState(ctx);

//	CGContextSetRGBFillColor(ctx,  0.0, 0.0, 0.0, 1.0);
//	CGContextFillRect(ctx,CGRectMake(-1000,-1000,1000,1000));
	
	CGContextStrokeRectWithWidth(ctx, bounds, 2);
//	logInfo(@"Drawing at bounds %f", bounds.size.width);
	
//	CGMutablePathRef thePath = CGPathCreateMutable();
//	
//    CGPathMoveToPoint(thePath,NULL,15.0f,15.f);
//    CGPathAddCurveToPoint(thePath, NULL, 15.f,250.0f, 295.0f,250.0f, 295.0f,15.0f);
//	
//    CGContextBeginPath(ctx);
//    CGContextAddPath(ctx, thePath );
//	
//    CGContextSetLineWidth(ctx, 1.0);
//	//  CGContextSetStrokeColorWithColor(ctx, self.lineColor);
//    CGContextStrokePath(ctx);
//    CFRelease(thePath);
//	
//	NSDottedFrameRect(_marqueeSelectionBounds);
	
	
	// Prepare font
	CTFontRef font = CTFontCreateWithName(CFSTR("Times"), 48, NULL);
	
	// Create an attributed string
	CFStringRef keys[] = { kCTFontAttributeName };
	CFTypeRef values[] = { font };
	CFDictionaryRef attr = CFDictionaryCreate(NULL, (const void **)&keys, (const void **)&values,
											  sizeof(keys) / sizeof(keys[0]), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
	CFAttributedStringRef attrString = CFAttributedStringCreate(NULL, CFSTR("Hello, World!"), attr);
	CFRelease(attr);
	
	// Draw the string
	CTLineRef line = CTLineCreateWithAttributedString(attrString);
	CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
	CGContextSetTextPosition(ctx, 10, 20);
	CTLineDraw(line, ctx);
	
	// Clean up
	CFRelease(line);
	CFRelease(attrString);
	CFRelease(font);
}


@end
