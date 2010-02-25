//
//  StarSceneTests.m
//  DebugDrawing
//
//  Created by steve hooley on 25/09/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "TestUtilities.h"
#import "Star.h"
#import "StarScene.h"
#import "AppControl.h"
#import "Graphic.h"

static int _currentFilteredContentSelectionIndexes, _currentFilteredContentChanges, _selectedItemIndexesChanges, _selectedItemsChanges;


@interface StarSceneTests : SenTestCase {
	
	SHNodeGraphModel	*_model;
	StarScene			*_scene;
}

@end


@implementation StarSceneTests

- (void)setUp {
	
	_model = [[SHNodeGraphModel makeEmptyModel] retain];
	_scene = [StarScene new];
	_scene.model = _model;

	STAssertTrue( [[_scene currentFilteredContent] count]==0, @"Err %i", [[_scene currentFilteredContent] count]);
}

- (void)tearDown {
	
	_scene.model = nil;
	[_scene release];
	[_model release];
}

static NSArray *newValue, *oldValue;
static NSIndexSet *changeIndexes;
static NSNumber *changeKind;
static SHNode *_oldCurrentNode, *_newCurrentNode;
static int _nodeChangedNotifications, _currentNPChangedNotifications, _selectionChangedNotifications;

+ (void)resetObservers {
	
	changeKind = nil;
	newValue = nil;
	oldValue = nil;
	changeIndexes = nil;
	_oldCurrentNode = nil;
	_newCurrentNode = nil;
	_nodeChangedNotifications = 0;
	_currentNPChangedNotifications = 0;
	_selectionChangedNotifications=0;
	_currentFilteredContentSelectionIndexes = 0;
	_currentFilteredContentChanges = 0;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

	NSString *cntxt = (NSString *)context;
	if(cntxt==nil)
		[NSException raise:@"MUST SUPPLY A CONTEXT" format:@"MUST SUPPLY A CONTEXT"];
	
    if( [cntxt isEqualToString:@"StarSceneTests"]==NO )
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];   
	
	oldValue = [change objectForKey:NSKeyValueChangeOldKey];
	BOOL oldValueNullOrNil = [oldValue isEqual:[NSNull null]] || oldValue==nil;
	newValue = [change objectForKey:NSKeyValueChangeNewKey];
	BOOL newValueNullOrNil = [newValue isEqual:[NSNull null]] || newValue==nil;
	changeKind = [change objectForKey:NSKeyValueChangeKindKey];
	changeIndexes = [change objectForKey:NSKeyValueChangeIndexesKey]; //  NSKeyValueChangeInsertion, NSKeyValueChangeRemoval, or NSKeyValueChangeReplacement, 		
	
	if ([keyPath isEqualToString:@"currentFilteredContent"] )
	{
		_currentFilteredContentChanges++;
		switch ([changeKind intValue]) 
		{
			case NSKeyValueChangeInsertion:
				NSAssert( oldValueNullOrNil, @"what would this be for an insertion?");
				NSAssert( newValueNullOrNil==NO, @"need this for an insertion");
				NSAssert( changeIndexes!=nil, @"need this for an insertion?");
//				_nodeInsertedNotifications++;
				break;
			case NSKeyValueChangeReplacement:
//				NSAssert( oldValueNullOrNil==NO, @"must have replaced something" );
//				NSAssert( newValueNullOrNil==NO, @"need this for a replacement" );
				NSAssert( changeIndexes!=nil, @"need this for a replacement" );
//				_nodeReplacedNotifications++;
				break;
			case NSKeyValueChangeSetting:
				_nodeChangedNotifications++;
				break;
			case NSKeyValueChangeRemoval:
				NSAssert( oldValueNullOrNil==NO, @"need this for a removal");
				NSAssert( newValueNullOrNil==YES, @"what would this be for a removal?");
				NSAssert( changeIndexes!=nil, @"need this for an removal");
//				_nodeRemovalNotifications++;
				break;
		}
	} else if ([keyPath isEqualToString:@"currentFilteredContentSelectionIndexes"]){
		/* nothing to see here - only interested in changeIndexes */
		
		// this is the terrible hack where i have filled the changedIndexes with my own data
		changeIndexes = [(NSArray *)changeIndexes objectAtIndex:0];
		_selectionChangedNotifications++;
		_currentFilteredContentSelectionIndexes++;

	} else if ([keyPath isEqualToString:@"currentProxy"]){
		_currentNPChangedNotifications++;
		_newCurrentNode = [(NodeProxy *)newValue originalNode];
		_oldCurrentNode = [(NodeProxy *)oldValue originalNode];
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];   
	}
}

#pragma mark -
#pragma mark Tests

/* What i need to know is whether notifications are received in the correct order, etc */

- (void)testWhatHappensWhenCurrentNodeChanges {

	[TestUtilities addSomeDefaultItemsToModel: _model];
	
	// - root
	// --- star1
	// --- audio1
	// --- *node1*
	// --- --- star2
	// --- --- audio2
	// --- --- node2
	STAssertTrue( _model.currentNodeGroup!=_model.rootNodeGroup, @"dufus!");

	SHNode *node1 = _model.currentNodeGroup;
	
	[_scene addObserver:self forKeyPath:@"currentFilteredContent" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"StarSceneTests"];
	[_scene addObserver:self forKeyPath:@"currentProxy" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"StarSceneTests"];
	
	[[self class] resetObservers];
	[_model setCurrentNodeGroup:_model.currentNodeGroup];
	STAssertTrue( _model.currentNodeGroup!=_model.rootNodeGroup, @"dufus!");
	STAssertTrue( _nodeChangedNotifications==1, @"no %i", _nodeChangedNotifications);
	STAssertTrue( _currentNPChangedNotifications==1, @"no %i", _currentNPChangedNotifications);


	// we should have received a notification
	STAssertTrue([newValue count]==2, @"doh %i", [newValue count]);

	STAssertTrue( _newCurrentNode==_model.currentNodeGroup, @"doh");
	STAssertTrue( _oldCurrentNode==node1, @"doh");

	[_scene removeObserver:self forKeyPath:@"currentProxy"];
	[_scene removeObserver:self forKeyPath:@"currentFilteredContent"];
}

// Make sure we get the correct notifications from scene, including changeKinds, etc.
- (void)testWhatHappensWhenContentChanges {

	// will trigger currentNode changed notification that the filter signs us up for
	[TestUtilities addSomeDefaultItemsToModel: _model];

	/* As an experiment lets see what notifications we can get out of node container */
	[_scene addObserver:self forKeyPath:@"currentFilteredContent" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"StarSceneTests"];
//	[_model.currentNodeGroup addObserver:self forKeyPath:@"childContainer.nodesInside.array" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"StarSceneTests"];

	// For starters Test a simple case where all onjects pass the filter

	//-- add an object
	Star *insertedStar1 = [Star makeChildWithName:@"insertedStar1"];
	Star *insertedStar2 = [Star makeChildWithName:@"insertedStar2"];
	Star *insertedStar3 = [Star makeChildWithName:@"insertedStar3"];

	[[self class] resetObservers];

	// NSKeyValueChangeInsertion - newValue=array, oldValue=nil, changeIndexes=relevant indexes
	[_model NEW_addChild:insertedStar1 atIndex:0];
	STAssertTrue([changeKind intValue]==NSKeyValueChangeInsertion, @"doh");
	STAssertTrue([newValue count]==1, @"doh");
	STAssertTrue([[newValue objectAtIndex:0] originalNode]==insertedStar1, @"doh");
	STAssertTrue(oldValue==nil, @"wha?");
	STAssertTrue([changeIndexes count]==1, @"doh");
	STAssertTrue([changeIndexes firstIndex]==0, @"doh");

	[[self class] resetObservers];

	// NSKeyValueChangeInsertion - newValue=array, oldValue=nil, changeIndexes=relevant indexes
	[_model insertGraphics:[NSArray arrayWithObjects:insertedStar2, insertedStar3, nil] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,2)]];
	STAssertTrue([changeKind intValue]==NSKeyValueChangeInsertion, @"doh");
	STAssertTrue([newValue count]==2, @"doh");
	STAssertTrue([[newValue objectAtIndex:0] originalNode]==insertedStar2, @"doh");
	STAssertTrue([[newValue objectAtIndex:1] originalNode]==insertedStar3, @"doh");
	STAssertTrue(oldValue==nil, @"wha?");
	STAssertTrue([changeIndexes count]==2, @"doh");
	STAssertTrue([changeIndexes firstIndex]==0, @"doh");
	STAssertTrue([changeIndexes indexGreaterThanIndex:0]==1, @"doh");

	[[self class] resetObservers];

	// NSKeyValueChangeRemoval newValue=nil, oldValue=array, changeIndexes=relevant indexes
	[_model removeGraphicAtIndex:0]; 
	STAssertTrue([changeKind intValue]==NSKeyValueChangeRemoval, @"doh");
	STAssertTrue(newValue==nil, @"doh");
	STAssertTrue([oldValue count]==1, @"wha?");
	STAssertTrue([[oldValue objectAtIndex:0] originalNode]==insertedStar2, @"doh");
	STAssertTrue([changeIndexes count]==1, @"doh");
	STAssertTrue([changeIndexes firstIndex]==0, @"doh");

	[[self class] resetObservers];

	// Now test a more complex case where some objects are filtered out
	Star *insertedStar4 = [Star makeChildWithName:@"insertedStar3"];
	SKTAudio *audio1 = [SKTAudio makeChildWithName:@"insertedAudio1"];
	[_model insertGraphics:[NSArray arrayWithObjects:insertedStar4, audio1, nil] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,2)]];
	STAssertTrue([changeKind intValue]==NSKeyValueChangeInsertion, @"doh");
	STAssertTrue([newValue count]==1, @"doh");
	STAssertTrue([[newValue objectAtIndex:0] originalNode]==insertedStar4, @"doh");
	STAssertTrue(oldValue==nil, @"wha?");
	STAssertTrue([changeIndexes count]==1, @"doh");
	STAssertTrue([changeIndexes firstIndex]==0, @"doh");

	// object at index 1 should be SKTAudio
	[[self class] resetObservers];
	[_model removeGraphicAtIndex:1]; 
	STAssertTrue(changeKind==nil, @"doh");
	STAssertTrue(newValue==nil, @"doh");
	STAssertTrue(oldValue==nil, @"doh");
	STAssertTrue(changeIndexes==nil, @"doh");

	[_scene removeObserver:self forKeyPath:@"currentFilteredContent"];
//	[_model.currentNodeGroup removeObserver:self forKeyPath:@"childContainer.nodesInside.array"];
}

- (void)testWhatHappensWhenSelectionChanges {

	// will trigger currentNode changed notification that the filter signs us up for
	[TestUtilities addSomeDefaultItemsToModel: _model];

	// - root
	// --- star1
	// --- audio1
	// --- node1
	// --- --- star2
	// --- --- audio2
	// --- --- node2

	[_scene addObserver:self forKeyPath:@"currentFilteredContentSelectionIndexes" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"StarSceneTests"];

	[_model changeNodeSelectionTo:[NSIndexSet indexSet]];

	[[self class] resetObservers];
	[_model changeNodeSelectionTo:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)]];
	STAssertTrue([changeIndexes count]==2, @"doh - %i", [changeIndexes count]);

	[[self class] resetObservers];
	[_model changeNodeSelectionTo:[NSIndexSet indexSet]];
	STAssertTrue([changeIndexes count]==0, @"doh %i", [changeIndexes count]);

	
	// -- old manual way of selection notifications
	// [_registeredObserver nodeProxy:value changedSelectionTo:values byDeselecting:indexesOfItemsToDeselect andSelecting:indexesOfItemsToSelect];
	
	//-- passes more info than any way i can configure the notifications
	[[self class] resetObservers];
	[_model changeNodeSelectionTo:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)]];
	STAssertTrue([changeIndexes count]==1, @"doh %i", [changeIndexes count]);
	STAssertTrue(_selectionChangedNotifications==1, @"boo");
	
	[_scene removeObserver:self forKeyPath:@"currentFilteredContentSelectionIndexes"];
}

- (void)testSelectItemAtIndex {
	// - (void)selectItemAtIndex:(NSUInteger)ind
	
	Star *star1=[Star makeChildWithName:@"star1"], *star2=[Star makeChildWithName:@"star2"], *star3=[Star makeChildWithName:@"star3"];
	SKTAudio *audio1 = [SKTAudio makeChildWithName:@"audio1"];
	SHNode *node1 = [SHNode makeChildWithName:@"node1"];
	[node1 addChild:star2 undoManager:nil];
	[_model NEW_addChild:star1 toNode:_model.rootNodeGroup atIndex:0];
	[_model NEW_addChild:audio1 toNode:_model.rootNodeGroup atIndex:1];
	[_model NEW_addChild:node1 toNode:_model.rootNodeGroup atIndex:2];
	[_model NEW_addChild:star3 toNode:_model.rootNodeGroup atIndex:3];
	
	NSMutableIndexSet *newSelection = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0,4)];
	[newSelection removeIndex:1];	// audio
	[newSelection removeIndex:2];	// node
	[_model.rootNodeGroup setSelectedNodesInsideIndexes:newSelection];
	
	[_scene selectItemAtIndex:1];		// node
	STAssertTrue( [[_scene currentFilteredContentSelectionIndexes] count]==3, @"Err %i", [[_scene currentFilteredContentSelectionIndexes] count]);
	STAssertTrue( [[_scene currentFilteredContentSelectionIndexes] firstIndex]==0, @"Err %i", [[_scene currentFilteredContentSelectionIndexes] firstIndex]);
	STAssertTrue( [[_scene currentFilteredContentSelectionIndexes] lastIndex]==2, @"Err %i", [[_scene currentFilteredContentSelectionIndexes] lastIndex]);
	
	NSArray *selectedItems = [_scene selectedItems];
	// note that selectedItems is unsorted
	STAssertTrue( [selectedItems count]==3, @"Err %i", [selectedItems count]);
	STAssertTrue( [[selectedItems objectAtIndex:0] originalNode]==star1, @"Err");
	STAssertTrue( [[selectedItems objectAtIndex:1] originalNode]==node1, @"Err %@", [[[[selectedItems objectAtIndex:1] originalNode] name] value]);
	STAssertTrue( [[selectedItems objectAtIndex:2] originalNode]==star3, @"Err %@", [[[[selectedItems objectAtIndex:2] originalNode] name] value]);
}

- (void)testDeselectItemAtIndex {
	// - (void)deselectItemAtIndex:(NSUInteger)ind
	
	Star *star1=[Star makeChildWithName:@"star1"], *star2=[Star makeChildWithName:@"star2"], *star3=[Star makeChildWithName:@"star3"];
	SKTAudio *audio1 = [SKTAudio makeChildWithName:@"audio1"];
	SHNode *node1 = [SHNode makeChildWithName:@"node1"];
	[node1 addChild:star2 undoManager:nil];
	[_model NEW_addChild:star1 toNode:_model.rootNodeGroup atIndex:0];
	[_model NEW_addChild:audio1 toNode:_model.rootNodeGroup atIndex:1];
	[_model NEW_addChild:node1 toNode:_model.rootNodeGroup atIndex:2];
	[_model NEW_addChild:star3 toNode:_model.rootNodeGroup atIndex:3];
	
	NSMutableIndexSet *newSelection = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0,4)];
	[newSelection removeIndex:1];		// audio
	[newSelection removeIndex:2];		// node
	[_model.rootNodeGroup setSelectedNodesInsideIndexes:newSelection];
	
	[_scene deselectItemAtIndex:2];
	STAssertTrue( [[_scene currentFilteredContentSelectionIndexes] count]==1, @"Err %i", [[_scene currentFilteredContentSelectionIndexes] count]);
	STAssertTrue( [[_scene currentFilteredContentSelectionIndexes] firstIndex]==0, @"Err %i", [[_scene currentFilteredContentSelectionIndexes] firstIndex]);
	
	NSArray *selectedItems = [_scene selectedItems];
	STAssertTrue( [selectedItems count]==1, @"Err %i", [selectedItems count]);
	STAssertTrue( [[selectedItems objectAtIndex:0] originalNode]==star1, @"Err");
}

- (void)testThatSceneWorks {
	
	[TestUtilities addSomeDefaultItemsToModel: _model];
	
	NSArray *stars = _scene.stars;
	STAssertTrue( [stars count]==2, @"haven't filtered stars correctly %i", [stars count] );
	
	//	-- test when we set a new model
	SHNodeGraphModel *model2 = [SHNodeGraphModel makeEmptyModel];
	[TestUtilities addSomeDefaultItemsToModel: model2];
	_scene.model = nil;
	_scene.model = model2;
	NSArray *stars2 = _scene.stars;
	STAssertTrue( [stars2 count]==2, @"haven't filtered stars correctly %i", [stars2 count] );
	
	Star *star1Ref = (Star *)((NodeProxy *)([stars2 objectAtIndex:0])).originalNode;
	// SHNode *node1Ref = (SHNode *)((NodeProxy *)([stars2 objectAtIndex:1])).originalNode;
	
	// check that star1 is observed properly
//june09	NSMutableArray *dirtyRectObservers1 = star1Ref->dirtyRectObservers;
//june09	STAssertNotNil( dirtyRectObservers1, @"eh?");
//june09	STAssertTrue( [dirtyRectObservers1 count]==1 , @"haven't filtered stars correctly %i", [dirtyRectObservers1 count] );
//june09	STAssertTrue( [dirtyRectObservers1 objectAtIndex:0]==_scene , @"haven't filtered stars correctly %i", [dirtyRectObservers1 count] );
	
	// check that star2 is observed properly
	NodeProxy *node1Proxy = (NodeProxy *)([stars2 objectAtIndex:1]);
	NSMutableArray *stars3 = node1Proxy.filteredContent;
	STAssertTrue( [stars3 count]==2, @"haven't filtered child stars correctly %i", [stars3 count] );
	
	Star *star2Ref = (Star *)((NodeProxy *)([stars3 objectAtIndex:0])).originalNode;
	SHNode *node2Ref = (SHNode *)((NodeProxy *)([stars3 objectAtIndex:1])).originalNode;
	
	// check that node2's children were observed correctly
//june09	NSMutableArray *dirtyRectObservers2 = star2Ref->dirtyRectObservers;
//june09	STAssertNotNil( dirtyRectObservers2, @"eh?");
//june09	STAssertTrue( [dirtyRectObservers2 count]==1 , @"haven't filtered child stars correctly %i", [dirtyRectObservers2 count] );
//june09	STAssertTrue( [dirtyRectObservers2 objectAtIndex:0]==_scene , @"haven't child filtered stars correctly %i", [dirtyRectObservers2 count] );
	
	NodeProxy *node2Proxy = (NodeProxy *)([stars3 objectAtIndex:1]);
	NSMutableArray *stars4 = node2Proxy.filteredContent;
	STAssertTrue( [stars4 count]==0, @"haven't filtered child stars correctly %i", [stars4 count] );
	
	// -- check that we are observing an inserted chid graphic
	Star *star3 = [Star makeChildWithName:@"star3"];
	[model2 setCurrentNodeGroup: node2Ref];
	[node2Ref addChild:star3 undoManager:nil];
	NSMutableArray *stars5 = node2Proxy.filteredContent;
	STAssertTrue( [stars5 count]==1, @"haven't filtered child stars correctly %i", [stars5 count] );
	
	Star *star3Ref = (Star *)((NodeProxy *)([stars5 objectAtIndex:0])).originalNode;
//june09	NSMutableArray *dirtyRectObservers3 = star3Ref->dirtyRectObservers;
//june09	STAssertNotNil( dirtyRectObservers3, @"eh?");
//june09	STAssertTrue( [dirtyRectObservers3 count]==1 , @"haven't filtered child stars correctly %i", [dirtyRectObservers3 count] );
//june09	STAssertTrue( [dirtyRectObservers3 objectAtIndex:0]==_scene , @"haven't child filtered stars correctly %i", [dirtyRectObservers3 count] );
	
	// clean
	_scene.model = nil;
	_scene.model = _model;
}

- (void)testNotificationsWhenCurrentNodeChanges {
	
	/* add some stuff to model root */
	Star *star1=[Star makeChildWithName:@"star1"], *star2=[Star makeChildWithName:@"star2"], *star3=[Star makeChildWithName:@"star3"];
	SKTAudio *audio1 = [SKTAudio makeChildWithName:@"audio1"];
	SHNode *node1 = [SHNode makeChildWithName:@"node1"];
	[node1 addChild:star2 undoManager:nil];
	[_model NEW_addChild:star1 toNode:_model.rootNodeGroup atIndex:0];
	[_model NEW_addChild:audio1 toNode:_model.rootNodeGroup atIndex:1];
	[_model NEW_addChild:node1 toNode:_model.rootNodeGroup atIndex:2];
	[_model NEW_addChild:star3 toNode:_model.rootNodeGroup atIndex:3];
	
	[_scene addObserver:self forKeyPath:@"currentFilteredContentSelectionIndexes" options:(NSKeyValueObservingOptionNew) context: @"StarSceneTests"];
	[_scene addObserver:self forKeyPath:@"currentFilteredContent" options:(NSKeyValueObservingOptionNew) context: @"StarSceneTests"];
//june09	[_scene addObserver:self forKeyPath:@"selectedItemIndexes" options:(NSKeyValueObservingOptionNew) context: @"StarSceneTests"];
//june09	[_scene addObserver:self forKeyPath:@"selectedItems" options:(NSKeyValueObservingOptionNew) context: @"StarSceneTests"];
	[[self class] resetObservers];
	
	[_model setCurrentNodeGroup:node1];
	STAssertTrue(_currentFilteredContentChanges==1, @"eh? %i", _currentFilteredContentChanges);
	STAssertTrue(_currentFilteredContentSelectionIndexes==1, @"eh? %i", _currentFilteredContentSelectionIndexes);
	//	STAssertTrue(_selectedItemIndexesChanges==1, @"eh? %i", _selectedItemIndexesChanges);
	//	STAssertTrue(_selectedItemsChanges==1, @"eh? %i", _selectedItemsChanges);
	
	[_scene removeObserver:self forKeyPath:@"currentFilteredContent"];
	[_scene removeObserver:self forKeyPath:@"currentFilteredContentSelectionIndexes"];
//june09	[_scene removeObserver:self forKeyPath:@"selectedItemIndexes"];
//june09	[_scene removeObserver:self forKeyPath:@"selectedItems"];
}

- (void)testCurrentFilteredContentSelectionIndexes {
	// - (NSIndexSet *)currentFilteredContentSelectionIndexes
	
	Star *star1=[Star makeChildWithName:@"star1"], *star2=[Star makeChildWithName:@"star2"], *star3=[Star makeChildWithName:@"star3"];
	SKTAudio *audio1 = [SKTAudio makeChildWithName:@"audio1"];
	SHNode *node1 = [SHNode makeChildWithName:@"node1"];
	[node1 addChild:star2 undoManager:nil];
	[_model NEW_addChild:star1 toNode:_model.rootNodeGroup atIndex:0];
	[_model NEW_addChild:audio1 toNode:_model.rootNodeGroup atIndex:1];
	[_model NEW_addChild:node1 toNode:_model.rootNodeGroup atIndex:2];
	[_model NEW_addChild:star3 toNode:_model.rootNodeGroup atIndex:3];
	
	NSMutableIndexSet *newSelection = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0,4)];
	[newSelection removeIndex:1]; // audio
	[newSelection removeIndex:2]; // node
	[_model.rootNodeGroup setSelectedNodesInsideIndexes:newSelection];
	
	STAssertTrue( [[_scene currentFilteredContentSelectionIndexes] count]==2, @"Err %i", [[_scene currentFilteredContentSelectionIndexes] count]);
	STAssertTrue( [[_scene currentFilteredContentSelectionIndexes] firstIndex]==0, @"Err %i", [[_scene currentFilteredContentSelectionIndexes] firstIndex]);
	STAssertTrue( [[_scene currentFilteredContentSelectionIndexes] lastIndex]==2, @"Err %i", [[_scene currentFilteredContentSelectionIndexes] lastIndex]);
	
	NSArray *selectedItems = [_scene selectedItems];
	STAssertTrue( [selectedItems count]==2, @"Err %i", [selectedItems count]);
	STAssertTrue( [[selectedItems objectAtIndex:0] originalNode]==star1, @"Err");
	STAssertTrue( [[selectedItems objectAtIndex:1] originalNode]==star3, @"Err");
}

- (void)testCurrentFilteredContent {
	// - (NSArray *)currentFilteredContent
	
	Star *star1=[Star makeChildWithName:@"star1"], *star2=[Star makeChildWithName:@"star2"], *star3=[Star makeChildWithName:@"star3"];
	SKTAudio *audio1 = [SKTAudio makeChildWithName:@"audio1"];
	SHNode *node1 = [SHNode makeChildWithName:@"node1"];
	[node1 addChild:star2 undoManager:nil];
	[_model NEW_addChild:star1 toNode:_model.rootNodeGroup atIndex:0];
	[_model NEW_addChild:audio1 toNode:_model.rootNodeGroup atIndex:1];
	[_model NEW_addChild:node1 toNode:_model.rootNodeGroup atIndex:2];
	[_model NEW_addChild:star3 toNode:_model.rootNodeGroup atIndex:3];	
	
	STAssertTrue( [[_scene currentFilteredContent] count]==3, @"Err %i", [[_scene currentFilteredContent] count]);
	STAssertTrue( [(NodeProxy *)([[_scene currentFilteredContent] objectAtIndex:0]) originalNode]==star1, @"Err");
	STAssertTrue( [(NodeProxy *)([[_scene currentFilteredContent] objectAtIndex:1]) originalNode]==node1, @"Err");
	STAssertTrue( [(NodeProxy *)([[_scene currentFilteredContent] objectAtIndex:2]) originalNode]==star3, @"Err");
}

- (void)testTemp_proxyChangedContent {
	// - (void)temp_proxy:(NodeProxy *)value changedContent:(NSArray *)values;
	
//	STAssertTrue(NO,@"fail");
}

- (void)testAutomaticallyNotifiesObserversForKey {
	//+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key

	STAssertThrows( [StarScene automaticallyNotifiesObserversForKey:@"randomKey"], @"doh" );
	
	STAssertFalse( [StarScene automaticallyNotifiesObserversForKey:@"currentProxy"], @"doh" );
	STAssertFalse( [StarScene automaticallyNotifiesObserversForKey:@"currentFilteredContent"], @"doh" );
	STAssertFalse( [StarScene automaticallyNotifiesObserversForKey:@"currentFilteredContentSelectionIndexes"], @"doh" );
}

- (void)testObserveValueForKeyPathOfObjectChangeContext {
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(NSObject *)observedObject change:(NSDictionary *)change context:(void *)vcontext
	
	STAssertThrows([_scene observeValueForKeyPath:nil ofObject:nil change:nil context:@"StarScene"], @"bugger");
	
	NSDictionary *changeDict1 = [NSDictionary dictionaryWithObjectsAndKeys:
								[NSNumber numberWithInt:NSKeyValueChangeSetting], NSKeyValueChangeKindKey, 
								nil];
	
	STAssertNoThrow([_scene observeValueForKeyPath:@"currentNodeProxy" ofObject:nil change:changeDict1 context:@"StarScene"], @"bugger");
	
	
	NSDictionary *changeDict2 = [NSDictionary dictionaryWithObjectsAndKeys:
								[NSNumber numberWithInt:NSKeyValueChangeReplacement], NSKeyValueChangeKindKey, 
								nil];
	
	STAssertThrows([_scene observeValueForKeyPath:@"currentNodeProxy" ofObject:nil change:changeDict2 context:@"StarScene"], @"bugger");
	STAssertThrows([_scene observeValueForKeyPath:@"rabbit" ofObject:nil change:changeDict2 context:@"StarScene"], @"bugger");
}

- (void)testTemp_proxyWillChangeContentAtIndexes {
	// - (void)temp_proxy:(NodeProxy *)proxy willChangeContent:(NSArray *)values atIndexes:(NSIndexSet *)indexes
	//- (void)temp_proxy:(NodeProxy *)proxy didChangeContent:(NSArray *)values atIndexes:(NSIndexSet *)indexes

	[_scene addObserver:self forKeyPath:@"currentFilteredContent" options:0 context:@"StarSceneTests"];

	OCMockObject *mockProxy = [OCMockObject mockForClass:[NodeProxy class]];
	[[self class] resetObservers];

	[_scene temp_proxy:(id)mockProxy willChangeContent:[NSArray arrayWithObject:[NSNull null]] atIndexes:[NSIndexSet indexSetWithIndex:0]];
	[_scene temp_proxy:(id)mockProxy didChangeContent:[NSArray arrayWithObject:[NSNull null]] atIndexes:[NSIndexSet indexSetWithIndex:0]];
	
	STAssertTrue( _currentFilteredContentChanges==1, @"doh");
	
	[_scene removeObserver:self forKeyPath:@"currentFilteredContent"];
}

- (void)testSomeAcessorCrap {
	
	STAssertTrue([_scene rootProxy]!=nil, @"hmm");
	STAssertTrue([_scene model]==_model, @"hmm");
	STAssertTrue([_scene filter]!=nil, @"hmm");
	STAssertThrows([_scene setCurrentFilteredContent:nil], @"not valid");
}

@end

