//
//  NSObject_ExtrasTests.m
//  SHShared
//
//  Created by steve hooley on 16/11/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

@interface NSObject_ExtrasTests : SenTestCase {
	
}

@end


@implementation NSObject_ExtrasTests

- (BOOL)trueMethod {
	return YES;
}

- (BOOL)falseMethod {
	return FALSE;
}

- (BOOL)trueMethod:(NSString *)value {
	NSParameterAssert([@"camel" isEqualToString:value]);
	return YES;
}

- (BOOL)falseMethod:(NSString *)value {
	NSParameterAssert([@"banana" isEqualToString:value]);
	return FALSE;
}

- (void)testPerformInstanceSelectorReturningBool {
// - (BOOL)performInstanceSelectorReturningBool:(SEL)value

	STAssertTrue([self performInstanceSelectorReturningBool:@selector(trueMethod)], @"fuck");
	STAssertFalse([self performInstanceSelectorReturningBool:@selector(falseMethod)], @"fuck");
}

- (void)testPerformInstanceSelectorReturningBoolWithObject {
	// - (BOOL)performInstanceSelectorReturningBool:(SEL)value withObject:(id)value

	STAssertTrue([self performInstanceSelectorReturningBool:@selector(trueMethod:) withObject:@"camel"], @"fuck");
	STAssertFalse([self performInstanceSelectorReturningBool:@selector(falseMethod:) withObject:@"banana"], @"fuck");
}

@end
