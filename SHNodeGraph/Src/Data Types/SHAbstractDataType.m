//
//  SHAbstractDataType.m
//  SHNodeGraph
//
//  Created by steve hooley on 01/12/2007.
//  Copyright 2007 HooleyHoop. All rights reserved.
//

#import "SHAbstractDataType.h"

@implementation SHAbstractDataType

@synthesize isUnset;

/* called from HooleyObject init */
- (id)initBase {

	self=[super initBase];
	if(self){
		isUnset = YES;
	}
	return self;
}

- (id)init {

	self=[super init];
    if(self) {
	}
	return self;
}

- (void)dealloc {
	
	[super dealloc];
}

- (id)initWithCoder:(NSCoder *)coder {
	
	/* careful not to call [super initWithCoder:] here as it will call [self init] */
    self = [super init];
	if(self){
    }
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {

}

- (id)copyWithZone:(NSZone *)zone {

	id copy = [[[self class] alloc] initBase]; // if we are a HooleyObject call -initBase
	return copy;
}

@end
