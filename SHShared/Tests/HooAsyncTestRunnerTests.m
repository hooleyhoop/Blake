//
//  HooAsyncTestRunner.m
//  InAppTests
//
//  Created by steve hooley on 16/03/2010.
//  Copyright 2010 BestBefore Ltd. All rights reserved.
//
#import "HooAsyncTestRunner.h"

@interface HooAsyncTestRunner : SenTestCase {
	
	RunTests *_testRunner;
}

@end

@implementation HooAsyncTestRunner

- (void)setUp {
	_testRunner = [[RunTests alloc] init];
}

- (void)tearDown {
	[_testRunner release];
}

@end
