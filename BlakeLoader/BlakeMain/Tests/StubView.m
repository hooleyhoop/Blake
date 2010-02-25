//
//  StubView.m
//  BlakeLoader
//
//  Created by steve hooley on 25/03/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "StubView.h"

@implementation StubView

- (id)initWithFrame:(NSRect)frame {

    self = [super initWithFrame:frame];
    if(self) {
        testSelectorWasCalled = NO;
    }
    return self;
}

- (void)dealloc {

    [super dealloc];
}

//- (void)drawRect:(NSRect)rect {}

- (void)testSelector {
	logInfo(@"testSelector called ok");
	testSelectorWasCalled = YES;
}

- (BOOL)testSelectorReturningBool {
	testSelectorWasCalled = YES;
	return YES;
}

- (BOOL)canSelectAllChildren {
	return YES;
}

// Are some items in the table selected? Examine the tables arrayController 'selectionIndexes' binding to find out
- (BOOL)canDeSelectAllChildren {
	return YES;
}

- (BOOL)acceptsFirstResponder { return YES; }
- (BOOL)canBecomeKeyView { return YES; }

@end
