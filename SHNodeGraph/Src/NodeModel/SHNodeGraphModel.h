//
//  SHNodeGraphModel.h
//  SHNodeGraph
//
//  Created by Steve Hooley on 09/05/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import <ProtoNodeGraph/SHNodeLikeProtocol.h>

@class SHNode, SHInterConnector, SHProtoAttribute;
@protocol SHContentProviderUserProtocol, NodeGraphLoaderProtocol;

//!Alert-putback!@class SHNodeGraphScheduler;
//!Alert-putback!@class SKTGraphic, SHContentProviderUserProtocol;

/*
 *
*/
@interface SHNodeGraphModel : _ROOT_OBJECT_ <GraphLikeProtocol> {

	SHNode			*_rootNodeGroup;	
	SHNode			*_currentNodeGroup;
	NSUndoManager	*_undoManager;
	
//!Alert-putback!	SHNodeGraphScheduler			*_scheduler;
	
	// lets not get into this now
	NSObject<NodeGraphLoaderProtocol>		*_savingAndLoadingDelegate;
	
	
	NSMutableArray	*_contentFilters;
	
	/* Temp Debug Drawing Project stuff */
	id _graphUpdatedCallBackObject;
	SEL _graphUpdatedCallBackSEL;
	IMP _graphUpdatedCallBackMethod;
	/* Temp Debug Drawing Project stuff */

}

@property (retain, readwrite, nonatomic) SHNode *rootNodeGroup;
@property (assign, readwrite, nonatomic) SHNode *currentNodeGroup;
@property (readonly, nonatomic) NSUndoManager *undoManager;

@property (readonly, nonatomic) NSMutableArray *contentFilters;
//!Alert-putback!@property (retain, readwrite, nonatomic) id savingAndLoadingDelegate;
//!Alert-putback!@property (retain, readwrite, nonatomic) SHNodeGraphScheduler *scheduler;

#pragma mark -
#pragma mark class methods
+ (id)makeEmptyModel;
+ (BOOL)isValidCurrentNode:(id)value;

#pragma mark init methods
- (id)initEmptyModel;

#pragma mark Filter Methods
- (void)registerContentFilter:(Class)filterClass andUser:(id <SHContentProviderUserProtocol>)user options:(NSDictionary *)optValues;
- (void)unregisterContentFilter:(Class)filterClass andUser:(id <SHContentProviderUserProtocol>)user options:(NSDictionary *)optValues;


- (void)willBeginMultipleEdit;
- (void)didEndMultipleEdit;
	
#pragma mark SUPER *NEW* action methods
//NotReady- (void)NEW_addChildren:graphics toNode:_rootNodeGroup atIndexes:indexes;
- (void)NEW_addChild:(id)newchild atIndex:(NSInteger)nindex;

/* OOps - badly named 
	At the moment you cannot do more than one operation in one cycle. ie add some nodes and remove some inputs
	As this will fuck up the filters - ie if notifications are attached. We need a better way to coalesce ntifications
 */
- (void)insertGraphics:(NSArray *)graphics atIndexes:(NSIndexSet *)indexes;
- (void)removeGraphicsAtIndexes:(NSIndexSet *)indexes;
- (void)removeGraphicAtIndex:(NSUInteger)gindex;

- (void)NEW_addChild:(id)newchild toNode:(SHNode *)targetNode atIndex:(NSInteger)nindex; // index might be NSNotFound
- (void)NEW_addChild:(id)newchild toNode:(SHNode *)targetNode;

//TODO: didn't we used to have a way to connect multiple attributes in 1 go?
- (SHInterConnector *)connectOutletOfAttribute:(SHProtoAttribute *)att1 toInletOfAttribute:(SHProtoAttribute *)att2;

// New, stricter
- (void)addChildrenToCurrentSelection:(NSArray *)arrayValue;
- (void)removeChildrenFromCurrentSelection:(NSArray *)arrayValue;
//!These dont look right- (void)addChildrenToSelection:(NSArray *)arrayValue inNode:(SHNode *)node;
//!These don't look right- (void)removeChildrenFromSelection:(NSArray *)arrayValue inNode:(SHNode *)node;
- (void)deleteChildren:(NSArray *)arrayValue fromNode:(SHNode *)targetNode;

//!Alert-putback!- (BOOL)isEquivalentTo:(SHNodeGraphModel *)value;


/* For reordering childnodes */
- (void)add:(NSInteger)amountToMove toIndexOfChild:(id)aChild;
- (void)moveChildren:(NSArray *)children toInsertionIndex:(NSUInteger)value;


- (void)changeNodeSelectionTo:(NSIndexSet *)value;

#pragma mark action methods
- (SHNode *)makeEmptyNodeInCurrentNodeWithName:(NSString *)aName;
//!Alert-putback!- (SHNode *)makeEmptyNodeInNode:(SHNode *)aNodegroup withName:(NSString *)aName;

- (void)moveUpAlevelToParentNodeGroup;
- (void)moveDownALevelIntoNodeGroup:(SHNode *)aNodeGroup;

// for saving and loading. Uses the current delegate
- (BOOL)saveNode:(SHNode*)aNode toFile:(NSString *)fileName;
- (SHNode *)loadNodeFromFile:(NSString *)fileName;

// for copying to pasteboard. Uses the current delegate
//!Alert-putback!- (NSXMLElement *)fScriptWrapperFromChildren:(NSArray *)childrenToCopy fromNode:(SHNode *)parentNode;
//!Alert-putback!- (BOOL)unArchiveChildrenFromFScriptWrapper:(NSXMLElement *)copiedStuffWrapper intoNode:(SHNode *)parentNode;

#pragma mark accessor methods
- (NSArray *)allChildrenFromCurrentNode;
- (NSArray *)allChildrenFromNode:(SHNode *)aNode;

//!Alert-putback!- (NSArray *)allSelectedChildrenFromNode:(SHNode *)aNode;
- (NSArray *)allSelectedChildrenFromCurrentNode;

- (BOOL)weHaveSelectedNodesOrAttributesOrICs;
- (BOOL)currentNodeGroupIsValid;

// good idea to use NSDocument's undomanager if we are in a document based app
- (void)replaceUndomanager:(NSUndoManager *)value;

@end

