//
//  NodeProxy.h
//  SHNodeGraph
//
//  Created by steve hooley on 02/10/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

@class AbtractModelFilter, SHNode, SHChild;


@interface NodeProxy : _ROOT_OBJECT_ {

	AbtractModelFilter		*_filter;
	SHNode					*_originalNode;
	NSMutableArray			*_filteredContent;
	NSMutableIndexSet		*_indexesOfFilteredContent;
	
	/* NB. These are the indexes pertaining to _filteredContent, not the original node.nodesInside */
	NSMutableIndexSet		*_filteredContentSelectionIndexes;

	BOOL					_isObservingChildren;
	NSUInteger				_debug_selectionNotificationsReceivedCount, _debug_arrayNotificationsReceivedCount;
	
	// lazily update children
	BOOL					_filteredTreeNeedsMaking;
}

@property (retain, readwrite, nonatomic) NSMutableArray		*filteredContent;
@property (retain, readwrite, nonatomic) NSMutableIndexSet	*indexesOfFilteredContent;
@property (retain, readwrite, nonatomic) NSMutableIndexSet	*filteredContentSelectionIndexes;

// careful, have written a custom accessor for this 
@property (assign, readwrite, nonatomic) SHNode				*originalNode;

@property (assign, readonly, nonatomic) BOOL				isObservingChildren;
@property (nonatomic) BOOL									filteredTreeNeedsMaking;

@property (readonly, nonatomic) NSUInteger debug_selectionNotificationsReceivedCount, debug_arrayNotificationsReceivedCount;

+ (id)makeNodeProxyWithFilter:(AbtractModelFilter *)filter;
+ (id)makeNodeProxyWithFilter:(AbtractModelFilter *)filter object:(SHChild *)value;

- (id)initWithFilter:(AbtractModelFilter *)filter;

- (void)startObservingOriginalNode;
- (void)stopObservingOriginalNode;

- (void)setUpObservationOf:(id)objectToObserve withObserver:(id)observer forKeyPath:(NSString *)kp;
- (void)takeDownObservationOf:(id)objectToObserve withObserver:(id)observer forKeyPath:(NSString *)kp;

// hmm dont know why we need this to stop compiler warning
- (id)forwardingTargetForSelector:(SEL)sel;

// nodes
- (void)addIndexesToIndexesOfFilteredContent:(NSIndexSet *)value;
- (void)insertFilteredContent:(NSArray *)graphics atIndexes:(NSIndexSet *)indexes;
- (void)removeIndexesFromIndexesOfFilteredContent:(NSIndexSet *)value;
- (void)removeFilteredContentAtIndexes:(NSIndexSet *)indexes;

// indexed accessors
- (NSMutableArray *)filteredContent;
- (NSUInteger)countOfFilteredContent;
- (id)objectInFilteredContentAtIndex:(NSUInteger)theIndex;
- (id)objectsInFilteredContentAtIndexes:(NSIndexSet *)theIndexes;
- (void)getFilteredContent:(id *)objsPtr range:(NSRange)range;
- (void)insertObject:(id)obj inFilteredContentAtIndex:(NSUInteger)theIndex;

// selection
- (void)removeIndexesFromSelection:(id)value;
- (void)addIndexesToSelection:(NSIndexSet *)value;

- (NSUInteger)indexOfOriginalObjectIdenticalTo:(id)value;

- (BOOL)hasChildren;

- (NodeProxy *)nodeProxyForNode:(id)value;
- (BOOL)containsObjectIdenticalTo:(NodeProxy *)value;

- (void)changeSelectionIndexes:(NSIndexSet *)indexes;

- (NSString *)debugNameString;
- (NodeName *)name;

@end
