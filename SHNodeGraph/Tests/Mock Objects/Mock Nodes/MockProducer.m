//
//  MockProducer.m
//  SHNodeGraph
//
//  Created by Steve Hooley on 25/02/2007.
//  Copyright 2007 HooleyHoop. All rights reserved.
//

#import "MockProducer.h"
#import "SHExecutableNode.h"


/*
 *
*/
@implementation MockProducer

+ (int)executionMode {
	return PROVIDER;
}

- (id)init {
	
	self=[super init];
	if( self )
	{
		_didRender = NO;
	}
	return self;
}

- (BOOL)didRender {
	return _didRender;
}

- (void)resetDidRender {
	_didRender = NO;
}

/* This is only ever called from evaluateOncePerFrame */
- (BOOL)execute:(id)fp8 head:()np time:(CGFloat)timeKey arguments:(id)fp20 {
	
	_didRender = YES;
	return _didRender;
}


@end
