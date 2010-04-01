//
//  NodeClassFilter.h
//  BlakeLoader
//
//  Created by steve hooley on 09/05/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "SHContentProvidorProtocol.h"
#import "AbtractModelFilter.h"

@class BlakeDocument, SKTGraphic;

@interface NodeClassFilter : AbtractModelFilter <SHContentProvidorProtocol> {

	Class _filterType;
	
@public;
	int _addedObjectCount, _removedObjectCount;
}

//- (NSIndexSet *)allModelSelectionIndexes;
//- (void)changeSelectionIndexes:(NSIndexSet *)indexes;
//- (NSArray *)selectedGraphics;

@property (readonly, nonatomic) Class filterType;

#pragma mark hooley tested methods
- (void)setClassFilter:(NSString *)value;
- (BOOL)objectPassesFilter:(id)value;
- (void)objectsAndIndexesThatPassFilter:(NSArray *)objects :(NSIndexSet *)indexes :(NSMutableArray *)successFullObjects :(NSMutableIndexSet *)successFullIndexes;

/* content */
- (void)modelWillChange:(NodeProxy *)proxy nodesInside_to:(id)newValue from:(id)oldValue;
- (void)modelWillInsert:(NodeProxy *)proxy nodesInside:(id)newValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelWillReplace:(NodeProxy *)proxy nodesInside:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelWillRemove:(NodeProxy *)proxy nodesInside:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes;

- (void)modelChanged:(NodeProxy *)proxy nodesInside_to:(id)newValue from:(id)oldValue;
- (void)modelInserted:(NodeProxy *)proxy nodesInside:(id)newValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelReplaced:(NodeProxy *)proxy nodesInside:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelRemoved:(NodeProxy *)proxy nodesInside:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes;

/* selection */
- (void)modelWillChange:(NodeProxy *)proxy nodesInsideSelection_to:(id)newValue from:(id)oldValue;
- (void)modelWillInsert:(NodeProxy *)proxy nodesInsideSelection:(id)newValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelWillReplace:(NodeProxy *)proxy nodesInsideSelection:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelWillRemove:(NodeProxy *)proxy nodesInsideSelection:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes;

- (void)modelChanged:(NodeProxy *)proxy nodesInsideSelection_to:(id)newValue from:(id)oldValue;
- (void)modelInserted:(NodeProxy *)proxy nodesInsideSelection:(id)newValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelReplaced:(NodeProxy *)proxy nodesInsideSelection:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelRemoved:(NodeProxy *)proxy nodesInsideSelection:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes;

#pragma mark Indexed accessors methods

//
//- (void)removeObjectFromFilteredContentAtIndex:(unsigned)theIndex;
//
//- (void)replaceObjectInFilteredContentAtIndex:(unsigned)theIndex withObject:(id)obj;
//
//- (void)addIndexesToSelection:(NSIndexSet *)value;
//- (void)removeIndexesFromSelection:(id)value;
//
///* New Stuff */
//- (void)addIndexToIndexesOfFilteredContent:(NSUInteger)value;
//- (void)removeIndexFromIndexesOfFilteredContent:(NSUInteger)value;

///* End New Stuff */
//
//- (BOOL)isSelected:(id)value;
//- (void)_syncSelectionIndexes;
//
//- (NSArray *)selectedContent;

@end
