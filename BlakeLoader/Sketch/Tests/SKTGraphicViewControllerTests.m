//
//  SKTGraphicViewControllerTests.m
//  BlakeLoader
//
//  Created by steve hooley on 26/05/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "SKTGraphicViewControllerTests.h"
#import "SKTGraphicViewController.h"
#import "SKTGraphicViewModel.h"
#import "SKTCircle.h"

#import "SKTGraphicView.h"
#import "StubSketchDoc.h"
#import "SKTWindowController.h"
#import "SKTDragReorderArrayController.h"


@interface SKTGraphicViewControllerTests : SenTestCase {
	
	StubSketchDoc				*_doc;
	SKTWindowController			*_sketchWindowController;
	SKTGraphicViewController	*_skViewControl;
}

@implementation SKTGraphicViewControllerTests

/*
 * IF YOU MAKE AND DESTROY A VIEW CONTROLLER WITHOUT SETTING A DOCUMENT IT WILL CRASH
*/

// -- the control has a model and a view.
// -- control signs up for drawable content from the model

// -- if you were scripting i would want to say something like
// -- blake.setDoc "doc1"
// -- blake.viewController "sketch".addRulers
// -- blake.viewController "sketch".selectItemAt( 10, 10 )

// -- the view wouldn't have to be visible


- (void)setUp {
	
	/* 
		I am just instiating the whole fucking nib to make an instance of SKTGraphicViewController - NB you need to have a documentController and document in place for this to work
		I tried testing SKTGraphicViewController separetly from it's dependencies using mocks and stuff but it was too difficult and at the end of the
		day i need to test that the nib is unarchived correctly anyway - ok, i know that doesnt justify unarchiving the nib for every test but i've had enough of OCMock…
	 */
	 
	NSError *err;
	id docController = [SHDocumentController sharedDocumentController];
	[docController setDocClass:[StubSketchDoc class] forDocType:@"sketch"];
	_doc = [[docController makeUntitledDocumentOfType:@"sketch" error:&err] retain];
	SHNodeGraphModel *sModel = [[[SHNodeGraphModel alloc] init] autorelease];
	[_doc setNodeGraphModel: sModel];
	_sketchWindowController = [[SKTWindowController alloc] init];
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0]];

	[_sketchWindowController setDocument: _doc];
	[_doc addWindowController: _sketchWindowController];
	[_sketchWindowController setShouldCloseDocument:YES];	
	[_sketchWindowController showWindow:self];
	
	_skViewControl = _sketchWindowController.viewController;
}

- (void)tearDown {
	
	[_sketchWindowController.window close];
	[_sketchWindowController setDocument:nil];
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0]];
	[_sketchWindowController release];
    [_doc release];
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0]];

	[SHDocumentController cleanUpSharedDocumentController];
}

- (void)testUnarchivedProperties {
	
	// test skViewControl properties
	STAssertNotNil(_skViewControl.document, @"where is it?");
	STAssertNotNil(_skViewControl.sketchViewModel, @"where is it?");
	STAssertNotNil(_skViewControl.sketchView, @"where is it?");
	STAssertNotNil(_skViewControl.sketchLayerTable, @"where is it?");
	STAssertNotNil(_skViewControl.debugTableArrayController, @"where is it?");
	STAssertTrue(_skViewControl->_isSetup==YES, @"should be setup");
	
	// test arrayController properties
	SKTDragReorderArrayController *layerTableController = _skViewControl.debugTableArrayController;
	STAssertNotNil( [layerTableController tableView], @"where is it?");
	NSDictionary *contentBinding = [layerTableController infoForBinding: NSContentArrayBinding];
	STAssertTrue([[contentBinding valueForKey:@"NSObservedKeyPath"] isEqualToString:@"sketchViewModel.sktSceneItems"], @"content binding seems wrong");
	
	NSDictionary *selectionBinding = [layerTableController infoForBinding:@"selectionIndexes"];
	STAssertTrue([[selectionBinding valueForKey:@"NSObservedKeyPath"] isEqualToString:@"sketchViewModel.sktSceneSelectionIndexes"], @"selection binding seems wrong");
	
	//-- check the 
	// test sketchView properties
	STAssertNotNil(_skViewControl.sketchView.sketchViewController, @"where is it?");

	// test layer table properties
		
}


/*
 * when you set the document in viewcontroller it should
 * set sketchmodel in the view model
 */
- (void)testSetDocument {
	// - (void)setDocument:(BlakeDocument *)value;

	// give the doc a mock sketch Model
	StubSketchDoc *stubDoc = [[[StubSketchDoc alloc] init] autorelease];
	stubDoc.nodeGraphModel = [[[SHNodeGraphModel alloc] init] autorelease];

	/* set the document on our controller.
	  * This will cause _sketchViewModel to have it's model set
	  * This will cause controller to observe changes to graphics & selectionIndexes in _sketchViewModel
	  * However, using this mock model will NOT trigger the notifications we need when a new model is set - 
	  * We need to do some tests with the real deal. Real Model, etc..
	 */
	[_skViewControl setDocument:(id)stubDoc];
	STAssertEqualObjects([_skViewControl document], stubDoc, @"Didnt we just set the document");
}


//eek! - (void)testGraphicViewControllerReceivesUpdateNotifications {
	
	/* First, set a mock doc */
//eek!	id mockDoc = [OCMockObject mockForClass:NSClassFromString(@"SHAppControl")];
//eek!	id mockSketchModel = [OCMockObject mockForClass:NSClassFromString(@"SHNodeGraphModel")];
//eek!	[[mockSketchModel stub] isKindOfClass:OCMOCK_ANY];
//eek!	[[[mockDoc stub] andReturnValue:OCMOCK_VALUE(mockSketchModel)] sketchModel];
//eek!	mockSketchModel = [OCMockObject _makeNice:mockSketchModel];
//eek!	[_skViewControl setDocument: mockDoc];
	
	/* Now swap in a real doc and check that we get nofications that graphics & selection have changed */
//eek!	id doc = [[self class] standInDocument];
//eek!	SHNodeGraphModel *sModel = [[[SHNodeGraphModel alloc] init] autorelease];
//eek!	[doc setNodeGraphModel: sModel];	
	
	// -- Verify that _skViewControl receives notification that graphics and selection have changed when we set a new doc 
//eek!	int beforeGCC = _skViewControl->_graphicsChangeCount;
//eek!	int beforeSCC = _skViewControl->_selectionChangeCount;
//eek!	[_skViewControl setDocument: doc];
	
//eek!	STAssertTrue( _skViewControl->_graphicsChangeCount == beforeGCC+1 , @"looks like graphicsDidChange notification wasn't received");
//eek!	STAssertTrue( _skViewControl->_selectionChangeCount == beforeSCC+1, @"looks like selectionDidChange notification wasn't received");
//eek! }

/* 
	Vague investigations into how notifications work 
	Am i losing information? The graphics providor gets Inserted, removed info. We then build a new array
	to replace the old one with so viewModel just knows thatr each time an entire new array has been set.
	Investigate this.
*/
//eek!- (void)testBubbleDownOfNotificationsToController {
	
//eek!	id doc = [[self class] standInDocument];
//eek!	SHNodeGraphModel *sModel = [[[SHNodeGraphModel alloc] init] autorelease];
//eek!	[doc setNodeGraphModel: sModel];	
//eek!	[_skViewControl setDocument: doc];

//eek!	STAssertNotNil( _skViewControl.sketchViewModel, @"fuck" );
//eek!	STAssertNotNil( _skViewControl.document, @"fuck" );

	/* Add some graphics */
//eek!	SKTCircle *newGraphic1 = [[[SKTCircle alloc] init] autorelease];		// first drawable
//eek!	[sModel insertGraphic:newGraphic1 atIndex:0];
	
//eek!	SKTGraphic *newGraphic2 = [[[SKTGraphic alloc] init] autorelease];		// not drawable
//eek!	[sModel insertGraphic:newGraphic2 atIndex:1];

//eek!	SKTCircle *newGraphic3 = [[[SKTCircle alloc] init] autorelease];		// second drawable
//eek!	[sModel insertGraphic:newGraphic3 atIndex:1];

	/* Swap them around */
//eek!	[sModel setIndexOfChild:newGraphic1 to:2];
//eek!	[sModel setIndexOfChild:newGraphic1 to:2];

//eek!	[sModel setIndexOfChild:newGraphic3 to:0];

	/* Remove the graphics */
//eek!	[sModel removeGraphicAtIndex: 1];
//eek!	[sModel removeGraphicAtIndex: 0];
//eek!	[sModel removeGraphicAtIndex: 0];
//eek! }

//eek! - (void)testThatWeSendViewDirtyMessages {
	
//eek!	id doc = [[self class] standInDocument];
//eek!	SHNodeGraphModel *sModel = [[[SHNodeGraphModel alloc] init] autorelease];
//eek!	[doc setNodeGraphModel: sModel];
	
	//-- clean up first if we need to
//eek!	if([sModel.graphics count]>0)
//eek!		[sModel removeGraphicsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [sModel.graphics count])]]; 
//eek!	STAssertTrue([sModel.graphics count]==0, @"failed to clean up model %i", [sModel.graphics count] );
	
//eek!	[_skViewControl setDocument: doc];

//eek!	id mockView = [OCMockObject mockForClass:NSClassFromString(@"NSView")];
//eek!	BOOL expectedValue = NO; // you need to asign expectedValue to a variable or it doesn't work !(?)
//eek!	[[[mockView stub] andReturn:OCMOCK_VALUE(expectedValue)] performSelector: NSSelectorFromString(@"isNSString__")];
//eek!	[[[mockView stub] andReturn:OCMOCK_VALUE(expectedValue)] respondsToSelector:@selector(descriptionWithLocale:indent:)];
//eek!	[[[mockView stub] andReturn:OCMOCK_VALUE(expectedValue)] respondsToSelector:@selector(descriptionWithLocale:)];

//eek!	_skViewControl->_sketchView = mockView;
//eek!	STAssertNotNil(_skViewControl.sketchViewModel, @"oops");
//eek!	STAssertNotNil(_skViewControl->_sketchView, @"oops");

//eek!	NSRect circBnds = NSMakeRect(0.f, 100.f, 99.f, 98.f);
//eek!	[[mockView expect] setNeedsDisplayInRect: circBnds];
//eek!	SKTCircle *newGraphic1 = [[[SKTCircle alloc] init] autorelease];
//eek!	[newGraphic1 setBounds: circBnds];

	/* when we add an object it should dirty the view */
//eek!	[sModel insertGraphic:newGraphic1 atIndex:0];
//eek!	[mockView verify];

	/* when we remove an object it should dirty the view */
//eek!	[[mockView expect] setNeedsDisplayInRect: circBnds];
//eek!	[sModel removeGraphicAtIndex:0];
//eek!	[mockView verify];
//eek! }

//temp- (void)testTableViewStuff {

//temp	id doc = [self standInDocument];
//temp	_skViewControl->_sketchLayerTable = [OCMockObject mockForClass:NSClassFromString(@"NSTableView")];
//temp	[_skViewControl setDocument: doc];
//temp}
@end
