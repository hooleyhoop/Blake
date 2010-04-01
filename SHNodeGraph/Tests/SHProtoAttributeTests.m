//
//  SHProtoAttributeTests.m
//  SHNodeGraph
//
//  Created by steve hooley on 27/02/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "SHProtoInputAttribute.h"
#import "SHProtoOutputAttribute.h"
#import "SHInterConnector.h"
#import "SHConnectlet.h"
#import "NodeName.h"

@interface SHProtoAttributeTests : SenTestCase {
	
}

@end


@implementation SHProtoAttributeTests

- (void)setUp {
}

- (void)tearDown {
}

- (void)testInit {
	//- (id)init
	
	SHProtoAttribute *test = [[[SHProtoAttribute alloc] init] autorelease];
	STAssertNotNil(test.theOutlet, @"doh");
	STAssertNotNil(test.theInlet, @"doh");
}

- (void)testEncodeWithCoder {
	//- (void)encodeWithCoder:(NSCoder *)coder
	//- (id)initWithCoder:(NSCoder *)coder
	
	SHProtoAttribute* i1 = [SHProtoAttribute attributeWithType:@"mockDataType"];	
	[i1 changeNameWithStringTo:@"Delel" fromParent:nil undoManager:nil];

	NSData *archive = [NSKeyedArchiver archivedDataWithRootObject:i1];
	STAssertNotNil(archive, @"ooch");

	SHProtoAttribute *i2 = [NSKeyedUnarchiver unarchiveObjectWithData:archive];
	STAssertNotNil(i2, @"ooch");

	STAssertTrue([i1 isEquivalentTo: i2], @"should be roughly the same");
	STAssertFalse(i1==i2, @"christ");
	STAssertTrue([i1.name isEqualToNodeName:i2.name], @"copy should be straight forward!");
	STAssertFalse(i1.name==i2.name, @"christ");
}

- (void)testCopyWithZone {
	// - (id)copyWithZone:(NSZone *)zone

	/* test an attribute without a value set */
	SHProtoAttribute* i1 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	[i1 changeNameWithStringTo:@"Delel" fromParent:nil undoManager:nil];

	SHProtoAttribute *att2 = [[i1 copy] autorelease];
	STAssertFalse(att2==i1, @"need a copy!");
	STAssertTrue([i1 isEquivalentTo: att2], @"should be roughly the same");
	
	/* test an attribute with a value set */
	NSString *val1 = [NSString stringWithFormat:@"chicken6"];
	[i1 publicSetValue: val1];
	att2 = [[i1 copy] autorelease];
	STAssertTrue([i1 isEquivalentTo: att2], @"should be roughly the same");
	STAssertFalse(i1==att2, @"christ");

	NSString *val2 = [NSString stringWithFormat:@"chicken3"];
	[i1 publicSetValue: val2];
	STAssertFalse([i1 isEquivalentTo: att2], @"should be roughly the same");
	STAssertTrue([i1.name isEqualToNodeName:att2.name], @"copy should be straight forward!");
}

- (void)testIsEquivalentTo {
	// - (BOOL)isEquivalentTo:(id)anObject

	SHProtoInputAttribute* i1 = [SHProtoInputAttribute makeChildWithName:@"boo1"];
	SHProtoInputAttribute* i2 = [SHProtoInputAttribute makeChildWithName:@"boo2"];
	[i1 setDataType:@"mockDataType"];
	SHProtoOutputAttribute* o1 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	
	STAssertTrue( [i1 isEquivalentTo:i2]==NO, @"should have different data types");
	STAssertTrue( [i1 isEquivalentTo:o1]==NO, @"should be different classes");
	STAssertTrue( [i1 isEquivalentTo:self]==NO, @"should be different classes");
	[i2 setDataType:@"mockDataType"];
	[i2 changeNameWithStringTo:@"boo1" fromParent:nil undoManager:nil];
	STAssertTrue([i1 isEquivalentTo:i2], @"should be the same");
	NSString *val1 = [NSString stringWithFormat:@"chicken5"];
	[i1 publicSetValue: val1];
	STAssertTrue(![i1 isEquivalentTo:i2], @"should have different values");
}

- (void)testConnectOutletToInletOfWithConnector {
	// - (BOOL)connectOutletToInletOf:(SHProtoAttribute *)inAttr withConnector:(SHInterConnector *)aConnector
	
	SHInterConnector* testIC = [SHInterConnector makeChildWithName:@"ic1"];
	
	// inAttribute to inAttribute
	SHProtoInputAttribute* inAtt1 = [SHProtoInputAttribute makeChildWithName:@"i1"];
	SHProtoInputAttribute* inAtt2 = [SHProtoInputAttribute makeChildWithName:@"i2"];
	
	// but have not had a type specified
	STAssertTrue([inAtt1 connectOutletToInletOf:inAtt2 withConnector:testIC], @"New Version: can connect attributes with nil type");
	STAssertTrue( [inAtt1 removeInterConnector:testIC], @"yeah" );

	[inAtt1 setDataType:@"mockDataType"];
	[inAtt2 setDataType:@"mockDataType"];
	
	// both should now be clean
	STAssertTrue([inAtt1 connectOutletToInletOf:inAtt2 withConnector:testIC], @"failed to connect 2 inAttributes");
	
	BOOL dirtyFlag1 = [inAtt1 dirtyBit];
	BOOL dirtyFlag2 = [inAtt2 dirtyBit];
	STAssertTrue(dirtyFlag1==NO, @"failed to connect 2 inAttributes");
	STAssertTrue(dirtyFlag2==YES, @"failed to connect 2 inAttributes");
	
	// outAttribute to outAttribute
	SHProtoOutputAttribute* outAtt1 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	SHProtoOutputAttribute* outAtt2 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	
	STAssertTrue([outAtt1 connectOutletToInletOf:outAtt2 withConnector:testIC], @"failed to connect 2 outAttributes");
	dirtyFlag1 = [outAtt1 dirtyBit];
	dirtyFlag2 = [outAtt2 dirtyBit];
	STAssertTrue(dirtyFlag1==NO, @"failed to connect 2 inAttributes");
	STAssertTrue(dirtyFlag2==YES, @"failed to connect 2 inAttributes");
	
	// inAttribute to outAttribute
	SHInterConnector* testIC1 = [SHInterConnector makeChildWithName:@"ic1"];
	STAssertTrue([inAtt1 connectOutletToInletOf:outAtt1 withConnector:testIC1], @"failed to connect 2 outAttributes");
	dirtyFlag1 = [inAtt1 dirtyBit];
	dirtyFlag2 = [outAtt2 dirtyBit];
	STAssertTrue(dirtyFlag1==NO, @"failed to connect 2 inAttributes");
	STAssertTrue(dirtyFlag2==YES, @"failed to connect 2 inAttributes");
	
	// try a duplicate connection
	STAssertFalse([inAtt1 connectOutletToInletOf:outAtt1 withConnector:testIC], @"duplicate connection shouldnt be allowed");
	
	// try a feedback loop
	SHProtoInputAttribute* inAttFeedback = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	SHProtoOutputAttribute* outAttFeedback = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];

	BOOL flagf1 = [inAttFeedback connectOutletToInletOf:outAttFeedback withConnector:testIC];
	BOOL flagf2 = [outAttFeedback connectOutletToInletOf:inAttFeedback withConnector:testIC];
	STAssertTrue(flagf1==YES, @"failed to connect 2 outAttributes");
	STAssertTrue(flagf2==YES, @"failed to connect 2 outAttributes");
	dirtyFlag1 = [inAttFeedback dirtyBit];
	dirtyFlag2 = [outAttFeedback dirtyBit];
	STAssertTrue(dirtyFlag1==YES, @"failed to connect 2 inAttributes");
	STAssertTrue(dirtyFlag2==YES, @"failed to connect 2 inAttributes");
	
	STAssertFalse([inAtt1 connectOutletToInletOf:outAttFeedback withConnector:testIC], @"this ic alerady used..?");
	SHInterConnector* testIC2 = [[[SHInterConnector alloc] init] autorelease];
	STAssertThrows([inAtt1 connectOutletToInletOf:outAttFeedback withConnector:testIC2], @"outAttFeedback already has an input");
}

- (void)testRemoveInterConnector {
	// - (BOOL)removeInterConnector:(SHInterConnector *)aConnector

	SHInterConnector* inter1 = [[[SHInterConnector alloc] init] autorelease];
	SHInterConnector* inter2 = [[[SHInterConnector alloc] init] autorelease];
	SHProtoInputAttribute* spareInAtt1 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	SHProtoInputAttribute* inAtt1 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	SHProtoInputAttribute* inAtt2 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	STAssertFalse([inAtt1 isInletConnected], @"why?");
	STAssertFalse([inAtt1 isOutletConnected], @"why?");
	STAssertFalse([inAtt2 isInletConnected], @"why?");
	STAssertFalse([inAtt2 isOutletConnected], @"why?");
	
	/* Add a connector before we can test */
	BOOL didConnect1 = [inAtt1 connectOutletToInletOf:inAtt2 withConnector:inter1];
	STAssertThrows( [spareInAtt1 connectOutletToInletOf:inAtt2 withConnector:inter2], @"cant hook up 2 connectors into inAtt2" );
	BOOL didConnect2 = [inAtt1 connectOutletToInletOf:spareInAtt1 withConnector:inter2]; // however 2 going out is ok
	
	STAssertTrue(didConnect1==YES, @"dig it");
	STAssertTrue(didConnect2==YES, @"dig it");
	STAssertFalse([inAtt1 isInletConnected], @"why?");
	STAssertTrue([inAtt1 isOutletConnected], @"why?");
	STAssertTrue([inAtt2 isInletConnected], @"why?");
	STAssertFalse([inAtt2 isOutletConnected], @"why?");
	
	/* remove the interconnector */
	BOOL didRemove1 = [inAtt1 removeInterConnector:inter1];
	STAssertTrue(didRemove1, @"failed to remove InterConnector from Attribute");
	STAssertFalse([inAtt1 isInletConnected], @"why?");
	STAssertTrue([inAtt1 isOutletConnected], @"still connected to spareInAtt1");
	STAssertFalse([inAtt2 isInletConnected], @"not connected any more");
	STAssertFalse([inAtt2 isOutletConnected], @"why?");
	
	BOOL didRemove2 = [inAtt2 removeInterConnector:inter1];
	STAssertFalse(didRemove2, @"shouldnt be allowed to remove the same interconnector twice!");
	
	BOOL didRemove3 = [spareInAtt1 removeInterConnector:inter2];
	STAssertTrue(didRemove3, @"failed to remove InterConnector from Attribute");
	
	STAssertFalse([inAtt2 isOutletConnected], @"why?");
}

- (void)testIsInletConnectedIsOutletConnected {
	//- (void)setIsInletConnected:(BOOL)flag
	//- (void)setIsOutletConnected:(BOOL)flag
	//- (BOOL)isOutletConnected
	// - (BOOL)isInletConnected

	// SHInterConnector* test = [[[SHInterConnector alloc] init] autorelease];
	id mockIC = [OCMockObject mockForClass:[SHInterConnector class]];
	BOOL returnValue = YES;
	[[[mockIC expect] andReturnValue:OCMOCK_VALUE(returnValue)] respondsToSelector:@selector(resetNodeSHConnectlets)];

	// inAttribute to inAttribute
	SHProtoInputAttribute* inAtt1 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	SHProtoInputAttribute* inAtt2 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	[[mockIC expect] setOutSHConnectlet:inAtt1.theOutlet];
	[[mockIC expect] setInSHConnectlet:inAtt2.theInlet];

	BOOL flag1 = [inAtt1 connectOutletToInletOf:inAtt2 withConnector:mockIC];
	BOOL flag2 = [inAtt1 isInletConnected];
	BOOL flag3 = [inAtt1 isOutletConnected];
	STAssertTrue(flag1, @"return connectlet state is wrong");
	STAssertTrue(flag2==NO, @"return connectlet state is wrong");
	STAssertTrue(flag3==YES, @"return connectlet state is wrong");
	BOOL flag4 = [inAtt2 isInletConnected];
	BOOL flag5 = [inAtt2 isOutletConnected];	
	STAssertTrue(flag4==YES, @"return connectlet state is wrong");
	STAssertTrue(flag5==NO, @"return connectlet state is wrong");	
}

- (void)testAllConnectedInterConnectors {
	// - (NSMutableArray *)allConnectedInterConnectors

	SHProtoOutputAttribute* outAtt = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	SHProtoInputAttribute* inAtt1 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	SHProtoInputAttribute* inAtt2 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	id mockIC1 = [OCMockObject mockForClass:[SHInterConnector class]];
	id mockIC2 = [OCMockObject mockForClass:[SHInterConnector class]];
	BOOL returnValue = YES;
	[[[mockIC1 expect] andReturnValue:OCMOCK_VALUE(returnValue)] respondsToSelector:@selector(resetNodeSHConnectlets)];
	[[[mockIC2 expect] andReturnValue:OCMOCK_VALUE(returnValue)] respondsToSelector:@selector(resetNodeSHConnectlets)];
	
	[[mockIC1 expect] setOutSHConnectlet:outAtt.theOutlet];
	[[mockIC1 expect] setInSHConnectlet:inAtt1.theInlet];
	
	[[mockIC2 expect] setOutSHConnectlet:inAtt1.theOutlet];
	[[mockIC2 expect] setInSHConnectlet:inAtt2.theInlet];

	STAssertTrue([outAtt connectOutletToInletOf:inAtt1 withConnector:mockIC1], @"New Version: can connect attributes with nil type");
	STAssertTrue([inAtt1 connectOutletToInletOf:inAtt2 withConnector:mockIC2], @"New Version: can connect attributes with nil type");

	NSMutableArray* allICs = [inAtt1 allConnectedInterConnectors];
	STAssertNotNil(allICs, @"failed to get all interconnectors");
	STAssertTrue([allICs count]==2, @"failed to get all interconnectors - %i",[allICs count]);
}

- (void)testAttributeWithType {
	// + (id)attributeWithType:(NSString *)aDataTypeName 

	SHProtoAttribute *att = [SHProtoAttribute attributeWithType:@"mockDataType"];
	STAssertNotNil(att, @"you need a vaild dataType");
}

@end
