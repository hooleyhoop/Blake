/*
	SKTGraphicView.m
	Part of the Sketch Sample Code
*/


#import "SKTGraphicView.h"
#import "SKTImage.h"
#import "SKTRenderingView.h"
#import "SKTToolPaletteController.h"
#import "SKTGraphicViewController.h"
#import "SKTGraphicViewModel.h"
#import "SKTUserAdaptor.h"
#import "SHDrawableOperatorProvidor.h"


// Some methods that are invoked by methods above them in this file.
//@interface SKTGraphicView(SKTForwardDeclarations)
//- (void)bind:(NSString *)bindingName toObject:(id)observableObject withKeyPath:(NSString *)observableKeyPath options:(NSDictionary *)options;
//@end

static int _graphicsChangeCount = 0;
static int _selectionChangeCount = 0;

@implementation SKTGraphicView


- (void)dealloc {

    // If we've set a timer to show handles invalidate it so it doesn't send a message to this object's zombie.
//drawingHandles    [_handleShowingTimer invalidate];

    // Make sure any outstanding editing view doesn't cause leaks.
    // [_mouseInputAdaptor stopEditingInSketchView:self];


    [super dealloc];

}

//- (id)retain {
//	return [super retain];
//}
//- (void)release {
//    int retainCount = [self retainCount];
//	[super release];
//}

#pragma mark *** Drawing ***
- (void)drawRect:(NSRect)rect {

	// Draw every graphic that intersects the rectangle to be drawn. In Sketch the frontmost graphics have the lowest indexes.
	NSGraphicsContext *currentContext = [NSGraphicsContext currentContext];
	
	const NSRect *rects;
	int dirtyRectCount;
	[self getRectsBeingDrawn:&rects count:&dirtyRectCount];

	for( int dirtyRectIndex=0; dirtyRectIndex<dirtyRectCount; dirtyRectIndex++ )
	{
		NSRect dirtyRect = rects[dirtyRectIndex];
		NSEraseRect( dirtyRect );
	}

	//-- some portion of the view has become dirty --
	// duh! i want to draw the dirty objects, not the dirty rects, but 1 dirty object could cause anothers rect to become dirty
	// and therfore an un-dirty object will need drawing, by virtue of it sharing some portion of a dirty objects rect

	// -- shapes may need to draw : or composite : or both
	
//	 NSIndexSet *selectionIndexes = [_sketchViewController.sketchViewModel sktSceneSelectionIndexes];
	NSInteger graphicCount = [_sketchViewController.sketchViewModel countOfSktSceneItems];
	for( NSInteger graphIndex=graphicCount-1; graphIndex>=0; graphIndex-- )
	{
		NSAssert( graphicCount>graphIndex, @"bad index drawRect");
		
		SKTGraphic *graphic = [_sketchViewController.sketchViewModel objectInSktSceneItemsAtIndex: graphIndex];
		NSRect graphicDrawingBounds = [graphic drawingBounds];

		//-- if a little bit is within rect we will draw the entire shape - including bits that may be over parts of the background
		//-- that we didnt erase, leading to the ugly aliasing / overdrawn look
		
		//--Illustrator and freehand dont actually draw the object when you drag - they just draw a wire-frame with no handles
		
		// First test against coalesced rect.
		
		// NB - this has not in anyway been profiled so i cant be at all sure that it is better than i niave approach (eek!)
		if( NSIntersectsRect( graphicDrawingBounds, rect ) )
		{
			// Then test per dirty rect
			for( int dirtyRectIndex=0; dirtyRectIndex<dirtyRectCount; dirtyRectIndex++ )
			{
				NSRect dirtyRect = rects[dirtyRectIndex];

				if( NSIntersectsRect( dirtyRect, graphicDrawingBounds ) )
				{
                    enum SKTGraphicDrawingMode drawingStyle = SKTGraphicNormalFill;
                    //-- ask the tool which rep it would prefer
                    //	if(_mouseInputAdaptor)
                    //	drawingStyle = [_mouseInputAdaptor preferredDrawingStyleForGraphic: graphic];

					// Figure out whether or not to draw selection handles on the graphic. Selection handles are drawn for all selected objects except:
					// - While the selected objects are being moved.
					// - For the object actually being created or edited, if there is one.
					//drawingHandles			BOOL drawSelectionHandles = NO;
					//drawingHandles			if (!_isHidingHandles && graphic!=_creatingGraphic && graphic!=_editingGraphic) {
					//drawingHandles				drawSelectionHandles = [selectionIndexes containsIndex:graphIndex];
					//drawingHandles			}
					
					// Draw the graphic, possibly with selection handles.
					//-- NB - by saving the state we can resore the clip rect to new
					[currentContext saveGraphicsState];
					NSRectClip( dirtyRect );
					// i dont quite understand why we need to clip the shape to its own bounds - unless the drawing bounds are incorrect?
					//drawingMarqueeOnly			[NSBezierPath clipRect:graphicDrawingBounds];
					
					[graphic drawContentsInView:self preferredRepresentation: drawingStyle];
                    
//		NSFrameRect(graphicDrawingBounds );
					//drawingHandles			if (drawSelectionHandles) {
					//drawingHandles				[graphic drawHandlesInView:self];
					//drawingHandles			}
					// reapply the old clip rect
					[currentContext restoreGraphicsState];
				}
			}
		}
	}

	
	//-- draw tool sprites
	if(_mouseInputAdaptor){
		NSRect toolDrawingBounds = [_mouseInputAdaptor toolDisplaybounds];
		if( NSIntersectsRect( toolDrawingBounds, rect ) ){
//			for( int dirtyRectIndex=0; dirtyRectIndex<dirtyRectCount; dirtyRectIndex++ ) {
//				NSRect dirtyRect = rects[dirtyRectIndex];
//				if( NSIntersectsRect( dirtyRect, toolDrawingBounds ) ) {
//					[currentContext saveGraphicsState];
//					NSRectClip( dirtyRect );
					[_mouseInputAdaptor drawToolInSketchView:self];
//					[currentContext restoreGraphicsState];
//				}
//			}
		}
	}

//STEVE	{

		// are we on the arrow tool?
//STEVE			if([[SKTToolPaletteController sharedToolPaletteController] currentTool]==0)
//STEVE			{
//STEVE				if ( _creatingGraphic==nil && _editingGraphic==nil) //   !_isHidingHandles &&
//STEVE				{
				// -- get all selected objects
//STEVE					NSArray *selectedGraphics = [_sketchViewController selectedGraphics];
//				NSRect selectedBounds = NSZeroRect;
//				SKTGraphic *ob = nil;
//				for(ob in selectedGraphics){
//					selectedBounds =  NSUnionRect( selectedBounds, [ob bounds] );
//				}
//STEVE					NSRect selectedBounds = [SKTGraphic drawingBoundsOfGraphics:selectedGraphics];
				
				// -- calculate the centre point
//STEVE					if(NSIsEmptyRect(selectedBounds)==NO)
//STEVE					{
//					NSPoint centreOfSelection = NSMakePoint( NSMidX(selectedBounds), NSMidY(selectedBounds) );
					
					// -- draw an arrer
	//STEVE					{
						//[currentContext saveGraphicsState];
					
	//STEVE						[[NSColor redColor] set];

//STEVE							NSRectFill(NSInsetRect(selectedBounds,4,4));
						//[currentContext restoreGraphicsState];

//STEVE						}
//STEVE					}

//STEVE				}
//STEVE			}
//STEVE		}
	
	//-- test to see if dirty first!
	NSRect spriteBounds = NSMakeRect(0,0,80,33);
	if ([self needsToDrawRect:spriteBounds])

	//-- draw view sprites
	{
		[[NSColor grayColor] set];
//drawingMarqueeOnly		NSRectFill(spriteBounds);
		//[self setNeedsDisplayInRect:spriteBounds];
	}
	
	//-- draw overlays
	{
//		[[NSColor grayColor] set];
//		NSRectFill(NSMakeRect(0,0,80,33));
	}
	
	
//	[[NSColor grayColor] set];
//	NSRect inset = NSInsetRect(rect, 4, 4 );
//	NSFrameRect(inset);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(NSObject *)observedObject change:(NSDictionary *)change context:(void *)vcontext {
    
	NSString *context = (NSString *)vcontext;
	if(context==nil)
		[NSException raise:@"MUST SUPPLY A CONTEXT" format:@"MUST SUPPLY A CONTEXT"];
	
    if( [context isEqualToString:@"SKTGraphicViewController"] )
	{
		id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
		id newValue = [change objectForKey:NSKeyValueChangeNewKey];
		BOOL oldValueIsNullOrNil = [oldValue isEqual:[NSNull null]] || oldValue==nil;
		BOOL newValueNullOrNil = [newValue isEqual:[NSNull null]] || newValue==nil;
		id changeKind = [change objectForKey:NSKeyValueChangeKindKey];
//		id changeIndexes = [change objectForKey:NSKeyValueChangeIndexesKey];

        if ([keyPath isEqualToString:@"sktSceneItems"])
        {
			_graphicsChangeCount++;
			/*	Monitor what happens when we swap in a decorator - Dont start observing the decorator as if a new graphic was added! 
				I think we are ok as long as we do not swap in the decorator in a KVC way
			 */
			if(newValueNullOrNil==NO)
			{
				switch ([changeKind intValue]) 
				{
					case NSKeyValueChangeInsertion:
		//				[self insertGraphics: newValue atIndexes: changeIndexes];
						NSLog(@"Insert");
						break;
						
					case NSKeyValueChangeReplacement:
						[NSException raise:@"UNSUPPORTED" format:@"UNSUPPORTED"];
						break;
						
					case NSKeyValueChangeSetting:
		//				[self setGraphics: [[newValue mutableCopy] autorelease]];
						NSLog(@"Change");
						break;
						
					case NSKeyValueChangeRemoval:
						NSAssert(oldValueIsNullOrNil==NO, @"DOH!");
		//				[self removeGraphicsAtIndexes: changeIndexes];
						NSLog(@"Remove");
						break;
						
					default:
						[NSException raise:@"unpossible" format:@"unpossible"];
						break;
				}
				
				// Yes. Start observing them so we know when we need to redraw the parts of the view where they sit.
				[self startObservingGraphics: newValue];
				
				// Redraw just the parts of the view that they now occupy.
				NSUInteger graphicCount = [newValue count];
				for(NSUInteger graphIndex = 0; graphIndex<graphicCount; graphIndex++) {
					[self setNeedsDisplayInRect:[[newValue objectAtIndex: graphIndex] drawingBounds]];
				}
			}
					

			if(oldValueIsNullOrNil==NO)
			{
				// if an object has gone
				// Yes. Stop observing them because we don't want to leave dangling observations.
				[self stopObservingGraphics:oldValue];			

				// Redraw just the parts of the view that they used to occupy.
				NSUInteger removedGraphicCount = [oldValue count];
				for(NSUInteger graphIndex = 0; graphIndex<removedGraphicCount; graphIndex++) {
					[self setNeedsDisplayInRect:[[oldValue objectAtIndex: graphIndex] drawingBounds]];
				}
									
				// If a graphic is being edited right now, and the graphic is being removed, stop the editing. 
				// This way we don't strand an editing view whose graphic has been pulled out from under it.
				// This situation can arise from undoing and scripting.
//				if ([_mouseInputAdaptor editingGraphic] && [oldValue containsObject:[_mouseInputAdaptor editingGraphic]]) {
//					[_mouseInputAdaptor stopEditingInSketchView:self];
//				}
			}
			if(newValueNullOrNil && oldValueIsNullOrNil){
				//MOVE UP			[_view setNeedsDisplay:YES];
				[NSException raise:@"UNSUPPORTED" format:@"UNSUPPORTED"];
			}

		} else if ([keyPath isEqualToString:@"sktSceneSelectionIndexes"]){

			_selectionChangeCount++;
			NSLog(@"selection changed");
			// -- remove
			if (oldValueIsNullOrNil==NO) {
				for(NSUInteger oldSelectionIndex = [oldValue firstIndex]; oldSelectionIndex!=NSNotFound; oldSelectionIndex = [oldValue indexGreaterThanIndex:oldSelectionIndex]) {
					if (![newValue containsIndex:oldSelectionIndex]) {
						SKTGraphic *deselectedGraphic = [_sketchViewController.sketchViewModel objectInSktSceneItemsAtIndex: oldSelectionIndex];
						[self setNeedsDisplayInRect:[deselectedGraphic drawingBounds]];
					}
				}
			}
			
			// -- added
			if (newValueNullOrNil==NO) {
				for(NSUInteger newSelectionIndex = [newValue firstIndex]; newSelectionIndex!=NSNotFound; newSelectionIndex = [newValue indexGreaterThanIndex:newSelectionIndex]) {
					if (![oldValue containsIndex:newSelectionIndex]) {
						SKTGraphic *selectedGraphic = [_sketchViewController.sketchViewModel objectInSktSceneItemsAtIndex: newSelectionIndex];
						[self setNeedsDisplayInRect:[selectedGraphic drawingBounds]];
					}
				}
			}
			
		} else {
			[NSException raise:@"UNSUPPORTED" format:@"UNSUPPORTED"];
			[self setNeedsDisplay:YES];
		}			
		
	} else if( [context isEqualToString:@"SKTGraphicView.individualGraphic"] )
	{
 		// Has a graphic's drawing bounds changed, or some other value that affects how it appears?
		if ([keyPath isEqualToString:@"drawingBounds"])
		{
			// Redraw the part of the view that the graphic used to occupy, and the part that it now occupies.
#warning - this will not work if we are swapping in and out decorators
			NSRect oldGraphicDrawingBounds = [[change objectForKey:NSKeyValueChangeOldKey] rectValue];
			[self setNeedsDisplayInRect:oldGraphicDrawingBounds];
			NSRect newGraphicDrawingBounds = [[change objectForKey:NSKeyValueChangeNewKey] rectValue];
			[self setNeedsDisplayInRect:newGraphicDrawingBounds];
			
		} else if ([keyPath isEqualToString:@"drawingContents"]) {
			
			// The graphic's drawing bounds hasn't changed, so just redraw the part of the view that it occupies right now.
			NSRect graphicDrawingBounds = [(SKTGraphic *)observedObject drawingBounds];
			[self setNeedsDisplayInRect:graphicDrawingBounds];
			
		} else {
			[NSException raise:@"UNSUPPORTED" format:@"UNSUPPORTED"];
		}
		
    } else {
		// In overrides of -observeValueForKeyPath:ofObject:change:context: always invoke super when the observer notification isn't recognized. 
		// Code in the superclass is apparently doing observation of its own. NSObject's implementation of this method throws an exception. 
		// Such an exception would be indicating a programming error that should be fixed.
		[super observeValueForKeyPath:keyPath ofObject:observedObject change:change context:context];
	}
}
#pragma mark *** Editing Subviews ***




#pragma mark *** Mouse Event Handling ***

/*
	which objects are inside this view and may be clicked on? 
	graphics?
	nodes?
	handles?
	grids?
	guides?
	tool handles?
	rulers?
	labels?
*/	
//- (id)whatIsUnderPoint:(NSPoint)point {
//
//	id objectUnderMouse=nil;
//	id contentProvider=nil;
//	for(contentProvider in _orderedContentProvidors)
//	{
//		objectUnderMouse = [contentProvider objectForPoint:point];
//		if(objectUnderMouse!=nil)
//			return objectUnderMouse;
//	}
//	return nil;
//}

//-- move to provider?
- (SKTGraphic *)graphicUnderPoint:(NSPoint)point index:(NSUInteger *)outIndex isSelected:(BOOL *)outIsSelected handle:(NSInteger *)outHandle {

    // We don't touch *outIndex, *outIsSelected, or *outHandle if we return nil. Those values are undefined if we don't return a match.

    // Search through all of the graphics, front to back, looking for one that claims that the point is on a selection handle (if it's selected) or in the contents of the graphic itself.
    SKTGraphic *graphicToReturn = nil;
    NSIndexSet *selectionIndexes = [_sketchViewController.sketchViewModel sktSceneSelectionIndexes];
    NSUInteger graphicCount = [_sketchViewController.sketchViewModel countOfSktSceneItems];
    for(NSUInteger graphIndex = 0; graphIndex<graphicCount; graphIndex++)
	{
		NSAssert(graphicCount>graphIndex, @"bad index graphicUnderPoint");
		SKTGraphic *graphic = [_sketchViewController.sketchViewModel objectInSktSceneItemsAtIndex: graphIndex];

		// Do a quick check to weed out graphics that aren't even in the neighborhood.
		if (NSPointInRect(point, [graphic drawingBounds]))
		{
			// Check the graphic's selection handles first, because they take precedence when they overlap the graphic's contents.
			BOOL graphicIsSelected = [selectionIndexes containsIndex:graphIndex];
			if (graphicIsSelected) {
				NSInteger handle = [graphic handleUnderPoint:point];
				if (handle!=SKTGraphicNoHandle) {
					
					// The user clicked on a handle of a selected graphic.
					graphicToReturn = graphic;
					if (outHandle) {
						*outHandle = handle;
					}
					
				}
			}
			if (!graphicToReturn) {
				BOOL clickedOnGraphicContents = [graphic isContentsUnderPoint:point];
				if (clickedOnGraphicContents) {
					
					// The user clicked on the contents of a graphic.
					graphicToReturn = graphic;
					if (outHandle) {
						*outHandle = SKTGraphicNoHandle;
					}
					
				}
			}
			if (graphicToReturn) {

				// Return values and stop looking.
				if (outIndex) {
					*outIndex = graphIndex;
				}
				if (outIsSelected) {
					*outIsSelected = graphicIsSelected;
				}
				break;
			
			}

		}

    }
    return graphicToReturn;
}



- (NSIndexSet *)indexesOfGraphicsIntersectingRect:(NSRect)rect {

   NSMutableIndexSet *indexSetToReturn = [NSMutableIndexSet indexSet];

    NSUInteger graphicCount = [_sketchViewController.sketchViewModel countOfSktSceneItems];
    for(NSUInteger graphIndex = 0; graphIndex<graphicCount; graphIndex++)
	{
		NSAssert(graphicCount>graphIndex, @"bad index indexesOfGraphicsIntersectingRect");
		SKTGraphic *graphic = [_sketchViewController.sketchViewModel objectInSktSceneItemsAtIndex: graphIndex];
        if (NSIntersectsRect(rect, [graphic drawingBounds])) 
		{
            [indexSetToReturn addIndex: graphIndex];
        }
    }
    return indexSetToReturn;
}


#pragma mark *** Keyboard Event Handling ***


- (IBAction)delete:(id)sender {

	NSIndexSet *objectsToDelete = [[_sketchViewController.sketchViewModel sktSceneSelectionIndexes] copy];
	//-- unselect them first
	[_sketchViewController.sketchViewModel changeSktSceneSelectionIndexes:[NSIndexSet indexSet]];
	[_sketchViewController removeGraphicsAtIndexes:objectsToDelete];
	[objectsToDelete release];
}

- (void)startObservingGraphics:(NSArray *)graphics {

	// Start observing "drawingBounds" in each of the graphics. Use KVO's options for getting the old and new values in change notifications so we can invalidate just the old and new drawing bounds of changed graphics when they move or change size, instead of the whole view. (The new drawing bounds is easy to otherwise get using regular KVC, but the old one would otherwise have been forgotten by the time we get the notification.) Instances of SKTGraphic must therefore be KVC- and KVO-compliant for drawingBounds. SKTGraphics's use of KVO's dependency mechanism means that being KVO-compliant for drawingBounds when subclassing is as easy as overriding -drawingBounds (to compute an accurate value) and +keysForValuesAffectingDrawingBounds (to tell SKTGraphic how to use KVO's dependency mechanism) though.
	NSIndexSet *allGraphicIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [graphics count])];
	[graphics addObserver:self toObjectsAtIndexes:allGraphicIndexes forKeyPath:@"drawingBounds" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SKTGraphicView.individualGraphic"];

	// Start observing "drawingContents" in each of the graphics. Don't bother using KVO's options for getting the old and new values because there is no value for drawingContents. It's just something that depends on all of the properties that affect drawing of a graphic but don't affect the drawing bounds of the graphic. Similar to what we do for drawingBounds, SKTGraphics' use of KVO's dependency mechanism means that being KVO-compliant for drawingContents when subclassing is as easy as overriding +keysForValuesAffectingDrawingContents (there is no -drawingContents method to override).
	[graphics addObserver:self toObjectsAtIndexes:allGraphicIndexes forKeyPath:@"drawingContents" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SKTGraphicView.individualGraphic"];
}

- (void)stopObservingGraphics:(NSArray *)graphics {

	// Undo what we do in -startObservingGraphics:.
	NSIndexSet *allGraphicIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [graphics count])];
	[graphics removeObserver:self fromObjectsAtIndexes:allGraphicIndexes forKeyPath:@"drawingContents"];
	[graphics removeObserver:self fromObjectsAtIndexes:allGraphicIndexes forKeyPath:@"drawingBounds"];
}

// An override of an NSResponder(NSStandardKeyBindingMethods) method and a matching method of our own.
//putbacklater- (void)selectAll:(id)sender {
//putbacklater    [_sketchViewController.sketchViewModel changeSktSceneSelectionIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [_sketchViewController.sketchViewModel countOfSktSceneItems])]];
//putbacklater}
- (IBAction)deselectAll:(id)sender {
	
    [_sketchViewController.sketchViewModel changeSktSceneSelectionIndexes:[NSIndexSet indexSet]];
}


@end

