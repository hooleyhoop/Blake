//
//  NSObject_Extras.m
//  SHShared
//
//  Created by steve hooley on 16/11/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "NSObject_Extras.h"
#import <Foundation/NSObjCRuntime.h>
#import <objc/runtime.h>

@implementation NSObject (NSObject_Extras) 

+ (NSString *)classAsString {
	return NSStringFromClass(self);
}

- (id)initBase {
	return [self init];
}

/* You must overide this to be more specific */
- (BOOL)isEquivalentTo:(id)value {
	
	NSParameterAssert(value);
	return ([value class]==[self class]);
}

- (NSString *)classAsString {
	return NSStringFromClass([self class]);
}

- (BOOL)performInstanceSelectorReturningBool:(SEL)selector {

	NSParameterAssert( [self respondsToSelector:selector] );

	Method m = class_getInstanceMethod([self class], selector);
	
	// check that return type is BOOL
	const char * hmm = method_getTypeEncoding(m);
	NSAssert(hmm[0]=='c', @"A BOOL is type char (c)");

	IMP theIMP = method_getImplementation(m);
	BOOL (*MyMagicSender)(id, SEL)=(BOOL (*)(id, SEL))theIMP; // 2 args Self and _cmd
	
	BOOL returnValue = NO;
	if(MyMagicSender!=NULL){
		returnValue = MyMagicSender(self, selector);
	}
	return returnValue;
}

- (BOOL)performInstanceSelectorReturningBool:(SEL)selector withObject:(id)value {

	NSParameterAssert( [self respondsToSelector:selector] );
	
	Method m = class_getInstanceMethod([self class], selector);
	
	// check that return type is BOOL
	const char * hmm = method_getTypeEncoding(m);
	NSAssert(hmm[0]=='c', @"A BOOL is type char (c)");
	
	IMP theIMP = method_getImplementation(m);
	BOOL (*MyMagicSender)(id, SEL, id)=(BOOL (*)(id, SEL, id))theIMP; // 3 args Self and _cmd and value
	
	BOOL returnValue = NO;
	if(MyMagicSender!=NULL){
		returnValue = MyMagicSender(self, selector, value);
	}
	return returnValue;
}

@end
