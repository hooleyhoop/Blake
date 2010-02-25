//
//  SHViewPlaceholder.m
//  InterfaceTest
//
//  Created by Steve Hooley on 09/11/2004.
//  Copyright 2004 HooleyHoop. All rights reserved.
//

#import "SHViewPlaceholder.h"


@implementation SHViewPlaceholder

- (void)drawRect:(NSRect)rect
{
	// NSRect r = [self bounds];
	// [[NSColor greenColor] set];
    [[NSColor clearColor] set];
	NSRectFill(rect);
	
}


//=========================================================== 
// - viewDidMoveToWindow:
//=========================================================== 
- (void) viewDidMoveToWindow
{
	// NSLog(@"SHViewPlaceholder.m: viewDidMoveToWindow");
	[super viewDidMoveToWindow];
//	[[self window] setOpaque:NO];
//	[[self window] setAlphaValue:.999f];
	[self setNeedsDisplay: YES];
}


//=========================================================== 
// - viewDidMoveToWindow:
//=========================================================== 
// this tells the window manager that nothing behind our view is visible
-(BOOL) isOpaque {
	// NSLog(@"SHViewPlaceholder.m: isOpaque");

	 return YES;
}



@end
