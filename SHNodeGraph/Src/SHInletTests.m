//
//  SHInletTests.m
//  SHNodeGraph
//
//  Created by steve hooley on 20/11/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//
#import "SHInlet.h"

@interface SHInletTests : SenTestCase {
	
	SHInlet *_inlet;
}

@end

@implementation SHInletTests

- (void)setUp {
	_inlet = [[SHInlet alloc] init];
}

- (void)tearDown {
	[_inlet release];
}

@end
