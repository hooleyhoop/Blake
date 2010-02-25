//
//  SHInfoTextView.m
//  InterfaceTest
//
//  Created by Steve Hooley on 01/12/2004.
//  Copyright 2004 HooleyHoop. All rights reserved.
//

#import "SHInfoTextView.h"
// #import "SHSwapableView.h"

@implementation SHInfoTextView

/*
 * Because the textview overides mouse events the events
 * are not reaching swapableview.
 * Hence these are needed to forward the messages
*/
// NSView


// ===========================================================
// - initWithFrame:
// ===========================================================
- (id) initWithFrame: (NSRect) frame
{
    if((self = [super initWithFrame:frame]) != nil)
    {
		// NSLog(@"InfoTextFrame.m: initwithframe");
		trackRect = [self addTrackingRect:[self frame] owner:self userData:nil assumeInside:YES];
		[self setEditable:NO];
	}
	return self;
}


// ===========================================================
// - mouseDown:
// ===========================================================
- (void)mouseDown:(NSEvent *)event
{
//	[super mouseDown:event];
//	[[self superview]mouseDown:event];
    oldPointInWindow    = [event locationInWindow];
}


// ===========================================================
// - mouseDragged:
// ===========================================================
- (void)mouseDragged:(NSEvent *)event
{
	// NSLog(@"SHInfoTextView.m: mouse dragged");

//	[super mouseDragged:event];
//	[[self superview]mouseDragged:event];
	
	// is alt down  ?
//	 NSLog(@"SHInfoTextView.m: %@", [[[[[[[self superview]superview]superview]superview]superview]superview]class]);
	
	int ALT_DOWN = [(SHSwapableView*)[[[[[[self superview]superview]superview]superview]superview]superview]ALT_DOWN]; // in swapaleview
	
	if( ALT_DOWN==1 )
	{

		NSPoint currentPointInWindow    = [event locationInWindow];
		
		float angleX, angleY;
		angleX = currentPointInWindow.x - oldPointInWindow.x;
		angleY = currentPointInWindow.y - oldPointInWindow.y;
		
		// NSLog(@"SHInfoTextView.m: ALT mouse dragged");
		[(SHSwapableView*)[[[[[[self superview]superview]superview]superview]superview]superview]altMouseDragActionX:angleX Y:angleY];

		oldPointInWindow = currentPointInWindow;
	}
}

// ===========================================================
// - drawRect:
// ===========================================================
//- (void)drawRect:(NSRect)rect
//{

//	if([[self window] firstResponder]==self)
//	{
//		[[NSColor blackColor] set];
//	} else {
//		[[NSColor grayColor] set];
//	}
//	NSFrameRect(rect);
//	[super drawRect:rect ];
//}

// ===========================================================
// - viewDidMoveToSuperview:
// ===========================================================
//- (void)viewDidMoveToSuperview
//{
//	NSLog(@"SHInfoTextView.m: viewDidMoveToSuperview");
//}


@end
