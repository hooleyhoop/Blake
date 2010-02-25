//
//  TADocumentWindowController.m
//  TemplateDocumentBasedApplication
//
//  Created by Jesse Grosjean on 11/17/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "TADocumentWindowController.h"


@implementation TADocumentWindowController

#pragma mark init

- (id)init {
    if (self = [super initWithWindowNibName:@"TADocumentWindow"]) {
    }
    return self;
}

#pragma mark dealloc

- (void)dealloc {
    [super dealloc];
}

#pragma mark accessors

- (NSWindowController *)selfAsWindowController {
	return self;
}

@end
