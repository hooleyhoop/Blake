//
//  SHFSInterpreterView.m
//  Pharm
//
//  Created by Steve Hooley on 11/06/2005.
//  Copyright 2005 HooleyHoop. All rights reserved.
//

#import "SHFSInterpreterView.h"


@implementation SHFSInterpreterView



- (void) viewDidMoveToWindow
{
	[super viewDidMoveToWindow];
}	

- (BOOL)acceptsFirstResponder
{
    return YES;
}

-(BOOL) isOpaque{return YES;}

// ===========================================================
// - drawRect:
// ===========================================================
- (void)drawRect:(NSRect)rect
{
//	[super drawRect:rect ];
	NSRect r = [self bounds];
	if( [self inLiveResize] )
	{
		//	r.size.width = r.size.width *2;
		//	r.size.height = r.size.height *2;
		//	r.origin.x = r.origin.x - r.origin.x/2;
		//	r.origin.y = r.origin.y - r.origin.y/2;
		
	    [[NSColor whiteColor] set];
		//		[NSBezierPath fillRect: r];
		NSRectFill(r);
		//     drawImage([[NSGraphicsContext currentContext] graphicsPort], 0);
		
	} else {
		//    NSAssert( theOutputControl != nil, @"displayString nil" );
		// NSLog(@"SHObjPaletteView.m: drawRect");
		//NSRect r = [self bounds];
		
	//    [[NSColor whiteColor] set];
		//		[NSBezierPath fillRect: [self bounds]];
	//	NSRectFill(r);
		// draw the path in white
		//    [[NSColor whiteColor] set];
		//    [path stroke];
		//	[theObjectBrowser setNeedsDisplay:YES];
		//	[theImageView setNeedsDisplay:YES];
		//	[theTextField setNeedsDisplay:YES];
	}
	if( [[self window] firstResponder]==self )
	{
		[[NSColor blackColor] set];
		[NSBezierPath strokeRect:r];
	}
	NSLog(@"SHInterpreterView: drawrect is ");
}

- (BOOL)preservesContentDuringLiveResize
{
	return YES;
}



@end
