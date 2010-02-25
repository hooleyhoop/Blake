//
//  StubSketchDoc.m
//  BlakeLoader2
//
//  Created by steve hooley on 18/07/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "StubSketchDoc.h"


@implementation StubSketchDoc

@synthesize nodeGraphModel = _nodeGraphModel;

- (id)init {
	
	if ((self=[super init])!=nil) {
	}
	return self;
}

- (void)dealloc {

	[super dealloc];
}

- (void)close {
    [super close];
    int wondowControllerCount = [[self windowControllers] count];
    logInfo(@"winController count is %i", wondowControllerCount );
}

- (BOOL)isDocumentEdited {
	return YES;
}

@end
