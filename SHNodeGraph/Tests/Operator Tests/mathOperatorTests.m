//
//  mathOperatorTests.m
//  SHNodeGraph
//
//  Created by Steve Hooley on 01/10/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import <SHNodeGraph/SHNodeGraph.h>
#import "SHPlusOperator.h"
#import "SHInputAttribute.h"
#import "SHOutputAttribute.h"
#import "SHPlusOperator.h"
#import "SHMinusOperator.h"
#import "SHMultiplyOperator.h"
#import "SHDivideOperator.h"
#import "SHAbsOperator.h"
#import "SHInterConnector.h"
#import "SHNodeAttributeMethods.h"

@interface mathOperatorTests : SenTestCase {
	
	SHNodeGraphModel *_nodeGraphModel;
	
}

@implementation mathOperatorTests

// ===========================================================
// - setUp
// ===========================================================
- (void)setUp
{
    _nodeGraphModel =  [[SHNodeGraphModel makeEmptyModel] retain];
	STAssertNotNil(_nodeGraphModel, @"mathOperatorTests ERROR.. Couldnt make a nodeModel");
}


- (void)tearDown
{
	[_nodeGraphModel release];
	_nodeGraphModel = nil;
}

- (void)testCopyWithZone
{
	SHPlusOperator* op = [[[SHPlusOperator alloc] init] autorelease];
	[(SHNode *)op setName:@"plus1"];

	[(SHInputAttribute *)[op inputAttributeAtIndex:0] publicSetValue:@"4"];
	[(SHInputAttribute *)[op inputAttributeAtIndex:1] publicSetValue:@"3"];	

	SHNode* plus2 = [[op copy] autorelease];
	BOOL flag = [op isEquivalentTo: plus2];
	STAssertTrue(flag==YES, @"should be roughly the same");
}

- (void)testIsEquivalentTo
{
	// - (BOOL)isEquivalentTo:(id)anObject
	SHPlusOperator* op1 = [[[SHPlusOperator alloc] init] autorelease];	
	SHPlusOperator* op2 = [[[SHPlusOperator alloc] init] autorelease];	
	[(SHInputAttribute *)[op1 inputAttributeAtIndex:0] publicSetValue:@"4"];
	[(SHInputAttribute *)[op1 inputAttributeAtIndex:1] publicSetValue:@"3"];	
	[(SHInputAttribute *)[op2 inputAttributeAtIndex:0] publicSetValue:@"4"];
	[(SHInputAttribute *)[op2 inputAttributeAtIndex:1] publicSetValue:@"3"];	
	BOOL flag = [op1 isEquivalentTo: op2];
	STAssertTrue(flag==YES, @"should be roughly the same");
}

// ===========================================================
// - testPlusOperator
// ===========================================================
- (void)testPlusOperator
{
	NSError* error=nil;

	SHNode* root = [_nodeGraphModel rootNodeGroup];
	SHInputAttribute* inAtt1 = [SHInputAttribute attributeWithType:@"SHNumber"];
	SHInputAttribute* inAtt2 = [SHInputAttribute attributeWithType:@"SHNumber"];
	SHOutputAttribute* outAtt1 = [SHOutputAttribute attributeWithType:@"SHNumber"];

	[root addChild:inAtt1 autoRename:YES];
	[root addChild:inAtt2 autoRename:YES];
	[root addChild:outAtt1 autoRename:YES];
//	[inAtt1 setDataType:@"SHNumber"];
//	[inAtt2 setDataType:@"SHNumber"];
//	[outAtt1 setDataType:@"SHNumber"];
	SHPlusOperator* op = [[[SHPlusOperator alloc] init] autorelease];
	[root addChild:op autoRename:YES];
	
	SHInterConnector* connector1 = [[[SHInterConnector alloc] init] autorelease];
	SHInterConnector* connector2 = [[[SHInterConnector alloc] init] autorelease];
	SHInterConnector* connector3 = [[[SHInterConnector alloc] init] autorelease];
	
	BOOL flag1 = [inAtt1 connectOutletToInletOf:(SHAttribute*)[op inputAttributeAtIndex:0] withConnector:connector1];
	BOOL flag2 = [inAtt2 connectOutletToInletOf:(SHAttribute*)[op inputAttributeAtIndex:1] withConnector:connector2];
	BOOL flag3 = [(SHAttribute*)[op outputAttributeAtIndex:0] connectOutletToInletOf:outAtt1 withConnector:connector3];
	
	STAssertTrue(flag1==YES, @"failed to connect 2 attributes of type SHNumber");
	STAssertTrue(flag2==YES, @"failed to connect 2 attributes of type SHNumber");
	STAssertTrue(flag3==YES, @"failed to connect 2 attributes of type SHNumber");

	[inAtt1 publicSetValue:@"4"];
	[inAtt2 publicSetValue:@"3"];	
	NSObject<SHValueProtocol>* val1 = [outAtt1 upToDateEvaluatedValue:random() head:nil error:&error];
	STAssertTrue([[val1 displayObject] isEqualToString:@"7"], @"should be 7 but is %@", [val1 displayObject]  );
//	[_nodeGraphModel closeCurrentRootNode];
}

// ===========================================================
// - testMinusOperator
// ===========================================================
- (void) testMinusOperator
{
	NSError* error=nil;
	SHNode* root = [_nodeGraphModel rootNodeGroup];
	SHInputAttribute* inAtt1 = [SHInputAttribute makeAttribute];
	SHInputAttribute* inAtt2 = [SHInputAttribute makeAttribute];
	SHOutputAttribute* outAtt1 = [SHOutputAttribute makeAttribute];
	[root addChild:inAtt1 autoRename:YES];
	[root addChild:inAtt2 autoRename:YES];
	[root addChild:outAtt1 autoRename:YES];
	[inAtt1 setDataType:@"SHNumber"];
	[inAtt2 setDataType:@"SHNumber"];
	[outAtt1 setDataType:@"SHNumber"];
	SHMinusOperator* op = [[[SHMinusOperator alloc] init] autorelease];	
	[root addChild:op autoRename:YES];
	
	SHInterConnector* connector1 = [[[SHInterConnector alloc] init] autorelease];
	SHInterConnector* connector2 = [[[SHInterConnector alloc] init] autorelease];
	SHInterConnector* connector3 = [[[SHInterConnector alloc] init] autorelease];
	
	BOOL flag1 = [inAtt1 connectOutletToInletOf:(SHAttribute*)[op inputAttributeAtIndex:0] withConnector:connector1];
	BOOL flag2 = [inAtt2 connectOutletToInletOf:(SHAttribute*)[op inputAttributeAtIndex:1] withConnector:connector2];
	BOOL flag3 = [(SHAttribute*)[op outputAttributeAtIndex:0] connectOutletToInletOf:outAtt1 withConnector:connector3];
	
	STAssertTrue(flag1==YES, @"failed to connect 2 attributes of type SHNumber");
	STAssertTrue(flag2==YES, @"failed to connect 2 attributes of type SHNumber");
	STAssertTrue(flag3==YES, @"failed to connect 2 attributes of type SHNumber");
	
	[inAtt1 publicSetValue:@"4"];
	[inAtt2 publicSetValue:@"3"];	
	NSObject<SHValueProtocol>* val1 = [outAtt1 upToDateEvaluatedValue:random() head:nil error:&error];
	STAssertTrue([[val1 displayObject] isEqualToString:@"1"], @"should be 1 but is %@", [val1 displayObject]  );
//	[_nodeGraphModel closeCurrentRootNode];	
}

// ===========================================================
// - testMultiplyOperator
// ===========================================================
- (void) testMultiplyOperator
{
	NSError* error=nil;

	SHNode* root = [_nodeGraphModel rootNodeGroup];
	SHInputAttribute* inAtt1 = [SHInputAttribute makeAttribute];
	SHInputAttribute* inAtt2 = [SHInputAttribute makeAttribute];
	SHOutputAttribute* outAtt1 = [SHOutputAttribute makeAttribute];
	[root addChild:inAtt1 autoRename:YES];
	[root addChild:inAtt2 autoRename:YES];
	[root addChild:outAtt1 autoRename:YES];
	[inAtt1 setDataType:@"SHNumber"];
	[inAtt2 setDataType:@"SHNumber"];
	[outAtt1 setDataType:@"SHNumber"];
	SHMultiplyOperator* op = [[[SHMultiplyOperator alloc] init] autorelease];	
	[root addChild:op autoRename:YES];
	
	SHInterConnector* connector1 = [[[SHInterConnector alloc] init] autorelease];
	SHInterConnector* connector2 = [[[SHInterConnector alloc] init] autorelease];
	SHInterConnector* connector3 = [[[SHInterConnector alloc] init] autorelease];
	
	BOOL flag1 = [inAtt1 connectOutletToInletOf:(SHAttribute*)[op inputAttributeAtIndex:0] withConnector:connector1];
	BOOL flag2 = [inAtt2 connectOutletToInletOf:(SHAttribute*)[op inputAttributeAtIndex:1] withConnector:connector2];
	BOOL flag3 = [(SHAttribute*)[op outputAttributeAtIndex:0] connectOutletToInletOf:outAtt1 withConnector:connector3];
	
	STAssertTrue(flag1==YES, @"failed to connect 2 attributes of type SHNumber");
	STAssertTrue(flag2==YES, @"failed to connect 2 attributes of type SHNumber");
	STAssertTrue(flag3==YES, @"failed to connect 2 attributes of type SHNumber");
	
	[inAtt1 publicSetValue:@"4"];
	[inAtt2 publicSetValue:@"3"];	
	NSObject<SHValueProtocol>* val1 = [outAtt1 upToDateEvaluatedValue:random() head:nil error:&error];
	STAssertTrue([[val1 displayObject] isEqualToString:@"12"], @"should be 12 but is %@", [val1 displayObject]  );
//	[_nodeGraphModel closeCurrentRootNode];	
	
}

// ===========================================================
// - testDivideOperator
// ===========================================================
- (void)testDivideOperator
{
	NSError* error=nil;

	SHNode* root = [_nodeGraphModel rootNodeGroup];
	SHInputAttribute* inAtt1 = [SHInputAttribute makeAttribute];
	SHInputAttribute* inAtt2 = [SHInputAttribute makeAttribute];
	SHOutputAttribute* outAtt1 = [SHOutputAttribute makeAttribute];
	[root addChild:inAtt1 autoRename:YES];
	[root addChild:inAtt2 autoRename:YES];
	[root addChild:outAtt1 autoRename:YES];
	[inAtt1 setDataType:@"SHNumber"];
	[inAtt2 setDataType:@"SHNumber"];
	[outAtt1 setDataType:@"SHNumber"];
	SHDivideOperator* op = [[[SHDivideOperator alloc] init] autorelease];	
	[root addChild:op autoRename:YES];
	
	SHInterConnector* connector1 = [[[SHInterConnector alloc] init] autorelease];
	SHInterConnector* connector2 = [[[SHInterConnector alloc] init] autorelease];
	SHInterConnector* connector3 = [[[SHInterConnector alloc] init] autorelease];
	
	BOOL flag1 = [inAtt1 connectOutletToInletOf:(SHAttribute*)[op inputAttributeAtIndex:0] withConnector:connector1];
	BOOL flag2 = [inAtt2 connectOutletToInletOf:(SHAttribute*)[op inputAttributeAtIndex:1] withConnector:connector2];
	BOOL flag3 = [(SHAttribute*)[op outputAttributeAtIndex:0] connectOutletToInletOf:outAtt1 withConnector:connector3];
	
	STAssertTrue(flag1==YES, @"failed to connect 2 attributes of type SHNumber");
	STAssertTrue(flag2==YES, @"failed to connect 2 attributes of type SHNumber");
	STAssertTrue(flag3==YES, @"failed to connect 2 attributes of type SHNumber");
	
	[inAtt1 publicSetValue:@"12"];
	[inAtt2 publicSetValue:@"3"];	
	NSObject<SHValueProtocol>* val1 = [outAtt1 upToDateEvaluatedValue:random() head:nil error:&error];
	STAssertTrue([[val1 displayObject] isEqualToString:@"4"], @"should be 1 but is %@", [val1 displayObject]  );
//	[_nodeGraphModel closeCurrentRootNode];	
	
}

// ===========================================================
// - testAbsOperator
// ===========================================================
- (void)testAbsOperator
{
	NSError* error=nil;

	SHNode* root = [_nodeGraphModel rootNodeGroup];
	SHInputAttribute* inAtt1 = [SHInputAttribute makeAttribute];
	SHOutputAttribute* outAtt1 = [SHOutputAttribute makeAttribute];
	[root addChild:inAtt1 autoRename:YES];
	[root addChild:outAtt1 autoRename:YES];
	[inAtt1 setDataType:@"SHNumber"];
	[outAtt1 setDataType:@"SHNumber"];
	SHAbsOperator* op = [[[SHAbsOperator alloc] init] autorelease];	
	[root addChild:op autoRename:YES];
	
	SHInterConnector* connector1 = [[[SHInterConnector alloc] init] autorelease];
	SHInterConnector* connector2 = [[[SHInterConnector alloc] init] autorelease];
	
	BOOL flag1 = [inAtt1 connectOutletToInletOf:(SHAttribute*)[op inputAttributeAtIndex:0] withConnector:connector1];
	BOOL flag2 = [(SHAttribute*)[op outputAttributeAtIndex:0] connectOutletToInletOf:outAtt1 withConnector:connector2];
	
	STAssertTrue(flag1==YES, @"failed to connect 2 attributes of type SHNumber");
	STAssertTrue(flag2==YES, @"failed to connect 2 attributes of type SHNumber");

	[inAtt1 publicSetValue:@"-12"];

	NSObject<SHValueProtocol>* val1 = [outAtt1 upToDateEvaluatedValue:random() head:nil error:&error];
	STAssertTrue([[val1 displayObject] isEqualToString:@"12"], @"should be 12 but is %@", [val1 displayObject]  );
//	[_nodeGraphModel closeCurrentRootNode];	
}

@end
