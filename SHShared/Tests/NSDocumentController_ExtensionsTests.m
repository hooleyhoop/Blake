//
//  NSDocumentController_ExtensionsTests.m
//  SHShared
//
//  Created by steve hooley on 12/06/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "NSDocumentController_Extensions.h"
#import "NSApplication_Extensions.h"
#import "SHDocument.h"
#import "SHDocumentController.h"
#import "SHInstanceCounter.h"

@interface NSDocumentController_ExtensionsTests : SenTestCase {
	
    NSAutoreleasePool *_pool;
	SHDocumentController *_appDocController;
}

@end

@implementation NSDocumentController_ExtensionsTests

- (void)setUp {
	
    _pool = [[NSAutoreleasePool alloc] init];
	_appDocController = [[SHDocumentController sharedDocumentController] retain];
	
	//- make sure all docs are closed..
	[_appDocController closeAll];
	NSArray* allDocs = [_appDocController documents];
	STAssertTrue([allDocs count]==0, @"mm %i", [allDocs count]);
}

- (void)tearDown {
	
	//- make sure all docs are closed..
	[_appDocController closeAll];
	NSArray* allDocs = [_appDocController documents];
	STAssertTrue([allDocs count]==0, @"mm %i", [allDocs count]);

	[_appDocController release];
    [_pool release];
    [SHInstanceCounter cleanUpInstanceCounter];
}

- (void)testCloseAll {
	// - (void)closeAll;
	
	//- make 3 docs
	[_appDocController newDocument:self];
	[_appDocController newDocument:self];
	[_appDocController newDocument:self];
    
	//- close 1 doc
	NSArray* allDocs = [_appDocController documents];
	STAssertTrue([allDocs count]==3, @"i thought the app was running? %i", [allDocs count]);
	[_appDocController tryToCloseDoc:[allDocs lastObject]];
    
	//-assert we have 2 opendocs
	allDocs = [_appDocController documents];
 	STAssertTrue([allDocs count]==2, @"i thought the app was running? %i", [allDocs count]);
	
	[_appDocController closeAll];
	allDocs = [_appDocController documents];
	STAssertTrue([allDocs count]==0, @"i thought the app was running?");
}

- (void)testTryToCloseDoc {
	// - (void)tryToCloseDoc:(NSDocument *)aDoc
	NSError *error = nil;
    
	id newDocument1 = [_appDocController openUntitledDocumentAndDisplay:YES error:&error];
	STAssertNotNil(newDocument1, @"openUntitledDocumentAndDisplay failed");
	
	[_appDocController tryToCloseDoc:newDocument1];
	NSArray *allDocs = [[NSApplication sharedApplication] openDocs];
	STAssertTrue([allDocs count]==0, @"We should have closed all open docs");	
}

- (void)testFrontDocument {
    // - (SHDocument *)frontDocument;
    
	NSError *err;

	// Must make some documents with windows here..	
	id what = [_appDocController openUntitledDocumentAndDisplay:YES error:&err];
	NSDocument* newDoc1 = [_appDocController frontDocument];
	
	[_appDocController newDocument:self];
	NSDocument* newDoc2 = [_appDocController frontDocument];
	[newDoc1 showWindows];

	[_appDocController newDocument:self];
	NSDocument* newDoc3 = [_appDocController frontDocument];
	
	STAssertFalse(newDoc1==newDoc2, @"front doc failed?");
	STAssertFalse(newDoc2==newDoc3, @"front doc failed?");
	STAssertFalse(newDoc1==newDoc3, @"front doc failed?");
}

@end
