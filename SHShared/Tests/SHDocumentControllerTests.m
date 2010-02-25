//
//  SHDocumentControllerTests.m
//  SHShared
//
//  Created by steve hooley on 13/08/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "SHDocument.h"
#import "SHDocumentController.h"

@interface StupidTestDocument : SHDocument {
	
}

@end

@implementation StupidTestDocument

@end


@interface SHDocumentControllerTests : SenTestCase {
	
	SHDocumentController *_docController;
}

@end

@implementation SHDocumentControllerTests

- (void)setUp {
	
	_docController = [[SHDocumentController alloc] init];
}

- (void)tearDown {
	
	[_docController release];
}

- (void)testDynamicallyRegisterType {
	
	id docController = [SHDocumentController sharedDocumentController];
	STAssertNotNil( docController, @"eh?");
	/* register a new type */	
	[docController setDocClass:[StupidTestDocument class] forDocType:@"stupidDoc"];
	 
	/* test */
	NSError *err;
	id doc = [docController makeUntitledDocumentOfType:@"stupidDoc" error:&err];
	STAssertNotNil(doc, @"we should be able to make a doc");
	STAssertTrue([doc isKindOfClass:[StupidTestDocument class]], @"is wrong class %@", NSStringFromClass([doc class]) );
}


@end
