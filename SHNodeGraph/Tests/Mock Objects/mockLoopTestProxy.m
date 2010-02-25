//
//  mockLoopTestProxy.m
//  SHNodeGraph
//
//  Created by Steve Hooley on 21/06/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import "mockLoopTestProxy.h"

static int loopCondition=10;

@implementation mockLoopTestProxy

#pragma mark -
#pragma mark class methods


// ===========================================================
// - loopTestProxy
// ===========================================================
+ (id) loopTestProxy
{
	return [[[mockLoopTestProxy alloc] init] autorelease];
}

#pragma mark init methods
// ===========================================================
// - init
// ===========================================================
- (id)init
{	
	if( (self=[super init])!=nil )
	{
		[self reset];
	} 
	return self;
}

#pragma mark action methods
// ===========================================================
// - reset
// ===========================================================
- (void) reset {
	loopCondition=10;
}

#pragma mark accessor methods

// ===========================================================
// - loopConditionalTest
// ===========================================================
- (BOOL) loopConditionalTest
{
	// loop 10 times
	if(--loopCondition >0)
		return YES;
	return NO;
}

// ===========================================================
// - success
// ===========================================================
- (BOOL) success
{
	if(loopCondition==0)
		return YES;
	return NO;
}
@end
