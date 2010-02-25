//
//  BlakeGlobalCommandControllerTests.m
//  BlakeLoader
//
//  Created by steve hooley on 03/01/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "BlakeGlobalCommandController.h"
#import "BlakeDocumentController.h"
#import "BlakeDocument.h"
#import "HighLevelBlakeDocumentActions.h"
#import "StubWindow.h"
#import "StubView.h"


@interface BlakeGlobalCommandControllerTests : SenTestCase {
	
	BlakeGlobalCommandController	*_gcc;
	Class							_customDocClassForTests;
	
	/* a stub window - not a real document */
	StubWindow						*_stubWindow;
	StubView						*_stubView;
	
	/* Experimental ArrayController binding tests */
//	SHNode							*testSHNode;
}

// @property (assign, nonatomic) SHNode *testSHNode;

@end


@implementation BlakeGlobalCommandControllerTests

// @synthesize testSHNode;

- (void)setUp {

//	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0]];

	/* The real globalCommandController is the application delegate - Tests are run after this is set up if we are inject tests into the app - if tests are run in otest we must make it manually. If only we could settle on a way… */
	[BlakeGlobalCommandController sharedGlobalCommandController];
	
	_gcc = [[NSApplication sharedApplication] delegate];
	STAssertNotNil(_gcc, @"failed to make BlakeGlobalCommandController");
	STAssertTrue([_gcc isKindOfClass:[BlakeGlobalCommandController class]], @"wrong object is app delegate");

	BlakeDocumentController *dc = [BlakeDocumentController sharedDocumentController];
	_customDocClassForTests = NSClassFromString(@"MockSHDocument");

	//- make sure all docs are closed.. clear away unsaved changes first..
//	NSArray *allCurrentDocs = [[[dc documents] copy] autorelease];
//	for( NSDocument *doc in allCurrentDocs)
//		[doc updateChangeCount: NSChangeCleared];
//	[dc closeAll];
	NSArray *allDocs = [dc documents];
	STAssertTrue(0==[allDocs count], @"mm %i", [allDocs count]);
	
	NSRect stubFrame = NSMakeRect(50, 50, 200, 200);
	_stubWindow = [[StubWindow alloc] initWithContentRect:stubFrame styleMask:NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask backing:NSBackingStoreBuffered defer:NO];
	
	// try to force it not to cache the window so we can tell if we cleaned up correctly. Windows are released onClose Panels are not!
	[_stubWindow setOneShot:YES];
	[_stubWindow setReleasedWhenClosed:YES];
	
	_stubView = [[[StubView alloc] initWithFrame:stubFrame] autorelease];
	[[_stubWindow contentView] addSubview:_stubView];
	[_stubWindow makeKeyAndOrderFront:self];
	NSWindow *mainWindow = [NSApp myMainWindow];
	STAssertEqualObjects(_stubWindow, mainWindow, @"_stubWindow needs to be the main window for the tests to work");

	[_stubWindow makeFirstResponder:_stubView];
}

- (void)tearDown {

	NSArray *allCurrentDocs = [[[[BlakeDocumentController sharedDocumentController] documents] copy] autorelease];
	for( NSDocument *doc2 in allCurrentDocs )
		[doc2 updateChangeCount:NSChangeCleared];
		
	//- make sure all docs are closed..
	[[BlakeDocumentController sharedDocumentController] closeAll];
	NSArray* allDocs = [[BlakeDocumentController sharedDocumentController] documents];
	STAssertTrue([allDocs count]==0, @"mm %i", [allDocs count]);
	
	[BlakeGlobalCommandController cleanUpSharedGlobalCommandController];
//	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.3]];
}

for each menu action validate that BlakeGlobalCommandController is a valid target

test what the target each for each menu action

- (void)testValidateUserInterfaceItem {
	//	// - (BOOL)validateUserInterfaceItem:(id<NSValidatedUserInterfaceItem>)anItem
	//
	//    NSMenu* mainMenu = [NSApp mainMenu];
	//    NSMenu* fileMenu = [[mainMenu itemWithTitle:@"File"] submenu];
	//    id<NSValidatedUserInterfaceItem> newMenuItem =  [fileMenu itemWithTitle:@"New"];
	////	[newMenuItem setAction:@selector(newDocument:)];
	//	
	//    id<NSValidatedUserInterfaceItem> openMenuItem =  [fileMenu itemWithTitle:@"Open…"];
	////	[openMenuItem setAction:@selector(openDocument:)];
	//
	//    NSMenuItem <NSValidatedUserInterfaceItem> * closeMenuItem =  [fileMenu itemWithTitle:@"Close"];
	//	[closeMenuItem setAction:@selector(closeDocument:)];
	//
	//	[_gcc newDocument:self];
	//	NSArray* allDocs = [[BlakeDocumentController sharedDocumentController] documents];
	//	STAssertTrue([allDocs count]==1, @"if we have a doc then close should be enabled");
	//
	//	// NSAssert([allDocs containsObject:aDoc], @"Trying to close a doc we are not managing");
	//	
	//	BOOL canNew = [_gcc validateUserInterfaceItem: newMenuItem];
	//	STAssertTrue(canNew, @"if we have a doc then close should be enabled");
	//	
	//	BOOL canOpen = [_gcc validateUserInterfaceItem: openMenuItem];
	//	STAssertTrue(canOpen, @"if we have a doc then close should be enabled");
	//	
	//	BOOL canClose = [_gcc validateUserInterfaceItem: closeMenuItem];
	//	STAssertTrue(canClose, @"if we have a doc then close should be enabled");
	//		
	//	[_gcc closeDocument: self];
}

#pragma mark File Menu methods
//- (void)testNewDocument {
//// - (IBAction)newDocument:(id)sender;
//
//	BlakeDocumentController* shc = [BlakeDocumentController sharedDocumentController];
//	NSArray* allDocs;
//	
//	[_gcc newDocument:self];
//	allDocs = [shc documents];
//	STAssertTrue([allDocs count]==1, @"mm %i", [allDocs count]);
//	[_gcc newDocument:self];
//	allDocs = [shc documents];
//	STAssertTrue([allDocs count]==2, @"mm %i", [allDocs count]);
//}

/*	Cant get these tests to work when we build the tests - they work when we run the app 
 	However, i cant cope with that so i am disabling them */
//- (void)testCloseDocument {
//	// - (IBAction)closeDocument:(id)sender;
//	
//	BlakeDocumentController* shc = [BlakeDocumentController sharedDocumentController];
//	shc.customDocClass = _customDocClassForTests;
//	STAssertNotNil(shc, @"didnt we just make a documentController?");
//	
//	BlakeDocument *cd1 = [shc currentDocument];
//	STAssertNil(cd1, @"we should not have a current document here");
//	[_gcc newDocument:self];
////	int i=0;
////	while(i<1000000){
////	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
////		i++;
////	}
////	BlakeDocument *cd2 = [shc currentDocument];
////	STAssertNotNil(cd2, @"didnt we just make a document?");
//	
//	NSArray* openDocs = [( *)[SHApplication sharedApplication] openDocs];
//	STAssertTrue([openDocs count]==1, @"eek");
//	BlakeDocument *lastOb = [openDocs lastObject];
//	id winController = [[lastOb windowControllers] lastObject];
//	NSWindow *currentWin = [winController window];
//	STAssertNotNil(currentWin, @"we should not have a current window here");
//	STAssertTrue(cd1!=lastOb, @"eek");
//	
//	//- close 1 doc
//	NSArray* allDocs = [[BlakeDocumentController sharedDocumentController] documents];
//	STAssertTrue([allDocs count]==1, @"mm %i", [allDocs count]);
//	[_gcc closeDocument: self];
//	allDocs = [shc documents];
//// 	STAssertTrue([allDocs count]==0, @"mm %i", [allDocs count]);	
//}


//- (void)testApplicationOpenFile {
//// - (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename
//
//	/* drop a file on the dock icon to open it - need a dummy file */
//	NSBundle* thisTestBundle = [NSBundle bundleForClass:[self class]];
//	NSString *mockFilePath = [thisTestBundle pathForResource:@"MockFile" ofType:documentExtension];
//	STAssertNotNil(mockFilePath, @"Mock file missing");
//	BOOL result = [_gcc application:[NSApplication sharedApplication] openFile:mockFilePath];
//	STAssertTrue(result, @"cant open mock file");
//}

//- (void)testApplicationOpenFiles {
//// - (void)application:(NSApplication *)sender openFiles:(NSArray *)filenames;
////	STFail(@"Not done yet");
//}

#pragma mark Edit Menu methods
//- (void)testUndo {
////- (IBAction)undo:(id)sender 
//	STFail(@"Not done yet");
//}

//- (void)testUndoManager {
////- (NSUndoManager *)undoManager
//	STAssertThrows( [_gcc undoManager], @"what are we usig this undo manager for?" );
//}

//- (void)testRedo {
////- (IBAction)redo:(id)sender
//	STFail(@"Not done yet");
//}

- (void)tesCanCut {
		// - (BOOL)canCut
}

- (void)testCut {
	////- (IBAction)cut:(id)sender
	//	STFail(@"Not done yet");
}

- (void)tesCanCopy {
		// - (BOOL)canCopy
}

- (void)testCopy {
	////- (IBAction)copy:(id)sender
	//	STFail(@"Not done yet");
	
		#warning test that we copy a string that can be pasted into a text editor?
}

- (void)tesCanPaste {
		// - (BOOL)canPaste 
		
		#warning test that we can paste a string of fscript from another app
}

- (void)testPaste {
	////- (IBAction)paste:(id)sender 
	//	STFail(@"Not done yet");
}

//- (void)testCanDelete {
////- (BOOL)canDelete 
//
//	BOOL result = [_gcc canDelete];
//	STAssertFalse(result, @"How can we delete when we dont have a doc?");
//	[_gcc newDocument:self];
//	result = [_gcc canDelete];
//	STAssertFalse(result, @"How can we delete when we dont have a selection");
//	
//	[_gcc addNewEmptyGroup:self];
//	result = [_gcc canDelete];
//	STAssertTrue(result, @"a new group should be selected");
//	//NB - clean the doc so it will close
//	BlakeDocumentController *dc = [BlakeDocumentController sharedDocumentController];
//	[[dc frontDocument] updateChangeCount:  NSChangeCleared];
//}

- (void)testDelete {
	////- (IBAction)delete:(id)sender 
	//	STFail(@"Not done yet");
}

- (void)testCanSelectAllChildren {
	// - (BOOL)canSelectAllChildren
	
	BOOL result = [_gcc canSelectAllChildren];
	STAssertTrue(result==YES, @"it should have travelled up the responder chain till it found this");
}

- (void)testCanDeSelectAllChildren {
	//- (BOOL)canDeSelectAllChildren
	
	BOOL result = [_gcc canDeSelectAllChildren];
	STAssertTrue(result==YES, @"it should have travelled up the responder chain till it found this");
}


/* What does 'All' children mean? All visible in current editor? */
/* we will get the frontestMostMainWindow and send selectAll to the responder chain */
//- (void)testSelectAllChildren {
////- (IBAction)selectAllChildren:(id)sender
//
//	STFail(@"Not done yet");
//
////	BlakeDocumentController *dc = [BlakeDocumentController sharedDocumentController];
////	[_gcc newDocument:self];
////	BlakeDocument *doc = [dc frontDocument];
////	NSArray *allChildren1 = [doc.nodeGraphModel allChildrenFromCurrentNode];
////	[_gcc addNewEmptyGroup:self];
////	[_gcc addNewEmptyGroup:self];
////	[_gcc addNewEmptyGroup:self];
////	[doc deSelectAllChildrenInCurrentNode];
////	[_gcc selectAllChildren:self];
////	NSArray *allChildren2 = [doc.nodeGraphModel allSelectedChildrenFromCurrentNode];
////	STAssertTrue([allChildren2 count]==[allChildren1 count]+3, @"did we select all? %i", [allChildren2 count]);
////	
////	//NB - clean the doc so it will close
////	[[dc frontDocument] updateChangeCount:  NSChangeCleared];
//
//}

//- (void)testSeSelectAllChildren {
//// - (IBAction)deSelectAllChildren:(id)sender;
//	STFail(@"Not done yet");
//}

- (void)testDuplicate {
	//- (IBAction)duplicate:(id)sender 
	//	STFail(@"Not done yet");
}

#pragma mark Graph Menu methods
//- (void)testCanMoveUpToParent {
////- (BOOL)canMoveUpToParent
//
//	[_gcc newDocument:self];
//	[_gcc addNewEmptyGroup:self];
//	BOOL result = [_gcc canMoveUpToParent];
//	STAssertFalse(result, @"How can we canMoveUpToParent when we dont have a selection");
//	[_gcc moveDownToChild:self];
//	result = [_gcc canMoveUpToParent];
//	STAssertTrue(result, @"How can we canMoveDownToChild when we dont have a selection");
//
//	//NB - clean the doc so it will close
//	BlakeDocumentController *dc = [BlakeDocumentController sharedDocumentController];
//	[[dc frontDocument] updateChangeCount:  NSChangeCleared];
//}

//- (void)testMoveUpToParent {
////- (IBAction)moveUpToParent:(id)sender 
//
//	STFail(@"Not done yet");
//}

//- (void)testCanMoveDownToChild {
////- (BOOL)canMoveDownToChild
//
//	BOOL result = [_gcc canMoveDownToChild];
//	STAssertFalse(result, @"How can we canMoveDownToChild when we dont have a doc?");
//	[_gcc newDocument:self];
//	result = [_gcc canMoveDownToChild];
//	STAssertFalse(result, @"How can we canMoveDownToChild when we dont have a selection");
//	
//	[_gcc addNewEmptyGroup:self];
//	result = [_gcc canMoveDownToChild];
//	STAssertTrue(result, @"How can we canMoveDownToChild when we dont have a selection");
//	[_gcc addNewEmptyGroup:self];
//	result = [_gcc canMoveDownToChild];
//	STAssertTrue(result, @"How can we canMoveDownToChild when we dont have a selection");
//
//	//NB - clean the doc so it will close
//	BlakeDocumentController *dc = [BlakeDocumentController sharedDocumentController];
//	[[dc frontDocument] updateChangeCount:  NSChangeCleared];
//}

//- (void)testMoveDownToChild {
////- (IBAction)moveDownToChild:(id)sender
//	STFail(@"Not done yet");
//}

- (void)testCanAddNewEmptyGroup {
	//- (BOOL)canAddNewEmptyGroup

	BOOL result = [_gcc canAddNewEmptyGroup];
	STAssertFalse(result, @"How can we add a new group when we dont have a doc?");

	[_gcc newDocument:self];
	result = [_gcc canAddNewEmptyGroup];
	STAssertTrue(result, @"we should be able to");
		
	// Not really a thoro test - there are other conditions that we cannot add a new group
	// but this is covering the basics for now
}

- (void)testNewEmptyGroup {
	//- (IBAction)newEmptyGroup:(id)sender
	
	BlakeDocumentController *dc = [BlakeDocumentController sharedDocumentController];
	[_gcc newDocument:self];
	BlakeDocument *doc = (BlakeDocument *)[dc frontDocument];
	int count1 = [doc.nodeGraphModel.currentNodeGroup countOfChildren];
	[_gcc newEmptyGroup:self];
	int count2 = [doc.nodeGraphModel.currentNodeGroup countOfChildren];
	STAssertTrue(count2==count1+1, @"did we add an empty group?", count2, count1);
	
	//NB - clean the doc so it will close
	[doc updateChangeCount:  NSChangeCleared];
}

- (void)testAddNewInput {
	//- (IBAction)addNewInput:(id)sender

	OCMockObject *mocDocController = MOCK(BlakeDocumentController);
	OCMockObject *mockDoc = MOCK(BlakeDocument);
	
	[[[mocDocController expect] andReturn:mockDoc] frontDocument];
	[[mockDoc expect] makeInputInCurrentNodeWithType:@"mockDataType"];

	SwappedInIvar *swappedIn = [SwappedInIvar swapFor:_gcc :"_documentController" :mocDocController];
	[_gcc addNewInput:self];
	[swappedIn putBackOriginal];

	[mocDocController verify];
	[mockDoc verify];
}

- (void)testAddNewOutput {
	// - (IBAction)addNewOutput:(id)sender
	
	OCMockObject *mocDocController = MOCK(BlakeDocumentController);
	OCMockObject *mockDoc = MOCK(BlakeDocument);
	
	[[[mocDocController expect] andReturn:mockDoc] frontDocument];
	[[mockDoc expect] makeOutputInCurrentNodeWithType:@"mockDataType"];
	
	SwappedInIvar *swappedIn = [SwappedInIvar swapFor:_gcc :"_documentController" :mocDocController];
	[_gcc addNewOutput:self];
	[swappedIn putBackOriginal];
	
	[mocDocController verify];
	[mockDoc verify];
}

- (void)testCanGroup {
	//- (BOOL)canGroup 
	
	BlakeDocumentController *dc = [BlakeDocumentController sharedDocumentController];
	[_gcc newDocument:self];
	BlakeDocument *doc = (BlakeDocument *)[dc frontDocument];
	[[doc.nodeGraphModel currentNodeGroup] unSelectAllChildren];

	// we must have a selection
	STAssertFalse([_gcc canGroup], @"Need a Valid selection before we can group");
	[[doc.nodeGraphModel currentNodeGroup] selectAllChildren];
	STAssertTrue([_gcc canGroup], @"Need a Valid selection before we can group");
}

- (void)testGroup {
	//- (IBAction)group:(id)sender
	
	//boogaloo	BlakeDocumentController *dc = [BlakeDocumentController sharedDocumentController];
	//boogaloo	[_gcc newDocument:self];
	//boogaloo	BlakeDocument *doc = [dc frontDocument];
	//boogaloo	NSUndoManager *um = [doc undoManager];
	//boogaloo	SHNode* root = [[doc nodeGraphModel] rootNodeGroup];
	//boogaloo	[doc selectAllChildrenInCurrentNode];
	//boogaloo	[doc deleteSelectedChildrenFromCurrentNode];
		
	//boogaloo	SHNode* newNode1 = [doc makeEmptyGroupInCurrentNodeWithName:@"jaja1"];
	//boogaloo//boogaloo	SHNode* newNode2 = [doc makeEmptyGroupInCurrentNodeWithName:@"jaja2"];
	
	//later	[doc makeInputInCurrentNodeWithType:@"mockDataType"];
	//later	[doc makeInputInCurrentNodeWithType:@"mockDataType"];
	//later	[doc makeOutputInCurrentNodeWithType:@"mockDataType"];
	//later	[doc makeOutputInCurrentNodeWithType:@"mockDataType"];
	
	//boogaloo	NSArray *inputs = [[root inputs] array];
	//boogaloo	NSArray *outputs = [[root outputs] array];
	//boogaloo	SHInputAttribute *in1 =  [inputs objectAtIndex:0];
	//boogaloo	SHInputAttribute *in2 =  [inputs objectAtIndex:1];
	//boogaloo	SHOutputAttribute *out1 =  [outputs objectAtIndex:0];
	//boogaloo	SHOutputAttribute *out2 =  [outputs objectAtIndex:1];
		
	//later	[doc connectOutletOfInput:in1 toInletOfOutput:in2];
	//later	SHInterConnector *originalIC1 = [[[root shInterConnectorsInside] array] objectAtIndex:0];
	//later	SHConnectlet *inCon1 = [originalIC1 inSHConnectlet];
	//later	SHConnectlet *outCon1 = [originalIC1 outSHConnectlet];
		
	//later	[doc connectOutletOfInput:in2 toInletOfOutput:out1];
	//later	SHInterConnector *originalIC2 = [[[root shInterConnectorsInside] array] objectAtIndex:1];
	//later	SHConnectlet *inCon2 = [originalIC2 inSHConnectlet];
	//later	SHConnectlet *outCon2 = [originalIC2 outSHConnectlet];
		
	//later	[doc connectOutletOfInput:out1 toInletOfOutput:out2];
	//later	SHInterConnector *originalIC3 = [[[root shInterConnectorsInside] array] objectAtIndex:2];
	//later	SHConnectlet *inCon3 = [originalIC3 inSHConnectlet];
	//later	SHConnectlet *outCon3 = [originalIC3 outSHConnectlet];
	//later	STAssertTrue(originalIC1!=originalIC2, @"wrong connectors");
	//later	STAssertTrue(originalIC1!=originalIC3, @"wrong connectors");
		
	//boogaloo	SHNode *currentNodeGroup = [doc.nodeGraphModel currentNodeGroup];
	//boogaloo	NSArray *nodes = [[root nodesInside] array];
	//later	NSArray *ics = [[root shInterConnectorsInside] array];
	//boogaloo	STAssertTrue([nodes count]==2, @"did we move the contents into a new node? %i", [nodes count]);
	//boogaloo	STAssertTrue([inputs count]==2, @"did we move the contents into a new node? %i", [inputs count]);
	//boogaloo	STAssertTrue([outputs count]==2, @"did we move the contents into a new node? %i", [outputs count]);
	//later	STAssertTrue([ics count]==3, @"did we move the contents into a new node? %i", [ics count]);
	//later	STAssertTrue([currentNodeGroup countOfChildren]==9, @"actually is %i", [currentNodeGroup countOfChildren]);
	
	//boogaloo	[doc deSelectAllChildrenInCurrentNode];
	//boogaloo	[currentNodeGroup addChildToSelection: newNode1];	
	//boogaloo	[currentNodeGroup addChildToSelection: newNode2];
	//boogaloo	[currentNodeGroup addChildToSelection: in2];
	//boogaloo	[currentNodeGroup addChildToSelection: out1];
		
		/* Do the group */
	//boogaloo	[um removeAllActions];
	//boogaloo	[um setGroupsByEvent:NO];
	//boogaloo	[um beginUndoGrouping];
	//boogaloo	[_gcc group:self];
	//boogaloo	[um endUndoGrouping];
		
	//later	STAssertTrue([currentNodeGroup countOfChildren]==5, @"actually is %i", [currentNodeGroup countOfChildren]);
	
		// now have 1 node, 1 input and 1 output in root
		// the input in root is connected to input in new Empty node
		// the output in new Empty is connected to output in root
	//boogaloo	nodes = [[root nodesInside] array];
	//boogaloo	inputs = [[root inputs] array];
	//boogaloo	outputs = [[root outputs] array];
	//later	ics = [[root shInterConnectorsInside] array];
	
	//boogaloo	STAssertTrue([nodes count]==1, @"did we move the contents into a new node? %i", [nodes count]);
	//boogaloo	STAssertTrue([inputs count]==1, @"did we move the contents into a new node? %i", [inputs count]);
	//boogaloo	STAssertTrue([outputs count]==1, @"did we move the contents into a new node? %i", [outputs count]);
		/* one connection should have been moved inside new group leaqving 2 here */
	//later	STAssertTrue([ics count]==2, @"did we move the contents into a new node? %i", [ics count]);
		//-- test each ics connectlets are the same way round
	//later	SHInterConnector *remainingIC1 = [ics objectAtIndex:0];
	//later	SHConnectlet *inCon = [remainingIC1 inSHConnectlet];
	//later	SHConnectlet *outCon = [remainingIC1 outSHConnectlet];
	//later	STAssertTrue(inCon==inCon1, @"Must have made a connection the wrong way round");
	//later	STAssertTrue(outCon==outCon1, @"Must have made a connection the wrong way round");
	
	//later	SHInterConnector *remainingIC2 = [ics objectAtIndex:1];
	//later	inCon = [remainingIC2 inSHConnectlet];
	//later	outCon = [remainingIC2 outSHConnectlet];
	//later	STAssertTrue(inCon==inCon3, @"Must have made a connection the wrong way round");
	//later	STAssertTrue(outCon==outCon3, @"Must have made a connection the wrong way round");
		
	//boogaloo	SHNode *newNode = [nodes objectAtIndex:0];
		
		// this contains newNode1 & newNode2
	//boogaloo	NSArray *deeperNodes = [[newNode nodesInside] array];
	//boogaloo	NSArray *deeperInputs = [[newNode inputs] array];
	//boogaloo	NSArray *deeperOutputs = [[newNode outputs] array];
	//later	NSArray *deeperOConnectors = [[newNode shInterConnectorsInside] array];
		
	//boogaloo	STAssertTrue([deeperNodes count]==2, @"did we move the contents into a new node? %i", [deeperNodes count]);
	//boogaloo	STAssertTrue([deeperNodes objectAtIndex:0]==newNode2, @"did we move the contents into a new node?");
	//boogaloo	STAssertTrue([deeperNodes objectAtIndex:1]==newNode1, @"did we move the contents into a new node?");
	
	//boogaloo	STAssertTrue([deeperInputs count]==1, @"did we move the contents into a new node? %i", [deeperInputs count]);
	//boogaloo	STAssertTrue([deeperOutputs count]==1, @"did we move the contents into a new node? %i", [deeperOutputs count]);
	//later	STAssertTrue([deeperOConnectors count]==1, @"did we move the contents into a new node? %i", [deeperOConnectors count]);
		// -- test that the ics connectlets are the right way round
	//later	SHInterConnector *deepIC = [deeperOConnectors objectAtIndex:0];
	//later	inCon = [deepIC inSHConnectlet];
	//later	outCon = [deepIC outSHConnectlet];
	//later	STAssertTrue(inCon==inCon2, @"Must have made a connection the wrong way round");
	//later	STAssertTrue(outCon==outCon2, @"Must have made a connection the wrong way round");
	
		//-- test undo & redo
	//boogaloo	[um undo];
		//-- it should be like the group never happened
	//boogaloo	SHNode *currentNodeGroup2 = [doc.nodeGraphModel currentNodeGroup];
	//boogaloo	STAssertTrue(currentNodeGroup2==currentNodeGroup, @"eh");
	
	//boogaloo	NSArray *nodes2 = [[root nodesInside] array];
	//boogaloo	NSArray *ics2 = [[root shInterConnectorsInside] array];
	//boogaloo	NSArray *inputs2 = [[root inputs] array];
	//boogaloo	NSArray *outputs2 = [[root outputs] array];
	//boogaloo	STAssertTrue([nodes2 count]==2, @"did we move the contents into a new node? %i", [nodes2 count]);
	//boogaloo	STAssertTrue([inputs2 count]==2, @"did we move the contents into a new node? %i", [inputs2 count]);
	//boogaloo	STAssertTrue([outputs2 count]==2, @"did we move the contents into a new node? %i", [outputs2 count]);
	//later		STAssertTrue([ics2 count]==3, @"did we move the contents into a new node? %i", [ics2 count]);
	//later		STAssertTrue([currentNodeGroup2 countOfChildren]==9, @"actually is %i", [currentNodeGroup2 countOfChildren]);
		
		
	//boogaloo	[um redo];
		//-- we should be the same as after grouping
	//later		STAssertTrue([currentNodeGroup countOfChildren]==5, @"actually is %i", [currentNodeGroup countOfChildren]);
	//boogaloo	NSArray *nodes4 = [[root nodesInside] array];
	//boogaloo	NSArray *inputs4 = [[root inputs] array];
	//boogaloo	NSArray *outputs4 = [[root outputs] array];
	//later		NSArray *ics4 = [[root shInterConnectorsInside] array];
	//boogaloo	STAssertTrue([nodes4 count]==1, @"did we move the contents into a new node? %i", [nodes4 count]);
	//boogaloo	STAssertTrue([inputs4 count]==1, @"did we move the contents into a new node? %i", [inputs4 count]);
	//boogaloo	STAssertTrue([outputs4 count]==1, @"did we move the contents into a new node? %i", [outputs4 count]);
		/* one connection should have been moved inside new group leaqving 2 here */
	//later		STAssertTrue([ics4 count]==2, @"did we move the contents into a new node? %i", [ics4 count]);
	
		
	//boogaloo	[um undo];
		//-- it should be like the group never happened
	//boogaloo	SHNode *currentNodeGroup3 = [doc.nodeGraphModel currentNodeGroup];
	//boogaloo	STAssertTrue(currentNodeGroup3==currentNodeGroup, @"eh");
	
	//boogaloo	NSArray *nodes3 = [[root nodesInside] array];
	//later		NSArray *ics3 = [[root shInterConnectorsInside] array];
	//boogaloo	NSArray *inputs3 = [[root inputs] array];
	//boogaloo	NSArray *outputs3 = [[root outputs] array];
	//boogaloo	STAssertTrue([nodes3 count]==2, @"did we move the contents into a new node? %i", [nodes3 count]);
	//boogaloo	STAssertTrue([inputs3 count]==2, @"did we move the contents into a new node? %i", [inputs3 count]);
	//boogaloo	STAssertTrue([outputs3 count]==2, @"did we move the contents into a new node? %i", [outputs3 count]);
	//later		STAssertTrue([ics3 count]==3, @"did we move the contents into a new node? %i", [ics3 count]);
	//later		STAssertTrue([currentNodeGroup3 countOfChildren]==9, @"actually is %i", [currentNodeGroup3 countOfChildren]);
		
	//boogaloo	[um setGroupsByEvent:YES];
	//boogaloo	[um removeAllActions];
}


- (void)testCanUnGroup {
	//- (BOOL)canUnGroup 
	
	BlakeDocumentController *dc = [BlakeDocumentController sharedDocumentController];
	[_gcc newDocument:self];
	BlakeDocument *doc = (BlakeDocument *)[dc frontDocument];
	SHNode* root = [[doc nodeGraphModel] rootNodeGroup];

	// cant ungroup the root node
	STAssertFalse([_gcc canUnGroup], @"Cant ungroup root");
	
	SHNode* newNode = [doc makeEmptyGroupInCurrentNodeWithName:@"jaja"];
	[doc.nodeGraphModel moveDownALevelIntoNodeGroup:newNode];
	STAssertFalse([_gcc canUnGroup], @"Cant ungroup empty selection");
	
	[doc.nodeGraphModel moveUpAlevelToParentNodeGroup];
	[root addChildToSelection:newNode];
	STAssertTrue([_gcc canUnGroup], @"This IS valid!");
}

- (void)testUnGroup {
	//- (IBAction)unGroup:(id)sender
	
	//boogaloo	BlakeDocumentController *dc = [BlakeDocumentController sharedDocumentController];
	//boogaloo	[_gcc newDocument:self];
	//boogaloo	BlakeDocument *doc = [dc frontDocument];
	//boogaloo	NSUndoManager *um = [doc undoManager];
	//boogaloo	SHNode* root = [[doc nodeGraphModel] rootNodeGroup];
	//boogaloo	[doc selectAllChildrenInCurrentNode];
	//boogaloo	[doc deleteSelectedChildrenFromCurrentNode];
	
	/* the node that we will attempt to un group */
	//boogaloo	SHNode* macroNode = [doc makeEmptyGroupInCurrentNodeWithName:@"myMacro"];
		
	//boogaloo	[doc makeInputInCurrentNodeWithType:@"mockDataType"];
	//boogaloo	[doc makeOutputInCurrentNodeWithType:@"mockDataType"];
		
	//boogaloo	[[doc nodeGraphModel] setCurrentNodeGroup:macroNode];
		
	//-- add some nodes inside
	//boogaloo	SHNode* deepNode1 = [doc makeEmptyGroupInCurrentNodeWithName:@"deepNode1"];
	//boogaloo	[doc makeInputInCurrentNodeWithType:@"mockDataType"];
	//boogaloo	[doc makeOutputInCurrentNodeWithType:@"mockDataType"];
		
		//-- get references to the children
	//boogaloo	NSArray *nodes = [[root nodesInside] array];
	//boogaloo	STAssertTrue([nodes count]==1, @"yay %i", [nodes count]);
	
	//boogaloo	NSArray *inputs = [[root inputs] array];
	//boogaloo	NSArray *outputs = [[root outputs] array];
	//boogaloo	STAssertTrue([inputs count]==1, @"yay %i", [inputs count]);
	//boogaloo	STAssertTrue([outputs count]==1, @"yay %i", [outputs count]);
	
	//boogaloo	NSArray *deeperNodes = [[macroNode nodesInside] array];
	//boogaloo	NSArray *deeperInputs = [[macroNode inputs] array];
	//boogaloo	NSArray *deeperOutputs = [[macroNode outputs] array];
	//boogaloo	STAssertTrue([deeperNodes count]==1, @"yay %i", [deeperNodes count]);
	//boogaloo	STAssertTrue([deeperInputs count]==1, @"yay %i", [deeperInputs count]);
	//boogaloo	STAssertTrue([deeperOutputs count]==1, @"yay %i", [deeperOutputs count]);
	
		//-- Make some connections 
		//-- add a connection inside
	//later	[doc connectOutletOfInput:[deeperInputs objectAtIndex:0] toInletOfOutput:[deeperOutputs objectAtIndex:0]];
	//later	SHInterConnector *deepIC1 = [[[macroNode shInterConnectorsInside] array] objectAtIndex:0];
	//later	SHConnectlet *inCon = [deepIC1 inSHConnectlet];
	//later	SHConnectlet *outCon = [deepIC1 outSHConnectlet];
		
		//-- add a couple of connections outside to inside
	//later	[doc connectOutletOfInput:[inputs objectAtIndex:0] toInletOfOutput:[deeperInputs objectAtIndex:0]];
	//later	[doc connectOutletOfInput:[deeperOutputs objectAtIndex:0] toInletOfOutput:[outputs objectAtIndex:0]];
	
	//later	NSArray *ics = [[root shInterConnectorsInside] array];
	//later	NSArray *deeperOConnectors = [[macroNode shInterConnectorsInside] array];	
	//later	STAssertTrue([ics count]==2, @"yay %i", [ics count]);
	//later	STAssertTrue([deeperOConnectors count]==1, @"yay %i", [deeperOConnectors count]);
		
	//boogaloo	[[doc nodeGraphModel] setCurrentNodeGroup:root];
	//boogaloo	[doc deSelectAllChildrenInCurrentNode];
	//boogaloo	[root addChildToSelection:macroNode];
		
		/* Do the ungroup */
	//boogaloo	[um removeAllActions];
	//boogaloo	[um setGroupsByEvent:NO];
	//boogaloo	[um beginUndoGrouping];
		//-- some connections not being made? Count em…
	//boogaloo	[_gcc unGroup:self];
	//boogaloo	[um endUndoGrouping];
	
	//boogaloo	nodes = [[root nodesInside] array];
	//boogaloo	STAssertTrue([nodes count]==1, @"yay %i", [nodes count]);
	//boogaloo	STAssertTrue([nodes objectAtIndex:0]==deepNode1, @"yay");
	
	//boogaloo	inputs = [[root inputs] array];
	//boogaloo	STAssertTrue([inputs count]==2, @"yay %i", [inputs count]);
	
	//boogaloo	outputs = [[root outputs] array];
	//boogaloo	STAssertTrue([outputs count]==2, @"yay %i", [outputs count]);
	
	//later		ics = [[root shInterConnectorsInside] array];
	//later		STAssertTrue([ics count]==3, @"yay %i", [ics count]);
		//-- check the connectOrder
		//SHInterConnector *shallowIC1 = [ics objectAtIndex:0];
		//SHInterConnector *shallowIC2 = [ics objectAtIndex:1];
	//later	SHInterConnector *shallowIC3 = [ics objectAtIndex:2];
		
		//SHConnectlet *inConCheck1 = [shallowIC1 inSHConnectlet];
		//SHConnectlet *outConCheck1 = [shallowIC1 outSHConnectlet];
		//SHConnectlet *inConCheck2 = [shallowIC2 inSHConnectlet];
		//SHConnectlet *outConCheck2 = [shallowIC2 outSHConnectlet];
	//later		SHConnectlet *inConCheck3 = [shallowIC3 inSHConnectlet];
	//later		SHConnectlet *outConCheck3 = [shallowIC3 outSHConnectlet];
		
	//later		STAssertTrue(inCon==inConCheck3, @"Must have made a connection the wrong way round");
	//later		STAssertTrue(outCon==outConCheck3, @"Must have made a connection the wrong way round");
	
		//-- test undo and redo
		
	//boogaloo	[um undo];
		//-- it should be like the ungroup never happened
	//boogaloo	NSArray *nodes2 = [[root nodesInside] array];
	//boogaloo	STAssertTrue([nodes2 count]==1, @"yay %i", [nodes2 count]);
	//boogaloo	NSArray *inputs2 = [[root inputs] array];
	//boogaloo	NSArray *outputs2 = [[root outputs] array];
	//boogaloo	STAssertTrue([inputs2 count]==1, @"yay %i", [inputs2 count]);
	//boogaloo	STAssertTrue([outputs2 count]==1, @"yay %i", [outputs2 count]);
	//boogaloo	STAssertTrue([nodes2 objectAtIndex:0]==macroNode, @"yay" );
	//boogaloo	SHNode* macroNode2 = [nodes2 objectAtIndex:0];
	//boogaloo	NSArray *deeperNodes2 = [[macroNode2 nodesInside] array];
	//boogaloo	NSArray *deeperInputs2 = [[macroNode2 inputs] array];
	//boogaloo	NSArray *deeperOutputs2 = [[macroNode2 outputs] array];
	//boogaloo	STAssertTrue([deeperNodes2 count]==1, @"yay %i", [deeperNodes2 count]);
	//boogaloo	STAssertTrue([deeperInputs2 count]==1, @"yay %i", [deeperInputs2 count]);
	//boogaloo	STAssertTrue([deeperOutputs2 count]==1, @"yay %i", [deeperOutputs2 count]);
	//later		NSArray *ics2 = [[root shInterConnectorsInside] array];
	//later		NSArray *deeperOConnectors2 = [[macroNode2 shInterConnectorsInside] array];	
	//later		STAssertTrue([ics2 count]==2, @"yay %i", [ics2 count]);
	//later		STAssertTrue([deeperOConnectors2 count]==1, @"yay %i", [deeperOConnectors2 count]);
		
	//boogaloo	[um redo];
		//-- we should be in the same state as ungrouping
	//boogaloo	NSArray *nodes3 = [[root nodesInside] array];
	//boogaloo	STAssertTrue([nodes3 count]==1, @"yay %i", [nodes3 count]);
	//boogaloo	STAssertTrue([nodes3 objectAtIndex:0]==deepNode1, @"yay");
	
	//boogaloo	NSArray *inputs3 = [[root inputs] array];
	//boogaloo	STAssertTrue([inputs3 count]==2, @"yay %i", [inputs3 count]);
	
	//boogaloo	NSArray *outputs3 = [[root outputs] array];
	//boogaloo	STAssertTrue([outputs3 count]==2, @"yay %i", [outputs3 count]);
	
	//later		NSArray *ics3 = [[root shInterConnectorsInside] array];
	//later		STAssertTrue([ics3 count]==3, @"yay %i", [ics3 count]);
		
		
	//boogaloo	[um undo];
		//-- it should be like the ungroup never happened
	//boogaloo	NSArray *nodes4 = [[root nodesInside] array];
	//boogaloo	STAssertTrue([nodes4 count]==1, @"yay %i", [nodes4 count]);
	//boogaloo	NSArray *inputs4 = [[root inputs] array];
	//boogaloo	NSArray *outputs4 = [[root outputs] array];
	//boogaloo	STAssertTrue([inputs4 count]==1, @"yay %i", [inputs4 count]);
	//boogaloo	STAssertTrue([outputs4 count]==1, @"yay %i", [outputs4 count]);
	//boogaloo	NSArray *deeperNodes4 = [[macroNode nodesInside] array];
	//boogaloo	NSArray *deeperInputs4 = [[macroNode inputs] array];
	//boogaloo	NSArray *deeperOutputs4 = [[macroNode outputs] array];
	//boogaloo	STAssertTrue([deeperNodes4 count]==1, @"yay %i", [deeperNodes4 count]);
	//boogaloo	STAssertTrue([deeperInputs4 count]==1, @"yay %i", [deeperInputs4 count]);
	//boogaloo	STAssertTrue([deeperOutputs4 count]==1, @"yay %i", [deeperOutputs4 count]);
		
	//boogaloo	[um setGroupsByEvent:YES];
	//boogaloo	[um removeAllActions];
}

- (void)testPasteboardHasData {
	//- (BOOL)pasteboardHasData
	//	STFail(@"Not done yet");
}


/* Just for fun.. what happens if we try to make a SHNode the dataSource for an arrayController ? */
//- (void)testMakeSHNodeAnArrayControllerDataSource {
//
//	[_gcc newDocument:self];
//	NSArray* allDocs = [[BlakeDocumentController sharedDocumentController] documents];
//	BlakeDocument *nweDoc = [allDocs lastObject];
//
//	SHNode* root = [[nweDoc nodeGraphModel] rootNodeGroup];
//	SHNode* node1 = [SHNode newNode];
//	SHNode* node2 = [SHNode newNode];
//	SHNode* node3 = [SHNode newNode];
//	SHNode* node4 = [SHNode newNode];
//	[root NEW_addChild:node1 autoRename:YES];
//	[root NEW_addChild:node2 autoRename:YES];
//	[node2 NEW_addChild:node3 autoRename:YES];
//	[node3 NEW_addChild:node4 autoRename:YES];
//	
//	NSArrayController *testArrayController = [[[NSArrayController alloc] init] autorelease];
//	[testArrayController bind:NSContentArrayBinding toObject:self withKeyPath:@"testSHNode" options:nil];
//	
//	id nodeMock = [OCMockObject mockForClass:[SHNode class]];
//	[[nodeMock stub] isNSString__];
//	[[nodeMock stub] respondsToSelector:OCMOCK_ANY];
//	BOOL expectedValue = YES;
//	int returnCount = 7;
////	[[[nodeMock stub] andReturnValue:OCMOCK_VALUE(expectedValue)] isKindOfClass:OCMOCK_ANY]; - (void)getObjects:(id *)objects; - (void)getObjects:(id *)objects range:(NSRange)range;
//	[[nodeMock stub] count];
//
//	self.testSHNode = nodeMock;
//
//	NSArray *arrangedObjects = [testArrayController arrangedObjects]; 
//	NSLog(@"arrangedObjects %@", arrangedObjects);
//}
@end
