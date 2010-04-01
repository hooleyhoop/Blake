//
//  SHChildContainer.h
//  SHNodeGraph
//
//  Created by steve hooley on 25/02/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "SHNodeLikeProtocol.h"

@class SHOrderedDictionary, SHChild, SHInterConnector, SHProtoAttribute;

@interface SHChildContainer : _ROOT_OBJECT_ <NSCoding> {

@public
	SHOrderedDictionary			*_nodesInside;
	SHOrderedDictionary			*_inputs, *_outputs;
	SHOrderedDictionary			*_shInterConnectorsInside;
}

@property(retain, readonly, nonatomic)	SHOrderedDictionary *nodesInside;
@property(retain, readonly, nonatomic)	SHOrderedDictionary *inputs;
@property(retain, readonly, nonatomic)	SHOrderedDictionary *outputs;
@property(retain, readonly, nonatomic)	SHOrderedDictionary *shInterConnectorsInside;

- (id)initWithNodes:(SHOrderedDictionary *)nodes inputs:(SHOrderedDictionary *)inputs outputs:(SHOrderedDictionary *)outputs ics:(SHOrderedDictionary *)ics;

- (BOOL)isEqualToContainer:(SHChildContainer *)value;

#pragma mark With Undo
- (void)_addNode:(SHChild *)value atIndex:(int)ind withKey:(NSString *)key undoManager:(NSUndoManager *)um;
- (void)_addInput:(SHChild *)value atIndex:(int)ind withKey:(NSString *)key undoManager:(NSUndoManager *)um;
- (void)_addOutput:(SHChild *)value atIndex:(int)ind withKey:(NSString *)key undoManager:(NSUndoManager *)um;
- (void)_addInterConnector:(SHInterConnector *)anInterConnector between:(SHProtoAttribute *)outAttr and:(SHProtoAttribute *)inAttr undoManager:(NSUndoManager *)um;

- (void)_removeNode:(SHChild *)value withKey:(NSString *)key undoManager:(NSUndoManager *)um;
- (void)_removeInput:(SHChild *)value withKey:(NSString *)key undoManager:(NSUndoManager *)um;
- (void)_removeOutput:(SHChild *)value withKey:(NSString *)key undoManager:(NSUndoManager *)um;
- (void)_removeInterConnector:(SHInterConnector *)connectorToDelete undoManager:(NSUndoManager *)um;

/* indexes can be nil */
- (void)_addOutputs:(NSArray *)values atIndexes:(NSIndexSet *)indexes withKeys:(NSArray *)keys undoManager:(NSUndoManager *)um;
- (void)_addInputs:(NSArray *)values atIndexes:(NSIndexSet *)indexes withKeys:(NSArray *)keys undoManager:(NSUndoManager *)um;
- (void)_addNodes:(NSArray *)values atIndexes:(NSIndexSet *)indexes withKeys:(NSArray *)keys undoManager:(NSUndoManager *)um;
- (void)_addInterconnectors:(NSArray *)values between:(NSArray *)outAtts and:(NSArray *)inAtts undoManager:(NSUndoManager *)um;

- (void)_removeNodes:(NSArray *)nodes undoManager:(NSUndoManager *)um;
- (void)_removeInputs:(NSArray *)inputs undoManager:(NSUndoManager *)um;
- (void)_removeOutputs:(NSArray *)outputs undoManager:(NSUndoManager *)um;
- (void)_removeInterConnectors:(NSArray *)connectorsToDelete undoManager:(NSUndoManager *)um;

- (BOOL)isChild:(id)value;
- (NSUInteger)indexOfChild:(id)child; // may return NSNotFound

// reordering - 
- (void)setIndexOfChild:(id)child to:(NSUInteger)index undoManager:(NSUndoManager *)um;
// children must be passed in in the correct order - dest index must be valid . ie not a table cell drop destination (which can be 'after' last index)
- (void)moveObjects:(NSArray *)children toIndexes:(NSIndexSet *)indexes undoManager:(NSUndoManager *)um;
// This is the table reordering version
- (void)moveChildren:(NSArray *)children toInsertionIndex:(NSUInteger)index undoManager:(NSUndoManager *)um;


- (SHChild<SHNodeLikeProtocol> *)childWithKey:(NSString *)aName;

- (unsigned int)countOfChildren;
- (BOOL)isEmpty;

- (SHOrderedDictionary *)_targetStorageForObject:(SHChild *)anOb;

- (SHInterConnector *)interConnectorFor:(SHProtoAttribute *)inAtt1 and:(SHProtoAttribute *)inAtt2;

- (SHChild *)nodeAtIndex:(NSUInteger)index;
- (SHChild *)connectorAtIndex:(NSUInteger)index;
- (SHChild *)inputAtIndex:(NSUInteger)index;
- (SHChild *)outputAtIndex:(NSUInteger)index;

@end
