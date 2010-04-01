//
//  SelectingSceneManipulationTests.m
//  DebugDrawing
//
//  Created by steve hooley on 07/08/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "SelectingSceneManipulation.h"
#import "StarScene.h"

@interface SelectingSceneManipulationTests : SenTestCase {
	
	OCMockObject *_mockScene;
	SelectingSceneManipulation *_sceneManipulation;
}

@end

@implementation SelectingSceneManipulationTests

- (void)setUp {

	_mockScene = [[OCMockObject mockForClass:[StarScene class]] retain];
	_sceneManipulation = [[SelectingSceneManipulation alloc] initWithScene:(id)_mockScene];
}

- (void)tearDown {
	
	[_sceneManipulation release];
	[_mockScene release];
}

- (void)testToggleSelectionOfItemShouldModifyCurrent {
	// - (void)toggleSelectionOfItem:(NodeProxy *)proxyItem shouldModifyCurrent:(BOOL)modifyCurrentSelection
	
	Class testClass = [Graphic class];
	OCMockObject *mockNode = [OCMockObject mockForClass:testClass];
	OCMockObject *mockProxy = [OCMockObject mockForClass:[NodeProxy class]];
	[[[mockProxy expect] andReturn:mockNode] originalNode];

	NSUInteger expectedIndex=3;
	[[[_mockScene expect] andReturnValue:OCMOCK_VALUE(expectedIndex)] indexOfOriginalObjectIdenticalTo:mockNode];
	[[[_mockScene stub] andReturn:[NSArray arrayWithObject:mockProxy]] currentFilteredContent];
	[[[_mockScene expect] andReturn:[NSIndexSet indexSet]] currentFilteredContentSelectionIndexes];
	
	[[_mockScene expect] selectItemAtIndex:3];

	[_sceneManipulation toggleSelectionOfItem:(id)mockProxy shouldModifyCurrent:YES];
	
	[_mockScene verify];
}

- (void)testClearSelection {
	// - (void)clearSelection

	[[_mockScene expect] setCurrentFilteredContentSelectionIndexes:[NSIndexSet indexSet]];

	[_sceneManipulation clearSelection];
	[_mockScene verify];
}

- (void)testModifyInitialSelectionWithMarqueedIndexes {
	//- (void)modifyInitialSelection:(NSIndexSet *)initialSelection withMarqueedIndexes:(NSIndexSet *)indexesOfGraphicsInRubberBand;
	
	NSMutableIndexSet *initalSelection = [NSMutableIndexSet indexSetWithIndex:0];
	NSMutableIndexSet *marqueedSelection = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0,2)];
	
	[[_mockScene expect] setCurrentFilteredContentSelectionIndexes:[NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0,2)]];

	[_sceneManipulation modifyInitialSelection:initalSelection withMarqueedIndexes:marqueedSelection];
	
	[_mockScene verify];
}


@end
