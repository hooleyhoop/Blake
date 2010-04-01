//
//  SHChild.h
//  SHNodeGraph
//
//  Created by steve hooley on 22/04/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "SHNodeLikeProtocol.h"

@class SHNode, NodeName;

@interface SHChild : _ROOT_OBJECT_ <NSCoding, NSCopying> {

	@public
	NSObject<GraphLikeProtocol>				*_nodeGraphModel;
	NSObject<ChildAndParentProtocol>		*_parentSHNode;
	NodeName								*_name;
	BOOL									_operatorPrivateMember;
}

@property (readwrite, nonatomic) BOOL operatorPrivateMember;
@property (assign, readwrite, nonatomic) NSObject<ChildAndParentProtocol> *parentSHNode;
@property (assign, readwrite, nonatomic) NSObject<GraphLikeProtocol> *nodeGraphModel;
@property (readonly, nonatomic) NodeName *name;

+ (id)makeChildWithName:(NSString *)nameStr;

- (BOOL)isEquivalentTo:(id)anObject;

- (BOOL)isNodeParentOfMe:(NSObject<SHParentLikeProtocol> *)aNode;

/*	This must only be called from the parent, the parent must check that the name is unique before calling 
	The Parent is responsible for changinging the names in the container
*/
- (BOOL)changeNameWithStringTo:(NSString *)aNameStr fromParent:(NSObject<SHParentLikeProtocol> *)parent undoManager:(NSUndoManager *)um;
- (BOOL)changeNameTo:(NodeName *)aName fromParent:(NSObject<SHParentLikeProtocol> *)parent undoManager:(NSUndoManager *)um;

#pragma mark notification methods
- (void)isAboutToBeDeletedFromParentSHNode;
- (void)hasBeenAddedToParentSHNode;

#pragma mark accessor methods
- (SHChild *)rootNode;

@end
