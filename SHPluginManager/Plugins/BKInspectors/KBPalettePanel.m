//
//  KBPalettePanel.m
//  ----------------
//
//  Created by Keith Blount on 09/04/2006.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

/*
 
 TO DO
 -----
 
 Scroll views need to avoid resize indicator (which we draw manually).
 Does NSWindow have a private method for this???
 
 */

#import "KBPalettePanel.h"

NSString *KBPaletteResizeIndicatorStateDidChangeNotification = @"KBPaletteResizeIndicatorStateDidChangeNotification";

@interface KBPaletteContentView : NSView
@end

@implementation KBPaletteContentView
- (void)drawRect:(NSRect)rect
{
	if (![[self window] showsResizeIndicator])
		return;
	
	BOOL drawScrollResizer = NO;
	
	// Is there a scroll view in the bottom right corner?
	id v = [self hitTest:NSMakePoint([[self window] frame].size.width-8.0,
										  8.0)];
	
	if (v != nil && [v isKindOfClass:[NSScrollView class]])
	{
		if ([v hasVerticalScroller])
			drawScrollResizer = YES;
	}
	
	NSImage *resizeImg = drawScrollResizer ?
		[NSImage imageNamed:@"ScrollViewResizer" class:[self class]] :
		[NSImage imageNamed:@"ContentViewResizer" class:[self class]];
	
	[resizeImg compositeToPoint:NSMakePoint([self frame].size.width-15.0,
											0.0)
					  operation:NSCompositeSourceOver];
}
@end

@interface KBPaletteHeaderView : NSView
{
	NSButton *closeButton;
	int rolloverTrackingRectTag;
	NSImage *icon;
	NSString *keyEquivalentString;
}
- (void)setupCloseButtonTrackingRect;
- (void)removeCloseButtonTrackingRect;
- (void)addCloseButton;
- (void)removeCloseButton;
- (void)setIcon:(NSImage *)newIcon;
- (NSImage *)icon;
- (void)setKeyEquivalentString:(NSString *)string;
- (NSString *)keyEquivalentString;
@end

@implementation KBPaletteHeaderView

- (id)initWithFrame:(NSRect)frameRect
{
	if (self = [super initWithFrame:frameRect])
	{
		[self addCloseButton];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(controlTintDidChange:)
													 name:NSControlTintDidChangeNotification
												   object:NSApp];
	}
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[icon release];
	[keyEquivalentString release];
	[super dealloc];
}

- (void)controlTintDidChange:(NSNotification *)notification
{
	int tint = [[NSUserDefaults standardUserDefaults] integerForKey:@"AppleAquaColorVariant"];
	if (tint == NSGraphiteControlTint)
	{
		[closeButton setImage:[NSImage imageNamed:@"GraphiteWindowCloseBttn-N" class:[self class]]];
		[closeButton setAlternateImage:[NSImage imageNamed:@"GraphiteWindowCloseBttn-P" class:[self class]]];
	}
	else
	{
		[closeButton setImage:[NSImage imageNamed:@"BlueWindowCloseBttn-N" class:[self class]]];
		[closeButton setAlternateImage:[NSImage imageNamed:@"BlueWindowCloseBttn-P" class:[self class]]];
	}
}

- (void)addCloseButton
{
	closeButton = [[NSButton alloc] initWithFrame:NSMakeRect(6.0, 1.0, 14.0, 14.0)];
	[self addSubview:closeButton];
	[closeButton setAutoresizingMask:NSViewMaxXMargin|NSViewMinYMargin];
	[closeButton setBezelStyle:NSRoundedBezelStyle];
	[closeButton setButtonType:NSMomentaryChangeButton];
	[closeButton setBordered:NO];
	
	int tint = [[NSUserDefaults standardUserDefaults] integerForKey:@"AppleAquaColorVariant"];
	if (tint == NSGraphiteControlTint)
	{
		[closeButton setImage:[NSImage imageNamed:@"GraphiteWindowCloseBttn-N" class:[self class]]];
		[closeButton setAlternateImage:[NSImage imageNamed:@"GraphiteWindowCloseBttn-P" class:[self class]]];
	}
	else
	{
		[closeButton setImage:[NSImage imageNamed:@"BlueWindowCloseBttn-N" class:[self class]]];
		[closeButton setAlternateImage:[NSImage imageNamed:@"BlueWindowCloseBttn-P" class:[self class]]];
	}
	[closeButton setTitle:@""];
	[closeButton setImagePosition:NSImageBelow];
	//[closeButton setTarget:[self window]];
	[closeButton setFocusRingType:NSFocusRingTypeNone];
	[closeButton setAction:@selector(performClose:)];
	[closeButton release];
	[self setupCloseButtonTrackingRect];
}

- (void)removeCloseButton
{
	[closeButton removeFromSuperview];
	[self removeCloseButtonTrackingRect];
	closeButton = nil;
}

- (void)viewDidMoveToWindow
{
	[super viewDidMoveToWindow];
	
	[closeButton setTarget:[self window]];
	[self removeCloseButtonTrackingRect];
	[self setupCloseButtonTrackingRect];
}

- (void)setIcon:(NSImage *)newIcon
{
	[newIcon retain];
	[icon release];
	icon = newIcon;
	[self setNeedsDisplay:YES];
}

- (NSImage *)icon
{
	return icon;
}

- (void)setKeyEquivalentString:(NSString *)string
{
	[string retain];
	[keyEquivalentString release];
	keyEquivalentString = string;
	[self setNeedsDisplay:YES];
}

- (NSString *)keyEquivalentString
{
	return keyEquivalentString;
}

- (void)drawRect:(NSRect)rect
{
	BOOL isKey = [[self window] isKeyWindow];
	BOOL isPressed = [(KBPalettePanel *)[self window] titleBarIsPressed];
	BOOL isExpanded = [(KBPalettePanel *)[self window] isExpanded];
	
	NSRect frame = [self frame];
	NSImage *titleImg = isPressed ?
		(isKey ?
			[NSImage imageNamed:@"PaletteTitleBarActivePressed" class:[self class]] :
			[NSImage imageNamed:@"PaletteTitleBarInactivePressed" class:[self class]]) :
		(isKey ?
			[NSImage imageNamed:@"PaletteTitleBarActive" class:[self class]] :
			[NSImage imageNamed:@"PaletteTitleBarInactive" class:[self class]]);

	[titleImg drawInRect:NSMakeRect(0.0,
									frame.size.height - 16.0,
									frame.size.width,
									16.0)
				fromRect:NSMakeRect(0,0,[titleImg size].width,[titleImg size].height)
			   operation:NSCompositeSourceOver
				fraction:1.0];
	
	NSImage *discloseImg = isExpanded ?
		(isPressed ?
			[NSImage imageNamed:@"DisclosureDownPressed" class:[self class]] :
			[NSImage imageNamed:@"DisclosureDownNormal" class:[self class]]) :
		(isPressed ?
			[NSImage imageNamed:@"DisclosureRightPressed" class:[self class]] :
			[NSImage imageNamed:@"DisclosureRightNormal" class:[self class]]);
	
	NSSize s = [discloseImg size];
	[discloseImg compositeToPoint:NSMakePoint(26.0,
											 (frame.size.height-s.height)/2.0)
						operation:NSCompositeSourceOver];
	
	float xPos = 45.0;
	
	if (icon != nil)
	{
		s = [icon size];
		[icon compositeToPoint:NSMakePoint(xPos, (frame.size.height-s.height)/2.0)
					 operation:NSCompositeSourceOver];
		xPos += s.width + 8.0;
	}
	
	NSString *title = [[self window] title];
	
	if ([title length] > 0)
	{
		NSDictionary *attribs = [NSDictionary dictionaryWithObjectsAndKeys:
			[NSFont systemFontOfSize:10.0], NSFontAttributeName,
			nil];
		s = [title sizeWithAttributes:attribs];
		[title drawAtPoint:NSMakePoint(xPos, (frame.size.height-s.height)/2.0 + 1.0)
			withAttributes:attribs];
	}
	
	NSString *keyEquivalent = [self keyEquivalentString];
	
	if ([keyEquivalent length] > 0)
	{
		NSDictionary *attribs = [NSDictionary dictionaryWithObjectsAndKeys:
			[NSFont systemFontOfSize:10.0], NSFontAttributeName,
			[NSColor colorWithCalibratedWhite:(90.0/255.0) alpha:1.0], NSForegroundColorAttributeName,
			nil];
		
		s = [keyEquivalent sizeWithAttributes:attribs];
		[keyEquivalent drawAtPoint:NSMakePoint(frame.size.width - s.width - 10.0,
											   (frame.size.height-s.height)/2.0 + 1.0)
					withAttributes:attribs];
	}
}

- (void)mouseEntered:(NSEvent *)theEvent
{
	int tint = [[NSUserDefaults standardUserDefaults] integerForKey:@"AppleAquaColorVariant"];
	if (tint == NSGraphiteControlTint)
		[closeButton setImage:[NSImage imageNamed:@"GraphiteWindowCloseBttn-H" class:[self class]]];
	else
		[closeButton setImage:[NSImage imageNamed:@"BlueWindowCloseBttn-H" class:[self class]]];
}

- (void)mouseExited:(NSEvent *)theEvent
{
	int tint = [[NSUserDefaults standardUserDefaults] integerForKey:@"AppleAquaColorVariant"];
	if (tint == NSGraphiteControlTint)
		[closeButton setImage:[NSImage imageNamed:@"GraphiteWindowCloseBttn-N" class:[self class]]];
	else
		[closeButton setImage:[NSImage imageNamed:@"BlueWindowCloseBttn-N" class:[self class]]];
}

- (void)removeCloseButtonTrackingRect
{
	// If we have a tracking rect, then remove it
	if (rolloverTrackingRectTag > 0)
	{
		[self removeTrackingRect:rolloverTrackingRectTag];
		rolloverTrackingRectTag = 0;
	}
}

- (void)setupCloseButtonTrackingRect
{
	rolloverTrackingRectTag = [self addTrackingRect:NSMakeRect(6.0, 1.0, 14.0, 14.0)
											  owner:self
										   userData:NULL
									   assumeInside:NO];
}

@end


@interface KBPalettePanel (Private)
- (void)windowDidMove:(id)notification;
- (void)springCoordinate:(float *)coord to:(float)coord inPoint:(NSPoint *)pt;
- (NSRect)titleBarRect;
- (NSRect)resizeIndicatorRect;
- (NSView *)actualContentView;
- (KBPaletteHeaderView *)headerView;
- (void)setEnableResizeIndicatorIfAllowed:(BOOL)flag;
@end

@implementation KBPalettePanel

/*************************** Init/Dealloc ***************************/

#pragma mark -
#pragma mark Init/Dealloc

- (id)initWithContentRect:(NSRect)contentRect styleMask:(unsigned int)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
    // Enforce borderless window; allows us to handle dragging ourselves
    if (self = [super initWithContentRect:contentRect
                            styleMask:NSBorderlessWindowMask
                              backing:bufferingType
								defer:flag])
	{
		// NOTE: a side-effect of using NSBorderlessWindowMask is that the window has NO TITLEBAR.
		// This is necessary in order to implement snapping *during* dragging, instead of *after* dragging.
		// We draw the title bar and resize indicator ourselves in our custom content view.
    
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	
		[nc addObserver:self
			   selector:@selector(windowDidMove:)
				   name:NSWindowDidMoveNotification
				 object:self];

		[self setHasShadow:YES];
		[self useOptimizedDrawing:YES];
		[self setSnapsToEdges:YES];
		[self setSnapTolerance:20.0];
		[self setPadding:0.0];
	
		[self setShowsResizeIndicator:YES];
	
		[self setFloatingPanel:YES];
		isExpanded = YES;
	
	}
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

/*************************** NSPanel overrides ***************************/

#pragma mark -
#pragma mark NSPanel overrides


- (void)setContentView:(NSView *)aView
{
	if (!didFinishLoading)
	{
		[super setContentView:aView];
		return;
	}
	
	if (innerContentView)
		[innerContentView removeFromSuperview];
	
	NSRect contentFrame = [NSWindow contentRectForFrameRect:[self frame] styleMask:NSBorderlessWindowMask];
	contentFrame.origin = NSZeroPoint;
	contentFrame.size.height -= [self titleBarRect].size.height;
	[aView setFrame:contentFrame];
	[[self actualContentView] addSubview:aView];
	[aView setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];

	innerContentView = aView;	// Save a pointer to the view
}

- (NSView *)contentView
{
	return innerContentView;
}

- (void)awakeFromNib
{
	NSView *oldContent = [[self actualContentView] retain];
	[oldContent removeFromSuperview];
	
	NSRect cFrame = [NSWindow contentRectForFrameRect:[self frame] styleMask:NSBorderlessWindowMask];
	KBPaletteContentView *content = [[KBPaletteContentView alloc] initWithFrame:cFrame];
	[super setContentView:content];
	[content release];
	
	cFrame = [self titleBarRect];
	headerView = [[KBPaletteHeaderView alloc] initWithFrame:cFrame];
	[headerView setAutoresizingMask:NSViewWidthSizable|NSViewMinYMargin];
	[content addSubview:headerView];
	[headerView release];
	
	NSRect contentFrame = [[self actualContentView] frame];
	contentFrame.size.height -= [self titleBarRect].size.height;
	[oldContent setFrame:contentFrame];
	[[self actualContentView] addSubview:oldContent];
	[oldContent setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];

	innerContentView = oldContent;	// Save a pointer to the view
	
	didFinishLoading = YES;
	
	[self setIcon:[NSImage imageNamed:@"TESTIcon" class:[self class]]];
}

- (NSView *)actualContentView
{
	return [super contentView];
}

- (KBPaletteHeaderView *)headerView
{
	return headerView;
}

- (void)setEnableResizeIndicatorIfAllowed:(BOOL)flag
{
	BOOL canShowWidget = ([self isExpanded] && ![self attachedPalette] && flag && resizeAllowed);

	[super setShowsResizeIndicator:canShowWidget];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:KBPaletteResizeIndicatorStateDidChangeNotification
														object:self];
}

- (void)setShowsResizeIndicator:(BOOL)flag
{
	[super setShowsResizeIndicator:flag];
	resizeAllowed = flag;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:KBPaletteResizeIndicatorStateDidChangeNotification
														object:self];
}

// Borderless windows cannot become key by default, so we have to override this.
- (BOOL)canBecomeKeyWindow
{
	return YES;
}

- (void)becomeKeyWindow
{
	[super becomeKeyWindow];
	[[self headerView] setNeedsDisplay:YES];
}

- (BOOL)becomesKeyOnlyIfNeeded
{
	return YES;
}

- (void)resignKeyWindow
{
	[super resignKeyWindow];
	[[self headerView] setNeedsDisplay:YES];
}

- (void)performClose:(id)sender
{
	if ([[self delegate] respondsToSelector:@selector(windowShouldShouldClose:)])
	{
		if ([[self delegate] windowShouldClose:sender] == NO)
			return;
	}
	
	// Detach from any parent windows (shouldn't close if attached to parents, really)
	if ([self parentWindow] != nil)
		[[self parentWindow] removeChildWindow:self];
	
	[self close];

	// Order out children
	NSEnumerator *e = [[self attachedPalettes] objectEnumerator];
	id win;
	while (win = [e nextObject])
		[win close];
}

/*************************** Mouse Handling ***************************/

#pragma mark -
#pragma mark Mouse Handling

// Since we don't have a titlebar, we handle window-dragging ourselves.

- (void)mouseDown:(NSEvent *)theEvent
{
    dragStartLocation = [theEvent locationInWindow];
	initialWindowFrame = [self frame];
	
	// Is this a resize operation?
	if (NSPointInRect(dragStartLocation,[self resizeIndicatorRect]) &&
		([self showsResizeIndicator] == YES) )
		isResizeOperation = YES;
    else
		isResizeOperation = NO;
	
	if (NSPointInRect(dragStartLocation,[self titleBarRect]))
	{
		titleBarIsPressed = YES;
		[[self headerView] setNeedsDisplay:YES];
	}
	else
		titleBarIsPressed = NO;
	
	windowMoved = NO;
}

- (void)sendEvent:(NSEvent *)theEvent
{
	NSPoint location = [theEvent locationInWindow];
	NSEventType type = [theEvent type];
	
	if ([self isVisible] && (type == NSLeftMouseDown || type == NSLeftMouseDragged || type == NSLeftMouseUp))
	{
		NSView *v = [[self actualContentView] hitTest:location];
		
		BOOL needsKey = [v needsPanelToBecomeKey];
		
		// Scroll view is a special case - if we click on the scroller of a scroll view,
		// we want its document view to become key if necessary...
		if ([[v superview] isKindOfClass:[NSScrollView class]])
			needsKey = [[(NSScrollView *)[v superview] documentView] needsPanelToBecomeKey];
		
		// Make sure the resizer always works
		BOOL passToView = (v != nil && 
						   (![self showsResizeIndicator] ||
							!NSPointInRect(location,[self resizeIndicatorRect])));
			
		if (type == NSLeftMouseDown)
		{
			// May need to check something higher than contentView?
			if (![self isKeyWindow])
			{
				if (![self becomesKeyOnlyIfNeeded] || needsKey)
					[self makeKeyAndOrderFront:self];
				else
					[self orderFront:self];
			}
			
			// Activate the app *after* making the receiver key, as app
			// activation tries to make the previous key window key
			if ([NSApp isActive] == NO)
				[NSApp activateIgnoringOtherApps:YES];
			
			// Now ensure that we receive -mouseDown: for moving the window
			if (passToView)
				[v mouseDown:theEvent];
			else
				[self mouseDown:theEvent];
		}
		else if (type == NSLeftMouseDragged)
		{
			if (passToView)
				[v mouseDragged:theEvent];
			else
				[self mouseDragged:theEvent];
		}
		else if (type == NSLeftMouseUp)
		{
			if (passToView)//(v != nil)
				[v mouseUp:theEvent];
			else
				[self mouseUp:theEvent];
		}
	}
	else
		[super sendEvent:theEvent];
}


- (void)detachChildPalettes
{
	KBPalettePanel *attachedWin = [self attachedPalette];
	
	if (attachedWin == nil)
		return;
	
	[self removeChildWindow:attachedWin];
	[[attachedWin headerView] addCloseButton];
	[self setEnableResizeIndicatorIfAllowed:YES];
	
	// This is a silly hack, but it seems that removing child windows cause child windows of the
	// children to lose their ordering relationships, so we fix that here...
	KBPalettePanel *palette = attachedWin;//self;
	while (palette != nil)
	{
		if ([palette attachedPalette] != nil)
		{
			KBPalettePanel *child = [palette attachedPalette];
			[palette removeChildWindow:child];
			[palette addChildWindow:child ordered:NSWindowAbove];
		}
		palette = [palette attachedPalette];
	}
}


- (void)mouseDragged:(NSEvent *)theEvent
{
    if([theEvent type] != NSLeftMouseDragged)
		return;
	
	NSRect frame = [self frame];
	NSPoint origin = frame.origin;
	NSPoint newLocation = [theEvent locationInWindow];

	// Is this a resize operation? If so, resize the window and return.
	
	if(isResizeOperation)	// Check collapsed!
	{
		// Get the current local mouse location via the global coordinates;
		// this ensures we get the right coordinates in case the resizing 
		// of the window is not following fast enough.
		NSPoint currentLocation = [self convertBaseToScreen:[self mouseLocationOutsideOfEventStream]];
		currentLocation.x -= initialWindowFrame.origin.x;
		currentLocation.y -= initialWindowFrame.origin.y;
		
		// NOTE: need to deal with minSize, maxSize and aspect ratio
			
		float deltaX = currentLocation.x - dragStartLocation.x;
		float deltaY = currentLocation.y - dragStartLocation.y;
		
		NSRect newFrame = NSMakeRect(initialWindowFrame.origin.x,
									 initialWindowFrame.origin.y + deltaY,
									 initialWindowFrame.size.width + deltaX,
									 initialWindowFrame.size.height - deltaY);
		
		if (newFrame.size.width > [self maxSize].width)
			newFrame.size.width = [self maxSize].width;
		else if (newFrame.size.width < [self minSize].width)
			newFrame.size.width = [self minSize].width;
		
		if (newFrame.size.height > [self maxSize].height)
		{
			newFrame.size.height = [self maxSize].height;
			newFrame.origin.y = initialWindowFrame.origin.y + (initialWindowFrame.size.height - newFrame.size.height);
		}
		else if (newFrame.size.height < [self minSize].height)
		{
			newFrame.size.height = [self minSize].height;
			newFrame.origin.y = initialWindowFrame.origin.y + (initialWindowFrame.size.height - newFrame.size.height);
		}

		[self setFrame:newFrame display:YES];
		return;
	}
	
	// Is the drag inside the title bar rect? If not, return
	if (!NSPointInRect(dragStartLocation, [self titleBarRect]))
	{
		return;
	}
	
	// We move the window manually
	NSPoint newOrigin = NSMakePoint(origin.x + newLocation.x - dragStartLocation.x,
									origin.y + newLocation.y - dragStartLocation.y);
	
	frame.origin = newOrigin;
	
	if ([self parentWindow] != nil)
	{
		NSRect parentFrame = [[self parentWindow] frame];
		if ( (NSMaxY(frame) < parentFrame.origin.y - snapTolerance) ||
			 (NSMaxY(frame) > parentFrame.origin.y + snapTolerance) ||
			 (frame.origin.x > parentFrame.origin.x + (parentFrame.size.width/2.0)) ||
			 (NSMaxX(frame) < parentFrame.origin.x + (parentFrame.size.width/2.0)) )
		{
			if ([[self parentWindow] isKindOfClass:[KBPalettePanel class]])
				[(KBPalettePanel *)[self parentWindow] detachChildPalettes];
		}
		else
			return;
	}
	
	[self setFrameOrigin:newOrigin];
}

- (void)mouseUp:(NSEvent *)theEvent
{
	[super mouseUp:theEvent];
	
	if ( titleBarIsPressed)
	{
		if (windowMoved )
		{
			// Should we be attached to another palette?
			if (paletteToAttachTo != nil)
				[self attachToPalette:paletteToAttachTo];
			if (paletteToAttach != nil)
				[paletteToAttach attachToPalette:[self lastPaletteInGroup]];
		}
		else
			[self setExpanded:![self isExpanded]];
	}
	
	titleBarIsPressed = NO;
	windowMoved = NO;
	paletteToAttachTo = nil;
	paletteToAttach = nil;
	[[self headerView] setNeedsDisplay:YES];
}

- (void)windowDidMove:(id)notification
{
	if (isExpanding)
		return;
	
	windowMoved = YES;
	paletteToAttachTo = nil;
	paletteToAttach = nil;
	
    // Get some useful values
    NSRect myFrame = [self frame];
	
    NSPoint aPoint = myFrame.origin;
    float windowX = myFrame.origin.x;
    float windowY = myFrame.origin.y;
    float windowW = myFrame.size.width;
    float windowH = myFrame.size.height;
	
	NSEnumerator *e = [[self attachedPalettes] objectEnumerator];
	id child = self;
	float childH = 0.0;
	while (child != nil)
	{
		child = [child attachedPalette];
		if (child != nil)
			childH += [child frame].size.height;
	}

    NSRect myScreenFrame = [[self screen] visibleFrame];

    
    // Don't snap if Option/Alt key is held down during drag.
     //   Feel free to comment out the "return;" line below if you want to always snap.
    if ([[NSApp currentEvent] modifierFlags] & NSAlternateKeyMask)
	{
        return;
    }
    
    if ([self snapsToEdges] && (snapping == NO))
	{
        snapping = YES; // so we don't keep getting NSWindowDidMoveNotifications whilst we are snapping the window

        // Bottom of the screen
		//if ( (windowY-childH < myScreenFrame.origin.y + snapTolerance) &&
		if ( (windowY-childH < myScreenFrame.origin.y) &&
			 (windowY-childH > myScreenFrame.origin.y - snapTolerance*2) &&
			 (NSMaxY(myFrame) < NSMaxY(myScreenFrame)) )
            [self springCoordinate:&(aPoint.y) to:myScreenFrame.origin.y+childH + padding inPoint:&aPoint];
		
		// Top of screen (note that we use an else because we don't want it to jitter between the two
		if (NSMaxY(myFrame) > NSMaxY(myScreenFrame))
            [self springCoordinate:&(aPoint.y) to:(NSMaxY(myScreenFrame)-windowH) - padding inPoint:&aPoint];
        
        // Left hand side of the screen
		if ( (windowX < myScreenFrame.origin.x) &&
			 (windowX > myScreenFrame.origin.x - snapTolerance*2) )
            [self springCoordinate:&(aPoint.x) to:myScreenFrame.origin.x + padding inPoint:&aPoint];
        
        // Right hand side of the screen
		if ( (NSMaxX(myFrame) > NSMaxX(myScreenFrame)) &&
			 (NSMaxX(myFrame) < NSMaxX(myScreenFrame) + snapTolerance*2) )
			[self springCoordinate:&(aPoint.x) to:(NSMaxX(myScreenFrame)-windowW) - padding inPoint:&aPoint];
        
        // Add your custom logic here to deal with snapping to other edges,
		//   such as the edges of other windows.
        
        // Suggestion for custom logic to deal with snapping to other windows:
        //    1. Get a list of your app's windows, other than this one.
        //    2. Ignore any that aren't of a type you want this window to snap to.
        //    3. Loop through them like this:
        //    3-1. Get the window's frame.
        //    3-2. Expand its frame by snapTolerance, using NSInsetRect(theWindowFrame, -snapTolerance, -snapTolerance).
        //    3-3. Check to see if this window's frame intersects with the expanded frame, using NSIntersectsRect()
        //    3-4. If so, do appropriate snapping.
        //    4. Optionally, continue looping through all other windows and do appropriate snapping similarly.
		
		// Snap to left or right of main window
		NSWindow *mainWindow = [NSApp mainWindow];
		if (mainWindow != nil)
		{
			NSRect mainWinFrame = [mainWindow frame];
			
			float xRight = NSMaxX(mainWinFrame) + 2.0;
			if ( (windowX < xRight + snapTolerance) &&
				 (windowX > xRight - snapTolerance) )//&&
				[self springCoordinate:&(aPoint.x) to:xRight + padding inPoint:&aPoint];
			
			float xLeft = mainWinFrame.origin.x - 2.0;
			if ( (NSMaxX(myFrame) > xLeft - snapTolerance) &&
				 (NSMaxX(myFrame) < xLeft + snapTolerance) )//&&
				[self springCoordinate:&(aPoint.x) to:(xLeft - windowW) - padding inPoint:&aPoint];
		}
		
		// Snap to bottom of other palette windows (and become a child window of them...)

		e = [[NSApp windows] objectEnumerator];
		id win;
		NSRect winFrame;

		while (win = [e nextObject])
		{
			if ([win isKindOfClass:[KBPalettePanel class]] &&
				[win isVisible] &&
				win != self &&
				![[self attachedPalettes] containsObject:win])
			{
				winFrame = [win frame];
				
				// Are we underneath another palette?
				if ( (NSMaxY(myFrame) > winFrame.origin.y - snapTolerance) &&
					 (NSMaxY(myFrame) < winFrame.origin.y + snapTolerance)  &&
					 (myFrame.origin.x < winFrame.origin.x + (winFrame.size.width/2.0)) &&
					 (NSMaxX(myFrame) > winFrame.origin.x + (winFrame.size.width/2.0)) )
				{
					if ( ([self parentWindow] == nil) && ([win attachedPalette] == nil) )
					{
						[self springCoordinate:&myFrame.origin.x to:winFrame.origin.x inPoint:&myFrame.origin];
						[self springCoordinate:&myFrame.origin.y to:winFrame.origin.y-myFrame.size.height inPoint:&myFrame.origin];
						paletteToAttachTo = win;
					}
				}
				
				// Are we directly above another palette?
				else if ( (NSMaxY(winFrame) > myFrame.origin.y-childH - snapTolerance) &&
						  (NSMaxY(winFrame) < myFrame.origin.y-childH + snapTolerance)  &&
						  (myFrame.origin.x < winFrame.origin.x + (winFrame.size.width/2.0)) &&
						  (NSMaxX(myFrame) > winFrame.origin.x + (winFrame.size.width/2.0)) )
				{
					if ( ([win parentWindow] == nil) )
					{						
						// Snap own co-ordinates
						[self springCoordinate:&myFrame.origin.x to:winFrame.origin.x inPoint:&myFrame.origin];
						[self springCoordinate:&myFrame.origin.y to:NSMaxY(winFrame)+childH inPoint:&myFrame.origin];
						
						paletteToAttach = win;
					}
				}
			}
		}
        
        snapping = NO;
    }
}

/*************************** Helper Methods ***************************/

#pragma mark -
#pragma mark Helper Methods

- (void)springCoordinate:(float *)start to:(float)dest inPoint:(NSPoint *)pt
{
	if ([self parentWindow] != nil)
		return;
	
    *start = dest;
    [self setFrameOrigin:*pt];
}

/*************************** Accessors ***************************/

#pragma mark -
#pragma mark Accessors

- (void)setExpanded:(BOOL)flag {
	[self setExpanded:flag animate:YES];
}

- (void)setExpanded:(BOOL)flag animate:(BOOL)animate {
	isExpanded = flag;
	
	// Hmm... For some reason we actually have to retain the whole content view during the expansion/collapse process,
	// otherwise we are left with a blank window (this bug only showed up on Intel...).
	[[super contentView] retain];
	
	NSRect oldFrame = [self frame];
	NSRect newFrame = oldFrame;
	NSRect titleRect = [self titleBarRect];
	NSRect childFrame;
	NSWindow *child = [self attachedPalette];
	if (child != nil)
		childFrame = [child frame];
	NSRect newChildFrame = childFrame;
	
	if (flag)	// Need a collapsed flag
	{
		newFrame.size.height = precollapsedHeight;
		newFrame.origin.y -= precollapsedHeight - titleRect.size.height;
		
		newChildFrame.origin.y -= (precollapsedHeight-titleRect.size.height);
		
		[self setEnableResizeIndicatorIfAllowed:YES];
	}
	else
	{
		// Note -contentView is not the actual window content view in our subclass,
		// so can have its flags changed
		[[self contentView] setAutoresizingMask:NSViewWidthSizable|NSViewMinYMargin];
		
		precollapsedHeight = newFrame.size.height;
		newFrame.size = titleRect.size;
		newFrame.origin.y += precollapsedHeight - titleRect.size.height;
		
		newChildFrame.origin.y += precollapsedHeight - titleRect.size.height;
		
		[self setEnableResizeIndicatorIfAllowed:NO];	// Can't resize when collapsed
	}
	
	if (animate) {
		isExpanding = YES;
		
		// time that the resize is expected to take in seconds
		NSTimeInterval resizeTime;
		// velocity
		NSRect v;
		// time parameter
		float t;
		float tdiff;
			
		v.origin.y = oldFrame.origin.y - newFrame.origin.y;
		v.size.height = oldFrame.size.height - newFrame.size.height;
			
		resizeTime = [self animationResizeTime:newFrame];
		tdiff = 0.075 / resizeTime;
			
		[NSEvent startPeriodicEventsAfterDelay: 0 withPeriod: 0.02];
		t = 1.0;
		while (t > 0.0)
		{
			NSEvent *theEvent = [NSApp nextEventMatchingMask:NSPeriodicMask
												   untilDate:[NSDate distantFuture]
													  inMode:NSEventTrackingRunLoopMode
													 dequeue:YES];
				
			if ([theEvent type] == NSPeriodic)
			{
				NSRect tempFrame;
					
				t -= tdiff;
				if (t <= 0.0)
				{
					break;
				}
					
				// move
				tempFrame = oldFrame;
				tempFrame.origin.y = newFrame.origin.y + v.origin.y * t - childFrame.size.height;
					
				// stretch
				tempFrame.size.height = newFrame.size.height + v.size.height * t + childFrame.size.height;
				
				[self setFrame: tempFrame display:YES];
			}
		}
		[NSEvent stopPeriodicEvents];
		
		if (child != nil)
		{
			// Snap to place now to avoid gaps
			[child setFrameTopLeftPoint:NSMakePoint(newFrame.origin.x,
													newFrame.origin.y)];//+1.0)];
		}
		
		isExpanding = NO;
		
		[self setFrame:newFrame display:YES];
	} else {
		[child setFrameTopLeftPoint:NSMakePoint(newFrame.origin.x,
												newFrame.origin.y)];//+1.0)];
		[self setFrame:newFrame display:YES];
		
	}
	
	// should remove and reinsert view here...
	if (flag)
	{
		[[self contentView] setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
	}
	
	[[super contentView] release];
}

- (BOOL)isExpanded
{
	return isExpanded;
}

- (void)setFrame:(NSRect)frameRect display:(BOOL)displayFlag
{
	NSRect oldFrame = [self frame];
	
	[super setFrame:frameRect display:displayFlag];
	
	// This stuff may be affecting the attachToPalette: method...
	
	KBPalettePanel *child = [self attachedPalette];
	if (child != nil)
	{
		// If we are only changing the height, just set the origin of the child (this is much quicker)
		if (oldFrame.size.height != frameRect.size.height)// && oldFrame.size.width == frameRect.size.width)
		{
			[child setFrameTopLeftPoint:NSMakePoint(frameRect.origin.x,
													frameRect.origin.y + (isExpanding? [child frame].size.height : 0.0))];
													//frameRect.origin.y + 1.0 + (isExpanding? [child frame].size.height : 0.0))];
		}
	}
	
	NSWindow *parent = [self parentWindow];
	if (parent == nil)
		return;
	
	// This works fine....
	if (oldFrame.size.width != frameRect.size.height)
	{
		NSRect pFrame = [parent frame];
		pFrame.size.width = frameRect.size.width;
		[parent setFrame:pFrame display:displayFlag];
	}
	 
}

- (NSRect)titleBarRect
{
	NSRect frame = [self frame];
	return NSMakeRect(0.0,
					  frame.size.height - 16.0,
					  frame.size.width,
					  16.0);
}

- (NSRect)resizeIndicatorRect
{
	NSRect frame = [self frame];
	return NSMakeRect(frame.size.width - 15.0,
					  0.0,
					  15.0,
					  15.0);
}

- (void)setSnapsToEdges:(BOOL)flag
{
    snapsToEdges = flag;
}

- (BOOL)snapsToEdges
{
    return snapsToEdges;
}

- (void)setSnapTolerance:(float)tolerance
{
    snapTolerance = MIN([self titleBarRect].size.height,tolerance);
}

- (float)snapTolerance
{
    return snapTolerance;
}

- (void)setPadding:(float)newPadding
{
    padding = newPadding;
}

- (float)padding
{
    return padding;
}

- (BOOL)titleBarIsPressed
{
	return titleBarIsPressed;
}

- (KBPalettePanel *)attachedPalette
{
	NSArray *children = [self childWindows];
	if ([children count] > 0)
	{
		if ([[children objectAtIndex:0] isKindOfClass:[KBPalettePanel class]])
			return [children objectAtIndex:0];
	}
	return nil;
}

- (KBPalettePanel *)lastPaletteInGroup
{
	NSArray *palettes = [self attachedPalettes];
	return ([palettes count] > 0) ? [palettes lastObject] : self;
}

- (NSArray *)attachedPalettes
{
	NSMutableArray *palettes = [NSMutableArray array];
	KBPalettePanel *palette = self;
	while (palette != nil)
	{
		palette = [palette attachedPalette];
		if (palette != nil)
			[palettes addObject:palette];
	}
	
	return palettes;
}

- (KBPalettePanel *)firstPaletteInGroup
{
	id palette, parent = self;
	while (parent != nil)
	{
		palette = parent;
		parent = [palette parentWindow];
	}
	return palette;
}

- (float)groupHeight
{
	id palette = [self firstPaletteInGroup];
	float childH = 0.0;
	while (palette != nil)
	{
		childH += [palette frame].size.height;
		palette = [palette attachedPalette];
	}
	return childH;
}

- (void)attachToPalette:(KBPalettePanel *)anotherPalette
{
	[anotherPalette addChildWindow:self ordered:NSWindowAbove];
	[anotherPalette setEnableResizeIndicatorIfAllowed:NO];
	[[self headerView] removeCloseButton];
	
	// Now we resize ourself and all of our children so that we fit snugly beneath our parent.
	// Note that we use the frame of the first palette in the group for this, as there is no
	// guarantee that all of its children have had their frames updated at this point (including
	// the palette we are snapping on to), which means that we could end up in the wrong position if
	// we only used the frame of anotherPalette.
	
	// At this point, the only palette that is guaranteed to be in the right place is the topmost
	// one, so we use that one to calculate the frame of everything else.
	id child = [anotherPalette firstPaletteInGroup];
	NSRect f, mainPaletteFrame = [child frame];
	
	// Go through all children and ensure their frames are correct...
	child = [child attachedPalette];//self;
	
	// Actually, don't we only need to set the frame of the first child - the rest
	// will get updated in setFrame...?
	
	BOOL setFrame = NO;	// We only want to calculate the height of everything up to self
		
	// At this point, we must be in the right position, because we will have been sprung there...
	float yPos = mainPaletteFrame.origin.y;
	while (child != nil)
	{
		f = [child  frame];
		f.origin.x = mainPaletteFrame.origin.x;
		f.origin.y = yPos - f.size.height;
		yPos -= f.size.height;
		f.size.width = mainPaletteFrame.size.width;
		if (child == self)
			setFrame = YES;
		
		if (setFrame == YES)
			[child setFrame:f display:YES];	// THIS IS STILL PROBLEMATIC !!!
		
		if (child = [child attachedPalette])
			[child orderWindow:NSWindowAbove relativeTo:[[child parentWindow] windowNumber]];
	}
}

- (void)setIcon:(NSImage *)newIcon
{
	[headerView setIcon:newIcon];
}

- (NSImage *)icon
{
	return [headerView icon];
}

- (void)setKeyEquivalentString:(NSString *)string
{
	[headerView setKeyEquivalentString:string];
}

- (NSString *)keyEquivalentString
{
	return [headerView keyEquivalentString];
}

- (void)setGroupVisible:(BOOL)isVisible {
	if (isVisible) {
		[self orderFront:nil];
		[[self attachedPalettes] makeObjectsPerformSelector:@selector(orderFront:)];
	} else {
		[self orderOut:nil];
		[[self attachedPalettes] makeObjectsPerformSelector:@selector(orderOut:)];
	}
}

- (NSDictionary *)configurationDictionary {
	NSRect frame = [self frame];
	
	if (![self isExpanded]) {
		frame.size.height = precollapsedHeight;
		frame.origin.y -= precollapsedHeight - [self titleBarRect].size.height;
	}
	
	return [NSDictionary dictionaryWithObjectsAndKeys:
		[NSNumber numberWithBool:[self isExpanded]], @"isExpanded",
		[NSNumber numberWithFloat:precollapsedHeight], @"precollapsedHeight",
		NSStringFromRect(frame), @"frame",
		nil];
}

- (void)setConfigurationFromDictionary:(NSDictionary *)configurationDictionary {
	[self setFrame:NSRectFromString([configurationDictionary objectForKey:@"frame"]) display:NO];
//	[self setFrameFromString:[configurationDictionary objectForKey:@"frame"]];
	
	if ([configurationDictionary objectForKey:@"isExpanded"] && ![[configurationDictionary objectForKey:@"isExpanded"] boolValue]) {
//		NSRect frame = [self frame];
//		frame.size.height = [[configurationDictionary objectForKey:@"precollapsedHeight"] floatValue];
//		frame.size.height = [[configurationDictionary objectForKey:@"precollapsedHeight"] floatValue];
//		[self setFrame:frame display:NO];
		[self setExpanded:NO animate:NO];
	}	
}

@end
