// we need to add a forward reference for SHParentLikeProtocol
@protocol SHParentLikeProtocol, ChildAndParentProtocol, GraphLikeProtocol;
@class SH_Path, NodeName, SHOrderedDictionary;
@class SHChild;

// any object that adopts this protocol must also adopt NSObject.
// This is useful, we could define a new protocol like @protocol aNewProt <SHNodeLikeProtocol, SHParentLikeProtocol>
// And any object that adopted aNewProt must also conform to SHNodeLikeProtocol & SHParentLikeProtocol
#pragma mark -
#pragma mark SHNodeLikeProtocol
@protocol SHNodeLikeProtocol <NSObject>

- (BOOL)isEquivalentTo:(id)anObject;

#pragma mark notification methods
- (void)hasBeenAddedToParentSHNode;
- (BOOL)isNodeParentOfMe:(NSObject<SHParentLikeProtocol> *)aNode; 

#pragma mark accessor methods
- (BOOL)changeNameWithStringTo:(NSString *)aNameStr fromParent:(NSObject<SHParentLikeProtocol> *)parent undoManager:(NSUndoManager *)um;
- (BOOL)changeNameTo:(NodeName *)aName fromParent:(NSObject<SHParentLikeProtocol> *)parent undoManager:(NSUndoManager *)um;

- (NodeName *)name;
- (BOOL)operatorPrivateMember;
- (void)setOperatorPrivateMember:(BOOL)value;
- (NSObject<ChildAndParentProtocol> *)parentSHNode;
- (void)setParentSHNode:(NSObject<ChildAndParentProtocol> *)value;
@end


#pragma mark -
#pragma mark SHParentLikeProtocol
@protocol SHParentLikeProtocol <NSObject>

- (void)deleteChild:(SHChild *)child undoManager:(NSUndoManager *)um;
- (void)deleteInterconnectors:(NSArray *)ics undoManager:(NSUndoManager *)um;

- (NSObject<GraphLikeProtocol> *)nodeGraphModel;
- (SHChild *)rootNode;

- (BOOL)isNameUsedByChild:(NSString *)aName;
- (SHChild<SHNodeLikeProtocol> *)childWithKey:(NSString *)aName;

- (int)indexOfChild:(id)child; // may return NSNotFound
- (BOOL)isChild:(id)value;

- (BOOL)isLeaf;

- (SHOrderedDictionary *)nodesInside;
- (SHOrderedDictionary *)inputs;
- (SHOrderedDictionary *)outputs;
- (SHOrderedDictionary *)shInterConnectorsInside;

- (SH_Path *)relativePathToChild:(NSObject<SHNodeLikeProtocol> *)aNode;
- (NSArray *)indexPathToNode:(NSObject<SHNodeLikeProtocol> *)aNode;
- (NSObject<SHNodeLikeProtocol> *)objectForIndexString:(NSString *)value;

- (void)setIndexOfChild:(id)child to:(NSUInteger)index undoManager:(NSUndoManager *)um;

// Make a new protocol using our new skills
// - (void)_changeNameOfChild:(SHChild *)child to:(NSString *)value;

@end


/* Use this one for objects that are both SHParentLikeProtocol && SHNodeLikeProtocol */
#pragma mark -
#pragma mark ChildAndParentProtocol
@protocol ChildAndParentProtocol <SHParentLikeProtocol, SHNodeLikeProtocol>

@end

#pragma mark -
#pragma mark SHInputLikeProtocol
@protocol SHInputLikeProtocol <SHNodeLikeProtocol>

@end

#pragma mark -
#pragma mark SHOutputLikeProtocol
@protocol SHOutputLikeProtocol <SHNodeLikeProtocol>

@end

#pragma mark -
#pragma mark GraphLikeProtocol
@protocol GraphLikeProtocol <NSObject>
- (NSObject<SHParentLikeProtocol> *)currentNodeGroup;
@end
