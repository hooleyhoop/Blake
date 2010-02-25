//
//  BlakeNodeListViewControllerTests.m
//  BlakeLoader
//
//  Created by steve hooley on 05/01/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "BlakeNodeListViewController.h"
#import "BlakeDocumentController.h"
#import "BlakeNodeListWindowController.h"
#import "BlakeDocument.h"
#import "HighLevelBlakeDocumentActions.h"

#import "defs.h"
#import <FScript/FScript.h>

@interface BlakeNodeListViewControllerTests : SenTestCase {
	
	IBOutlet BlakeNodeListViewController		*viewController;
	BlakeDocumentController					*dc;
	BlakeDocument							*doc;
	
}

@property(assign, readwrite, nonatomic) BlakeNodeListViewController	*viewController;

@end


@implementation BlakeNodeListViewControllerTests

@synthesize viewController;

- (void)setUp {
		
	/* One document controller for all documents */
	dc = [BlakeDocumentController sharedDocumentController];

	//- make sure all docs are closed..
	NSArray* allDocs = [dc documents];
	// NSDocument *openDoc = [allDocs lastObject];

	[dc closeAll];
	allDocs = [dc documents];
	STAssertTrue([allDocs count]==0, @"cleanUpExistingDocsBeforeMakingNew broken? %i", [allDocs count]);
	
	[dc newDocument:self];
	doc = [[dc frontDocument] retain];
	
	STAssertNotNil(doc, @"doc init failed");

	BlakeNodeListWindowController *winController = [[doc windowControllers] lastObject];
	self.viewController = winController.viewController;
	STAssertTrue([self.viewController isKindOfClass:[BlakeNodeListViewController class]], @"Fucked up the test by adding more window controllers");
	
	STAssertTrue( [viewController.contentView nextResponder]==viewController, @"ER");
	STAssertTrue( [viewController nextResponder]==[viewController.contentView window], @"ER");
	STAssertNotNil( viewController.currentNodeGroup, @"ER");
}


- (void)tearDown {

	NSArray *allCurrentDocs = [[[dc documents] copy] autorelease];

	for(NSDocument *doc2 in allCurrentDocs)
		[doc2 updateChangeCount:  NSChangeCleared];
		
    [[doc undoManager] setGroupsByEvent:YES];
	[[doc undoManager] removeAllActions];
    
	[doc release];
	
	//- make sure all docs are closed..
	[dc closeAll];
	NSArray* allDocs = [dc documents];
	STAssertTrue([allDocs count]==0, @"closeAll broken? %i", [allDocs count]);
	
	self.viewController = nil;
    
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.3]]; // must give sufficient time - zero doesnt work
}

- (void)resetDocStatus {
    
	[self tearDown];
	[self setUp];
}

- (void)testIconsArePresent {

	NSArray *icons = [BlakeNodeListViewController icons];
	STAssertNotNil(icons, @"where are our icons?");
	STAssertTrue([icons count]==4, @"where are our icons? %i", [icons count]);
}


// - (void)setFilterType:(NSString *)newType;
- (void)testSetFilterType {
    
    	// @"Nodes", @"Inputs", @"Outputs", @"Connectors"
    	[viewController setFilterType: @"All"];
    	[viewController setFilterType: @"Nodes"];
    	[viewController setFilterType: @"Inputs"];
    	[viewController setFilterType: @"Outputs"];
    	[viewController setFilterType: @"Connectors"];
}

- (void)testKindOfObjectAtIndex {
    // - (int)kindOfObjectAtIndex:(int)ind;
    	/* assuming we already have nodes and shit in the doc */
    	STAssertTrue([[[[doc nodeGraphModel] currentNodeGroup] nodesInside] count]==3, @"starting with wrong number of nodesInside");
    	STAssertTrue([[[[doc nodeGraphModel] currentNodeGroup] inputs] count]==3, @"starting with wrong number of inputs");
    	STAssertTrue([[[[doc nodeGraphModel] currentNodeGroup] outputs] count]==3, @"starting with wrong number of outputs");
    	STAssertTrue([[[[doc nodeGraphModel] currentNodeGroup] shInterConnectorsInside] count]==3, @"starting with wrong number of shInterConnectorsInside");
    
    	[viewController setFilterType: @"Nodes"];
    	STAssertTrue([viewController kindOfObjectAtIndex:0]==0, @"wrong");
    	
    	[viewController setFilterType: @"Inputs"];
    	STAssertTrue([viewController kindOfObjectAtIndex:0]==1, @"wrong");
    	
    	[viewController setFilterType: @"Outputs"];
    	STAssertTrue([viewController kindOfObjectAtIndex:0]==2, @"wrong");
    	
    	[viewController setFilterType: @"Connectors"];
    	STAssertTrue([viewController kindOfObjectAtIndex:0]==3, @"wrong %i", [viewController kindOfObjectAtIndex:0]);
    	
    	[viewController setFilterType: @"All"];
    	STAssertTrue([viewController kindOfObjectAtIndex:0]==0, @"wrong");
    	STAssertTrue([viewController kindOfObjectAtIndex:4]==1, @"wrong");
    	STAssertTrue([viewController kindOfObjectAtIndex:7]==2, @"wrong");
    	STAssertTrue([viewController kindOfObjectAtIndex:10]==3, @"wrong");
}

- (void)testCanCopy {
    	// - (BOOL)canCopy;
    	
    	/* assuming we already have nodes and shit in the doc */
    	STAssertTrue([[[[doc nodeGraphModel] currentNodeGroup] nodesInside] count]==3, @"starting with wrong number of nodesInside");
    	STAssertTrue([[[[doc nodeGraphModel] currentNodeGroup] inputs] count]==3, @"starting with wrong number of inputs");
    	STAssertTrue([[[[doc nodeGraphModel] currentNodeGroup] outputs] count]==3, @"starting with wrong number of outputs");
    	STAssertTrue([[[[doc nodeGraphModel] currentNodeGroup] shInterConnectorsInside] count]==3, @"starting with wrong number of shInterConnectorsInside");
    	
    	[viewController setFilterType: @"Nodes"];
    	// select node 0
    	[doc addChildToSelectionInCurrentNode: [[[doc nodeGraphModel] currentNodeGroup] nodeAtIndex:0]];
    	STAssertTrue([viewController canCopy]==YES, @"canCopy failed" );
    	[doc deSelectAllChildrenInCurrentNode];
    	STAssertTrue([viewController canCopy]==NO, @"canCopy failed" );
    	
    	[viewController setFilterType: @"Inputs"];
    	[doc addChildToSelectionInCurrentNode: [[[doc nodeGraphModel] currentNodeGroup] inputAtIndex:0]];
    	STAssertTrue([viewController canCopy]==YES, @"canCopy failed" );
    	[doc deSelectAllChildrenInCurrentNode];
    	STAssertTrue([viewController canCopy]==NO, @"canCopy failed" );
    	
    	[viewController setFilterType: @"Outputs"];
    	[doc addChildToSelectionInCurrentNode: [[[doc nodeGraphModel] currentNodeGroup] outputAtIndex:0]];
    	STAssertTrue([viewController canCopy]==YES, @"canCopy failed" );
    	[doc deSelectAllChildrenInCurrentNode];
    	STAssertTrue([viewController canCopy]==NO, @"canCopy failed" );
    
    	[viewController setFilterType: @"Connectors"];
    	[doc addChildToSelectionInCurrentNode: [[[doc nodeGraphModel] currentNodeGroup] connectorAtIndex:0]];
    	STAssertTrue([viewController canCopy]==NO, @"canCopy failed" );
    	[doc deSelectAllChildrenInCurrentNode];
    	STAssertTrue([viewController canCopy]==NO, @"canCopy failed" );
    	
    	[viewController setFilterType: @"All"];
    	[doc deSelectAllChildrenInCurrentNode];
    	STAssertTrue([viewController canCopy]==NO, @"canCopy failed" );
    	// select an interconnector
    	[doc addChildToSelectionInCurrentNode: [[[doc nodeGraphModel] currentNodeGroup] connectorAtIndex:0]];
    	STAssertTrue([viewController canCopy]==NO, @"canCopy failed" );
    	// select an input
    	[doc addChildToSelectionInCurrentNode: [[[doc nodeGraphModel] currentNodeGroup] inputAtIndex:0]];
    	STAssertTrue([viewController canCopy]==YES, @"canCopy failed" );
}

- (void)testCanPaste {
    	// - (BOOL)canPaste;
    	
    	NSPasteboard *pb = [NSPasteboard generalPasteboard];
    
    	// copy random string to Pasteboard
    	NSArray *types = [NSArray arrayWithObjects: NSStringPboardType, nil];
    	[pb declareTypes:types owner:nil];	
    	[pb setString:@"Once upon a time there was a hoob a noob" forType:NSStringPboardType];
    	STAssertTrue([viewController canPaste]==NO, @"canCopy failed" );
    	
    	// copy proper fscript to the pasteboard
    	id firstNode = [[[doc nodeGraphModel] currentNodeGroup] nodeAtIndex:0];
    	NSXMLElement* rootElement = [doc.nodeGraphModel fScriptWrapperFromChildren:[NSArray arrayWithObject:firstNode] fromNode:[[doc nodeGraphModel] currentNodeGroup]];
    	NSString *xmlString = [rootElement canonicalXMLStringPreservingComments:YES];
    	types = [NSArray arrayWithObjects: fscriptPBoardType, nil];
    	[pb declareTypes:types owner:nil];	
    	[pb setString:xmlString forType: fscriptPBoardType];
    	STAssertTrue([viewController canPaste]==YES, @"canCopy failed" );
    	
    	// copy a string representing some fscript to the pasteboard (like if we were copying from another app)
    	types = [NSArray arrayWithObjects: NSStringPboardType, nil];
    	[pb declareTypes:types owner:nil];	
    	[pb setString:xmlString forType:NSStringPboardType];
    	STAssertTrue([viewController canPaste]==YES, @"canCopy failed" );
}
	
- (void)testCopyCurrentObjects {
    // - (void)copyCurrentObjects
    	[viewController selectAllChildren];
    	[viewController copyCurrentObjects];
    	
    	// -- get the fscript type from the pastboard and execute IT
    	NSPasteboard *pb = [NSPasteboard generalPasteboard];
    	NSString *xmlString = [pb stringForType:fscriptPBoardType];	
    	STAssertNotNil(xmlString, @"copy failed" );
    	NSError *error = nil;
    	NSAssert(xmlString!=nil, @"cant make NSXMLElement 2");
    	NSXMLElement* rootElement = [[[NSXMLElement alloc] initWithXMLString:xmlString error:&error] autorelease];
    	NSArray* nodeStrings = [rootElement objectsForXQuery:@"node" error:&error];
    	NSEnumerator *enumerator = [nodeStrings objectEnumerator];
    	NSXMLElement* xmlElement;
    	NSString *eachNodeFscript;
    	while ((xmlElement = [enumerator nextObject]) ) 
        	{	
            		FSInterpreter* theInterpreter = [FSInterpreter interpreter];
            		eachNodeFscript = [xmlElement stringValue];
            		FSInterpreterResult* execResult = [theInterpreter execute: eachNodeFscript];
            		id result = nil;
            		STAssertTrue([execResult isOK], @"Failed");
            		result = [execResult result];
            		STAssertNotNil(result, @"Failed to execute save string for node");
        	}
    
    	// -- get the string type
    	NSString *pbString = [pb stringForType:NSStringPboardType];	
    	STAssertNotNil(pbString, @"copy failed" );
    	NSAssert(pbString!=nil, @"cant make NSXMLElement 1");
    	rootElement = [[[NSXMLElement alloc] initWithXMLString:pbString error:&error] autorelease];
    	nodeStrings = [rootElement objectsForXQuery:@"node" error:&error];
    	enumerator = [nodeStrings objectEnumerator];
    	while ((xmlElement = [enumerator nextObject]) ) 
        	{	
            		FSInterpreter* theInterpreter = [FSInterpreter interpreter];
            		eachNodeFscript = [xmlElement stringValue];
            		FSInterpreterResult* execResult = [theInterpreter execute: eachNodeFscript];
            		id result = nil;
            		STAssertTrue([execResult isOK], @"Failed");
            		result = [execResult result];
            		STAssertNotNil(result, @"Failed to execute save string for node");
        	}
    
}

- (void)testMyPaste {
    // - (void)myPaste;
    
    	// -- count objects
    	SHNode *cn = [viewController currentNodeGroup];
    	int numberOfNodes = [[cn nodesInside] count];
    	int numberOfInputs = [[cn inputs] count];
    	int numberOfOutputs = [[cn outputs] count];
    	int numberOfConnections = [[cn shInterConnectorsInside] count];
    	
    	[viewController selectAllChildren];
    	[viewController copyCurrentObjects];
    	[viewController myPaste];
    	
    	// -- should now have double the amount of object
    	int postNumberOfNodes = [[cn nodesInside] count];
    	int postNumberOfInputs = [[cn inputs] count];
    	int postNumberOfOutputs = [[cn outputs] count];
    	int postNumberOfConnections = [[cn shInterConnectorsInside] count];
    	
    	STAssertTrue(postNumberOfNodes == numberOfNodes*2, @"copy and paste failed on Nodes");
    	STAssertTrue(postNumberOfInputs == numberOfInputs*2, @"copy and paste failed on Inputs");
    	STAssertTrue(postNumberOfOutputs == numberOfOutputs*2, @"copy and paste failed on Outputs");
    	STAssertTrue(postNumberOfConnections == numberOfConnections*2, @"copy and paste failed on Connectors");
}


// - (BOOL)canSelectAllChildren

- (void)testMyDelete {
    
    	[viewController setFilterType: @"All"];	
    	[viewController selectAllChildren];
    	[viewController myDelete];
}

/* returns an array of file names */
- (void)testTableViewNamesOfPromisedFilesDroppedAtDestinationForDraggedRowsWithIndexes {
    // - (NSArray *)tableView:(NSTableView *)tableView namesOfPromisedFilesDroppedAtDestination:(NSURL *)dropDestination forDraggedRowsWithIndexes:(NSIndexSet *)indexSet {
    
    	// rename some nodes
    	// SHOrderedDictionary *ni = [[doc nodeGraphModel] currentNodeGroup].nodesInside;
    	SHNode *currentNode = [[doc nodeGraphModel] currentNodeGroup];
    	[(SHChild *)[currentNode nodeAtIndex:0] setName:@"rrrr"];
    	[(SHChild *)[currentNode nodeAtIndex:1] setName:@"ssss"];
    	[(SHChild *)[currentNode nodeAtIndex:2] setName:@"tttt"];
    
    	NSTableView *tv = (NSTableView *)viewController.displayedNodesTableView;
    	
    	// save them to the desktop
    	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
    	NSString *desktopPath = [paths objectAtIndex: 0];
    	NSURL* desktopURL = [NSURL fileURLWithPath:desktopPath];
    	[viewController tableView:tv namesOfPromisedFilesDroppedAtDestination:desktopURL forDraggedRowsWithIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)]];
    
    	// we should now have 3 valid files on the desktop
    	NSString *path1 = [desktopPath stringByAppendingPathComponent:@"rrrr.fscript"];
    	NSString *path2 = [desktopPath stringByAppendingPathComponent:@"ssss.fscript"];
    	NSString *path3 = [desktopPath stringByAppendingPathComponent:@"tttt.fscript"];
    	NSFileManager* fileManager = [NSFileManager defaultManager];
    	BOOL isDirectory;
    	BOOL fileExists1 = [fileManager fileExistsAtPath:path1 isDirectory:&isDirectory];
    	BOOL fileExists2 = [fileManager fileExistsAtPath:path2 isDirectory:&isDirectory];
    	BOOL fileExists3 = [fileManager fileExistsAtPath:path3 isDirectory:&isDirectory];
    
    	STAssertTrue(fileExists1, @"didnt write file");
    	STAssertTrue(fileExists2, @"didnt write file");
    	STAssertTrue(fileExists3, @"didnt write file");
    
    	[fileManager removeFileAtPath:path1 handler:nil];
    	[fileManager removeFileAtPath:path2 handler:nil];
    	[fileManager removeFileAtPath:path3 handler:nil];
}

- (void)testTableViewWriteRowsWithIndexestToPasteboard {
    // - (BOOL)tableView:(NSTableView *)tv writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard 
    
    	NSPasteboard *pb = [NSPasteboard generalPasteboard];
    	NSTableView *tv = (NSTableView *)viewController.displayedNodesTableView;
    	
    	[viewController setFilterType: @"Nodes"];
    	BOOL success = [viewController tableView:tv writeRowsWithIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)] toPasteboard:pb];
    	STAssertTrue(success, @"dragging rows failed" );
    
    	[viewController setFilterType: @"Inputs"];
    	success = [viewController tableView:tv writeRowsWithIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)] toPasteboard:pb];
    	STAssertTrue(success, @"dragging rows failed" );
    	
    	[viewController setFilterType: @"Outputs"];
    	success = [viewController tableView:tv writeRowsWithIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)] toPasteboard:pb];
    	STAssertTrue(success, @"dragging rows failed" );
    	
    	/* cant drag interconnectors */
    	[viewController setFilterType: @"Connectors"];
    	success = [viewController tableView:tv writeRowsWithIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)] toPasteboard:pb];
    	STAssertTrue(success==false, @"dragging rows failed" );
    	
    	[viewController setFilterType: @"All"];
    	success = [viewController tableView:tv writeRowsWithIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)] toPasteboard:pb];
    	STAssertTrue(success, @"dragging rows failed" );
    	success = [viewController tableView:tv writeRowsWithIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(3, 3)] toPasteboard:pb];
    	STAssertTrue(success, @"dragging rows failed" );
    	success = [viewController tableView:tv writeRowsWithIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(6, 3)] toPasteboard:pb];
    	STAssertTrue(success, @"dragging rows failed" );
    	success = [viewController tableView:tv writeRowsWithIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(9, 3)] toPasteboard:pb];
    	STAssertTrue(success, @"dragging rows failed" );
    	success = [viewController tableView:tv writeRowsWithIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(12, 3)] toPasteboard:pb];
    	STAssertTrue(success==true, @"dragging rows failed" );
    	
    	NSMutableIndexSet *complexDrag = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(12, 3)];
    	success = [viewController tableView:tv writeRowsWithIndexes:complexDrag toPasteboard:pb];
    	STAssertTrue(success==true, @"dragging rows failed" );
    	
    	/* Test with Alt key pressed - should add a flag to the pasteboard that the accept drop methods can test for */
    	NSString* altPressed = [pb availableTypeFromArray:[NSArray arrayWithObject:@"ALTKEY_PRESSED"]];
    	BOOL wasAltPressed = altPressed!=nil;
    	STAssertFalse(wasAltPressed, @"Test ALT KEY PRESSED");
    	[NSApp oneShotOverideAltKeyDown];
    	success = [viewController tableView:tv writeRowsWithIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)] toPasteboard:pb];
    	altPressed = [pb availableTypeFromArray:[NSArray arrayWithObject:@"ALTKEY_PRESSED"]];
    	wasAltPressed = altPressed!=nil;
    	STAssertTrue(wasAltPressed, @"Test ALT KEY PRESSED");
}

- (void)testtTableViewValidateDropProposedRowProposedDropOperation {
    // - (NSDragOperation)tableView:(NSTableView*)tableView validateDrop:(id <NSDraggingInfo>)info proposedRow:(int)proposedRow proposedDropOperation:(NSTableViewDropOperation)op 
    
    	// NSTableView *tv = (NSTableView *)viewController.displayedNodesTableView;
    	// NSPasteboard *pb = [NSPasteboard generalPasteboard];
}

/* if we are dragging to the same table (ie. reordering) each row must be of the same type, and if mode is 'All' you can only drop to the same destination type */
- (void)testValidateSameTableDrop {
    	// - (NSDragOperation)_validateSameTableDrop:(id <NSDraggingInfo>)info proposedRow:(int)proposedRow proposedDropOperation:(NSTableViewDropOperation)op {
    
    	NSTableView *tv = (NSTableView *)viewController.displayedNodesTableView;
    	NSPasteboard *pb = [NSPasteboard generalPasteboard];
    
    	// rows from the same table
    	id dropInfo1 = [OCMockObject mockForClass:NSClassFromString(@"NSDragDestination")];
    	[[[dropInfo1 stub] andReturnValue:OCMOCK_VALUE(pb)] draggingPasteboard];
    	[[[dropInfo1 stub] andReturnValue:OCMOCK_VALUE(tv)] draggingSource];
    	
    	[pb declareTypes:[NSArray arrayWithObjects:MyTableViewDataType, nil] owner:self];
    	NSIndexSet *rowIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
        [pb setData:data forType:MyTableViewDataType];
    	
    	[viewController setFilterType: @"Connectors"];
    	NSDragOperation result = [viewController _validateSameTableDrop:dropInfo1 proposedRow:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationNone, @"should be none %i, %i", result, NSDragOperationNone);
    
    	[viewController setFilterType: @"Nodes"];
    	result = [viewController _validateSameTableDrop:dropInfo1 proposedRow:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationMove, @"should be none %i, %i", result, NSDragOperationMove);
    
    	[viewController setFilterType: @"Inputs"];
    	result = [viewController _validateSameTableDrop:dropInfo1 proposedRow:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationMove, @"should be none %i, %i", result, NSDragOperationMove);
    	
    	[viewController setFilterType: @"Outputs"];
    	result = [viewController _validateSameTableDrop:dropInfo1 proposedRow:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationMove, @"should be none %i, %i", result, NSDragOperationMove);
    	
    	[viewController setFilterType: @"All"];
    	result = [viewController _validateSameTableDrop:dropInfo1 proposedRow:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationMove, @"should be none %i, %i", result, NSDragOperationMove);
    
    	result = [viewController _validateSameTableDrop:dropInfo1 proposedRow:4 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationNone, @"should be none %i, %i", result, NSDragOperationNone);
}

- (void)testTableViewAcceptDropRowRropOperation {
    // - (BOOL)tableView:(NSTableView *)aTableView acceptDrop:(id <NSDraggingInfo>)info row:(int)row dropOperation:(NSTableViewDropOperation)operation
}

- (void)test_acceptFileDrop {
    // - (BOOL)_acceptFileDrop:(id <NSDraggingInfo>)info;
    
    	NSTableView *tv = (NSTableView *)viewController.displayedNodesTableView;
    	NSPasteboard *pb = [NSPasteboard generalPasteboard];
    	
    	// we can drop files - try a jpeg - should fail
    	id dropInfo = [OCMockObject mockForClass:NSClassFromString(@"NSDragDestination")];
    	[[[dropInfo stub] andReturnValue:OCMOCK_VALUE(pb)] draggingPasteboard];
    	[[dropInfo stub] draggingSource];
    	
    	[pb declareTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil] owner:self];
        NSArray *fileNameList = [NSArray arrayWithObject:@"/aFile.jpg"];
        [pb setPropertyList:fileNameList forType:NSFilenamesPboardType];
    	
    	[viewController setFilterType: @"Nodes"];
    	BOOL result = [viewController tableView:tv acceptDrop:dropInfo row:1 dropOperation: NSTableViewDropAbove ];
    	STAssertFalse(result, @"should be none");
    	[viewController setFilterType: @"All"];
    	result = [viewController tableView:tv acceptDrop:dropInfo row:1 dropOperation: NSTableViewDropAbove ];
    	STAssertFalse(result, @"should be none");	
    	
    	// now try fscript - should succedd
    	// -- create a temporary file on the desktop
    	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
    	NSString *mockPath = [[paths objectAtIndex: 0] stringByAppendingPathComponent:  @"aFile.fscript"];
    	NSURL* mockStoreUrl = [NSURL fileURLWithPath:mockPath];
    	NSError *error = nil;
    	BOOL success = [doc writeToURL:mockStoreUrl ofType:@"fscript" error:&error];
    	STAssertTrue(success, @"should be able to write to url");
    
    	[pb declareTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil] owner:self];
        [pb setPropertyList:[NSArray arrayWithObject:mockPath] forType:NSFilenamesPboardType];
    	result = [viewController tableView:tv acceptDrop:dropInfo row:1 dropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result, @"should be none");
    	[self resetDocStatus];
    	
    	[viewController setFilterType: @"All"];
    	result = [viewController tableView:tv acceptDrop:dropInfo row:1 dropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result, @"should be none");	
    	[self resetDocStatus];
    	
    	// but should fail when not in mode all or node
    	[viewController setFilterType: @"Inputs"];
    	result = [viewController tableView:tv acceptDrop:dropInfo row:1 dropOperation: NSTableViewDropAbove ];
    	STAssertFalse(result, @"should be none");	
    	[viewController setFilterType: @"Outputs"];
    	result = [viewController tableView:tv acceptDrop:dropInfo row:1 dropOperation: NSTableViewDropAbove ];
    	STAssertFalse(result, @"should be none");	
    	[viewController setFilterType: @"Connectors"];
    	result = [viewController tableView:tv acceptDrop:dropInfo row:1 dropOperation: NSTableViewDropAbove ];
    	STAssertFalse(result, @"should be none");
    	
    	NSFileManager* fileManager = [NSFileManager defaultManager];
    	result = [fileManager removeFileAtPath:mockPath handler:nil];
}

- (void)test_acceptSameTableDrop {
    // - (BOOL)_acceptSameTableDrop:(id <NSDraggingInfo>)info proposedRow:(int)proposedRow proposedDropOperation:(NSTableViewDropOperation)op;
    
	NSTableView *tv = (NSTableView *)viewController.displayedNodesTableView;
	NSPasteboard *pb = [NSPasteboard generalPasteboard];

	// rows from the same table
	id dropInfo1 = [OCMockObject mockForClass:NSClassFromString(@"NSDragDestination")];
	[[[dropInfo1 stub] andReturnValue:OCMOCK_VALUE(pb)] draggingPasteboard];
	[[[dropInfo1 stub] andReturnValue:OCMOCK_VALUE(tv)] draggingSource];
	
	[pb declareTypes:[NSArray arrayWithObjects:MyTableViewDataType, nil] owner:self];
	NSIndexSet *rowIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)];
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
	[pb setData:data forType:MyTableViewDataType];
	
	[viewController setFilterType: @"Connectors"];
	BOOL result = [viewController _acceptSameTableDrop:dropInfo1 row:3 proposedDropOperation: NSTableViewDropAbove ];
	STAssertFalse(result, @"should be none");

	[viewController setFilterType: @"Nodes"];
	result = [viewController _acceptSameTableDrop:dropInfo1 row:3 proposedDropOperation: NSTableViewDropAbove ];
	STAssertTrue(result, @"should be none");
	[self resetDocStatus];
	
	[viewController setFilterType: @"Inputs"];
	result = [viewController _acceptSameTableDrop:dropInfo1 row:3 proposedDropOperation: NSTableViewDropAbove ];
	STAssertTrue(result, @"should be none");
	[self resetDocStatus];
	
	[viewController setFilterType: @"Outputs"];
	result = [viewController _acceptSameTableDrop:dropInfo1 row:3 proposedDropOperation: NSTableViewDropAbove ];
	STAssertTrue(result, @"should be none");
	[self resetDocStatus];
	
	/* varify each kind of drag to both first index -1 and last index */
	[viewController setFilterType: @"All"];
	/* Nodes */
	result = [viewController _acceptSameTableDrop:dropInfo1 row:0 proposedDropOperation: NSTableViewDropAbove ];
	STAssertTrue(result, @"should be none");
	[self resetDocStatus];
	
	result = [viewController _acceptSameTableDrop:dropInfo1 row:3 proposedDropOperation: NSTableViewDropAbove ];
	STAssertTrue(result, @"should be none");
	[self resetDocStatus];
	
	result = [viewController _acceptSameTableDrop:dropInfo1 row:4 proposedDropOperation: NSTableViewDropAbove ];
	STAssertFalse(result, @"should be none");
	
	/* Inputs */
	rowIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(3, 3)];
	data = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
	[pb setData:data forType:MyTableViewDataType];
	result = [viewController _acceptSameTableDrop:dropInfo1 row:3 proposedDropOperation: NSTableViewDropAbove ];
	STAssertTrue(result, @"should be none");
	[self resetDocStatus];
	result = [viewController _acceptSameTableDrop:dropInfo1 row:6 proposedDropOperation: NSTableViewDropAbove ];
	STAssertTrue(result, @"should be none");
	[self resetDocStatus];
	result = [viewController _acceptSameTableDrop:dropInfo1 row:10 proposedDropOperation: NSTableViewDropAbove ];
	STAssertFalse(result, @"should be none");
	
	/* Outputs */
	rowIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(6, 3)];
	data = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
	[pb setData:data forType:MyTableViewDataType];
	result = [viewController _acceptSameTableDrop:dropInfo1 row:6 proposedDropOperation: NSTableViewDropAbove ];
	STAssertTrue(result, @"should be none");
	[self resetDocStatus];
	result = [viewController _acceptSameTableDrop:dropInfo1 row:9 proposedDropOperation: NSTableViewDropAbove ];
	STAssertTrue(result, @"should be none");
	[self resetDocStatus];
	result = [viewController _acceptSameTableDrop:dropInfo1 row:10 proposedDropOperation: NSTableViewDropAbove ];
	STAssertFalse(result, @"should be none");
	
	/* Connectors - cant reorder them */
	rowIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(9, 3)];
	data = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
	[pb setData:data forType:MyTableViewDataType];
	result = [viewController _acceptSameTableDrop:dropInfo1 row:9 proposedDropOperation: NSTableViewDropAbove ];
	STAssertFalse(result, @"should be none");
	result = [viewController _acceptSameTableDrop:dropInfo1 row:12 proposedDropOperation: NSTableViewDropAbove ];
	STAssertFalse(result, @"should be none");
	result = [viewController _acceptSameTableDrop:dropInfo1 row:13 proposedDropOperation: NSTableViewDropAbove ];
	STAssertFalse(result, @"should be none");
	[self resetDocStatus];

	/* Test dropping at a nonsense row at a nonsense loaction */
	[viewController setFilterType: @"Nodes"];
	result = [viewController _acceptSameTableDrop:dropInfo1 row:9 proposedDropOperation: NSTableViewDropAbove ];
	STAssertFalse(result, @"should be none");

	/* Test with Alt key pressed - MMm final resting place is somewhat tricky */
	[viewController setFilterType: @"Nodes"];
	[NSApp oneShotOverideAltKeyDown];
	BOOL success = [viewController tableView:tv writeRowsWithIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)] toPasteboard:pb]; // copy 2 nodes
	STAssertTrue(success==YES, @"Should have written our little altPressed flag to the pasteboard");
	STAssertTrue([[viewController.displayedNodesArrayController arrangedObjects] count]==3, @"should start with 3 objects");

	SHNode *node1 = [[viewController.displayedNodesArrayController arrangedObjects] objectAtIndex:0];
	SHNode *node2 = [[viewController.displayedNodesArrayController arrangedObjects] objectAtIndex:1];
	SHNode *node3 = [[viewController.displayedNodesArrayController arrangedObjects] objectAtIndex:2];
	[node1 setName:@"aaa"];
	[node2 setName:@"bbb"];
	[node3 setName:@"ccc"];
	STAssertTrue([[viewController.displayedNodesArrayController arrangedObjects] count]==3, @"should start with 3 objects");

	/* Do the alt-drag */
	result = [viewController _acceptSameTableDrop:dropInfo1 row:3 proposedDropOperation: NSTableViewDropAbove ]; // drop 2 nodes after the 3rd node
	
	STAssertTrue(result, @"should be none");
	STAssertTrue([[viewController.displayedNodesArrayController arrangedObjects] count]==5, @"should start with 3 objects");
    	
    	SHNode* nodeAt0 = [[viewController.displayedNodesArrayController arrangedObjects] objectAtIndex:0];
    	SHNode* nodeAt1 = [[viewController.displayedNodesArrayController arrangedObjects] objectAtIndex:1];
    	SHNode* nodeAt2 = [[viewController.displayedNodesArrayController arrangedObjects] objectAtIndex:2];
    	SHNode* nodeAt3 = [[viewController.displayedNodesArrayController arrangedObjects] objectAtIndex:3];
    	SHNode* nodeAt4 = [[viewController.displayedNodesArrayController arrangedObjects] objectAtIndex:4];
    	STAssertTrue(nodeAt0==node1, @"That node should not have changed loaction");
    	STAssertTrue(nodeAt1==node2, @"That node should not have changed loaction");
    	STAssertTrue(nodeAt2==node3, @"That node should not have changed loaction %@", nodeAt2);
    
    	NSString* node3Name = [nodeAt3 name];
    	NSString* node4Name = [nodeAt4 name];
    	STAssertTrue([node3Name characterAtIndex:0]=='a', @"This should be a duplicate of node1 is %c", [node3Name characterAtIndex:0]);
    	STAssertTrue([node4Name characterAtIndex:0]=='b', @"This should be a duplicate of node2 is %c", [node4Name characterAtIndex:0]);
    
    //	SHNode *cn = [viewController currentNodeGroup];
    //	int numberOfNodes = [[cn nodesInside] count];
    //			int actualIndex = 
    
    	
    	
    //	STFail(@"Test ALT KEY PRESSED");
    
    //	NSString* altPressed = [pb availableTypeFromArray:[NSArray arrayWithObject:@"ALTKEY_PRESSED"]];
    //	BOOL wasAltPressed = altPressed!=nil;
    //	STAssertFalse(wasAltPressed, @"Test ALT KEY PRESSED");
    //	success = [viewController tableView:tv writeRowsWithIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)] toPasteboard:pb];
    //	altPressed = [pb availableTypeFromArray:[NSArray arrayWithObject:@"ALTKEY_PRESSED"]];
    //	wasAltPressed = altPressed!=nil;
    //	STAssertTrue(wasAltPressed, @"Test ALT KEY PRESSED");
    
}

- (void)setUpSecondTable:(BlakeDocument**)newDoc1 :(BlakeNodeListWindowController**)winController21 :(BlakeNodeListViewController**)secondViewController1 :(SHRootNodeListTableView**)secondTV1 :(id*)dropInfo21 {
    
    NSPasteboard *pb = [NSPasteboard generalPasteboard];
    
    [dc newDocument:self];
    *newDoc1 = [dc frontDocument];
    *winController21 = [[*newDoc1 windowControllers] lastObject];
    *secondViewController1 = (*winController21).viewController;
    *secondTV1 = (*secondViewController1).displayedNodesTableView;
    
    *dropInfo21 = [OCMockObject mockForClass:NSClassFromString(@"NSDragDestination")];
    [[[*dropInfo21 stub] andReturnValue:OCMOCK_VALUE(pb)] draggingPasteboard];
    [[[*dropInfo21 stub] andReturnValue:OCMOCK_VALUE(*secondTV1)] draggingSource];
}

- (void)test_acceptDifferentTableDrop {
    // - (BOOL)_acceptDifferentTableDrop:(id <NSDraggingInfo>)info row:(int)row proposedDropOperation:(NSTableViewDropOperation)op;
    
    	// NSTableView *tv = (NSTableView *)viewController.displayedNodesTableView;
    	NSPasteboard *pb = [NSPasteboard generalPasteboard];
    
    	BlakeDocument *newDoc = nil;
    	BlakeNodeListWindowController *winController2 = nil;
    	BlakeNodeListViewController *secondViewController = nil;
    	SHRootNodeListTableView *secondTV = nil;
    	id dropInfo2 = nil;
    	
    	[self setUpSecondTable :&newDoc :&winController2 :&secondViewController :&secondTV :&dropInfo2];
    	
    	[pb declareTypes:[NSArray arrayWithObjects:MyTableViewDataType, nil] owner:self];
    	NSIndexSet *rowIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
        [pb setData:data forType:MyTableViewDataType];
    	
    	// if source filter type is 'Connectors' or dest is 'Connectors' or src is 'All' and rows is connectors : fail
    	[secondViewController setFilterType: @"Nodes"];
    	[viewController setFilterType: @"Connectors"];
    	// -- fail
    	BOOL result = [viewController _acceptDifferentTableDrop:dropInfo2 row:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertFalse(result, @"cant drag nodes to connectors");
    		
    	[secondViewController setFilterType: @"Nodes"];
    	[viewController setFilterType: @"Inputs"];
    	// -- fail
    	result = [viewController _acceptDifferentTableDrop:dropInfo2 row:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertFalse(result, @"cant drag nodes to inputs");
    		
    	[secondViewController setFilterType: @"Nodes"];
    	[viewController setFilterType: @"Outputs"];
    	// -- fail
    	result = [viewController _acceptDifferentTableDrop:dropInfo2 row:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertFalse(result, @"cant drag nodes to outputs");
    
    	[secondViewController setFilterType: @"Connectors"];
    	[viewController setFilterType: @"Connectors"];
    	// -- fail
    	result = [viewController _acceptDifferentTableDrop:dropInfo2 row:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertFalse(result, @"cant drag connectors");
    		
    	[secondViewController setFilterType: @"Connectors"];
    	[viewController setFilterType: @"Inputs"];
    	// -- fail
    	result = [viewController _acceptDifferentTableDrop:dropInfo2 row:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertFalse(result, @"cant drag connectors to inputs");
    		
    	[secondViewController setFilterType: @"Connectors"];
    	[viewController setFilterType: @"Outputs"];
    	// -- fail
    	result = [viewController _acceptDifferentTableDrop:dropInfo2 row:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertFalse(result, @"cant drag connectors to nodes");
    		
    	[secondViewController setFilterType: @"Connectors"];
    	[viewController setFilterType: @"Nodes"];
    	// -- fail
    	result = [viewController _acceptDifferentTableDrop:dropInfo2 row:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertFalse(result, @"cant drag connectors to nodes");
    		
    	[secondViewController setFilterType: @"Connectors"];
    	[viewController setFilterType: @"All"];
    	// -- fail
    	result = [viewController _acceptDifferentTableDrop:dropInfo2 row:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertFalse(result, @"cant drag connectors");	
    	
    	[secondViewController setFilterType: @"Inputs"];
    	[viewController setFilterType: @"Connectors"];
    	// -- fail
    	result = [viewController _acceptDifferentTableDrop:dropInfo2 row:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertFalse(result, @"cant drag inputs to connectors");
    
    	[secondViewController setFilterType: @"Inputs"];
    	[viewController setFilterType: @"Outputs"];
    	// -- fail
    	result = [viewController _acceptDifferentTableDrop:dropInfo2 row:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertFalse(result, @"cant drag inputs to outputs");
    		
    	[secondViewController setFilterType: @"Inputs"];
    	[viewController setFilterType: @"Nodes"];
    	// -- fail
    	result = [viewController _acceptDifferentTableDrop:dropInfo2 row:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertFalse(result, @"cant drag inputs to nodes");
    
    	[secondViewController setFilterType: @"Outputs"];
    	[viewController setFilterType: @"Connectors"];
    	// -- fail
    	result = [viewController _acceptDifferentTableDrop:dropInfo2 row:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertFalse(result, @"cant drag outputs to connectors");
    	
    	[secondViewController setFilterType: @"Outputs"];
    	[viewController setFilterType: @"Inputs"];
    	// -- fail
    	result = [viewController _acceptDifferentTableDrop:dropInfo2 row:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertFalse(result, @"cant drag outputs to inputs");
    
    	[secondViewController setFilterType: @"Outputs"];
    	[viewController setFilterType: @"Nodes"];
    	// -- fail
    	result = [viewController _acceptDifferentTableDrop:dropInfo2 row:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertFalse(result, @"cant drag outputs to nodes");
    
    	[secondViewController setFilterType: @"All"];
    	[viewController setFilterType: @"Connectors"];
    	// -- fail
    	result = [viewController _acceptDifferentTableDrop:dropInfo2 row:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertFalse(result, @"cant drag nodes to connectors");
    		
    	[secondViewController setFilterType: @"Outputs"];
    	[viewController setFilterType: @"Outputs"];
    	// -- copy
    	result = [viewController _acceptDifferentTableDrop:dropInfo2 row:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result, @"valid drag");
    	[self resetDocStatus];
    	
    	[self setUpSecondTable :&newDoc :&winController2 :&secondViewController :&secondTV :&dropInfo2];
    
    	
    	[secondViewController setFilterType: @"Nodes"];
    	[viewController setFilterType: @"Nodes"];
    	// -- copy
    	result = [viewController _acceptDifferentTableDrop:dropInfo2 row:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result, @"valid drag");
    	[self resetDocStatus];
    	
    	[self setUpSecondTable :&newDoc :&winController2 :&secondViewController :&secondTV :&dropInfo2];
    	
    	[secondViewController setFilterType: @"Inputs"];
    	[viewController setFilterType: @"Inputs"];
    	// -- copy
    	result = [viewController _acceptDifferentTableDrop:dropInfo2 row:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result, @"valid drag");
    	[self resetDocStatus];
    
    	[self setUpSecondTable :&newDoc :&winController2 :&secondViewController :&secondTV :&dropInfo2];
    
    	
    	[secondViewController setFilterType: @"Nodes"];
    	[viewController setFilterType: @"All"];
    	// -- copy
    	result = [viewController _acceptDifferentTableDrop:dropInfo2 row:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result, @"valid drag");
    	[self resetDocStatus];
    	
    	[self setUpSecondTable :&newDoc :&winController2 :&secondViewController :&secondTV :&dropInfo2];
    
    	result = [viewController _acceptDifferentTableDrop:dropInfo2 row:7 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertFalse(result, @"cant drop on that row");
    	
    	[secondViewController setFilterType: @"Inputs"];
    	[viewController setFilterType: @"All"];
    	// -- copy
    	result = [viewController _acceptDifferentTableDrop:dropInfo2 row:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result, @"valid drop");
    	[self resetDocStatus];
    	
    	[self setUpSecondTable :&newDoc :&winController2 :&secondViewController :&secondTV :&dropInfo2];
    
    	[secondViewController setFilterType: @"Inputs"];
    	[viewController setFilterType: @"All"];
    	
    	result = [viewController _acceptDifferentTableDrop:dropInfo2 row:0 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertFalse(result, @"not a valid drop at this loction");
    	result = [viewController _acceptDifferentTableDrop:dropInfo2 row:11 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertFalse(result, @"not a valid drop at this location");
    	
    	[secondViewController setFilterType: @"Outputs"];
    	[viewController setFilterType: @"All"];
    	// -- copy
    	result = [viewController _acceptDifferentTableDrop:dropInfo2 row:6 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result, @"should be none");
    	[self resetDocStatus];
    	
    	[self setUpSecondTable :&newDoc :&winController2 :&secondViewController :&secondTV :&dropInfo2];
    
    	
    	[secondViewController setFilterType: @"Outputs"];
    	[viewController setFilterType: @"All"];
    	result = [viewController _acceptDifferentTableDrop:dropInfo2 row:0 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertFalse(result, @"not a valid drop at this location");
    	result = [viewController _acceptDifferentTableDrop:dropInfo2 row:11 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertFalse(result, @"should be none");
    	
    	[secondViewController setFilterType: @"All"];
    	[viewController setFilterType: @"Inputs"];
    	// -- copy if source is inputs
    	result = [viewController _acceptDifferentTableDrop:dropInfo2 row:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertFalse(result, @"should be none");	
        data = [NSKeyedArchiver archivedDataWithRootObject:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(3, 3)]];
        [pb setData:data forType:MyTableViewDataType];
    	result = [viewController _acceptDifferentTableDrop:dropInfo2 row:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result, @"should be none");
    	[self resetDocStatus];
    	
    	[self setUpSecondTable :&newDoc :&winController2 :&secondViewController :&secondTV :&dropInfo2];
    
    	
    	[secondViewController setFilterType: @"All"];
    	[viewController setFilterType: @"Outputs"];
    	// -- copy if src is outputs
    	result = [viewController _acceptDifferentTableDrop:dropInfo2 row:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertFalse(result, @"should be none");	
        data = [NSKeyedArchiver archivedDataWithRootObject:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(6, 3)]];
        [pb setData:data forType:MyTableViewDataType];
    	result = [viewController _acceptDifferentTableDrop:dropInfo2 row:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result, @"should be none");
    	[self resetDocStatus];
    	
    	[self setUpSecondTable :&newDoc :&winController2 :&secondViewController :&secondTV :&dropInfo2];
    
    	
  	[secondViewController setFilterType: @"All"];
   	[viewController setFilterType: @"Nodes"];
   	// -- copy if src is nodes
   	result = [viewController _acceptDifferentTableDrop:dropInfo2 row:3 proposedDropOperation: NSTableViewDropAbove ];
   	STAssertFalse(result, @"should be none");	
       data = [NSKeyedArchiver archivedDataWithRootObject:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)]];
       [pb setData:data forType:MyTableViewDataType];
   	result = [viewController _acceptDifferentTableDrop:dropInfo2 row:3 proposedDropOperation: NSTableViewDropAbove ];
   	STAssertTrue(result, @"should be none");
   	[self resetDocStatus];
    	
   	[self setUpSecondTable :&newDoc :&winController2 :&secondViewController :&secondTV :&dropInfo2];
    
    	
    	[secondViewController setFilterType: @"All"];
    	[viewController setFilterType: @"All"];
    	// -- copy any combination of inputs, outputs and nodes. If we have inputs and outputs we also need to copy any connectors between them
    	NSMutableIndexSet *mis = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)];
    	[mis addIndex:3];
    	[mis addIndex:6];
    	[mis addIndex:9];
        data = [NSKeyedArchiver archivedDataWithRootObject:mis];
        [pb setData:data forType:MyTableViewDataType];
    	result = [viewController _acceptDifferentTableDrop:dropInfo2 row:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertFalse(result, @"should be none");
    	[self resetDocStatus];
    	
    	[self setUpSecondTable :&newDoc :&winController2 :&secondViewController :&secondTV :&dropInfo2];
    
    	
    	// copy the last output from table2 to after the last output position in table2
    	mis = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(8, 1)];
        data = [NSKeyedArchiver archivedDataWithRootObject:mis];
        [pb setData:data forType:MyTableViewDataType];	
    	result = [viewController _acceptDifferentTableDrop:dropInfo2 row:11 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertFalse(result, @"should be none");
    	
    	// STFail(@"Copy the connections");
}


- (void)testValidateDifferentTableDrop {
    	// - (NSDragOperation)_validateDifferentTableDrop:(id <NSDraggingInfo>)info proposedRow:(int)proposedRow proposedDropOperation:(NSTableViewDropOperation)op  {
    
    	NSTableView *tv = (NSTableView *)viewController.displayedNodesTableView;
    	NSPasteboard *pb = [NSPasteboard generalPasteboard];
    
    	[dc newDocument:self];
    	BlakeDocument *newDoc = [dc frontDocument];
    	STAssertTrue(newDoc!=doc, @"didnt we just make a new doc?");
    	BlakeNodeListWindowController *winController2 = [[newDoc windowControllers] lastObject];
    	BlakeNodeListViewController *secondViewController = winController2.viewController;
    		
    	id dropInfo2 = [OCMockObject mockForClass:NSClassFromString(@"NSDragDestination")];
    	[[[dropInfo2 stub] andReturnValue:OCMOCK_VALUE(pb)] draggingPasteboard];
    	[[[dropInfo2 stub] andReturnValue:OCMOCK_VALUE(tv)] draggingSource];
    	
    	[pb declareTypes:[NSArray arrayWithObjects:MyTableViewDataType, nil] owner:self];
    	NSIndexSet *rowIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
        [pb setData:data forType:MyTableViewDataType];
    	
    	// if source filter type is 'Connectors' or dest is 'Connectors' or src is 'All' and rows is connectors : fail
    	[viewController setFilterType: @"Nodes"];
    	[secondViewController setFilterType: @"Connectors"];
    	// -- fail
    	NSDragOperation result = [secondViewController _validateDifferentTableDrop:dropInfo2 proposedRow:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationNone, @"should be none %i, %i", result, NSDragOperationNone);
    		
    	[viewController setFilterType: @"Nodes"];
    	[secondViewController setFilterType: @"Inputs"];
    	// -- fail
    	result = [secondViewController _validateDifferentTableDrop:dropInfo2 proposedRow:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationNone, @"should be none %i, %i", result, NSDragOperationNone);
    		
    	[viewController setFilterType: @"Nodes"];
    	[secondViewController setFilterType: @"Outputs"];
    	// -- fail
    	result = [secondViewController _validateDifferentTableDrop:dropInfo2 proposedRow:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationNone, @"should be none %i, %i", result, NSDragOperationNone);
    
    	[viewController setFilterType: @"Connectors"];
    	[secondViewController setFilterType: @"Connectors"];
    	// -- fail
    	result = [secondViewController _validateDifferentTableDrop:dropInfo2 proposedRow:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationNone, @"should be none %i, %i", result, NSDragOperationNone);
    		
    	[viewController setFilterType: @"Connectors"];
    	[secondViewController setFilterType: @"Inputs"];
    	// -- fail
    	result = [secondViewController _validateDifferentTableDrop:dropInfo2 proposedRow:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationNone, @"should be none %i, %i", result, NSDragOperationNone);
    		
    	[viewController setFilterType: @"Connectors"];
    	[secondViewController setFilterType: @"Outputs"];
    	// -- fail
    	result = [secondViewController _validateDifferentTableDrop:dropInfo2 proposedRow:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationNone, @"should be none %i, %i", result, NSDragOperationNone);
    		
    	[viewController setFilterType: @"Connectors"];
    	[secondViewController setFilterType: @"Nodes"];
    	// -- fail
    	result = [secondViewController _validateDifferentTableDrop:dropInfo2 proposedRow:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationNone, @"should be none %i, %i", result, NSDragOperationNone);
    		
    	[viewController setFilterType: @"Connectors"];
    	[secondViewController setFilterType: @"All"];
    	// -- fail
    	result = [secondViewController _validateDifferentTableDrop:dropInfo2 proposedRow:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationNone, @"should be none %i, %i", result, NSDragOperationNone);	
    	
    	[viewController setFilterType: @"Inputs"];
    	[secondViewController setFilterType: @"Connectors"];
    	// -- fail
    	result = [secondViewController _validateDifferentTableDrop:dropInfo2 proposedRow:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationNone, @"should be none %i, %i", result, NSDragOperationNone);
    
    	[viewController setFilterType: @"Inputs"];
    	[secondViewController setFilterType: @"Outputs"];
    	// -- fail
    	result = [secondViewController _validateDifferentTableDrop:dropInfo2 proposedRow:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationNone, @"should be none %i, %i", result, NSDragOperationNone);
    		
    	[viewController setFilterType: @"Inputs"];
    	[secondViewController setFilterType: @"Nodes"];
    	// -- fail
    	result = [secondViewController _validateDifferentTableDrop:dropInfo2 proposedRow:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationNone, @"should be none %i, %i", result, NSDragOperationNone);
    
    	[viewController setFilterType: @"Outputs"];
    	[secondViewController setFilterType: @"Connectors"];
    	// -- fail
    	result = [secondViewController _validateDifferentTableDrop:dropInfo2 proposedRow:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationNone, @"should be none %i, %i", result, NSDragOperationNone);	
    	[viewController setFilterType: @"Outputs"];
    	
    	[secondViewController setFilterType: @"Inputs"];
    	// -- fail
    	result = [secondViewController _validateDifferentTableDrop:dropInfo2 proposedRow:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationNone, @"should be none %i, %i", result, NSDragOperationNone);
    
    	[viewController setFilterType: @"Outputs"];
    	[secondViewController setFilterType: @"Nodes"];
    	// -- fail
    	result = [secondViewController _validateDifferentTableDrop:dropInfo2 proposedRow:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationNone, @"should be none %i, %i", result, NSDragOperationNone);
    
    	[viewController setFilterType: @"All"];
    	[secondViewController setFilterType: @"Connectors"];
    	// -- fail
    	result = [secondViewController _validateDifferentTableDrop:dropInfo2 proposedRow:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationNone, @"should be none %i, %i", result, NSDragOperationNone);
    		
    	[viewController setFilterType: @"Outputs"];
    	[secondViewController setFilterType: @"Outputs"];
    	// -- copy
    	result = [secondViewController _validateDifferentTableDrop:dropInfo2 proposedRow:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationCopy, @"should be none %i, %i", result, NSDragOperationCopy);
    	
    	[viewController setFilterType: @"Nodes"];
    	[secondViewController setFilterType: @"Nodes"];
    	// -- copy
    	result = [secondViewController _validateDifferentTableDrop:dropInfo2 proposedRow:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationCopy, @"should be none %i, %i", result, NSDragOperationCopy);
    	
    	[viewController setFilterType: @"Inputs"];
    	[secondViewController setFilterType: @"Inputs"];
    	// -- copy
    	result = [secondViewController _validateDifferentTableDrop:dropInfo2 proposedRow:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationCopy, @"should be none %i, %i", result, NSDragOperationCopy);
    	
    	[viewController setFilterType: @"Nodes"];
    	[secondViewController setFilterType: @"All"];
    	// -- copy
    	result = [secondViewController _validateDifferentTableDrop:dropInfo2 proposedRow:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationCopy, @"should be none %i, %i", result, NSDragOperationCopy);
    	result = [secondViewController _validateDifferentTableDrop:dropInfo2 proposedRow:7 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationNone, @"should be none %i, %i", result, NSDragOperationNone);
    	
    	[viewController setFilterType: @"Inputs"];
    	[secondViewController setFilterType: @"All"];
    	// -- copy
    	result = [secondViewController _validateDifferentTableDrop:dropInfo2 proposedRow:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationCopy, @"should be none %i, %i", result, NSDragOperationCopy);
    	result = [secondViewController _validateDifferentTableDrop:dropInfo2 proposedRow:0 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationNone, @"should be none %i, %i", result, NSDragOperationNone);
    	result = [secondViewController _validateDifferentTableDrop:dropInfo2 proposedRow:11 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationNone, @"should be none %i, %i", result, NSDragOperationNone);
    	
    	[viewController setFilterType: @"Outputs"];
    	[secondViewController setFilterType: @"All"];
    	// -- copy
    	result = [secondViewController _validateDifferentTableDrop:dropInfo2 proposedRow:6 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationCopy, @"should be none %i, %i", result, NSDragOperationCopy);
    	result = [secondViewController _validateDifferentTableDrop:dropInfo2 proposedRow:0 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationNone, @"should be none %i, %i", result, NSDragOperationNone);
    	result = [secondViewController _validateDifferentTableDrop:dropInfo2 proposedRow:11 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationNone, @"should be none %i, %i", result, NSDragOperationNone);
    	
    	[viewController setFilterType: @"All"];
    	[secondViewController setFilterType: @"Inputs"];
    	// -- copy if source is inputs
    	result = [secondViewController _validateDifferentTableDrop:dropInfo2 proposedRow:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationNone, @"should be none %i, %i", result, NSDragOperationNone);	
        data = [NSKeyedArchiver archivedDataWithRootObject:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(3, 3)]];
        [pb setData:data forType:MyTableViewDataType];
    	result = [secondViewController _validateDifferentTableDrop:dropInfo2 proposedRow:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationCopy, @"should be none %i, %i", result, NSDragOperationCopy);
    	
    	[viewController setFilterType: @"All"];
    	[secondViewController setFilterType: @"Outputs"];
    	// -- copy if src is outputs
    	result = [secondViewController _validateDifferentTableDrop:dropInfo2 proposedRow:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationNone, @"should be none %i, %i", result, NSDragOperationNone);	
        data = [NSKeyedArchiver archivedDataWithRootObject:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(6, 3)]];
        [pb setData:data forType:MyTableViewDataType];
    	result = [secondViewController _validateDifferentTableDrop:dropInfo2 proposedRow:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationCopy, @"should be none %i, %i", result, NSDragOperationCopy);
    	
    	[viewController setFilterType: @"All"];
    	[secondViewController setFilterType: @"Nodes"];
    	// -- copy if src is nodes
    	result = [secondViewController _validateDifferentTableDrop:dropInfo2 proposedRow:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationNone, @"should be none %i, %i", result, NSDragOperationNone);	
        data = [NSKeyedArchiver archivedDataWithRootObject:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)]];
        [pb setData:data forType:MyTableViewDataType];
    	result = [secondViewController _validateDifferentTableDrop:dropInfo2 proposedRow:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationCopy, @"should be none %i, %i", result, NSDragOperationCopy);
    	
    	[viewController setFilterType: @"All"];
    	[secondViewController setFilterType: @"All"];
    	// -- copy any combination of inputs, outputs and nodes. If we have inputs and outputs we also need to copy any connectors between them
    	NSMutableIndexSet *mis = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)];
    	[mis addIndex:3];
    	[mis addIndex:6];
    	[mis addIndex:9];
        data = [NSKeyedArchiver archivedDataWithRootObject:mis];
        [pb setData:data forType:MyTableViewDataType];
    	result = [secondViewController _validateDifferentTableDrop:dropInfo2 proposedRow:3 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationNone, @"should be none %i, %i", result, NSDragOperationNone);
}

- (void)testValidateFileDrop {
    
    	NSTableView *tv = (NSTableView *)viewController.displayedNodesTableView;
    	NSPasteboard *pb = [NSPasteboard generalPasteboard];
    	
    	// we can drop files - try a jpeg - should fail
    	id dropInfo = [OCMockObject mockForClass:NSClassFromString(@"NSDragDestination")];
    	[[[dropInfo stub] andReturnValue:OCMOCK_VALUE(pb)] draggingPasteboard];
    	[[dropInfo stub] draggingSource];
    	
    	[pb declareTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil] owner:self];
    	
    	// we need a valid file at our mockpath
    	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
    	NSString *mockPath = [[paths objectAtIndex: 0] stringByAppendingPathComponent:  @"aFile.jpg"];
    	[[NSString stringWithString:@"mock file contents!"] writeToFile:mockPath atomically:YES];
    	
        NSArray *fileNameList = [NSArray arrayWithObject:mockPath];
        [pb setPropertyList:fileNameList forType:NSFilenamesPboardType];
    	
    	[viewController setFilterType: @"Nodes"];
    	NSDragOperation result = [viewController tableView:tv validateDrop:dropInfo proposedRow:1 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationNone, @"should be none %i, %i", result, NSDragOperationNone);
    	[viewController setFilterType: @"All"];
    	result = [viewController tableView:tv validateDrop:dropInfo proposedRow:1 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationNone, @"should be none %i, %i", result, NSDragOperationNone);	
    	
    	NSFileManager* fileManager = [NSFileManager defaultManager];
        result = [fileManager removeFileAtPath:mockPath handler:nil];
    	
    	// now try fscript - should pass
    	[pb declareTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil] owner:self];
    	mockPath = [[paths objectAtIndex: 0] stringByAppendingPathComponent:  @"aFile.fscript"];
    	[[NSString stringWithString:@"mock file contents!"] writeToFile:mockPath atomically:YES];
    
        [pb setPropertyList:[NSArray arrayWithObject:mockPath] forType:NSFilenamesPboardType];
    	result = [viewController tableView:tv validateDrop:dropInfo proposedRow:1 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationCopy, @"should be none %i, %i", result, NSDragOperationCopy);	
    	[viewController setFilterType: @"All"];
    	result = [viewController tableView:tv validateDrop:dropInfo proposedRow:1 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationCopy, @"should be none %i, %i", result, NSDragOperationCopy);	
    
    	// but should fail when not in mode all or node
    	[viewController setFilterType: @"Inputs"];
    	result = [viewController tableView:tv validateDrop:dropInfo proposedRow:1 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationNone, @"should be none %i, %i", result, NSDragOperationNone);	
    	[viewController setFilterType: @"Outputs"];
    	result = [viewController tableView:tv validateDrop:dropInfo proposedRow:1 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationNone, @"should be none %i, %i", result, NSDragOperationNone);	
    	[viewController setFilterType: @"Connectors"];
    	result = [viewController tableView:tv validateDrop:dropInfo proposedRow:1 proposedDropOperation: NSTableViewDropAbove ];
    	STAssertTrue(result==NSDragOperationNone, @"should be none %i, %i", result, NSDragOperationNone);
    	
    	result = [fileManager removeFileAtPath:mockPath handler:nil];
}


static BOOL _selectionDiDChangeKVO = NO;
static int _selectionDidChangeCount = 0;

- (void)testSelectionBindingWorks {
    
    [viewController addObserver:self forKeyPath:@"currentNodeGroup.nodesInside.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];

    NSTableView *tv = (NSTableView *)viewController.displayedNodesTableView;
    [tv selectRowIndexes:[NSIndexSet indexSetWithIndex:1] byExtendingSelection:YES];
    //[[viewController currentNodeGroup] clearRecordedHits];
    _selectionDiDChangeKVO = NO;
    _selectionDidChangeCount = 0;
    [[viewController currentNodeGroup] clearSelectionNoUndo];
    // NSMutableArray *actualRecordings2 = [[viewController currentNodeGroup]  recordedSelectorStrings];
    // STAssertTrue([actualRecordings2 containsObject:@"select"], @"Fuck");
    STAssertTrue(_selectionDiDChangeKVO, @"what happened to KVO notification of selection change?");
    STAssertTrue(_selectionDidChangeCount==1, @"what happened to KVO notification of selection change? %i", _selectionDidChangeCount);
    
    [viewController removeObserver:self forKeyPath:@"currentNodeGroup.nodesInside.selection"];	
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentNodeGroup.nodesInside.selection"]) {
            _selectionDiDChangeKVO = YES;
            _selectionDidChangeCount++;
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];      
    }
}

@end
