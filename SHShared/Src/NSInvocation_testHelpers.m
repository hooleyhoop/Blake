//
//  NSInvocation_testHelpers.m
//  SHShared
//
//  Created by Steven Hooley on 13/01/2010.
//  Copyright 2010 Tinsal Parks. All rights reserved.
//

#import "NSInvocation_testHelpers.h"


@implementation NSInvocation (TestHelpers)

- (BOOL)isTestMethod {

	NSMethodSignature *sig = [self methodSignature];
	SEL selector = [self selector];
	NSString *selectorAsString = NSStringFromSelector(selector);
	NSUInteger argCount = [sig numberOfArguments];
	if( 2!=argCount )
		return NO;
	if( 0!=[sig methodReturnLength] )
		return NO;

	if( NO==[selectorAsString beginsWith:@"test"] )
		return NO;
	if( NO==[[self target] isKindOfClass:[SenTestCase class]] )
		return NO;
	return YES;
}

/* Woah! This really only works for selectors with no args - 
	Other wise you would have - _mySelector_: for 1 arg and fuck knows for more than that
 */
- (NSInvocation *)prependSelector:(NSString *)value {
	// -- build a new invocation with the modified selector
	
	NSMethodSignature *sig = [self methodSignature]; 
	NSUInteger argCount = [sig numberOfArguments];
	NSInvocation *cpy = [NSInvocation invocationWithMethodSignature:sig];
	for( NSUInteger i=2; i<argCount; i++ ){
		
		id arg;
		[self getArgument:&arg atIndex:i];
		[cpy setArgument:&arg atIndex:i];
	}
	SEL selector = [self selector];
	NSString *selectorAsString = NSStringFromSelector(selector);
	NSString *modifiedSelectorString = [selectorAsString prepend:value];
	SEL modifiedSelector = NSSelectorFromString(modifiedSelectorString);
	[cpy setSelector:modifiedSelector];
	id target = [self target];
	NSAssert([target respondsToSelector:modifiedSelector], @"Have we fucked up mangling selectors? This NSInvocation is going to be useless!");
	[cpy setTarget:target];

	if( [self argumentsRetained] )
		[cpy retainArguments];

	return cpy;
}
@end
