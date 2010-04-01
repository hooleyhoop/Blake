//
//  HighLevelBlakeDocumentActions.h
//  Pharm
//
//  Created by Steven Hooley on 26/07/2007.
//  Copyright 2007 HooleyHoop. All rights reserved.
//

#import "BlakeDocument.h"

@class SHNode, SHProtoAttribute, SHInputAttribute, SHOutputAttribute, SH_Path;

/*
 *
*/
@interface BlakeDocument (HighLevelSketchDocumentActions)

@end

/*
 *
*/
@interface BlakeDocument (HighLevelBlakeDocumentActions) 

#pragma mark -
#pragma mark User Interface methods

- (SHNode *)makeEmptyGroupInCurrentNodeWithName:(NSString *)name;
//nov09- (SHNode *)makeEmptyGroupInNode:(SHNode *)parentNode withName:(NSString *)name;

- (SHInputAttribute *)makeInputInCurrentNodeWithType:(NSString *)type;
- (SHOutputAttribute *)makeOutputInCurrentNodeWithType:(NSString *)type;

- (void)connectOutletOfInput:(SHProtoAttribute *)att1 toInletOfOutput:(SHProtoAttribute *)att2;
- (void)connectOutletOfInputAtPath:(SH_Path *)att1 toInletOfOutputAtPath:(SH_Path *)att2;

- (void)addChildrenToCurrentNode:(NSArray *)arrayValue;
- (void)addChildren:(NSArray *)arrayValue toNode_NOT_CURRENT:(SHNode *)node;
- (void)addChildren:(NSArray *)arrayValue toNode:(SHNode *)node;
- (void)addChildren:(NSArray *)arrayValue toNode:(SHNode *)node atIndexes:(NSArray *)positions;

- (void)deleteChildrenFromCurrentNode:(NSArray *)arrayValue;
- (void)deleteChildren:(NSArray *)arrayValue fromNode:(SHNode *)node;

- (void)deleteInterConnectors:(NSArray *)ics  fromNode:(NSObject<ChildAndParentProtocol> *)node;

- (void)deleteSelectedChildrenFromCurrentNode;
- (void)deleteSelectedChildrenFromNode:(SHNode *)node;

- (void)addChildrenToSelection:(NSArray *)childrenToSelect inNode:(SHNode *)theParentNode;
- (void)removeChildrenFromSelection:(NSArray *)childrenToDeSelect inNode:(SHNode *)theParentNode;

/* Hmmmm, are the selecting methods going to be undoable? I think they may have to be to ensure state doesnt get fucked up */
- (void)selectAllChildrenInCurrentNode;
- (void)selectAllChildrenInNode:(SHNode *)node;

/* may have to rename this later when i find out ho the tableView handles it (we want to get the table view to use the undoable versions) */
- (void)addChildToSelectionInCurrentNode:(id)child;

- (void)deSelectAllChildrenInCurrentNode;
- (void)deSelectAllChildrenInNode:(SHNode *)node;

- (void)moveDownAlevelIntoSelectedNodeGroup;

- (void)addContentsOfFile:(NSString *)filePath toNode:(SHNode *)node atIndex:(int)index;

- (void)add:(int)amountToMove toIndexOfChild:(id)aChild;

//- (BOOL)canMoveDownAlevelIntoSelectedNodeGroup;
//- (BOOL)canMoveUpAlevelToParentNodeGroup;

- (void)groupChildren:(NSArray *)someChildren;
- (void)unGroupNode:(SHNode *)aNodeGroup;

// table drag help
- (void)moveChildren:(NSArray *)obsToDrag toInsertionIndex:(NSUInteger)row shouldCopy:(BOOL)copyFlag;

@end
