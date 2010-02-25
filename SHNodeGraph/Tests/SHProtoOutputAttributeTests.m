//
//  SHProtoOutputAttributeTests.m
//  SHNodeGraph
//
//  Created by steve hooley on 27/02/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "SHProtoOutputAttribute.h"

@interface SHProtoOutputAttributeTests : SenTestCase {
	
	SHProtoOutputAttribute *_testAtt;
}

@end

@implementation SHProtoOutputAttributeTests

- (void)setUp {
	
	_testAtt = [[SHProtoOutputAttribute alloc] init];
}

- (void)tearDown {
	
	[_testAtt release];
}

- (void)testSetDirtyBelow {
	// - (void)setDirtyBelow:(int)uid
	
	[_testAtt setDirtyBelow:0];
}

@end
