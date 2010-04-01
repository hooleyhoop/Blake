//
//  NSResponder_Extras.m
//  SHShared
//
//  Created by steve hooley on 18/03/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "NSResponder_Extras.h"


@implementation NSResponder (NSResponder_Extras)

+ (void)insert:(NSResponder *)newItem intoResponderChainAbove:(NSResponder *)existingItem {
	
	NSParameterAssert(newItem);
	NSParameterAssert(existingItem);

	NSResponder *currentNextResponder = [existingItem nextResponder];
	NSAssert(currentNextResponder!=nil, @"boot boot");

	[existingItem setNextResponder: newItem];
	[newItem setNextResponder: currentNextResponder];
}

@end
