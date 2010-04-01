//
//  StubView.h
//  BlakeLoader
//
//  Created by steve hooley on 25/03/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//


@interface StubView : NSView {

@public
	BOOL testSelectorWasCalled;
}

- (void)testSelector;
- (BOOL)testSelectorReturningBool;

- (BOOL)canSelectAllChildren;
- (BOOL)canDeSelectAllChildren;

@end
