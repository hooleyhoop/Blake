//
//  SHNodeSelectingMethods.h
//  SHNodeGraph
//
//  Created by Steve Hooley on 01/06/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import "SHNode.h"

/*
 *
*/
@interface SHNode (SHNodeSelectingMethods)

#pragma mark -
#pragma mark SUPER *NEW* action methods

#pragma mark action methods


- (void)addChildrenToSelection:(NSArray *)children;
- (void)removeChildrenFromSelection:(NSArray *)children;

//- (void)toggleSelectedOfChild:(id)child;



//nov09- (void)deleteSelectedChildren;
//- (void)deleteSelectedInterConnectors;

//- (void)moveSelectedChildrenUpInExecutionOrder;
//- (void)moveSelectedChildrenDownInExecutionOrder;


#pragma mark accessor methods
//- (BOOL)selectedFlag;
//- (void)setSelectedFlag:(BOOL)aFlag;
//
//- (NSMutableIndexSet *)selectedNodeAndAttributeIndexes;
//- (void)setSelectedNodeAndAttributeIndexes:(NSMutableIndexSet*)value; /* This will auto-update selection bindings */



//nov09- (NSMutableIndexSet *)allChildrenSelectedIndexes;
//nov09- (void)setAllChildrenSelectedIndexes:(NSMutableIndexSet *)value;

//- (NSMutableArray *)selectedChildNodesAndAttributes;
//- (void)setSelectedChildNodesAndAttributes:(NSMutableArray *)value;



#pragma mark notification methods

//- (void)postSHSelectedChildrenChanged_Notification:(id)aNode;

@end
