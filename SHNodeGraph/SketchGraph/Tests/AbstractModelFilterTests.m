//
//  AbstractModelFilterTests.m
//  SHNodeGraph
//
//  Created by steve hooley on 01/10/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "AbtractModelFilter.h"
#import "SHNodeGraphModel.h"
#import "SHNode.h"
#import "MockProducer.h"
#import "NodeProxy.h"

@interface AbstractModelFilterTests : SenTestCase {
	
	AbtractModelFilter *_filter;
}

@end


@implementation AbstractModelFilterTests

- (void)setUp {
	_filter = [[AbtractModelFilter alloc] init];
}

- (void)tearDown {
	[_filter cleanUpFilter];
	[_filter release];
}

- (void)testObservationCntx {
//+ (NSString *)observationCntx
	
	id mockModel = [OCMockObject mockForClass:[SHNodeGraphModel class]];
	[[mockModel stub] addObserver:_filter forKeyPath:@"currentNodeGroup" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionPrior) context:[OCMArg anyPointer]];
	[[mockModel stub] removeObserver:_filter forKeyPath:@"currentNodeGroup" ];
	id mockRootNode = [OCMockObject mockForClass:[SHNode class]];
	[[[mockModel stub] andReturn:mockRootNode] rootNodeGroup];
	[[[mockModel stub] andReturn:mockRootNode] currentNodeGroup];
	[[[mockRootNode stub] andReturnBOOLValue:YES] allowsSubpatches];

	[_filter setModel:mockModel]; // auto starts observing
	
	STAssertThrows([AbtractModelFilter observationCntx], @"This is supposed to be an abstract class");
}

- (void)testModelKeyPathsToObserve {
//+ (NSArray *)modelKeyPathsToObserve
	
	id mockModel = [OCMockObject mockForClass:[SHNodeGraphModel class]];
	[[mockModel stub] addObserver:_filter forKeyPath:@"currentNodeGroup" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionPrior) context:[OCMArg anyPointer]];
	[[mockModel stub] removeObserver:_filter forKeyPath:@"currentNodeGroup" ];
	id mockRootNode = [OCMockObject mockForClass:[SHNode class]];
	[[[mockModel stub] andReturn:mockRootNode] rootNodeGroup];
	[[[mockModel stub] andReturn:mockRootNode] currentNodeGroup];
	[[[mockRootNode stub] andReturnBOOLValue:YES] allowsSubpatches];

	[_filter setModel:mockModel]; // auto starts observing

	STAssertNil([AbtractModelFilter modelKeyPathsToObserve], @"This is supposed to be an abstract class");
}

/* When the model changes, what would you like to get called? */
- (void)testSelectorForChangedKeyPath {
//+ (SEL)selectorForChangedKeyPath:(NSString *)keyPath

	id mockModel = [OCMockObject mockForClass:[SHNodeGraphModel class]];
	[[mockModel stub] addObserver:_filter forKeyPath:@"currentNodeGroup" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionPrior) context:[OCMArg anyPointer]];
	[[mockModel stub] removeObserver:_filter forKeyPath:@"currentNodeGroup" ];
	id mockRootNode = [OCMockObject mockForClass:[SHNode class]];
	[[[mockModel stub] andReturn:mockRootNode] rootNodeGroup];
	[[[mockModel stub] andReturn:mockRootNode] currentNodeGroup];
	BOOL returnValue = YES;
	[[[mockRootNode stub] andReturnValue:OCMOCK_VALUE(returnValue)] allowsSubpatches];
	[_filter setModel:mockModel]; // auto starts observing
	
	STAssertThrows([AbtractModelFilter selectorForChangedKeyPath:@"chump"], @"This is supposed to be an abstract class");
}

- (void)testSelectorForInsertedKeyPath {
//+ (SEL)selectorForInsertedKeyPath:(NSString *)keyPath

	id mockModel = [OCMockObject mockForClass:[SHNodeGraphModel class]];
	[[mockModel stub] addObserver:_filter forKeyPath:@"currentNodeGroup" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionPrior) context:[OCMArg anyPointer]];
	[[mockModel stub] removeObserver:_filter forKeyPath:@"currentNodeGroup" ];
	id mockRootNode = [OCMockObject mockForClass:[SHNode class]];
	[[[mockModel stub] andReturn:mockRootNode] rootNodeGroup];
	[[[mockModel stub] andReturn:mockRootNode] currentNodeGroup];
	BOOL returnValue = YES;
	[[[mockRootNode stub] andReturnValue:OCMOCK_VALUE(returnValue)] allowsSubpatches];
	[_filter setModel:mockModel]; // auto starts observing
	
	STAssertThrows([AbtractModelFilter selectorForInsertedKeyPath:@"chump"], @"This is supposed to be an abstract class");
}

- (void)testSelectorForReplacedKeyPath {
//+ (SEL)selectorForReplacedKeyPath:(NSString *)keyPath

	id mockModel = [OCMockObject mockForClass:[SHNodeGraphModel class]];
	[[mockModel stub] addObserver:_filter forKeyPath:@"currentNodeGroup" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionPrior) context:[OCMArg anyPointer]];
	[[mockModel stub] removeObserver:_filter forKeyPath:@"currentNodeGroup" ];
	id mockRootNode = [OCMockObject mockForClass:[SHNode class]];
	[[[mockModel stub] andReturn:mockRootNode] rootNodeGroup];
	[[[mockModel stub] andReturn:mockRootNode] currentNodeGroup];
	BOOL returnValue = YES;
	[[[mockRootNode stub] andReturnValue:OCMOCK_VALUE(returnValue)] allowsSubpatches];
	[_filter setModel:mockModel]; // auto starts observing

	STAssertThrows([AbtractModelFilter selectorForReplacedKeyPath:@"chump"], @"This is supposed to be an abstract class");
}

- (void)testSelectorForRemovedKeyPath {
//+ (SEL)selectorForRemovedKeyPath:(NSString *)keyPath

	id mockModel = [OCMockObject mockForClass:[SHNodeGraphModel class]];
	[[mockModel stub] addObserver:_filter forKeyPath:@"currentNodeGroup" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionPrior) context:[OCMArg anyPointer]];
	[[mockModel stub] removeObserver:_filter forKeyPath:@"currentNodeGroup" ];
	id mockRootNode = [OCMockObject mockForClass:[SHNode class]];
	[[[mockModel stub] andReturn:mockRootNode] rootNodeGroup];
	[[[mockModel stub] andReturn:mockRootNode] currentNodeGroup];
	BOOL returnValue = YES;
	[[[mockRootNode stub] andReturnValue:OCMOCK_VALUE(returnValue)] allowsSubpatches];
	[_filter setModel:mockModel]; // auto starts observing
	
	STAssertThrows([AbtractModelFilter selectorForRemovedKeyPath:@"chump"], @"This is supposed to be an abstract class");
}

#pragma mark init methods

//- (id)init
//- (void)dealloc

#pragma mark action methods
//- (void)setOptions:(NSDictionary *)opts
//- (void)cleanUpFilter

- (void)testRegisterAsUser {
	//- (void)registerAUser:(id<SHContentProviderUserProtocol>)user
	//- (void)unRegisterAUser:(id<SHContentProviderUserProtocol>)user
	//- (BOOL)hasUsers

	id mockUser = [OCMockObject mockForProtocol:@protocol(SHContentProviderUserProtocol)];
	[[mockUser expect] setFilter:_filter];

	STAssertFalse([_filter hasUsers], @"doh!");
	[_filter registerAUser:mockUser];
	STAssertTrue([_filter hasUsers], @"doh!");
	[mockUser verify];

	id mockModel = [OCMockObject mockForClass:[SHNodeGraphModel class]];
	id mockRootNode = [OCMockObject mockForClass:[SHNode class]];
	[[[mockModel expect] andReturn:mockRootNode] rootNodeGroup];
	[[[mockModel expect] andReturn:mockRootNode] currentNodeGroup];
	[[mockModel expect] addObserver:_filter forKeyPath:@"currentNodeGroup" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionPrior) context:[OCMArg anyPointer]]; // Are these options needed? ( | NSKeyValueObservingOptionOld )
	// This will be called in clean up
	[[mockModel stub] removeObserver:_filter forKeyPath:@"currentNodeGroup" ];
	
	BOOL returnValue = YES;
	[[[mockRootNode stub] andReturnValue:OCMOCK_VALUE(returnValue)] allowsSubpatches];
	
	[_filter setModel:mockModel]; // auto starts observing
	STAssertTrue(_filter.model==mockModel, @"have we gone spaz?");
	
	[mockModel verify];
	
	[[mockUser expect] setFilter:nil];
	[_filter unRegisterAUser:mockUser];
	[mockUser verify];
	STAssertFalse([_filter hasUsers], @"doh!");
}


- (void)testSetModel {
//- (void)setModel:(SHNodeGraphModel *)value

	SHNodeGraphModel *model = [SHNodeGraphModel makeEmptyModel];
	
	/* lets begin with some content in the model to verify it picks it up */
	SHNode *ng1 = [SHNode makeChildWithName:@"ng1"];
	MockProducer *graphic1 = [MockProducer makeChildWithName:@"grap1"];
	[ng1 addChild:graphic1 undoManager:nil];
	[model NEW_addChild:ng1 toNode:model.rootNodeGroup atIndex:0];
	model.currentNodeGroup = ng1;
	 
    [_filter setModel:model];
	
	NodeProxy *currentProxy = _filter.currentNodeProxy;
	STAssertNotNil(currentProxy, @"must have a current node");
	STAssertTrue([currentProxy originalNode]==ng1, @"yay! %@", [currentProxy originalNode]);

	// check the initial proxy tree
	STAssertTrue( [_filter.rootNodeProxy.filteredContent count]==1, @"%i", [_filter.rootNodeProxy.filteredContent count] );
	NodeProxy *child1 = [_filter.rootNodeProxy.filteredContent objectAtIndex:0];
	STAssertTrue( child1.originalNode == ng1, @"should be %@", child1.originalNode.name );
	STAssertTrue( [child1.filteredContent count]==1, @"%i", [child1.filteredContent count] );
	NodeProxy *child2_1 = [child1.filteredContent objectAtIndex:0];
	STAssertTrue( child2_1.originalNode == graphic1, @"should be");
	
	// check that we are not observing root
	// and that we are observing current as per V2 (V1 was where we observed everything)
	STAssertFalse(_filter.rootNodeProxy.isObservingChildren, @"bah");
	STAssertTrue(currentProxy.isObservingChildren, @"bah");
}


//- (void)startObservingModel
//- (void)stopObservingModel

//- (BOOL)objectPassesFilter:(id)value

#pragma mark notification methods
/* Observe changes to the models contents and selection */
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(NSObject *)observedObject change:(NSDictionary *)change context:(void *)vcontext

/* These seem untestable */
//- (void)testSelectorForwardingThings {
//- (void)modelObject:(NodeProxy *)proxy inserted:(id)newValue atIndexes:(NSIndexSet *)changeIndexes forKeyPath:(NSString *)keyPath
//- (void)modelObject:(NodeProxy *)proxy inserted:(id)newValue atIndexes:(NSIndexSet *)changeIndexes forKeyPath:(NSString *)keyPath
//- (void)modelObject:(NodeProxy *)proxy replaced:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes forKeyPath:(NSString *)keyPath
//- (void)modelObject:(NodeProxy *)proxy removed:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes forKeyPath:(NSString *)keyPath	
//}

- (void)testNodeProxyForNode {
	// - (NodeProxy *)nodeProxyForNode:(id)value

	SHNodeGraphModel *model = [SHNodeGraphModel makeEmptyModel];
	
	/* lets begin with some content in the model to verify it picks it up */
	SHNode *ng1 = [SHNode makeChildWithName:@"ng1"];
	MockProducer *graphic1 = [MockProducer makeChildWithName:@"grap1"];
	[ng1 addChild:graphic1 undoManager:nil];
	[model NEW_addChild:ng1 toNode:model.rootNodeGroup atIndex:0];
	model.currentNodeGroup = ng1;
	
    [_filter setModel:model];
	
	NodeProxy *currentProxy = _filter.currentNodeProxy;
	NodeProxy *graphic1Proxy = [_filter nodeProxyForNode:graphic1];
	STAssertNotNil(graphic1Proxy, @"hmm");
	STAssertTrue(graphic1Proxy.originalNode==graphic1, @"hmm");
}

- (void)testSetCurrentNodeProxy {
	// - (void)setCurrentNodeProxy:(NodeProxy *)nodeProxy

	SHNodeGraphModel *model = [SHNodeGraphModel makeEmptyModel];
	
	/* lets begin with some content in the model to verify it picks it up */
	SHNode *ng1 = [SHNode makeChildWithName:@"ng1"];
	MockProducer *graphic1 = [MockProducer makeChildWithName:@"grap1"];
	[ng1 addChild:graphic1 undoManager:nil];
	[model NEW_addChild:ng1 toNode:model.rootNodeGroup atIndex:0];
	model.currentNodeGroup = ng1;
	
    [_filter setModel:model];
	
	NodeProxy *rootProxy = _filter.rootNodeProxy;
	NodeProxy *ng1Proxy = [_filter nodeProxyForNode:ng1];
	NodeProxy *graphic1Proxy = [_filter nodeProxyForNode:graphic1];
	
	STAssertTrue(_filter.currentNodeProxy==ng1Proxy, @"oops");
	STAssertFalse(rootProxy.isObservingChildren, @"oops");
	STAssertTrue(ng1Proxy.isObservingChildren, @"oops");
	STAssertFalse(graphic1Proxy.isObservingChildren, @"oops");

	[_filter setCurrentNodeProxy:graphic1Proxy];

	STAssertTrue(_filter.currentNodeProxy==graphic1Proxy, @"oops");
	STAssertFalse(rootProxy.isObservingChildren, @"oops");
	STAssertFalse(ng1Proxy.isObservingChildren, @"oops");
	STAssertFalse(graphic1Proxy.isObservingChildren, @"oops"); // graphic cant have children so not observing it
}
	
@end
