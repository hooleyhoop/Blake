/*
	SKTLine.m
	Part of the Sketch Sample Code
*/


#import "SKTLine.h"

// SKTGraphic's default selection handle machinery draws more handles than we need, so this class implements its own.
enum {
    SKTLineBeginHandle = 1,
    SKTLineEndHandle = 2
};


@implementation SKTLine

#warning - this is old
//+ (void)initialize {
//
//    // Specify that invocations of [aLine setBounds:aRect] or [aLine setValue:[NSValue valueWithRect:aRect] forKey:@"bounds"], 
//    // or anything else that causes the "bounds" to change in a KVO-compliant way, should automatically notify observers of "beginPoint" and "endPoint" too, 
//    // because the values of those properties are derived from the value of the bounds.
//    NSArray *boundsKeyAsArray = [NSArray arrayWithObject:@"bounds"];
//#warning - deprecated
//    [self setKeys:boundsKeyAsArray triggerChangeNotificationsForDependentKey:@"beginPoint"];
//    [self setKeys:boundsKeyAsArray triggerChangeNotificationsForDependentKey:@"endPoint"];
//
//    // Don't prevent the invocations of -setKeys:triggerChangeNotificationsForDependentKey: that +[SKTGraphic initialize] does.
//    [super initialize];
//}

// DrawingBounds
//test this! super doesnt have any but we need to be careful - check that this should trigger bounds and drawing bounds
//+ (NSSet *)keyPathsForValuesAffectingBounds {
//    
//    NSSet *superset = [[[super keyPathsForValuesAffectingDrawingBounds] mutableCopy] autorelease];
//    [superset addObject:@"strokeWidth"];
//    return superset;
//}

//- (id)copyWithZone:(NSZone *)zone {
//
//    // Do the regular Cocoa thing.
//    SKTLine *copy = [super copyWithZone:zone];
//    copy->_pointsRight = _pointsRight;
//    copy->_pointsDown = _pointsDown;
//    return copy;
//}

#pragma mark *** Private KVC-Compliance for Public Properties ***

// The only reason we have to have this many methods for simple KVC and KVO compliance for "beginPoint" and "endPoint" is because reusing 
// SKTGraphic's "bounds" property is so complicated (see the instance variable comments in the header). 
// If we just had _beginPoint and _endPoint we wouldn't need any of these methods because KVC's direct instance variable access and KVO's 
// autonotification would just take care of everything for us (though maybe then we'd have to override -setBounds: and -bounds to fulfill
// the KVC and KVO compliance obligation for "bounds" that this class inherits from its superclass).

- (NSPoint)beginPoint {
    
    // Convert from our odd storage format to something natural.
    NSPoint beginPoint;
    NSRect bounds = [self bounds];
    beginPoint.x = _pointsRight ? NSMinX(bounds) : NSMaxX(bounds);
    beginPoint.y = _pointsDown ? NSMinY(bounds) : NSMaxY(bounds);
    return beginPoint;
    
}


- (NSPoint)endPoint {
    
    // Convert from our odd storage format to something natural.
    NSPoint endPoint;
    NSRect bounds = [self bounds];
    endPoint.x = _pointsRight ? NSMaxX(bounds) : NSMinX(bounds);
    endPoint.y = _pointsDown ? NSMaxY(bounds) : NSMinY(bounds);
    return endPoint;
    
}


+ (NSRect)boundsWithBeginPoint:(NSPoint)beginPoint endPoint:(NSPoint)endPoint pointsRight:(BOOL *)outPointsRight down:(BOOL *)outPointsDown {

    // Convert the begin and end points of the line to its bounds and flags specifying the direction in which it points.
    BOOL pointsRight = beginPoint.x<endPoint.x;
    BOOL pointsDown = beginPoint.y<endPoint.y;
    CGFloat xPosition = pointsRight ? beginPoint.x : endPoint.x;
    CGFloat yPosition = pointsDown ? beginPoint.y : endPoint.y;
    CGFloat width = fabs(endPoint.x - beginPoint.x);
    CGFloat height = fabs(endPoint.y - beginPoint.y);
    if (outPointsRight) {
	*outPointsRight = pointsRight;
    }
    if (outPointsDown) {
	*outPointsDown = pointsDown;
    }
    return NSMakeRect(xPosition, yPosition, width, height);
    
}


- (void)setBeginPoint:(NSPoint)beginPoint {
    
    // It's easiest to compute the results of setting these points together.
    [self setBounds:[[self class] boundsWithBeginPoint:beginPoint endPoint:[self endPoint] pointsRight:&_pointsRight down:&_pointsDown]];
    
}


- (void)setEndPoint:(NSPoint)endPoint {
    
    // It's easiest to compute the results of setting these points together.
    [self setBounds:[[self class] boundsWithBeginPoint:[self beginPoint] endPoint:endPoint pointsRight:&_pointsRight down:&_pointsDown]];
	
}


#pragma mark *** Overrides of SKTGraphic Methods ***

//- (id)initWithProperties:(NSDictionary *)properties {
//
//    // Let SKTGraphic do its job and then handle the additional properties defined by this subclass.
//    self = [super initWithProperties:properties];
//    if (self) {
//		// This object still doesn't have a bounds (because of what we do in our override of -properties), so set one and record the other information we need to place the begin and end points. 
//		// The dictionary entries are all instances of the classes that can be written in property lists. Don't trust the type of something you get out of a property list unless you know your 
//		// process created it or it was read from your application or framework's resources. We don't have to worry about KVO-compliance in initializers like this by the way; no one should be observing an unitialized object.
//		Class stringClass = [NSString class];
//		NSString *beginPointString = [properties objectForKey:@"beginPoint"];
//		NSPoint beginPoint = [beginPointString isKindOfClass:stringClass] ? NSPointFromString(beginPointString) : NSZeroPoint;
//		NSString *endPointString = [properties objectForKey:@"endPoint"];
//		NSPoint endPoint = [endPointString isKindOfClass:stringClass] ? NSPointFromString(endPointString) : NSZeroPoint;
//		[self setBounds:[[self class] boundsWithBeginPoint:beginPoint endPoint:endPoint pointsRight:&_pointsRight down:&_pointsDown]];
//    }
//    return self;
//}


//- (NSMutableDictionary *)properties {
//
//    // Let SKTGraphic do its job but throw out the bounds entry in the dictionary it returned and add begin and end point entries insteads. We do this instead of simply recording the currnet value of _pointsRight and _pointsDown because bounds+pointsRight+pointsDown is just too unnatural to immortalize in a file format. The dictionary must contain nothing but values that can be written in old-style property lists.
//    NSMutableDictionary *properties = [super properties];
//    [properties removeObjectForKey:@"bounds"];
//    [properties setObject:NSStringFromPoint([self beginPoint]) forKey:@"beginPoint"];
//    [properties setObject:NSStringFromPoint([self endPoint]) forKey:@"endPoint"];
//    return properties;
//}


// We don't bother overriding +keysForValuesAffectingDrawingBounds because we don't need to take advantage of the KVO dependency mechanism enabled by that method. We fulfill our KVO compliance obligations (inherited from SKTGraphic) for @"drawingBounds" by just always invoking -setBounds: in -setBeginPoint: and -setEndPoint:. "bounds" is always in the set returned by +[SKTGraphic keysForValuesAffectingDrawingBounds]. Now, there's nothing in SKTGraphic.h that actually guarantees that, so we're taking advantage of "undefined" behavior. If we didn't have the source to SKTGraphic right next to the source for this class it would probably be prudent to override +keysForValuesAffectingDrawingBounds, and make sure.

// We don't bother overriding +keysForValuesAffectingDrawingContents because this class doesn't define any properties that affect drawing without affecting the bounds.


- (BOOL)isDrawingFill {

    // You can't fill a line.
    return NO;

}


- (BOOL)isDrawingStroke {

    // You can't not stroke a line.
    return YES;

}


- (NSBezierPath *)bezierPathForDrawing {

    // Simple.
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path moveToPoint:[self beginPoint]];
    [path lineToPoint:[self endPoint]];
    return path;

}

//- (void)drawHandlesInView:(NSView *)view {
//    
//    // A line only has two handles.
//    [self drawHandleInView:view atPoint:[self beginPoint]];
//    [self drawHandleInView:view atPoint:[self endPoint]];
//}


+ (NSInteger)creationSizingHandle {

    // When the user creates a line and is dragging around a handle to size it they're dragging the end of the line.
    return SKTLineEndHandle;
}


- (BOOL)canSetDrawingFill {

    // Don't let the user think we can fill a line.
    return NO;

}


- (BOOL)canSetDrawingStroke {

    // Don't let the user think can ever not stroke a line.
    return NO;

}


- (BOOL)canMakeNaturalSize {

    // What would the "natural size" of a line be?
    return NO;

}


- (BOOL)isContentsUnderPoint:(NSPoint)point {

    // Do a gross check against the bounds.
    BOOL isContentsUnderPoint = NO;
    if (NSPointInRect(point, [self bounds])) {

	// Let the user click within the stroke width plus some slop.
	CGFloat acceptableDistance = ([self strokeWidth] / 2.0f) + 2.0f;

	// Before doing anything avoid a divide by zero error.
	NSPoint beginPoint = [self beginPoint];
	NSPoint endPoint = [self endPoint];
	CGFloat xDelta = endPoint.x - beginPoint.x;
	if (xDelta==0.0f && fabs(point.x - beginPoint.x)<=acceptableDistance) {
	    isContentsUnderPoint = YES;
	} else {

	    // Do a weak approximation of distance to the line segment.
	    CGFloat slope = (endPoint.y - beginPoint.y) / xDelta;
	    if (fabs(((point.x - beginPoint.x) * slope) - (point.y - beginPoint.y))<=acceptableDistance) {
		isContentsUnderPoint = YES;
	    }

	}

    }
    return isContentsUnderPoint;

}


- (NSInteger)handleUnderPoint:(NSPoint)point {

    // A line just has handles at its ends.
    NSInteger handle = SKTGraphicNoHandle;
    if ([self isHandleAtPoint:[self beginPoint] underPoint:point]) {
	handle = SKTLineBeginHandle;
    } else if ([self isHandleAtPoint:[self endPoint] underPoint:point]) {
	handle = SKTLineEndHandle;
    }
    return handle;

}


- (NSInteger)resizeByMovingHandle:(NSInteger)handle toPoint:(NSPoint)point {

    // A line just has handles at its ends.
    if (handle==SKTLineBeginHandle) {
	[self setBeginPoint:point];
    } else if (handle==SKTLineEndHandle) {
	[self setEndPoint:point];
    } // else a cataclysm occurred.

    // We don't have to do the kind of handle flipping that SKTGraphic does.
    return handle;

}


- (void)setColor:(NSColor *)color {

    // Because lines aren't filled we'll consider the stroke's color to be the one.
    [self setValue:color forKey: @"strokeColor"];

}





@end


/* removed */