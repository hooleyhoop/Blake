//
//  SHParent_Selection.h
//  SHNodeGraph
//
//  Created by steve hooley on 27/02/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "SHParent.h"

@interface SHParent (SHParent_Selection)

- (void)clearSelectionNoUndo;

- (void)setSelectedChildren:(NSArray *)children;
- (NSArray *)selectedChildren;
- (BOOL)hasSelection;

- (void)addChildToSelection:(id)child;

#pragma mark adding methods
- (void)addNodesToSelection:(NSSet *)values;
- (void)addInputsToSelection:(NSSet *)values;
- (void)addOutputsToSelection:(NSSet *)values;
- (void)addICsToSelection:(NSSet *)values;

#pragma mark removing methods
- (void)removeNodesFromSelection:(NSSet *)values;
- (void)removeInputsFromSelection:(NSSet *)values;
- (void)removeOutputsFromSelection:(NSSet *)values;
- (void)removeICsFromSelection:(NSSet *)values;

- (void)removeChildFromSelection:(id)child;
- (void)selectAllChildren;
- (void)unSelectAllChildren;

- (void)unSelectAllChildNodes;
- (void)unSelectAllChildInputs;
- (void)unSelectAllChildOutputs;
- (void)unSelectAllChildInterConnectors;

- (NSArray *)selectedChildNodes;
- (NSArray *)selectedChildInputs;
- (NSArray *)selectedChildOutputs;
- (NSArray *)selectedChildInterConnectors;

- (NSMutableIndexSet *)selectedNodesInsideIndexes;
- (NSMutableIndexSet *)selectedInputIndexes;
- (NSMutableIndexSet *)selectedOutputIndexes;
- (NSMutableIndexSet *)selectedInterConnectorIndexes;

- (void)setSelectedNodesInsideIndexes:(NSMutableIndexSet *)value;		/* This will auto-update selection bindings */
- (void)setSelectedInputIndexes:(NSMutableIndexSet *)value;				/* This will auto-update selection bindings */
- (void)setSelectedOutputIndexes:(NSMutableIndexSet *)value;			/* This will auto-update selection bindings */
- (void)setSelectedInterConnectorIndexes:(NSMutableIndexSet *)value;	/* This will auto-update selection bindings */

@end
