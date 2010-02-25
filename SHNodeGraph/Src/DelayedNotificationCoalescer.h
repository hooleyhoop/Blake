//
//  DelayedNotificationCoalescer.h
//  SHNodeGraph
//
//  Created by steve hooley on 27/08/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//


@class AllChildrenFilter, DelayedNotifier, NodeProxy;
@interface DelayedNotificationCoalescer : _ROOT_OBJECT_ {

	NSString *_mode;

	SEL _callback1, _callback2;
	id _notificationProxy;
	BOOL _needToSendNotification;
	AllChildrenFilter *_filter;
	DelayedNotifier *_delayedNotifier;
	
	// notification objects
	
	// Insertion
	NSArray *_nodesInserted, *_inputsInserted, *_outputsInserted, *_icsInserted;
	NSIndexSet *_nodesInsertedIndexes, *_inputsInsertedIndexes, *_outputsInsertedIndexes, *_icsInsertedIndexes;
	
	// Removal
	NSArray *_nodesRemoved, *_inputsRemoved, *_outputsRemoved, *_icsRemoved;
	NSIndexSet *_nodesRemovedIndexes, *_inputsRemovedIndexes, *_outputsRemovedIndexes, *_icsRemovedIndexes;

	// Selection
	NSIndexSet * _selectedNodeIndexes, *_oldSelectedNodeIndexes, *_selectedInputIndexes, *_oldSelectedInputIndexes, *_selectedOutputIndexes, *_oldSelectedOutputIndexes, *_selectedICIndexes, *_oldSelectedICIndexes;
}

@property (readonly, nonatomic) id notificationProxy;

// Insertion
@property (readwrite, retain, nonatomic) NSArray *nodesInserted, *inputsInserted, *outputsInserted, *icsInserted;
@property (readwrite, retain, nonatomic) NSIndexSet *nodesInsertedIndexes, *inputsInsertedIndexes, *outputsInsertedIndexes, *icsInsertedIndexes;

// Removal
@property (readwrite, retain, nonatomic) NSArray *nodesRemoved, *inputsRemoved, *outputsRemoved, *icsRemoved;
@property (readwrite, retain, nonatomic) NSIndexSet *nodesRemovedIndexes, *inputsRemovedIndexes, *outputsRemovedIndexes, *icsRemovedIndexes;

// Selection
@property (readwrite, retain, nonatomic) NSIndexSet *selectedNodeIndexes, *selectedInputIndexes, *selectedOutputIndexes, *selectedICIndexes;
@property (readwrite, retain, nonatomic) NSIndexSet *oldSelectedNodeIndexes, *oldSelectedInputIndexes, *oldSelectedOutputIndexes, *oldSelectedICIndexes;

- (id)initWithFilter:(AllChildrenFilter *)value mode:(NSString *)mode;
- (id)notificationProxy;
- (void)fireSingleWillChangeNotification:(NodeProxy *)proxy;
- (void)queueSinglePostponedNotification:(NodeProxy *)proxy;
- (void)notificationDidFire_callback;
- (BOOL)isWaitingForNotificationToBeSent;

- (void)postNotification;

#pragma mark notification objects Accessors

// Insertion
- (void)appendNodesInserted:(NSArray *)newValues atIndexes:(NSIndexSet *)changeIndexes;
- (void)appendInputsInserted:(NSArray *)newValues atIndexes:(NSIndexSet *)changeIndexes;
- (void)appendOutputsInserted:(NSArray *)newValues atIndexes:(NSIndexSet *)changeIndexes;
- (void)appendIcsInserted:(NSArray *)newValues atIndexes:(NSIndexSet *)changeIndexes;

// Removal
- (void)appendNodesRemoved:(NSArray *)newValues atIndexes:(NSIndexSet *)changeIndexes;
- (void)appendInputsRemoved:(NSArray *)newValues atIndexes:(NSIndexSet *)changeIndexes;
- (void)appendOutputsRemoved:(NSArray *)newValues atIndexes:(NSIndexSet *)changeIndexes;
- (void)appendIcsRemoved:(NSArray *)newValues atIndexes:(NSIndexSet *)changeIndexes;

// Selection
- (void)changedSelectedNodeIndexesFrom:(NSIndexSet *)oldValue to:(NSIndexSet *)newValue;
- (void)changedSelectedInputIndexesFrom:(NSIndexSet *)oldValue to:(NSIndexSet *)newValue;
- (void)changedSelectedOutputIndexesFrom:(NSIndexSet *)oldValue to:(NSIndexSet *)newValue;
- (void)changedSelectedICIndexesFrom:(NSIndexSet *)oldValue to:(NSIndexSet *)newValue;

@end
