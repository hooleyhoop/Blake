//
//  SHChildContainer_Selection.h
//  SHNodeGraph
//
//  Created by steve hooley on 27/02/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "SHChildContainer.h"

@interface SHChildContainer (SHChildContainer_Selection)

- (void)clearSelectionNoUndo;
- (BOOL)hasSelection;

- (void)setSelectedNodes:(NSArray *)nodesSet;
- (void)setSelectedInputs:(NSArray *)inputsSet;
- (void)setSelectedOutputs:(NSArray *)outputsSet;
- (void)setSelectedInterconnectors:(NSArray *)icSet;

- (NSArray *)selectedChildren;

- (void)addChildToSelection:(id)child;

- (void)selectAllChildren;
//- (void)_setSelectionForStorage:(SHOrderedDictionary *)targetStorage newSelection:(NSMutableIndexSet *)value;

- (void)unSelectAllChildNodes;
- (void)unSelectAllChildInputs;
- (void)unSelectAllChildOutputs;
- (void)unSelectAllChildInterConnectors;

- (void)setSelectedNodesInsideIndexes:(NSMutableIndexSet *)value;
- (void)setSelectedInputIndexes:(NSMutableIndexSet *)value;
- (void)setSelectedOutputIndexes:(NSMutableIndexSet *)value;
- (void)setSelectedInterConnectorIndexes:(NSMutableIndexSet *)value;

@end
