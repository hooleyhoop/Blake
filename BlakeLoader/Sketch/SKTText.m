/*
	SKTText.m
	Part of the Sketch Sample Code
*/


#import "SKTText.h"


@implementation SKTText


- (NSTextStorage *)contents {

    // Never return nil.
    if (!_contents) {
	_contents = [[NSTextStorage alloc] init];

	// We need to be notified whenever the text storage changes.
	[_contents setDelegate:self];

    }
    return _contents;

}

//- (id)copyWithZone:(NSZone *)zone {
//
//    // Sending -copy or -mutableCopy to an NSTextStorage results in an NSAttributedString or NSMutableAttributedString, so we have to do something a little different. We go through [copy contents] to make sure delegation gets set up properly, and [self contents] to easily ensure we're not passing nil to -setAttributedString:.
//    SKTText *copy = [super copyWithZone:zone];
//    [[copy contents] setAttributedString:[self contents]];
//    return copy;
//}

- (void)dealloc {

    // Do the regular Cocoa thing.
    [_contents setDelegate:nil];
    [_contents release];
    [super dealloc];

}


#pragma mark *** Text Layout ***


// This is a class method to ensure that it doesn't need to access the state of any particular SKTText.
+ (NSLayoutManager *)sharedLayoutManager {

    // Return a layout manager that can be used for any drawing.
    static NSLayoutManager *layoutManager = nil;
    if (!layoutManager) {
        NSTextContainer *textContainer = [[NSTextContainer alloc] initWithContainerSize:NSMakeSize(1.0e7f, 1.0e7f)];
	layoutManager = [[NSLayoutManager alloc] init];
	[textContainer setWidthTracksTextView:NO];
        [textContainer setHeightTracksTextView:NO];
        [layoutManager addTextContainer:textContainer];
        [textContainer release];
    }
    return layoutManager;

}


- (NSSize)naturalSize {

    // Figure out how big this graphic would have to be to show all of its contents. -glyphRangeForTextContainer: forces layout.
    NSRect bounds = [self bounds];
    NSLayoutManager *layoutManager = [[self class] sharedLayoutManager];
    NSTextContainer *textContainer = [[layoutManager textContainers] objectAtIndex:0];
    [textContainer setContainerSize:NSMakeSize(bounds.size.width, 1.0e7f)];
    NSTextStorage *contents = [self contents]; 
    [contents addLayoutManager:layoutManager];
    [layoutManager glyphRangeForTextContainer:textContainer];
    NSSize naturalSize = [layoutManager usedRectForTextContainer:textContainer].size;
    [contents removeLayoutManager:layoutManager];
    return naturalSize;

}


- (void)setHeightToMatchContents {

    // Update the bounds of this graphic to match the height of the text. Make sure that doesn't result in the registration of a spurious undo action.
    // There might be a noticeable performance win to be had during editing by making this object a delegate of the text views it creates, implementing -[NSObject(NSTextDelegate) textDidChange:], and using information that's already calculated by the editing text view instead of invoking -makeNaturalSize like this.

    _boundsBeingChangedToMatchContents = YES;

    NSRect bounds = [self bounds];
    NSSize naturalSize = [self naturalSize];
    [self setBounds:NSMakeRect(bounds.origin.x, bounds.origin.y, bounds.size.width, naturalSize.height)];

    _boundsBeingChangedToMatchContents = NO;


}


// Conformance to the NSObject(NSTextStorageDelegate) informal protocol.
- (void)textStorageDidProcessEditing:(NSNotification *)notification {

    // The work we're going to do here involves sending -glyphRangeForTextContainer: to a layout manager, but you can't send that message to a layout manager attached to a text storage that's still responding to -endEditing, so defer the work to a point where -endEditing has returned.
    [self performSelector:@selector(setHeightToMatchContents) withObject:nil afterDelay:0.0];

}

#pragma mark *** Overrides of SKTGraphic Methods ***


//- (id)initWithProperties:(NSDictionary *)properties {
//
//    // Let SKTGraphic do its job and then handle the one additional property defined by this subclass.
//    self = [super initWithProperties:properties];
//    if (self) {
//
//	// The dictionary entries are all instances of the classes that can be written in property lists. Don't trust the type of something you get out of a property list unless you know your process created it or it was read from your application or framework's resources. We don't have to worry about KVO-compliance in initializers like this by the way; no one should be observing an unitialized object.
//	NSData *contentsData = [properties objectForKey:@"contents"];
//	if ([contentsData isKindOfClass:[NSData class]]) {
//	    NSTextStorage *contents = [NSUnarchiver unarchiveObjectWithData:contentsData];
//	    if ([contents isKindOfClass:[NSTextStorage class]]) {
//		_contents = [contents retain];
//
//		// We need to be notified whenever the text storage changes.
//		[_contents setDelegate:self];
//
//	    }
//	}
//    }
//    return self;
//}

//- (NSMutableDictionary *)properties {
//
//    // Let SKTGraphic do its job and then handle the one additional property defined by this subclass. The dictionary must contain nothing but values that can be written in old-style property lists.
//    NSMutableDictionary *properties = [super properties];
//    [properties setObject:[NSArchiver archivedDataWithRootObject:[self contents]] forKey:@"contents"];
//    return properties;
//}

- (BOOL)isDrawingStroke {

    // We never draw a stroke on this kind of graphic.
    return NO;
}

- (NSRect)drawingBounds {

    // The drawing bounds must take into account the focus ring that might be drawn by this class' override of -drawContentsInView:isBeingCreatedOrEdited:. It can't forget to take into account drawing done by -drawHandleInView:atPoint: though. Because this class doesn't override -drawHandleInView:atPoint:, it should invoke super to let SKTGraphic take care of that, and then alter the results.
    return NSUnionRect([super drawingBounds], NSInsetRect([self bounds], -1.0f, -1.0f));
}


- (void)drawContentsInView:(NSView *)view withPreferredStyle:(int)preferredRepresentation {

    // Draw the fill color if appropriate.
    NSRect bounds = [self bounds];
    if ([self drawingFill]) {
        [[self fillColor] set];
        NSRectFill(bounds);
    }

    // If this graphic is being created it has no text. If it is being edited then the editor returned by -newEditingViewWithSuperviewBounds: will draw the text.
    if( preferredRepresentation==SKTGraphicEditingText ) {

        // Just draw a focus ring.
        [[NSColor knobColor] set];
        NSFrameRect(NSInsetRect(bounds, -1.0, -1.0));

    } else {

	// Don't bother doing anything if there isn't actually any text.
	NSTextStorage *contents = [self contents]; 
	if ([contents length]>0) {

	    // Get a layout manager, size its text container, and use it to draw text. -glyphRangeForTextContainer: forces layout and tells us how much of text fits in the container.
	    NSLayoutManager *layoutManager = [[self class] sharedLayoutManager];
	    NSTextContainer *textContainer = [[layoutManager textContainers] objectAtIndex:0];
	    [textContainer setContainerSize:bounds.size];
	    [contents addLayoutManager:layoutManager];
	    NSRange glyphRange = [layoutManager glyphRangeForTextContainer:textContainer];
	    if (glyphRange.length>0) {
		[layoutManager drawBackgroundForGlyphRange:glyphRange atPoint:bounds.origin];
		[layoutManager drawGlyphsForGlyphRange:glyphRange atPoint:bounds.origin];
	    }
	    [contents removeLayoutManager:layoutManager];

        }

    }

}


- (BOOL)canSetDrawingStroke {

    // Don't let the user think we would even try to draw a stroke on this kind of graphic.
    return NO;

}

- (void)makeNaturalSize {

    // The real work is done in code shared with -setHeightToMatchContents:.
    NSRect bounds = [self bounds];
    NSSize naturalSize = [self naturalSize];
    [self setBounds:NSMakeRect(bounds.origin.x, bounds.origin.y, naturalSize.width, naturalSize.height)];
}

- (void)setBounds:(NSRect)bounds {

    // In Sketch the user can change the bounds of a text area while it's being edited using the graphics inspector, scripting, or undo. When that happens we have to update the editing views (there might be more than one, in different windows) to keep things consistent. We don't need to do this when the bounds is being changed to keep up with changes to the contents, because the text views we set up take care of that themselves.
    [super setBounds:bounds];
    if (!_boundsBeingChangedToMatchContents) {
	NSArray *layoutManagers = [[self contents] layoutManagers];
	NSUInteger layoutManagerCount = [layoutManagers count];
		
	for(NSLayoutManager *layoutManager in layoutManagers )
	{
	    // We didn't set up any multiple-text-view layout managers in -newEditingViewWithSuperviewBounds:, so we're not expecting to have to deal with any here.
	    [[layoutManager firstTextView] setFrame:bounds];

	}
    }

}



@end

