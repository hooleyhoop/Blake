//
//  HooAsyncTestRunner.m
//  InAppTests
//
//  Created by steve hooley on 16/03/2010.
//  Copyright 2010 BestBefore Ltd. All rights reserved.
//
#import "HooAsyncTestRunner.h"

@interface HooAsyncTestRunnerTests : SenTestCase {
	
	HooAsyncTestRunner *_testRunner;
}

@end

@implementation HooAsyncTestRunnerTests

- (void)setUp {
	_testRunner = [[HooAsyncTestRunner alloc] init];
}

- (void)tearDown {
	[_testRunner release];
}

@end
