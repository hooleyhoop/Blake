//
//  SHProtoInputAttributeTests.m
//  SHNodeGraph
//
//  Created by steve hooley on 27/02/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//
#import "SHProtoInputAttribute.h"

@interface SHProtoInputAttributeTests : SenTestCase {
	
	SHProtoInputAttribute *_testAtt;
}

@end


@implementation SHProtoInputAttributeTests

- (void)setUp {
	_testAtt = [[SHProtoInputAttribute alloc] init];
}

- (void)tearDown {
	[_testAtt release];
}


- (void)testSetDirtyBelow {
	// - (void)setDirtyBelow:(int)uid;

//	STFail(@"haven't needed setDirtyBelow yet");
	[_testAtt setDirtyBelow:0];
}

- (void)testNodesIAffect {

	STAssertTrue([_testAtt.nodesIAffect count]==0, @"hmm");
}

@end
