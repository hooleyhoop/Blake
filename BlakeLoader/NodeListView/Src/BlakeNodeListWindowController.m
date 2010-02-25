//
//  BlakeNodeListWindowController.m
//  Pharm
//
//  Created by Steve Hooley on 16/04/2007.
//  Copyright 2007 HooleyHoop. All rights reserved.
//

#import "BlakeNodeListWindowController.h"
#import "BlakeNodeListViewController.h"
#import "SHRootNodeListTableView.h"
#import "BlakeDocument.h"
#import "BlakeGlobalCommandController.h"
#import "BlakeDocument.h"

/*
 *
*/
@implementation BlakeNodeListWindowController


@synthesize filteringArrayController;
@synthesize viewController;
@synthesize duplicateWindowReferenceForDebugging;
@synthesize duplicateDocReferenceForDebugging;

#pragma mark -
#pragma mark class methods
+ (NSString *)nibName {
	return @"NodeListWindow";
}

#pragma mark init methods

//- (id)initWithWindowNibName:(NSString *)windowNibName {
//
//	self = [super initWithWindowNibName:windowNibName];
//	if( self ) {
//	}
//    return self;	
//}
 
//- (id)initWithWindow:(NSWindow *)window {
//
//	NSLog(@"BlakeNodeListWindowController.m: initWithWindow %@", window);
//
//	if( (self = [super initWithWindow:nil])!=nil )
//    {
//		
//		// make a global command centre - insert it into the responder chain above self - Do this with each window
//		[self setGlobalCommandCentre: [[[BlakeGlobalCommandController alloc] init] autorelease]];
//		[globalCommandCentre setNextResponder:[NSApplication sharedApplication]];
//		[self setNextResponder:(NSResponder *)globalCommandCentre];
//		_isBound = NO;
//	}
//    return self;
//}


- (void)dealloc {

	// should do this in unbind really, except we want it to dealloc last so i've moved it to here - 
	// we need to be careful tho that is matched up with each call in bind
	[duplicateDocReferenceForDebugging release];
		
    [super dealloc];
}

/* called on files owner ! */
//- (void)awakeFromNib {
//}

- (void)initBindings {

	// This can easily be called twice so its best to protect
	if(!_isBound) {

		duplicateDocReferenceForDebugging = [self document];
		[duplicateDocReferenceForDebugging retain];

		NSAssert(viewController!=nil, @"eek");
		[viewController setup];
		_isBound = YES;
	}
}


- (void)unBind {

	if(_isBound) {
		NSAssert(viewController!=nil, @"eek");
		NSAssert([self document]!=nil, @"eek");
		[viewController tearDown];
			
		_isBound = NO;
	}
}

//– showWindow:  
//– isWindowLoaded  
//– window  
//– setWindow:  
#pragma mark action methods

/*
 * It seems like close isn't called for every kind of close, but setDocument is called with nil - so it may be better to clean up there...
*/ 
//- (void)close {
//
//	// [self unBind];
//	[super close];
//}

- (void)setDocument:(NSDocument *)document {

	if (!document) {
		[self unBind];
    }
	[super setDocument:document];
}

- (void)windowDidLoad {
	
	// make a global command centre - insert it into the responder chain above self - Do this with each window
	
	/* discuss…
	 
	 the http://katidev.com/blog stuff which is pribably better sets the window.nextResponder=viewController, viewController.nextResponder = 
// to do with whether the viewController validates menu items.. ie the view would have to be firstresponder
// in order for the menu item to be validated. Is this what we want?
	 
	 * If you set the target of an action to 'firstResponder' (ie. nil) NSApplication's -targetForAction:to:from:
	 * will go up the responder chain as far as windowController - where the responder chain ends, then on to document, etc. and further
	 */
//MaybePutBaCKIFSENDACTIONDOESNTWORKOUT	[self setNextResponder:[BlakeGlobalCommandController sharedGlobalCommandController]];
	
	[self initBindings];
}

//TODO: -- get window menu upto date
//- (void) orderOutMyWindow: (id) sender {
//	NSString* title = self.window.title;
//	[self.window orderOut: sender];
//	[NSApp addWindowsItem:self.window title:title filename: NO];
//}
//
//- (BOOL) windowShouldClose: (id) sender {
//	[self performSelector: @selector (orderOutMyWindow:) withObject: sender afterDelay: 0.0];
//	return NO;
//}


// If we return nil here the window creates a new undo manager and returns that
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)sender {
	
	NSUndoManager *docUndoManager = [[self document] undoManager];
	return docUndoManager;
}

#warning! we need to do the interpret keyevents things
- (void)keyDown:(NSEvent *)theEvent {

	BOOL wasHandled=NO;
	unsigned int modFlags = [theEvent modifierFlags];
 //   int SHIFT_DOWN = (modFlags & NSShiftKeyMask) >> 17;
//	int ALT_DOWN = (modFlags & NSAlternateKeyMask) >> 19;
	int CMD_DOWN = (modFlags & NSCommandKeyMask) >> 20;
	
    unsigned short theKeyCode = [theEvent keyCode];
//	NSString* keypress = [theEvent charactersIgnoringModifiers];
//	NSLog(@"BlakeNodeListWindowController.m: keypress %@, theKeyCode is %i", keypress, theKeyCode);
		
	/* backspace */
	if( theKeyCode==51 || theKeyCode==117) {
		wasHandled = [self backSpacePressed];		
	} else if(CMD_DOWN && (theKeyCode==125 || theKeyCode==126)){
	/* up & down */
//		switch(theKeyCode){
//		case 125:
//			// down
//			[_controller moveDownToChild:self];
//			break;
//		case 126:
//			// up
//			[_controller moveUpToParent:self];
//			break;
//		}
	} else {
//		NSCharacterSet* cs = [[NSCharacterSet nodeNameCharacterSet] invertedSet];
//		NSRange sr = [[theEvent characters] rangeOfCharacterFromSet:cs];
//		if(sr.location==NSNotFound)
//		{
//			[self interpretKeyEvents: [NSArray arrayWithObject:theEvent]];
//		}
	}

	/* Really we should let these go up the responder chain to our SHApplication which is at the top */
	/* All responder objects have a next responder, for a view it's default is the superview, then window, then application */
	
	/* You can set the 'target' of things line menu-items to Nil and it will go to the first item in the responder chain that accepts that message */
	if(!wasHandled)
		[super keyDown:theEvent];
}


- (BOOL)backSpacePressed
{
//	NSString* currentFilterType = viewController.filterType;
//	NSArray *selectedChildren = 
//	[duplicateDocReferenceForDebugging deleteChildren:selectedChildren fromNode:node];
	logWarning(@"Backspace pressed in BlakeNodeListWindowController");
	return NO;
}


//– setDocument:  
//– document  
//– setDocumentEdited:  

//– close  
//– shouldCloseDocument  
//– setShouldCloseDocument:  

//– owner  
//– windowNibName  
//– windowNibPath  

//– setShouldCascadeWindows:  
//– shouldCascadeWindows  
//– setWindowFrameAutosaveName:  
//– windowFrameAutosaveName  
//– synchronizeWindowTitleWithDocumentName  

#pragma mark accessor methods
- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
	return displayName;
}

//- (void)windowDidBecomeKey:(NSNotification *)notification {
//}



@end
