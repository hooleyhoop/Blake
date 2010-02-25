//
//  NodeNameTests.m
//  SHNodeGraph
//
//  Created by steve hooley on 26/02/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//


#import "NodeName.h"
#import "SHChildContainer.h"
#import "SHChild.h"
#import "SHParent.h"

@interface NodeNameTests : SenTestCase {
	
}

@end

@implementation NodeNameTests

- (void)setUp {
}

- (void)tearDown {
}

- (void)testmakeNameWithString {
	// + (id)makeNameWithString:(NSString *)nameStr
	
	NodeName *name1 = [NodeName makeNameWithString:@"Steve"];
	STAssertNotNil(name1, @"ooch");
	STAssertTrue([@"Steve" isEqualToString:name1.value], @"should be");
	
	NodeName *name2 = [NodeName makeNameWithString:@"$Steve"];
	STAssertNil(name2, @"ooch");
}

- (void)testmakeNameBasedOnClass {
	// + (id)makeNameBasedOnClass:(Class *)objClass

	NodeName *name1 = [NodeName makeNameBasedOnClass:[self class]];
	STAssertTrue( [name1.value isEqualToString:@"NodeNameTests1"], @"Doh %@", name1.value );
}

- (void)testCopy {

	NodeName *name1 = [NodeName makeNameWithString:@"Steve"];
	NodeName *name2 = [[name1 copy] autorelease];
	STAssertNotNil(name2, @"ooch");
	STAssertTrue([name2 isEqualToNodeName:name1], @"should be");
	
	// As long as names are immutable then copies smay be the same pointer
	// STAssertFalse(name2==name1, @"should be");
}

- (void)testIsEqual {
	// - (BOOL)isEqual:(id)other
	
	NodeName *name1 = [NodeName makeNameWithString:@"Steve"];
	STAssertTrue( [name1 isEqual:name1], @"should be");
	STAssertFalse( [name1 isEqual:self], @"should be");
	
	// should this return false or fail?
	STAssertThrows( [name1 isEqual:nil], @"should be");
}

- (void)testIsEqualToNodeName {
//- (BOOL)isEqualToNodeName:(NodeName *)aName
	
	NodeName *name1 = [NodeName makeNameWithString:@"Steve"];
	STAssertFalse( [name1 isEqualToNodeName:(NodeName *)self], @"should be");
	STAssertTrue([name1 isEqualToNodeName:name1], @"should be");
	
	NodeName *name2 = [[name1 copy] autorelease];
	STAssertTrue([name2 isEqualToNodeName:name1], @"should be");
	STAssertFalse([name2 isEqualToNodeName:(NodeName *)self], @"should be");
	STAssertFalse( [name2 isEqualToNodeName:[NodeName makeNameWithString:@"RubyTuesday"]], @"should be");
}

- (void)testEncodeDecode {
	
	NodeName *name1 = [NodeName makeNameWithString:@"Steve"];
	NSData *archive = [NSKeyedArchiver archivedDataWithRootObject:name1];
	STAssertNotNil(archive, @"ooch");
					   
	NodeName *name2 = [NSKeyedUnarchiver unarchiveObjectWithData:archive];
	STAssertNotNil(name2, @"ooch");
	
	STAssertTrue( [name1.value isEqualToString:name2.value], @"cock %@ = %@", name1.value, name2.value );
	STAssertEqualObjects(name1, name2, @"Fuck - names should be the same");
	
	STAssertTrue(name1.hash==name2.hash, @"Hash must be equal");
}

// names inAtt1, inAtt2, inAtt3 already exist. Try to transform inAtt1 into 3 sensible names
- (void)testUniqueChildNamesBasedOnForSet {
	// + (NSArray *)uniqueChildNamesBasedOn:(NSArray *)nameStrings forSet:(SHChildContainer *)container;
	
	NSArray *startingFileNames = [NSArray arrayWithObjects:[NodeName makeNameWithString:@"inAtt1"], [NodeName makeNameWithString:@"inAtt1"], [NodeName makeNameWithString:@"inAtt1"], nil];
	
	// set up already existing objects
	SHChildContainer *container = [[[SHChildContainer alloc] init] autorelease];
	SHChild *inAtt1 = [SHChild makeChildWithName:@"inAtt1"], *inAtt2=[SHChild makeChildWithName:@"inAtt2"], *inAtt3=[SHChild makeChildWithName:@"inAtt3"];
	NSArray *inputs = [NSArray arrayWithObjects:inAtt1, inAtt2, inAtt3, nil];
	NSArray *keys = [NSArray arrayWithObjects:[inAtt1 name].value, [inAtt2 name].value, [inAtt3 name].value, nil];
	NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,3)];
	[container _addInputs:inputs atIndexes:indexes withKeys:keys undoManager:nil];
	
	// try to generate some new names based on these
	NSArray *uniqueNames = [NodeName uniqueChildNamesBasedOn:startingFileNames forSet:container];
	STAssertTrue( [[[uniqueNames objectAtIndex:0] value] isEqualToString:@"inAtt4"], @"no way %@", [[uniqueNames objectAtIndex:0] value] );
	STAssertTrue( [[[uniqueNames objectAtIndex:1] value] isEqualToString:@"inAtt5"], @"no way %@", [[uniqueNames objectAtIndex:1] value] );
	STAssertTrue( [[[uniqueNames objectAtIndex:2] value] isEqualToString:@"inAtt6"], @"no way %@", [[uniqueNames objectAtIndex:2] value] );
}

- (void)testStringsFromNodeNames {
	//+ (NSArray *)stringsFromNodeNames:(NSArray *)nodeNames

	NSArray *startingFileNames = [NSArray arrayWithObjects:[NodeName makeNameWithString:@"inAtt1"], [NodeName makeNameWithString:@"inAtt2"], [NodeName makeNameWithString:@"inAtt3"], nil];
	NSArray *asStrings = [NodeName stringsFromNodeNames:startingFileNames];
	
	STAssertTrue( [[asStrings objectAtIndex:0] isEqualToString:@"inAtt1"], @"no way %@", [asStrings objectAtIndex:0] );
	STAssertTrue( [[asStrings objectAtIndex:1] isEqualToString:@"inAtt2"], @"no way %@", [asStrings objectAtIndex:1] );
	STAssertTrue( [[asStrings objectAtIndex:2] isEqualToString:@"inAtt3"], @"no way %@", [asStrings objectAtIndex:2] );
}

- (void)testNodeNamesFromStrings {
	//+ (NSArray *)nodeNamesFromStrings:(NSArray *)nodeNames;
	
	NSArray *startingNames = [NSArray arrayWithObjects:@"inAtt1", @"inAtt2", @"inAtt3", nil];
	NSArray *asNodeNames = [NodeName nodeNamesFromStrings:startingNames];
	
	STAssertTrue( [[[asNodeNames objectAtIndex:0] value] isEqualToString:@"inAtt1"], @"no way %@", [[asNodeNames objectAtIndex:0] value] );
	STAssertTrue( [[[asNodeNames objectAtIndex:1] value] isEqualToString:@"inAtt2"], @"no way %@", [[asNodeNames objectAtIndex:1] value] );
	STAssertTrue( [[[asNodeNames objectAtIndex:2] value] isEqualToString:@"inAtt3"], @"no way %@", [[asNodeNames objectAtIndex:2] value] );
}

- (void)testCurrentOrNewNamesForNodes {
// + (NSArray *)currentOrNewNamesForNodes:(NSArray *)objects

	NSArray *itemsToAdd = [NSArray arrayWithObjects:[SHChild makeChildWithName:@"Node1"], [[[SHChild alloc] init] autorelease], nil];
	NSArray *placeHolderNames = [NodeName currentOrNewNamesForNodes:itemsToAdd];
	STAssertTrue( [[[placeHolderNames objectAtIndex:0] value] isEqualToString:@"Node1"], @"no way %@", [[placeHolderNames objectAtIndex:0] value] );
	STAssertTrue( [[[placeHolderNames objectAtIndex:1] value] isEqualToString:@"SHChild1"], @"no way %@", [[placeHolderNames objectAtIndex:1] value] );
}

- (void)test_setNamesOfObjects {
	// + (void)_setNamesOfObjects:(NSArray *)objects toNames:(NSArray *)nodeNames withUndoManager:(NSUndoManager *)um;
	
	NSUndoManager *um = [[NSUndoManager alloc] init];

	SHParent *node1 = [SHParent makeChildWithName:@"1"];
	SHParent *node2 = [SHParent makeChildWithName:@"2"];
	NSArray *itemsToAdd = [NSArray arrayWithObjects:node1, node2, nil];
	NSArray *newNames = [NSArray arrayWithObjects:[NodeName makeNameWithString:@"Steve"], [NodeName makeNameWithString:@"Terrance"], nil];
	[NodeName _setNamesOfObjects:itemsToAdd toNames:newNames withUndoManager:um];
	STAssertTrue( [[[node1 name] value] isEqualToString:@"Steve"], @"should be %@", [[node1 name] value] );
	STAssertTrue( [[[node2 name] value] isEqualToString:@"Terrance"], @"should be %@", [[node2 name] value] );

	[um undo];
	STAssertTrue( [[[node1 name] value] isEqualToString:@"1"], @"should be %@", [[node1 name] value] );
	STAssertTrue( [[[node2 name] value] isEqualToString:@"2"], @"should be %@", [[node2 name] value] );
	
	[um redo];
	STAssertTrue( [[[node1 name] value] isEqualToString:@"Steve"], @"should be %@", [[node1 name] value] );
	STAssertTrue( [[[node2 name] value] isEqualToString:@"Terrance"], @"should be %@", [[node2 name] value] );
	
	[um removeAllActions];
	[um release];
}

- (void)testGetNewUniqueID {
// + (NSUInteger)getNewUniqueID;
	NSUInteger newId = [NodeName getNewUniqueID];
	STAssertTrue( [NodeName getNewUniqueID]==newId+1, @"doh");
	STAssertTrue( [NodeName getNewUniqueID]==newId+2, @"doh");
}

- (void)testDescription {
	// - (NSString *)description
	
	NodeName *name1 = [NodeName makeNameWithString:@"Steve"];
	NSString *targetDescription = [NSString stringWithFormat:@"<NodeName: %p> - Steve", name1];
	STAssertTrue([[name1 description] isEqualToString:targetDescription], @"doh is *%@*", [name1 description]);
}

@end
