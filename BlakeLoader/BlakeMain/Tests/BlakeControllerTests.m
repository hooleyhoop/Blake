//
//  BlakeControllerTests.m
//  BlakeLoader
//
//  Created by steve hooley on 03/01/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//


#import <BlakeMain/BlakeController.h>
#import <BlakeMain/BlakeDocumentController.h>



@interface BlakeControllerTests : SenTestCase {
	
	BlakeController *blakeController;
}

@end


@implementation BlakeControllerTests


- (BlakeDocumentController *)docController {
	
	id dc = [BlakeDocumentController sharedDocumentController];
	STAssertTrue([dc isKindOfClass:[BlakeDocumentController class]], @"STOP!! Wrong document controller");
	BlakeDocumentController *docControl = dc;
	if(docControl.isSetup==NO)
		[docControl setupObserving];
	STAssertTrue(docControl.isSetup==YES, @"STOP!! docController not setup");
	return docControl;
}

- (void)setUp {

	/* This loads our custom view plugins and  creates the single documentController for the app */
	blakeController = [[BlakeController alloc] init];
	
	[[self docController] closeAll];
	NSArray* allDocs = [[self docController] documents];
	STAssertTrue([allDocs count]==0, @"closeAll docs broken? %i", [allDocs count]);
}

- (void)tearDown {
	[blakeController release];
}


- (void)testApplicationLaunching {
//- (void)applicationLaunching;
//	STFail(@"Hello - Running Test");
}
//- (void)applicationWillFinishLaunching
//- (void)applicationDidFinishLaunching
//- (void)applicationWillTerminate

@end
