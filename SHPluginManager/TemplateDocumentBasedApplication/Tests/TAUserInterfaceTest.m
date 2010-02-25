//
//  TAUserInterfaceTest.m
//  TemplateDocumentBasedApplication
//
//  Created by Jesse Grosjean on 11/17/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "TAUserInterfaceTest.h"
#import "TADocumentTest.h"


@implementation TAUserInterfaceTest

- (void)setUp {
	document = [TADocumentTest setUpDocumentTest:YES];
	windowController = [[[document selfAsPersistentDocument] windowControllers] lastObject];
}

- (void)tearDown {
	[TADocumentTest tearDownDocumentForTesting:document];
}

- (void)testWindowController {
	STAssertTrue([windowController conformsToProtocol:@protocol(TADocumentWindowControllerProtocol)], @"");
}

@end