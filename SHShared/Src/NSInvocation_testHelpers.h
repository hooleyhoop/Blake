//
//  NSInvocation_testHelpers.h
//  SHShared
//
//  Created by Steven Hooley on 13/01/2010.
//  Copyright 2010 Tinsal Parks. All rights reserved.
//


@interface NSInvocation (TestHelpers)

- (BOOL)isTestMethod;
- (NSInvocation *)prependSelector:(NSString *)value;

@end
