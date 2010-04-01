//
//  NSApplication_ExtensionsTests.m
//  SHShared
//
//  Created by steve hooley on 12/06/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "NSDocumentController_Extensions.h"
#import "NSApplication_Extensions.h"
#import "SHDocument.h"
#import "SHDocumentController.h"

#import <AppKit/NSWindow.h>

@interface NSApplication_ExtensionsTests : SenTestCase {
	
    NSAutoreleasePool	*_pool;
	NSApplication		*app;
}

@end


@implementation NSApplication_ExtensionsTests

- (void)setUp {
	
    _pool = [[NSAutoreleasePool alloc] init];
	app = [NSApplication sharedApplication];
	SHDocumentController *dc = [SHDocumentController sharedDocumentController];
	STAssertNotNil(app, @"where is app?");
	
	//- make sure all docs are closed.. clear away unsaved changes first..
	NSArray *allCurrentDocs = [[[dc documents] copy] autorelease];
	NSDocument *doc;
	for(doc in allCurrentDocs)
		[doc updateChangeCount: NSChangeCleared];
	
	[dc closeAll];
	NSArray* allDocs = [dc documents];
	STAssertTrue([allDocs count]==0, @"closeAll docs broken? %i", [allDocs count]);
}


- (void)tearDown {
	
	//- make sure all docs are closed..
	[[SHDocumentController sharedDocumentController] closeAll];
	NSArray* allDocs = [[SHDocumentController sharedDocumentController] documents];
	STAssertTrue([allDocs count]==0, @"closeAll docs broken? %i", [allDocs count]);
    [_pool drain];
}

- (void)testOpenDocs {
	// - (NSArray *)openDocs;
	
	//- make 3 docs
	SHDocumentController* dc = [SHDocumentController sharedDocumentController];
	STAssertNotNil(dc, @"i thought the app was running?");
	[dc newDocument:self];
	[dc newDocument:self];
	[dc newDocument:self];
    
	//- close 1 doc
	NSArray* openDocs = [app openDocs];
	NSArray* allDocs = [dc documents];
	STAssertTrue([openDocs count]==3, @"mm %i", [openDocs count]);
	STAssertTrue([openDocs count]==[allDocs count], @"mm %i, %i", [openDocs count], [allDocs count]);
    
	[dc tryToCloseDoc:[openDocs lastObject]];
	
	//-assert we have 2 opendocs
	openDocs = [app openDocs];
	allDocs = [dc documents];
	STAssertTrue([openDocs count]==2, @"mm %i", [openDocs count]);
	STAssertTrue([openDocs count]==[allDocs count], @"mm %i, %i", [openDocs count], [allDocs count]);
    
	[dc closeAll];
	openDocs = [app openDocs];
	allDocs = [dc documents];
	STAssertTrue([openDocs count]==0, @"mm %i", [openDocs count]);
	STAssertTrue([openDocs count]==[allDocs count], @"mm %i, %i", [openDocs count], [allDocs count]);
}

/* I cant get apps MainWindow stuff to work in the tests so i had to roll my own */
- (void)testMyMainWindow{
	// - (NSWindow *)myMainWindow 
	
	NSRect stubFrame = NSMakeRect(50, 50, 200, 200);
	NSWindow *stubWindow = [[NSWindow alloc] initWithContentRect:stubFrame styleMask:NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask backing:NSBackingStoreBuffered defer:NO];
	[stubWindow setOneShot:YES];
	[stubWindow makeKeyAndOrderFront:self];
	NSWindow *mainWindow = [NSApp myMainWindow];
	STAssertNotNil(mainWindow, @"we need a main window");
	STAssertEqualObjects(stubWindow, mainWindow, @"stubWindow needs to be the main window for the tests to work");
	[stubWindow close];
}

- (void)testAltKeyDown {
	// - (BOOL)altKeyDown
	STAssertFalse([NSApp altKeyDown], @"bugger");
	
	[NSApp oneShotOverideAltKeyDown];
	STAssertTrue([NSApp altKeyDown], @"bugger");
	STAssertFalse([NSApp altKeyDown], @"bugger");
}

//- (void)testSetAboutPanelClass {
//	//- (void)setAboutPanelClass:(Class)aClass
//	STAssertThrows([NSApp setAboutPanelClass:[self class]], @"should be abstract");
//}

@end
