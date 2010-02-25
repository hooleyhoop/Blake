//
//  SHClipView.m
//  Pharm
//
//  Created by Steve Hooley on 07/08/2005.
//  Copyright 2005 HooleyHoop. All rights reserved.
//

#import "SHClipView.h"


@implementation SHClipView

static NSColor* lightColor;

#pragma mark -
#pragma mark class Methods

+ (void)initialize {
    
    static BOOL isInitialized = NO;
    if(!isInitialized)
    {
        isInitialized = YES;
        lightColor = [[NSColor colorWithCalibratedRed:(240/255.0f) green:(240/255.0f) blue:(240/255.0f) alpha:1.0f] retain];
        //	darkColor = [[NSColor colorWithCalibratedRed:(230/255.0f) green:(230/255.0f) blue:(230/255.0f) alpha:1.0f] retain];
    } else {
        [NSException raise:NSInvalidArgumentException format:@"Cleaning up instance counter when we have some objects left over"];
    }
}

#pragma mark action Methods
// ===========================================================
// - drawRect:
// ===========================================================
- (void) drawRect:(NSRect)rect
{
//	NSRect r = [self frame];
//	r.origin.x += -10;
//	r.origin.y += -10;
//	r.size.width += 20;
//	r.size.height += 20;
//	[[NSColor whiteColor] set];
	
//	[super drawRect:r];
//	[[self superview] setNeedsDisplay:YES];


//	NSRect myBounds = [self bounds];
//	NSDrawLightBezel(myBounds,myBounds);
	
//	NSBezierPath *clipRect = [NSBezierPath bezierPathWithRect:r];
//	[clipRect addClip];
	
//	NSArray* subviews = [self subviews];
//	int i, count= [subviews count];
//	for(i=0;i<count;i++){
//		[[subviews objectAtIndex:i] setNeedsDisplay:YES];
//	}
//	NSLog(@"drawing clipview %@", self );
//	[super drawRect:rect];
	//	r.origin.x = r.origin.x - 50;
	//	r.origin.y = r.origin.y - 50;
	//	r.size.width = r.size.width + 50;
	//	r.size.height = r.size.height + 50;
	[lightColor set];
//	[[NSColor clearColor] set];
	NSRectFill(rect);
//sh	if([[self window] firstResponder]==self)
//sh	{
//sh		[[NSColor blackColor] set];
//sh	} else {
//sh		[[NSColor grayColor] set];
//sh	}
//sh	NSFrameRect(rect);
	
	// [[NSColor windowBackgroundColor] set];
// lightGrayColor
}

- (BOOL)isFlipped{return YES;}

/* we are invisible */
-(BOOL) isOpaque {
	return YES;
}

//sh- (BOOL)acceptsFirstResponder
//sh{
//sh    return NO;
//sh}

//sh- (BOOL)becomeFirstResponder
//sh{
	//NSLog(@"SHObjPaletteView.m: SHObjPaletteView is about to become the first responder");
//sh	[[self window] setAcceptsMouseMovedEvents: YES]; 
//sh	return YES;
//sh}


//sh- (BOOL)resignFirstResponder
//sh{
	//Notifies the receiver that it's not the first responder.
	// 	NSLog(@"BOO HOO!! SwapableView is about to not be the first responder!");
//sh  [[self window] setAcceptsMouseMovedEvents: NO]; 
//sh	return YES;
//sh}


@end

