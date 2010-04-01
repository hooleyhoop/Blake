//
//  MockProcessor.m
//  SHNodeGraph
//
//  Created by Steve Hooley on 25/02/2007.
//  Copyright 2007 HooleyHoop. All rights reserved.
//

#import "MockProcessor.h"
#import "SHExecutableNode.h"


/*
 *
*/
@implementation MockProcessor

// ===========================================================
// + executionMode
// ===========================================================
+ (int)executionMode
{
	return PROCESSOR;
}

// ===========================================================
// - init
// ===========================================================
- (id)init
{
	if( (self=[super init])!=nil )
	{
		_didRender = NO;
	}
	return self;
}

// ===========================================================
// - didRender
// ===========================================================
- (BOOL)didRender
{
	return _didRender;
}

// ===========================================================
// - resetDidRender
// ===========================================================
- (void)resetDidRender
{
	_didRender = NO;
}

// ===========================================================
// - execute:
// ===========================================================
/* This is only ever called from evaluateOncePerFrame */
- (BOOL)execute:(id)fp8 head:()np time:(CGFloat)timeKey arguments:(id)fp20
{
	_didRender = YES;
	return _didRender;
}


@end
