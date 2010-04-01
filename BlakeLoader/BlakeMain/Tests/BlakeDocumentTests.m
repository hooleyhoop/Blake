//
//  BlakeDocumentTests.m
//  BlakeLoader
//
//  Created by steve hooley on 03/01/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//
#import "defs.h"
#import "BlakeDocumentController.h"
#import "BlakeDocument.h"
#import "BlakeNodeListWindowController.h"
#import "HighLevelBlakeDocumentActions.h"

@interface BlakeDocumentTests : SenTestCase {
	
	BlakeDocumentController		*dc;
	BlakeDocument				*doc;
}

@end

@implementation BlakeDocumentTests

- (void)setUp {

	/* One document controller for all documents */
	dc = [BlakeDocumentController sharedDocumentController];
	NSAssert(dc, @"eh?");
	
	//- make sure all docs are closed..
	NSArray* allDocs = [dc documents];
	// NSDocument *openDoc = [allDocs lastObject];

	[dc closeAll];

	allDocs = [dc documents];
	STAssertTrue([allDocs count]==0, @"cleanUpExistingDocsBeforeMakingNew broken? %i", [allDocs count]);
	
	[dc newDocument:self];
	doc = [[dc frontDocument] retain];
	
	STAssertNotNil(doc, @"doc init failed");
	STAssertNotNil(doc.nodeGraphModel, @"doc init failed");
}

- (void)tearDown {

    [[doc undoManager] setGroupsByEvent:YES];
	[[doc undoManager] removeAllActions];
	[doc updateChangeCount: NSChangeCleared];
    STAssertTrue([[doc undoManager] canUndo]==NO, @"UndoManager should be clean after a read");

	[doc release];

	//- make sure all docs are closed..
	[dc closeAll];
	NSArray* allDocs = [dc documents];
	STAssertTrue([allDocs count]==0, @"closeAll broken? %i", [allDocs count]);
}

- (void)testReadFromURL {
    
    logInfo(@"\nExecuting testReadFromURL \n\n");
    // - (BOOL)readFromURL:(NSURL *)inAbsoluteURL ofType:(NSString *)inTypeName error:(NSError **)outError
 //   [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0]];

//dec2009	NSError *error = nil;
//dec2009	NSBundle* thisBundle = [NSBundle bundleForClass:[self class]];
//dec2009	NSString* mocDockPath = [thisBundle pathForResource:@"DocWriteTestf" ofType:documentExtension];
//dec2009	NSURL* mockDocUrl = [NSURL fileURLWithPath:mocDockPath];
//dec2009	BOOL success = [doc readFromURL:mockDocUrl ofType:documentExtension error:&error];
//dec2009	STAssertTrue(success, @"should be able to read in data from bundled mock data");
	
//dec2009	STAssertTrue([doc isDocumentEdited]==NO, @"Doc should be clean after a read");
//dec2009	STAssertTrue([[doc undoManager] canUndo]==NO, @"UndoManager should be clean after a read");
//	STAssertTrue([doc.model.moc hasChanges]==NO, @"Context should be clean after a read");
//    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0]];

}

- (void)testWriteToURL {
    
    logInfo(@"\nExecuting testWriteToURL \n\n");

	// - (BOOL)writeToURL:(NSURL *)inAbsoluteURL ofType:(NSString *)inTypeName error:(NSError **)outError
//   [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0]];

		NSError *error = nil;
		
		/* In order to test the result immediately we need to temporarily disable groupsByEvent */
		[[doc undoManager] setGroupsByEvent:NO];
		[[doc undoManager] beginUndoGrouping];
		/* clear the doc of any objects */
	//	SHNode* rootNode = [doc.nodeGraphModel rootNodeGroup];
	//	NSArray *allRootChildren = [doc.nodeGraphModel allChildrenFromNode:rootNode];
	//	[doc.nodeGraphModel deleteChildren:allRootChildren fromNode:rootNode];
		
		/* add our test nodes */
		[doc makeEmptyGroupInCurrentNodeWithName:@"testWriteToURL"];
		[[doc undoManager] endUndoGrouping];	
		[[doc undoManager] setGroupsByEvent:YES];
		
		STAssertTrue([doc isDocumentEdited], @"didnt we just add a 3 new scenes?"); // has changes pertains to the undo manager
	
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
        NSString *mockPath = [[[paths objectAtIndex: 0] stringByAppendingPathComponent:  @"DocWriteTestf"] stringByAppendingPathExtension:documentExtension];
		NSURL* mockStoreUrl = [NSURL fileURLWithPath:mockPath];
		BOOL success = [doc writeToURL:mockStoreUrl ofType:documentExtension error:&error];
//dec09			STAssertTrue(success, @"should be able to write to url");
		NSFileManager* fileManager = [NSFileManager defaultManager];
		BOOL isDirectory;
		BOOL fileExists = [fileManager fileExistsAtPath:mockPath isDirectory:&isDirectory];
//dec09			STAssertTrue(fileExists, @"didnt write file");
		
		BOOL result = [fileManager removeFileAtPath:mockPath handler:nil];
//dec09			STAssertTrue(result, @"Not cleaning up properly after tests");
		// check that docs fileName is now what it should be
		NSURL *docURL = [doc fileURL];
//dec09			STAssertTrue([[docURL path] isEqualToString:[mockStoreUrl path]], @"%@ Not Equal To %@", docURL, mockStoreUrl);
		
		// check that recent docs contains this
	//	NSArray* recentURLS = [dc recentDocumentURLs];
	//	NSURL *latestRecentURL = [recentURLS objectAtIndex:0];
	//	logInfo(@"recentURLS %@", recentURLS);
	//	STAssertTrue([[latestRecentURL path] isEqualToString:[mockStoreUrl path]], @"%@ Not Equal To %@", latestRecentURL, mockStoreUrl);
	
		STAssertTrue([doc isDocumentEdited]==NO, @"Doc should be clean after a read");
		
		/* Undecided about whether to clean undo stack when we save. I would like not too.. but it seems like expected behavoir. Why shouldn't you undo after a save? */
        // STAssertTrue([[doc undoManager] sudo port install]==NO, @"UndoManager should be clean after a read");
}

- (void)testRevertToContentsOfURLofTypeError {
	// - (BOOL)revertToContentsOfURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError
		
	NSError *error;
		
	/* In order to test the result immediately we need to temporarily disable groupsByEvent */
	[[doc undoManager] setGroupsByEvent:NO];
	[[doc undoManager] beginUndoGrouping];
			
	/* clear the doc of any objects */
	SHNode* rootNode = [doc.nodeGraphModel rootNodeGroup];
	NSArray *allRootChildren = [doc.nodeGraphModel allChildrenFromNode:rootNode];
		[doc.nodeGraphModel deleteChildren:allRootChildren fromNode:rootNode];
		
		/* add our test nodes */
		[doc makeEmptyGroupInCurrentNodeWithName:@"revertTest1"];
		[[doc undoManager] endUndoGrouping];
	
		/* Beware this doesnt return an immutable array - it's contents will change */
		allRootChildren = [doc.nodeGraphModel allChildrenFromNode:rootNode];
		int numberOfNodes = [allRootChildren count];
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
		NSString *mockPath = [[[paths objectAtIndex: 0] stringByAppendingPathComponent:  @"DocRevertTestf"] stringByAppendingPathExtension:documentExtension];
		NSURL* mockStoreUrl = [NSURL fileURLWithPath:mockPath];
		BOOL success = [doc writeToURL:mockStoreUrl ofType:documentExtension error:&error];
//dec09		STAssertTrue(success, @"should be able to write to url");
		NSFileManager* fileManager = [NSFileManager defaultManager];
		BOOL isDirectory;
		BOOL fileExists = [fileManager fileExistsAtPath:mockPath isDirectory:&isDirectory];
//dec09			STAssertTrue(fileExists, @"didnt write file");
	
		/* Modify the doc model */
		[[doc undoManager] beginUndoGrouping];
		[doc makeEmptyGroupInCurrentNodeWithName:@"revertTest2"];
		[[doc undoManager] endUndoGrouping];
		/* Attempt the revert */
		success = [doc revertToContentsOfURL:mockStoreUrl ofType:documentExtension error:&error];
//dec09			STAssertTrue(success, @"didnt revert file?");
	
		// check that there is only one scene and its name is revertTest
		rootNode = [doc.nodeGraphModel rootNodeGroup];
		
		/* Beware this doesnt return an immutable array - it's contents will change */
		allRootChildren = [doc.nodeGraphModel allChildrenFromNode:rootNode];
//DEC09		STAssertTrue([allRootChildren count]==numberOfNodes, @"Looks like we didnt revert at all! Should be %i is %i", numberOfNodes, [allRootChildren count] );
		SHNode *singleRemainingNode = [allRootChildren lastObject];
//DEC09		STAssertTrue([[[singleRemainingNode name] value] isEqualToString:@"revertTest1"], @"wrong scene? %@", [singleRemainingNode name]);
			 
		// check that docs fileName is now what it should be
		NSURL *docURL = [doc fileURL];
//DEC09		STAssertTrue([[docURL path] isEqualToString:[mockStoreUrl path]], @"%@ Not Equal To %@", docURL, mockStoreUrl);
		
		STAssertTrue([doc isDocumentEdited]==NO, @"Doc should be clean after a read");
		STAssertTrue([[doc undoManager] canUndo]==NO, @"UndoManager should be clean after a read");
	
		[[doc undoManager] setGroupsByEvent:YES];
		BOOL result = [fileManager removeFileAtPath:mockPath handler:nil];
//DEC09		STAssertTrue(result, @"Not cleaning up properly after tests");
}

- (void)testMakeWindowControllers {
	// - (void)makeWindowControllers
	
		// [doc makeWindowControllers]; // called automatically
//dec2009		NSArray *windowControllers = [doc windowControllers]; 
//dec2009		STAssertTrue([windowControllers count]==1, @"ERROR CREATING WINDOW Controllers");
		
//dec2009		BlakeNodeListWindowController* newWindowController = [windowControllers lastObject];
//dec2009		STAssertTrue([newWindowController document]==doc, @"ERROR CREATING WINDOW Controllers");
}

- (void)testClose {
	// - (void)close
	
		STAssertTrue(doc.isClosed==NO, @"Document status shouldnt be 'closed' after init");
		[doc close];
		STAssertNil(doc.nodeGraphModel, @"Have we closed the doc or what?");
}

- (void)testValidateUserInterfaceItem {
	// - (BOOL)validateUserInterfaceItem:(id<NSValidatedUserInterfaceItem>)anItem
	
		// see other test
		
	//	id<NSValidatedUserInterfaceItem> saveMenuItem =  [fileMenu itemWithTitle:@"Save"];
	//	[saveMenuItem setAction:@selector(newDocument:)];
	//
	//    id<NSValidatedUserInterfaceItem> saveAsMenuItem =  [fileMenu itemWithTitle:@"Save As…"];
	//	[saveAsMenuItem setAction:@selector(newDocument:)];
	
	//    id<NSValidatedUserInterfaceItem> revertMenuItem =  [fileMenu itemWithTitle:@"Revert"];
	//	[revertMenuItem setAction:@selector(newDocument:)];
	
	//	BOOL canSaveAs = [gcc validateUserInterfaceItem: saveAsMenuItem];
	//	STAssertTrue(canSaveAs, @"if we have a doc then close should be enabled");
	//
	//	BOOL canSave = [gcc validateUserInterfaceItem: saveMenuItem];
	//	BOOL canRevert = [gcc validateUserInterfaceItem: revertMenuItem];
	
}

@end
