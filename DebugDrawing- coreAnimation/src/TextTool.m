//
//  TextTool.m
//  DebugDrawing
//
//  Created by steve hooley on 28/10/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "TextTool.h"
#import "Text.h"
#import "Graphic.h"
#import "StarScene.h"
#import "AppControl.h"
#import "SelectedItem.h"
#import "HitTestContext.h"


@implementation TextTool

- (id)initWithToolBarController:(ToolBarController *)value
{
	self = [super initWithToolBarController:value];
	if ( self ) {
		_identifier = @"SKTTextTool";
		_labelString = @"Text";
		_iconPath = [[NSBundle bundleForClass:[self class ]] pathForImageResource:@"TextToolIcn"];
		_dirtyRect = NSZeroRect;
		_marqueeSelectionBounds = NSZeroRect;
	}
	return self;
}


- (void)checkForDeslection
{
	/* Is our editable item still selected? */
	if ( _editingGraphic != nil ) {
        CALayerStarView *view = _toolBarControl.targetView;
		NSArray *selectedItems = [view.starScene selectedItems];
		Text *editingItem = nil;
		for ( SelectedItem *each in selectedItems ) {
			if ( each.originalNodeProxy.originalNode == _editingGraphic ) {
				editingItem = (Text *)each.originalNodeProxy.originalNode;
				NSAssert([editingItem isKindOfClass:[Text class]], @"blurgg");
				break;
			}
		}
		/* so, did we deselect it? */
		if ( editingItem == nil )
			[self stopEditingInSketchView:view];
	}
}

- (void)enforceConsistentState

{
	/* Selection may have changed… should we still be editing text? */
	[self checkForDeslection];
}

// Create a new graphic and then track to size it.
- (void)mouseDownAtPoint:(NSPoint)pt event:(NSEvent *)event inStarView:(CALayerStarView *)view
{
	/* On doubleclick swap editing graphic */
	// id doubleClickedNode=nil, 
	id doubleClickedGraphic=nil;
	if ([event clickCount] > 1 )
	{
		NSArray *pathsOfHitObjects = _hitTestCntxt.keysToHitObjects;
		for(SH_Path *relativePathToClickedOnObject in pathsOfHitObjects)
		{
			id anclickedOb = [view.starScene graphicFromPath:relativePathToClickedOnObject index:NULL isSelected:NULL];
			NSAssert(anclickedOb!=nil, @"eek! relative path *MUST* correspond to a node");
			
			if([[anclickedOb originalNode] isKindOfClass:[Text class]]){
				doubleClickedGraphic = [anclickedOb originalNode];
				break;
			}
		}

		





		// so, where did we click? if we clicked on currently editing text swap
//		if( doubleClickedNode )
//		{
//			if ( clickedGraphicIsSelected )
//				doubleClickedGraphic = ((SelectedItem *)doubleClickedNode).originalNodeProxy.originalNode;
//			else
//				doubleClickedGraphic = ((NodeProxy *)doubleClickedNode).originalNode;
//
//			NSAssert( [doubleClickedGraphic isKindOfClass:[SelectedItem class]]==NO && [doubleClickedGraphic isKindOfClass:[NodeProxy class]]==NO, @"NO!" );
//			
//			if ( [doubleClickedGraphic isKindOfClass:[Text class]]==NO ) {
//				doubleClickedGraphic = nil;
//			}
//		}

		/* swap out current editing text */
		if( _editingGraphic && doubleClickedGraphic!=_editingGraphic ){
			[self stopEditingInSketchView:view];
		}		
		
		/* swap in new editing text */
		if( doubleClickedGraphic ){
			[self startEditingGraphic:doubleClickedGraphic inSketchView:view];
			// _creatingGraphic = nil;
		} else {
			// didnt click on anything we could edit… fall thru to tracking the mouse
			// doubleClickedGraphic = nil;
		}
	}
}

- (void)trackMouseDragWithEvent:(NSEvent *)event inStarView:(CALayerStarView *)view
{
	if(_editingGraphic) 	// if ( !doubleClickedGraphic && !_editingGraphic )
		return;

	NSPoint originalMouseLocation = [view convertPoint:[event locationInWindow] fromView:nil];

	// add the marquee widget to the view
	[_toolBarControl addWidgetToView:self];

	// Clear the selection.
	[view.starScene setCurrentFilteredContentSelectionIndexes:[NSIndexSet indexSet]];

	while ( [event type] != NSLeftMouseUp ) {
		event = [[view window] nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask)];
		NSPoint currentMouseLocation = [view convertPoint:[event locationInWindow] fromView:nil];

		// Figure out a new a selection rectangle based on the mouse location.
		NSRect newMarqueeSelectionBounds = NSMakeRect(fmin(originalMouseLocation.x, currentMouseLocation.x), fmin(originalMouseLocation.y, currentMouseLocation.y), fabs(currentMouseLocation.x - originalMouseLocation.x), fabs(currentMouseLocation.y - originalMouseLocation.y));
		if ( !NSEqualRects(newMarqueeSelectionBounds, _marqueeSelectionBounds) ) {
			// Erase the old selection rectangle and draw the new one.
//			[view setNeedsDisplayInRect:_marqueeSelectionBounds];
			_marqueeSelectionBounds = newMarqueeSelectionBounds;
//			[view setNeedsDisplayInRect:_marqueeSelectionBounds];

			/* The drawing loop is suspened at the moment - updates wont be sent from scene to view! */
			_dirtyRect = _marqueeSelectionBounds;
//			[view setNeedsDisplayInRect:_marqueeSelectionBounds];
			[[[NSApplication sharedApplication] delegate] forceUpdateInHijackedEventLoop];
		}
	}

	// Make it not there.
	[view removeWidget:self];

	// Unselect all items, add new text with _marqueeSelectionBounds and select it
	Class graphicClassToInstantiate = [Text class];
	[self createGraphicOfClass:graphicClassToInstantiate withEvent:event inStarView:view];

	_marqueeSelectionBounds = NSZeroRect;
}

- (void)createGraphicOfClass:(Class)graphicClass withEvent:(NSEvent *)event inStarView:(CALayerStarView *)view
{
	if ( _marqueeSelectionBounds.size.width > 2.0f && _marqueeSelectionBounds.size.height > 2.0 ) {
		// Create the new graphic and set it's bounds
		_creatingGraphic = [[graphicClass alloc] init];
		[_creatingGraphic setPosition:_marqueeSelectionBounds.origin];
		[_creatingGraphic setPhysicalBounds:_marqueeSelectionBounds];

		// Add it to the scene
		[view.starScene addGraphic:_creatingGraphic];
		[self startEditingGraphic:_creatingGraphic inSketchView:view];
	}


//    // Let the user size the new graphic until they let go of the mouse. Because different kinds of graphics have different kinds of handles, first ask the graphic class what handle the user is dragging during this initial sizing.
//    [self resizeGraphic:_creatingGraphic usingHandle:0 withEvent:event inSketchView:view];
//
//    // Did we really create a graphic? Don't check with !NSIsEmptyRect(createdGraphicBounds) because the bounds of a perfectly horizontal or vertical line is "empty" but of course we want to let people create those.
//    NSRect createdGraphicBounds = [_creatingGraphic physicalBounds];
//    if (NSWidth(createdGraphicBounds)!=0.0 || NSHeight(createdGraphicBounds)!=0.0)
//	{
//put back!!		[view.starScene changeSktSceneSelectionIndexes:[NSIndexSet indexSetWithIndex:0]];

	// The graphic wasn't sized to nothing during mouse tracking. Present its editing interface it if it's that kind of graphic (like Sketch's SKTTexts). Invokers of the method we're in right now should have already cleared out _editingView.

//    } else {
//    }

	[_creatingGraphic release];
	_creatingGraphic = nil;
}

/* If the graphic provides a custom view for editing we  add it to the stage */
- (void)startEditingGraphic:(Graphic *)graphic inSketchView:(CALayerStarView *)view
{
	NSParameterAssert([graphic isKindOfClass:[Graphic class ]]);
	NSParameterAssert(view != nil);

	// It's the responsibility of invokers to not invoke this method when editing has already been started.
	NSAssert((!_editingGraphic && !_editingView), @"-[SKTGraphicView startEditingGraphic:] is being mis-invoked.");

	// Select it.
	// -- from the proxy, or the selected item, how do we find the index of this item?
	int newTextIndex = [view.starScene indexOfOriginalObjectIdenticalTo:graphic];
	NSAssert(newTextIndex != NSNotFound, @"Failed to add new text!?");
	[view.starScene selectItemAtIndex:newTextIndex];

	// Can the graphic even provide an editing view?
	_editingView = [[self newEditingViewForGraphic:graphic withSuperviewBounds:[view bounds]] retain];

	if ( _editingView ) {
		// Keep a pointer to the graphic around so we can ask it to draw its "being edited" look, and eventually send it a -finalizeEditingView: message.
		_editingGraphic = [graphic retain];

		// If the editing view adds a ruler accessory view we're going to remove it when editing is done, so we have to remember the old reserved accessory view thickness so we can restore it. Otherwise there will be a big blank space in the ruler.
		//		_oldReservedThicknessForRulerAccessoryView = [[[self enclosingScrollView] horizontalRulerView] reservedThicknessForAccessoryView];

		// Make the editing view a subview of this one. It was the graphic's job to make sure that it was created with the right frame and bounds.
		[view addSubview:_editingView];

		// Make the editing view the first responder so it takes key events and relevant menu item commands.
		[[view window] makeFirstResponder:_editingView];

		// Get notified if the editing view's frame gets smaller, because we may have to force redrawing when that happens. Record the view's frame because it won't be available when we get the notification.
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNeedsDisplayForEditingViewFrameChangeNotification:) name:NSViewFrameDidChangeNotification object:_editingView];
		_editingViewFrame = [_editingView frame];

		// Give the graphic being edited a chance to draw one more time. In Sketch, SKTText draws a focus ring.
//		[view setNeedsDisplayInRect:[_editingGraphic drawingBounds]];
	}
}

- (NSView *)newEditingViewForGraphic:(Graphic *)graphic withSuperviewBounds:(NSRect)superviewBounds
{
	// Create a text view that has the same frame as this graphic. We use -[NSTextView initWithFrame:textContainer:] instead of -[NSTextView initWithFrame:] because the latter method creates the entire collection of objects associated with an NSTextView - its NSTextContainer, NSLayoutManager, and NSTextStorage - and we already have an NSTextStorage. The text container should be the width of this graphic but very high to accomodate whatever text is typed into it.
	NSAssert(graphic != nil, @"where is graphic?");
	NSRect bounds = [graphic drawingBounds];
	NSTextContainer *textContainer = [[NSTextContainer alloc] initWithContainerSize:NSMakeSize(bounds.size.width, 1.0e7f)];
	NSTextView *textView = [[NSTextView alloc] initWithFrame:bounds textContainer:textContainer];

	// Create a layout manager that will manage the communication between our text storage and the text container, and hook it up.
	NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
	[layoutManager addTextContainer:textContainer];
	[textContainer release];
	NSTextStorage *contents = [(Text *)graphic contents];
	NSAssert(contents!=nil, @"This should never happen");
	[contents addLayoutManager:layoutManager];
	[layoutManager release];

	// Of course text editing should be as undoable as anything else.
	[textView setAllowsUndo:YES];

	// This kind of graphic shouldn't appear opaque just because it's being edited.
	[textView setDrawsBackground:NO];

	// This is has been handy for debugging text editing view size problems though.
	[textView setBackgroundColor:[NSColor greenColor]];
	[textView setDrawsBackground:YES];

	// Start off with the all of the text selected.
	[textView setSelectedRange:NSMakeRange(0, [contents length])];

	// Specify that the text view should grow and shrink to fit the text as text is added and removed, but only in the vertical direction. With these settings the NSTextView will always be large enough to show an extra line fragment but never so large that the user won't be able to see just-typed text on the screen. Sending -setVerticallyResizable:YES to the text view without also sending -setMinSize: or -setMaxSize: would be useless by the way; the default minimum and maximum sizes of a text view are the size of the frame that is specified at initialization time.
	[textView setMinSize:NSMakeSize(bounds.size.width, 0.0)];
	[textView setMaxSize:NSMakeSize(bounds.size.width, superviewBounds.size.height - bounds.origin.y)];
	[textView setVerticallyResizable:YES];

	// The invoker doesn't have to release this object.
	return [textView autorelease];
}

- (void)setNeedsDisplayForEditingViewFrameChangeNotification:(NSNotification *)viewFrameDidChangeNotification
{
	// If the editing view got smaller we have to redraw where it was or cruft will be left on the screen.
	// If the editing view got larger we might be doing some redundant invalidation (not a big deal), but we're not doing any redundant drawing (which might be a big deal).
	// If the editing view actually moved then we might be doing substantial redundant drawing, but so far that wouldn't happen in Sketch.
	// In Sketch this prevents cruft being left on the screen when the user
	// 1) creates a great big text area and fills it up with text,
	// 2) sizes the text area so not all of the text fits,
	// 3) starts editing the text area but doesn't actually change it, so the text area hasn't been automatically resized and the text editing view
	// is actually bigger than the text area, and 4) deletes so much text in one motion (Select All, then Cut)
	// that the text editing view suddenly becomes smaller than the text area. In every other text editing situation the text editing
	// view's invalidation or the fact that the SKTText's "drawingBounds" changes is enough to cause the proper redrawing.
	NSView *editingView2 = [viewFrameDidChangeNotification object];

	NSAssert(editingView2 == _editingView, @"eh?");
	NSRect newEditingViewFrame = [editingView2 frame];
	[[_editingView superview] setNeedsDisplayInRect:NSUnionRect(_editingViewFrame, newEditingViewFrame)];
	_editingViewFrame = newEditingViewFrame;
}

- (void)stopEditingInSketchView:(CALayerStarView *)view
{
	// Make it harmless to invoke this method unnecessarily.
	if ( _editingView ) {
		// Undo what we did in -startEditingGraphic:.
		[[NSNotificationCenter defaultCenter] removeObserver:self name:NSViewFrameDidChangeNotification object:_editingView];

		// Pull the editing view out of this one. When editing is being stopped because the user has clicked in this view, outside of the editing view, NSWindow will have already made this view the window's first responder, and that's good. However, when editing is being stopped because the edited graphic is being removed (by undoing or scripting, for example), the invocation of -[NSView removeFromSuperview] we do here will leave the window as its own first responder, and that would be bad, so also fix the window's first responder if appropriate. It wouldn't be appropriate to steal first-respondership from sibling views here.

//		[view setNeedsDisplayInRect:[_editingView frame]];

		BOOL makeSelfFirstResponder = [[view window] firstResponder] == _editingView ? YES : NO;
		[_editingView removeFromSuperview];
		if ( makeSelfFirstResponder )
			[[view window] makeFirstResponder:view];


		// If the editing view added a ruler accessory view then remove it because it's not applicable anymore, and get rid of the blank space in the ruler that would otherwise result.
		// In Sketch the NSTextViews created by SKTTexts leave horizontal ruler accessory views.
		//		NSRulerView *horizontalRulerView = [[self enclosingScrollView] horizontalRulerView];
		//		[horizontalRulerView setAccessoryView:nil];
		//		[horizontalRulerView setReservedThicknessForAccessoryView:_oldReservedThicknessForRulerAccessoryView];

		// Give the graphic that created the editing view a chance to tear down their relationships and then forget about them both.
		[self finalizeEditingView:_editingView];
		[_editingGraphic release];
		_editingGraphic = nil;
		[_editingView release];
		_editingView = nil;
		NSLog(@"SWAPPED OUT - SWAPPED OUT");
	}
}


- (void)finalizeEditingView:(NSView *)editingView
{
	// Tell our text storage that it doesn't have to talk to the editing view's layout manager anymore.
	[[_editingGraphic contents] removeLayoutManager:[(NSTextView *) editingView layoutManager]];
}

//- (void)resizeGraphic:(Graphic *)graphic usingHandle:(NSInteger)handle withEvent:(NSEvent *)event inStarView:(CALayerStarView *)view {
//    while ([event type]!=NSLeftMouseUp)
//	{
//        event = [[view window] nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask)];
//        NSPoint handleLocation = [view convertPoint:[event locationInWindow] fromView:nil];
//
//        handle = [graphic resizeByMovingHandle:handle toPoint:handleLocation];
//        [graphic setPhysicalBounds:NSMakeRect(0,0,300,100)];
//
//    }
//}

#pragma mark Notification Methods
- (IBAction)selectToolAction:(id)sender
{
	[super selectToolAction:sender];

	_marqueeSelectionBounds = NSZeroRect;
	_dirtyRect = NSZeroRect;

	// -- needs to observe selection
	CALayerStarView *view = _toolBarControl.targetView;
	[view.starScene addObserver:self forKeyPath:@"currentFilteredContentSelectionIndexes" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial)context: @"TextTool"];

	// -- cursor
}

- (void)toolWillBecomeUnActive
{
	CALayerStarView *view = _toolBarControl.targetView;

	[self stopEditingInSketchView:view];

	// -- remove observers
	[view.starScene removeObserver:self forKeyPath:@"currentFilteredContentSelectionIndexes"];

	_marqueeSelectionBounds = NSZeroRect;
	_dirtyRect = NSZeroRect;

	// -- cursor

	[super toolWillBecomeUnActive];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(NSObject *)observedObject change:(NSDictionary *)change context:(void *)vcontext
{
	NSString *context = (NSString *)vcontext;

	if ( context == nil )
		[NSException raise:@"MUST SUPPLY A CONTEXT" format:@"MUST SUPPLY A CONTEXT"];

	if ( [context isEqualToString:@"TextTool"] ) {
		if ([keyPath isEqualToString:@"currentFilteredContentSelectionIndexes"] ) {
			[self enforceConsistentState];
			return;
		}
	}
	[super observeValueForKeyPath:keyPath ofObject:observedObject change:change context:vcontext];
}

- (NSRect)displaybounds
{
	return NSUnionRect(_marqueeSelectionBounds, _dirtyRect);
}

- (void)drawInStarView:(CALayerStarView *)value
{
	[[NSColor knobColor] set];

	// If the user is in the middle of selecting draw the selection rectangle.
	if ( !NSEqualRects(_marqueeSelectionBounds, NSZeroRect ))
		NSDottedFrameRect(_marqueeSelectionBounds);
}

@end
