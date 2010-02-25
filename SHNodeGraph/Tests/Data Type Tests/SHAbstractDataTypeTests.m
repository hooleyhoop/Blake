//
//  SHAbstractDataTypeTests.m
//  SHNodeGraph
//
//  Created by steve hooley on 01/12/2007.
//  Copyright 2007 HooleyHoop. All rights reserved.
//


#import "SHAbstractDataType.h"

@interface SHAbstractDataTypeTests : SenTestCase {
	
	SHAbstractDataType* dataType;
}

@end


@implementation SHAbstractDataTypeTests


- (void)setUp {
	dataType = [[SHAbstractDataType alloc] init];
}


- (void)tearDown {
	[dataType release];
}

- (void)testIsUnset {
	STAssertTrue([dataType isUnset], @"new value should be unset");
}
@end
