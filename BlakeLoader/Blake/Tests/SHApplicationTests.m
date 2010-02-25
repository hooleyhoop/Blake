//
//  SHApplicationTests.m
//  BlakeLoader
//
//  Created by steve hooley on 03/01/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "SHApplication.h"


@interface SHApplicationTests : SenTestCase {
	
	SHApplication *app;
}

@end


@implementation SHApplicationTests

- (void)setUp {
	
	/* The app uses the principle class as the app class - how to set that for otest? */
//	app = (SHApplication *)[SHApplication sharedApplication];
//	SHDocumentController *dc = [SHDocumentController sharedDocumentController];
//	STAssertNotNil(app, @"where is app?");
//	STAssertTrue([app isKindOfClass:[SHApplication class]], @"SHApplication not being used");
	
	//- make sure all docs are closed.. clear away unsaved changes first..
//	NSArray *allCurrentDocs = [[[dc documents] copy] autorelease];
//	NSDocument *doc;
//	for(doc in allCurrentDocs)
//		[doc updateChangeCount:  NSChangeCleared];
//
//	[dc closeAll];
//	NSArray* allDocs = [[SHDocumentController sharedDocumentController] documents];
//	STAssertTrue([allDocs count]==0, @"closeAll docs broken? %i", [allDocs count]);
//	
	// [NSThread sleepForTimeInterval:100];
}


- (void)tearDown {
	//- make sure all docs are closed..
	NSArray* allDocs = [[SHDocumentController sharedDocumentController] documents];
	STAssertTrue([allDocs count]==0, @"closeAll docs broken? %i", [allDocs count]);
}

- (void)testUndoManager {
// - (NSUndoManager *)undoManager
	
	STAssertThrows([app undoManager], @"Always use documents undoManager");
}

- (void)testOrderFrontStandardAboutPanel {
// - (void)orderFrontStandardAboutPanel:(id)sender
	
	STFail(@"Not done yet");
}

- (void)testSetAboutPanelClass {
// - (void)setAboutPanelClass:(Class)aClass 
	STFail(@"Not done yet");

}

- (void)testAltKeyDown {
// - (BOOL)altKeyDown
	STFail(@"Not done yet");
}

- (void)testOneShotOverideAltKeyDown {
// - (void)oneShotOverideAltKeyDown 
	STFail(@"Not done yet");
}

@end
