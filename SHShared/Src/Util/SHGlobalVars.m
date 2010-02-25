//
//  SHGlobalVars.m
//  Shared
//
//  Created by Steve Hooley on 31/10/2005.
//  Copyright 2005 HooleyHoop. All rights reserved.
//

#import "SHGlobalVars.h"

static SHGlobalVars *_globals = nil;

@implementation SHGlobalVars

#pragma mark -
#pragma mark class methods
+ (SHGlobalVars *)globals {

	if( !_globals ) {
		_globals = [[self alloc] init];
	}
	return _globals;
}

+ (void)cleanUpGlobals {

	if(_globals){
		[_globals release];
		_globals = nil;
	}
}

#pragma mark init methods
- (id)init {

	NSAssert(!_globals, @"are we making more than one of these now then?");
	self = [super init];
    if( self ) {
		_vars = [[NSMutableDictionary alloc]initWithCapacity:10];
	}
    return self;
}

- (void)dealloc {
	
    [_vars release];
	[super dealloc];
}

#pragma mark acessor methods
- (NSObject *)objectForKey:(NSObject *)key {

	return [_vars objectForKey:key];
}

- (void)setObject:(NSObject *)object forKey:(NSObject *)key {

	[_vars setObject:object forKey:key];
} 

@end
