/*
	SKTWindowController.m
	Part of the Sketch Sample Code
*/
#import "SKTWindowController.h"

#import "SKTGraphicView.h"
#import "SKTToolPaletteController.h"
#import "SKTZoomingScrollView.h"
#import "SketchPanel.h"
#import "BlakeDocument.h"
#import "SKTGraphicViewController.h"

@implementation SKTWindowController

@synthesize sketchToolPaletteConroller = _sketchToolPaletteConroller;
@synthesize graphicView = _graphicView;
@synthesize zoomingScrollView = _zoomingScrollView;
@synthesize viewController = _viewController;

- (id)init {
	
	if( (self = [super initWithWindowNibName:@"DrawWindow"])!=nil ) {
		
		_sketchToolPaletteConroller = [[SKTToolPaletteController alloc] initWithWindowController:self];
		[self setShouldCloseDocument:YES];
		_zoomFactor = 1.0f;
		
		SHToolbar *newToolBar = [[[SHToolbar alloc] initWithIdentifier:@"sketchDraw"] autorelease];
		[_sketchToolPaletteConroller setToolBar: newToolBar];

		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedToolDidChange:) name:@"SKTSelectedToolDidChange" object:_sketchToolPaletteConroller];

		[[self window] setToolbar: newToolBar];
	}
	return self;
}

- (void)dealloc {

	// Stop observing the tool palette.
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"SKTSelectedToolDidChange" object:_sketchToolPaletteConroller];
	
    // Stop observing the document's canvas size.

	if([self window]!=nil)
		[[self window] close];
    
//    NSWindow *win = [self window];
    // [self setWindow:nil];
	[_sketchToolPaletteConroller release];
    [super dealloc];
}


/* called on files owner ! */
- (void)awakeFromNib {
	
#warning - won't work in tests!
	// -- the view needs a mouseadaptor 
	NSAssert(_graphicView!=nil, @"not ready");
	[_graphicView setMouseInputAdaptor: _sketchToolPaletteConroller.activeTool];

}

#pragma mark *** Observing ***

/* This will not receive the initial tool setting */
- (void)selectedToolDidChange:(NSNotification *)notification {

	// -- the view needs a mouseadaptor 
	NSAssert(_graphicView!=nil, @"not ready");
	[_graphicView setMouseInputAdaptor: _sketchToolPaletteConroller.activeTool];
	
//JOOST    // Just set the correct cursor
//JOOST    Class theClass = [_sketchToolPaletteConroller currentGraphicClass];
//JOOST    NSCursor *theCursor = nil;
//JOOST    if (theClass) {
//JOOST        theCursor = [theClass creationCursor];
//JOOST    }
//JOOST    if (!theCursor) {
//JOOST        theCursor = [NSCursor arrowCursor];
//JOOST    }
//JOOST    [[_graphicView enclosingScrollView] setDocumentCursor:theCursor ];
}

/* We have to clean up EVERYTHING! */
- (void)windowWillClose:(NSNotification *)notification {
	
	logInfo(@"! Window will close !");
	
    NSWindow *win = [self window];
//    NSMutableArray *allSubViews = [NSMutableArray array];
//    [self allSubviewsOf: [win contentView] into: allSubViews];
//    [allSubViews addObject:[win contentView]];
//    for( NSView *view in allSubViews)
//	{
//		NSView *parentView = [view superview];
//        NSArray *allBindings = [view exposedBindings];
//        for(NSString *binding in allBindings)
//		{
//            NSDictionary *contentBinding = [view infoForBinding:binding];
//            id observedObject = [contentBinding objectForKey:@"NSObservedObject"];
//            if(observedObject)
//                logInfo(@"found a binding for %@", observedObject);
//        }
//		if(parentView)
//		{
//			if([parentView respondsToSelector:@selector(setDocumentView:)])
//				[parentView setDocumentView:nil];
//			else
//				[view removeFromSuperview];
//		}
//		
//        if([view respondsToSelector:@selector(setDelegate:)])
//            [view setDelegate:nil];
//        if([view respondsToSelector:@selector(setDataSource:)])
//            [view setDataSource:nil];
//    }
//    [win setToolbar:nil];

	
	/*
		This is called when the window closes.. caveat: only if window controller is properly registered with a document - ie in windowController tests it doesnt happen automatically
		_windowDidClose calls setDocument:nil
		[_viewController unSetupViewController];
	*/
	
    NSAssert(win!=nil, @"er, need a window");
	
//    [win disableFlushWindow];
//	[win setDelegate:nil];
    
    id doc = [self document];
    NSAssert(doc!=nil, @"er, need a doc");
 //   BOOL  shouldCloseDocument = [self shouldCloseDocument];
    
//    id winsController = [win windowController];

    [super cleanUpUnarchivedObjects];

    
}

- (void)allSubviewsOf:(NSView *)parentView into:(NSMutableArray *)array {

    
    NSArray *children = [parentView subviews];
    [array addObjectsFromArray:children];
    for( NSView *child in children ){
        [self allSubviewsOf: child into: array];
    }
}

/* i think this just calls close on the window */
//- (void)close {
//    id doc = [self document];
//    [super close];
//}

#pragma mark *** Overrides of NSWindowController Methods ***
/* This is called automatically when you add the windowcontroller to the documents windowcontrollers 
 *  caveat - Only if windowcontroller is registered properly with a document, otherwise this will not get called
 */

- (void)setDocument:(NSDocument *)document {
	
	
	/* Not sure where the main viewModel should get it's document from - here for now */
	[_viewController setDocument: document];

    // Cocoa Bindings makes many things easier. Unfortunately, one of the things it makes easier is creation of reference counting cycles. 
	// In Tiger NSWindowController has a feature that keeps bindings to File's Owner, when File's Owner is a window controller, 
	// from retaining the window controller in a way that would prevent its deallocation. We're setting up bindings programmatically 
	// in -windowDidLoad though, so that feature doesn't kick in, and we have to explicitly unbind to make sure this window controller 
	// and everything in the nib it owns get deallocated. We do this here instead of in an override of -[NSWindowController close] because 
	// window controllers aren't sent -close messages for every kind of window closing. Fortunately, window controllers are sent -setDocument:nil messages during window closing.
    if (!document) {
//JOOST		[_zoomingScrollView unbind:SKTZoomingScrollViewFactor];
		[_graphicView unbind:@"graphics"];
		
		[_viewController unSetupViewController];
    }
    
	[super setDocument:document];

    // Redo the observing of the document's canvas size when the document changes. 
    //You would think we would just be able to observe self's "document.canvasSize" in -windowDidLoad or maybe even -init, 
    //but KVO wasn't really designed with observing of self in mind so things get a little squirrelly.
}

- (void)windowDidLoad {

    [super windowDidLoad];

 //JOOST   NSArray *tlo = self.nibManager.topLevelObjects;
//JOOST    for(id item in tlo)
//JOOST        logInfo(@"tlo is %@", item);
    
    // Set up the graphic view and its enclosing scroll view.
//JOOST	NSScrollView *enclosingScrollView = [_graphicView enclosingScrollView];
//JOOST	[enclosingScrollView setHasHorizontalRuler:YES];
//JOOST	[enclosingScrollView setHasVerticalRuler:YES];

    // Bind the zooming scroll view's factor to this window's controller's zoom factor.
//JOOST	[_zoomingScrollView bind:SKTZoomingScrollViewFactor toObject:self withKeyPath:@"zoomFactor" options:nil];
    
    // Start observing the tool palette.
//JOOST	NSAssert( _sketchToolPaletteConroller!=nil, @"oops no toolbar controller");
//JOOST	[self selectedToolDidChange:nil];
}


#pragma mark *** Actions ***

// use validateUserInterfaceItem
- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {

    // Which menu item?
    BOOL enabled;
    SEL action = [menuItem action];
    if (action==@selector(newDocumentWindow:)) {

		// Give the menu item that creates new sibling windows for this document a reasonably descriptive title. It's important to use the document's "display name" in places like this; it takes things like file name extension hiding into account. We could do a better job with the punctuation!
		[menuItem setTitle:[NSString stringWithFormat:NSLocalizedStringFromTable(@"New window for '%@'", @"MenuItems", @"Formatter string for the new document window menu item. Argument is a the display name of the document."), [[self document] displayName]]];
		enabled = YES;


    } else {
		enabled = [super validateMenuItem:menuItem];
    }
    return enabled;

}

- (IBAction)showOrHideGraphicsInspector:(id)sender {
	
	//latetr    // We always show the same inspector panel. Its controller doesn't get deallocated when the user closes it.
	//latetr    if (!_graphicsInspectorController) {
	//latetr		_graphicsInspectorController = [[NSWindowController alloc] initWithWindowNibName:@"Inspector"];
	//latetr		
	//latetr   	// Make the panel appear in the same place when the user quits and relaunches the application.
	//latetr		[_graphicsInspectorController setWindowFrameAutosaveName:@"Inspector"];
	//latetr		
	//latetr    }
	//latetr    [_graphicsInspectorController showOrHideWindow];
}


@end