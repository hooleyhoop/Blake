//
//  NSCharacterSet_Extensions.m
//  Shared
//
//  Created by Steve Hooley on 29/07/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import "NSCharacterSet_Extensions.h"

static NSCharacterSet *_nodeNameCharacterSet;

@implementation NSCharacterSet (NSCharacterSet_Extensions)

+ (NSCharacterSet *)nodeNameCharacterSet {
	
	if(!_nodeNameCharacterSet)
		_nodeNameCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@" _0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"] retain];
	return _nodeNameCharacterSet;
}

+ (void)cleanUpNodeNameCharacterSet {
	[_nodeNameCharacterSet release];
	_nodeNameCharacterSet=nil;
}

@end
