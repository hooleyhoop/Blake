//
//  NodeProxyTests.m
//  SHNodeGraph
//
//  Created by steve hooley on 17/10/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import <SHNodeGraph/NodeClassFilter.h>
#import <SHNodeGraph/SHNodeGraph.h>
#import <ProtoNodeGraph/SHParent_Selection.h>

#import "StubFilterUser.h"
#import "NodeProxy.h"
#import "MockProducer.h"
#import "MockConsumer.h"

@interface NodeProxyTests : SenTestCase {
	
    SHNodeGraphModel		*_model;
	NodeClassFilter			*_graphicsProvider;
}

@end


@implementation NodeProxyTests

- (void)setUp {
    
	_model = [[SHNodeGraphModel makeEmptyModel] retain];
    
	_graphicsProvider = [[NodeClassFilter alloc] init];
    [_graphicsProvider setClassFilter:@"MockProducer"];
    [_graphicsProvider setModel:_model];
}

- (void)tearDown {
    
	[_graphicsProvider cleanUpFilter];	
	[_graphicsProvider release];
	[_model release];
}


// ng1 ¬
//	-- audio1
//	-- graphic1
//	-- ng2 ¬	
//		-- audio2
//		-- ng3
//	-- graphic2
- (void)testNodeProxyForNode {
	// - (NodeProxy *)nodeProxyForNode:(id)value;
    
	SHNode *ng1 = [[SHNode new] autorelease], *ng2 = [[SHNode new] autorelease], *ng3 = [[SHNode new] autorelease];
    MockProducer *graphic1 = [[MockProducer new] autorelease], *graphic2 = [[MockProducer new] autorelease];
    MockConsumer *audio1 = [[MockConsumer new] autorelease], *audio2 = [[MockConsumer new] autorelease];
    [ng1 addChild:audio1 undoManager:nil];
    [ng1 addChild:graphic1 undoManager:nil];
    [ng2 addChild:audio2 undoManager:nil];
    [ng2 addChild:ng3 undoManager:nil];
    [ng1 addChild:ng2 undoManager:nil];
    [ng1 addChild:graphic2 undoManager:nil];
	[_model NEW_addChild:ng1 toNode:_model.rootNodeGroup atIndex:0];
    
	NodeProxy *rootProxy = [_graphicsProvider rootNodeProxy];
    
	NodeProxy *ng1P = [rootProxy nodeProxyForNode:ng1];
	NodeProxy *ng2P = [rootProxy nodeProxyForNode:ng2];
	NodeProxy *ng3P = [rootProxy nodeProxyForNode:ng3];
    
	STAssertNotNil(ng1P, @"eh?");
	STAssertNotNil(ng2P, @"eh?");
	STAssertNotNil(ng3P, @"eh?");
    
	NodeProxy *graphic1P = [rootProxy nodeProxyForNode:graphic1];
	NodeProxy *graphic2P = [rootProxy nodeProxyForNode:graphic2];
    
	STAssertNotNil(graphic1P, @"eh?");
	STAssertNotNil(graphic2P, @"eh?");
	
	STAssertNil([rootProxy nodeProxyForNode:audio1], @"eh?");
	STAssertNil([rootProxy nodeProxyForNode:audio2], @"eh?");
	
	STAssertTrue( [rootProxy containsObjectIdenticalTo:ng1P], @"Must do");
	STAssertTrue( [rootProxy containsObjectIdenticalTo:ng2P], @"Must do");
	STAssertTrue( [rootProxy containsObjectIdenticalTo:ng3P], @"Must do");
    
	STAssertTrue( [rootProxy containsObjectIdenticalTo:graphic1P], @"Must do");
	STAssertTrue( [rootProxy containsObjectIdenticalTo:graphic2P], @"Must do");
}

// ng1 ¬
//	-- audio1
//	-- graphic1
//	-- ng2 ¬	
//		-- audio2
//		-- ng3
//	-- graphic2
- (void)testChangeSelectionIndexes {
    // - (void)changeSelectionIndexes:(NSIndexSet *)indexes

	SHNode *ng1 = [[SHNode new] autorelease], *ng2 = [[SHNode new] autorelease], *ng3 = [[SHNode new] autorelease];
    MockProducer *graphic1 = [[MockProducer new] autorelease], *graphic2 = [[MockProducer new] autorelease];
    MockConsumer *audio1 = [[MockConsumer new] autorelease], *audio2 = [[MockConsumer new] autorelease];
    [ng1 addChild:audio1 undoManager:nil];
    [ng1 addChild:graphic1 undoManager:nil];
    [ng2 addChild:audio2 undoManager:nil];
    [ng2 addChild:ng3 undoManager:nil];
    [ng1 addChild:ng2 undoManager:nil];
    [ng1 addChild:graphic2 undoManager:nil];
	[_model NEW_addChild:ng1 toNode:_model.rootNodeGroup atIndex:0];
    
	NodeProxy *rootProxy = [_graphicsProvider rootNodeProxy];
	NodeProxy *ng1P = [rootProxy nodeProxyForNode:ng1];

    NSMutableIndexSet *newIndexes = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0,3)];
    [newIndexes removeIndex:1];
    [ng1P changeSelectionIndexes:newIndexes];
    
    NSArray *modelSelection = [ng1 selectedChildNodes];
    STAssertTrue([modelSelection count]==2, @"yay %i", [modelSelection count]);
    STAssertTrue([modelSelection containsObjectIdenticalTo:graphic1], @"yay");
    STAssertTrue([modelSelection containsObjectIdenticalTo:graphic2], @"yay");
}

- (void)testDebugNameString {
	// - (NSString *)debugNameString;

	NodeProxy *rootProxy = [_graphicsProvider rootNodeProxy];
	STAssertTrue([[rootProxy debugNameString] isEqualToString:@"SHNode - root"], @"doh %@", [rootProxy debugNameString]);
}

- (void)testInit {
	STAssertThrows([[[NodeProxy alloc] init] autorelease], @"doh");
}

- (void)testForwardingTargetForSelector {
// - (id)forwardingTargetForSelector:(SEL)sel

	NodeProxy *rootProxy = [_graphicsProvider rootNodeProxy];
	id targetForSel = [rootProxy forwardingTargetForSelector:@selector(swineFlu)];
	STAssertNotNil(targetForSel, @"doh");
	STAssertEqualObjects(_model.rootNodeGroup, targetForSel, @"aye");
}

// test that we receive a notification that thigs have changed
- (void)testAddIndexesToSelection {
	//- (void)addIndexesToSelection:(NSIndexSet *)value
	
	SHNode *ng1 = [[SHNode new] autorelease], *ng2 = [[SHNode new] autorelease], *ng3 = [[SHNode new] autorelease];
    MockProducer *graphic1 = [[MockProducer new] autorelease], *graphic2 = [[MockProducer new] autorelease];
    MockConsumer *audio1 = [[MockConsumer new] autorelease], *audio2 = [[MockConsumer new] autorelease];
    [ng1 addChild:audio1 undoManager:nil];
    [ng1 addChild:graphic1 undoManager:nil];
    [ng2 addChild:audio2 undoManager:nil];
    [ng2 addChild:ng3 undoManager:nil];
    [ng1 addChild:ng2 undoManager:nil];
    [ng1 addChild:graphic2 undoManager:nil];
	_model.currentNodeGroup = _model.rootNodeGroup;
	[_model NEW_addChild:ng1 toNode:_model.rootNodeGroup atIndex:0];
    
	NodeProxy *rootProxy = [_graphicsProvider rootNodeProxy];
	NodeProxy *ng1P = [rootProxy nodeProxyForNode:ng1];
	
    NSMutableIndexSet *newIndexes = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0,1)];
    [newIndexes removeIndex:1];
	_model.currentNodeGroup = ng1;
    [ng1P changeSelectionIndexes:newIndexes];
    [ng1P addIndexesToSelection:[NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(1,2)]];

	STAssertTrue( [ng1P.filteredContentSelectionIndexes count]==3, @"doh");
}

- (void)testAddObserverForKeyPathOptionsContext {
	// - (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
	
	// should we be able to bind to NodeProxy content? it used to raise an exception - now i think we MUST. What was the exception for?
//	STAssertThrows([[_graphicsProvider rootNodeProxy] addObserver:self forKeyPath:@"filteredContent" options:0 context:NULL], @"not valid");
	STAssertThrows([[_graphicsProvider rootNodeProxy] addObserver:self forKeyPath:@"chicken" options:0 context:NULL], @"not valid");
}

- (void)testHAsChildren {
//	- (BOOL)hasChildren

	_model.currentNodeGroup = _model.rootNodeGroup;
	NodeProxy *rootProxy = [_graphicsProvider rootNodeProxy];
	STAssertFalse([rootProxy hasChildren], @"no way");

	SHNode *ng1 = [[SHNode new] autorelease];
	[_model NEW_addChild:ng1 toNode:_model.rootNodeGroup atIndex:0];
	NodeProxy *ng1P = [rootProxy nodeProxyForNode:ng1];
	STAssertTrue([rootProxy hasChildren], @"no way");
	STAssertFalse([ng1P hasChildren], @"no way");
}

- (void)testCountOfFilteredContent {
//- (NSUInteger)countOfFilteredContent

	_model.currentNodeGroup = _model.rootNodeGroup;
	NodeProxy *rootProxy = [_graphicsProvider rootNodeProxy];
	STAssertTrue([rootProxy countOfFilteredContent]==0, @"no way");
	
	SHNode *ng1 = [[SHNode new] autorelease];
	[_model NEW_addChild:ng1 toNode:_model.rootNodeGroup atIndex:0];
	NodeProxy *ng1P = [rootProxy nodeProxyForNode:ng1];
	STAssertTrue([rootProxy countOfFilteredContent]==1, @"no way");
}

- (void)testGetFilteredContentRange {
	//- (void)getFilteredContent:(id *)objsPtr range:(NSRange)range
	
	NodeProxy *rootProxy = [_graphicsProvider rootNodeProxy];
	id container;
	STAssertThrows( [rootProxy getFilteredContent:&container range:NSMakeRange(0, 1)], @"heh?");
}

- (void)testInsertObjectInFilteredContentAtIndex {
	// - (void)insertObject:(id)obj inFilteredContentAtIndex:(NSUInteger)theIndex
	
	NodeProxy *rootProxy = [_graphicsProvider rootNodeProxy];
	id newObject;
	STAssertThrows( [rootProxy insertObject:newObject inFilteredContentAtIndex:0], @"heh?");
}

- (void)testObjectsInFilteredContentAtIndexes {
	// - (id)objectsInFilteredContentAtIndexes:(NSIndexSet *)theIndexes
	
	SHNode *ng1 = [[SHNode new] autorelease], *ng2 = [[SHNode new] autorelease], *ng3 = [[SHNode new] autorelease];
    MockProducer *graphic1 = [[MockProducer new] autorelease], *graphic2 = [[MockProducer new] autorelease];
    MockConsumer *audio1 = [[MockConsumer new] autorelease], *audio2 = [[MockConsumer new] autorelease];
    [ng1 addChild:audio1 undoManager:nil];
    [ng1 addChild:graphic1 undoManager:nil];
    [ng2 addChild:audio2 undoManager:nil];
    [ng2 addChild:ng3 undoManager:nil];
    [ng1 addChild:ng2 undoManager:nil];
    [ng1 addChild:graphic2 undoManager:nil];
	_model.currentNodeGroup = _model.rootNodeGroup;
	[_model NEW_addChild:ng1 toNode:_model.rootNodeGroup atIndex:0];
    
	NodeProxy *rootProxy = [_graphicsProvider rootNodeProxy];
	_model.currentNodeGroup = ng1;
	NodeProxy *ng1P = [rootProxy nodeProxyForNode:ng1];
	NSMutableArray *filteredContent = [ng1P filteredContent];
	STAssertTrue([filteredContent count]==3, @"yes it is %i", [filteredContent count]);

	NSArray *returnedContent = [ng1P objectsInFilteredContentAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)]];
	STAssertTrue([returnedContent count]==2, @"oh yeah %i", [returnedContent count]);
	STAssertTrue([[returnedContent objectAtIndex:0] originalNode] ==graphic1, @"hmm");
	STAssertTrue([[returnedContent objectAtIndex:1] originalNode] ==ng2, @"hmm");
}

@end
