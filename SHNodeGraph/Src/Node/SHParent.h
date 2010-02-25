//
//  SHParent.h
//  SHNodeGraph
//
//  Created by steve hooley on 25/02/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "SHChild.h"
#import "SHNodeLikeProtocol.h"

@class SHChildContainer, SHProtoAttribute, SHInterConnector, SH_Path;

@interface SHParent : SHChild <ChildAndParentProtocol, NSCoding, NSCopying> {

	@public
	SHChildContainer *_childContainer;
	
	// This is temporarily set between -willRemove and -didRemove
	NSSet *_otherNodesAffectedByRemove;
}

#pragma mark Class Methods
+ (NSSet *)childrenBelongingToParent:(NSObject<ChildAndParentProtocol> *)parent fromSet:(NSSet *)children;

#pragma mark add methods
/* These add and set the parent and are undoable. They Don't check for connections etc. */
- (void)addChild:(SHChild *)object atIndex:(NSInteger)index undoManager:(NSUndoManager *)um;
- (void)addItemsOfSingleType:(NSArray *)objects atIndexes:(NSIndexSet *)indexes undoManager:(NSUndoManager *)um;

// bear in mind that outAttr isn't nesarily an SHOutputAttribute or inAttr an SHInputAttribute
- (void)_makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)outAttr andInletOfAtt:(SHProtoAttribute *)inAttr undoManager:(NSUndoManager *)um;
- (BOOL)_validParentForConnectionBetweenOutletOf:(SHProtoAttribute *)outAttr andInletOfAtt:(SHProtoAttribute *)inAttr;

#pragma mark delete methods
/* Use these to delete items - is undoable and will unset parent and remove interconnectors */
- (void)deleteChild:(SHChild *)child undoManager:(NSUndoManager *)um;
- (void)deleteChildren:(NSArray *)childrenToDelete undoManager:(NSUndoManager *)um;

/* These seems to assume that interconnectors have been removed - dont use directly - use nodegraphmodel methods */
- (void)deleteNodes:(NSArray *)nodes undoManager:(NSUndoManager *)um;
- (void)deleteInputs:(NSArray *)inputs undoManager:(NSUndoManager *)um;
- (void)deleteOutputs:(NSArray *)outputs undoManager:(NSUndoManager *)um;
- (void)deleteInterconnectors:(NSArray *)ics undoManager:(NSUndoManager *)um;

#pragma mark - other methods
- (BOOL)checkItemsAreValidChildren:(NSArray *)objects;

/* These will be called when we add objects - dont use directly */
- (void)_makeParentOfObjects:(NSArray *)values undoManager:(NSUndoManager *)theUmm;
- (void)_undoSetParentOfObjects:(NSArray *)values undoManager:(NSUndoManager *)theUmm;

- (void)_makeParentOfObject:(SHChild *)value undoManager:(NSUndoManager *)theUmm;
- (void)_undoSetParentOfObject:(SHChild *)value undoManager:(NSUndoManager *)theUmm;

// Private - before the nodes are added the names will be to changed to names that dont clash. The names are returned in an array
- (NSArray *)_prepareObjectsNamesForAdding:(NSArray *)objects withUndoManager:(NSUndoManager *)um;

- (unsigned int)countOfChildren;

// returns [aNode, parent, parent ] upto but not including self
- (NSArray *)reverseNodeChainToNode:(NSObject<SHNodeLikeProtocol> *)aNode;

- (SH_Path *)relativePathToChild:(NSObject<SHNodeLikeProtocol> *)aNode;
- (NSObject<SHNodeLikeProtocol> *)childAtRelativePath:(SH_Path *)relativeChildPath;

- (NSArray *)indexPathToNode:(NSObject<SHNodeLikeProtocol> *)aNode;
- (NSObject<SHNodeLikeProtocol> *)objectForIndexPathToNode:(NSArray *)value;
- (NSObject<SHNodeLikeProtocol> *)objectForIndexString:(NSString *)value; // recipricol of above

- (NSUInteger)indexOfChild:(id)child;
- (void)setIndexOfChild:(id)child to:(NSUInteger)index undoManager:(NSUndoManager *)um;
// TableDrop thing
- (void)moveChildren:(NSArray *)children toInsertionIndex:(NSUInteger)value undoManager:(NSUndoManager *)um;
	
- (SHChild *)nodeAtIndex:(NSUInteger)index;
- (SHChild *)connectorAtIndex:(NSUInteger)index;
- (SHChild *)inputAtIndex:(NSUInteger)index;
- (SHChild *)outputAtIndex:(NSUInteger)index;

- (BOOL)isNameUsedByChild:(NSString *)aName;
- (SHChild<SHNodeLikeProtocol> *)childWithKey:(NSString *)aName;
- (BOOL)isChild:(id)value;
- (BOOL)isLeaf;
- (SHOrderedDictionary *)nodesInside;
- (SHOrderedDictionary *)inputs;
- (SHOrderedDictionary *)outputs;
- (SHOrderedDictionary *)shInterConnectorsInside;

- (NSSet *)otherNodesAffectedByRemove;

@end
