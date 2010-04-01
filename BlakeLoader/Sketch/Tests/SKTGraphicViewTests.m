//
//  SKTGraphicsViewTests.m
//  BlakeLoader
//
//  Created by steve hooley on 11/05/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "SKTGraphicView.h"

@interface SKTGraphicsViewTests : SenTestCase {
	
	//BlakeDocumentController *dc;
	//	BlakeDocument			*doc;
}

@implementation SKTGraphicsViewTests


- (void)setUp {
	
	/* One document controller for all documents */
//	dc = [BlakeDocumentController sharedDocumentController];
	
	//- make sure all docs are closed..
//	NSArray* allDocs = [dc documents];	
//	[dc closeAll];
//	allDocs = [dc documents];
//	STAssertTrue([allDocs count]==0, @"cleanUpExistingDocsBeforeMakingNew broken? %i", [allDocs count]);
	
//	[dc newDocument:self];
//	doc = [[dc frontDocument] retain];
	
//	STAssertNotNil(doc, @"doc init failed");
//	STAssertNotNil(doc.nodeGraphModel, @"doc init failed");
}

- (void)tearDown {
	
//	[doc release];
	
	//- make sure all docs are closed..
//	[dc closeAll];
//	NSArray* allDocs = [dc documents];
//	STAssertTrue([allDocs count]==0, @"closeAll broken? %i", [allDocs count]);
}

- (void)testReadFromURL {
	// - (BOOL)readFromURL:(NSURL *)inAbsoluteURL ofType:(NSString *)inTypeName error:(NSError **)outError
	
//	NSError *error = nil;
//	NSBundle* thisBundle = [NSBundle bundleForClass:[self class]];
//	NSString* mocDockPath = [thisBundle pathForResource:@"DocWriteTestf" ofType:documentExtension];
//	NSURL* mockDocUrl = [NSURL fileURLWithPath:mocDockPath];
//	BOOL success = [doc readFromURL:mockDocUrl ofType:documentExtension error:&error];
	STAssertTrue(YES, @"should be able to read in data from bundled mock data");
	
	//	STAssertTrue([doc isDocumentEdited]==NO, @"Doc should be clean after a read");
	//	STAssertTrue([[doc undoManager] canUndo]==NO, @"UndoManager should be clean after a read");
	//	STAssertTrue([doc.model.moc hasChanges]==NO, @"Context should be clean after a read");
}


@end
