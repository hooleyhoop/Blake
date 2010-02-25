//
//  SketchExtension.m
//  BlakeLoader experimental
//
//  Created by steve hooley on 17/06/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "SketchExtension.h"
#import "SKTWindowController.h"
#import "SHAppControl.h"
#import "SKTCircle.h"


static SketchExtension *_sharedSketchExtension;

@implementation SketchExtension

#pragma mark -
#pragma mark Properties
@synthesize sketchWindowController = _sketchWindowController;

#pragma mark -
#pragma mark class methods
+ (void)wipeSharedSketchExtension {
	
	_sharedSketchExtension = nil;
	logInfo( @"_sharedSketchExtension is %@", _sharedSketchExtension);
}

#pragma mark init methods
- (id)init {
	
	if( _sharedSketchExtension==nil )
	{
		if ((self=[super init])!=nil) {
			_sharedSketchExtension = self;
            
			/* If we are running in a windowed environment, install a menu item into the main menu.. Assumes one window for the app… */
			[self installWindowMenuItem];
			
		}
	} else {
		logInfo(@"Using shared sketchextension");
	}
	return _sharedSketchExtension;
}

- (void)dealloc {

    logInfo(@"_sketchWindowController retainCount is %i", [_sketchWindowController retainCount]);
	
	[_sketchWindowController release];
	_sharedSketchExtension = nil;
    [super dealloc];
}

#pragma mark action methods
- (SKTWindowController *)makeWindowControllerForDocument:(NSDocument *)doc {
	
	//-- make a sketch window controller
    NSParameterAssert(doc!=nil);
	[self debug_setUpSketchModel:doc];

    NSAssert(_sketchWindowController==nil, @"one shot deal fella!");
	_sketchWindowController = [[SKTWindowController alloc] init];
    
    /* calls setDocument */
	[doc addWindowController: _sketchWindowController];
	
	/* This is called automatically when you add the windowcontroller to the documents windowcontrollers
	[_sketchWindowController setDocument: doc];
	*/
	
	[_sketchWindowController setShouldCloseDocument:YES];	

	// Do the same thing that a typical override of -[NSDocument makeWindowControllers] would do, but then also show the window. 
	// This is here instead of in SKTDocument, though it would work there too, with one small alteration, because it's really view-layer code.
	[_sketchWindowController showWindow:self];
	
	return _sketchWindowController;
}


- (void)installWindowMenuItem {
	
	//-- Install the sketch menu item
	NSMenu *mainMenu = [NSApp mainMenu];
	NSMenuItem *windowMenu = [mainMenu itemWithTitle:@"Window"];
	
	if(mainMenu && windowMenu)
	{
		[windowMenu setEnabled:YES];
		NSMenu *windowSubMenu = [windowMenu submenu];
		
		//-- seperate the palettes from the docs
		[windowSubMenu insertItem:[NSMenuItem separatorItem] atIndex:0];
		
		// -- the selector must be valid to make the menuitem enabled
		NSMenuItem *newMenuItem = [[NSMenuItem alloc] initWithTitle:@"Sketch" action:NSSelectorFromString(@"fuckMeUp:") keyEquivalent:@""];
		[windowSubMenu insertItem:[newMenuItem autorelease] atIndex:0];
		[newMenuItem setEnabled:YES];
		[newMenuItem setTarget:self];
	
		// [newMenuItem setRepresentedObject:_sketchWindowController];
	} else {
		logWarning(@"No menu present to install are menu item into!");
	}
}

- (void)showWindow {
	
	[_sketchWindowController showWindow:self];
}



/* Hmm, a hack for tests.. Sketch needs to be a plugin of Blake to make sure Blake loads first.. how would we test Sketch on its own? */
- (id)debug_getDefaultDocument {
	
	id doc = nil;
	doc = [[SHDocumentController sharedDocumentController] frontDocument];
	
	if(doc==nil){
		NSError *err;
		doc = [[SHDocumentController sharedDocumentController] openUntitledDocumentAndDisplay:YES error:&err];
		
	//	Class docClass2 = NSClassFromString(@"SHAppControl");
	//	SEL selectorToPerform = NSSelectorFromString(@"appControl");
	//	if(docClass2!=nil && [docClass2 respondsToSelector:selectorToPerform]){
	//		doc = [docClass2 performSelector:selectorToPerform];
	//	}
	}
	NSAssert( doc!=nil, @"we need a doc of somekind to continue");
	NSAssert( [doc respondsToSelector:@selector(isDocumentEdited)], @"Looks like we haven't got a valid doc or stand-in doc" );
	return doc;
}

/*	Hmm, this is only for unit tests - Extension doesnt need to know about docs or models
 Saying that, the document / model for our GraphicsProvidor has to be set or located somewhere - where?
 */
- (void)debug_setUpSketchModel:(BlakeDocument *)doc  {
	
	BlakeDocument *sktm = [doc nodeGraphModel];
	NSAssert( sktm!=nil, @"help");
	
	// Create the new graphic and set what little we know of its location.
	SKTCircle *creatingGraphic1 = [[[SKTCircle alloc] init] autorelease];
	[creatingGraphic1 setBounds:NSMakeRect(0.f, 100.f, 99.f, 99.f)];
	
	SKTCircle *creatingGraphic2 = [[[SKTCircle alloc] init] autorelease];
	[creatingGraphic2 setBounds:NSMakeRect(50.f, 50.f, 99.f, 99.f)];
	
	SKTCircle *creatingGraphic3 = [[[SKTCircle alloc] init] autorelease];
	[creatingGraphic3 setBounds:NSMakeRect(100.f, 0.f, 99.f, 99.f)];
	
	// Add it to the set of graphics right away so that it will show up in other views of the same array of graphics as the user sizes it.
	[sktm insertGraphic:creatingGraphic1 atIndex:0];
	[sktm insertGraphic:creatingGraphic2 atIndex:1];
	[sktm insertGraphic:creatingGraphic3 atIndex:2];
}

@end
