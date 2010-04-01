/*
	SKTGraphic.h
	Part of the Sketch Sample Code
*/

#import <Cocoa/Cocoa.h>
#import <SHNodeGraph/SHNode.h>
#import <SHShared/SHooleyObject.h>

This is dead infavour of Graphic.h?

//june09 extern NSString *SKTGraphicCanSetDrawingFillKey;

enum SKTGraphicDrawingMode {
    SKTGraphicNormalFill = 1,
    SKTGraphicWireframe = 2,
    SKTGraphicEditingText = 3,
};

// The value that is returned by -handleUnderPoint: to indicate that no selection handle is under the point.
extern const NSInteger SKTGraphicNoHandle;

@interface SKTGraphic : SHNode {	//<NSCopying> 

    NSRect      _bounds;
//	NSPoint		_position;
//	NSSize		_size;
    BOOL		_drawingFill, _drawingStroke;
    CGFloat		_strokeWidth;
    NSColor		*_strokeColor, *_fillColor;
}

//@property NSPoint position;
//@property NSSize size;
//@property CGFloat xPosition, yPosition, width, height;
@property (nonatomic) CGFloat strokeWidth;
@property (nonatomic) BOOL drawingFill, drawingStroke;
@property (retain, readwrite, nonatomic) NSColor *strokeColor, *fillColor;

#pragma mark *** Convenience ***

/* You can override these class methods in your subclass of SKTGraphic, but it would be a waste of time, because no one invokes these on any class 
 other than SKTGraphic itself. Really these could just be functions if we didn't have such a syntactic sweet tooth. */

// Move each graphic in the array by the same amount.
+ (void)translateGraphics:(NSArray *)graphics byX:(CGFloat)deltaX y:(CGFloat)deltaY;

// Return the total "bounds" of all of the graphics in the array.
+ (NSRect)boundsOfGraphics:(NSArray *)graphics;

// Return the total drawing bounds of all of the graphics in the array.
+ (NSRect)drawingBoundsOfGraphics:(NSArray *)graphics;

- (NSArray *)controlPts;

#pragma mark *** Persistence ***

/* You can override these class methods in your subclass of SKTGraphic, but it would be a waste of time, because no one invokes these on any class other than SKTGraphic itself. Really these could just be functions if we didn't have such a syntactic sweet tooth. */

// Return an array of graphics created from flattened data of the sort returned by +pasteboardDataWithGraphics: or, if that's not possible, 
// return nil and set *outError to an NSError that can be presented to the user to explain what went wrong.
//+ (NSArray *)graphicsWithPasteboardData:(NSData *)data error:(NSError **)outError;

// Given an array of property list dictionaries whose validity has not been determined, return an array of graphics.
// + (NSArray *)graphicsWithProperties:(NSArray *)propertiesArray;

// Return the array of graphics as flattened data that is appropriate for passing to +graphicsWithPasteboardData:error:.
//+ (NSData *)pasteboardDataWithGraphics:(NSArray *)graphics;

// Given an array of graphics, return an array of property list dictionaries.
//+ (NSArray *)propertiesWithGraphics:(NSArray *)graphics;

/* Subclasses of SKTGraphic might have reason to override any of the rest of this class' methods, starting here. */

// Given a dictionary having the sort of entries that would be in a dictionary returned by -properties, but whose validity has not been determined,
// initialize, setting the values of as many properties as possible from it. Ignore unrecognized dictionary entries. Use default values for missing dictionary entries. 
// This is not the designated initializer for this class (-init is).
//- (id)initWithProperties:(NSDictionary *)properties;

// Return a dictionary that can be used as property list object and contains enough information to recreate the graphic (except for its class, which is handled by +propertiesWithGraphics:).
// The returned dictionary must be mutable so that it can be added to efficiently, but the receiver must ignore any mutations made to it after it's been returned.
//- (NSMutableDictionary *)properties;

#pragma mark *** Simple Property Getting ***

// Accessors for properties that this class stores as instance variables. 
// These methods provide readable KVC-compliance for several of the keys mentioned in comments above, but that's not why they're here 
// (KVC direct instance variable access makes them unnecessary for that). 
// They're here just for invoking and overriding by subclass code.
- (NSRect)bounds;

// Set the bounds of the graphic, doing whatever scaling and translation is necessary.
- (void)setBounds:(NSRect)bounds;

#pragma mark *** Drawing ***


// Return the bounding box of everything the receiver might draw when sent a -draw...InView: message. 
// The default implementation of this method returns a bounds that assumes the default implementations of -drawContentsInView: and -drawHandlesInView:. 
// Subclasses that override this probably have to override +keysForValuesAffectingDrawingBounds too.
- (NSRect)drawingBounds;
- (BOOL)drawingContents;

// Draw the contents the receiver in a specific view. Use isBeingCreatedOrEditing if the graphic draws differently during its creation or while it's being edited. 
// The default implementation of this method just draws the result of invoking -bezierPathForDrawing using the current fill and stroke parameters.
// Subclasses have to override either this method or -bezierPathForDrawing.
// Subclasses that override this may have to override +keysForValuesAffectingDrawingBounds, +keysForValuesAffectingDrawingContents, and -drawingBounds too.
- (void)drawContentsInView:(NSView *)view preferredRepresentation:(enum SKTGraphicDrawingMode)preferredRepresentation;

// Return a bezier path that can be stroked and filled to draw the graphic, if the graphic can be drawn so simply, nil otherwise. 
// The default implementation of this method returns nil. Subclasses have to override either this method or -drawContentsInView:.
// Any returned bezier path should already have the graphic's current stroke width set in it.
- (NSBezierPath *)bezierPathForDrawing;

// Draw the handles of the receiver in a specific view. The default implementation of this method just invokes -drawHandleInView:atPoint: for each point at the corners 
// and on the sides of the rectangle returned by -bounds.
// Subclasses that override this probably have to override -handleUnderPoint: too.
//- (void)drawHandlesInView:(NSView *)view;

// Draw handle at a specific point in a specific view. Subclasses that override -drawHandlesInView: can invoke this to easily draw handles whereever they like.
//- (void)drawHandleInView:(NSView *)view atPoint:(NSPoint)point;

#pragma mark *** Editing ***

// Return a cursor that can be used when the user has clicked using the creation tool and is dragging the mouse to size a new instance of the receiving class.
+ (NSCursor *)creationCursor;

// Return the number of the handle that the user is dragging when they move the mouse after clicking to create a new instance of the receiving class.
// The default implementation of this method returns a number that corresponds to one of the corners of the graphic's bounds.
// Subclasses that override this should probably override -resizeByMovingHandle:toPoint: too.
+ (NSInteger)creationSizingHandle;

// Return YES if it's useful to let the user toggle drawing of the fill or stroke, NO otherwise. 
// The default implementations of these methods return YES.
- (BOOL)canSetDrawingFill;
- (BOOL)canSetDrawingStroke;

// Return YES if sending -makeNaturalSize to the receiver would do something noticable by the user, NO otherwise. 
// The default implementation of this method returns YES if the defaultimplementation of -makeNaturalSize would actually do something, NO otherwise.
// - (BOOL)canMakeNaturalSize;

// Return YES if the point is in the contents of the receiver, NO otherwise. 
// The default implementation of this method returns YES if the point is inside [self bounds].
- (BOOL)isContentsUnderPoint:(NSPoint)point;
    
// If the point is in one of the handles of the receiver return its number, SKTGraphicNoHandle otherwise. 
// The default implementation of this method invokes -isHandleAtPoint:underPoint: for the corners and on the sides of the rectangle returned by -bounds.
// Subclasses that override this probably have to override several other methods too.
- (NSInteger)handleUnderPoint:(NSPoint)point;

// Return YES if the handle at a point is under another point. 
// Subclasses that override -handleUnderPoint: can invoke this to hit-test the sort of handles that would be drawn by -drawHandleInView:atPoint:.
- (BOOL)isHandleAtPoint:(NSPoint)handlePoint underPoint:(NSPoint)point;

// Given that one of the receiver's handles has been dragged by the user, resize to match, and return the handle number that should be passed into subsequent invocations of this same method. 
// The default implementation of this method assumes that the passed-in handle number was returned by a previous invocation of +creationSizingHandle or -handleUnderPoint:, 
// so subclasses that override this should probably override +creationSizingHandle and -handleUnderPoint: too. It also invokes -flipHorizontally and -flipVertically when the user flips the graphic.
- (NSInteger)resizeByMovingHandle:(NSInteger)handle toPoint:(NSPoint)point;

// Given that -resizeByMovingHandle:toPoint: is being invoked and sensed that the user has flipped the graphic one way or the other, change the graphic to accomodate, 
// whatever that means. Subclasses that represent asymmetrical graphics can override these to accomodate the user's dragging of handles without having to override and mostly reimplement -resizeByMovingHandle:toPoint:.
- (void)flipHorizontally;
- (void)flipVertically;

// Given that [[self class] canMakeNaturalSize] would return YES, set the the bounds of the receiver to whatever is "natural" for its particular subclass of SKTGraphic. The default implementation of this method just squares the bounds.
//- (void)makeNaturalSize;

// Set the color of the graphic, whatever that means. 
// The default implementation of this method just sets isDrawingFill to YES and fillColor to the passed-in color. 
// In Sketch this method is invoked when the user drops a color chip on the graphic or uses the color panel to change the color of all of the selected graphics.
- (void)setColor:(NSColor *)color;

// Given that the receiver has just been created or double-clicked on or something, create and return a view that can present its editing interface to the user, or return nil. 
// The returned view should be suitable for becoming a subview of a view whose bounds is passed in. Its frame should match the bounds of the receiver.
// The receiver should not assume anything about the lifetime of the returned editing view; it may remain in use even after subsequent invocations of this method, which should, again,
// create a new editing view each time. In other words, overrides of this method should be prepared for a graphic to have more than editing view outstanding.
// The default implementation of this method returns nil. In Sketch SKTText overrides it.
//- (NSView *)newEditingViewWithSuperviewBounds:(NSRect)superviewBounds;

// Given an editing view that was returned by a previous invocation of -newEditingViewWithSuperviewBounds:, tear down whatever connections exist between it and the receiver.
- (void)finalizeEditingView:(NSView *)editingView;

@end