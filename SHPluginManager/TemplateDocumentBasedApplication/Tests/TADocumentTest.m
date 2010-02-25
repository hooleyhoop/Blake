//
//  TADocumentTest.m
//  TemplateDocumentBasedApplication
//
//  Created by Jesse Grosjean on 12/8/04.
//  Copyright 2004 Hog Bay Software. All rights reserved.
//

#import "TADocumentTest.h"


@implementation TADocumentTest

+ (id)setUpDocumentTest:(BOOL)display {
	static BOOL isSetUp = NO;
	if (!isSetUp) {
		[[BKPluginRegistry sharedInstance] scanPlugins];
		[[BKPluginRegistry sharedInstance] loadMainExtension];
		isSetUp = YES;
	}

	return [[NSDocumentController sharedDocumentController] openUntitledDocumentAndDisplay:display error:nil];
}

+ (void)tearDownDocumentForTesting:(id)doc {
	[doc close];
	[[NSFileManager defaultManager] removeFileAtPath:[[[doc fileURL] path] stringByDeletingLastPathComponent] handler:nil];
}

- (void)setUp {
	document = [TADocumentTest setUpDocumentTest:NO];
}

- (void)tearDown {
	[TADocumentTest tearDownDocumentForTesting:document];
}

- (void)testNotNil {
	STAssertNotNil(document, @"");
}

@end