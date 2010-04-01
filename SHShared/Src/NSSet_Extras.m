//
//  NSSet_Extras.m
//  SHShared
//
//  Created by steve hooley on 02/12/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "NSSet_Extras.h"


@implementation NSSet (NSSet_Extras)

- (NSSet *)setMinus:(id)value {
	
	if(![self containsObject:value])
		return self;
	
	NSMutableSet *duplicate = [self mutableCopy];
	[duplicate removeObject:value];
	return [duplicate autorelease];
}

@end
