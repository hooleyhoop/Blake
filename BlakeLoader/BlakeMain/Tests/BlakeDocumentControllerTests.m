//
//  BlakeDocumentControllerTests.m
//  BlakeLoader
//
//  Created by steve hooley on 03/01/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//
#import "BlakeDocumentController.h"
#import "MockSHDocument.h"


@interface BlakeDocumentControllerTests : SenTestCase {
	
	BlakeDocumentController *appDocController;
	
	Class customDocClassForTests;
	
}

@end

@implementation BlakeDocumentControllerTests

- (BlakeDocumentController *)docController {
	
	id dc = [BlakeDocumentController sharedDocumentController];
	STAssertTrue([dc isKindOfClass:[BlakeDocumentController class]], @"STOP!! Wrong document controller");
	BlakeDocumentController *docControl = dc;
	if(docControl.isSetup==NO)
		[docControl setupObserving];
	STAssertTrue(docControl.isSetup==YES, @"STOP!! docController not setup");
	
//	[dc setDocClass:[StubSketchDoc class] forDocType:@"sketch"];
	
	return docControl;
}

- (void)setUp {
	
	appDocController = [[self docController] retain];
	customDocClassForTests = NSClassFromString(@"MockSHDocument");

	//- make sure all docs are closed..
	[[self docController] closeAll];
	NSArray* allDocs = [[self docController] documents];
	STAssertTrue([allDocs count]==0, @"mm %i", [allDocs count]);
}

- (void)tearDown {
	[appDocController release];
	
	//- make sure all docs are closed..
	[[self docController] closeAll];
	NSArray* allDocs = [[self docController] documents];
	STAssertTrue([allDocs count]==0, @"mm %i", [allDocs count]);
}

- (void)testDocumentClassForType {
	// - (Class)documentClassForType:(NSString *)typeName

	/* By default, document type should be BlakeDocument */
	Class defaultDocClass = [appDocController documentClassForType:@"BlakeDocument"];
	STAssertTrue( defaultDocClass==NSClassFromString(@"BlakeDocument"), @"Wrong Document Class %@", NSStringFromClass(defaultDocClass) );
	
	/* Try changing the document type */
	Class customClass = NSClassFromString(@"MockSHDocument");
	STAssertNotNil(customClass, @"where is our mock document class? MockSHDocument");
	appDocController.customDocClass = customClass;
	Class customDocClass = [appDocController documentClassForType:@"BlakeDocument"];
	STAssertTrue(customDocClass==NSClassFromString(@"MockSHDocument"), @"Wrong Document Class %@", NSStringFromClass(defaultDocClass));

	/* Document type should have reverted to default */
	defaultDocClass = [appDocController documentClassForType:@"BlakeDocument"];
	STAssertTrue(defaultDocClass==NSClassFromString(@"BlakeDocument"), @"Wrong Document Class %@", NSStringFromClass(defaultDocClass));
}

- (void)testOpenUntitledDocumentAndDisplay {
// openUntitledDocumentAndDisplay
	
	NSError *error = nil;
	id newDocument1, newDocument2, newDocument3;
	
	appDocController.customDocClass = customDocClassForTests;
	newDocument1 = [appDocController openUntitledDocumentAndDisplay:YES error:&error];
	STAssertNotNil(newDocument1, @"openUntitledDocumentAndDisplay failed");
	STAssertTrue([newDocument1 isKindOfClass:customDocClassForTests], @"Wrong kind of document for tests");
	
	appDocController.customDocClass = customDocClassForTests;
	newDocument2 = [appDocController openUntitledDocumentAndDisplay:YES error:&error];
	STAssertNotNil(newDocument2, @"openUntitledDocumentAndDisplay failed");
	STAssertTrue([newDocument2 isKindOfClass:customDocClassForTests], @"Wrong kind of document for tests");
	
	appDocController.customDocClass = customDocClassForTests;
	newDocument3 = [appDocController openUntitledDocumentAndDisplay:YES error:&error];
	STAssertNotNil(newDocument3, @"openUntitledDocumentAndDisplay failed");
	STAssertTrue([newDocument3 isKindOfClass:customDocClassForTests], @"Wrong kind of document for tests");
}

- (void)testWindowDidBecomeMainNotification {
	// - (void)windowDidBecomeMainNotification:(NSNotification *)notification
}

- (void)testWindowWillCloseNotification {
	// - (void)windowWillCloseNotification:(NSNotification *)notification 
}

- (void)testMakeDocumentWithContentsOfURL {

	// - (id)openDocumentWithContentsOfURL:(NSURL *)absoluteURL display:(BOOL)displayDocument error:(NSError **)outError:
	// - (id)makeDocumentWithContentsOfURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError
	
	// to test makeDocumentWithContentsOfURL we will actually use openDocumentWithContentsOfURL which is the only method that uses it.
	
	NSError *error = nil;
	NSBundle* thisBundle = [NSBundle bundleForClass:[self class]];
	NSString *pathForMockDoc = [thisBundle pathForResource:@"DocWriteTestf" ofType:@"fscript"];
	STAssertNotNil(pathForMockDoc, @"cant find bundled test document");
	appDocController.customDocClass = customDocClassForTests;
	MockSHDocument *newDocument1 = [appDocController openDocumentWithContentsOfURL:[NSURL fileURLWithPath:pathForMockDoc] display:YES error:&error];
	STAssertNotNil(newDocument1, @"makeDocumentWithContentsOfURL:ofType:error failed");
	STAssertTrue([newDocument1 class]==customDocClassForTests, @"makeDocumentWithContentsOfURL:ofType:error failed");

	appDocController.customDocClass = customDocClassForTests;
	MockSHDocument *newDocument2 = [appDocController openDocumentWithContentsOfURL:[NSURL fileURLWithPath:pathForMockDoc] display:YES error:&error];
	STAssertNotNil(newDocument2, @"makeDocumentWithContentsOfURL:ofType:error failed");
	STAssertTrue([newDocument2 class]==customDocClassForTests, @"makeDocumentWithContentsOfURL:ofType:error failed");

}



@end
