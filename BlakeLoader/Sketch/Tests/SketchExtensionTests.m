//
//  SketchExtensionTests.m
//  BlakeLoader experimental
//
//  Created by steve hooley on 17/06/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "SketchExtensionTests.h"
#import "SketchExtension.h"
#import "StubSketchDoc.h"

@interface SketchExtensionTests : SenTestCase {
	
	SketchExtension		*_sketchExtension;
	StubSketchDoc		*_stubdoc;
}

@end


@implementation SketchExtensionTests

- (void)setUp {
	
	[SketchExtension wipeSharedSketchExtension];
	_sketchExtension = [[SketchExtension alloc] init];
	
	//-- make a document
	_stubdoc = [[StubSketchDoc alloc] init];
	_stubdoc.nodeGraphModel = [[[SHNodeGraphModel alloc] init] autorelease];
	[[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.0]];
}

- (void)tearDown {
	
	[SketchExtension wipeSharedSketchExtension];
	[_sketchExtension release];
	[_stubdoc release];
	[[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.3]];
}

- (void)testMenuItemInstalled {
	
	NSMenu *mainMenu = [NSApp mainMenu];
	NSMenuItem *windowMenu = [mainMenu itemWithTitle:@"Window"];
	if(mainMenu!=nil && windowMenu!=nil)
	{
		[windowMenu setEnabled:YES];
		NSMenu *windowSubMenu = [windowMenu submenu];
		
		NSMenuItem *sketchItem = [windowSubMenu itemWithTitle:@"Sketch"];
		STAssertNotNil(sketchItem, @"should have installed a menu item");
		
		STAssertTrue([sketchItem isEnabled], @"How do we get it to be enable??? arggg");
	
	} else {
		logWarning(@"Cant test install menu item when we dont have a main-menu!");
	}
}


- (void)testSetupStuff {

	//-- make a window controller with the document
	STAssertTrue( [[[SHDocumentController sharedDocumentController] documents] count]==0, @"hm - doh %i", [[[SHDocumentController sharedDocumentController] documents] count] ); 

	SKTWindowController *winController = [_sketchExtension makeWindowControllerForDocument: _stubdoc];
	NSWindow *theSketchWin = [winController window];
	[[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.0]];

	// the document should now contain it as a window controller
	NSArray *allWinControllers = [_stubdoc windowControllers];
	STAssertTrue( [allWinControllers containsObject: winController], @"what happened to our window controller?");

//-- close the window
	[theSketchWin close];
	
//-- check that there are no hooley objects left
	allWinControllers = [_stubdoc windowControllers];
	STAssertFalse( [allWinControllers containsObject: winController], @"what happened to our window controller?");
}
				 
@end
