
//
//  SHAppView.m
//  InterfaceTest
//
//  Created by Steve Hool on Fri Dec 26 2003.
//  Copyright (c) 2003 HooleyHoop. All rights reserved.
//
#import "SHAppView.h"
//#import "SHSwapableView.h"
#import "SHMainWindow.h"
#import "SHAppControl.h"
//#import "SHCustomViewController.h"
//#import "OutputView.h"


static SHAppView* _appView;

/*
 *
*/
@implementation SHAppView


#pragma mark -
#pragma mark class methods

+ (SHAppView*)appView {
	return _appView;
}

#pragma mark init methods

- (id)init
{
    if ((self = [super init]) != nil)
    {
		// NSLog(@"SHAppView.m: initing SHAppView");
		_theWindows		= [[NSMutableDictionary alloc]initWithCapacity:3 ];
		_SHViewports	= [[NSMutableDictionary alloc]initWithCapacity:3 ];
		_fourViewFlag	= YES;
		_appView		= self;
	}
    return self;
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

	[self setTheSHAppControl:nil];
	[self setTheMainWindow:nil];
	[_theWindows release];
	[_SHViewports release];
	
	_SHViewports = nil;
	_theWindows = nil;
    [super dealloc];
}

- (void)awakeFromNib
{
	// NSLog(@"SHAppView.m: AwakeFromNib");
	[_theWindows setObject:_theMainWindow forKey:@"mainWindow"];
	[_SHViewports setObject:_SHViewportTL forKey:@"SHViewportTL"];
	[_SHViewports setObject:_SHViewportTR forKey:@"SHViewportTR"];
	[_SHViewports setObject:_SHViewportBL forKey:@"SHViewportBL"];
	[_SHViewports setObject:_SHViewportBR forKey:@"SHViewportBR"];

//sh		NSRect newSize;
//sh		newSize.origin.x = 0;
//sh		newSize.origin.y = 0;
//sh		newSize.size.width = 20;
//sh		newSize.size.height = 20;
	
//sh		SHViewport1 = [[SHViewport alloc] initWithFrame:newSize];
//sh		SHViewport2 = [[SHViewport alloc] initWithFrame:newSize];
//sh		SHViewport3 = [[SHViewport alloc] initWithFrame:newSize];
//sh		SHViewport4 = [[SHViewport alloc] initWithFrame:newSize];

//sh		SHViewports = [[NSMutableArray alloc] initWithCapacity:4];
//sh		[SHViewports addObject:SHViewport1];
//sh		[SHViewports addObject:SHViewport2];
//sh		[SHViewports addObject:SHViewport3];
//sh		[SHViewports addObject:SHViewport4];
		
//sh		[SHViewport1 makeViewMenu];
//sh		[SHViewport2 makeViewMenu];
//sh		[SHViewport3 makeViewMenu];
//sh		[SHViewport4 makeViewMenu];

//sh		[theWindow setContentView:self];
//sh        [self setAutoresizesSubviews: NO];
}

#pragma mark action methods


- (void)setSHViewport:(NSString*)viewSpecifier withContent:(SHCustomViewController*)aViewController
{
	// NSLog(@"SHAppView.m: setSHViewport");
	if([(SHCustomViewController*)aViewController respondsToSelector:@selector(isInViewPort)])
	{
		if(![(SHCustomViewController*)aViewController isInViewPort] && ![(SHCustomViewController*)aViewController isInWindow])
		{
			if( [viewSpecifier isEqualToString: @"SHViewportTL"] )
			{
					[_SHViewportTL setTheViewController: aViewController];
			} else if( [viewSpecifier isEqualToString: @"SHViewportTR"] )
			{
					[_SHViewportTR setTheViewController: aViewController];
			} else if( [viewSpecifier isEqualToString: @"SHViewportBL"] )
			{
					[_SHViewportBL setTheViewController: aViewController];
			
			} else if( [viewSpecifier isEqualToString: @"SHViewportBR"] )
			{
					[_SHViewportBR setTheViewController: aViewController];
			} else {
				NSLog(@"SHAppView.m: ERROR! Not a valid veiwport to set content for.");
			}
		}
	}
}


/*
 * Call When window is resized, etc.
*/
- (void)layOutAtNewSize
{
//sh	NSRect windowBounds = [theMainWindow frame];
//sh	windowBounds.origin.x = 0;
//sh	windowBounds.origin.y = 0;
	//	windowBounds.size.width = windowBounds.size.width - 4;	
	//	windowBounds.size.height = windowBounds.size.height - 20;
//sh	[self setBounds: windowBounds];
//sh	[self setFrame: windowBounds];

    if( _fourViewFlag )
	{
        [self layOutQuadView];
   } else if( _singleViewFlag ) {
        [self layOutSingleView];
	}
}


/*
 * User has chosen 4 up view.
 * This is also the default
*/
- (void)setFourView
{
//sh	singleViewFlag  = NO;
//sh	fourViewFlag	= YES;
//sh	[self removeSHViewports];
//sh    [self addSubview:SHViewport1]; // superview retains the view
//sh    [self addSubview:SHViewport2];
//sh    [self addSubview:SHViewport3];
//sh    [self addSubview:SHViewport4];
//sh	[SHViewport1 release];
//sh	[SHViewport2 release];
//sh	[SHViewport3 release];
//sh	[SHViewport4 release];
//sh	[self layOutQuadView];
}


/*
 * User has chosen 1 up view.
*/
- (void)setSingleView
{
//sh	singleViewFlag  = YES;
//sh	fourViewFlag	= NO;
//sh	[self removeSHViewports];
//sh    [self addSubview: currentSHViewport]; // superview retains the view
//sh	[currentSHViewport release];
//sh	[self layOutSingleView];
}



/*
 * Each of the 4 SHViewports gets a quarter of the view
*/
- (void)layOutQuadView
{
	[_SHViewportTL layOutAtNewSize];
	[_SHViewportTR layOutAtNewSize];
	[_SHViewportBL layOutAtNewSize];
	[_SHViewportBR layOutAtNewSize];

//	NSRect windowBounds = [theMainWindow frame];
	// 'set frame' positions and sizes the view
	// '- (void)setBounds:(NSRect)boundsRect' sets the origin and stuff
//sh    NSPoint p1 = { 2, windowBounds.size.height*0.5+1 };
//sh    NSSize dstSize1 = { windowBounds.size.width*0.5-3, windowBounds.size.height*0.5-3 };
//sh    NSRect dstRect1 = { p1, dstSize1 };
//	[SHViewportTL setHasBeenResized:dstRect1];


 //sh   NSPoint p2 = { windowBounds.size.width*0.5+1, windowBounds.size.height*0.5+1 };
//sh    NSSize dstSize2 = { windowBounds.size.width*0.5-3, windowBounds.size.height*0.5-3 };
 //sh   NSRect dstRect2 = { p2, dstSize2 };   
//	[SHViewportTR setHasBeenResized:dstRect2];

//sh    NSPoint p3 = { windowBounds.size.width*0.5+1, 2 };
//sh    NSSize dstSize3 = { windowBounds.size.width*0.5-3, windowBounds.size.height*0.5-3};
//sh    NSRect dstRect3 = { p3, dstSize3 };
//sh	[SHViewportBL setHasBeenResized:dstRect3];

//sh    NSPoint p4 = { 2, 2 };
//sh    NSSize dstSize4 = { windowBounds.size.width*0.5-3, windowBounds.size.height*0.5-3 };
//sh    NSRect dstRect4 = { p4, dstSize4 };
//sh	[SHViewportBR setHasBeenResized:dstRect4];
 
//	[self setNeedsDisplay:YES];
//	[super  setNeedsDisplay:YES];
}


// CurrentView gets the whole screen
- (void)layOutSingleView
{	
//sh    NSRect windowBounds = [self frame];
//sh    NSPoint p1 = { 2, 2 };
//sh    NSSize dstSize1 = { windowBounds.size.width-4, windowBounds.size.height-4 };
//sh    NSRect dstRect1 = { p1, dstSize1 };
//sh	[currentSHViewport setHasBeenResized:dstRect1];
//	[self setNeedsDisplay:YES];
}


/*
 *
*/
//- (void)drawRect:(NSRect)rect
///{
	// NSAssert( theOutputControl != nil, @"displayString nil" );
	// NSRect bounds = [self bounds];
	// NSSize size = bounds.size;

	// float w = size.width;
	// float h = size.height;

	// NSLog(@"width = %f", w);

	//  NSRect r = [self frame];
	//[[NSColor redColor] set];
	// [NSBezierPath fillRect: r];
//}



- (void)splitViewDidResizeSubviews:(NSNotification *)aNotification
{
	[self resizeAllViews];
}


- (void)resizeAllViews
{
	[_SHViewportTL layOutAtNewSize];
	[_SHViewportTR layOutAtNewSize];
	[_SHViewportBL layOutAtNewSize];
	[_SHViewportBR layOutAtNewSize];
}


- (void)removeSHViewports
{
//sh	int i=0;
//sh	for( i=0; i<[SHViewports count]; i++ )
//sh	{
//sh		SHViewport* view = [SHViewports objectAtIndex:i];
//sh		if( [view superview] != nil )
//sh		{
//sh			[view retain]; // superView releases the view
//sh			[view removeFromSuperview];
//sh		}		
//sh	}
}



- (void)updateAllViewPorts
{
	NSEnumerator	*en;
	SHViewport		*view;
	
	en = [_SHViewports objectEnumerator];
	while ((view = [en nextObject]) != nil){
		[view reDrawContents];
	}
}

#pragma mark accessor methods

- (SHMainWindow *)theMainWindow{
    return _theMainWindow; 
}
- (void)setTheMainWindow:(SHMainWindow *)a_theMainWindow
{
    if (_theMainWindow != a_theMainWindow) {
        [a_theMainWindow retain];
        [_theMainWindow release];
        _theMainWindow = a_theMainWindow;
    }
}


- (SHAppControl *)theSHAppControl{
    return _theSHAppControl; 
}
- (void)setTheSHAppControl:(SHAppControl *)a_theSHAppControl
{
    if (_theSHAppControl != a_theSHAppControl) {
 //       [a_theSHAppControl retain];
  //      [_theSHAppControl release];
        _theSHAppControl = a_theSHAppControl;
    }
}


- (NSMutableDictionary*)SHViewports{
    return _SHViewports;
}


- (NSWindow *)theWindowNamed:(NSString*)windowName{
	return [_theWindows objectForKey:windowName];
}


@end
