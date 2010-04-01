//
//  SHParentTests.m
//  SHNodeGraph
//
//  Created by steve hooley on 25/02/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "SHParent.h"
#import "SHParent_Connectable.h"
#import "SHProtoInputAttribute.h"
#import "SHProtoOutputAttribute.h"
#import "NodeName.h"
#import "SH_Path.h"
#import "SHChildContainer.h"
#import "SHInterConnector.h"

static int _numberOfNotificationsReceived, _nodeAddedNotifications, _selectionChangedCount, _interConnectorsChanged, inputsChangedCount=0, outputsChangedCount=0;
static int _nodeReplacedNotifications=0, _nodeInsertedNotifications=0, _nodeChangedNotifications=0, _nodeRemovalNotifications=0;
static BOOL _allChildrenDidChange;

@interface SHParentTests : SenTestCase {

	NSArray		*_otherNodesAffectedByRemove;
	SHParent	*_parent;
}

- (void)resetObservers;

@end

@implementation SHParentTests

- (void)setUp {

	_parent = [[SHParent alloc] init];
	[_parent changeNameWithStringTo:@"rootNode" fromParent:nil undoManager:nil];
}

- (void)tearDown {

	[_parent release];
}

- (void)resetObservers {

	_allChildrenDidChange = NO;
	_numberOfNotificationsReceived=0;
	
	// Nodes
	_nodeAddedNotifications=0;
	_nodeReplacedNotifications=0;
	_nodeInsertedNotifications=0;
	_nodeChangedNotifications=0;
	_nodeRemovalNotifications=0;
	
	_selectionChangedCount=0;
	_interConnectorsChanged=0, inputsChangedCount=0, outputsChangedCount=0;
	
	[_otherNodesAffectedByRemove release];
	_otherNodesAffectedByRemove = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	
	_numberOfNotificationsReceived++;
	
	NSString *cntxt = (NSString *)context;
	if(cntxt==nil)
		[NSException raise:@"MUST SUPPLY A CONTEXT" format:@"MUST SUPPLY A CONTEXT"];
	
    if( [cntxt isEqualToString:@"SHParentTests"] )
	{
		id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
		BOOL oldValueNullOrNil = [oldValue isEqual:[NSNull null]] || oldValue==nil;
		id newValue = [change objectForKey:NSKeyValueChangeNewKey];
		BOOL newValueNullOrNil = [newValue isEqual:[NSNull null]] || newValue==nil;
		id changeKind = [change objectForKey:NSKeyValueChangeKindKey];
		id changeIndexes = [change objectForKey:NSKeyValueChangeIndexesKey]; //  NSKeyValueChangeInsertion, NSKeyValueChangeRemoval, or NSKeyValueChangeReplacement, 		
		
		NSNumber *isPrior = [change objectForKey:NSKeyValueChangeNotificationIsPriorKey];
		if(isPrior){
			_otherNodesAffectedByRemove = [[object otherNodesAffectedByRemove] retain];
			return;
		}
		
		if ([keyPath isEqualToString:@"testSHNode.allChildren"]) {
			_allChildrenDidChange = YES;
		} else
			if ([keyPath isEqualToString:@"nodesInside.selection"]) {
				_selectionChangedCount++;
			} else
				if ([keyPath isEqualToString:@"childContainer.nodesInside.array"] ) {
					_nodeAddedNotifications++;
					switch ([changeKind intValue]) 
					{
						case NSKeyValueChangeInsertion:
							NSAssert( oldValueNullOrNil, @"what would this be for an insertion?");
							NSAssert( newValueNullOrNil==NO, @"need this for an insertion");
							NSAssert( changeIndexes!=nil, @"need this for an insertion?");
							_nodeInsertedNotifications++;
							break;
						case NSKeyValueChangeReplacement:
							NSAssert( oldValueNullOrNil==NO, @"must have replaced something");
							NSAssert( newValueNullOrNil==NO, @"need this for a replacement");
							NSAssert( changeIndexes!=nil, @"need this for a replacement");
							_nodeReplacedNotifications++;
							break;
						case NSKeyValueChangeSetting:
							_nodeChangedNotifications++;
							break;
						case NSKeyValueChangeRemoval:
							NSAssert( oldValueNullOrNil==NO, @"need this for a removal");
							NSAssert( newValueNullOrNil==YES, @"what would this be for a removal?");
							NSAssert( changeIndexes!=nil, @"need this for an removal");
							_nodeRemovalNotifications++;
							break;
					}
				} else if ([keyPath isEqualToString:@"childContainer.shInterConnectorsInside.array"]) {
					_interConnectorsChanged++;
					
				} else if([keyPath isEqualToString:@"childContainer.inputs.array"]){
					inputsChangedCount++;
					
				} else if([keyPath isEqualToString:@"childContainer.outputs.array"]){
					outputsChangedCount++;
					
				} else {
					[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];   
				}
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];   
	}
}


- (void)testCheckItemsAreValidChildren {
// - (BOOL)_checkItemsAreValidChildren:(NSArray *)objects

	SHChild *ch1 = [SHChild makeChildWithName:@"1"];
	SHChild *ch2 = [SHChild makeChildWithName:@"2"];
	SHParent *node1 = [SHParent makeChildWithName:@"1"];
	SHParent *node2 = [SHParent makeChildWithName:@"2"];
	
	NSArray *itemsToAdd1 = [NSArray arrayWithObjects:ch1, ch2, nil];
	NSArray *itemsToAdd2 = [NSArray arrayWithObjects:node1, node2, nil];
	NSArray *itemsToAdd3 = [NSArray arrayWithObjects:[SHProtoInputAttribute makeChildWithName:@"1"], [SHProtoInputAttribute makeChildWithName:@"1"], nil];
	NSArray *itemsToAdd4 = [NSArray arrayWithObjects:[SHProtoOutputAttribute makeChildWithName:@"o1"], [SHProtoOutputAttribute makeChildWithName:@"o1"], nil];
	NSArray *itemsToAdd5 = [NSArray arrayWithObjects:[SHInterConnector makeChildWithName:@"i1"], [SHInterConnector makeChildWithName:@"i1"], nil];

	// Items have to be the correct type
	STAssertFalse([_parent checkItemsAreValidChildren:itemsToAdd1], @"cant add children");

	//	-- item must be of correct type
	STAssertTrue([_parent checkItemsAreValidChildren:itemsToAdd2], @"These should be ok");
	
	//	-- item cant already have a parent
	[_parent _makeParentOfObjects:itemsToAdd2 undoManager:nil];
	STAssertFalse([_parent checkItemsAreValidChildren:itemsToAdd2], @"cant add items with parent");
	
	STAssertTrue([_parent checkItemsAreValidChildren:itemsToAdd3], @"should be able to add inputs");
	STAssertTrue([_parent checkItemsAreValidChildren:itemsToAdd4], @"should be able to add outputs");
	
	STAssertTrue([_parent checkItemsAreValidChildren:itemsToAdd5], @"should be able to add connectors");
	
	SHParent *ch3 = [SHParent makeChildWithName:@"c3"];
	SHParent *node3 = [SHParent makeChildWithName:@"p3"];
	[node3 addChild:ch3 atIndex:-1 undoManager:nil];
	STAssertFalse([ch3 checkItemsAreValidChildren:[NSArray arrayWithObject:node3]], @"should be able to add connectors");
}

- (void)test_prepareObjectsNamesForAdding {
	// - (NSArray *)_prepareObjectsNamesForAdding:(NSArray *)objects withUndoManager:(NSUndoManager *)um;

	NSUndoManager *um = [[NSUndoManager alloc] init];

	SHParent *node1 = [SHParent makeChildWithName:@"N1"];
	SHParent *node2 = [SHParent makeChildWithName:@"N1"];
	SHParent *node3 = [[[SHParent alloc] init] autorelease];
	NSArray *itemsToAdd = [NSArray arrayWithObjects:node1, node2, node3, nil];
	NSArray *returnedNames = [_parent _prepareObjectsNamesForAdding:itemsToAdd withUndoManager:um];
	STAssertTrue( [[[returnedNames objectAtIndex:0] value] isEqualToString:@"N1"], @"should be %@", [[returnedNames objectAtIndex:0] value] );
	STAssertTrue( [[[returnedNames objectAtIndex:1] value] isEqualToString:@"N2"], @"should be %@", [[returnedNames objectAtIndex:1] value] );
	STAssertTrue( [[[returnedNames objectAtIndex:2] value] isEqualToString:@"SHParent1"], @"should be %@", [[returnedNames objectAtIndex:2] value] );

	STAssertTrue( [[node1.name value] isEqualToString:@"N1"], @"should be %@", [node1.name value] );
	STAssertTrue( [[node2.name value] isEqualToString:@"N2"], @"should be %@", [node2.name value] );
	STAssertTrue( [[node3.name value] isEqualToString:@"SHParent1"], @"should be %@", [node3.name value] );
	
	[um undo];
	STAssertTrue( [[node1.name value] isEqualToString:@"N1"], @"should be %@", [node1.name value] );
	STAssertTrue( [[node2.name value] isEqualToString:@"N1"], @"should be %@", [node2.name value] );
	STAssertTrue( [[node3.name value] isEqualToString:@"SHParent1"], @"should be %@", [node3.name value] );

	[um redo];
	STAssertTrue( [[node1.name value] isEqualToString:@"N1"], @"should be %@", [node1.name value] );
	STAssertTrue( [[node2.name value] isEqualToString:@"N2"], @"should be %@", [node2.name value] );
	STAssertTrue( [[node3.name value] isEqualToString:@"SHParent1"], @"should be %@", [node3.name value] );

	[um removeAllActions];
	[um release];
}

- (void)test_undoSetParentOfObjectUndoManager {
	//- (void)_makeParentOfObject:(SHChild *)value undoManager:(NSUndoManager *)theUmm
	// - (void)_undoSetParentOfObject:(SHChild *)value undoManager:(NSUndoManager *)theUmm;
	
	NSUndoManager *um = [[NSUndoManager alloc] init];

	OCMockObject *mockSHChild = [OCMockObject mockForClass:[SHChild class]];
	SHParent *node1 = [SHParent makeChildWithName:@"1"];
	[[mockSHChild expect] setParentSHNode:node1];
	[[mockSHChild expect] hasBeenAddedToParentSHNode];
	[node1 _makeParentOfObject:(id)mockSHChild undoManager:um];
	[mockSHChild verify];
	
	[[mockSHChild expect] isAboutToBeDeletedFromParentSHNode];
	[[mockSHChild expect] setParentSHNode:nil];
	[um undo];
	[mockSHChild verify];
	
	[[mockSHChild expect] setParentSHNode:node1];
	[[mockSHChild expect] hasBeenAddedToParentSHNode];
	[um redo];
	[mockSHChild verify];

	[um removeAllActions];
	[um release];
}

- (void)test_makeParentOfObjectsUndoManager {
	//- (void)_makeParentOfObjects:(NSArray *)values undoManager:(NSUndoManager *)theUmm;
	
	NSUndoManager *um = [[NSUndoManager alloc] init];

	SHParent *node1 = [SHParent makeChildWithName:@"1"];
	SHParent *node2 = [SHParent makeChildWithName:@"2"];
	NSArray *itemsToAdd = [NSArray arrayWithObjects:node1, node2, nil];
	[_parent _makeParentOfObjects:itemsToAdd undoManager:um];
	
	STAssertTrue( node1.parentSHNode==_parent, @"gone wrong");
	STAssertTrue( node2.parentSHNode==_parent, @"gone wrong");

	[um undo]; //-- unset parent
	STAssertTrue( node1.parentSHNode==nil, @"gone wrong");
	STAssertTrue( node2.parentSHNode==nil, @"gone wrong");
	
	[um redo]; //-- set parent again
	STAssertTrue( node1.parentSHNode==_parent, @"gone wrong");
	STAssertTrue( node2.parentSHNode==_parent, @"gone wrong");
	
	[um removeAllActions];
	[um release];
}

- (void)test_undoSetParentOfObjectsUndoManager {
	//- (void)_undoSetParentOfObjects:(NSArray *)values undoManager:(NSUndoManager *)theUmm;

	SHParent *node1 = [SHParent makeChildWithName:@"1"];
	SHParent *node2 = [SHParent makeChildWithName:@"2"];
	NSArray *itemsToAdd = [NSArray arrayWithObjects:node1, node2, nil];
	[_parent _makeParentOfObjects:itemsToAdd undoManager:nil];
	STAssertTrue( node1.parentSHNode==_parent, @"gone wrong");
	STAssertTrue( node2.parentSHNode==_parent, @"gone wrong");

	NSUndoManager *um = [[NSUndoManager alloc] init];
	[um beginUndoGrouping];
		[_parent _undoSetParentOfObjects:itemsToAdd undoManager:um];
	[um endUndoGrouping];
	STAssertTrue( node1.parentSHNode==nil, @"gone wrong");
	STAssertTrue( node2.parentSHNode==nil, @"gone wrong");
	
	[um undo]; //-- set parent again
	STAssertTrue( node1.parentSHNode==_parent, @"gone wrong");
	STAssertTrue( node2.parentSHNode==_parent, @"gone wrong");
	
	[um redo]; //-- unset parent again
	STAssertTrue( node1.parentSHNode==nil, @"gone wrong");
	STAssertTrue( node2.parentSHNode==nil, @"gone wrong");
	
	[um removeAllActions];
	[um release];
}

#pragma mark - Add Methods

// -- adding is undoable and sets the parent
// -- it doesn't do anything like check for interconnectors when deleting so aren't for using directly in working graphs

/* These add and set the parent and are undoable. They Don't check for connections etc. */

- (void)testAddChildAtIndexUndoManager {
	// - (void)addChild:(SHChild *)object atIndex:(NSInteger)index undoManager:(NSUndoManager *)um
	
	STAssertTrue( [_parent isLeaf], @"shouldnt have any children");
	[self resetObservers];
	NSUndoManager *um = [[NSUndoManager alloc] init];
	
	[_parent addObserver:self forKeyPath:@"childContainer.nodesInside.array" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParentTests"];

	SHChild *ch1 = [SHChild makeChildWithName:@"1"];
	STAssertThrows([_parent addChild:ch1 atIndex:-1 undoManager:um], @"SHChild should not count as valid");
	STAssertTrue( [_parent isLeaf], @"shouldnt have any children");
	STAssertNil( ch1.parentSHNode, @"fuck off" );
	STAssertTrue(_nodeAddedNotifications==0, @"received incorrect number of notifications %i", _nodeAddedNotifications);
	// -- should not have been able to add these
	
	SHParent *par1 = [SHParent makeChildWithName:@"1"], *par2 = [SHParent makeChildWithName:@"2"];
	[_parent addChild:par1 atIndex:-1 undoManager:um];
	[_parent addChild:par2 atIndex:-1 undoManager:um];
	STAssertTrue([[_parent nodesInside] count]==2, @"should have added Nodes.. %i", [[_parent nodesInside] count]);
	STAssertFalse( [_parent isLeaf], @"shouldnt have any children");
	STAssertTrue(_nodeAddedNotifications==2, @"received incorrect number of notifications %i", _nodeAddedNotifications);
	STAssertTrue(_nodeInsertedNotifications==2, @"received incorrect number of notifications %i", _nodeInsertedNotifications);
	
	STAssertNotNil( par1.parentSHNode, @"fuck off" );
	// -- this should have worked fine
	
	[um undo];
	STAssertNil( par1.parentSHNode, @"fuck off" );
	STAssertTrue([[_parent nodesInside] count]==0, @"should have added Nodes.. %i", [[_parent nodesInside] count]);
	STAssertTrue(_nodeAddedNotifications==4, @"received incorrect number of notifications %i", _nodeAddedNotifications);
	[um redo];
	STAssertNotNil( par1.parentSHNode, @"fuck off" );
	STAssertTrue([[_parent nodesInside] count]==2, @"should have added Nodes.. %i", [[_parent nodesInside] count]);
	STAssertTrue(_nodeAddedNotifications==6, @"received incorrect number of notifications %i", _nodeAddedNotifications);
	[um removeAllActions];
	
	// -- test we can undo names back to shit names
	SHParent *par3 = [SHParent makeChildWithName:@"1"], *par4 = [SHParent makeChildWithName:@"2"];
	[_parent addChild:par3 atIndex:-1 undoManager:um];
	[_parent addChild:par4 atIndex:-1 undoManager:um];
	STAssertTrue( [par3.name.value isEqualToString:@"3"], @"Name should have been modified as it was already staken %@", par3.name.value);
	[um undo];
	STAssertTrue( [par3.name.value isEqualToString:@"1"], @"Name should have been modified as it was already staken %@", par3.name.value);
	[um redo];
	STAssertTrue( [par3.name.value isEqualToString:@"3"], @"Name should have been modified as it was already staken %@", par3.name.value);
	[um removeAllActions];
	
	// -- test adding at indexes and shit
	SHParent *par5 = [SHParent makeChildWithName:@"1"], *par6 = [SHParent makeChildWithName:@"2"];
	[_parent addChild:par5 atIndex:2 undoManager:um];
	[_parent addChild:par6 atIndex:3 undoManager:um];
	STAssertTrue( [[_parent nodesInside] objectAtIndex:0]==par1, @"doh");
	STAssertTrue( [[_parent nodesInside] objectAtIndex:1]==par2, @"doh");
	STAssertTrue( [[_parent nodesInside] objectAtIndex:2]==par5, @"doh");
	STAssertTrue( [[_parent nodesInside] objectAtIndex:3]==par6, @"doh");
	STAssertTrue( [[_parent nodesInside] objectAtIndex:4]==par3, @"doh");
	STAssertTrue( [[_parent nodesInside] objectAtIndex:5]==par4, @"doh");
	
	[_parent removeObserver:self forKeyPath:@"childContainer.nodesInside.array"];
	[um removeAllActions];
	[um release];	
}

- (void)testAddItemsOfSingleTypeAtIndexes {
	//- (void)addItemsOfSingleType:(NSArray *)objects atIndexes:(NSIndexSet *)indexes undoManager:(NSUndoManager *)um;

	STAssertTrue( [_parent isLeaf], @"shouldnt have any children");
	[self resetObservers];
	NSUndoManager *um = [[NSUndoManager alloc] init];
	[_parent addObserver:self forKeyPath:@"childContainer.nodesInside.array" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParentTests"];
	SHChild *ch1 = [SHChild makeChildWithName:@"1"], *ch2 = [SHChild makeChildWithName:@"2"];
	NSArray *itemsToAdd = [NSArray arrayWithObjects:ch1, ch2, nil];
	STAssertThrows([_parent addItemsOfSingleType:itemsToAdd atIndexes:nil undoManager:um], @"SHChild should not count as valid");
	
	STAssertTrue( [_parent isLeaf], @"shouldnt have any children");
	STAssertNil( ch1.parentSHNode, @"fuck off" );
	STAssertTrue(_nodeAddedNotifications==0, @"received incorrect number of notifications %i", _nodeAddedNotifications);
	// -- should not have been able to add these
	
	SHParent *par1 = [SHParent makeChildWithName:@"1"], *par2 = [SHParent makeChildWithName:@"2"];
	NSArray *itemsToAdd2 = [NSArray arrayWithObjects:par1, par2, nil];
	[_parent addItemsOfSingleType:itemsToAdd2 atIndexes:nil undoManager:um];
	STAssertTrue([[_parent nodesInside] count]==2, @"should have added Nodes.. %i", [[_parent nodesInside] count]);
	STAssertFalse( [_parent isLeaf], @"shouldnt have any children");
	STAssertTrue(_nodeAddedNotifications==1, @"received incorrect number of notifications %i", _nodeAddedNotifications);
	STAssertNotNil( par1.parentSHNode, @"fuck off" );
	// -- this should have worked fine
	
	[um undo];
	STAssertNil( par1.parentSHNode, @"fuck off" );
	STAssertTrue([[_parent nodesInside] count]==0, @"should have added Nodes.. %i", [[_parent nodesInside] count]);
	STAssertTrue(_nodeAddedNotifications==2, @"received incorrect number of notifications %i", _nodeAddedNotifications);
	[um redo];
	STAssertNotNil( par1.parentSHNode, @"fuck off" );
	STAssertTrue([[_parent nodesInside] count]==2, @"should have added Nodes.. %i", [[_parent nodesInside] count]);
	STAssertTrue(_nodeAddedNotifications==3, @"received incorrect number of notifications %i", _nodeAddedNotifications);
	[um removeAllActions];
	
	// -- test we can undo names back to shit names
	SHParent *par3 = [SHParent makeChildWithName:@"1"], *par4 = [SHParent makeChildWithName:@"2"];
	NSArray *itemsToAdd3 = [NSArray arrayWithObjects:par3, par4, nil];
	[_parent addItemsOfSingleType:itemsToAdd3 atIndexes:nil undoManager:um];
	STAssertTrue( [par3.name.value isEqualToString:@"3"], @"Name should have been modified as it was already staken %@", par3.name.value);
	[um undo];
	STAssertTrue( [par3.name.value isEqualToString:@"1"], @"Name should have been modified as it was already staken %@", par3.name.value);
	[um redo];
	STAssertTrue( [par3.name.value isEqualToString:@"3"], @"Name should have been modified as it was already staken %@", par3.name.value);
	[um removeAllActions];
	
	// -- test adding at indexes and shit
	SHParent *par5 = [SHParent makeChildWithName:@"1"], *par6 = [SHParent makeChildWithName:@"2"];
	NSArray *itemsToAdd4 = [NSArray arrayWithObjects:par5, par6, nil];
	[_parent addItemsOfSingleType:itemsToAdd4 atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, 2)] undoManager:um];
	STAssertTrue( [[_parent nodesInside] objectAtIndex:0]==par1, @"doh");
	STAssertTrue( [[_parent nodesInside] objectAtIndex:1]==par2, @"doh");
	STAssertTrue( [[_parent nodesInside] objectAtIndex:2]==par5, @"doh");
	STAssertTrue( [[_parent nodesInside] objectAtIndex:3]==par6, @"doh");
	STAssertTrue( [[_parent nodesInside] objectAtIndex:4]==par3, @"doh");
	STAssertTrue( [[_parent nodesInside] objectAtIndex:5]==par4, @"doh");
	
	[_parent removeObserver:self forKeyPath:@"childContainer.nodesInside.array"];
	[um removeAllActions];
	[um release];
}

- (void)testSameAsAboveWithInputs {

	STAssertTrue( [_parent isLeaf], @"shouldnt have any children");
	[self resetObservers];
	NSUndoManager *um = [[NSUndoManager alloc] init];
	[_parent addObserver:self forKeyPath:@"childContainer.inputs.array" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParentTests"];

	SHProtoInputAttribute *input1 = [SHProtoInputAttribute makeChildWithName:@"i1"], *input2 = [SHProtoInputAttribute makeChildWithName:@"2"];
	NSArray *itemsToAdd2 = [NSArray arrayWithObjects:input1, input2, nil];
	[_parent addItemsOfSingleType:itemsToAdd2 atIndexes:nil undoManager:um];
	STAssertTrue([[_parent inputs] count]==2, @"should have added Nodes.. %i", [[_parent inputs] count]);
	STAssertFalse( [_parent isLeaf], @"shouldnt have any children");
	STAssertTrue(inputsChangedCount==1, @"received incorrect number of notifications %i", inputsChangedCount);
	STAssertNotNil( input1.parentSHNode, @"fuck off" );
	// -- this should have worked fine
	
	[um undo];
	STAssertNil( input1.parentSHNode, @"fuck off" );
	STAssertTrue([[_parent inputs] count]==0, @"should have added Nodes.. %i", [[_parent inputs] count]);
	STAssertTrue(inputsChangedCount==2, @"received incorrect number of notifications %i", inputsChangedCount);
	[um redo];
	STAssertNotNil( input1.parentSHNode, @"fuck off" );
	STAssertTrue([[_parent inputs] count]==2, @"should have added Nodes.. %i", [[_parent inputs] count]);
	STAssertTrue(inputsChangedCount==3, @"received incorrect number of notifications %i", inputsChangedCount);
	[um removeAllActions];
	
	// -- test we can undo names back to shit names
	SHProtoInputAttribute *input3 = [SHProtoInputAttribute makeChildWithName:@"i1"], *input4 = [SHProtoInputAttribute makeChildWithName:@"2"];
	NSArray *itemsToAdd3 = [NSArray arrayWithObjects:input3, input4, nil];
	[_parent addItemsOfSingleType:itemsToAdd3 atIndexes:nil undoManager:um];
	STAssertTrue( [input3.name.value isEqualToString:@"i2"], @"Name should have been modified as it was already staken %@", input3.name.value);
	[um undo];
	STAssertTrue( [input3.name.value isEqualToString:@"i1"], @"Name should have been modified as it was already staken %@", input3.name.value);
	[um redo];
	STAssertTrue( [input3.name.value isEqualToString:@"i2"], @"Name should have been modified as it was already staken %@", input3.name.value);
	[um removeAllActions];
	
	// -- test adding at indexes and shit
	SHProtoInputAttribute *input5 = [SHProtoInputAttribute makeChildWithName:@"i1"], *input6 = [SHProtoInputAttribute makeChildWithName:@"2"];
	NSArray *itemsToAdd4 = [NSArray arrayWithObjects:input5, input6, nil];
	[_parent addItemsOfSingleType:itemsToAdd4 atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, 2)] undoManager:um];
	STAssertTrue( [[_parent inputs] objectAtIndex:0]==input1, @"doh");
	STAssertTrue( [[_parent inputs] objectAtIndex:1]==input2, @"doh");
	STAssertTrue( [[_parent inputs] objectAtIndex:2]==input5, @"doh");
	STAssertTrue( [[_parent inputs] objectAtIndex:3]==input6, @"doh");
	STAssertTrue( [[_parent inputs] objectAtIndex:4]==input3, @"doh");
	STAssertTrue( [[_parent inputs] objectAtIndex:5]==input4, @"doh");
	
	[_parent removeObserver:self forKeyPath:@"childContainer.inputs.array"];
	[um removeAllActions];
	[um release];
}

- (void)test_validParentForConnectionBetweenOutletOf_andInletOfAtt {
	// - (BOOL)_validParentForConnectionBetweenOutletOf:(SHProtoAttribute *)outAttr andInletOfAtt:(SHProtoAttribute *)inAttr
	
	SHParent *childnode1 = [SHParent makeChildWithName:@"1"];
	SHParent *childnode2 = [SHParent makeChildWithName:@"2"];
	[_parent addChild:childnode1 atIndex:-1 undoManager:nil];
	[_parent addChild:childnode2 atIndex:-1 undoManager:nil];
	
	// attributes in root node
	SHProtoInputAttribute *inAtt1 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	SHProtoOutputAttribute *outAtt1 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	[_parent addChild:inAtt1 atIndex:-1 undoManager:nil];
	[_parent addChild:outAtt1 atIndex:-1 undoManager:nil];

	// attributes in child 1
	SHProtoInputAttribute *inAtt2 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	SHProtoOutputAttribute *outAtt2 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	[childnode1 addChild:inAtt2 atIndex:-1 undoManager:nil];
	[childnode1 addChild:outAtt2 atIndex:-1 undoManager:nil];
	
	// attributes in child 2
	SHProtoInputAttribute *inAtt3 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	[childnode2 addChild:inAtt3 atIndex:-1 undoManager:nil];

	STAssertTrue( [_parent _validParentForConnectionBetweenOutletOf:inAtt1 andInletOfAtt:inAtt2], @"connection wont validate" );
	STAssertTrue( [_parent _validParentForConnectionBetweenOutletOf:outAtt1 andInletOfAtt:inAtt2], @"connection wont validate" );
	STAssertTrue( [_parent _validParentForConnectionBetweenOutletOf:outAtt2 andInletOfAtt:outAtt1], @"connection wont validate" );
	STAssertTrue( [_parent _validParentForConnectionBetweenOutletOf:outAtt2 andInletOfAtt:inAtt1], @"connection wont validate" );
	STAssertTrue( [_parent _validParentForConnectionBetweenOutletOf:inAtt1 andInletOfAtt:outAtt1], @"connection wont validate" );
	STAssertTrue( [_parent _validParentForConnectionBetweenOutletOf:outAtt1 andInletOfAtt:inAtt1], @"connection wont validate" );
	
	STAssertFalse( [_parent _validParentForConnectionBetweenOutletOf:inAtt2 andInletOfAtt:inAtt1], @"connection wont validate" );
	STAssertFalse( [_parent _validParentForConnectionBetweenOutletOf:inAtt1 andInletOfAtt:outAtt2], @"connection wont validate" );
	STAssertFalse( [_parent _validParentForConnectionBetweenOutletOf:outAtt1 andInletOfAtt:outAtt2], @"connection wont validate" );
	
	STAssertTrue( [_parent _validParentForConnectionBetweenOutletOf:outAtt2 andInletOfAtt:inAtt3], @"connection wont validate" );
}

- (void)test_makeSHInterConnectorBetweenOutletOfAndInletOfAtt {
	// - (SHInterConnector *)_makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)outAttr andInletOfAtt:(SHProtoAttribute *)inAttr undoManager:

	NSUndoManager *um = [[NSUndoManager alloc] init];

	//-- observe all items
	[_parent addObserver:self forKeyPath:@"childContainer.shInterConnectorsInside.array" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParentTests"];
	
	// inAttribute to inAttribute
	SHProtoInputAttribute* inAtt1 = [SHProtoInputAttribute makeChildWithName:@"inAtt1"];
	SHProtoInputAttribute* inAtt2 = [SHProtoInputAttribute makeChildWithName:@"inAtt2"];
	
	[_parent addChild:inAtt1 atIndex:-1 undoManager:nil];
	[_parent addChild:inAtt2 atIndex:-1 undoManager:nil];
	[self resetObservers];
	
	[_parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)inAtt1 andInletOfAtt:(SHProtoAttribute *)inAtt2 undoManager:um];
	SHInterConnector* int1 = [_parent interConnectorFor:inAtt1 and:inAtt2];
	STAssertNotNil(int1, @"failed to connect 2 inAttributes");
	STAssertTrue(_interConnectorsChanged==1, @"received incorrect number of notifications %i", _interConnectorsChanged);
	
	// outAttribute to outAttribute
	SHProtoOutputAttribute* outAtt1 = [SHProtoOutputAttribute makeChildWithName:@"outAtt1"];
	SHProtoOutputAttribute* outAtt2 = [SHProtoOutputAttribute makeChildWithName:@"outAtt2"];
	[_parent addChild:outAtt1 atIndex:-1 undoManager:nil];
	[_parent addChild:outAtt2 atIndex:-1 undoManager:nil];
	
	[_parent _makeSHInterConnectorBetweenOutletOf:outAtt1 andInletOfAtt:outAtt2 undoManager:um];
	SHInterConnector* int2 = [_parent interConnectorFor:outAtt1 and:outAtt2];
	STAssertNotNil(int2, @"failed to connect 2 outAttributes");
	STAssertTrue(_interConnectorsChanged==2, @"received incorrect number of notifications %i", _interConnectorsChanged);
	
	// inAttribute to outAttribute
	[_parent _makeSHInterConnectorBetweenOutletOf:inAtt1 andInletOfAtt:outAtt1 undoManager:um];
	SHInterConnector* in3 = [_parent interConnectorFor:inAtt1 and:outAtt1];
	STAssertNotNil(in3, @"failed to connect 2 outAttributes");
	STAssertTrue(_interConnectorsChanged==3, @"received incorrect number of notifications %i", _interConnectorsChanged);
	
	// try a duplicate connection
	STAssertThrows([_parent _makeSHInterConnectorBetweenOutletOf:inAtt1 andInletOfAtt:outAtt1 undoManager:um], @"duplicate!");
	STAssertTrue(_interConnectorsChanged==3, @"received incorrect number of notifications %i", _interConnectorsChanged);
	
	//-- try connecting across levels. ie.
	SHParent* child = [SHParent makeChildWithName:@"1"];
	[_parent addChild:child atIndex:-1 undoManager:nil];
	SHProtoInputAttribute *deepInput = [SHProtoInputAttribute makeChildWithName:@"deepInput"];
	SHProtoOutputAttribute *deepOutput = [SHProtoOutputAttribute makeChildWithName:@"deepOutput"];
	
	[child addChild:deepInput atIndex:-1 undoManager:nil];
	[child addChild:deepOutput atIndex:-1 undoManager:nil];
	[_parent _makeSHInterConnectorBetweenOutletOf:inAtt1 andInletOfAtt:deepInput undoManager:um];
	SHInterConnector* in5 = [_parent interConnectorFor:inAtt1 and:deepInput];
	STAssertNotNil(in5, @"This should work");
	STAssertTrue(_interConnectorsChanged==4, @"received incorrect number of notifications %i", _interConnectorsChanged);
	
	//SHInterConnector* in6 = [_parent _makeSHInterConnectorBetweenOutletOf:deepOutput andInletOfAtt:outAtt2]; // cant have 2 inputs to outAtt2
	
	[_parent _makeSHInterConnectorBetweenOutletOf:deepInput andInletOfAtt:deepOutput undoManager:um];
	SHInterConnector* in7 = [_parent interConnectorFor:deepInput and:deepOutput];
	STAssertTrue(_interConnectorsChanged==4, @"received incorrect number of notifications %i", _interConnectorsChanged);
	
	//	STAssertNotNil(in6, @"This should work");
	STAssertNil(in7, @"should fail - wrong root");
	
	/* Test Undo Redo */
	[um removeAllActions];
	[child _makeSHInterConnectorBetweenOutletOf:deepInput andInletOfAtt:deepOutput undoManager:um];

	// NSAssert([um groupingLevel]==0, @"should not be in an undo group");
	STAssertTrue(_interConnectorsChanged==4, @"received incorrect number of notifications %i", _interConnectorsChanged);
	
    STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo add connection"], @"Incorrect Undo Title :%@", [um undoMenuItemTitle]);
	// STAssertTrue([[um redoMenuItemTitle] isEqualToString:@"Redo add child"], @"Incorrect Redo Title :%@", [um redoMenuItemTitle]);
    
	SHInterConnector* in8 = [_parent interConnectorFor:deepInput and:deepOutput];
	SHInterConnector* in88 = [child interConnectorFor:deepInput and:deepOutput];
	STAssertNil(in8, @"wrong parent");
	STAssertNotNil(in88, @"correct parent");
	
	NSUInteger numberOfInterConnectors1 = [[deepInput allConnectedInterConnectors] count];
	NSUInteger numberOfInterConnectors2 = [[child shInterConnectorsInside] count];
	STAssertTrue(numberOfInterConnectors2==1, @"did connection fail? %i", numberOfInterConnectors2);
		
//	[child clearRecordedHits];
	[um undo]; //-- take away again
//	BOOL hitRecordResult1 = [child assertRecordsIs:@"_removeInterConnector:", nil];
//	NSMutableArray *actualRecordings1 = [child recordedSelectorStrings];
//	STAssertTrue(hitRecordResult1, @"That is what happened %@", actualRecordings1);
	
	int numberOfInterConnectors3 = [[child shInterConnectorsInside] count];
	STAssertTrue( [[deepInput allConnectedInterConnectors] count]==(numberOfInterConnectors1-1), @"is %i - should be %i", [[deepInput allConnectedInterConnectors] count], (numberOfInterConnectors1-1));
	STAssertTrue( numberOfInterConnectors3==0, @"is, %i - should be %i", numberOfInterConnectors3, 0);
    // STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo remove from selection"], @"Incorrect Undo Title :%@", [um undoMenuItemTitle]);
	STAssertTrue([[um redoMenuItemTitle] isEqualToString:@"Redo add connection"], @"Incorrect Redo Title :%@", [um redoMenuItemTitle]);
    
//	[child clearRecordedHits];
	[um redo]; //-- add again
//	BOOL hitRecordResult2 = [child assertRecordsIs:@"_addInterConnector:between:and:", nil];	
//	NSMutableArray *actualRecordings2 = [child recordedSelectorStrings];
//	STAssertTrue(hitRecordResult2, @"That is what happened %@", actualRecordings2);
	
	NSUInteger numberOfInterConnectors4 = [[deepInput allConnectedInterConnectors] count];
	NSUInteger numberOfInterConnectors5 = [[child shInterConnectorsInside] count];
	STAssertTrue( numberOfInterConnectors4==(numberOfInterConnectors1), @"is %i - should be %i", numberOfInterConnectors4, (numberOfInterConnectors1));
	STAssertTrue(numberOfInterConnectors5==numberOfInterConnectors2, @"eek, %i instead of %i", numberOfInterConnectors5, numberOfInterConnectors2);
	
    STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo add connection"], @"Incorrect Undo Title :%@", [um undoMenuItemTitle]);
	// STAssertTrue([[um redoMenuItemTitle] isEqualToString:@"Redo add child"], @"Incorrect Redo Title :%@", [um redoMenuItemTitle]);
    
	// -- remove observer
	[_parent removeObserver:self forKeyPath:@"childContainer.shInterConnectorsInside.array"];
	[um removeAllActions];
	[um release];
}

#pragma mark - delete methods

- (void)testDeleteChildUndoManager {
	//- (void)deleteChild:(SHChild *)child undoManager:(NSUndoManager *)um
	
	//-- observe all items
	NSUInteger observingOptions = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionPrior;
	[_parent addObserver:self forKeyPath:@"childContainer.nodesInside.array" options:observingOptions context:@"SHParentTests"];
	[_parent addObserver:self forKeyPath:@"childContainer.inputs.array" options:observingOptions context:@"SHParentTests"];
	[_parent addObserver:self forKeyPath:@"childContainer.outputs.array" options:observingOptions context:@"SHParentTests"];
	[_parent addObserver:self forKeyPath:@"childContainer.shInterConnectorsInside.array" options:observingOptions context:@"SHParentTests"];
	
	[self resetObservers];
	NSUndoManager *um = [[NSUndoManager alloc] init];

	SHParent *childnode1=[SHParent makeChildWithName:@"testSHNode1"];
	SHProtoInputAttribute *childInput1=[SHProtoInputAttribute makeChildWithName:@"testInput1"];
	SHProtoOutputAttribute *childOutput1=[SHProtoOutputAttribute makeChildWithName:@"testInput1"];
	
	[_parent addChild:childnode1 atIndex:-1 undoManager:um];
	[um removeAllActions];
	[_parent deleteChild:childnode1 undoManager:um];
	STAssertTrue( [[_parent nodesInside] count]==0, @"Number ofchild nodes should be 0, but was %d instead!", [[_parent nodesInside] count] );
	STAssertNil([childnode1 parentSHNode], @"not dissassembling properly");
	STAssertTrue(_nodeAddedNotifications==2, @"received incorrect number of notifications %i", _nodeAddedNotifications);
	[um undo];
	STAssertTrue( [[_parent nodesInside] count]==1, @"Number ofchild nodes should be 1, but was %d instead!", [[_parent nodesInside] count] );
	STAssertNotNil([childnode1 parentSHNode], @"not dissassembling properly");
	[um redo];
	STAssertTrue( [[_parent nodesInside] count]==0, @"Number ofchild nodes should be 0, but was %d instead!", [[_parent nodesInside] count] );
	STAssertNil([childnode1 parentSHNode], @"not dissassembling properly");

	// test adding an input attribute
	[_parent addChild:childInput1 atIndex:-1 undoManager:um];
	[_parent deleteChild:childInput1 undoManager:um];
	STAssertTrue( [[_parent inputs] count]==0, @"Number ofchild nodes should be 0, but was %d instead!", [[_parent inputs] count] );
	STAssertNil( [childInput1 parentSHNode], @"not dissassembling properly");
	STAssertTrue( inputsChangedCount==2, @"received incorrect number of notifications %i", inputsChangedCount);
	
	// test adding an output attribute
	[_parent addChild:childOutput1 atIndex:-1 undoManager:um];
	[_parent deleteChild:childOutput1 undoManager:um];
	STAssertTrue( [[_parent outputs] count]==0, @"Number ofchild nodes should be 0, but was %d instead!", [[_parent outputs] count]);
	STAssertNil([childOutput1 parentSHNode], @"not dissassembling properly");
	
	// test deleting an interconnector
	// check that removes attached interconnectors
	SHProtoInputAttribute* i1 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	SHProtoOutputAttribute* o1 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	[_parent addChild:i1 atIndex:-1 undoManager:um];
	[_parent addChild:o1 atIndex:-1 undoManager:um];
	[_parent _makeSHInterConnectorBetweenOutletOf:i1 andInletOfAtt:o1 undoManager:um];
	SHInterConnector* int1 = [_parent interConnectorFor:i1 and:o1];
	
	STAssertEquals(1, (int)[[i1 allConnectedInterConnectors] count], @"Number ofchild nodes should be 0, but was %d instead!", [[i1 allConnectedInterConnectors] count]);
	STAssertEquals(1, (int)[[o1 allConnectedInterConnectors] count], @"Number ofchild nodes should be 0, but was %d instead!", [[o1 allConnectedInterConnectors] count]);
	
	[um removeAllActions];
	[_parent deleteChild:int1 undoManager:um];
	STAssertEquals(0, (int)[[_parent shInterConnectorsInside] count], @"Number of ics should be 0, but was %d instead!", [[_parent shInterConnectorsInside] count]);
	STAssertNil([int1 parentSHNode], @"not dissassembling properly");
	STAssertEquals(0, (int)[[i1 allConnectedInterConnectors] count], @"Number ofchild nodes should be 0, but was %d instead!", [[i1 allConnectedInterConnectors] count]);
	STAssertEquals(0, (int)[[o1 allConnectedInterConnectors] count], @"Number ofchild nodes should be 0, but was %d instead!", [[o1 allConnectedInterConnectors] count]);
	
	[um undo];
	STAssertEquals(1, (int)[[_parent shInterConnectorsInside] count], @"Number of ics should be 0, but was %d instead!", [[_parent shInterConnectorsInside] count]);
	STAssertNotNil([int1 parentSHNode], @"not dissassembling properly");
	STAssertEquals(1, (int)[[i1 allConnectedInterConnectors] count], @"Number ofchild nodes should be 0, but was %d instead!", [[i1 allConnectedInterConnectors] count]);
	STAssertEquals(1, (int)[[o1 allConnectedInterConnectors] count], @"Number ofchild nodes should be 0, but was %d instead!", [[o1 allConnectedInterConnectors] count]);
	
	[um redo];
	STAssertEquals(0, (int)[[_parent shInterConnectorsInside] count], @"Number of ics should be 0, but was %d instead!", [[_parent shInterConnectorsInside] count]);
	STAssertNil([int1 parentSHNode], @"not dissassembling properly");
	STAssertEquals(0, (int)[[i1 allConnectedInterConnectors] count], @"Number ofchild nodes should be 0, but was %d instead!", [[i1 allConnectedInterConnectors] count]);
	STAssertEquals(0, (int)[[o1 allConnectedInterConnectors] count], @"Number ofchild nodes should be 0, but was %d instead!", [[o1 allConnectedInterConnectors] count]);
	
	// try deleting an attribute and ensureing that it deletes the connected ic
	[_parent _makeSHInterConnectorBetweenOutletOf:i1 andInletOfAtt:o1 undoManager:um];
	SHInterConnector* int2 = [_parent interConnectorFor:i1 and:o1];
	[um removeAllActions];
	[_parent deleteChild:i1 undoManager:um];
	STAssertEquals(0, (int)[[_parent shInterConnectorsInside] count], @"Number of ics should be 0, but was %d instead!", [[_parent shInterConnectorsInside] count]);
	STAssertEquals(0, (int)[[o1 allConnectedInterConnectors] count], @"Number ofchild nodes should be 0, but was %d instead!", [[o1 allConnectedInterConnectors] count]);

	[um undo];
	STAssertEquals(1, (int)[[_parent shInterConnectorsInside] count], @"Number of ics should be 0, but was %d instead!", [[_parent shInterConnectorsInside] count]);
	STAssertNotNil([int2 parentSHNode], @"not dissassembling properly");
	STAssertEquals(1, (int)[[i1 allConnectedInterConnectors] count], @"Number ofchild nodes should be 0, but was %d instead!", [[i1 allConnectedInterConnectors] count]);
	STAssertEquals(1, (int)[[o1 allConnectedInterConnectors] count], @"Number ofchild nodes should be 0, but was %d instead!", [[o1 allConnectedInterConnectors] count]);
	
	[um redo];
	STAssertEquals(0, (int)[[_parent shInterConnectorsInside] count], @"Number of ics should be 0, but was %d instead!", [[_parent shInterConnectorsInside] count]);
	STAssertEquals(0, (int)[[o1 allConnectedInterConnectors] count], @"Number ofchild nodes should be 0, but was %d instead!", [[o1 allConnectedInterConnectors] count]);
	
	// -- remove observer
	[_parent removeObserver:self forKeyPath:@"childContainer.shInterConnectorsInside.array"];
	[_parent removeObserver:self forKeyPath:@"childContainer.nodesInside.array"];
	[_parent removeObserver:self forKeyPath:@"childContainer.inputs.array"];
	[_parent removeObserver:self forKeyPath:@"childContainer.outputs.array"];
	[um removeAllActions];
	
	// -- test most complicated case - output connected to input. Resulting ic is in parentNode
	// parentNode
	// -- childNode1
	// -- -- output
	// -- childNode2
	// -- -- input
	// -- ic
	SHParent *parentNode=[SHParent makeChildWithName:@"parentNode"];
	SHParent *childNode1=[SHParent makeChildWithName:@"childNode1"];
	SHParent *childNode2=[SHParent makeChildWithName:@"childNode2"];
	SHProtoInputAttribute *input=[SHProtoInputAttribute makeChildWithName:@"input"];
	SHProtoOutputAttribute *output=[SHProtoOutputAttribute makeChildWithName:@"output"];
	[_parent addChild:childNode1 atIndex:-1 undoManager:um];
	[_parent addChild:childNode2 atIndex:-1 undoManager:um];
	[childNode1 addChild:output atIndex:-1 undoManager:um];
	[childNode2 addChild:input atIndex:-1 undoManager:um];
	[_parent _makeSHInterConnectorBetweenOutletOf:output andInletOfAtt:input undoManager:um];
	SHInterConnector *int3 = [_parent interConnectorFor:output and:input];
	STAssertNotNil(int3, @"doh");
	
	// -- test in  willChange that we are notified about deleting dependent ics
	[self resetObservers];
	
	[childNode1 addObserver:self forKeyPath:@"childContainer.outputs.array" options:observingOptions context:@"SHParentTests"];
	
	[childNode1 deleteChild:output undoManager:um];
	STAssertTrue([_otherNodesAffectedByRemove count]==1, @"hmm %i", [_otherNodesAffectedByRemove count]);
	STAssertTrue([_otherNodesAffectedByRemove containsObject:_parent], @"fuck off Proxy bullshit wank" );
	
	[childNode1 removeObserver:self forKeyPath:@"childContainer.outputs.array"];
	[um removeAllActions];
	[um release];
	[self resetObservers];
}

- (void)testDeleteChildren {
	// - (void)deleteChildren:(NSArray *)childrenToDelete undoManager:(NSUndoManager *)ud
	
	NSUndoManager *um = [[NSUndoManager alloc] init];
	
	// -- observe each
	NSUInteger observingOptions = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionPrior;
	[_parent addObserver:self forKeyPath:@"childContainer.nodesInside.array" options:observingOptions context:@"SHParentTests"];
	[_parent addObserver:self forKeyPath:@"childContainer.inputs.array" options:observingOptions context:@"SHParentTests"];
	[_parent addObserver:self forKeyPath:@"childContainer.outputs.array" options:observingOptions context:@"SHParentTests"];
	[_parent addObserver:self forKeyPath:@"childContainer.shInterConnectorsInside.array" options:observingOptions context:@"SHParentTests"];
	
	/* make a shit load of children */
	SHParent *childnode1=[SHParent makeChildWithName:@"testSHNode1"], *childnode2=[SHParent makeChildWithName:@"testSHNode2"], *childnode3=[SHParent makeChildWithName:@"testSHNode3"];
	NSArray *itemsToAdd1 = [NSArray arrayWithObjects:childnode1, childnode2, childnode3, nil];
	[_parent addItemsOfSingleType:itemsToAdd1 atIndexes:nil undoManager:um];
	
	SHProtoInputAttribute *childInput1=[SHProtoInputAttribute makeChildWithName:@"testInput1"], *childInput2=[SHProtoInputAttribute makeChildWithName:@"testInput2"], *childInput3=[SHProtoInputAttribute makeChildWithName:@"testInput3"];
	NSArray *itemsToAdd2 = [NSArray arrayWithObjects:childInput1, childInput2, childInput3, nil];
	[_parent addItemsOfSingleType:itemsToAdd2 atIndexes:nil undoManager:um];
	
	SHProtoOutputAttribute *childOutput1=[SHProtoOutputAttribute makeChildWithName:@"testInput1"], *childOutput2=[SHProtoOutputAttribute makeChildWithName:@"testInput2"], *childOutput3=[SHProtoOutputAttribute makeChildWithName:@"testInput3"];
	NSArray *itemsToAdd3 = [NSArray arrayWithObjects:childOutput1, childOutput2, childOutput3, nil];
	[_parent addItemsOfSingleType:itemsToAdd3 atIndexes:nil undoManager:um];
	
	[_parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)childInput1 andInletOfAtt:(SHProtoAttribute *)childOutput1 undoManager:um];
	[_parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)childInput2 andInletOfAtt:(SHProtoAttribute *)childOutput2 undoManager:um];
	SHInterConnector* int1 = [_parent interConnectorFor:childInput1 and:childOutput1];
	SHInterConnector* int2 = [_parent interConnectorFor:childInput2 and:childOutput2];
	STAssertNotNil(int1, @"what?");
	STAssertNotNil(int2, @"what?");
	STAssertTrue( [_parent countOfChildren]==11, @"Should have added %i", [_parent countOfChildren] );
	[self resetObservers];
	
	[_parent deleteChildren:[NSArray arrayWithObjects:int1, childOutput1, childInput1, childnode1, nil] undoManager:um];
	STAssertTrue( [_parent countOfChildren]==7, @"Should have added %i", [_parent countOfChildren] );
	
	STAssertTrue( _interConnectorsChanged==1, @"eh %i", _interConnectorsChanged );
	STAssertTrue( inputsChangedCount==1, @"eh %i", inputsChangedCount );
	STAssertTrue( outputsChangedCount==1, @"eh %i", outputsChangedCount );
	STAssertTrue( _nodeAddedNotifications==1, @"eh %i", _nodeAddedNotifications );
	
	[um undo];
	
	[um redo];
	
	// Test IC bugs - does removing an input remove a connected ic?
	SHProtoInputAttribute *icBugIn=[SHProtoInputAttribute makeChildWithName:@"icBugIn"];
	SHProtoOutputAttribute *icBugOut=[SHProtoOutputAttribute makeChildWithName:@"icBugOut"];
	[_parent addItemsOfSingleType:[NSArray arrayWithObject:icBugIn] atIndexes:nil undoManager:um];
	[_parent addItemsOfSingleType:[NSArray arrayWithObject:icBugOut] atIndexes:nil undoManager:um];
	[_parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)icBugIn andInletOfAtt:(SHProtoAttribute *)icBugOut undoManager:nil];
	SHInterConnector* icBugTestIc = [_parent interConnectorFor:icBugIn and:icBugOut];
	[self resetObservers];
	
	[_parent deleteChildren:[NSArray arrayWithObject:icBugIn] undoManager:nil];
	STAssertTrue( inputsChangedCount==1, @"eh %i", inputsChangedCount );
	STAssertTrue( _interConnectorsChanged==1, @"eh %i", _interConnectorsChanged );
	
	/* URGGGGGGhhhhhhh - some connected ics will actually be 'in' the parent node */
	SHParent *subChild1=[SHParent makeChildWithName:@"subChild1"], *subChild2=[SHParent makeChildWithName:@"subChild2"];
	[_parent addItemsOfSingleType:[NSArray arrayWithObjects:subChild1, subChild2, nil] atIndexes:nil undoManager:um];
	SHProtoInputAttribute *deepInput=[SHProtoInputAttribute makeChildWithName:@"deepInput"];
	SHProtoOutputAttribute *deepOutput=[SHProtoOutputAttribute makeChildWithName:@"deepOutput"];
	[subChild2 addItemsOfSingleType:[NSArray arrayWithObject:deepInput] atIndexes:nil undoManager:um];	
	[subChild1 addItemsOfSingleType:[NSArray arrayWithObject:deepOutput] atIndexes:nil undoManager:um];
	[_parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)deepOutput andInletOfAtt:(SHProtoAttribute *)deepInput undoManager:um];
	STAssertNotNil([_parent interConnectorFor:deepOutput and:deepInput], @"this should not have failed");
	[subChild1 deleteChildren:[NSArray arrayWithObject:deepOutput] undoManager:nil];
	
	// -- remove observer
	[_parent removeObserver:self forKeyPath:@"childContainer.nodesInside.array"];	
	[_parent removeObserver:self forKeyPath:@"childContainer.inputs.array"];	
	[_parent removeObserver:self forKeyPath:@"childContainer.outputs.array"];	
	[_parent removeObserver:self forKeyPath:@"childContainer.shInterConnectorsInside.array"];
	
	[um removeAllActions];
	
	// -- test most complicated case - output connected to input. Resulting ic is in parentNode
	// parentNode
	// -- childNode1
	// -- -- output
	// -- childNode2
	// -- -- input
	// -- ic
	SHParent *parentNode=[SHParent makeChildWithName:@"parentNode"];
	SHParent *childNode1=[SHParent makeChildWithName:@"childNode1"];
	SHParent *childNode2=[SHParent makeChildWithName:@"childNode2"];
	SHProtoInputAttribute *input=[SHProtoInputAttribute makeChildWithName:@"input"];
	SHProtoOutputAttribute *output=[SHProtoOutputAttribute makeChildWithName:@"output"];
	SHProtoOutputAttribute *output_spare=[SHProtoOutputAttribute makeChildWithName:@"output_spare"];
	[_parent addChild:childNode1 atIndex:-1 undoManager:um];
	[_parent addChild:childNode2 atIndex:-1 undoManager:um];
	[childNode1 addChild:output atIndex:-1 undoManager:um];
	[childNode1 addChild:output_spare atIndex:-1 undoManager:um];
	[childNode2 addChild:input atIndex:-1 undoManager:um];
	[_parent _makeSHInterConnectorBetweenOutletOf:output andInletOfAtt:input undoManager:um];
	SHInterConnector *int3 = [_parent interConnectorFor:output and:input];
	STAssertNotNil(int3, @"doh");
	
	// -- test in  willChange that we are notified about deleting dependent ics
	[self resetObservers];
	
	[childNode1 addObserver:self forKeyPath:@"childContainer.outputs.array" options:observingOptions context:@"SHParentTests"];
	
	[childNode1 deleteChildren:[NSArray arrayWithObjects:output, output_spare, nil] undoManager:um];
	STAssertTrue([_otherNodesAffectedByRemove count]==1, @"hmm %i", [_otherNodesAffectedByRemove count]);
	STAssertTrue([_otherNodesAffectedByRemove containsObject:_parent], @"fuck off Proxy bullshit wank" );
	
	[childNode1 removeObserver:self forKeyPath:@"childContainer.outputs.array"];
	[um removeAllActions];
	[um release];
	
	[self resetObservers];
}


- (void)testDeleteNodes {
	// - (void)deleteNodes:(NSArray *)nodes undoManager:(NSUndoManager *)um;
	
	NSUndoManager *um = [[NSUndoManager alloc] init];

	//-- observe all items
	[_parent addObserver:self forKeyPath:@"childContainer.nodesInside.array" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParentTests"];
	
	SHParent *childnode1=[SHParent makeChildWithName:@"testSHNode1"], *childnode2=[SHParent makeChildWithName:@"testSHNode2"], *childnode3=[SHParent makeChildWithName:@"testSHNode3"];
	NSArray *itemsToAdd1 = [NSArray arrayWithObjects:childnode1, childnode2, childnode3, nil];
	[_parent addItemsOfSingleType:itemsToAdd1 atIndexes:nil undoManager:um];

	STAssertTrue([[_parent nodesInside] count]==3, @"should have deleted them.. %i", [[_parent nodesInside] count]);

	[self resetObservers];
	[um removeAllActions];	

	[um beginUndoGrouping];
		[_parent deleteNodes:[NSArray arrayWithObjects:childnode1, childnode3, nil] undoManager:um];
	[um endUndoGrouping];
	
	STAssertTrue([[_parent nodesInside] count]==1, @"should have deleted them.. %i", [[_parent nodesInside] count]);

	STAssertTrue([[itemsToAdd1 objectAtIndex:0] parentSHNode]==nil, @"eh?");
	STAssertNil([childnode1 parentSHNode], @"not dissassembling properly");

	STAssertTrue(_nodeAddedNotifications==1, @"received incorrect number of notifications %i", _nodeAddedNotifications);
	STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo remove nodes"], @"Incorrect Undo Title :%@", [um undoMenuItemTitle]);

	[um undo]; //-- add again
	STAssertTrue([[_parent nodesInside] count]==3, @"should have added them.. %i", [[_parent nodesInside] count]);

	STAssertTrue([[itemsToAdd1 objectAtIndex:0] parentSHNode]==_parent, @"eh?");
	STAssertNotNil([childnode1 parentSHNode], @"not dissassembling properly");

	STAssertTrue(_nodeAddedNotifications==2, @"received incorrect number of notifications %i", _nodeAddedNotifications);
	STAssertTrue([[um redoMenuItemTitle] isEqualToString:@"Redo remove nodes"], @"Incorrect Redo Title :%@", [um redoMenuItemTitle]);
	
	[um redo]; //-- remove again
	STAssertTrue([[_parent nodesInside] count]==1, @"should have deleted them.. %i", [[_parent nodesInside] count]);
	
	STAssertTrue(_nodeAddedNotifications==3, @"received incorrect number of notifications %i", _nodeAddedNotifications);
	STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo remove nodes"], @"Incorrect Undo Title :%@", [um undoMenuItemTitle]);
	STAssertNil([childnode1 parentSHNode], @"not dissassembling properly");

	
	// -- remove observer
	[_parent removeObserver:self forKeyPath:@"childContainer.nodesInside.array"];
	[um removeAllActions];
	[um release];
}

- (void)testDeleteInputs {
	// - (void)deleteInputs:(NSArray *)inputs

	NSUndoManager *um = [[NSUndoManager alloc] init];
	
	//-- observe all items
	[_parent addObserver:self forKeyPath:@"childContainer.inputs.array" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParentTests"];
	
	SHProtoInputAttribute *childInput1=[SHProtoInputAttribute makeChildWithName:@"testInput1"], *childInput2=[SHProtoInputAttribute makeChildWithName:@"testInput2"], *childInput3=[SHProtoInputAttribute makeChildWithName:@"testInput3"];
	NSArray *itemsToAdd1 = [NSArray arrayWithObjects:childInput1, childInput2, childInput3, nil];
	[_parent addItemsOfSingleType:itemsToAdd1 atIndexes:nil undoManager:um];
	
	STAssertTrue([[_parent inputs] count]==3, @"should have deleted them.. %i", [[_parent inputs] count]);	
	[self resetObservers];
	[um removeAllActions];	
	
	[um beginUndoGrouping];
		[_parent deleteInputs:[NSArray arrayWithObjects:childInput1, childInput3, nil] undoManager:um];
	[um endUndoGrouping];
	
	STAssertTrue([[_parent inputs] count]==1, @"should have deleted them.. %i", [[_parent inputs] count]);
	STAssertTrue([[itemsToAdd1 objectAtIndex:0] parentSHNode]==nil, @"eh?");
	
	STAssertTrue(inputsChangedCount==1, @"received incorrect number of notifications %i", inputsChangedCount);
	STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo remove inputs"], @"Incorrect Undo Title :%@", [um undoMenuItemTitle]);
	
	[um undo]; //-- add again
	STAssertTrue([[_parent inputs] count]==3, @"should have added them.. %i", [[_parent inputs] count]);
	STAssertTrue([[itemsToAdd1 objectAtIndex:0] parentSHNode]==_parent, @"eh?");
	
	STAssertTrue(inputsChangedCount==2, @"received incorrect number of notifications %i", inputsChangedCount);
	STAssertTrue([[um redoMenuItemTitle] isEqualToString:@"Redo remove inputs"], @"Incorrect Redo Title :%@", [um redoMenuItemTitle]);
	
	[um redo]; //-- remove again
	STAssertTrue([[_parent inputs] count]==1, @"should have deleted them.. %i", [[_parent inputs] count]);
	STAssertTrue(inputsChangedCount==3, @"received incorrect number of notifications %i", inputsChangedCount);
	STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo remove inputs"], @"Incorrect Undo Title :%@", [um undoMenuItemTitle]);
	
	// -- remove observer
	[_parent removeObserver:self forKeyPath:@"childContainer.inputs.array"];
	[um removeAllActions];
	[um release];
}

- (void)testDeleteOutputs {
	// - (void)deleteOutputs:(NSArray *)outputs

	NSUndoManager *um = [[NSUndoManager alloc] init];

	//-- observe all items
	[_parent addObserver:self forKeyPath:@"childContainer.outputs.array" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParentTests"];

	SHProtoOutputAttribute *childOutput1=[SHProtoOutputAttribute makeChildWithName:@"testInput1"], *childOutput2=[SHProtoOutputAttribute makeChildWithName:@"testInput2"], *childOutput3=[SHProtoOutputAttribute makeChildWithName:@"testInput3"];
	NSArray *itemsToAdd1 = [NSArray arrayWithObjects:childOutput1, childOutput2, childOutput3, nil];
	[_parent addItemsOfSingleType:itemsToAdd1 atIndexes:nil undoManager:um];

	STAssertTrue([[_parent outputs] count]==3, @"should have deleted them.. %i", [[_parent outputs] count]);	
	[self resetObservers];
	[um removeAllActions];	

	[um beginUndoGrouping];
		[_parent deleteOutputs:[NSArray arrayWithObjects:childOutput1, childOutput3, nil] undoManager:um];
	[um endUndoGrouping];

	STAssertTrue([[_parent outputs] count]==1, @"should have deleted them.. %i", [[_parent outputs] count]);
	STAssertTrue([[itemsToAdd1 objectAtIndex:0] parentSHNode]==nil, @"eh?");

	STAssertTrue(outputsChangedCount==1, @"received incorrect number of notifications %i", outputsChangedCount);
	STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo remove outputs"], @"Incorrect Undo Title :%@", [um undoMenuItemTitle]);

	[um undo]; //-- add again
	STAssertTrue([[_parent outputs] count]==3, @"should have added them.. %i", [[_parent outputs] count]);
	STAssertTrue([[itemsToAdd1 objectAtIndex:0] parentSHNode]==_parent, @"eh?");

	STAssertTrue(outputsChangedCount==2, @"received incorrect number of notifications %i", outputsChangedCount);
	STAssertTrue([[um redoMenuItemTitle] isEqualToString:@"Redo remove outputs"], @"Incorrect Redo Title :%@", [um redoMenuItemTitle]);

	[um redo]; //-- remove again
	STAssertTrue([[_parent outputs] count]==1, @"should have deleted them.. %i", [[_parent outputs] count]);
	STAssertTrue(outputsChangedCount==3, @"received incorrect number of notifications %i", outputsChangedCount);
	STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo remove outputs"], @"Incorrect Undo Title :%@", [um undoMenuItemTitle]);

	// -- remove observer
	[_parent removeObserver:self forKeyPath:@"childContainer.outputs.array"];
	[um removeAllActions];
	[um release];
}

- (void)testDeleteInterconnectors {
	// - (void)deleteInterconnectors:(NSArray *)ics

	NSUndoManager *um = [[NSUndoManager alloc] init];

	//-- observe all items
	[_parent addObserver:self forKeyPath:@"childContainer.shInterConnectorsInside.array" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParentTests"];

	SHProtoInputAttribute *inAtt1 = [SHProtoInputAttribute attributeWithType:@"mockDataType"], *inAtt2 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	SHProtoOutputAttribute *outAtt1 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"], *outAtt2 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];

	[_parent addItemsOfSingleType:[NSArray arrayWithObjects:inAtt1, inAtt2, nil] atIndexes:nil undoManager:um];
	[_parent addItemsOfSingleType:[NSArray arrayWithObjects:outAtt1, outAtt2, nil] atIndexes:nil undoManager:um];

	[_parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)inAtt1 andInletOfAtt:(SHProtoAttribute *)outAtt1 undoManager:um];
	[_parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)inAtt2 andInletOfAtt:(SHProtoAttribute *)outAtt2 undoManager:um];
	SHInterConnector* int1 = [_parent interConnectorFor:inAtt1 and:outAtt1];
	SHInterConnector* int2 = [_parent interConnectorFor:inAtt2 and:outAtt2];
	[self resetObservers];
	
	[um removeAllActions];
	[_parent deleteInterconnectors:[NSArray arrayWithObjects:int1, int2, nil] undoManager:um];
	
	STAssertTrue([[_parent shInterConnectorsInside] count]==0, @"should have deleted them.. %i", [[_parent shInterConnectorsInside] count]);
	STAssertTrue(_interConnectorsChanged==1, @"received incorrect number of notifications %i", _interConnectorsChanged);
	
	STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo remove connections"], @"Incorrect Undo Title :%@", [um undoMenuItemTitle]);
	// STAssertTrue([[um redoMenuItemTitle] isEqualToString:@"Redo add child"], @"Incorrect Redo Title :%@", [um redoMenuItemTitle]);
	
	[um undo]; //-- add again
	STAssertTrue([[_parent shInterConnectorsInside] count]==2, @"should have deleted them.. %i", [[_parent shInterConnectorsInside] count]);
	STAssertTrue(_interConnectorsChanged==2, @"received incorrect number of notifications %i", _interConnectorsChanged);
	
	// STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo remove from selection"], @"Incorrect Undo Title :%@", [um undoMenuItemTitle]);
	STAssertTrue([[um redoMenuItemTitle] isEqualToString:@"Redo remove connections"], @"Incorrect Redo Title :%@", [um redoMenuItemTitle]);
	
	[um redo]; //-- remove again
	STAssertTrue([[_parent shInterConnectorsInside] count]==0, @"should have deleted them.. %i", [[_parent shInterConnectorsInside] count]);
	STAssertTrue(_interConnectorsChanged==3, @"received incorrect number of notifications %i", _interConnectorsChanged);
	STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo remove connections"], @"Incorrect Undo Title :%@", [um undoMenuItemTitle]);
	// STAssertTrue([[um redoMenuItemTitle] isEqualToString:@"Redo add child"], @"Incorrect Redo Title :%@", [um redoMenuItemTitle]);
	
	// -- remove observer
	[_parent removeObserver:self forKeyPath:@"childContainer.shInterConnectorsInside.array"];
	[um removeAllActions];
	[um release];
}


#pragma mark - other Methods
- (void)testIsNameUsedByChild {
	// - (BOOL)isNameUsedByChild:(NSString *)aName;

	SHParent *par1 = [SHParent makeChildWithName:@"1"], *par2 = [SHParent makeChildWithName:@"2"];
	[_parent addChild:par1 atIndex:-1 undoManager:nil];
	[_parent addChild:par2 atIndex:-1 undoManager:nil];

	STAssertTrue([_parent isNameUsedByChild:@"1"],@"testIsNameUsedByChild failed");
	STAssertTrue([_parent isNameUsedByChild:@"2"], @"testIsNameUsedByChild failed");
	STAssertFalse([_parent isNameUsedByChild:@"3"], @"testIsNameUsedByChild failed");
}

- (void)testChildWithKey {
	//- (id<SHNodeLikeProtocol>)childWithKey:(NSString *)aName;

	SHParent *par1 = [SHParent makeChildWithName:@"1"], *par2 = [SHParent makeChildWithName:@"2"];
	[_parent addChild:par1 atIndex:-1 undoManager:nil];
	[_parent addChild:par2 atIndex:-1 undoManager:nil];
	
	STAssertTrue([_parent childWithKey:@"1"]==par1,@"testIsNameUsedByChild failed");
	STAssertTrue([_parent childWithKey:@"2"]==par2, @"testIsNameUsedByChild failed");
	STAssertTrue([_parent childWithKey:@"3"]==nil, @"testIsNameUsedByChild failed");
}

- (void)testIndexOfChild {
	// - (int)indexOfChild:(id)child

	NSUndoManager *um = [[NSUndoManager alloc] init];

	SHParent *childnode1=[SHParent makeChildWithName:@"testSHNode1"], *childnode2=[SHParent makeChildWithName:@"testSHNode2"], *childnode3=[SHParent makeChildWithName:@"testSHNode3"];
	NSArray *itemsToAdd1 = [NSArray arrayWithObjects:childnode1, childnode2, childnode3, nil];
	[_parent addItemsOfSingleType:itemsToAdd1 atIndexes:nil undoManager:nil];
	
	SHProtoInputAttribute *childInput1=[SHProtoInputAttribute makeChildWithName:@"testInput1"], *childInput2=[SHProtoInputAttribute makeChildWithName:@"testInput2"], *childInput3=[SHProtoInputAttribute makeChildWithName:@"testInput3"];
	NSArray *itemsToAdd2 = [NSArray arrayWithObjects:childInput1, childInput2, childInput3, nil];
	[_parent addItemsOfSingleType:itemsToAdd2 atIndexes:nil undoManager:nil];
	
	SHProtoOutputAttribute *childOutput1=[SHProtoOutputAttribute makeChildWithName:@"testInput1"], *childOutput2=[SHProtoOutputAttribute makeChildWithName:@"testInput2"], *childOutput3=[SHProtoOutputAttribute makeChildWithName:@"testInput3"];
	NSArray *itemsToAdd3 = [NSArray arrayWithObjects:childOutput1, childOutput2, childOutput3, nil];
	[_parent addItemsOfSingleType:itemsToAdd3 atIndexes:nil undoManager:nil];

	[_parent _makeSHInterConnectorBetweenOutletOf:childInput1 andInletOfAtt:childOutput1 undoManager:um];
	SHInterConnector* int1 = [_parent interConnectorFor:childInput1 and:childOutput1];
	STAssertNotNil(int1, @"eh");
	
	SHParent* childnode4 = [SHParent makeChildWithName:@"1"];
	[_parent addChild:childnode4 atIndex:-1 undoManager:nil];
	SHProtoInputAttribute* i2 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	SHProtoOutputAttribute* o2 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	[_parent addChild:i2 atIndex:-1 undoManager:nil];
	[_parent addChild:o2 atIndex:-1 undoManager:nil];
	
	STAssertTrue([_parent indexOfChild:childnode2]==1, @"should be equal");
	STAssertTrue([_parent indexOfChild:childInput2]==1, @"eek %i", [_parent indexOfChild:childInput2]);
	STAssertTrue([_parent indexOfChild:childOutput2]==1, @"eek");
	STAssertTrue([_parent indexOfChild:int1]==0, @"eek");
	
	[um removeAllActions];
	[um release];
}

/* you cant manually manipulate the order of nodesAndAttributesInside */
- (void)testSetIndexOfChildToUndoManager {
	// - (void)setIndexOfChild:(id)child to:(NSUInteger)index undoManager:um
	
	NSUndoManager *um = [[NSUndoManager alloc] init];

	/* add objects */
	SHParent* childnode = [SHParent makeChildWithName:@"n1"];
	[_parent addChild:childnode atIndex:-1 undoManager:nil];
	SHProtoInputAttribute* i1 = [SHProtoInputAttribute makeChildWithName:@"mockDataType"];
	SHProtoOutputAttribute* o1 = [SHProtoOutputAttribute makeChildWithName:@"mockDataType"];
	[_parent addChild:i1 atIndex:-1 undoManager:nil];
	[_parent addChild:o1 atIndex:-1 undoManager:nil];	
	[_parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)i1 andInletOfAtt:(SHProtoAttribute *)o1 undoManager:nil];
	SHInterConnector* int1 = [_parent interConnectorFor:i1 and:o1];	
	STAssertNotNil(int1, @"eh");
	
	SHParent* childnode2 = [SHParent makeChildWithName:@"n2"];
	[_parent addChild:childnode2 atIndex:-1 undoManager:nil];
	SHProtoInputAttribute* i2 = [SHProtoInputAttribute makeChildWithName:@"mockDataType"];
	SHProtoOutputAttribute* o2 = [SHProtoOutputAttribute makeChildWithName:@"mockDataType"];
	[_parent addChild:i2 atIndex:-1 undoManager:nil];
	[_parent addChild:o2 atIndex:-1 undoManager:nil];
	[_parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)i2 andInletOfAtt:(SHProtoAttribute *)o2 undoManager:nil];
	SHInterConnector* int2 = [_parent interConnectorFor:i2 and:o2];	
	
	[_parent setIndexOfChild:childnode2 to:0 undoManager:nil];
	[_parent setIndexOfChild:o2 to:0 undoManager:nil];
	[_parent setIndexOfChild:int2 to:0 undoManager:nil];
	
	int ind1 = [_parent indexOfChild:childnode2];
	int ind2 = [_parent indexOfChild:o2];
	int ind3 = [_parent indexOfChild:int2];
	
	STAssertTrue(ind1==0, [NSString stringWithFormat:@"is %i", ind1]);
	STAssertTrue(ind2==0, [NSString stringWithFormat:@"is %i", ind2]);
	STAssertTrue(ind3==0, [NSString stringWithFormat:@"is %i", ind3]);
	
	[_parent setIndexOfChild:childnode2 to:1 undoManager:nil];
	
	/* Test Undo */
	[um beginUndoGrouping];
		[_parent setIndexOfChild:o2 to:1 undoManager:um];
	[um endUndoGrouping];
	
	ind1 = [_parent indexOfChild:childnode2];
	ind2 = [_parent indexOfChild:o2];
	STAssertTrue(ind1==1, @"eek");
	STAssertTrue(ind2==1, @"eek");
	
	/* Undo */
	[um undo];
	STAssertTrue([_parent indexOfChild:o2]==0, @"is %i", [_parent indexOfChild:o2] );
	
	[um redo];
	STAssertTrue([_parent indexOfChild:o2]==1, @"is %i", [_parent indexOfChild:o2] );
	
	[um removeAllActions];
	[um release];
}

- (void)testMoveChildrenToInsertionIndexUndoManager {
//- (void)moveChildren:(NSArray *)children toInsertionIndex:(NSUInteger)value undoManager:(NSUndoManager *)um
	
	NSUndoManager *um = [[NSUndoManager alloc] init];

	SHParent *n0=[SHParent makeChildWithName:@"n0"],*n1=[SHParent makeChildWithName:@"n1"],*n2=[SHParent makeChildWithName:@"n2"],*n3=[SHParent makeChildWithName:@"n3"],*n4=[SHParent makeChildWithName:@"n4"];

	[_parent addChild:n0 atIndex:-1 undoManager:nil];
	[_parent addChild:n1 atIndex:-1 undoManager:nil];
	[_parent addChild:n2 atIndex:-1 undoManager:nil];
	[_parent addChild:n3 atIndex:-1 undoManager:nil];
	[_parent addChild:n4 atIndex:-1 undoManager:nil];

	[_parent moveChildren:[NSArray arrayWithObjects:n1,n3,nil] toInsertionIndex:0 undoManager:um];
	STAssertTrue([_parent nodeAtIndex:0]==n1, @"fail");
	STAssertTrue([_parent nodeAtIndex:1]==n3, @"fail");
	STAssertTrue([_parent nodeAtIndex:2]==n0, @"fail");
	STAssertTrue([_parent nodeAtIndex:3]==n2, @"fail");
	STAssertTrue([_parent nodeAtIndex:4]==n4, @"fail");
	
	// Test Undo
	[um undo];
	STAssertTrue([_parent nodeAtIndex:0]==n0, @"fail");
	STAssertTrue([_parent nodeAtIndex:1]==n1, @"fail");
	STAssertTrue([_parent nodeAtIndex:2]==n2, @"fail");
	STAssertTrue([_parent nodeAtIndex:3]==n3, @"fail");
	STAssertTrue([_parent nodeAtIndex:4]==n4, @"fail");
	
	[um redo];
	STAssertTrue([_parent nodeAtIndex:0]==n1, @"fail");
	STAssertTrue([_parent nodeAtIndex:1]==n3, @"fail");
	STAssertTrue([_parent nodeAtIndex:2]==n0, @"fail");
	STAssertTrue([_parent nodeAtIndex:3]==n2, @"fail");
	STAssertTrue([_parent nodeAtIndex:4]==n4, @"fail");
	
	[um removeAllActions];
	[um release];
}

- (void)testIsChild {
	// - (BOOL)isChild:(id)value

	NSArray *itemsToAdd_fail = [NSArray arrayWithObjects:[SHChild makeChildWithName:@"1"], [SHChild makeChildWithName:@"2"], nil];
	STAssertThrows([_parent addItemsOfSingleType:itemsToAdd_fail atIndexes:nil undoManager:nil], @"SHChild isnt valid");

	NSArray *itemsToAdd1 = [NSArray arrayWithObjects:[SHParent makeChildWithName:@"1"], [SHParent makeChildWithName:@"2"], nil];
	[_parent addItemsOfSingleType:itemsToAdd1 atIndexes:nil undoManager:nil];
	
	NSArray *itemsToAdd2 = [NSArray arrayWithObjects:[SHProtoInputAttribute makeChildWithName:@"i1"], [SHProtoInputAttribute makeChildWithName:@"i1"], [SHProtoInputAttribute makeChildWithName:@"i3"], nil];
	[_parent addItemsOfSingleType:itemsToAdd2 atIndexes:nil undoManager:nil];

	NSArray *itemsToAdd3 = [NSArray arrayWithObjects:[SHProtoOutputAttribute makeChildWithName:@"o1"], [SHProtoOutputAttribute makeChildWithName:@"o2"], [SHProtoOutputAttribute makeChildWithName:@"o3"], nil];
	[_parent addItemsOfSingleType:itemsToAdd3 atIndexes:nil undoManager:nil];
	
	STAssertTrue([_parent isChild:[itemsToAdd1 objectAtIndex:0]], @"should be child");
	STAssertTrue([_parent isChild:[itemsToAdd2 objectAtIndex:0]], @"should be child");
	STAssertTrue([_parent isChild:[itemsToAdd3 objectAtIndex:0]], @"should be child");
	STAssertFalse([_parent isChild:[itemsToAdd_fail objectAtIndex:0]], @"should not be a child");
}

- (void)testInit {
//- (id)init

	SHParent *p = [[SHParent alloc] init];
	[p release];
}

- (void)testArchive {
//- (id)initWithCoder:(NSCoder *)coder
//- (void)encodeWithCoder:(NSCoder *)coder

	SHParent *childnode = [SHParent makeChildWithName:@"1"];
	SHProtoInputAttribute *inAtt1 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	SHProtoOutputAttribute *outAtt1 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	[_parent addChild:inAtt1 atIndex:-1 undoManager:nil];
	[_parent addChild:outAtt1 atIndex:-1 undoManager:nil];
	[_parent addChild:childnode atIndex:-1 undoManager:nil];
	SHProtoInputAttribute *inAtt2 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	SHProtoOutputAttribute *outAtt2 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	[childnode addChild:inAtt2 atIndex:-1 undoManager:nil];
	[childnode addChild:outAtt2 atIndex:-1 undoManager:nil];

	/* Try without ics */
	NSData *archive = [NSKeyedArchiver archivedDataWithRootObject:_parent];
	STAssertNotNil(archive, @"ooch");
	SHParent *parent2 = [NSKeyedUnarchiver unarchiveObjectWithData:archive];
	STAssertNotNil(parent2, @"ooch");
	STAssertTrue([parent2 isEquivalentTo:_parent], @"archive should be straight forward!");
	STAssertTrue([parent2.name isEqualToNodeName:_parent.name], @"archive should be straight forward!");
	SHProtoInputAttribute *inAtt1_copy = [[parent2 inputs] objectAtIndex:0];
	STAssertTrue( inAtt1_copy.parentSHNode==parent2, @"archive should be straight forward!");
	STAssertTrue( [inAtt1_copy isEquivalentTo:inAtt1], @"archive should be straight forward!");
	STAssertFalse( inAtt1_copy==inAtt1, @"archive should be straight forward!");

	/* try with ics */
	[_parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)inAtt1 andInletOfAtt:(SHProtoAttribute *)outAtt1 undoManager:nil];
	SHInterConnector* int1 = [_parent interConnectorFor:inAtt1 and:outAtt1];
	STAssertNotNil(int1, @"failed to connect 2 inAttributes");
	NSData *archive2 = [NSKeyedArchiver archivedDataWithRootObject:_parent];
	STAssertNotNil(archive2, @"ooch");
	SHParent *parent3 = [NSKeyedUnarchiver unarchiveObjectWithData:archive2];
	STAssertNotNil(parent3, @"ooch");
	STAssertTrue([parent3 isEquivalentTo:_parent], @"archive should be straight forward!");
	STAssertTrue([parent3.name isEqualToNodeName:_parent.name], @"archive should be straight forward!");	
}

- (void)testIsEquivalentTo {
//- (BOOL)isEquivalentTo:(id)anObject

	SHParent *parent2 = [SHParent makeChildWithName:@"rootNode"];
	STAssertTrue([parent2 isEquivalentTo:_parent], @"copy should be straight forward!");
	SHProtoInputAttribute *p1_inAtt1 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	SHProtoInputAttribute *p2_inAtt1 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	
	// test an input
	[_parent addChild:p1_inAtt1 atIndex:-1 undoManager:nil];
	STAssertFalse([parent2 isEquivalentTo:_parent], @"copy should be straight forward!");
	[parent2 addChild:p2_inAtt1 atIndex:-1 undoManager:nil];
	STAssertTrue([parent2 isEquivalentTo:_parent], @"copy should be straight forward!");
	
	// test an output
	SHProtoOutputAttribute *p1_outAtt1 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	SHProtoOutputAttribute *p2_outAtt1 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	[_parent addChild:p1_outAtt1 atIndex:-1 undoManager:nil];
	STAssertFalse([parent2 isEquivalentTo:_parent], @"copy should be straight forward!");
	[parent2 addChild:p2_outAtt1 atIndex:-1 undoManager:nil];
	STAssertTrue([parent2 isEquivalentTo:_parent], @"copy should be straight forward!");
	
	// test an ic
	[_parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)p1_inAtt1 andInletOfAtt:(SHProtoAttribute *)p1_outAtt1 undoManager:nil];
	STAssertFalse([parent2 isEquivalentTo:_parent], @"copy should be straight forward!");
	[parent2 _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)p2_inAtt1 andInletOfAtt:(SHProtoAttribute *)p2_outAtt1 undoManager:nil];
	STAssertTrue([parent2 isEquivalentTo:_parent], @"copy should be straight forward!");
	
	// test that it calls [super isEquivalentTo:]
	[parent2 changeNameWithStringTo:@"tickle" fromParent:nil undoManager:nil];
	STAssertFalse([parent2 isEquivalentTo:_parent], @"copy should be straight forward!");
}

- (void)testCopyWithZone {
//- (id)copyWithZone:(NSZone *)zone

	/* Simple case */
	SHProtoInputAttribute *inAtt1 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	[_parent addChild:inAtt1 atIndex:-1 undoManager:nil];
	
	SHParent *duplicate1 = [[_parent copy] autorelease];
	STAssertTrue([duplicate1 isEquivalentTo:_parent], @"copy should be straight forward!");
	STAssertFalse(duplicate1==_parent, @"christ");
	STAssertTrue([duplicate1.name isEqualToNodeName:_parent.name], @"copy should be straight forward!");
	SHProtoInputAttribute *inAtt1_copy = [[duplicate1 inputs] objectAtIndex:0];
	STAssertTrue( [inAtt1_copy isEquivalentTo:inAtt1], @"doh");
	STAssertTrue( inAtt1_copy!=inAtt1, @"doh");
	STAssertTrue( [inAtt1_copy parentSHNode]==duplicate1, @"copy hasn't filled in parent nodes");

	/* Bit more complex */
	SHProtoOutputAttribute *outAtt1 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	[_parent addChild:outAtt1 atIndex:-1 undoManager:nil];
	SHParent *duplicate2 = [[_parent copy] autorelease];
	STAssertTrue([duplicate2 isEquivalentTo:_parent], @"copy should be straight forward!");
	STAssertFalse(duplicate2==_parent, @"christ");
	STAssertTrue([duplicate2.name isEqualToNodeName:_parent.name], @"copy should be straight forward!");
	SHProtoOutputAttribute *outAtt1_copy = [[duplicate2 outputs] objectAtIndex:0];
	STAssertTrue( [outAtt1_copy isEquivalentTo:outAtt1], @"doh");
	STAssertTrue( outAtt1_copy!=outAtt1, @"doh");
	STAssertTrue( [outAtt1_copy parentSHNode]==duplicate2, @"copy hasn't filled in parent nodes");
	
	/* With Interconnectors */
	SHParent *childnode = [SHParent makeChildWithName:@"1"];
	[_parent addChild:childnode atIndex:-1 undoManager:nil];
	SHProtoInputAttribute *inAtt2 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	SHProtoOutputAttribute *outAtt2 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	[childnode addChild:inAtt2 atIndex:-1 undoManager:nil];
	[childnode addChild:outAtt2 atIndex:-1 undoManager:nil];
	[_parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)inAtt1 andInletOfAtt:(SHProtoAttribute *)outAtt1 undoManager:nil];
	SHInterConnector* int1 = [_parent interConnectorFor:inAtt1 and:outAtt1];
	STAssertNotNil(int1, @"failed to connect 2 inAttributes");

	[childnode _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)inAtt2 andInletOfAtt:(SHProtoAttribute *)outAtt2 undoManager:nil];
	SHInterConnector* int2 = [childnode interConnectorFor:inAtt2 and:outAtt2];
	STAssertNotNil(int2, @"failed to connect 2 inAttributes");
	
	SHParent *duplicate3 = [[_parent copy] autorelease];
	STAssertTrue([duplicate3 isEquivalentTo:_parent], @"copy should be straight forward!");
	STAssertFalse(duplicate3==_parent, @"christ");
	STAssertTrue([duplicate3.name isEqualToNodeName:_parent.name], @"copy should be straight forward!");
	SHInterConnector *int1_copy = [[duplicate3 shInterConnectorsInside] objectAtIndex:0];
	STAssertTrue( [int1_copy isEquivalentTo:int1], @"doh");
	STAssertTrue( int1_copy!=int1, @"doh");
	STAssertTrue( [int1_copy parentSHNode]==duplicate3, @"copy hasn't filled in parent nodes");
}

- (void)testRelativePathToChild {
	// - (SH_Path *)relativePathToChild:(id)aNode
	// - (id)childAtRelativePath:(SH_Path *)relativeChildPath
	
	SHParent* childNode1 = [SHParent makeChildWithName:@"n1"], *childNode2 = [SHParent makeChildWithName:@"n2"], *childNode3 = [SHParent makeChildWithName:@"n3"], *childNode4 = [SHParent makeChildWithName:@"n4"];
	
	// try some nodes
	[_parent addChild:childNode1 atIndex:-1 undoManager:nil];
	[_parent addChild:childNode2 atIndex:-1 undoManager:nil];
	[childNode1 addChild:childNode3 atIndex:-1 undoManager:nil];
	[childNode3 addChild:childNode4 atIndex:-1 undoManager:nil];
	
	STAssertNil([_parent childAtRelativePath:[SH_Path pathWithString:@"gravy"]], @"made up path");
	
	SH_Path* relativePath = [_parent relativePathToChild:childNode4];
	STAssertTrue([[relativePath pathAsString] isEqualToString:@"n1/n3/n4"], @"relative path is wrong %@", [relativePath pathAsString]);
	
	id foundChild = [_parent childAtRelativePath:relativePath];
	STAssertEqualObjects(foundChild, childNode4, @"cant get child at path");
	
	// try some inputs and outputs
	SHProtoInputAttribute* i1 = [SHProtoInputAttribute makeChildWithName:@"i1"], *i2 = [SHProtoInputAttribute makeChildWithName:@"i2"], *i3 = [SHProtoInputAttribute makeChildWithName:@"i3"];
	SHProtoOutputAttribute* o1 = [SHProtoOutputAttribute makeChildWithName:@"o1"], *o2 = [SHProtoOutputAttribute makeChildWithName:@"o2"], *o3 = [SHProtoOutputAttribute makeChildWithName:@"o3"];
	[_parent addChild:o1 atIndex:-1 undoManager:nil];
	[childNode1 addChild:i1 atIndex:-1 undoManager:nil];
	[childNode1 addChild:i2 atIndex:-1 undoManager:nil];
	[childNode3 addChild:i3 atIndex:-1 undoManager:nil];
	[childNode4 addChild:o2 atIndex:-1 undoManager:nil];
	[childNode3 addChild:o3 atIndex:-1 undoManager:nil];
	
	STAssertTrue([[[_parent relativePathToChild:o1] pathAsString] isEqualToString:@"o1"], @"relative path is wrong %@", [[_parent relativePathToChild:o1] pathAsString]);
	STAssertTrue([[[_parent relativePathToChild:i1] pathAsString] isEqualToString:@"n1/i1"], @"relative path is wrong %@", [[_parent relativePathToChild:i1] pathAsString]);
	STAssertTrue([[[_parent relativePathToChild:i2] pathAsString] isEqualToString:@"n1/i2"], @"relative path is wrong %@", [[_parent relativePathToChild:i2] pathAsString]);
	STAssertTrue([[[_parent relativePathToChild:i3] pathAsString] isEqualToString:@"n1/n3/i3"], @"relative path is wrong %@", [[_parent relativePathToChild:i3] pathAsString]);
	STAssertTrue([[[_parent relativePathToChild:o2] pathAsString] isEqualToString:@"n1/n3/n4/o2"], @"relative path is wrong %@", [[_parent relativePathToChild:o2] pathAsString]);
		
	STAssertEqualObjects([_parent childAtRelativePath:[SH_Path pathWithString:@"n1/n3/n4/o2"]], o2, @"cant get child at path");

	// try some ics
	[_parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)o1 andInletOfAtt:(SHProtoAttribute *)i1 undoManager:nil];
	[childNode1 _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)i2 andInletOfAtt:(SHProtoAttribute *)i3 undoManager:nil];
	[childNode3 _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)o2 andInletOfAtt:(SHProtoAttribute *)o3 undoManager:nil];
	SHInterConnector* int1 = [_parent interConnectorFor:o1 and:i1];
	SHInterConnector* int2 = [childNode1 interConnectorFor:i2 and:i3];
	SHInterConnector* int3 = [childNode3 interConnectorFor:o2 and:o3];
	STAssertTrue([[[_parent relativePathToChild:int1] pathAsString] isEqualToString:@"InterConnector"], @"relative path is wrong <%@>", [[_parent relativePathToChild:int1] pathAsString]);
	STAssertTrue([[[_parent relativePathToChild:int2] pathAsString] isEqualToString:@"n1/InterConnector"], @"relative path is wrong <%@>", [[_parent relativePathToChild:int2] pathAsString]);
	STAssertTrue([[[_parent relativePathToChild:int3] pathAsString] isEqualToString:@"n1/n3/InterConnector"], @"relative path is wrong <%@>", [[_parent relativePathToChild:int3] pathAsString]);
	
	STAssertEqualObjects([_parent childAtRelativePath:[SH_Path pathWithString:@"n1/n3/InterConnector"]], int3, @"cant get child at path");
}	

- (void)testReverseNodeChainToNode {
	// - (NSArray *)reverseNodeChainToNode:(id<SHNodeLikeProtocol>)aNode

	SHProtoInputAttribute* i1 = [SHProtoInputAttribute makeChildWithName:@"i1"];
	SHProtoOutputAttribute* o1 = [SHProtoOutputAttribute makeChildWithName:@"o1"];
	SHParent *parent2 = [SHParent makeChildWithName:@"p2"];
	SHProtoInputAttribute* i2 = [SHProtoInputAttribute makeChildWithName:@"i2"];
	SHProtoOutputAttribute* o2 = [SHProtoOutputAttribute makeChildWithName:@"o2"];
	SHParent *parent3 = [SHParent makeChildWithName:@"p3"];
	SHProtoInputAttribute* i3 = [SHProtoInputAttribute makeChildWithName:@"i3"];
	SHProtoOutputAttribute* o3 = [SHProtoOutputAttribute makeChildWithName:@"o3"];
	[_parent addChild:parent2 atIndex:-1 undoManager:nil];
	[parent2 addChild:parent3 atIndex:-1 undoManager:nil];
	[_parent addChild:i1 atIndex:-1 undoManager:nil];
	[_parent addChild:o1 atIndex:-1 undoManager:nil];
	[parent2 addChild:i2 atIndex:-1 undoManager:nil];
	[parent2 addChild:o2 atIndex:-1 undoManager:nil];
	[parent3 addChild:i3 atIndex:-1 undoManager:nil];
	[parent3 addChild:o3 atIndex:-1 undoManager:nil];
	[_parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)i1 andInletOfAtt:(SHProtoAttribute *)o1 undoManager:nil];
	SHInterConnector* int1 = [_parent interConnectorFor:i1 and:o1];
	[parent2 _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)i2 andInletOfAtt:(SHProtoAttribute *)o2 undoManager:nil];
	SHInterConnector* int2 = [parent2 interConnectorFor:i2 and:o2];
	[parent3 _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)i3 andInletOfAtt:(SHProtoAttribute *)o3 undoManager:nil];
	SHInterConnector* int3 = [parent3 interConnectorFor:i3 and:o3];

	SHProtoOutputAttribute *o1_2 = [SHProtoOutputAttribute makeChildWithName:@"o1_2"];
	SHProtoInputAttribute *i2_2 = [SHProtoInputAttribute makeChildWithName:@"i2_2"];
	SHProtoInputAttribute *i2_3 = [SHProtoInputAttribute makeChildWithName:@"i2_3"];
	SHProtoOutputAttribute *o2_2 = [SHProtoOutputAttribute makeChildWithName:@"o2_2"];
	SHProtoInputAttribute *i3_2 = [SHProtoInputAttribute makeChildWithName:@"i3_2"];
	SHProtoOutputAttribute *o3_2 = [SHProtoOutputAttribute makeChildWithName:@"o3_2"];
	[parent3 addChild:o1_2 atIndex:-1 undoManager:nil];
	[parent3 addChild:i2_2 atIndex:-1 undoManager:nil];
	[parent3 addChild:o2_2 atIndex:-1 undoManager:nil];
	[parent3 addChild:i2_3 atIndex:-1 undoManager:nil];
	[parent3 addChild:i3_2 atIndex:-1 undoManager:nil];
	[parent3 addChild:o3_2 atIndex:-1 undoManager:nil];
	
	[_parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)o1_2 andInletOfAtt:(SHProtoAttribute *)i2_2 undoManager:nil];
	SHInterConnector* int4 = [_parent interConnectorFor:i1 and:o1];
	
	[_parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)o2_2 andInletOfAtt:(SHProtoAttribute *)i3_2 undoManager:nil];
	SHInterConnector* int5 = [parent2 interConnectorFor:i2 and:o2];
	
	[_parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)o3_2 andInletOfAtt:(SHProtoAttribute *)i2_3 undoManager:nil];
	SHInterConnector* int6 = [parent3 interConnectorFor:i3 and:o3];
	
	STAssertNotNil(int4, @"doh");
	STAssertNotNil(int5, @"doh");
	STAssertNotNil(int6, @"doh");

	STAssertThrows([_parent reverseNodeChainToNode:_parent], @"not a child");
	NSArray *rev2 = [_parent reverseNodeChainToNode:parent2];
	STAssertTrue([rev2 count]==2, @"should be");
	STAssertEqualObjects([rev2 objectAtIndex:0], parent2, @"should be");
	STAssertEqualObjects([rev2 objectAtIndex:1], _parent, @"should be");
	
	NSArray *rev3 = [_parent reverseNodeChainToNode:parent3];
	STAssertTrue([rev3 count]==3, @"should be");
	STAssertEqualObjects([rev3 objectAtIndex:0], parent3, @"should be");
	STAssertEqualObjects([rev3 objectAtIndex:1], parent2, @"should be");
	STAssertEqualObjects([rev3 objectAtIndex:2], _parent, @"should be");

	NSArray *rev4 = [_parent reverseNodeChainToNode:i1];
	STAssertTrue([rev4 count]==2, @"should be");
	STAssertEqualObjects([rev4 objectAtIndex:0], i1, @"should be");
	STAssertEqualObjects([rev4 objectAtIndex:1], _parent, @"should be");

	NSArray *rev5 = [_parent reverseNodeChainToNode:o1];
	NSArray *rev6 = [_parent reverseNodeChainToNode:i2];
	NSArray *rev7 = [_parent reverseNodeChainToNode:o2];
	NSArray *rev8 = [_parent reverseNodeChainToNode:i3];
	NSArray *rev9 = [_parent reverseNodeChainToNode:o3];

	NSArray *rev10 = [_parent reverseNodeChainToNode:int1];
	STAssertTrue([rev10 count]==2, @"should be");
	STAssertEqualObjects([rev10 objectAtIndex:0], int1, @"should be");
	STAssertEqualObjects([rev10 objectAtIndex:1], _parent, @"should be");
	
	NSArray *rev11 = [_parent reverseNodeChainToNode:int2];
	STAssertTrue([rev11 count]==3, @"should be");
	STAssertEqualObjects([rev11 objectAtIndex:0], int2, @"should be");
	STAssertEqualObjects([rev11 objectAtIndex:1], parent2, @"should be");
	STAssertEqualObjects([rev11 objectAtIndex:2], _parent, @"should be");
	
	NSArray *rev12 = [_parent reverseNodeChainToNode:int3];
	STAssertTrue([rev12 count]==4, @"should be");
	STAssertEqualObjects([rev12 objectAtIndex:0], int3, @"should be");
	STAssertEqualObjects([rev12 objectAtIndex:1], parent3, @"should be");
	STAssertEqualObjects([rev12 objectAtIndex:2], parent2, @"should be");
	STAssertEqualObjects([rev12 objectAtIndex:3], _parent, @"should be");
	
	NSArray *rev13 = [_parent reverseNodeChainToNode:o1_2];
	NSArray *rev14 = [_parent reverseNodeChainToNode:i2_2];
	NSArray *rev15 = [_parent reverseNodeChainToNode:i2_3];
	NSArray *rev16 = [_parent reverseNodeChainToNode:o2_2];
	NSArray *rev17 = [_parent reverseNodeChainToNode:i3_2];
	NSArray *rev18 = [_parent reverseNodeChainToNode:o3_2];

	NSArray *rev19 = [_parent reverseNodeChainToNode:int4];
	NSArray *rev20 = [_parent reverseNodeChainToNode:int5];
	NSArray *rev21 = [_parent reverseNodeChainToNode:int6];
}

- (void)testIndexPathToNode {
	// - (NSArray *)indexPathToNode:(id<SHNodeLikeProtocol>)aNode
	//- (NSObject<SHNodeLikeProtocol> *)objectForIndexPathToNode:(NSArray *)value

	// - (id)objectForIndexString:(NSString *)value // recipricol of above

	// add some bumpf
	SHProtoInputAttribute* i1 = [SHProtoInputAttribute makeChildWithName:@"i1"];
	SHProtoOutputAttribute* o1 = [SHProtoOutputAttribute makeChildWithName:@"o1"];
	SHParent *parent2 = [SHParent makeChildWithName:@"p2"];
	SHProtoInputAttribute* i2 = [SHProtoInputAttribute makeChildWithName:@"i2"];
	SHProtoOutputAttribute* o2 = [SHProtoOutputAttribute makeChildWithName:@"o2"];
	SHParent *parent3 = [SHParent makeChildWithName:@"p3"];
	SHProtoInputAttribute* i3 = [SHProtoInputAttribute makeChildWithName:@"i3"];
	SHProtoOutputAttribute* o3 = [SHProtoOutputAttribute makeChildWithName:@"o3"];
	
	STAssertThrows([parent2 indexPathToNode:o2], @"only works for children");
	
	[_parent addChild:parent2 atIndex:-1 undoManager:nil];
	[parent2 addChild:parent3 atIndex:-1 undoManager:nil];
	[_parent addChild:i1 atIndex:-1 undoManager:nil];
	[_parent addChild:o1 atIndex:-1 undoManager:nil];
	[parent2 addChild:i2 atIndex:-1 undoManager:nil];
	[parent2 addChild:o2 atIndex:-1 undoManager:nil];
	[parent3 addChild:i3 atIndex:-1 undoManager:nil];
	[parent3 addChild:o3 atIndex:-1 undoManager:nil];
	[_parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)i1 andInletOfAtt:(SHProtoAttribute *)o1 undoManager:nil];
	SHInterConnector* int1 = [_parent interConnectorFor:i1 and:o1];
	[parent2 _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)i2 andInletOfAtt:(SHProtoAttribute *)o2 undoManager:nil];
	SHInterConnector* int2 = [parent2 interConnectorFor:i2 and:o2];
	[parent3 _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)i3 andInletOfAtt:(SHProtoAttribute *)o3 undoManager:nil];
	SHInterConnector* int3 = [parent3 interConnectorFor:i3 and:o3];

	NSArray *indexes1 = [_parent indexPathToNode:parent2];
	NSArray *indexes2 = [_parent indexPathToNode:parent3];
	NSArray *indexes3 = [_parent indexPathToNode:i1];
	NSArray *indexes4 = [_parent indexPathToNode:i2];
	NSArray *indexes5 = [_parent indexPathToNode:i3];
	NSArray *indexes6 = [_parent indexPathToNode:o1];
	NSArray *indexes7 = [_parent indexPathToNode:o2];
	NSArray *indexes8 = [_parent indexPathToNode:o3];
	NSArray *indexes9 = [_parent indexPathToNode:int1];
	NSArray *indexes10 = [_parent indexPathToNode:int2];
	NSArray *indexes11 = [_parent indexPathToNode:int3];

	STAssertTrue([indexes1 count]==1, @"should be 1 deep but is %i", [indexes1 count]);
	STAssertTrue([[indexes1 objectAtIndex:0] isEqualToString:@"n0"], @"index path should be 'n0' but is %@", [indexes1 objectAtIndex:0]);

	STAssertTrue([indexes2 count]==2, @"should be 1 deep but is %i", [indexes2 count]);
	STAssertTrue([indexes3 count]==1, @"should be 1 deep but is %i", [indexes3 count]);
	STAssertTrue([indexes4 count]==2, @"should be 1 deep but is %i", [indexes4 count]);
	STAssertTrue([indexes5 count]==3, @"should be 1 deep but is %i", [indexes5 count]);
	STAssertTrue([indexes6 count]==1, @"should be 1 deep but is %i", [indexes6 count]);
	STAssertTrue([indexes7 count]==2, @"should be 1 deep but is %i", [indexes7 count]);
	STAssertTrue([indexes8 count]==3, @"should be 1 deep but is %i", [indexes8 count]);
	STAssertTrue([indexes9 count]==1, @"should be 1 deep but is %i", [indexes9 count]);
	STAssertTrue([indexes10 count]==2, @"should be 1 deep but is %i", [indexes10 count]);
	STAssertTrue([indexes11 count]==3, @"should be 1 deep but is %i", [indexes11 count]);
	
	STAssertEqualObjects( [_parent objectForIndexString:@"n0"], parent2, @"should be" );
	STAssertEqualObjects( [parent3 objectForIndexString:@"i0"], i3, @"should be" );
	STAssertEqualObjects( [parent3 objectForIndexString:@"o0"], o3, @"should be" );
	STAssertEqualObjects( [parent3 objectForIndexString:@"c0"], int3, @"should be" );
	STAssertNil([parent3 objectForIndexString:@"a0"], @"not valid");
	
	STAssertTrue([_parent objectForIndexPathToNode:indexes5]==i3, @"doh!");
}

- (void)testIsNodeParentOfMe {
	// - (BOOL)isNodeParentOfMe:(id<SHParentLikeProtocol>)aNode;
	
	SHParent *parent2 = [SHParent makeChildWithName:@"p2"];
	SHParent *parent3 = [SHParent makeChildWithName:@"p3"];
	[parent2 addChild:parent3 atIndex:-1 undoManager:nil];
	[_parent addChild:parent2 atIndex:-1 undoManager:nil];
	
	STAssertFalse([_parent isNodeParentOfMe: parent2], @"node should be a parent");
	STAssertTrue([parent3 isNodeParentOfMe: _parent], @"node should be a parent");
}

- (void)testCountOfChildren {
	//- (unsigned int)countOfChildren
	
	STAssertTrue([_parent countOfChildren]==0, @"eh");

	SHParent *parent2 = [SHParent makeChildWithName:@"p2"];
	SHParent *parent3 = [SHParent makeChildWithName:@"p3"];
	[_parent addChild:parent3 atIndex:-1 undoManager:nil];
	STAssertTrue([_parent countOfChildren]==1, @"eh");

	[_parent addChild:parent2 atIndex:-1 undoManager:nil];
	STAssertTrue([_parent countOfChildren]==2, @"eh");

	[_parent deleteChild:parent3 undoManager:nil];
	STAssertTrue([_parent countOfChildren]==1, @"eh");
}

- (void)testNodeAtIndex {
	//- (SHChild *)nodeAtIndex:(NSUInteger)index
	
	SHParent *parent2 = [SHParent makeChildWithName:@"p2"];
	SHParent *parent3 = [SHParent makeChildWithName:@"p3"];
	[_parent addChild:parent2 atIndex:-1 undoManager:nil];
	[_parent addChild:parent3 atIndex:-1 undoManager:nil];
	SHProtoInputAttribute* inAtt1 = [SHProtoInputAttribute makeChildWithName:@"inAtt1"];
	SHProtoInputAttribute* inAtt2 = [SHProtoInputAttribute makeChildWithName:@"inAtt2"];
	[_parent addChild:inAtt1 atIndex:-1 undoManager:nil];
	[_parent addChild:inAtt2 atIndex:-1 undoManager:nil];	
	[_parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)inAtt1 andInletOfAtt:(SHProtoAttribute *)inAtt2 undoManager:nil];
	SHInterConnector *int1 = [_parent interConnectorFor:inAtt1 and:inAtt2];
	
	id aNode = [_parent nodeAtIndex:1];
	STAssertTrue(aNode==parent3, @"eh");
}

- (void)testConnectorAtIndex {
	//- (SHChild *)connectorAtIndex:(NSUInteger)index
	
	SHParent *parent2 = [SHParent makeChildWithName:@"p2"];
	SHParent *parent3 = [SHParent makeChildWithName:@"p3"];
	[_parent addChild:parent2 atIndex:-1 undoManager:nil];
	[_parent addChild:parent3 atIndex:-1 undoManager:nil];
	SHProtoInputAttribute* inAtt1 = [SHProtoInputAttribute makeChildWithName:@"inAtt1"];
	SHProtoInputAttribute* inAtt2 = [SHProtoInputAttribute makeChildWithName:@"inAtt2"];
	[_parent addChild:inAtt1 atIndex:-1 undoManager:nil];
	[_parent addChild:inAtt2 atIndex:-1 undoManager:nil];
	SHProtoOutputAttribute* outAtt1 = [SHProtoOutputAttribute makeChildWithName:@"outAtt1"];
	SHProtoOutputAttribute* outAtt2 = [SHProtoOutputAttribute makeChildWithName:@"outAtt2"];
	[_parent addChild:outAtt1 atIndex:-1 undoManager:nil];
	[_parent addChild:outAtt2 atIndex:-1 undoManager:nil];
	[_parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)outAtt1 andInletOfAtt:(SHProtoAttribute *)inAtt1 undoManager:nil];
	[_parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)outAtt2 andInletOfAtt:(SHProtoAttribute *)inAtt2 undoManager:nil];
	SHInterConnector* int1 = [_parent interConnectorFor:outAtt1 and:inAtt1];
	SHInterConnector* int2 = [_parent interConnectorFor:outAtt2 and:inAtt2];

	STAssertTrue([_parent connectorAtIndex:1]==int2, @"eh");
}

- (void)testInputAtIndex {
	//- (SHChild *)inputAtIndex:(NSUInteger)index;
	
	SHParent *parent2 = [SHParent makeChildWithName:@"p2"];
	SHParent *parent3 = [SHParent makeChildWithName:@"p3"];
	[_parent addChild:parent2 atIndex:-1 undoManager:nil];
	[_parent addChild:parent3 atIndex:-1 undoManager:nil];
	SHProtoInputAttribute* inAtt1 = [SHProtoInputAttribute makeChildWithName:@"inAtt1"];
	SHProtoInputAttribute* inAtt2 = [SHProtoInputAttribute makeChildWithName:@"inAtt2"];
	[_parent addChild:inAtt1 atIndex:-1 undoManager:nil];
	[_parent addChild:inAtt2 atIndex:-1 undoManager:nil];
	SHProtoOutputAttribute* outAtt1 = [SHProtoOutputAttribute makeChildWithName:@"outAtt1"];
	SHProtoOutputAttribute* outAtt2 = [SHProtoOutputAttribute makeChildWithName:@"outAtt2"];
	[_parent addChild:outAtt1 atIndex:-1 undoManager:nil];
	[_parent addChild:outAtt2 atIndex:-1 undoManager:nil];
	[_parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)outAtt1 andInletOfAtt:(SHProtoAttribute *)inAtt1 undoManager:nil];
	[_parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)outAtt2 andInletOfAtt:(SHProtoAttribute *)inAtt2 undoManager:nil];

	STAssertTrue([_parent inputAtIndex:1]==inAtt2, @"eh");
}

- (void)testOutputAtIndex {
	//- (SHChild *)outputAtIndex:(NSUInteger)index;
	
	SHParent *parent2 = [SHParent makeChildWithName:@"p2"];
	SHParent *parent3 = [SHParent makeChildWithName:@"p3"];
	[_parent addChild:parent2 atIndex:-1 undoManager:nil];
	[_parent addChild:parent3 atIndex:-1 undoManager:nil];
	SHProtoOutputAttribute* inAtt1 = [SHProtoOutputAttribute makeChildWithName:@"inAtt1"];
	SHProtoOutputAttribute* inAtt2 = [SHProtoOutputAttribute makeChildWithName:@"inAtt2"];
	[_parent addChild:inAtt1 atIndex:-1 undoManager:nil];
	[_parent addChild:inAtt2 atIndex:-1 undoManager:nil];
	SHProtoOutputAttribute* outAtt1 = [SHProtoOutputAttribute makeChildWithName:@"outAtt1"];
	SHProtoOutputAttribute* outAtt2 = [SHProtoOutputAttribute makeChildWithName:@"outAtt2"];
	[_parent addChild:outAtt1 atIndex:-1 undoManager:nil];
	[_parent addChild:outAtt2 atIndex:-1 undoManager:nil];
	[_parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)outAtt1 andInletOfAtt:(SHProtoAttribute *)inAtt1 undoManager:nil];
	[_parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)outAtt2 andInletOfAtt:(SHProtoAttribute *)inAtt2 undoManager:nil];
	
	STAssertTrue([_parent outputAtIndex:1]==inAtt2, @"eh");
}

- (void)testIsLeaf {
	//- (BOOL)isLeaf;
	
	STAssertTrue([_parent isLeaf], @"eh");

	SHParent *parent2 = [SHParent makeChildWithName:@"p2"];
	SHParent *parent3 = [SHParent makeChildWithName:@"p3"];
	[_parent addChild:parent2 atIndex:-1 undoManager:nil];
	
	STAssertFalse([_parent isLeaf], @"eh");
	[_parent deleteChild:parent2 undoManager:nil];
	STAssertTrue([_parent isLeaf], @"eh");
}

- (void)testNodesInside {
	//- (SHOrderedDictionary *)nodesInside
	
	SHParent *parent2 = [SHParent makeChildWithName:@"p2"];
	SHParent *parent3 = [SHParent makeChildWithName:@"p3"];
	[_parent addChild:parent2 atIndex:-1 undoManager:nil];
	[_parent addChild:parent3 atIndex:-1 undoManager:nil];
	SHProtoInputAttribute* inAtt1 = [SHProtoInputAttribute makeChildWithName:@"inAtt1"];
	SHProtoInputAttribute* inAtt2 = [SHProtoInputAttribute makeChildWithName:@"inAtt2"];
	[_parent addChild:inAtt1 atIndex:-1 undoManager:nil];
	[_parent addChild:inAtt2 atIndex:-1 undoManager:nil];
	SHProtoOutputAttribute* outAtt1 = [SHProtoOutputAttribute makeChildWithName:@"outAtt1"];
	SHProtoOutputAttribute* outAtt2 = [SHProtoOutputAttribute makeChildWithName:@"outAtt2"];
	[_parent addChild:outAtt1 atIndex:-1 undoManager:nil];
	[_parent addChild:outAtt2 atIndex:-1 undoManager:nil];
	[_parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)outAtt1 andInletOfAtt:(SHProtoAttribute *)inAtt1 undoManager:nil];
	[_parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)outAtt2 andInletOfAtt:(SHProtoAttribute *)inAtt2 undoManager:nil];
	
	STAssertTrue([[_parent nodesInside] count]==2, @"eh");
	STAssertTrue([[_parent nodesInside] objectAtIndex:0]==parent2, @"eh");
	STAssertTrue([[_parent nodesInside] objectAtIndex:1]==parent3, @"eh");
}

- (void)testInputs {
	//- (SHOrderedDictionary *)inputs
	
	SHParent *parent2 = [SHParent makeChildWithName:@"p2"];
	SHParent *parent3 = [SHParent makeChildWithName:@"p3"];
	[_parent addChild:parent2 atIndex:-1 undoManager:nil];
	[_parent addChild:parent3 atIndex:-1 undoManager:nil];
	SHProtoInputAttribute* inAtt1 = [SHProtoInputAttribute makeChildWithName:@"inAtt1"];
	SHProtoInputAttribute* inAtt2 = [SHProtoInputAttribute makeChildWithName:@"inAtt2"];
	[_parent addChild:inAtt1 atIndex:-1 undoManager:nil];
	[_parent addChild:inAtt2 atIndex:-1 undoManager:nil];
	SHProtoOutputAttribute* outAtt1 = [SHProtoOutputAttribute makeChildWithName:@"outAtt1"];
	SHProtoOutputAttribute* outAtt2 = [SHProtoOutputAttribute makeChildWithName:@"outAtt2"];
	[_parent addChild:outAtt1 atIndex:-1 undoManager:nil];
	[_parent addChild:outAtt2 atIndex:-1 undoManager:nil];
	[_parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)outAtt1 andInletOfAtt:(SHProtoAttribute *)inAtt1 undoManager:nil];
	[_parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)outAtt2 andInletOfAtt:(SHProtoAttribute *)inAtt2 undoManager:nil];
	
	STAssertTrue([[_parent inputs] count]==2, @"eh");
	STAssertTrue([[_parent inputs] objectAtIndex:0]==inAtt1, @"eh");
	STAssertTrue([[_parent inputs] objectAtIndex:1]==inAtt2, @"eh");
}

- (void)testOutputs {
	//- (SHOrderedDictionary *)outputs
	
	SHParent *parent2 = [SHParent makeChildWithName:@"p2"];
	SHParent *parent3 = [SHParent makeChildWithName:@"p3"];
	[_parent addChild:parent2 atIndex:-1 undoManager:nil];
	[_parent addChild:parent3 atIndex:-1 undoManager:nil];
	SHProtoInputAttribute* inAtt1 = [SHProtoInputAttribute makeChildWithName:@"inAtt1"];
	SHProtoInputAttribute* inAtt2 = [SHProtoInputAttribute makeChildWithName:@"inAtt2"];
	[_parent addChild:inAtt1 atIndex:-1 undoManager:nil];
	[_parent addChild:inAtt2 atIndex:-1 undoManager:nil];
	SHProtoOutputAttribute* outAtt1 = [SHProtoOutputAttribute makeChildWithName:@"outAtt1"];
	SHProtoOutputAttribute* outAtt2 = [SHProtoOutputAttribute makeChildWithName:@"outAtt2"];
	[_parent addChild:outAtt1 atIndex:-1 undoManager:nil];
	[_parent addChild:outAtt2 atIndex:-1 undoManager:nil];
	[_parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)outAtt1 andInletOfAtt:(SHProtoAttribute *)inAtt1 undoManager:nil];
	[_parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)outAtt2 andInletOfAtt:(SHProtoAttribute *)inAtt2 undoManager:nil];
	
	STAssertTrue([[_parent outputs] count]==2, @"eh");
	STAssertTrue([[_parent outputs] objectAtIndex:0]==outAtt1, @"eh");
	STAssertTrue([[_parent outputs] objectAtIndex:1]==outAtt2, @"eh");
}

- (void)testSHInterConnectorsInside {
	//- (SHOrderedDictionary *)shInterConnectorsInside
	
	SHParent *parent2 = [SHParent makeChildWithName:@"p2"];
	SHParent *parent3 = [SHParent makeChildWithName:@"p3"];
	[_parent addChild:parent2 atIndex:-1 undoManager:nil];
	[_parent addChild:parent3 atIndex:-1 undoManager:nil];
	SHProtoInputAttribute* inAtt1 = [SHProtoInputAttribute makeChildWithName:@"inAtt1"];
	SHProtoInputAttribute* inAtt2 = [SHProtoInputAttribute makeChildWithName:@"inAtt2"];
	[_parent addChild:inAtt1 atIndex:-1 undoManager:nil];
	[_parent addChild:inAtt2 atIndex:-1 undoManager:nil];
	SHProtoOutputAttribute* outAtt1 = [SHProtoOutputAttribute makeChildWithName:@"outAtt1"];
	SHProtoOutputAttribute* outAtt2 = [SHProtoOutputAttribute makeChildWithName:@"outAtt2"];
	[_parent addChild:outAtt1 atIndex:-1 undoManager:nil];
	[_parent addChild:outAtt2 atIndex:-1 undoManager:nil];
	[_parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)outAtt1 andInletOfAtt:(SHProtoAttribute *)inAtt1 undoManager:nil];
	[_parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)outAtt2 andInletOfAtt:(SHProtoAttribute *)inAtt2 undoManager:nil];
	SHInterConnector* int1 = [_parent interConnectorFor:outAtt1 and:inAtt1];
	SHInterConnector* int2 = [_parent interConnectorFor:outAtt2 and:inAtt2];
	
	STAssertTrue([[_parent shInterConnectorsInside] count]==2, @"eh");
	STAssertTrue([[_parent shInterConnectorsInside] objectAtIndex:0]==int1, @"eh");
	STAssertTrue([[_parent shInterConnectorsInside] objectAtIndex:1]==int2, @"eh");
}

- (void)testChildrenBelongingToParentFromSet {
	// + (NSSet *)childrenBelongingToParent:(NSObject<ChildAndParentProtocol> *)parent fromSet:(NSSet *)children
	
	SHParent *ob1Yes = [SHParent makeChildWithName:@"ob1Yes"];
	SHParent *ob2Yes = [SHParent makeChildWithName:@"ob2Yes"];
	SHParent *ob3No = [SHParent makeChildWithName:@"ob3No"];
	SHParent *fakeParent = [SHParent makeChildWithName:@"fakeParent"];
	
	[_parent addChild:ob1Yes atIndex:-1 undoManager:nil];
	[_parent addChild:ob2Yes atIndex:-1 undoManager:nil];
	[fakeParent addChild:ob3No atIndex:-1 undoManager:nil];

	NSSet *children = [NSSet setWithObjects:ob1Yes,ob2Yes,ob3No,nil];
	NSSet *filteredResults = [SHParent childrenBelongingToParent:_parent fromSet:children];
	
	STAssertTrue(2==[filteredResults count], @"doh %i", [children count]);
	STAssertTrue([filteredResults containsObject:ob1Yes], @"doh");
	STAssertTrue([filteredResults containsObject:ob2Yes], @"doh");
}

@end
