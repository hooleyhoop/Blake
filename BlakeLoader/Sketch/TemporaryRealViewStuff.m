//
//  TemporaryRealViewStuff.m
//  BlakeLoader
//
//  Created by steve hooley on 19/05/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "TemporaryRealViewStuff.h"
#import "SKTGraphicViewController.h"
#import "SKTUserAdaptor.h"
#import "SKTWindowController.h"
#import "SKTToolPaletteController.h"
#import "SKTGraphicViewModel.h"


@implementation TemporaryRealViewStuff

@synthesize sketchViewController = _sketchViewController;
@synthesize mouseInputAdaptor = _mouseInputAdaptor;

//- (id)initWithFrame:(NSRect)frameRect {
//	if((self=[super initWithFrame:frameRect])!=nil){
//	}
//	return self;
//}

- (void)dealloc {
	
	self.sketchViewController = nil;
	self.mouseInputAdaptor = nil;
	[super dealloc];
}

- (BOOL)acceptsFirstMouse:(NSEvent *)event {

    // In general we don't want to make people click once to activate the window then again to actually do something, but we do want to help users not accidentally throw away the current selection, if there is one.
	BOOL accepts = NO;
	accepts = [[_sketchViewController.sketchViewModel sktSceneSelectionIndexes] count]>0 ? NO : YES;
	return accepts;
}

// An override of the NSResponder method. NSResponder's implementation would just forward the message to the next responder (an NSClipView, in Sketch's case) and our overrides like -delete: would never be invoked.
- (void)keyDown:(NSEvent *)event {
    
	unsigned int modFlags = [event modifierFlags];
	int CMD_DOWN = (modFlags & NSCommandKeyMask) >> 20;
	unsigned short theKeyCode = [event keyCode];
	if( CMD_DOWN && theKeyCode==5 ) {
		// GROUP
		[_sketchViewController groupSelection];
		
	} else if( CMD_DOWN && theKeyCode==32 ){
		// UNGROUP
		[_sketchViewController ungroupSelection];
	}
    // Ask the key binding manager to interpret the event for us.
    [self interpretKeyEvents:[NSArray arrayWithObject:event]];
	
//	NSLog(@"KeyPressed is %i", theKeyCode);
	//NSDeleteCharFunctionKey
	
//	escape = 53
//	enter = 76
}


/* we need to work out the correct path for mouse messages */
- (void)mouseDown:(NSEvent *)event {
	
    // If a graphic has been being edited (in Sketch SKTTexts are the only ones that are "editable" in this sense) then end editing.
    // [_mouseInputAdaptor stopEditingInSketchView:self];
	
	NSPoint mouseLocation = [self convertPoint:[event locationInWindow] fromView:nil];	
	[_mouseInputAdaptor mouseDownEvent:event atPoint:mouseLocation inSketchView:self];
}

// - (void)viewWillMoveToWindow:(NSWindow *)newWindow;

// jeez these get called a lot!
//- (void)viewDidMoveToWindow {
//	[super viewDidMoveToWindow];
//	
//	// -- the view needs a mouseadaptor, see if the window has a toolbar
//	SKTWindowController *winControl = [[self window] windowController];
//	SKTTool *activeTool = winControl.sketchToolPaletteConroller.activeTool;
//	[self setMouseInputAdaptor: activeTool];
//}

//- (void)viewWillMoveToSuperview:(NSView *)newSuperview;
//- (void)viewDidMoveToSuperview {
//	[super viewDidMoveToSuperview];
//	// -- the view needs a mouseadaptor, see if the window has a toolbar
//	SKTWindowController *winControl = [[self window] windowController];
//	SKTTool *activeTool = winControl.sketchToolPaletteConroller.activeTool;
//	[self setMouseInputAdaptor: activeTool];
//}
//- (void)didAddSubview:(NSView *)subview;
//- (void)willRemoveSubview:(NSView *)subview;
//- (void)removeFromSuperview;
//- (void)replaceSubview:(NSView *)oldView with:(NSView *)newView;
//- (void)removeFromSuperviewWithoutNeedingDisplay;

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (BOOL)isFlipped {
    return YES;
}

- (BOOL)isOpaque {
    return YES;
}

//-- DO we need this -- given, say, an NSBezierPath how would you clip it to just the area rect given to drawRect?
- (BOOL)wantsDefaultClipping {
#warning get this clipping stuff right! makes drawing look fooked!
    return NO;
}

- (void)setMouseInputAdaptor:(id<SKTUserAdaptor>)inputAdaptor {
	
	if(_mouseInputAdaptor!=inputAdaptor){
		[_mouseInputAdaptor release];
		_mouseInputAdaptor = [inputAdaptor retain];
		[self setNeedsDisplayInRect:[inputAdaptor toolDisplaybounds]];
	}
}
@end
