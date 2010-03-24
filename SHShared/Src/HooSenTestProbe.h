//
//  HooSenTestProbe.h
//  InAppTests
//
//  Created by steve hooley on 07/01/2010.
//  Copyright 2010 BestBefore Ltd. All rights reserved.
//
#import <SenTestingKit/SenTestSuite.h>
#import <SenTestingKit/SenTestSuiteRun.h>

@interface HooSenTestProbe : NSObject {

}

+ (void)runTestsInBundle:(NSBundle *)aBundle;

@end


@interface SenTestSuite (HooSenTestSuite)

- (NSMutableArray *)tests;

@end


@interface SenTestSuiteRun (HooSenTestSuiteRun)

- (void)printHasSucceeded;

@end

@interface SenTestObserver (HooSenTestObserver)

+ (Class)currentObserverClass;

@end
