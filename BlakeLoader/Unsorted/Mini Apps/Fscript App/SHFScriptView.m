//
//  SHFScriptView.m
//  Pharm
//
//  Created by Steve Hooley on 11/06/2005.
//  Copyright 2005 HooleyHoop. All rights reserved.
//

#import "SHFScriptView.h"
#import "SHFSInterpreterView.h"
#import "SHFScriptControl.h"
#import "SHFScriptModel.h"
//#import "SHCustomViewController.h"


@implementation SHFScriptView

#pragma mark -
#pragma mark init methods
//=========================================================== 
// - initWithController:
//=========================================================== 
- (id)initWithController:(SHCustomViewController<SHViewControllerProtocol>*)aController
{
    if ((self = [super init]) != nil)
    {
		_controller = aController;
		[self awakeFromNib];
	}
    return self;
}

//=========================================================== 
// dealloc
//=========================================================== 
- (void) dealloc {
	[_SHFSInterpreterView release];
	_SHFSInterpreterView = nil;
    _controller = nil;
	
    [super dealloc];
}

// ===========================================================
// - awakeFromNib:
// ===========================================================
- (void) awakeFromNib
{
	_SHFSInterpreterView = [[FSInterpreterView alloc] initWithFrame:[self frame]];
	[self addSubview: _SHFSInterpreterView];
	[_SHFSInterpreterView notifyUser:@"Welcome"];

	[[(SHFScriptControl*)_controller theSHFScriptModel] setTheFSInterpreter: [_SHFSInterpreterView interpreter]];
}


// ===========================================================
// - drawRect:
// ===========================================================
- (void)drawRect:(NSRect)rect
{
	NSLog(@"SHNodeGraphInspector_V: drawrect is ");

	[super drawRect:rect ];
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
	if([[self window] firstResponder]==self)
	{
		[[NSColor blackColor] set];
	} else {
		[[NSColor grayColor] set];
	}
	//[NSBezierPath strokeRect:r];
}



- (void) viewDidMoveToWindow
{
	[super viewDidMoveToWindow];
}	

- (BOOL)acceptsFirstResponder
{
    return YES;
}

-(BOOL) isOpaque{return YES;}
- (BOOL)preservesContentDuringLiveResize
{
	return YES;
}

@end
