//
//  TAUserInterfaceTest.h
//  TemplateDocumentBasedApplication
//
//  Created by Jesse Grosjean on 11/17/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "BKDocumentsProtocols.h"
#import "TADocumentProtocols.h"
#import "TAUserInterfaceProtocols.h"


@interface TAUserInterfaceTest : SenTestCase {
	id <TADocumentProtocol> document;
	id <TADocumentWindowControllerProtocol> windowController;
}

@end
