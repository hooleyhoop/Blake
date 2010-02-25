//
//  SHOutletTests.m
//  SHNodeGraph
//
//  Created by steve hooley on 20/11/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "SHOutlet.h"

@interface SHOutletTests : SenTestCase {
	
	SHOutlet *_outlet;
}

@end


@implementation SHOutletTests

- (void)setUp {
	_outlet = [[SHOutlet alloc] init];
}

- (void)tearDown {
	[_outlet release];
}

@end
