//
//  SHNodeAttributeMethodsTests.m
//  SHNodeGraph
//
//  Created by Steven Hooley on 09/11/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import "SHNodeAttributeMethodsTests.h"
#import <SHNodeGraph/SHNodeGraph.h>
#import "SHInputAttribute.h"
#import "SHOutputAttribute.h"

#import <SenTestingKit/SenTestingKit.h>
#import "SHNodeGraph.h"

@interface SHNodeAttributeMethodsTests : SenTestCase {
	
    SHNodeGraphModel *_nodeGraphModel;
	
	
}

@end

/*
 *
*/
@implementation SHNodeAttributeMethodsTests

// ===========================================================
// - setUp
// ===========================================================
- (void) setUp
{		
    _nodeGraphModel =  [[SHNodeGraphModel makeEmptyModel] retain];
	STAssertNotNil(_nodeGraphModel, @"SHNodeTest ERROR.. Couldnt make a nodeModel");
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
// - testInputAttributeAtIndex
// ===========================================================
- (void)testInputAttributeAtIndex
{
	SHNode* root = [_nodeGraphModel rootNodeGroup];
	SHInputAttribute* atChild1 = [SHInputAttribute makeAttribute];
	SHInputAttribute* atChild2 = [SHInputAttribute makeAttribute];
	[root addChild:atChild1 autoRename:YES];
	[root addChild:atChild2 autoRename:YES];

	STAssertTrue(atChild2==[root inputAttributeAtIndex:1], @"should be equal");	
}

// ===========================================================
// - testOutputAttributeAtIndex
// ===========================================================
- (void)testOutputAttributeAtIndex
{
	SHNode* root = [_nodeGraphModel rootNodeGroup];
	SHOutputAttribute* atChild1 = [SHOutputAttribute makeAttribute];
	SHOutputAttribute* atChild2 = [SHOutputAttribute makeAttribute];
	[root addChild:atChild1 autoRename:YES];
	[root addChild:atChild2 autoRename:YES];

	STAssertTrue(atChild2==[root outputAttributeAtIndex:1], @"should be equal");
}

// ===========================================================
// - testInputAttributeWithKey
// ===========================================================
- (void)testInputAttributeWithKey
{
	// - (id<SHAttributeProtocol>)inputAttributeWithKey:(NSString*)key
	SHNode* root = [_nodeGraphModel rootNodeGroup];
	SHInputAttribute* atChild1 = [SHInputAttribute makeAttribute];
	SHInputAttribute* atChild2 = [SHInputAttribute makeAttribute];
	BOOL flag1 = [root addChild:atChild1 forKey:@"tommy" autoRename:YES];
	BOOL flag2 = [root addChild:atChild2 forKey:@"dave" autoRename:YES];
	STAssertTrue(flag1,@"e"); STAssertTrue(flag2,@"e");

	STAssertTrue(atChild2==[root inputAttributeWithKey:@"dave"], @"should be equal");	
	
	[atChild1 setName:@"rupert"];
	STAssertTrue(atChild1==[root inputAttributeWithKey:@"rupert"], @"should be equal");
}

// ===========================================================
// - testOutputAttributeWithKey
// ===========================================================
- (void)testOutputAttributeWithKey
{
	// - (id<SHAttributeProtocol>)outputAttributeWithKey:(NSString*)key
	SHNode* root = [_nodeGraphModel rootNodeGroup];
	SHOutputAttribute* atChild1 = [SHOutputAttribute makeAttribute];
	SHOutputAttribute* atChild2 = [SHOutputAttribute makeAttribute];
	[root addChild:atChild1 forKey:@"tommy" autoRename:YES];
	[root addChild:atChild2 forKey:@"dave" autoRename:YES];

	STAssertTrue(atChild1==[root outputAttributeWithKey:@"tommy"], @"%@", atChild1);	
	STAssertTrue(atChild2==[root outputAttributeWithKey:@"dave"], @"%@", atChild1);	

	[atChild1 setName:@"rupert"];
	STAssertTrue(atChild1==[root outputAttributeWithKey:@"rupert"], @"%@", [root inputAttributeWithKey:@"rupert"]);	
}


@end
