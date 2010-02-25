//
//  AllChildrenFilter.h
//  SHNodeGraph
//
//  Created by steve hooley on 26/05/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "SHContentProvidorProtocol.h"
#import "AbtractModelFilter.h"

@class DelayedNotificationCoalescer;

@interface AllChildrenFilter : AbtractModelFilter <SHContentProvidorProtocol> {

	@public
//	AllChildrenProxyFactory *_proxyMaker;
	DelayedNotificationCoalescer *_contentInsertionNotificationCoalescer;
	DelayedNotificationCoalescer *_contentRemovedNotificationCoalescer;
	DelayedNotificationCoalescer *_selectionChangedNotificationCoalescer;
	
}

#pragma mark Content
// Changed
- (void)modelWillChange:(NodeProxy *)proxy nodesInside_to:(id)newValue from:(id)oldValue;
- (void)modelWillChange:(NodeProxy *)proxy inputs_to:(id)newValue from:(id)oldValue;
- (void)modelWillChange:(NodeProxy *)proxy outputs_to:(id)newValue from:(id)oldValue;
- (void)modelWillChange:(NodeProxy *)proxy shInterConnectorsInside_to:(id)newValue from:(id)oldValue;

- (void)modelChanged:(NodeProxy *)proxy nodesInside_to:(id)newValue from:(id)oldValue;
- (void)modelChanged:(NodeProxy *)proxy inputs_to:(id)newValue from:(id)oldValue;
- (void)modelChanged:(NodeProxy *)proxy outputs_to:(id)newValue from:(id)oldValue;
- (void)modelChanged:(NodeProxy *)proxy shInterConnectorsInside_to:(id)newValue from:(id)oldValue;

// Inserted
- (void)modelWillInsert:(NodeProxy *)proxy nodesInside:(id)newValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelWillInsert:(NodeProxy *)proxy inputs:(id)newValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelWillInsert:(NodeProxy *)proxy outputs:(id)newValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelWillInsert:(NodeProxy *)proxy shInterConnectorsInside:(id)newValue atIndexes:(NSIndexSet *)changeIndexes;

- (void)modelInserted:(NodeProxy *)proxy nodesInside:(id)newValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelInserted:(NodeProxy *)proxy inputs:(id)newValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelInserted:(NodeProxy *)proxy outputs:(id)newValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelInserted:(NodeProxy *)proxy shInterConnectorsInside:(id)newValue atIndexes:(NSIndexSet *)changeIndexes;

// Replaced
- (void)modelWillReplace:(NodeProxy *)proxy nodesInside:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelWillReplace:(NodeProxy *)proxy inputs:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelWillReplace:(NodeProxy *)proxy outputs:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelWillReplace:(NodeProxy *)proxy shInterConnectorsInside:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes;

- (void)modelReplaced:(NodeProxy *)proxy nodesInside:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelReplaced:(NodeProxy *)proxy inputs:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelReplaced:(NodeProxy *)proxy outputs:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelReplaced:(NodeProxy *)proxy shInterConnectorsInside:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes;

// Removed
- (void)modelWillRemove:(NodeProxy *)proxy nodesInside:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelWillRemove:(NodeProxy *)proxy inputs:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelWillRemove:(NodeProxy *)proxy outputs:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelWillRemove:(NodeProxy *)proxy shInterConnectorsInside:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes;

- (void)modelRemoved:(NodeProxy *)proxy nodesInside:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelRemoved:(NodeProxy *)proxy inputs:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelRemoved:(NodeProxy *)proxy outputs:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelRemoved:(NodeProxy *)proxy shInterConnectorsInside:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes;

#pragma mark Selection
// Changed
- (void)modelWillChange:(NodeProxy *)proxy nodesInsideSelection_to:(id)newValue from:(id)oldValue;
- (void)modelWillChange:(NodeProxy *)proxy inputsSelection_to:(id)newValue from:(id)oldValue;
- (void)modelWillChange:(NodeProxy *)proxy outputsSelection_to:(id)newValue from:(id)oldValue;
- (void)modelWillChange:(NodeProxy *)proxy shInterConnectorsInsideSelection_to:(id)newValue from:(id)oldValue;

- (void)modelChanged:(NodeProxy *)proxy nodesInsideSelection_to:(id)newValue from:(id)oldValue;
- (void)modelChanged:(NodeProxy *)proxy inputsSelection_to:(id)newValue from:(id)oldValue;
- (void)modelChanged:(NodeProxy *)proxy outputsSelection_to:(id)newValue from:(id)oldValue;
- (void)modelChanged:(NodeProxy *)proxy shInterConnectorsInsideSelection_to:(id)newValue from:(id)oldValue;

// Inserted
- (void)modelWillInsert:(NodeProxy *)proxy nodesInsideSelection:(id)newValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelWillInsert:(NodeProxy *)proxy inputsSelection:(id)newValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelWillInsert:(NodeProxy *)proxy outputsSelection:(id)newValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelWillInsert:(NodeProxy *)proxy shInterConnectorsInsideSelection:(id)newValue atIndexes:(NSIndexSet *)changeIndexes;

- (void)modelInserted:(NodeProxy *)proxy nodesInsideSelection:(id)newValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelInserted:(NodeProxy *)proxy inputsSelection:(id)newValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelInserted:(NodeProxy *)proxy outputsSelection:(id)newValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelInserted:(NodeProxy *)proxy shInterConnectorsInsideSelection:(id)newValue atIndexes:(NSIndexSet *)changeIndexes;

// Replaced
- (void)modelWillReplace:(NodeProxy *)proxy nodesInsideSelection:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelWillReplace:(NodeProxy *)proxy inputsSelection:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelWillReplace:(NodeProxy *)proxy outputsSelection:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelWillReplace:(NodeProxy *)proxy shInterConnectorsInsideSelection:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes;

- (void)modelReplaced:(NodeProxy *)proxy nodesInsideSelection:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelReplaced:(NodeProxy *)proxy inputsSelection:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelReplaced:(NodeProxy *)proxy outputsSelection:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelReplaced:(NodeProxy *)proxy shInterConnectorsInsideSelection:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes;

// Removed
- (void)modelWillRemove:(NodeProxy *)proxy nodesInsideSelection:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelWillRemove:(NodeProxy *)proxy inputsSelection:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelWillRemove:(NodeProxy *)proxy outputsSelection:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelWillRemove:(NodeProxy *)proxy shInterConnectorsInsideSelection:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes;

- (void)modelRemoved:(NodeProxy *)proxy nodesInsideSelection:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelRemoved:(NodeProxy *)proxy inputsSelection:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelRemoved:(NodeProxy *)proxy outputsSelection:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes;
- (void)modelRemoved:(NodeProxy *)proxy shInterConnectorsInsideSelection:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes;

- (void)_doPreInsertionNotification;
- (void)_doDelayedInsertionNotification;
- (void)_doPreRemoveNotification;
- (void)_doDelayedRemoveNotification;
- (void)_doPreSelectionNotification;
- (void)_doDelayedSelectionNotification;

- (BOOL)hasPendingNotifications;
- (void)postPendingNotificationsExcept:(DelayedNotificationCoalescer *)value;

@end
