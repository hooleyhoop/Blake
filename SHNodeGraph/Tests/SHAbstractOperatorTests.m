//
//  SHAbstractOperatorTests.m
//  SHNodeGraph
//
//  Created by steve hooley on 04/12/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//
#import "SHAbstractOperator.h"

@interface SHAbstractOperatorTests : SenTestCase {
	
	SHAbstractOperator *_operator;
}

@end

@implementation SHAbstractOperatorTests

- (void)setUp {
    _operator =  [[SHAbstractOperator makeChildWithName:@"abstract1"] retain];
}

- (void)tearDown {
	[_operator release];
}

- (void)testDefault_allowsSubpatchesSetting {
	STAssertFalse(_operator.allowsSubpatches, @"Default should be no! Even tho this will fuck up a lot of tests when we change SKTAudio, etc. to be a subclass of AbstractOperator");
}

@end
