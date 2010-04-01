//
//  AbtractModelFilter.h
//  BlakeLoader
//
//  Created by steve hooley on 01/06/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "SHContentProvidorProtocol.h"

@class NodeProxy;

/* 
	Observes the rootNode and currentNode of a model.
	In your concerte subclass of AbtractModelFilter you define +modelKeyPathsToObserve and you will then have an
	NodeProxy for the rootNode that observes these properties for you.
 
	There are two ways to do this:-
 
	V1 is to keep a proxy tree that mirrors the graph. ie each proxy is observing the content of it's node.
	The beauty of this is that the proxy tree is always upto date. A graphic could be added three nodes down
	And drawing would still work.
 
	The thing is.. do we need this?
	We could only observe changes to the current node. However - if someone added a graphic three nodes down
	the proxy tree would be irrevocably out of sync. Therefore we must enforce model-wide that changes can
	only be made to the current node. - Is this a bad thing?
 
	What worries me is that whilst the second option seems more sensible, the first option is simple and working fine
	and the second option could just be an optimization that we dont really need? and that adds unnecessary constraints.
 
 
 */
@interface AbtractModelFilter : _ROOT_OBJECT_ <SHContentProvidorProtocol> {

	@public
    SHNodeGraphModel    *_model;
    NSMutableArray      *_registeredUsers;
    BOOL                _wasCleaned;
	
	NodeProxy			*_rootNodeProxy, *_currentNodeProxy;
}

@property (assign, readonly, nonatomic) NodeProxy	*rootNodeProxy;
@property (assign, nonatomic) NodeProxy				*currentNodeProxy;
@property (assign, nonatomic) SHNodeGraphModel		*model;
@property (assign, nonatomic) NSMutableArray		*registeredUsers;

+ (NSString *)observationCntx;
+ (NSArray *)modelKeyPathsToObserve;

- (void)setOptions:(NSDictionary *)opts;

/* subclasses specify which selector to call on each corresponding event */
+ (SEL)selectorForWillChangeKeyPath:(NSString *)keyPath;
+ (SEL)selectorForChangedKeyPath:(NSString *)keyPath;

+ (SEL)selectorForWillInsertKeyPath:(NSString *)keyPath;
+ (SEL)selectorForInsertedKeyPath:(NSString *)keyPath;

+ (SEL)selectorForWillReplaceKeyPath:(NSString *)keyPath;
+ (SEL)selectorForReplacedKeyPath:(NSString *)keyPath;

+ (SEL)selectorForWillRemoveKeyPath:(NSString *)keyPath;
+ (SEL)selectorForRemovedKeyPath:(NSString *)keyPath;

- (void)cleanUpFilter;

- (void)registerAUser:(id<SHContentProviderUserProtocol>)user;
- (void)unRegisterAUser:(id<SHContentProviderUserProtocol>)user;

- (void)startObservingModel;
- (void)stopObservingModel;

- (void)willBeginMultipleEdit;
- (void)didEndMultipleEdit;

// V2 method to add all children
- (void)makeFilteredTreeUpToDate:(NodeProxy *)value;

- (BOOL)objectPassesFilter:(id)value;

- (void)modelObject:(NodeProxy *)proxy willChangeTo:(id)newValue from:(id)oldValue forKeyPath:(NSString *)keyPath;
- (void)modelObject:(NodeProxy *)proxy changedTo:(id)newValue from:(id)oldValue forKeyPath:(NSString *)keyPath;

- (void)modelObject:(NodeProxy *)proxy willInsert:(id)newValue atIndexes:(NSIndexSet *)changeIndexes forKeyPath:(NSString *)keyPath;
- (void)modelObject:(NodeProxy *)proxy inserted:(id)newValue atIndexes:(NSIndexSet *)changeIndexes forKeyPath:(NSString *)keyPath;

- (void)modelObject:(NodeProxy *)proxy willReplace:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes forKeyPath:(NSString *)keyPath;
- (void)modelObject:(NodeProxy *)proxy replaced:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes forKeyPath:(NSString *)keyPath;

- (void)modelObject:(NodeProxy *)proxy willRemove:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes forKeyPath:(NSString *)keyPath;
- (void)modelObject:(NodeProxy *)proxy removed:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes forKeyPath:(NSString *)keyPath;

- (BOOL)hasUsers;

- (NodeProxy *)nodeProxyForNode:(id)value;

@end