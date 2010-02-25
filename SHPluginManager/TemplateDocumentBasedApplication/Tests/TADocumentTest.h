//
//  TADocumentTest.h
//  TemplateDocumentBasedApplication
//
//  Created by Jesse Grosjean on 12/8/04.
//  Copyright 2004 Hog Bay Software. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <Blocks/Blocks.h>
#import "TADocumentProtocols.h"


@class TADocument;

@interface TADocumentTest : SenTestCase {
	id <TADocumentProtocol> document;
}

+ (id)setUpDocumentTest:(BOOL)display;
+ (void)tearDownDocumentForTesting:(id)doc;
	
@end
