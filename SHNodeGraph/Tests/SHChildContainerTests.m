//
//  SHChildContainerTests.m
//  SHNodeGraph
//
//  Created by steve hooley on 25/02/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "SHChildContainer.h"
#import "SHChildContainer_Selection.h"
#import "SHChild.h"
#import "NodeName.h"
#import "SHParent.h"
#import "SHProtoInputAttribute.h"
#import "SHProtoOutputAttribute.h"
#import "SHInterConnector.h"
#import "SHConnectlet.h"

@interface SHChildContainerTests : SenTestCase {
	
	SHChildContainer *container;
	NSUndoManager *um;
}

- (void)resetObservers;

@end


@implementation SHChildContainerTests

- (void)setUp {
	
	container = [[SHChildContainer alloc] init];
	um = [[NSUndoManager alloc] init];
	[self resetObservers];

}

- (void)tearDown {
	
	[um removeAllActions];
	[um release];
	[container release];
}

static int selectionChangeCount=0, interConnectorsChangedCount=0, inputsChangedCount=0, outputsChangedCount=0, nodesChangedCount=0;
static int _allItems_Insertion=0, _allItems_Replacement=0, _allItems_Change=0, _allItems_Removal=0;
static NSIndexSet *_allItems_Insertion_indexes, *_allItems_Removal_indexes;

- (void)resetObservers {
	selectionChangeCount = 0;
	interConnectorsChangedCount=0, inputsChangedCount=0, outputsChangedCount=0, nodesChangedCount=0;
	_allItems_Insertion=0, _allItems_Replacement=0, _allItems_Change=0, _allItems_Removal=0;
	_allItems_Insertion_indexes = nil, _allItems_Removal_indexes = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)vcontext {
	
	NSString *context = (NSString *)vcontext;
	if(context==nil)
		[NSException raise:@"MUST SUPPLY A CONTEXT" format:@"MUST SUPPLY A CONTEXT"];
	id changeKind = [change objectForKey:NSKeyValueChangeKindKey];
	id changeIndexes = [change objectForKey:NSKeyValueChangeIndexesKey];
	
    if( [context isEqualToString:@"SHChildContainerTests"] )
	{
		if( [keyPath isEqualToString:@"allChildren"] ){
			switch ([changeKind intValue]) 
			{
				case NSKeyValueChangeInsertion:
					_allItems_Insertion++;
					_allItems_Insertion_indexes = changeIndexes;
					break;
				case NSKeyValueChangeReplacement:
					_allItems_Replacement++;
					break;
				case NSKeyValueChangeSetting:
					_allItems_Change++;
					break;
				case NSKeyValueChangeRemoval:
					_allItems_Removal++;
					_allItems_Removal_indexes = changeIndexes;
					break;
				default:
					[NSException raise:@"filtered content changed - how?" format:@"filtered content changed - how?"];
			}
		} 
		else if( [keyPath isEqualToString:@"nodesInside.selection"] ){
			selectionChangeCount++;
		} else if([keyPath isEqualToString:@"shInterConnectorsInside.array"]){
			interConnectorsChangedCount++;
		} else if([keyPath isEqualToString:@"nodesInside.array"]){
			nodesChangedCount++;
		} else if([keyPath isEqualToString:@"inputs.array"]){
			inputsChangedCount++;
		} else if([keyPath isEqualToString:@"outputs.array"]){
			outputsChangedCount++;
		}
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

- (void)testInit {
	//- (id)init
	
	STAssertNotNil( [container nodesInside], @"No!");
	STAssertNotNil( [container inputs], @"No!");
	STAssertNotNil( [container outputs], @"No!");
	STAssertNotNil( [container shInterConnectorsInside], @"No!");
}

- (void)testInitWithNodesInputsOutputsIcs {
//- (id)initWithNodes:(SHOrderedDictionary *)nodes inputs:(SHOrderedDictionary *)inputs outputs:(SHOrderedDictionary *)outputs ics:(SHOrderedDictionary *)ics {
	
	SHOrderedDictionary *dict1 = [SHOrderedDictionary dictionary];
	STAssertThrows([[SHChildContainer alloc] initWithNodes:dict1 inputs:dict1 outputs:dict1 ics:dict1], @"This cant be legal?");

	SHOrderedDictionary *dict2 = [SHOrderedDictionary dictionary];
	SHOrderedDictionary *dict3 = [SHOrderedDictionary dictionary];
	SHOrderedDictionary *dict4 = [SHOrderedDictionary dictionary];
	SHChildContainer *cont = [[[SHChildContainer alloc] initWithNodes:dict1 inputs:dict2 outputs:dict3 ics:dict4] autorelease];
	STAssertNotNil(cont, @"der");
}

- (void)testIsEqualToContainer {
	//- (BOOL)isEqualToContainer:(SHChildContainer *)value 
	
	// make 2 equal containers - assert they are the same
	SHChildContainer *container2 = [[[SHChildContainer alloc] init] autorelease];

	/* without ics it is quite easy */
	SHChild *n1 = [SHChild makeChildWithName:@"n1"];
	SHChild *n2 = [SHChild makeChildWithName:@"n1"];
	[container _addNode:n1 atIndex:0 withKey:@"n1" undoManager:um];
	STAssertFalse([container isEqualToContainer:container2], @"yeah");
	[container2 _addNode:n2 atIndex:0 withKey:@"n1" undoManager:um];
	STAssertTrue([container isEqualToContainer:container2], @"yeah");

	SHProtoOutputAttribute *o1 = [SHProtoOutputAttribute makeChildWithName:@"o1"];
	SHProtoOutputAttribute *o2 = [SHProtoOutputAttribute makeChildWithName:@"o1"];
	[container2 _addOutput:o2 atIndex:0 withKey:@"o1" undoManager:um];
	STAssertFalse([container isEqualToContainer:container2], @"yeah");
	[container _addOutput:o1 atIndex:0 withKey:@"o1" undoManager:um];
	STAssertTrue([container isEqualToContainer:container2], @"yeah");

	SHProtoInputAttribute *i1 = [SHProtoInputAttribute makeChildWithName:@"i1"];
	SHProtoInputAttribute *i2 = [SHProtoInputAttribute makeChildWithName:@"i1"];
	[container _addInput:i1 atIndex:0 withKey:@"i1" undoManager:um];
	STAssertFalse([container isEqualToContainer:container2], @"yeah");
	[container2 _addInput:i2 atIndex:0 withKey:@"i1" undoManager:um];
	STAssertTrue([container isEqualToContainer:container2], @"yeah");

	/* when we add ics it gets a bit more tricky */
	// urgg! we need to mimic some of the behavoir of -_makeSHInterConnectorBetweenOutletOf: 

	SHInterConnector *anInterConnector1 = [SHInterConnector makeChildWithName:@"ic1"];
	[container _addInterConnector:anInterConnector1 between:i1 and:o1 undoManager:um];
	id mockParent1 = [OCMockObject mockForProtocol: @protocol(SHParentLikeProtocol)];
	NSArray *expectedValue  = [NSArray arrayWithObject:@"i0"];
	[[[mockParent1 stub] andReturn:expectedValue] indexPathToNode:OCMOCK_ANY];

	[anInterConnector1 setParentSHNode:mockParent1];

	STAssertFalse([container isEqualToContainer:container2], @"yeah");
	
	SHInterConnector *anInterConnector2 = [SHInterConnector makeChildWithName:@"ic1"];
	[container2 _addInterConnector:anInterConnector2 between:i2 and:o2 undoManager:um];
	id mockParent2 = [OCMockObject mockForProtocol: @protocol(SHParentLikeProtocol)];
	[[[mockParent2 stub] andReturn:expectedValue] indexPathToNode:OCMOCK_ANY];
	[anInterConnector2 setParentSHNode:mockParent2];
	
	STAssertTrue([container isEqualToContainer:container2], @"yeah");

	// remove an object from one and assert they are not equal
	[container2 _removeInput:i2 withKey:@"i1" undoManager:nil];
	STAssertFalse([container isEqualToContainer:container2], @"yeah");
}

/* Only parent can copy its container 
	Otherwise whe you copy a tree parents will be wrong, ic's can be connected to nodes outside of this container - what should happen to them? etc. 
 */
//- (void)testCopy {
//	
//	SHChild *n1 = [SHChild makeChildWithName:@"n1"];
//	SHProtoOutputAttribute *o1 = [SHProtoOutputAttribute makeChildWithName:@"o1"];
//	SHProtoInputAttribute *i1 = [SHProtoInputAttribute makeChildWithName:@"i1"];
//	[container _addNode:n1 atIndex:0 withKey:@"n1" undoManager:um];
//	[container _addInput:i1 atIndex:0 withKey:@"i1" undoManager:um];
//	[container _addOutput:o1 atIndex:0 withKey:@"o1" undoManager:um];
//	
//	SHChildContainer *container2 = [[container copy] autorelease];
//	STAssertNotNil(container2, @"ooch");
//	STAssertTrue([container isEqualToContainer:container2], @"yeah");
//	STAssertFalse(container==container2, @"christ");
//	STAssertFalse(container.nodesInside==container2.nodesInside, @"christ");
//	STAssertFalse([container.nodesInside objectAtIndex:0]==[container2.nodesInside objectAtIndex:0], @"christ");
//}

- (void)testEncodeDecode {
	
	SHChild *n1 = [SHChild makeChildWithName:@"n1"];
	SHProtoOutputAttribute *o1 = [SHProtoOutputAttribute makeChildWithName:@"o1"];
	SHProtoInputAttribute *i1 = [SHProtoInputAttribute makeChildWithName:@"i1"];
	[container _addNode:n1 atIndex:0 withKey:@"n1" undoManager:um];
	[container _addInput:i1 atIndex:0 withKey:@"i1" undoManager:um];
	[container _addOutput:o1 atIndex:0 withKey:@"o1" undoManager:um];
	
	NSData *archive = [NSKeyedArchiver archivedDataWithRootObject:container];
	STAssertNotNil(archive, @"ooch");
	
	SHChildContainer *container2 = [NSKeyedUnarchiver unarchiveObjectWithData:archive];
	STAssertNotNil(container2, @"ooch");

	/* In order for array will send isEqual to each object. In order to overide isEqual we must overide hash */
	STAssertTrue([container isEqualToContainer:container2], @"yeah");
}

- (void)testTargetStorageForObject {
	// - (SHOrderedDictionary *)_targetStorageForObject:(id)anOb
	
	SHParent *n1 = [SHParent makeChildWithName:@"n1"];
	SHProtoOutputAttribute *o1 = [SHProtoOutputAttribute makeChildWithName:@"o1"];
	SHProtoInputAttribute *i1 = [SHProtoInputAttribute makeChildWithName:@"i1"];
	SHInterConnector *anInterConnector = [SHInterConnector makeChildWithName:@"ic1"];

	[container _addNode:n1 atIndex:0 withKey:@"n1" undoManager:nil];
	[container _addInput:i1 atIndex:0 withKey:@"i1" undoManager:nil];
	[container _addOutput:o1 atIndex:0 withKey:@"o1" undoManager:nil];
	[container _addInterConnector:anInterConnector between:i1 and:o1 undoManager:nil];

	SHOrderedDictionary* ordered1 = [container _targetStorageForObject: n1];
	SHOrderedDictionary* ordered2 = [container _targetStorageForObject: i1];
	SHOrderedDictionary* ordered3 = [container _targetStorageForObject: o1];
	SHOrderedDictionary* ordered4 = [container _targetStorageForObject: anInterConnector];
	STAssertTrue(ordered1==[container nodesInside], @"eh");
	STAssertTrue(ordered2==[container inputs], @"eh");
	STAssertTrue(ordered3==[container outputs], @"eh");
	STAssertTrue(ordered4==[container shInterConnectorsInside], @"eh");
	
	// we need to test with some observers added
	[n1 addObserver:self forKeyPath:@"name.value" options:0 context:@"SHChildContainerTest"];
	[o1 addObserver:self forKeyPath:@"name.value" options:0 context:@"SHChildContainerTest"];
	[i1 addObserver:self forKeyPath:@"name.value" options:0 context:@"SHChildContainerTest"];

	SHOrderedDictionary *ordered11 = [container _targetStorageForObject: n1];
	SHOrderedDictionary *ordered22 = [container _targetStorageForObject: i1];
	SHOrderedDictionary *ordered33 = [container _targetStorageForObject: o1];
	STAssertTrue(ordered1==[container nodesInside], @"eh");
	STAssertTrue(ordered2==[container inputs], @"eh");
	STAssertTrue(ordered3==[container outputs], @"eh");

	[n1 removeObserver:self forKeyPath:@"name.value"];
	[o1 removeObserver:self forKeyPath:@"name.value"];
	[i1 removeObserver:self forKeyPath:@"name.value"];
}

- (void)testChildWithKey {
	// - (id<SHNodeLikeProtocol>)childWithKey:(NSString *)aName;

	SHChild *n1 = [SHChild makeChildWithName:@"n1"];
	SHProtoOutputAttribute *o1 = [SHProtoOutputAttribute makeChildWithName:@"o1"];
	SHProtoInputAttribute *i1 = [SHProtoInputAttribute makeChildWithName:@"i1"];
	SHInterConnector *anInterConnector = [SHInterConnector makeChildWithName:@"ic1"];

	[container _addNode:n1 atIndex:0 withKey:@"n1" undoManager:um];
	[container _addInput:i1 atIndex:0 withKey:@"i1" undoManager:um];
	[container _addOutput:o1 atIndex:0 withKey:@"o1" undoManager:um];
	[container _addInterConnector:anInterConnector between:i1 and:o1 undoManager:um];
	
	STAssertEqualObjects( [container childWithKey:@"n1"], n1, @"childWithKey has failed somehow");
	STAssertEqualObjects( [container childWithKey:@"o1"], o1, @"childWithKey has failed somehow");
	STAssertEqualObjects( [container childWithKey:@"i1"], i1, @"childWithKey has failed somehow");
	STAssertEqualObjects( [container childWithKey:@"ic1"], anInterConnector, @"childWithKey has failed somehow");
	
	STAssertNil( [container childWithKey:@"booboo"], @"childWithKey has failed somehow");
}

- (void)testIsChild {
	//- (BOOL)isChild:(id)value
	
	SHParent *n1 = [SHParent makeChildWithName:@"n1"];
	SHParent *n2 = [SHParent makeChildWithName:@"n2"];
	SHProtoOutputAttribute *o1 = [SHProtoOutputAttribute makeChildWithName:@"o1"];
	SHProtoInputAttribute *i1 = [SHProtoInputAttribute makeChildWithName:@"i1"];
	
	[container _addNode:n1 atIndex:0 withKey:@"n1" undoManager:nil];
	[container _addInput:i1 atIndex:0 withKey:@"i1" undoManager:nil];
	[container _addOutput:o1 atIndex:0 withKey:@"o1" undoManager:nil];
	
	STAssertTrue([container isChild:n1], @"should be child");
	STAssertFalse([container isChild:n2], @"should not be child");	
	STAssertTrue([container isChild:o1], @"should be child");
	STAssertTrue([container isChild:i1], @"should be child");	
}

- (void)testIndexOfChild {
	// - (int)indexOfChild:(id)child; // may return NSNotFound
	
	SHParent *n1 = [SHParent makeChildWithName:@"n1"];
	SHParent *n2 = [SHParent makeChildWithName:@"n2"];
	SHProtoOutputAttribute *o1 = [SHProtoOutputAttribute makeChildWithName:@"o1"];
	SHProtoInputAttribute *i1 = [SHProtoInputAttribute makeChildWithName:@"i1"];
	
	[container _addNode:n1 atIndex:0 withKey:@"n1" undoManager:nil];
	[container _addNode:n2 atIndex:1 withKey:@"n2" undoManager:nil];
	[container _addInput:i1 atIndex:0 withKey:@"i1" undoManager:nil];
	[container _addOutput:o1 atIndex:0 withKey:@"o1" undoManager:nil];
		
	STAssertTrue([container indexOfChild:n1]==0, @"should be equal");
	STAssertTrue([container indexOfChild:n2]==1, @"eek");
	STAssertTrue([container indexOfChild:o1]==0, @"eek");
	STAssertTrue([container indexOfChild:i1]==0, @"eek");
	
	STAssertTrue([container indexOfChild:self]==NSNotFound, @"eek");
}

- (void)testSetIndexOfChildToUndoManager {
	// - (void)setIndexOfChild:(id)child to:(NSUInteger)index undoManager:(NSUndoManager *)um {

	[container addObserver:self forKeyPath:@"nodesInside.array" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHChildContainerTests"];

	SHParent *n1 = [SHParent makeChildWithName:@"n1"];
	SHParent *n2 = [SHParent makeChildWithName:@"n2"];
	SHProtoOutputAttribute *o1 = [SHProtoOutputAttribute makeChildWithName:@"o1"];
	SHProtoInputAttribute *i1 = [SHProtoInputAttribute makeChildWithName:@"i1"];
	
	[container _addNode:n1 atIndex:0 withKey:@"n1" undoManager:nil];
	[container _addNode:n2 atIndex:1 withKey:@"n2" undoManager:nil];
	[container _addInput:i1 atIndex:0 withKey:@"i1" undoManager:nil];
	[container _addOutput:o1 atIndex:0 withKey:@"o1" undoManager:nil];
	STAssertTrue(nodesChangedCount==2, @"we should have received a notification - arrayDidChange %i", nodesChangedCount);

	[container setIndexOfChild:n1 to:1 undoManager:um];
	STAssertTrue(nodesChangedCount==3, @"we should have received a notification - arrayDidChange %i", nodesChangedCount);

	STAssertTrue([container indexOfChild:n1]==1, @"should be equal %i", [container indexOfChild:n1]);
	STAssertTrue([container indexOfChild:n2]==0, @"eek %i", [container indexOfChild:n2]);

	[um undo];
	STAssertTrue(nodesChangedCount==4, @"we should have received a notification - arrayDidChange %i", nodesChangedCount);

	STAssertTrue([container indexOfChild:n1]==0, @"should be equal %i", [container indexOfChild:n1]);
	STAssertTrue([container indexOfChild:n2]==1, @"eek %i", [container indexOfChild:n2]);
	
	STAssertThrows([container setIndexOfChild:o1 to:1 undoManager:nil], @"yer");
	STAssertTrue([container indexOfChild:o1]==0, @"eek");
	
	[container removeObserver:self forKeyPath:@"nodesInside.array"];
}

- (void)testMoveObjectstoIndexesUndoManager {
	//- (void)moveObjects:(NSArray *)children toIndexes:(NSIndexSet *)indexes undoManager:(NSUndoManager *)um 

	[container addObserver:self forKeyPath:@"nodesInside.array" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHChildContainerTests"];

	SHParent *n1=[SHParent makeChildWithName:@"n1"],*n2=[SHParent makeChildWithName:@"n2"],*n3=[SHParent makeChildWithName:@"n3"],*n4=[SHParent makeChildWithName:@"n4"],*n5=[SHParent makeChildWithName:@"n5"];
	
	[container _addNode:n1 atIndex:0 withKey:@"n1" undoManager:nil];
	[container _addNode:n2 atIndex:1 withKey:@"n2" undoManager:nil];
	[container _addNode:n3 atIndex:2 withKey:@"n3" undoManager:nil];
	[container _addNode:n4 atIndex:3 withKey:@"n4" undoManager:nil];
	[container _addNode:n5 atIndex:4 withKey:@"n5" undoManager:nil];

	[container setSelectedNodes:[NSArray array]];
	[container addChildToSelection:n1];
	[container addChildToSelection:n4];
	
	[container moveObjects:[NSArray arrayWithObjects:n3,n5,nil] toIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,2)] undoManager:um];
	STAssertTrue([container nodeAtIndex:0]==n3, @"fail");
	STAssertTrue([container nodeAtIndex:1]==n5, @"fail");
	STAssertTrue([container nodeAtIndex:2]==n1, @"fail");
	STAssertTrue([container nodeAtIndex:3]==n2, @"fail");
	STAssertTrue([container nodeAtIndex:4]==n4, @"fail");
	STAssertTrue(nodesChangedCount==6, @"we should have received a notification - arrayDidChange %i", nodesChangedCount);
		
	// Test Undo
	[um undo];
	STAssertTrue([container nodeAtIndex:0]==n1, @"fail");
	STAssertTrue([container nodeAtIndex:1]==n2, @"fail");
	STAssertTrue([container nodeAtIndex:2]==n3, @"fail");
	STAssertTrue([container nodeAtIndex:3]==n4, @"fail");
	STAssertTrue([container nodeAtIndex:4]==n5, @"fail");
	STAssertTrue(nodesChangedCount==7, @"we should have received a notification - arrayDidChange %i", nodesChangedCount);

	[um redo];
	STAssertTrue([container nodeAtIndex:0]==n3, @"fail");
	STAssertTrue([container nodeAtIndex:1]==n5, @"fail");
	STAssertTrue([container nodeAtIndex:2]==n1, @"fail");
	STAssertTrue([container nodeAtIndex:3]==n2, @"fail");
	STAssertTrue([container nodeAtIndex:4]==n4, @"fail");
	STAssertTrue(nodesChangedCount==8, @"we should have received a notification - arrayDidChange %i", nodesChangedCount);

	[container moveObjects:[NSArray arrayWithObjects:n3,n1,nil] toIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1,2)] undoManager:um];
	STAssertTrue([container nodeAtIndex:0]==n5, @"fail");
	STAssertTrue([container nodeAtIndex:1]==n3, @"fail");
	STAssertTrue([container nodeAtIndex:2]==n1, @"fail");
	STAssertTrue([container nodeAtIndex:3]==n2, @"fail");
	STAssertTrue([container nodeAtIndex:4]==n4, @"fail");
	STAssertTrue(nodesChangedCount==9, @"we should have received a notification - arrayDidChange %i", nodesChangedCount);
	
	[container moveObjects:[NSArray arrayWithObjects:n1,n4,nil] toIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2,2)] undoManager:um];
	STAssertTrue([container nodeAtIndex:0]==n5, @"fail");
	STAssertTrue([container nodeAtIndex:1]==n3, @"fail");
	STAssertTrue([container nodeAtIndex:2]==n1, @"fail");
	STAssertTrue([container nodeAtIndex:3]==n4, @"fail");
	STAssertTrue([container nodeAtIndex:4]==n2, @"fail");
	STAssertTrue(nodesChangedCount==10, @"we should have received a notification - arrayDidChange %i", nodesChangedCount);
	
	[container moveObjects:[NSArray arrayWithObjects:n5,n4,nil] toIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(3,2)] undoManager:um];
	STAssertTrue([container nodeAtIndex:0]==n3, @"fail");
	STAssertTrue([container nodeAtIndex:1]==n1, @"fail");
	STAssertTrue([container nodeAtIndex:2]==n2, @"fail");
	STAssertTrue([container nodeAtIndex:3]==n5, @"fail");
	STAssertTrue([container nodeAtIndex:4]==n4, @"fail");
	STAssertTrue(nodesChangedCount==11, @"we should have received a notification - arrayDidChange %i", nodesChangedCount);
	
	[container moveObjects:[NSArray arrayWithObjects:n3,nil] toIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(4,1)] undoManager:um];
	STAssertTrue([container nodeAtIndex:0]==n1, @"fail");
	STAssertTrue([container nodeAtIndex:1]==n2, @"fail");
	STAssertTrue([container nodeAtIndex:2]==n5, @"fail");
	STAssertTrue([container nodeAtIndex:3]==n4, @"fail");
	STAssertTrue([container nodeAtIndex:4]==n3, @"fail");
	STAssertTrue(nodesChangedCount==12, @"we should have received a notification - arrayDidChange %i", nodesChangedCount);
	
	NSArray *selectedObjects = [container selectedChildren];
	STAssertTrue(2==[selectedObjects count], @"ERR, is %i", [selectedObjects count] );
	
	NSArray *woah = [NSArray arrayWithObjects:n1,n2,nil];
	STAssertThrows( [container moveObjects:woah toIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(5,2)] undoManager:um], @"invalid index" );
	STAssertTrue(nodesChangedCount==12, @"we should have received a notification - arrayDidChange %i", nodesChangedCount);
	
	// test that selection was preserved
	selectedObjects = [container selectedChildren];
	STAssertTrue(2==[selectedObjects count], @"ERR, is %i", [selectedObjects count] );
	STAssertTrue([selectedObjects objectAtIndex:0]==n1, @"ERR" );
	STAssertTrue([selectedObjects objectAtIndex:1]==n4, @"ERR" );
	
	// try moving something to where it already is
	[container moveObjects:[NSArray arrayWithObjects:n1,n2,nil] toIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,2)] undoManager:um];
	STAssertTrue(nodesChangedCount==12, @"we should have received a notification - arrayDidChange %i", nodesChangedCount);
	
	// the objects that we pass in should really be in their natural order? does it matter?
	NSArray *woah2 = [NSArray arrayWithObjects:n2,n1,nil];
	STAssertThrows( [container moveObjects:woah2 toIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,2)] undoManager:um], @"invalid index" );
	
	[container removeObserver:self forKeyPath:@"nodesInside.array"];
}

// The table drag reorder Utility
- (void)testMoveChildrenToInsertionIndexUndoManager {
	//- (void)moveChildren:(NSArray *)children toInsertionIndex:(NSUInteger)index undoManager:(NSUndoManager *)um
	
	SHParent *n0=[SHParent makeChildWithName:@"n0"],*n1=[SHParent makeChildWithName:@"n1"],*n2=[SHParent makeChildWithName:@"n2"],*n3=[SHParent makeChildWithName:@"n3"],*n4=[SHParent makeChildWithName:@"n4"];
	[container _addNodes:[NSArray arrayWithObjects:n0,n1,n2,n3,n4,nil] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,5)] withKeys:[NSArray arrayWithObjects:@"n0",@"n1",@"n2",@"n3",@"n4",nil]  undoManager:nil];
	STAssertTrue([container nodeAtIndex:0]==n0, @"fail");
	STAssertTrue([container nodeAtIndex:1]==n1, @"fail");
	STAssertTrue([container nodeAtIndex:2]==n2, @"fail");
	STAssertTrue([container nodeAtIndex:3]==n3, @"fail");
	STAssertTrue([container nodeAtIndex:4]==n4, @"fail");
	
	[container moveChildren:[NSArray arrayWithObjects:n1,n3,nil] toInsertionIndex:0 undoManager:um];
	STAssertTrue([container nodeAtIndex:0]==n1, @"fail");
	STAssertTrue([container nodeAtIndex:1]==n3, @"fail");
	STAssertTrue([container nodeAtIndex:2]==n0, @"fail");
	STAssertTrue([container nodeAtIndex:3]==n2, @"fail");
	STAssertTrue([container nodeAtIndex:4]==n4, @"fail");
	
	[um undo];
	[um removeAllActions];
	// just check that undo is really taking us back to the begining
	STAssertTrue([container nodeAtIndex:0]==n0, @"fail");
	STAssertTrue([container nodeAtIndex:1]==n1, @"fail");
	STAssertTrue([container nodeAtIndex:2]==n2, @"fail");
	STAssertTrue([container nodeAtIndex:3]==n3, @"fail");
	STAssertTrue([container nodeAtIndex:4]==n4, @"fail");
	
	[container moveChildren:[NSArray arrayWithObjects:n1,n3,nil] toInsertionIndex:1 undoManager:um];
	STAssertTrue([container nodeAtIndex:0]==n0, @"fail");
	STAssertTrue([container nodeAtIndex:1]==n1, @"fail");
	STAssertTrue([container nodeAtIndex:2]==n3, @"fail");
	STAssertTrue([container nodeAtIndex:3]==n2, @"fail");
	STAssertTrue([container nodeAtIndex:4]==n4, @"fail");
	
	[um undo];
	[um removeAllActions];
	[container moveChildren:[NSArray arrayWithObjects:n1,n3,nil] toInsertionIndex:2 undoManager:um];
	STAssertTrue([container nodeAtIndex:0]==n0, @"fail");
	STAssertTrue([container nodeAtIndex:1]==n1, @"fail");
	STAssertTrue([container nodeAtIndex:2]==n3, @"fail");
	STAssertTrue([container nodeAtIndex:3]==n2, @"fail");
	STAssertTrue([container nodeAtIndex:4]==n4, @"fail");
	
	[um undo];
	[um removeAllActions];
	[container moveChildren:[NSArray arrayWithObjects:n1,n3,nil] toInsertionIndex:3 undoManager:um];
	STAssertTrue([container nodeAtIndex:0]==n0, @"fail");
	STAssertTrue([container nodeAtIndex:1]==n2, @"fail");
	STAssertTrue([container nodeAtIndex:2]==n1, @"fail");
	STAssertTrue([container nodeAtIndex:3]==n3, @"fail");
	STAssertTrue([container nodeAtIndex:4]==n4, @"fail");
	
	[um undo];
	[um removeAllActions];
	[container moveChildren:[NSArray arrayWithObjects:n1,n3,nil] toInsertionIndex:4 undoManager:um];
	STAssertTrue([container nodeAtIndex:0]==n0, @"fail");
	STAssertTrue([container nodeAtIndex:1]==n2, @"fail");
	STAssertTrue([container nodeAtIndex:2]==n1, @"fail");
	STAssertTrue([container nodeAtIndex:3]==n3, @"fail");
	STAssertTrue([container nodeAtIndex:4]==n4, @"fail");

	[um undo];
	[um removeAllActions];
	[container moveChildren:[NSArray arrayWithObjects:n1,n3,nil] toInsertionIndex:5 undoManager:um];
	STAssertTrue([container nodeAtIndex:0]==n0, @"fail");
	STAssertTrue([container nodeAtIndex:1]==n2, @"fail");
	STAssertTrue([container nodeAtIndex:2]==n4, @"fail");
	STAssertTrue([container nodeAtIndex:3]==n1, @"fail");
	STAssertTrue([container nodeAtIndex:4]==n3, @"fail");
	
	NSArray *okArray = [NSArray arrayWithObjects:n1,n3,nil];
	STAssertThrows([container moveChildren:okArray toInsertionIndex:6 undoManager:um], @"index out of range");
}


- (void)testIsEmpty {
	//- (BOOL)isEmpty
	
	STAssertTrue([container isEmpty], @"no brainer");
	SHParent *n1 = [SHParent makeChildWithName:@"n1"];
	[container _addNode:n1 atIndex:0 withKey:@"n1" undoManager:nil];
	STAssertFalse([container isEmpty], @"no brainer");
}

#pragma mark With Undo
- (void)test_addNodeAtIndexWithKeyUndoManager {
	//- (void)_addNode:(SHChild *)value atIndex:(int)ind withKey:(NSString *)key undoManager:(NSUndoManager *)um;
	//- (SHChild *)nodeAtIndex:(NSUInteger)index;

	STAssertTrue( [container isEmpty], @"should be empty");
	
	[container addObserver:self forKeyPath:@"nodesInside.array" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHChildContainerTests"];
	SHChild *n1 = [SHChild makeChildWithName:@"n1"];
	[um beginUndoGrouping];
		[container _addNode:n1 atIndex:0 withKey:@"n1" undoManager:um];
	[um endUndoGrouping];
	STAssertTrue(nodesChangedCount==1, @"received incorrect number of notifications %i", nodesChangedCount);
	STAssertTrue([container.nodesInside count]==1, @"wrong number of nodesInside %i", [container.nodesInside count]);
	STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo add node"], @"Incorrect Undo Title :%@", [um undoMenuItemTitle]);
	STAssertTrue([container nodeAtIndex:0]==n1, @"doh");
	STAssertFalse( [container isEmpty], @"should be empty");

	[container removeObserver:self forKeyPath:@"nodesInside.array"];
}

- (void)test_addInputAtIndexWithKeyUndoManager {
	//- (void)_addInput:(SHChild *)value atIndex:(int)ind withKey:(NSString *)key undoManager:(NSUndoManager *)um;
	// - (SHChild *)inputAtIndex:(NSUInteger)index;

	STAssertTrue( [container isEmpty], @"should be empty");

	[container addObserver:self forKeyPath:@"inputs.array" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHChildContainerTests"];
	SHProtoInputAttribute *i1 = [SHProtoInputAttribute makeChildWithName:@"i1"];
	[um beginUndoGrouping];
		[container _addInput:i1 atIndex:0 withKey:@"i1" undoManager:um];
	[um endUndoGrouping];
	STAssertTrue(inputsChangedCount==1, @"received incorrect number of notifications %i", inputsChangedCount);
	STAssertTrue([container.inputs count]==1, @"wrong number of inputs %i", [container.inputs count]);
	STAssertTrue([container inputAtIndex:0]==i1, @"doh");
	STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo add input"], @"Incorrect Undo Title :%@", [um undoMenuItemTitle]);

	STAssertFalse( [container isEmpty], @"should be empty");

	[container removeObserver:self forKeyPath:@"inputs.array"];
}

- (void)test_addOutputAtIndexWithKeyUndoManager {
	//- (void)_addOutput:(SHChild *)value atIndex:(int)ind withKey:(NSString *)key undoManager:(NSUndoManager *)um;
	// - (SHChild *)outputAtIndex:(NSUInteger)index;

	STAssertTrue( [container isEmpty], @"should be empty");

	[container addObserver:self forKeyPath:@"outputs.array" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHChildContainerTests"];
	SHChild *o1 = [SHChild makeChildWithName:@"n1"];
	[um beginUndoGrouping];
		[container _addOutput:o1 atIndex:0 withKey:@"n1" undoManager:um];
	[um endUndoGrouping];
	STAssertTrue(outputsChangedCount==1, @"received incorrect number of notifications %i", outputsChangedCount);
	STAssertTrue([container.outputs count]==1, @"wrong number of outputs %i", [container.outputs count]);
	STAssertTrue([container outputAtIndex:0]==o1, @"doh");
	STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo add output"], @"Incorrect Undo Title :%@", [um undoMenuItemTitle]);

	STAssertFalse( [container isEmpty], @"should be empty");

	[container removeObserver:self forKeyPath:@"outputs.array"];
}

- (void)test_removeNodeWithKeyUndoManager {
	//- (void)_removeNode:(SHChild *)value withKey:(NSString *)key undoManager:(NSUndoManager *)um;

	[container addObserver:self forKeyPath:@"nodesInside.array" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHChildContainerTests"];
	SHChild *n1 = [SHChild makeChildWithName:@"n1"];
	[container _addNode:n1 atIndex:0 withKey:@"n1" undoManager:um];
	[um removeAllActions];	
	[self resetObservers];

	STAssertFalse( [container isEmpty], @"should be empty");

	[um beginUndoGrouping];
		[container _removeNode:n1 withKey:@"n1" undoManager:um];
	[um endUndoGrouping];
	
	STAssertTrue( [container isEmpty], @"should be empty");

	STAssertTrue([[container nodesInside] count]==0, @"should have deleted them.. %i", [[container nodesInside] count]);
	STAssertTrue(nodesChangedCount==1, @"received incorrect number of notifications %i", nodesChangedCount);
	STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo remove node"], @"Incorrect Undo Title :%@", [um undoMenuItemTitle]);
	
	[um undo]; //-- add again
	STAssertTrue([[container nodesInside] count]==1, @"should have deleted them.. %i", [[container nodesInside] count]);
	STAssertTrue(nodesChangedCount==2, @"received incorrect number of notifications %i", nodesChangedCount);
	STAssertTrue([[um redoMenuItemTitle] isEqualToString:@"Redo remove node"], @"Incorrect Redo Title :%@", [um redoMenuItemTitle]);
	STAssertFalse( [container isEmpty], @"should be empty");

	[um redo]; //-- remove again
	STAssertTrue([[container nodesInside] count]==0, @"should have deleted them.. %i", [[container nodesInside] count]);
	STAssertTrue(nodesChangedCount==3, @"received incorrect number of notifications %i", nodesChangedCount);
	STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo remove node"], @"Incorrect Undo Title :%@", [um undoMenuItemTitle]);
	STAssertTrue( [container isEmpty], @"should be empty");

	[container removeObserver:self forKeyPath:@"nodesInside.array"];
}

- (void)test_removeInputWithKeyUndoManager {
	//- (void)_removeInput:(SHChild *)value withKey:(NSString *)key undoManager:(NSUndoManager *)um;

	[container addObserver:self forKeyPath:@"inputs.array" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHChildContainerTests"];
	SHChild *n1 = [SHChild makeChildWithName:@"n1"];
	[container _addInput:n1 atIndex:0 withKey:@"n1" undoManager:um];
	[um removeAllActions];	
	[self resetObservers];

	[um beginUndoGrouping];
		[container _removeInput:n1 withKey:@"n1" undoManager:um];
	[um endUndoGrouping];

	STAssertTrue( [container isEmpty], @"should be empty");
	STAssertTrue([[container inputs] count]==0, @"should have deleted them.. %i", [[container inputs] count]);
	STAssertTrue(inputsChangedCount==1, @"received incorrect number of notifications %i", inputsChangedCount);
	STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo remove input"], @"Incorrect Undo Title :%@", [um undoMenuItemTitle]);
	
	[um undo]; //-- add again
	STAssertTrue([[container inputs] count]==1, @"should have deleted them.. %i", [[container inputs] count]);
	STAssertTrue(inputsChangedCount==2, @"received incorrect number of notifications %i", inputsChangedCount);
	STAssertTrue([[um redoMenuItemTitle] isEqualToString:@"Redo remove input"], @"Incorrect Redo Title :%@", [um redoMenuItemTitle]);
	STAssertFalse( [container isEmpty], @"should be empty");

	[um redo]; //-- remove again
	STAssertTrue([[container inputs] count]==0, @"should have deleted them.. %i", [[container inputs] count]);
	STAssertTrue(inputsChangedCount==3, @"received incorrect number of notifications %i", inputsChangedCount);
	STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo remove input"], @"Incorrect Undo Title :%@", [um undoMenuItemTitle]);

	[container removeObserver:self forKeyPath:@"inputs.array"];
}

- (void)test_removeOutputWithKeyUndoManager {
	//- (void)_removeOutput:(SHChild *)value withKey:(NSString *)key undoManager:(NSUndoManager *)um;

	[container addObserver:self forKeyPath:@"outputs.array" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHChildContainerTests"];
	SHProtoOutputAttribute *n1 = [SHProtoOutputAttribute makeChildWithName:@"n1"];
	[container _addOutput:n1 atIndex:0 withKey:@"n1" undoManager:um];
	[um removeAllActions];	
	[self resetObservers];

	[um beginUndoGrouping];
		[container _removeOutput:n1 withKey:@"n1" undoManager:um];
	[um endUndoGrouping];

	STAssertTrue( [container isEmpty], @"should be empty");
	STAssertTrue([[container outputs] count]==0, @"should have deleted them.. %i", [[container outputs] count]);
	STAssertTrue(outputsChangedCount==1, @"received incorrect number of notifications %i", outputsChangedCount);
	STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo remove output"], @"Incorrect Undo Title :%@", [um undoMenuItemTitle]);
	
	[um undo]; //-- add again
	STAssertTrue([[container outputs] count]==1, @"should have deleted them.. %i", [[container outputs] count]);
	STAssertTrue(outputsChangedCount==2, @"received incorrect number of notifications %i", outputsChangedCount);
	STAssertTrue([[um redoMenuItemTitle] isEqualToString:@"Redo remove output"], @"Incorrect Redo Title :%@", [um redoMenuItemTitle]);
	STAssertFalse( [container isEmpty], @"should be empty");

	[um redo]; //-- remove again
	STAssertTrue([[container outputs] count]==0, @"should have deleted them.. %i", [[container outputs] count]);
	STAssertTrue(outputsChangedCount==3, @"received incorrect number of notifications %i", outputsChangedCount);
	STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo remove output"], @"Incorrect Undo Title :%@", [um undoMenuItemTitle]);

	[container removeObserver:self forKeyPath:@"outputs.array"];
}

- (void)test_addOutputsAtIndexesWithKeysUndoManager {
	//- (void)_addOutputs:(NSArray *)values atIndexes:(NSIndexSet *)indexes withKeys:(NSArray *)keys undoManager:(NSUndoManager *)um
	
	[container addObserver:self forKeyPath:@"outputs.array" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHChildContainerTests"];
	
	SHProtoOutputAttribute *outAtt1 = [SHProtoOutputAttribute makeChildWithName:@"out1"], *outAtt2=[SHProtoOutputAttribute makeChildWithName:@"out2"], *outAtt3=[SHProtoOutputAttribute makeChildWithName:@"out3"];
	NSArray *outputs = [NSArray arrayWithObjects:outAtt1, outAtt2, outAtt3, nil];
	NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,3)];
	NSArray *keys = [NSArray arrayWithObjects:[outAtt1 name].value, [outAtt2 name].value, [outAtt3 name].value, nil];
	
	[um beginUndoGrouping];
		[container _addOutputs:outputs atIndexes:indexes withKeys:keys undoManager:um];
	[um endUndoGrouping];
	
	STAssertFalse( [container isEmpty], @"should be empty");
	STAssertTrue(outputsChangedCount==1, @"received incorrect number of notifications %i", outputsChangedCount);
	STAssertTrue([container.outputs count]==3, @"wrong number of outputs %i", [container.outputs count]);
	STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo add Outputs"], @"Incorrect Undo Title :%@", [um undoMenuItemTitle]);
    
	[um undo];
	STAssertTrue(outputsChangedCount==2, @"received incorrect number of notifications %i", outputsChangedCount);
	STAssertTrue([container.outputs count]==0, @"wrong number of outputs %i", [container.outputs count]);
	STAssertTrue([[um redoMenuItemTitle] isEqualToString:@"Redo add Outputs"], @"Incorrect Redo Title :%@", [um redoMenuItemTitle]);
	STAssertTrue( [container isEmpty], @"should be empty");

	[um redo];
	STAssertTrue(outputsChangedCount==3, @"received incorrect number of notifications %i", outputsChangedCount);
	STAssertTrue([container.outputs count]==3, @"wrong number of outputs %i", [container.outputs count]);
    STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo add Outputs"], @"Incorrect Undo Title :%@", [um undoMenuItemTitle]);
   	STAssertFalse( [container isEmpty], @"should be empty");

	[container removeObserver:self forKeyPath:@"outputs.array"];
}


- (void)test_addInputsAtIndexesWithKeysUndoManager {
	// - (void)_addInputs:(NSArray *)values atIndexes:(NSIndexSet *)indexes withKeys:(NSArray *)keys undoManager:um
	
	[container addObserver:self forKeyPath:@"inputs.array" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHChildContainerTests"];
	
	SHProtoInputAttribute *inAtt1 = [SHProtoInputAttribute makeChildWithName:@"inAtt1"], *inAtt2=[SHProtoInputAttribute makeChildWithName:@"inAtt2"], *inAtt3=[SHProtoInputAttribute makeChildWithName:@"inAtt3"];
	NSArray *inputs = [NSArray arrayWithObjects:inAtt1, inAtt2, inAtt3, nil];
	NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,3)];
	NSArray *keys = [NSArray arrayWithObjects:[inAtt1 name].value, [inAtt2 name].value, [inAtt3 name].value, nil];
	
	[um beginUndoGrouping];
		[container _addInputs:inputs atIndexes:indexes withKeys:keys undoManager:um];
	[um endUndoGrouping];
	
	STAssertTrue(inputsChangedCount==1, @"received incorrect number of notifications %i", inputsChangedCount);
	STAssertTrue([container.inputs count]==3, @"wrong number of inputs %i", [container.inputs count]);
	STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo add Inputs"], @"Incorrect Undo Title :%@", [um undoMenuItemTitle]);
	STAssertFalse( [container isEmpty], @"should be empty");

	[um undo];
	STAssertTrue(inputsChangedCount==2, @"received incorrect number of notifications %i", inputsChangedCount);
	STAssertTrue([container.inputs count]==0, @"wrong number of inputs %i", [container.inputs count]);
	STAssertTrue([[um redoMenuItemTitle] isEqualToString:@"Redo add Inputs"], @"Incorrect Redo Title :%@", [um redoMenuItemTitle]);
	STAssertTrue( [container isEmpty], @"should be empty");

	[um redo];
	STAssertTrue(inputsChangedCount==3, @"received incorrect number of notifications %i", inputsChangedCount);
	STAssertTrue([container.inputs count]==3, @"wrong number of inputs %i", [container.inputs count]);
    STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo add Inputs"], @"Incorrect Undo Title :%@", [um undoMenuItemTitle]);
	STAssertFalse( [container isEmpty], @"should be empty");

	[container removeObserver:self forKeyPath:@"inputs.array"];
}

- (void)test_addNodesAtIndexesWithKeysUndoManager {
	// - (void)_addNodes:(NSArray *)values atIndexes:(NSIndexSet *)indexes withKeys:(NSArray *)keys undoManager:um

	[container addObserver:self forKeyPath:@"nodesInside.array" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHChildContainerTests"];
	
	SHChild *node1 = [SHChild makeChildWithName:@"node1"], *node2=[SHChild makeChildWithName:@"node2"], *node3=[SHChild makeChildWithName:@"node3"];
	NSArray *nodes = [NSArray arrayWithObjects:node1, node2, node3, nil];
	NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,3)];
	NSArray *keys = [NSArray arrayWithObjects:[node1 name].value, [node2 name].value, [node3 name].value, nil];
	
	[um beginUndoGrouping];
		[container _addNodes:nodes atIndexes:indexes withKeys:keys undoManager:um];
	[um endUndoGrouping];
	
	STAssertTrue(nodesChangedCount==1, @"received incorrect number of notifications %i", nodesChangedCount);
	STAssertTrue([container.nodesInside count]==3, @"wrong number of nodesInside %i", [container.nodesInside count]);
	STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo add Nodes"], @"Incorrect Undo Title :%@", [um undoMenuItemTitle]);
	STAssertFalse( [container isEmpty], @"should be empty");

	[um undo];
	STAssertTrue(nodesChangedCount==2, @"received incorrect number of notifications %i", nodesChangedCount);
	STAssertTrue([container.nodesInside count]==0, @"wrong number of nodesInside %i", [container.nodesInside count]);
	STAssertTrue([[um redoMenuItemTitle] isEqualToString:@"Redo add Nodes"], @"Incorrect Redo Title :%@", [um redoMenuItemTitle]);
	STAssertTrue( [container isEmpty], @"should be empty");

	[um redo];
	STAssertTrue(nodesChangedCount==3, @"received incorrect number of notifications %i", nodesChangedCount);
	STAssertTrue([container.nodesInside count]==3, @"wrong number of nodesInside %i", [container.nodesInside count]);
    STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo add Nodes"], @"Incorrect Undo Title :%@", [um undoMenuItemTitle]);
	STAssertFalse( [container isEmpty], @"should be empty");

	[container removeObserver:self forKeyPath:@"nodesInside.array"];
}

- (void)test_addInterConnectorBetweenAndUndoManager {	
	// - (void)_addInterConnector:(SHInterConnector *)anInterConnector between:(SHAttribute *)outAttr and:(SHAttribute *)inAttr undoManager:(NSUndoManager *)um;
	//- (SHChild *)connectorAtIndex:(NSUInteger)index;

	[container addObserver:self forKeyPath:@"shInterConnectorsInside.array" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHChildContainerTests"];

	SHProtoInputAttribute *inAtt1 = [SHProtoInputAttribute makeChildWithName:@"i1"];
	SHProtoOutputAttribute *outAtt1 = [SHProtoOutputAttribute makeChildWithName:@"o1"];
	SHInterConnector *anInterConnector = [SHInterConnector makeChildWithName:@"ic1"];

	STAssertThrows([container _addInterConnector:anInterConnector between:inAtt1 and:inAtt1 undoManager:um], @"doh");
	
	[self resetObservers];
	[um removeAllActions];

	/* Test Undo Redo */
	[um beginUndoGrouping];
		[container _addInterConnector:anInterConnector between:inAtt1 and:outAtt1 undoManager:um];
	[um endUndoGrouping];
	
	//- cheque that the order of the connectors isnt swapped
	SHProtoAttribute *att1 = [[container.shInterConnectorsInside objectAtIndex:0] outOfAtt];
	SHProtoAttribute *att2 = [[container.shInterConnectorsInside objectAtIndex:0] intoAtt];
	STAssertNotNil(att1, @"failed to make connections");
	STAssertNotNil(att2, @"failed to make connections");
	
	/* we should have one interconnector */
	STAssertTrue([container connectorAtIndex:0]==anInterConnector, @"doh");
	STAssertTrue(interConnectorsChangedCount==1, @"received incorrect number of notifications %i", interConnectorsChangedCount);
	STAssertTrue([container.shInterConnectorsInside count]==1, @"wrong number of shInterConnectorsInside %i", [container.shInterConnectorsInside count]);
	STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo add connection"], @"Incorrect Undo Title :%@", [um undoMenuItemTitle]);
	STAssertTrue([[inAtt1 allConnectedInterConnectors] count]==1, @"Think we should have just made a connector..");
	STAssertTrue([[outAtt1 allConnectedInterConnectors] count]==1, @"Think we should have just made a connector..");
	STAssertTrue([inAtt1 isOutletConnected], @"Think we should have just made a connector..");
	STAssertFalse([inAtt1 isInletConnected], @"Think we should have just made a connector..");
	STAssertTrue([outAtt1 isInletConnected], @"Think we should have just made a connector..");
	STAssertFalse([outAtt1 isOutletConnected], @"Think we should have just made a connector..");
	STAssertThrows( [container _addInterConnector:anInterConnector between:inAtt1 and:outAtt1 undoManager:um], @"cant add twice" );

	[um undo]; //-- remove
	STAssertTrue(interConnectorsChangedCount==2, @"received incorrect number of notifications %i", interConnectorsChangedCount);

	/* we should be back at no interconnectors */
	STAssertTrue([container.shInterConnectorsInside count]==0, @"wrong number of shInterConnectorsInside %i", [container.shInterConnectorsInside count]);
	STAssertTrue([[inAtt1 allConnectedInterConnectors] count]==0, @"Think we should have just made a connector..");
	STAssertTrue([[outAtt1 allConnectedInterConnectors] count]==0, @"Think we should have just made a connector..");
	STAssertFalse([inAtt1 isOutletConnected], @"Think we should have just made a connector..");
	STAssertFalse([inAtt1 isInletConnected], @"Think we should have just made a connector..");
	STAssertFalse([outAtt1 isInletConnected], @"Think we should have just made a connector..");
	STAssertFalse([outAtt1 isOutletConnected], @"Think we should have just made a connector..");
	STAssertTrue([[um redoMenuItemTitle] isEqualToString:@"Redo add connection"], @"Incorrect Redo Title :%@", [um redoMenuItemTitle]);
	
	/* Redo */
	[um redo];
	STAssertTrue(interConnectorsChangedCount==3, @"received incorrect number of notifications %i", interConnectorsChangedCount);

	/* we should have one again */
	STAssertTrue([container.shInterConnectorsInside count]==1, @"wrong number of shInterConnectorsInside %i", [container.shInterConnectorsInside count]);
	STAssertTrue([[inAtt1 allConnectedInterConnectors] count]==1, @"Think we should have just made a connector..");
	STAssertTrue([[outAtt1 allConnectedInterConnectors] count]==1, @"Think we should have just made a connector..");
	STAssertTrue([inAtt1 isOutletConnected], @"Think we should have just made a connector..");
	STAssertFalse([inAtt1 isInletConnected], @"Think we should have just made a connector..");
	STAssertTrue([outAtt1 isInletConnected], @"Think we should have just made a connector..");
	STAssertFalse([outAtt1 isOutletConnected], @"Think we should have just made a connector..");
	STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo add connection"], @"Incorrect Undo Title :%@", [um undoMenuItemTitle]);
	
	[container removeObserver:self forKeyPath:@"shInterConnectorsInside.array"];
}

- (void)test_addInterconnectorsBetweenAndUndoManager {
	//- (void)_addInterconnectors:(NSArray *)values between:(NSArray *)outAtts and:(NSArray *)inAtts undoManager:(NSUndoManager *)um
	
	[container addObserver:self forKeyPath:@"shInterConnectorsInside.array" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHChildContainerTests"];

	SHProtoInputAttribute *inAtt1 = [SHProtoInputAttribute makeChildWithName:@"i1"], *inAtt2 = [SHProtoInputAttribute makeChildWithName:@"i2"], *inAtt3 = [SHProtoInputAttribute makeChildWithName:@"i3"];
	SHProtoOutputAttribute *outAtt1 = [SHProtoOutputAttribute makeChildWithName:@"o1"], *outAtt2 = [SHProtoOutputAttribute makeChildWithName:@"o2"], *outAtt3 = [SHProtoOutputAttribute makeChildWithName:@"o3"];
	SHInterConnector *ic1 = [SHInterConnector makeChildWithName:@"ic1"], *ic2 = [SHInterConnector makeChildWithName:@"ic2"], *ic3 = [SHInterConnector makeChildWithName:@"ic3"];

	NSArray *ics = [NSArray arrayWithObjects:ic1, ic2, ic3, nil];
	NSArray *inAtts = [NSArray arrayWithObjects:inAtt1, inAtt2, inAtt3, nil];
	NSArray *outAtts = [NSArray arrayWithObjects:outAtt1, outAtt2, outAtt3, nil];
	[self resetObservers];
	[um removeAllActions];	

	STAssertThrows([container _addInterconnectors:ics between:inAtts and:inAtts undoManager:um], @"cant connect");

	[um beginUndoGrouping];
		[container _addInterconnectors:ics between:inAtts and:outAtts undoManager:um];
	[um endUndoGrouping];

	STAssertThrows([container _addInterconnectors:ics between:inAtts and:outAtts undoManager:um], @"cant add twice");
	
	//- cheque that the order of the connectors isnt swapped
	SHProtoAttribute *att1 = [[container.shInterConnectorsInside objectAtIndex:0] outOfAtt];
	SHProtoAttribute *att2 = [[container.shInterConnectorsInside objectAtIndex:0] intoAtt];
	STAssertNotNil(att1, @"failed to make connections");
	STAssertNotNil(att2, @"failed to make connections");

	STAssertTrue(interConnectorsChangedCount==1, @"received incorrect number of notifications %i", interConnectorsChangedCount);
	STAssertTrue([container.shInterConnectorsInside count]==3, @"wrong number of shInterConnectorsInside %i", [container.shInterConnectorsInside count]);
	STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo add connections"], @"Incorrect Undo Title :%@", [um undoMenuItemTitle]);

	[um undo];
	STAssertTrue(interConnectorsChangedCount==2, @"received incorrect number of notifications %i", interConnectorsChangedCount);
	STAssertTrue([container.shInterConnectorsInside count]==0, @"wrong number of shInterConnectorsInside %i", [container.shInterConnectorsInside count]);
	STAssertTrue([[um redoMenuItemTitle] isEqualToString:@"Redo add connections"], @"Incorrect Redo Title :%@", [um redoMenuItemTitle]);

	[um redo];
	STAssertTrue(interConnectorsChangedCount==3, @"received incorrect number of notifications %i", interConnectorsChangedCount);
	STAssertTrue([container.shInterConnectorsInside count]==3, @"wrong number of shInterConnectorsInside %i", [container.shInterConnectorsInside count]);
	STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo add connections"], @"Incorrect Undo Title :%@", [um undoMenuItemTitle]);

	STAssertTrue( [[container.shInterConnectorsInside objectAtIndex:0] outOfAtt]==att1, @"fucked up connection %@", [[container.shInterConnectorsInside objectAtIndex:0] outOfAtt]);
	STAssertTrue( [[container.shInterConnectorsInside objectAtIndex:0] intoAtt]==att2, @"fucked up connection" );

	[container removeObserver:self forKeyPath:@"shInterConnectorsInside.array"];
}

- (void)test_removeInterConnectorUndoManager {
	// - (void)_removeInterConnector:(SHInterConnector *)connectorToDelete undoManager:(NSUndoManager *)um;

	[container addObserver:self forKeyPath:@"shInterConnectorsInside.array" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHChildContainerTests"];

	SHProtoInputAttribute *inAtt1 = [SHProtoInputAttribute makeChildWithName:@"i1"];
	SHProtoOutputAttribute *outAtt1 = [SHProtoOutputAttribute makeChildWithName:@"o1"];
	SHInterConnector *anInterConnector = [SHInterConnector makeChildWithName:@"ic1"];
	[container _addInterConnector:anInterConnector between:inAtt1 and:outAtt1 undoManager:um];
	SHConnectlet *originalInCon = (SHConnectlet *)[anInterConnector inSHConnectlet];
	SHConnectlet *originalOutCon = (SHConnectlet *)[anInterConnector outSHConnectlet];
	STAssertNotNil(originalInCon, @"woah");
	STAssertNotNil(originalOutCon, @"woah");
	[self resetObservers];
	[um removeAllActions];
	
	/* Test Undo Redo */
	[um beginUndoGrouping];
		[container _removeInterConnector:anInterConnector undoManager:um];
	[um endUndoGrouping];
	
	STAssertThrows([container _removeInterConnector:anInterConnector undoManager:um], @"should not contain");
	
	STAssertTrue([[container shInterConnectorsInside] count]==0, @"Think we should have just made a connector..");
	STAssertTrue([[inAtt1 allConnectedInterConnectors] count]==0, @"Think we should have just made a connector..");
	STAssertTrue([[outAtt1 allConnectedInterConnectors] count]==0, @"Think we should have just made a connector..");
	STAssertTrue([inAtt1 isOutletConnected]==NO, @"Think we should have just made a connector..");
	STAssertTrue([outAtt1 isInletConnected]==NO, @"Think we should have just made a connector..");
	STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo remove connection"], @"Incorrect Undo Title :%@", [um undoMenuItemTitle]);
	
	/* Undo */
	[um undo]; //-- add again
	
	STAssertTrue([[container shInterConnectorsInside] count]==1, @"Think we should have just made a connector.. %i", [[container shInterConnectorsInside] count]);
	STAssertTrue([[inAtt1 allConnectedInterConnectors] count]==1, @"Think we should have just made a connector..");
	STAssertTrue([[outAtt1 allConnectedInterConnectors] count]==1, @"Think we should have just made a connector..");
	STAssertTrue([inAtt1 isOutletConnected]==YES, @"Think we should have just made a connector..");
	STAssertTrue([outAtt1 isInletConnected]==YES, @"Think we should have just made a connector..");	
	//-- test that the little connectlets are wired in the correct way round
	SHInterConnector *remadeInterCon = [[container shInterConnectorsInside] objectAtIndex:0];
	SHConnectlet *inCon = (SHConnectlet *)[remadeInterCon inSHConnectlet];
	SHConnectlet *outCon = (SHConnectlet *)[remadeInterCon outSHConnectlet];
	STAssertEqualObjects(originalInCon, inCon, @"right way round");
	STAssertEqualObjects(originalOutCon, outCon, @"right way round");
	STAssertTrue([[um redoMenuItemTitle] isEqualToString:@"Redo remove connection"], @"Incorrect Redo Title :%@", [um redoMenuItemTitle]);
	
	/* Redo */
	[um redo]; //-- take away again
	
	STAssertTrue([[container shInterConnectorsInside] count]==0, @"Think we should have just made a connector..");
	STAssertTrue([[inAtt1 allConnectedInterConnectors] count]==0, @"Think we should have just made a connector..");
	STAssertTrue([[outAtt1 allConnectedInterConnectors] count]==0, @"Think we should have just made a connector..");
	STAssertTrue([inAtt1 isOutletConnected]==NO, @"Think we should have just made a connector..");
	STAssertTrue([outAtt1 isInletConnected]==NO, @"Think we should have just made a connector..");
	STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo remove connection"], @"Incorrect Undo Title :%@", [um undoMenuItemTitle]);
	
	[container removeObserver:self forKeyPath:@"shInterConnectorsInside.array"];
}

- (void)test_removeInterConnectorsUndoManager {
// - (void)_removeInterConnectors:(NSArray *)connectorsToDelete undoManager:(NSUndoManager *)um
	
	//-- observe all items 	-- we want to test the validity of the KVO data for allChildren
	[container addObserver:self forKeyPath:@"shInterConnectorsInside.array" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHChildContainerTests"];

	SHProtoInputAttribute *inAtt1 = [SHProtoInputAttribute makeChildWithName:@"i1"], *inAtt2 = [SHProtoInputAttribute makeChildWithName:@"i2"], *inAtt3 = [SHProtoInputAttribute makeChildWithName:@"i3"];
	SHProtoOutputAttribute *outAtt1 = [SHProtoOutputAttribute makeChildWithName:@"o1"], *outAtt2 = [SHProtoOutputAttribute makeChildWithName:@"o2"], *outAtt3 = [SHProtoOutputAttribute makeChildWithName:@"o3"];
	SHInterConnector *ic1 = [SHInterConnector makeChildWithName:@"ic1"], *ic2 = [SHInterConnector makeChildWithName:@"ic2"], *ic3 = [SHInterConnector makeChildWithName:@"ic3"];
	NSArray *ics = [NSArray arrayWithObjects:ic1, ic2, ic3, nil];
	NSArray *inAtts = [NSArray arrayWithObjects:inAtt1, inAtt2, inAtt3, nil];
	NSArray *outAtts = [NSArray arrayWithObjects:outAtt1, outAtt2, outAtt3, nil];
	[container _addInterconnectors:ics between:inAtts and:outAtts undoManager:um];
	
	[self resetObservers];
	[um removeAllActions];	

	[um beginUndoGrouping];
		[container _removeInterConnectors:[NSArray arrayWithObjects:ic1, ic2, nil] undoManager:um];
	[um endUndoGrouping];

	STAssertTrue([[container shInterConnectorsInside] count]==1, @"should have deleted them.. %i", [[container shInterConnectorsInside] count]);
	STAssertTrue(interConnectorsChangedCount==1, @"received incorrect number of notifications %i", interConnectorsChangedCount);
	STAssertTrue([inAtt1 isOutletConnected]==NO, @"Think we should have just made a connector..");
	STAssertTrue([outAtt1 isInletConnected]==NO, @"Think we should have just made a connector..");
	STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo remove connections"], @"Incorrect Undo Title :%@", [um undoMenuItemTitle]);

	[um undo]; //-- add again
	STAssertTrue([[container shInterConnectorsInside] count]==3, @"should have deleted them.. %i", [[container shInterConnectorsInside] count]);
	STAssertTrue(interConnectorsChangedCount==2, @"received incorrect number of notifications %i", interConnectorsChangedCount);
	STAssertTrue([inAtt1 isOutletConnected]==YES, @"Think we should have just made a connector..");
	STAssertTrue([outAtt1 isInletConnected]==YES, @"Think we should have just made a connector..");	
	STAssertTrue([[um redoMenuItemTitle] isEqualToString:@"Redo remove connections"], @"Incorrect Redo Title :%@", [um redoMenuItemTitle]);

	[um redo]; //-- remove again
	STAssertTrue([[container shInterConnectorsInside] count]==1, @"should have deleted them.. %i", [[container shInterConnectorsInside] count]);
	STAssertTrue(interConnectorsChangedCount==3, @"received incorrect number of notifications %i", interConnectorsChangedCount);
	STAssertTrue([inAtt1 isOutletConnected]==NO, @"Think we should have just made a connector..");
	STAssertTrue([outAtt1 isInletConnected]==NO, @"Think we should have just made a connector..");
	STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo remove connections"], @"Incorrect Undo Title :%@", [um undoMenuItemTitle]);

	// -- remove observer
	[container removeObserver:self forKeyPath:@"shInterConnectorsInside.array"];
}

- (void)test_removeNodesUndoManager {
	//- (void)_removeNodes:(NSArray *)nodes undoManager:(NSUndoManager *)um
	
	//-- observe all items
	[container addObserver:self forKeyPath:@"nodesInside.array" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHChildContainerTests"];

	SHChild *node1 = [SHChild makeChildWithName:@"node1"], *node2=[SHChild makeChildWithName:@"node2"], *node3=[SHChild makeChildWithName:@"node3"];
	NSArray *nodes = [NSArray arrayWithObjects:node1, node2, node3, nil];
	NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,3)];
	NSArray *keys = [NSArray arrayWithObjects:[node1 name].value, [node2 name].value, [node3 name].value, nil];
	
	[container _addNodes:nodes atIndexes:indexes withKeys:keys undoManager:um];
	[um removeAllActions];	
	[self resetObservers];
	
	[um beginUndoGrouping];
		[container _removeNodes:[NSArray arrayWithObjects:node1, node3, nil] undoManager:um];
	[um endUndoGrouping];
	
	STAssertTrue([[container nodesInside] count]==1, @"should have deleted them.. %i", [[container nodesInside] count]);
	STAssertTrue(nodesChangedCount==1, @"received incorrect number of notifications %i", nodesChangedCount);
	STAssertTrue([container.nodesInside objectAtIndex:0]==node2, @"should BE!");
	STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo remove nodes"], @"Incorrect Undo Title :%@", [um undoMenuItemTitle]);
	STAssertFalse( [container isEmpty], @"should be empty");

	[um undo]; //-- add again
	STAssertTrue([[container nodesInside] count]==3, @"should have deleted them.. %i", [[container nodesInside] count]);
	STAssertTrue(nodesChangedCount==2, @"received incorrect number of notifications %i", nodesChangedCount);
	STAssertTrue([[um redoMenuItemTitle] isEqualToString:@"Redo remove nodes"], @"Incorrect Redo Title :%@", [um redoMenuItemTitle]);
	STAssertFalse( [container isEmpty], @"should be empty");

	[um redo]; //-- remove again
	STAssertTrue([[container nodesInside] count]==1, @"should have deleted them.. %i", [[container nodesInside] count]);
	STAssertTrue(nodesChangedCount==3, @"received incorrect number of notifications %i", nodesChangedCount);
	STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo remove nodes"], @"Incorrect Undo Title :%@", [um undoMenuItemTitle]);
	STAssertFalse( [container isEmpty], @"should be empty");

	// -- remove observer
	[container removeObserver:self forKeyPath:@"nodesInside.array"];
}

- (void)test_removeInputsUndoManager {
	//- (void)_removeInputs:(NSArray *)inputs undoManager:(NSUndoManager *)um
	
	//-- observe all items
	[container addObserver:self forKeyPath:@"inputs.array" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHChildContainerTests"];

	SHProtoInputAttribute *inAtt1 = [SHProtoInputAttribute makeChildWithName:@"in1"], *inAtt2=[SHProtoInputAttribute makeChildWithName:@"in2"], *inAtt3=[SHProtoInputAttribute makeChildWithName:@"in3"];
	NSArray *inputs = [NSArray arrayWithObjects:inAtt1, inAtt2, inAtt3, nil];
	NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,3)];
	NSArray *keys = [NSArray arrayWithObjects:[inAtt1 name].value, [inAtt2 name].value, [inAtt3 name].value, nil];
	
	// Just to set up.. we must be careful we dont undo this
	[container _addInputs:inputs atIndexes:indexes withKeys:keys undoManager:um];
	[um removeAllActions];	
	[self resetObservers];

	[um beginUndoGrouping];
		[container _removeInputs:[NSArray arrayWithObjects:inAtt1, inAtt3, nil] undoManager:um];
	[um endUndoGrouping];
	
	STAssertTrue([[container inputs] count]==1, @"should have deleted them.. %i", [[container inputs] count]);
	STAssertTrue(inputsChangedCount==1, @"received incorrect number of notifications %i", inputsChangedCount);
	STAssertTrue([container.inputs objectAtIndex:0]==inAtt2, @"should BE!");
	STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo remove inputs"], @"Incorrect Undo Title :%@", [um undoMenuItemTitle]);
	STAssertFalse( [container isEmpty], @"should be empty");

	[um undo]; //-- add again
	STAssertTrue([[container inputs] count]==3, @"should have deleted them.. %i", [[container inputs] count]);
	STAssertTrue(inputsChangedCount==2, @"received incorrect number of notifications %i", inputsChangedCount);	
	STAssertTrue([[um redoMenuItemTitle] isEqualToString:@"Redo remove inputs"], @"Incorrect Redo Title :%@", [um redoMenuItemTitle]);
	STAssertFalse( [container isEmpty], @"should be empty");

	[um redo]; //-- remove again
	STAssertTrue([[container inputs] count]==1, @"should have deleted them.. %i", [[container inputs] count]);
	STAssertTrue(inputsChangedCount==3, @"received incorrect number of notifications %i", inputsChangedCount);
    STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo remove inputs"], @"Incorrect Undo Title :%@", [um undoMenuItemTitle]);
	STAssertFalse( [container isEmpty], @"should be empty");

	// -- remove observer
	[container removeObserver:self forKeyPath:@"inputs.array"];
}


- (void)test_removeOutputsUndoManager {
	// - (void)_removeOutputs:(NSArray *)outputs undoManager:(NSUndoManager *)um

	//-- observe all items
	[container addObserver:self forKeyPath:@"outputs.array" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHChildContainerTests"];

	SHProtoOutputAttribute *outAtt1 = [SHProtoOutputAttribute makeChildWithName:@"out1"], *outAtt2=[SHProtoOutputAttribute makeChildWithName:@"out2"], *outAtt3=[SHProtoOutputAttribute makeChildWithName:@"out3"];
	NSArray *outputs = [NSArray arrayWithObjects:outAtt1, outAtt2, outAtt3, nil];
	NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,3)];
	NSArray *keys = [NSArray arrayWithObjects:[outAtt1 name].value, [outAtt2 name].value, [outAtt3 name].value, nil];

	// Just to set up.. we must be careful we dont undo this
	[container _addOutputs:outputs atIndexes:indexes withKeys:keys undoManager:um];
	[um removeAllActions];	
	[self resetObservers];
	
	[um beginUndoGrouping];
		[container _removeOutputs:[NSArray arrayWithObjects:outAtt1, outAtt3, nil] undoManager:um];
	[um endUndoGrouping];
	
	STAssertTrue([[container outputs] count]==1, @"should have deleted them.. %i", [[container outputs] count]);
	STAssertTrue(outputsChangedCount==1, @"received incorrect number of notifications %i", outputsChangedCount);
	STAssertTrue([container.outputs objectAtIndex:0]==outAtt2, @"should BE!");
    STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo remove outputs"], @"Incorrect Undo Title :%@", [um undoMenuItemTitle]);
	STAssertFalse( [container isEmpty], @"should be empty");

	[um undo]; //-- add again
	STAssertTrue([[container outputs] count]==3, @"should have readded them.. %i", [[container outputs] count]);
	STAssertTrue(outputsChangedCount==2, @"received incorrect number of notifications %i", outputsChangedCount);
	STAssertTrue([[um redoMenuItemTitle] isEqualToString:@"Redo remove outputs"], @"Incorrect Redo Title :%@", [um redoMenuItemTitle]);
	STAssertFalse( [container isEmpty], @"should be empty");

	[um redo]; //-- remove again
	STAssertTrue([[container outputs] count]==1, @"should have deleted them.. %i", [[container outputs] count]);
	STAssertTrue(outputsChangedCount==3, @"received incorrect number of notifications %i", outputsChangedCount);
    STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo remove outputs"], @"Incorrect Undo Title :%@", [um undoMenuItemTitle]);
	STAssertFalse( [container isEmpty], @"should be empty");

	// -- remove observer
	[container removeObserver:self forKeyPath:@"outputs.array"];
}

- (void)testInterConnectorForAnd {
	// - (SHInterConnector *)interConnectorFor:(SHProtoAttribute *)inAtt1 and:(SHProtoAttribute *)inAtt2;
	
	// inAttribute to inAttribute
	SHProtoOutputAttribute *outAtt1 = [SHProtoOutputAttribute makeChildWithName:@"out1"], *outAtt2=[SHProtoOutputAttribute makeChildWithName:@"out2"], *outAtt3=[SHProtoOutputAttribute makeChildWithName:@"out3"];
	NSArray *outputs = [NSArray arrayWithObjects:outAtt1, outAtt2, outAtt3, nil];
	NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,3)];
	NSArray *keys = [NSArray arrayWithObjects:[outAtt1 name].value, [outAtt2 name].value, [outAtt3 name].value, nil];
	[container _addOutputs:outputs atIndexes:indexes withKeys:keys undoManager:nil];
	
	SHProtoInputAttribute *inAtt1 = [SHProtoInputAttribute makeChildWithName:@"in1"], *inAtt2=[SHProtoInputAttribute makeChildWithName:@"in2"], *inAtt3=[SHProtoInputAttribute makeChildWithName:@"in3"];
	NSArray *inputs = [NSArray arrayWithObjects:inAtt1, inAtt2, inAtt3, nil];
	indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,3)];
	keys = [NSArray arrayWithObjects:[inAtt1 name].value, [inAtt2 name].value, [inAtt3 name].value, nil];
	[container _addInputs:inputs atIndexes:indexes withKeys:keys undoManager:nil];
	
	//-- hmm got to make an interconnector - how?
	SHInterConnector *ic1 = [SHInterConnector makeChildWithName:@"ic1"];
	SHInterConnector *ic2 = [SHInterConnector makeChildWithName:@"ic2"];
	SHInterConnector *ic3 = [SHInterConnector makeChildWithName:@"ic3"];
	NSArray *ics = [NSArray arrayWithObjects:ic1, ic2, ic3, nil];
	[container _addInterconnectors:ics between:outputs and:inputs undoManager:nil];

	// Just to set up.. we must be careful we dont undo this
	SHInterConnector* int1 = [container interConnectorFor:inAtt1 and:outAtt1];
	STAssertEqualObjects(int1, ic1, @"should be");
	SHInterConnector* int2 = [container interConnectorFor:outAtt1 and:inAtt1];
	STAssertEqualObjects(int2, ic1, @"should be");
	SHInterConnector* int3 = [container interConnectorFor:inAtt1 and:nil];
	STAssertNil(int3, @"no");
	SHInterConnector* int4 = [container interConnectorFor:inAtt1 and:[SHChild makeChildWithName:@"in2"]];
	STAssertNil(int4, @"no");
	SHInterConnector* int5 = [container interConnectorFor:inAtt2 and:outAtt2];
	STAssertEqualObjects(int5, ic2, @"should be");
	SHInterConnector* int6 = [container interConnectorFor:inAtt3 and:outAtt3];
	STAssertEqualObjects(int6, ic3, @"should be");
	SHInterConnector* int7 = [container interConnectorFor:inAtt2 and:outAtt1];
	STAssertNil(int7, @"no");
}

- (void)testCountOfChildren {
	
	[container _addNode:[SHChild makeChildWithName:@"n1"] atIndex:0 withKey:@"n1" undoManager:nil];
	SHProtoInputAttribute *i1 = [SHProtoInputAttribute makeChildWithName:@"i1"];
	SHProtoOutputAttribute *o1 = [SHProtoOutputAttribute makeChildWithName:@"o1"];
	[container _addInput:i1 atIndex:0 withKey:@"i1" undoManager:nil];
	[container _addOutput:o1 atIndex:0 withKey:@"o1" undoManager:nil];
	SHInterConnector *anInterConnector = [SHInterConnector makeChildWithName:@"ic1"];
	[container _addInterConnector:anInterConnector between:i1 and:o1 undoManager:um];
	STAssertTrue([container countOfChildren]==4, [NSString stringWithFormat:@"count is %i", [container countOfChildren]]);
}


@end
