//
//  SHAbstractOperator.m
//  SHNodeGraph
//
//  Created by steve hooley on 09/03/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "SHAbstractOperator.h"


@implementation SHAbstractOperator

- (id)init {

	if( (self=[super init])!=nil ) {
		_allowsSubpatches = NO;
	}
	return self;
}

@end
