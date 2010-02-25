//
//  ArrayDataTests.m
//  SHNodeGraph
//
//  Created by Steven Hooley on 27/10/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import <SHNodeGraph/SHNodeGraph.h>

@interface ArrayDataTests : SenTestCase {
	
	SHNodeGraphModel *_nodeGraphModel;
	
}


@implementation ArrayDataTests


// ===========================================================
// - setUp
// ===========================================================
- (void) setUp
{	
    _nodeGraphModel =  [[SHNodeGraphModel makeEmptyModel] retain];
	STAssertNotNil(_nodeGraphModel, @"mathOperatorTests ERROR.. Couldnt make a nodeModel");
}

// ===========================================================
// - tearDown
// ===========================================================
- (void) tearDown
{
	[_nodeGraphModel release];
	_nodeGraphModel = nil;
}


// ===========================================================
// - testPlusOperator
// ===========================================================
- (void) testPlusOperator
{
//	SHNode* root = [_nodeGraphModel rootNodeGroup];
//	SHPlusOperator* op = [[SHPlusOperator alloc] init];	
//	[root addChild:op];
//	
//	SHNumber* n1 = [SHNumber numberWithInt:10];
//	SHNumber* n2 = [SHNumber numberWithInt:15];
//	SHNumber* n3 = [SHNumber numberWithInt:23];
//
//	NSMutableArray* inArray = [NSMutableArray arrayWithObjects:n1, n2, n3, nil];
//	
//	[op setContentsOfInputWithKey:@"input1" with:inArray]; // [inAtt1 publicSetValue:@"4"];
//	[op setContentsOfInputWithKey:@"input2" with:n1];

//	NSMutableArray* result  = [(SHOutputAttribute*)[op outputAttributeAtIndex:0] upToDateEvaluatedValue:random()]; // [outAtt1 upToDateEvaluatedValue:random()];
//
//	STAssertTrue([result count]==3, @"is %i", [result count]);
//	STAssertTrue([result objectAtIndex:0]==20, @"is %i", [result objectAtIndex:0]);
//	STAssertTrue([result objectAtIndex:1]==25, @"is %i", [result objectAtIndex:1]);
//	STAssertTrue([result objectAtIndex:2]==33, @"is %i", [result objectAtIndex:2]);
//	
//	[_nodeGraphModel closeCurrentRootNode];
	
//	STFail(@"NOT DONE YET");
	
	/* 14 November 2006 - abandoning this array input mallarky */
}


@end
