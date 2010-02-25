//
//  SHNode.h
//  SHNodeGraph
//
//  Created by Steve Hooley on 09/05/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//
#import <ProtoNodeGraph/SHParent.h>

@class SHOrderedDictionary;
@class SHAttribute, SHInterConnector, SH_Path, SHCustomMutableArray, SHNodeGraphModel, SHParent;

/*
 *
*/
@interface SHNode : SHParent { //!Alert-putback! <SHNodeLikeProtocol, SHOperatorProtocol> {
	
	CGFloat					_previousFrameKey;
//	BOOL						_enabled;
//	BOOL						_locked;

	BOOL					_allowsSubpatches;
	BOOL					_evaluationInProgress;

	/* Our children. Each SHOrderedDictionary has a selection set */

	SHCustomMutableArray	*_allChildren;
	

//!Alert-putback!	SH_Path						*_absolutePath;
	
//	id							_lastSelectedChild;	// TODO: - No equivalent for interconnector
	//	NSMutableDictionary*	_auxiliaryData;

}

//!Alert-putback!@property(readwrite, nonatomic) BOOL							evaluationInProgress;
@property (readonly, nonatomic) BOOL allowsSubpatches;
//!Alert-putback!@property(assign, readwrite, nonatomic) SH_Path					*absolutePath;
@property (readonly, nonatomic) SHCustomMutableArray *allChildren;

// @property(assign, readwrite, nonatomic) id lastSelectedChild;

#pragma mark -
#pragma mark class methods
+ (void)sortChildrenByType:(NSArray *)children :(NSMutableSet **)nodesSetPtr :(NSMutableSet **)inputsSetPtr :(NSMutableSet **)outputsSetPtr :(NSMutableSet **)icSetPtr;

//!Alert-putback!+ (id)newNode;

#pragma mark init methods
//- (id)init;

#pragma mark NSCopyopying, hash, isEqual
//!Alert-putback!- (id)copyWithZone:(NSZone *)zone;
//!Alert-putback!- (BOOL)isEquivalentTo:(id)anObject;

#pragma mark SUPER *NEW* action methods
//!Alert-putback!- (NSArray *)nodesAndAttributesInside;

/* These inex things are problematic - if you ask for the positions of a node, an index and an output they could all be 0 */
//!Alert-putback!- (NSArray *)positionsOfChildren:(NSArray *)children;

#pragma mark action methods
- (BOOL)addChild:(NSObject<SHNodeLikeProtocol> *)aNode undoManager:(NSUndoManager *)um;
- (BOOL)addChild:(NSObject<SHNodeLikeProtocol> *)aNode autoRename:(BOOL)renameFlag undoManager:(NSUndoManager *)um;
- (BOOL)addChild:(NSObject<SHNodeLikeProtocol> *)aNode atIndex:(NSInteger)ind autoRename:(BOOL)renameFlag undoManager:(NSUndoManager *)um;

//- (void)moveNodeUpInExecutionOrder:(id)aNode;
//- (void)moveNodeDownInExecutionOrder:(id)aNode;

#pragma mark notification methods
// - (void)postSHNodeAdded_Notification:(id)aNode;
// - (void)postSHNodeDeleted_Notification:(id)aNode;
// - (void)postNodeGuiMayNeedRebuilding_Notification;

#pragma mark accessor methods
//!Alert-putback!- (NSString *)nextUniqueChildNameBasedOn:(NSString *)aName;

/* a node, attribute or interconnector */
//!Alert-putback!- (id<SHNodeLikeProtocol>)childWithKey:(NSString *)aName;

//!Alert-putback!- (SH_Path *)absolutePath;
//!Alert-putback!- (void)setAbsolutePath:(SH_Path *)anAbsolutePath;

- (BOOL)dirtyBit;

- (id)childAtIndex:(NSUInteger)index;

- (NSUInteger)depth;

- (NSArray *)nearestChildNodesSupportingProtocol:(Protocol *)value;
- (NSObject<ChildAndParentProtocol> *)nearestParentSupportingProtocol:(Protocol *)value;

@end