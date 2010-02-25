//
//  SHObjPaletteView.m
//  InterfaceTest
//
//  Created by Steve Hool on Mon Dec 29 2003.
//  Copyright (c) 2003 HooleyHoop. All rights reserved.
//
#import "SHObjPaletteView.h"
#import "SHObjPaletteControl.h"
//#import "C3DTBox.h"
//#import "C3DTColor.h"
//#import "C3DTStringTexture.h"
//#import "C3DTEntity.h"
//#import "C3DTScene.h"
#import "FSNodeInfo.h"
#import "FSBrowserCell.h"
//#import "SHScrollView.h"
//#import "SHClipView.h"
#import "SHInfoTextView.h"

#define MAX_VISIBLE_COLUMNS 4

// static NSColor* backColour;
static NSColor* lightColor;


@implementation SHObjPaletteView

#pragma mark -
#pragma mark class methods
//=========================================================== 
// + initialize:
//=========================================================== 
+ (void)initialize 
{ 
	lightColor = [[NSColor colorWithCalibratedRed:(240/255.0f) green:(240/255.0f) blue:(240/255.0f) alpha:1.0f] retain];
}

#pragma mark init methods
//=========================================================== 
// - initWithController:
//=========================================================== 
- (id)initWithController:(SHCustomViewController<SHViewControllerProtocol>*)aController
{
    if ((self = [super initWithFrame:NSMakeRect(0,0,100,100)]) != nil)
    {
		// init code
		_controller = aController;
		[self setAutoresizesSubviews:YES];
		
		_theOuterMostView = [[SHScrollView alloc] initWithFrame: [self frame]];
		[_theOuterMostView setNeedsDisplay:YES];
		_theContainingView = [[SHClipView alloc] initWithFrame: [self frame]];
		[_theOuterMostView setDocumentView:_theContainingView];
		[_theOuterMostView setHasHorizontalScroller:YES];
		[_theOuterMostView setAutoresizesSubviews:YES];

		theObjectBrowser = [[NSBrowser alloc] initWithFrame:NSMakeRect(8,8,502,292)];
		[_theContainingView addSubview:theObjectBrowser];
		
		theTextFieldScrollView	= [[NSScrollView alloc] initWithFrame:NSMakeRect(516,8,200,292)];
		[_theContainingView addSubview:theTextFieldScrollView];
		
		theTextField = [[SHInfoTextView alloc] initWithFrame:NSMakeRect(0,0,200,292)];
		
		[_theContainingView setAutoresizingMask:NSViewNotSizable];
		
		[theTextFieldScrollView setDocumentView: theTextField];
		[self addSubview:_theOuterMostView];
		[self awakeFromNib];
	
	}
    return self;
}

// ===========================================================
//  - dealloc:
// ===========================================================
- (void)dealloc
{
//	[backColour release];
	[theObjectBrowser release];
	[_theOuterMostView release];
	[_theContainingView release];
	[theTextField release];
	[theTextFieldScrollView release];

	_theContainingView = nil;
	_theOuterMostView = nil;
//	backColour = nil;
	theTextField = nil;
	theObjectBrowser = nil;
	theTextFieldScrollView = nil;
	[super dealloc];
}

// ===========================================================
// - awakeFromNib:
// ===========================================================
- (void) awakeFromNib
{
	// NSLog(@"SHObjPaletteView.m: awakeFromNib");
	[theObjectBrowser setReusesColumns:YES];

	//	[theObjectBrowser setColumnResizingType:NSBrowserUserColumnResizing];
	[theObjectBrowser setColumnResizingType:NSBrowserAutoColumnResizing];
	// NSBrowserAutoColumnResizing
	// NSBrowserUserColumnResizing
	[theObjectBrowser setTitled:NO];
	[theObjectBrowser setFocusRingType: NSFocusRingTypeNone];
	[theObjectBrowser setEnabled:YES];
	[theObjectBrowser setDelegate:(id)[self controller]]; // set in nib
	[theObjectBrowser setAcceptsArrowKeys:YES];

	// Make the browser user our custom browser cell.
	[theObjectBrowser setCellClass: [FSBrowserCell class]];

	// Tell the browser to send us messages when it is clicked.
	[theObjectBrowser setTarget: [self controller]];
	[theObjectBrowser setAction: @selector(browserSingleClick:)];
	[theObjectBrowser setDoubleAction: @selector(browserDoubleClick:)];

	// Configure the number of visible columns (default max visible columns is 1).
	[theObjectBrowser setMaxVisibleColumns: MAX_VISIBLE_COLUMNS];
	[theObjectBrowser setMinColumnWidth: NSWidth([theObjectBrowser bounds])/(float)MAX_VISIBLE_COLUMNS];

	// Prime the browser with an initial load of data.
	[self reloadData: nil];

	// initialBrowserHeight	= [theObjectBrowser frame].size.height;
	initialBrowserHeight	= 292;

	initialTextFieldHeight	= [theTextFieldScrollView frame].size.height;

	//	[theTextField setRichText:YES];
	[theTextField setTextContainerInset: NSMakeSize(7,10) ]; // set the margins

	// Create a paragraph style. 
	NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init]; 
	[paragraph setMinimumLineHeight:14.0]; 
	[paragraph setMaximumLineHeight:14.0]; 
	[paragraph setLineSpacing:6]; 

	// here! need to set these attrtibnutes when we set the content i imagine!!!!!
	NSMutableDictionary *attrs = [[NSMutableDictionary dictionaryWithCapacity:3] retain];
	// NSUnderlineStyleAttributeName 
	[attrs setObject:[NSNumber numberWithInt:0] forKey: NSUnderlineStyleAttributeName]; 
	// NSForegroundColorAttributeName 
	[attrs setObject:[NSColor blackColor] forKey:NSForegroundColorAttributeName]; 
	// NSFontAttributeName 
	[attrs setObject: [NSFont systemFontOfSize:[NSFont systemFontSize]-2] forKey:NSFontAttributeName]; 
	// NSKernAttributeName 
	// [attrs setObject:0.0 forKey:NSKernAttributeName]; 
	// NSParagraphStyleAttributeName 
	[attrs setObject:paragraph forKey:NSParagraphStyleAttributeName];

	[[theTextField textStorage] setAttributes: attrs range:NSMakeRange(0, [[theTextField textStorage] length])];

	//	[theTextField setSelectable:NO];
	//	hasBeenResizedFlag = YES;
	[self layOutAtNewSize];
	[super awakeFromNib];
}


// ===========================================================
// - altDragActionX: Y:
// ===========================================================
- (void)altMouseDragActionX:(float)xarg Y:(float)yarg
{
	NSRect bb = [_theOuterMostView documentVisibleRect];

	NSPoint scrollPoint = bb.origin;
	scrollPoint.x = scrollPoint.x-xarg;
//	scrollPoint = [_theContainingView constrainScrollPoint:scrollPoint];
//	NSLog(@"%f", scrollPoint.x);
	
//	NSLog(@"SHObjPaletteView.m: drag and alt %f", bb.origin.x);
//	NSRect boundsSize	= [self bounds];
//	NSRect frameSize	= [self frameSize];
	
//	NSRect browserSize	= [theObjectBrowser frame];
//	NSRect textFrameSize = [theTextFieldScrollView frame];

	float totalContentWidth = [_theContainingView frame].size.width;
	float frameWidth = [_theOuterMostView frame].size.width;
	
		
	//	int totalContentHeight = browserSize.size.height-4;
	float maxScrollPoint = totalContentWidth-frameWidth;

//	float newx = boundsSize.origin.x - xarg;
//	float newy = boundsSize.origin.y - yarg;

//	float farXPoint = totalContentWidth-boundsSize.size.width;
//	float farYPoint = totalContentHeight-boundsSize.size.height;
	
//	if(newx>-4 && newx<(farXPoint-8))
//		boundsSize.origin.x = newx;
//	if(newy>-1 && newy<farYPoint)
//		boundsSize.origin.y = newy;

	if(scrollPoint.x>0.0f && scrollPoint.x<maxScrollPoint)
	{
		[_theContainingView scrollToPoint:scrollPoint];	
		//	[_theContainingView scrollPoint:scrollPoint];	
		//	[_theOuterMostView reflectScrolledClipView:_theContainingView];
		//	scrollRectToVisible

		// NSLog(@"KNOB PROPORTION = %f", (frameWidth/totalContentWidth) );
		// manually update the scrollbar? Why do i have to do this shit!!!
		NSScroller* HScrollbar = [_theOuterMostView horizontalScroller];
		[HScrollbar setFloatValue:(scrollPoint.x/maxScrollPoint) knobProportion:(frameWidth/totalContentWidth) ];

		[super setNeedsDisplay:YES];
		//	[_theOuterMostView setNeedsDisplay:YES];
		//		[_theContainingView setNeedsDisplay:YES];
		//	[self timedRedraw];
	}
	
    // NSLog(@"SHObjPaletteView.m: new x pos is %f", boundsSize.origin.y  );
}



-(BOOL) isOpaque{return YES;}

// ===========================================================
// - reloadData:
// ===========================================================
- (IBAction)reloadData:(id)sender {
    [[self theObjectBrowser] loadColumnZero];
}


// ===========================================================
// - drawRect:
// ===========================================================
- (void)drawRect:(NSRect)rect
{
	[lightColor set];
	NSRectFill(rect);
//[super drawRect:rect ];
//	NSRect r = [self bounds];
//	if( [self inLiveResize] )
//	{
	//	r.size.width = r.size.width *2;
	//	r.size.height = r.size.height *2;
	//	r.origin.x = r.origin.x - r.origin.x/2;
	//	r.origin.y = r.origin.y - r.origin.y/2;
		
//	[[NSColor windowBackgroundColor] set];

 //     drawImage([[NSGraphicsContext currentContext] graphicsPort], 0);

//	} else {
		//    NSAssert( theOutputControl != nil, @"displayString nil" );
		// NSLog(@"SHObjPaletteView.m: drawRect");
		//NSRect r = [self bounds];

	//	[[NSColor windowBackgroundColor] set];
	//	[[NSColor redColor] set];

	//	NSRectFill(r);
		// draw the path in white
		//    [[NSColor whiteColor] set];
		//    [path stroke];
		//	[theObjectBrowser setNeedsDisplay:YES];
		//	[theImageView setNeedsDisplay:YES];
		//	[theTextField setNeedsDisplay:YES];
//	}
	if([[self window] firstResponder]==self)
	{
		[[NSColor blackColor] set];
	} else {
		[[NSColor grayColor] set];
	}
	NSFrameRect(rect);
	//NSLog(@"SHObjectPalletteView firstresponder is %@", [[self window] firstResponder]);
}


// ===========================================================
// - layOutAtNewSize:
// ===========================================================
- (void) layOutAtNewSize
{
	// NSLog(@"SHObjPaletteView.m: layout at new size");
	[super layOutAtNewSize];
//	NSRect bb = [_theOuterMostView documentVisibleRect];
//	NSPoint scrollPoint = bb.origin;

	NSRect frameSize = [[self superview] frame];
	[self setFrame:frameSize];

	frameSize.origin.x = frameSize.origin.x+1;
	frameSize.origin.y = frameSize.origin.y+1;
	frameSize.size.width = frameSize.size.width-2;
	frameSize.size.height = frameSize.size.height-2;
	[_theOuterMostView setFrame:frameSize];

	NSRect browserSize = [theObjectBrowser frame];
	browserSize.size.height = frameSize.size.height - 30;
	[theObjectBrowser setFrame: browserSize ];

	NSRect textFrameSize = [theTextFieldScrollView frame];
//	textFrameSize.origin.x = textFrameSize.origin.x +8;
	textFrameSize.size.height = frameSize.size.height -30;
//	textFrameSize.size.width = frameSize.size.width -30;

	[theTextFieldScrollView setFrame: textFrameSize ];
	
	int totalContentWidth = browserSize.size.width + textFrameSize.size.width +0;
//	int gapOnRight = frameSize.size.width - totalContentWidth + frameSize.origin.x;
	 
	[_theContainingView setFrame:NSMakeRect(8,8,totalContentWidth+23, frameSize.size.height-16)];

	// if the view is wider than our browser than the amount of our content that
	// is displayed on the screen (ie. there is a gap), we shift the content right.
	//if( gapOnRight > 0 )
	//{	
	//	frameSize.origin.x = frameSize.origin.x - gapOnRight;
		// if all the content is already on the screen then we centre it
	//	if(frameSize.size.width>totalContentWidth){
	//		frameSize.origin.x = frameSize.origin.x/2;
	//	}
	//	[self setFrame: frameSize;
	//} else {
	//	int gapOnLeft = boundsSize.origin.x;
	//	if( gapOnRight < 0 )
	//	{
	//		frameSize.origin.x = frameSize.origin.x - gapOnLeft;
	//		[self setFrame: frameSize];
	//	}
	//}
	
	// [super setNeedsDisplay:YES];
//   NSPoint basePoint = NSZeroPoint;
//   basePoint.y = 50;
//	NSAssert( theOutputControl != nil, @"displayString nil" );
	
	// set the scroll to the proper position
	[_theContainingView scrollToPoint:NSZeroPoint];	
	[_theOuterMostView reflectScrolledClipView:_theContainingView];

	[self timedRedraw];
	[_theOuterMostView setNeedsDisplay:YES];
	[_theContainingView setNeedsDisplay:YES];
}

	
// ===========================================================
// - setHasBeenResized: OLD
// ===========================================================
//- (void) setHasBeenResized: (NSRect) newSize
//{
//	hasBeenResizedFlag = YES;
//	[super setNeedsDisplay:YES];
//}


// ===========================================================
// - reloadColumn:
// ===========================================================
- (void)reloadColumn:(int)col
{
	[theObjectBrowser reloadColumn:col];
}



- (void) viewDidMoveToWindow
{
	// NSLog(@"SHObjPaletteView.m: viewDidMoveToWindow");
	[super viewDidMoveToWindow];

}	

- (BOOL)acceptsFirstResponder { return YES; }

- (BOOL)becomeFirstResponder
{
	//NSLog(@"SHObjPaletteView.m: SHObjPaletteView is about to become the first responder");
	[[self window] setAcceptsMouseMovedEvents: YES]; 
	[self setNeedsDisplay:YES];
	return YES;
}

- (BOOL)resignFirstResponder
{
	//Notifies the receiver that it's not the first responder.
	// NSLog(@"BOO HOO!! SwapableView is about to not be the first responder!");
	[[self window] setAcceptsMouseMovedEvents: NO]; 
	[self setNeedsDisplay:YES];
	return YES;
}







@end


@implementation SHObjPaletteView(PrivateMethods)





// ===========================================================
// - theObjectBrowser:
// ===========================================================
- (NSBrowser *)theObjectBrowser { return theObjectBrowser; }

// ===========================================================
// - setTheObjectBrowser:
// ===========================================================
- (void)setTheObjectBrowser:(NSBrowser *)aTheObjectBrowser
{
    if (theObjectBrowser != aTheObjectBrowser) {
        [aTheObjectBrowser retain];
        [theObjectBrowser release];
        theObjectBrowser = aTheObjectBrowser;
    }
}



// ===========================================================
// - theImageView:
// ===========================================================
// - (NSImageView *)theImageView { return theImageView; }

// ===========================================================
// - setTheImageView:
// ===========================================================
// - (void)setTheImageView:(NSImageView *)aTheImageView
// {
//     if (theImageView != aTheImageView) {
//         [aTheImageView retain];
//         [theImageView release];
//         theImageView = aTheImageView;
//     }
// }

// ===========================================================
// - theTextField:
// ===========================================================
- (SHInfoTextView *)theTextField { return theTextField; }

// ===========================================================
// - setTheTextField:
// ===========================================================
- (void)setTheTextField:(SHInfoTextView *)aTheTextField
{
    if (theTextField != aTheTextField) {
        [aTheTextField retain];
        [theTextField release];
        theTextField = aTheTextField;
    }
}
// ===========================================================
// - theTextFieldScrollView:
// ===========================================================
- (NSScrollView *)theTextFieldScrollView { return theTextFieldScrollView; }

// ===========================================================
// - setTheTextFieldScrollView:
// ===========================================================
- (void)setTheTextFieldScrollView:(NSScrollView *)atheTextFieldScrollView
{
    if (theTextFieldScrollView != atheTextFieldScrollView) {
        [atheTextFieldScrollView retain];
        [theTextFieldScrollView release];
        theTextFieldScrollView = atheTextFieldScrollView;
    }
}


- (void)viewDidMoveToSuperview
{
	// NSLog(@"SHObjPaletteView.m: viewDidMoveToSuperview");
}


- (void)viewDidMoveToWindow
{
	// NSLog(@"SHObjPaletteView.m: viewDidMoveToWindow");
}

@end
