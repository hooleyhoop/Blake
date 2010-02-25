//
//  SHChildTests.m
//  SHNodeGraph
//
//  Created by steve hooley on 22/04/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "SHChild.h"
#import "SHChild.h"
#import "NodeName.h"

@interface SHChildTests : SenTestCase {
	
	SHChild *child;
	NSUndoManager *um;
}

@end

@implementation SHChildTests

- (void)setUp {

	child = [[SHChild alloc] init];
	[child changeNameWithStringTo:@"Steve" fromParent:nil undoManager:nil];
	STAssertTrue(child.parentSHNode==nil, @"fuck");
	STAssertTrue(child.operatorPrivateMember==NO, @"fuck");
	um = [[NSUndoManager alloc] init];
}

- (void)tearDown {

	[child release];
	[um removeAllActions];
	[um release];
}

- (void)testCopy {
	
	SHChild *child2 = [[child copy] autorelease];
	STAssertNotNil(child2, @"ooch");
	STAssertFalse(child2==child, @"christ");
	STAssertTrue([child2.name isEqualToNodeName:child.name], @"copy should have copied name");
	// STAssertFalse(child2.name==child.name, @"christ");
	STAssertTrue([child2.name.value isEqualToString:child.name.value], @"copy should have copied name");
	STAssertTrue(child2->_operatorPrivateMember==child->_operatorPrivateMember, @"copy should have _operatorPrivateMember");
}

- (void)testEncodeDecode {
	
	NSData *archive = [NSKeyedArchiver archivedDataWithRootObject:child];
	STAssertNotNil(archive, @"ooch");
	
	SHChild *child2 = [NSKeyedUnarchiver unarchiveObjectWithData:archive];
	STAssertNotNil(child2, @"ooch");
	STAssertTrue( [child.name isEqualTo:child2.name], @"cock %@ = %@", child.name, child2.name );
	STAssertTrue( [child isEquivalentTo:child2], @"cock %@ = %@", child.name, child2.name );
	STAssertTrue(child2.parentSHNode==nil, @"fuck");
	STAssertTrue(child2.operatorPrivateMember==NO, @"fuck");
}

- (void)testIsEquivalentTo {
	// - (BOOL)isEquivalentTo:(id)anObject

	SHChild *child2 = [SHChild makeChildWithName:@"fattyBingbing"];
	child2.operatorPrivateMember = YES;
	child2.nodeGraphModel = [OCMockObject mockForProtocol:@protocol(GraphLikeProtocol)];
	STAssertFalse([child2 isEquivalentTo:self], @"BleedingArse");
	STAssertFalse([child2 isEquivalentTo:child], @"BleedingArse");
	child2.operatorPrivateMember = child.operatorPrivateMember;
	
	/* Truth is i dont know what should be equivalent */
	STAssertFalse([child2 isEquivalentTo:child], @"BleedingArse");
	
	[child2 changeNameTo:child.name fromParent:nil undoManager:nil];
	STAssertTrue([child2 isEquivalentTo:child], @"BleedingArse");
	
	/* This depends on whether the names must be equivalent for the objects to be equivalent */
	child2.nodeGraphModel = child.nodeGraphModel;
	STAssertTrue([child2 isEquivalentTo:child], @"BleedingArse");
	
	child2.operatorPrivateMember = YES;
	STAssertFalse([child2 isEquivalentTo:child], @"BleedingArse");
}

- (void)testIsNodeParentOfMe {
	// - (BOOL)isNodeParentOfMe:(id<SHParentLikeProtocol>)aNode;

	id mockParent1 = [OCMockObject mockForProtocol:@protocol(SHParentLikeProtocol)];

	STAssertFalse([child isNodeParentOfMe: mockParent1], @"node should be a parent");
	child.parentSHNode = mockParent1;
	STAssertTrue([child isNodeParentOfMe: mockParent1], @"node should be a parent");
}

- (void)testChangeNameWithStringToFromParent {
	// - (BOOL)changeNameWithStringTo:(NSString *)aNameStr fromParent:(NSObject<SHParentLikeProtocol> *)parent;
	
	// try with no parent
	SHChild *child2 = [SHChild makeChildWithName:@"Steve"];
	int hash1 = [child2 hash];
	BOOL success = [child2 changeNameWithStringTo:@"Dave" fromParent:nil undoManager:nil];
	STAssertTrue(success, @"Should have changed name");
	STAssertTrue([child2.name.value isEqualToString:@"Dave"], @"Should have changed name");
	int hash2 = [child2 hash];
	STAssertEquals(hash1, hash2, @"changing the name shouldn't change the hash");
	int hash3 = [child hash];
	STAssertFalse(hash3==hash2, @"changing the name shouldn't change the hash");

	STAssertFalse([child2 changeNameWithStringTo:@"." fromParent:nil undoManager:nil], @"illegal");

	// try with a parent
	id mockParent = [OCMockObject mockForProtocol:@protocol(SHParentLikeProtocol)];
	child2.parentSHNode = mockParent;
	BOOL bakedResult = NO;
	[[[mockParent expect] andReturnValue:OCMOCK_VALUE(bakedResult)] isNameUsedByChild:@"Flo"]; // NB! use 'andReturnValue' for primitives : 'andReturn' for objects
	[um beginUndoGrouping];
	success = [child2 changeNameWithStringTo:@"Flo" fromParent:mockParent undoManager:um];
	[um endUndoGrouping];
	STAssertTrue(success, @"Should have changed name");
	STAssertTrue([child2.name.value isEqualToString:@"Flo"], @"Should have changed name");
	
	bakedResult = YES;
	[[[mockParent expect] andReturnValue:OCMOCK_VALUE(bakedResult)] isNameUsedByChild:@"Steve"]; // NB! use 'andReturnValue' for primitives : 'andReturn' for objects
	STAssertThrows( [child2 changeNameWithStringTo:@"Steve" fromParent:mockParent undoManager:um], @"should be illegal");
	STAssertFalse([child2.name.value isEqualToString:@"Steve"], @"Should have changed name");
	
	/* Test Undo */
	[um undo];
	STAssertTrue([child2.name.value isEqualToString:@"Dave"], @"Should have changed name %@", child2.name.value);
	
	[um redo];
	STAssertTrue([child2.name.value isEqualToString:@"Flo"], @"Should have changed name %@", child2.name.value);	
}

- (void)testChangeNameToFromParent {
	// - (BOOL)changeNameTo:(NodeName *)aName fromParent:(NSObject<SHParentLikeProtocol> *)parent undoManager:(NSUndoManager *)um;
	
	// try without a parent
	SHChild *child2 = [SHChild makeChildWithName:@"Steve"];
	NodeName *newName = [NodeName makeNameWithString:@"Dave"];
	BOOL success = [child2 changeNameTo:newName fromParent:nil undoManager:nil];
	STAssertTrue(success, @"Should have changed name");
	STAssertTrue([child2.name.value isEqualToString:@"Dave"], @"Should have changed name");
	
	// try with a parent
	id mockParent = [OCMockObject mockForProtocol:@protocol(SHParentLikeProtocol)];
	child2.parentSHNode = mockParent;
	BOOL bakedResult = NO;
	[[[mockParent expect] andReturnValue:OCMOCK_VALUE(bakedResult)] isNameUsedByChild:@"Flo"]; // NB! use 'andReturnValue' for primitives : 'andReturn' for objects
	[um beginUndoGrouping];
		success = [child2 changeNameTo:[NodeName makeNameWithString:@"Flo"] fromParent:mockParent undoManager:um];
	[um endUndoGrouping];
	STAssertTrue(success, @"Should have changed name");
	STAssertTrue([child2.name.value isEqualToString:@"Flo"], @"Should have changed name");

	bakedResult = YES;
	[[[mockParent expect] andReturnValue:OCMOCK_VALUE(bakedResult)] isNameUsedByChild:@"Steve"]; // NB! use 'andReturnValue' for primitives : 'andReturn' for objects
	STAssertThrows( [child2 changeNameTo:[NodeName makeNameWithString:@"Steve"] fromParent:mockParent undoManager:um], @"should be illegal");
	STAssertFalse([child2.name.value isEqualToString:@"Steve"], @"Should have changed name");
	
	/* Test Undo */
	[um undo];
	STAssertTrue([child2.name.value isEqualToString:@"Dave"], @"Should have changed name %@", child2.name.value);

	[um redo];
	STAssertTrue([child2.name.value isEqualToString:@"Flo"], @"Should have changed name %@", child2.name.value);
}

- (void)testRootNode {
	//- (SHChild *)rootNode 

	STAssertEqualObjects( [child rootNode], child, @"eh?");

	id mockParent = [OCMockObject mockForProtocol:@protocol(SHParentLikeProtocol)];
	child.parentSHNode = mockParent;
	[[[mockParent expect] andReturn:mockParent] rootNode]; // NB! use 'andReturnValue' for primitives : 'andReturn' for objects
	STAssertEqualObjects( [child rootNode], mockParent, @"eh?");
}

- (void)testNodeGraphModel {
	// - (NSObject<GraphLikeProtocol> *)nodeGraphModel
	
	id mockGraph = [OCMockObject mockForProtocol:@protocol(GraphLikeProtocol)];
	id mockParent = [OCMockObject mockForProtocol:@protocol(SHParentLikeProtocol)];
	child.parentSHNode = mockParent;
	[[[mockParent expect] andReturn:mockParent] rootNode];
	[[[mockParent expect] andReturn:mockGraph] nodeGraphModel];
	STAssertEqualObjects( [child nodeGraphModel], mockGraph, @"eh?");
}

- (void)testIsAboutToBeDeletedFromParentSHNode {
	//- (void)isAboutToBeDeletedFromParentSHNode

	STAssertThrows([child isAboutToBeDeletedFromParentSHNode], @"should NOT be valid when no parent");
	id mockParent = [OCMockObject mockForProtocol:@protocol(SHParentLikeProtocol)];
	child.parentSHNode = mockParent;
	STAssertNoThrow([child isAboutToBeDeletedFromParentSHNode], @"should NOT be valid when no parent");
}

- (void)testHasBeenAddedToParentSHNode {
	//- (void)hasBeenAddedToParentSHNode

	STAssertThrows([child hasBeenAddedToParentSHNode], @"should NOT be valid when no parent");
	id mockParent = [OCMockObject mockForProtocol:@protocol(SHParentLikeProtocol)];
	child.parentSHNode = mockParent;
	STAssertNoThrow([child hasBeenAddedToParentSHNode], @"should NOT be valid when no parent");
}
@end
