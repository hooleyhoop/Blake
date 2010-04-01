//
//  SHGlobalVarsTests.m
//  SHShared
//
//  Created by steve hooley on 17/12/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "SHGlobalVars.h"

@interface SHGlobalVarsTests : SenTestCase {
	
}

@end

@implementation SHGlobalVarsTests

- (void)testInOneGo {
	
	SHGlobalVars *testVars = [SHGlobalVars globals];
	[testVars setObject:self forKey:@"rabbit"];
	STAssertTrue([testVars objectForKey:@"rabbit"]==self, @"doh");
	[SHGlobalVars cleanUpGlobals];
}

@end
