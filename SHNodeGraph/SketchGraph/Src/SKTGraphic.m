/*
	SKTGraphic.m
	Part of the Sketch Sample Code
*/
#import "SKTGraphic.h"
#import "SKTError.h"

// Another constant that's declared in the header.
const NSInteger SKTGraphicNoHandle = 0;

// The values that might be returned by -[SKTGraphic creationSizingHandle] and -[SKTGraphic handleUnderPoint:],
// and that are understood by -[SKTGraphic resizeByMovingHandle:toPoint:].
// We provide specific indexes in this enumeration so make sure none of them are zero (that's SKTGraphicNoHandle) and to 
// make sure the flipping arrays in -[SKTGraphic resizeByMovingHandle:toPoint:] work.
enum {
    SKTGraphicUpperLeftHandle = 1,
    SKTGraphicUpperMiddleHandle = 2,
    SKTGraphicUpperRightHandle = 3,
    SKTGraphicMiddleLeftHandle = 4,
    SKTGraphicMiddleRightHandle = 5,
    SKTGraphicLowerLeftHandle = 6,
    SKTGraphicLowerMiddleHandle = 7,
    SKTGraphicLowerRightHandle = 8,
};

// The handles that graphics draw on themselves are 6 point by 6 point rectangles.
static CGFloat SKTGraphicHandleWidth = 6.0f;
static CGFloat SKTGraphicHandleHalfWidth = 6.0f / 2.0f;

/*
 *
*/
@implementation SKTGraphic

//@synthesize position = _position;
//@synthesize size = _size;
//@synthesize xPosition, yPosition, width, height;
@synthesize strokeWidth=_strokeWidth;
@synthesize drawingFill=_drawingFill, drawingStroke=_drawingStroke;
@synthesize strokeColor=_strokeColor, fillColor=_fillColor;

/* KVO for drawingBounds should be triggered when.. */

// DrawingBounds
+ (NSSet *)keyPathsForValuesAffectingDrawingBounds {
    return [NSSet setWithObjects: @"strokeWidth", nil];
}

// Position
//+ (NSSet *)keyPathsForValuesAffectingPosition {
//    return [NSSet setWithObjects: @"xPosition", @"yPosition", nil];
//}

// Size
//+ (NSSet *)keyPathsForValuesAffectingSize {
//    return [NSSet setWithObjects: @"width", @"height", nil];
//}

// DrawingContents - what is the proper way to do this?
+ (NSSet *)keyPathsForValuesAffectingDrawingContents {
    return [NSSet setWithObjects: @"drawingFill", @"fillColor", @"drawingStroke",  @"strokeColor", nil];
}

/* Move to tool */
+ (NSCursor *)creationCursor {
	
    // By default we use the crosshairs cursor.
    static NSCursor *crosshairsCursor = nil;
    if (!crosshairsCursor) {
        NSImage *crosshairsImage = [NSImage imageNamed:@"Cross"];
        NSSize crosshairsImageSize = [crosshairsImage size];
        crosshairsCursor = [[NSCursor alloc] initWithImage:crosshairsImage hotSpot:NSMakePoint((crosshairsImageSize.width / 2.0), (crosshairsImageSize.height / 2.0))];
    }
    return crosshairsCursor;
}

+ (NSInteger)creationSizingHandle {
	
    // Return the number of the handle for the lower-right corner. If the user drags it so that it's no longer in the lower-right,
    // -resizeByMovingHandle:toPoint: will deal with it.
    return SKTGraphicLowerRightHandle;
}

//+ (void)initialize {
//    // This method gets invoked for every subclass of SKTGraphic that's instantiated. That's a good thing, in this case. 
//	// In most other cases it means you have to check self to protect against redundant invocations.
//    
//    // Set up use of the KVO dependency mechanism for the receiving class.
//	// The use of +keysForValuesAffectingDrawingBounds and +keysForValuesAffectingDrawingContents allows subclasses to easily customize this when they define entirely new properties 
//	// that affect how they draw.
//    [self setKeys:[[self keysForValuesAffectingDrawingBounds] allObjects] triggerChangeNotificationsForDependentKey:@"drawingBounds"];
//    [self setKeys:[[self keysForValuesAffectingDrawingContents] allObjects] triggerChangeNotificationsForDependentKey:@"drawingContents"];
////    NSArray *boundsKeyAsArray = [NSArray arrayWithObject:@"bounds"];
////    [self setKeys:boundsKeyAsArray triggerChangeNotificationsForDependentKey:@"xPosition"];
////    [self setKeys:boundsKeyAsArray triggerChangeNotificationsForDependentKey:@"yPosition"];
////    [self setKeys:boundsKeyAsArray triggerChangeNotificationsForDependentKey: @"width"];
////    [self setKeys:boundsKeyAsArray triggerChangeNotificationsForDependentKey:@"height"];
//}

// An override of the NSObject(NSKeyValueObservingCustomization) method.
//+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
//	
//    // We don't want KVO autonotification for these properties. 
//	// Because the setters for all of them invoke -setBounds:, and this class is KVO-compliant for "bounds," 
//	// and we declared that the values of these properties depend on "bounds," we would up end up with double notifications for them. 
//	// That would probably be unnoticable, but it's a little wasteful.
//	// Something you have to think about with codependent mutable properties like these (regardless of what notification mechanism you're using).
//    BOOL automaticallyNotifies;
//    if ([[NSSet setWithObjects:@"xPosition", @"yPosition",  @"width", @"height", nil] containsObject:key]) {
//		automaticallyNotifies = NO;
//    } else {
//		automaticallyNotifies = [super automaticallyNotifiesObserversForKey:key];
//    }
//    return automaticallyNotifies;
//}

+ (NSRect)boundsOfGraphics:(NSArray *)graphics {
	
    // The bounds of an array of graphics is the union of all of their bounds.
    NSRect bounds = NSZeroRect;
    if( [graphics count]>0) {
		for( SKTGraphic *graphic in graphics ){
            bounds = NSUnionRect(bounds, [graphic bounds] );
		}
	}
    return bounds;
}

+ (NSRect)drawingBoundsOfGraphics:(NSArray *)graphics {
	
    // The drawing bounds of an array of graphics is the union of all of their drawing bounds.
    NSRect drawingBounds = NSZeroRect;
    if( [graphics count]>0 )
	{
		for( SKTGraphic *graphic in graphics ){
            drawingBounds = NSUnionRect(drawingBounds, [graphic drawingBounds] );
		}
	}
    return drawingBounds;
}

#warning replace this with [array translate allItems by :x :y]
+ (void)translateGraphics:(NSArray *)graphics byX:(CGFloat)deltaX y:(CGFloat)deltaY {
	
	for( SKTGraphic *graphic in graphics ){
        NSRect bnds = graphic.bounds;
        bnds.origin = NSMakePoint( bnds.origin.x+deltaX, bnds.origin.y+deltaY );
		graphic.bounds = bnds;
	}
}

#pragma mark - Init mathods
- (id)init {

    self = [super init];
    if (self) {		

		_bounds = NSZeroRect;
		_drawingFill = YES;
		_fillColor = [[NSColor redColor] retain];
		_drawingStroke = YES;
		_strokeColor = [[NSColor blueColor] retain];
		_strokeWidth = 1.0f;
		
		/* Important for filter! */
//!Alert-putback!		_allowsSubpatches = NO;
    }
    return self;
}

- (void)dealloc {
	
    [_strokeColor release];
    [_fillColor release];
    [super dealloc];
}


// Conformance to the NSCopying protocol. SKTGraphics are copyable for the sake of scriptability.
//- (id)copyWithZone:(NSZone *)zone {
//
//!Alert-putback!almost certainly wrong! we need to super copy

//    // Pretty simple, but there's plenty of opportunity for mistakes. We use [self class] instead of SKTGraphic so that overrides of this method can invoke super. We copy instead of retaining the fill and stroke color even though it probably doesn't make a difference because that's the correct thing to do for attributes (to-one relationships, that's another story). We don't copy _scriptingContainer because the copy doesn't have any scripting container until it's added to one.
//    SKTGraphic *copy = [[[self class] alloc] init];
//    copy->_bounds = _bounds;
//    copy->_isDrawingFill = _isDrawingFill;
//    copy->_fillColor = [_fillColor copy];
//    copy->_isDrawingStroke = _isDrawingStroke;
//    copy->_strokeColor = [_strokeColor copy];
//    copy->_strokeWidth = _strokeWidth;
//    return copy;
//}

#pragma mark - Action mathods

- (NSInteger)resizeByMovingHandle:(NSInteger)handle toPoint:(NSPoint)point {
	
    // Start with the original bounds.
    NSRect bounds = [self bounds];
	
    // Is the user changing the width of the graphic?
    if (handle==SKTGraphicUpperLeftHandle || handle==SKTGraphicMiddleLeftHandle || handle==SKTGraphicLowerLeftHandle) {
		
		// Change the left edge of the graphic.
        bounds.size.width = NSMaxX(bounds) - point.x;
        bounds.origin.x = point.x;
		
    } else if (handle==SKTGraphicUpperRightHandle || handle==SKTGraphicMiddleRightHandle || handle==SKTGraphicLowerRightHandle) {
		
		// Change the right edge of the graphic.
        bounds.size.width = point.x - bounds.origin.x;
		
    }
	
    // Did the user actually flip the graphic over?
    if (bounds.size.width<0.0f) {
		
		// The handle is now playing a different role relative to the graphic.
		static NSInteger flippings[9];
		static BOOL flippingsInitialized = NO;
		if (!flippingsInitialized) {
			flippings[SKTGraphicUpperLeftHandle] = SKTGraphicUpperRightHandle;
			flippings[SKTGraphicUpperMiddleHandle] = SKTGraphicUpperMiddleHandle;
			flippings[SKTGraphicUpperRightHandle] = SKTGraphicUpperLeftHandle;
			flippings[SKTGraphicMiddleLeftHandle] = SKTGraphicMiddleRightHandle;
			flippings[SKTGraphicMiddleRightHandle] = SKTGraphicMiddleLeftHandle;
			flippings[SKTGraphicLowerLeftHandle] = SKTGraphicLowerRightHandle;
			flippings[SKTGraphicLowerMiddleHandle] = SKTGraphicLowerMiddleHandle;
			flippings[SKTGraphicLowerRightHandle] = SKTGraphicLowerLeftHandle;
			flippingsInitialized = YES;
		}
        handle = flippings[handle];
		
		// Make the graphic's width positive again.
        bounds.size.width = 0.0f - bounds.size.width;
        bounds.origin.x -= bounds.size.width;
		
		// Tell interested subclass code what just happened.
        [self flipHorizontally];
		
    }
    
    // Is the user changing the height of the graphic?
    if (handle==SKTGraphicUpperLeftHandle || handle==SKTGraphicUpperMiddleHandle || handle==SKTGraphicUpperRightHandle) {
		
		// Change the top edge of the graphic.
        bounds.size.height = NSMaxY(bounds) - point.y;
        bounds.origin.y = point.y;
		
    } else if (handle==SKTGraphicLowerLeftHandle || handle==SKTGraphicLowerMiddleHandle || handle==SKTGraphicLowerRightHandle) {
		
		// Change the bottom edge of the graphic.
		bounds.size.height = point.y - bounds.origin.y;
		
    }
	
    // Did the user actually flip the graphic upside down?
    if (bounds.size.height<0.0f) {
		
		// The handle is now playing a different role relative to the graphic.
		static NSInteger flippings[9];
		static BOOL flippingsInitialized = NO;
		if (!flippingsInitialized) {
			flippings[SKTGraphicUpperLeftHandle] = SKTGraphicLowerLeftHandle;
			flippings[SKTGraphicUpperMiddleHandle] = SKTGraphicLowerMiddleHandle;
			flippings[SKTGraphicUpperRightHandle] = SKTGraphicLowerRightHandle;
			flippings[SKTGraphicMiddleLeftHandle] = SKTGraphicMiddleLeftHandle;
			flippings[SKTGraphicMiddleRightHandle] = SKTGraphicMiddleRightHandle;
			flippings[SKTGraphicLowerLeftHandle] = SKTGraphicUpperLeftHandle;
			flippings[SKTGraphicLowerMiddleHandle] = SKTGraphicUpperMiddleHandle;
			flippings[SKTGraphicLowerRightHandle] = SKTGraphicUpperRightHandle;
			flippingsInitialized = YES;
		}
        handle = flippings[handle];
		
		// Make the graphic's height positive again.
        bounds.size.height = 0.0f - bounds.size.height;
        bounds.origin.y -= bounds.size.height;
		
		// Tell interested subclass code what just happened.
        [self flipVertically];
		
    }
	
    // Done.
    [self setBounds:bounds];
    return handle;
}


- (void)drawContentsInView:(NSView *)view preferredRepresentation:(enum SKTGraphicDrawingMode)preferredRepresentation {
	
    // If the graphic is so so simple that it can be boiled down to a bezier path then just draw a bezier path.
    // It's -bezierPathForDrawing's responsibility to return a path with the current stroke width.
    NSBezierPath *path = [self bezierPathForDrawing];
    if( path )
    {
        if( preferredRepresentation==SKTGraphicWireframe )
        {
            [path setLineWidth:1];
            [[NSColor knobColor] set];
            [path stroke];
			
        } else if( preferredRepresentation==SKTGraphicNormalFill ){
            
            if ([self drawingFill]) {
                [[self fillColor] set];
                [path fill];
            }
            else if ([self drawingStroke]) {
                
                [path setLineWidth:_strokeWidth];
                [[self strokeColor] set];
                [path stroke];
            } 
            else {
                [NSException raise:NSInternalInconsistencyException format:@"Cant draw this type of representation."];
            }
        }
    }
}


#warning - decorator pattern or visitor pattern?
//- (void)drawHandlesInView:(NSView *)view {
//	
//    // Draw handles at the corners and on the sides.
//    NSRect bounds = [self bounds];
//    [self drawHandleInView:view atPoint:NSMakePoint(NSMinX(bounds), NSMinY(bounds))];
//    [self drawHandleInView:view atPoint:NSMakePoint(NSMidX(bounds), NSMinY(bounds))];
//    [self drawHandleInView:view atPoint:NSMakePoint(NSMaxX(bounds), NSMinY(bounds))];
//    [self drawHandleInView:view atPoint:NSMakePoint(NSMinX(bounds), NSMidY(bounds))];
//    [self drawHandleInView:view atPoint:NSMakePoint(NSMaxX(bounds), NSMidY(bounds))];
//    [self drawHandleInView:view atPoint:NSMakePoint(NSMinX(bounds), NSMaxY(bounds))];
//    [self drawHandleInView:view atPoint:NSMakePoint(NSMidX(bounds), NSMaxY(bounds))];
//    [self drawHandleInView:view atPoint:NSMakePoint(NSMaxX(bounds), NSMaxY(bounds))];
//}

//- (void)drawHandleInView:(NSView *)view atPoint:(NSPoint)point {
//	
//    // Figure out a rectangle that's centered on the point but lined up with device pixels.
//    NSRect handleBounds;
//    handleBounds.origin.x = point.x - SKTGraphicHandleHalfWidth;
//    handleBounds.origin.y = point.y - SKTGraphicHandleHalfWidth;
//    handleBounds.size.width = SKTGraphicHandleWidth;
//    handleBounds.size.height = SKTGraphicHandleWidth;
//    handleBounds = [view centerScanRect:handleBounds];
//    
//    // Draw the shadow of the handle.
//    NSRect handleShadowBounds = NSOffsetRect(handleBounds, 1.0f, 1.0f);
//    [[NSColor controlDarkShadowColor] set];
//    NSRectFill(handleShadowBounds);
//	
//    // Draw the handle itself.
//    [[NSColor knobColor] set];
//    NSRectFill(handleBounds);
//}


//- (CGFloat)xPosition {
//    return _position.x;
//}
//- (CGFloat)yPosition {
//    return _position.y;
//}
//- (void)setXPosition:(CGFloat)xPosition {
//	_position.x = xPosition;
//}
//- (void)setYPosition:(CGFloat)yPosition {
//	_position.y = yPosition;
//}
//- (CGFloat)width {
//    return _size.width;
//}
//- (CGFloat)height {
//    return _size.height;
//}
//- (void)setWidth:(CGFloat)width {
//	_size.width = width;
//}
//- (void)setHeight:(CGFloat)height {
//	_size.height = height;
//}

//+ (NSArray *)graphicsWithPasteboardData:(NSData *)data error:(NSError **)outError {
//
//    // Because this data may have come from outside this process, don't assume that any property list object we get back is the right type.
//    NSArray *graphics = nil;
//    NSArray *propertiesArray = [NSPropertyListSerialization propertyListFromData:data mutabilityOption:NSPropertyListImmutable format:NULL errorDescription:NULL];
//    if (![propertiesArray isKindOfClass:[NSArray class]]) {
//	propertiesArray = nil;
//    }
//    if (propertiesArray) {
//
//	// Convert the array of graphic property dictionaries into an array of graphics.
//	graphics = [self graphicsWithProperties:propertiesArray];
//
//    } else if (outError) {
//
//	// If property list parsing fails we have no choice but to admit that we don't know what went wrong. The error description returned by +[NSPropertyListSerialization propertyListFromData:mutabilityOption:format:errorDescription:] would be pretty technical, and not the sort of thing that we should show to a user.
//	*outError = SKTErrorWithCode(SKTUnknownPasteboardReadError);
//
//    }
//    return graphics;
//}


//+ (NSArray *)graphicsWithProperties:(NSArray *)propertiesArray {
//
//    // Convert the array of graphic property dictionaries into an array of graphics. Again, don't assume that property list objects are the right type.
//    NSUInteger graphicCount = [propertiesArray count];
//    NSMutableArray *graphics = [[NSMutableArray alloc] initWithCapacity:graphicCount];
//    for (NSUInteger gindex = 0; gindex<graphicCount; gindex++) {
//	NSDictionary *properties = [propertiesArray objectAtIndex:gindex];
//	if ([properties isKindOfClass:[NSDictionary class]]) {
//
//	    // Figure out the class of graphic to instantiate. The value of the SKTGraphicClassNameKey entry must be an Objective-C class name. Don't trust the type of something you get out of a property list unless you know your process created it or it was read from your application or framework's resources.
//	    NSString *className = [properties objectForKey:SKTGraphicClassNameKey];
//	    if ([className isKindOfClass:[NSString class]]) {
//		Class class = NSClassFromString(className);
//		if (class) {
//
//		    // Create a new graphic. If it doesn't work then just do nothing. We could return an NSError, but doing things this way 1) means that a user might be able to rescue graphics from a partially corrupted document, and 2) is easier.
//		    SKTGraphic *graphic = [[class alloc] initWithProperties:properties];
//		    if (graphic) {
//			[graphics addObject:graphic];
//			[graphic release];
//		    }
//
//		}
//
//	    }
//
//	}
//    }
//    return [graphics autorelease];
//}


//+ (NSData *)pasteboardDataWithGraphics:(NSArray *)graphics {
//
//    // Convert the contents of the document to a property list and then flatten the property list.
//    return [NSPropertyListSerialization dataFromPropertyList:[self propertiesWithGraphics:graphics] format:NSPropertyListBinaryFormat_v1_0 errorDescription:NULL];
//}


//+ (NSArray *)propertiesWithGraphics:(NSArray *)graphics {
//
//    // Convert the array of graphics dictionaries into an array of graphic property dictionaries.
//    NSUInteger graphicCount = [graphics count];
//    NSMutableArray *propertiesArray = [[NSMutableArray alloc] initWithCapacity:graphicCount];
//    for (NSUInteger gindex = 0; gindex<graphicCount; gindex++) {
//	SKTGraphic *graphic = [graphics objectAtIndex: gindex];
//
//	// Get the properties of the graphic, add the class name that can be used by +graphicsWithProperties: to it, and add the properties to the array we're building.
//	NSMutableDictionary *properties = [graphic properties];
//	[properties setObject:NSStringFromClass([graphic class]) forKey:SKTGraphicClassNameKey];
//	[propertiesArray addObject:properties];
//
//    }
//    return [propertiesArray autorelease];
//}


//- (id)initWithProperties:(NSDictionary *)properties {
//
//    // Invoke the designated initializer.
//    self = [self init];
//    if (self) {
//
//	// The dictionary entries are all instances of the classes that can be written in property lists. Don't trust the type of something you get out of a property list unless you know your process created it or it was read from your application or framework's resources. We don't have to worry about KVO-compliance in initializers like this by the way; no one should be observing an unitialized object.
//	Class dataClass = [NSData class];
//	Class numberClass = [NSNumber class];
//	Class stringClass = [NSString class];
//	NSString *boundsString = [properties objectForKey:@"bounds"];
//	if ([boundsString isKindOfClass:stringClass]) {
//	    _bounds = NSRectFromString(boundsString);
//	}
//	NSNumber *isDrawingFillNumber = [properties objectForKey:@"drawingFill"];
//	if ([isDrawingFillNumber isKindOfClass:numberClass]) {
//	    _isDrawingFill = [isDrawingFillNumber boolValue];
//	}
//	NSData *fillColorData = [properties objectForKey:@"fillColor"];
//	if ([fillColorData isKindOfClass:dataClass]) {
//	    [_fillColor release];
//	    _fillColor = [[NSUnarchiver unarchiveObjectWithData:fillColorData] retain];
//	}
//	NSNumber *isDrawingStrokeNumber = [properties objectForKey:@"drawingStroke"];
//	if ([isDrawingStrokeNumber isKindOfClass:numberClass]) {
//	    _isDrawingStroke = [isDrawingStrokeNumber boolValue];
//	}
//	NSData *strokeColorData = [properties objectForKey: @"strokeColor"];
//	if ([strokeColorData isKindOfClass:dataClass]) {
//	    [_strokeColor release];
//	    _strokeColor = [[NSUnarchiver unarchiveObjectWithData:strokeColorData] retain];
//	}
//	NSNumber *strokeWidthNumber = [properties objectForKey: @"strokeWidth"];
//	if ([strokeWidthNumber isKindOfClass:numberClass]) {
//	    _strokeWidth = [strokeWidthNumber doubleValue];
//	}
//
//    }
//    return self;
//
//}

//
//- (NSMutableDictionary *)properties {
//
//    // Return a dictionary that contains nothing but values that can be written in property lists.
//    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
//    [properties setObject:NSStringFromRect([self bounds]) forKey:@"bounds"];
//    [properties setObject:[NSNumber numberWithBool:[self isDrawingFill]] forKey:@"drawingFill"];
//    NSColor *fillColor = [self fillColor];
//    if (fillColor) {
//        [properties setObject:[NSArchiver archivedDataWithRootObject:fillColor] forKey:@"fillColor"];
//    }
//    [properties setObject:[NSNumber numberWithBool:[self drawingStroke]] forKey:@"drawingStroke"];
//    NSColor *strokeColor = [self strokeColor];
//    if (strokeColor) {
//        [properties setObject:[NSArchiver archivedDataWithRootObject:strokeColor] forKey: @"strokeColor"];
//    }
//    [properties setObject:[NSNumber numberWithDouble:[self strokeWidth]] forKey: @"strokeWidth"];
//    return properties;
//}

#pragma mark *** Simple Property Getting ***

- (NSRect)bounds {
    return _bounds;
}

/* if we set bounds do we want to trigger notifications for position & size? */
- (void)setBounds:(NSRect)bounds {
    _bounds = bounds;
}

#pragma mark *** Drawing ***


- (NSRect)drawingBounds {

    CGFloat outset = 0.0;
    if ([self drawingStroke]) {
		CGFloat strokeOutset = [self strokeWidth] / 2.0f;
		if (strokeOutset>outset) {
			outset = strokeOutset;
		}
    }
    CGFloat inset = 0.0f - outset;
    NSRect drawingBounds = NSInsetRect([self bounds], inset, inset);
    
    // -drawHandleInView:atPoint: draws a one-unit drop shadow too.
    // drawingBounds.size.width += 1.0f;
    // drawingBounds.size.height += 1.0f;
    return drawingBounds;
}

- (NSArray *)controlPts {
	
	/* we could return the centre point here */
	return nil;
}

/* THIS ISN'T EVEN REAL! */
- (BOOL)drawingContents {
	return YES;
}

- (NSBezierPath *)bezierPathForDrawing {
    
    // Live to be overriden.
    [NSException raise:NSInternalInconsistencyException format:@"Neither -drawContentsInView: nor -bezierPathForDrawing has been overridden."];
    return nil;
}

#pragma mark *** Editing ***

- (BOOL)canSetDrawingFill {

    // The default implementation of -drawContentsInView: can draw fills.
    return YES;
}

- (BOOL)canSetDrawingStroke {

    // The default implementation of -drawContentsInView: can draw strokes.
    return YES;
}

- (BOOL)canMakeNaturalSize {

    // Only return YES if -makeNaturalSize would actually do something.
    NSRect bounds = [self bounds];
    return bounds.size.width!=bounds.size.height;
}

- (BOOL)isContentsUnderPoint:(NSPoint)point {

    // Just check against the graphic's bounds.
    return NSPointInRect(point, [self bounds]);
}

- (NSInteger)handleUnderPoint:(NSPoint)point {
    
    // Check handles at the corners and on the sides.
    NSInteger handle = SKTGraphicNoHandle;
    NSRect bounds = [self bounds];
    if ([self isHandleAtPoint:NSMakePoint(NSMinX(bounds), NSMinY(bounds)) underPoint:point]) {
		handle = SKTGraphicUpperLeftHandle;
    } else if ([self isHandleAtPoint:NSMakePoint(NSMidX(bounds), NSMinY(bounds)) underPoint:point]) {
		handle = SKTGraphicUpperMiddleHandle;
    } else if ([self isHandleAtPoint:NSMakePoint(NSMaxX(bounds), NSMinY(bounds)) underPoint:point]) {
		handle = SKTGraphicUpperRightHandle;
    } else if ([self isHandleAtPoint:NSMakePoint(NSMinX(bounds), NSMidY(bounds)) underPoint:point]) {
		handle = SKTGraphicMiddleLeftHandle;
    } else if ([self isHandleAtPoint:NSMakePoint(NSMaxX(bounds), NSMidY(bounds)) underPoint:point]) {
		handle = SKTGraphicMiddleRightHandle;
    } else if ([self isHandleAtPoint:NSMakePoint(NSMinX(bounds), NSMaxY(bounds)) underPoint:point]) {
		handle = SKTGraphicLowerLeftHandle;
    } else if ([self isHandleAtPoint:NSMakePoint(NSMidX(bounds), NSMaxY(bounds)) underPoint:point]) {
		handle = SKTGraphicLowerMiddleHandle;
    } else if ([self isHandleAtPoint:NSMakePoint(NSMaxX(bounds), NSMaxY(bounds)) underPoint:point]) {
		handle = SKTGraphicLowerRightHandle;
    }
    return handle;
}


- (BOOL)isHandleAtPoint:(NSPoint)handlePoint underPoint:(NSPoint)point {
    
    // Check a handle-sized rectangle that's centered on the handle point.
    NSRect handleBounds;
    handleBounds.origin.x = handlePoint.x - SKTGraphicHandleHalfWidth;
    handleBounds.origin.y = handlePoint.y - SKTGraphicHandleHalfWidth;
    handleBounds.size.width = SKTGraphicHandleWidth;
    handleBounds.size.height = SKTGraphicHandleWidth;
    return NSPointInRect(point, handleBounds);
}

- (void)flipHorizontally {
    
    // Live to be overridden.
}

- (void)flipVertically {
    
    // Live to be overridden.
}

- (void)makeNaturalSize {

    // Just make the graphic square.
    NSRect bounds = [self bounds];
    if (bounds.size.width<bounds.size.height) {
        bounds.size.height = bounds.size.width;
        [self setBounds:bounds];
    } else if (bounds.size.width>bounds.size.height) {
        bounds.size.width = bounds.size.height;
        [self setBounds:bounds];
    }
}

- (void)setColor:(NSColor *)color {

    // This method demonstrates something interesting: we haven't bothered to provide setter methods for the properties we want to change, but we can still change them using KVC. KVO autonotification will make sure observers hear about the change (it works with -setValue:forKey: as well as -set<Key>:). Of course, if we found ourselvings doing this a little more often we would go ahead and just add the setter methods. The point is that KVC direct instance variable access very often makes boilerplate accessors unnecessary but if you want to just put them in right away, eh, go ahead.

    // Can we fill the graphic?
    if ([self canSetDrawingFill]) {

	// Are we filling it? If not, start, using the new color.
	if (![self drawingFill]) {
	    [self setValue:[NSNumber numberWithBool:YES] forKey:@"drawingFill"];
	}
	[self setValue:color forKey:@"fillColor"];

    }
}


- (NSView *)newEditingViewWithSuperviewBounds:(NSRect)superviewBounds {
    
    // Live to be overridden.
    return nil;
}


- (void)finalizeEditingView:(NSView *)editingView {
    
    // Live to be overridden.
}


#pragma mark *** Debugging ***


//- (NSString *)description {
//
//	NSString *defaultDescription = [super description];
//    return [NSString stringWithFormat:@"%@ - %@", defaultDescription, [[self properties] description]];
//}


@end