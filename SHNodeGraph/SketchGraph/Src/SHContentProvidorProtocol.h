/*
 *  SHContentProvidorProtocol.h
 *  BlakeLoader
 *
 *  Created by steve hooley on 09/05/2008.
 *  Copyright 2008 HooleyHoop. All rights reserved.
 *
 */
@class SHNodeGraphModel;
@class AbtractModelFilter, NodeProxy;

/* Providor */
@protocol SHContentProvidorProtocol <NSObject>

- (void)cleanUpFilter;

- (void)registerAUser:(id)user;
- (void)unRegisterAUser:(id)user;

- (void)setOptions:(NSDictionary *)opts;

- (BOOL)hasUsers;
- (void)setModel:(SHNodeGraphModel *)value;

- (void)startObservingModel;
- (void)stopObservingModel;

@end

/* User */
@protocol SHContentProviderUserProtocol <NSObject>

- (AbtractModelFilter *)filter;
- (void)setFilter:(AbtractModelFilter *)value;

/* content */
- (void)temp_proxy:(NodeProxy *)proxy willChangeContent:(NSArray *)values atIndexes:(NSIndexSet *)indexes;
- (void)temp_proxy:(NodeProxy *)proxy didChangeContent:(NSArray *)values atIndexes:(NSIndexSet *)indexes;

- (void)temp_proxy:(NodeProxy *)proxy willInsertContent:(NSArray *)proxiesForsuccessFullObjects atIndexes:(NSIndexSet *)indexes;
- (void)temp_proxy:(NodeProxy *)proxy didInsertContent:(NSArray *)proxiesForsuccessFullObjects atIndexes:(NSIndexSet *)indexes;

- (void)temp_proxy:(NodeProxy *)proxy willRemoveContent:(NSArray *)values atIndexes:(NSIndexSet *)indexes;
- (void)temp_proxy:(NodeProxy *)proxy didRemoveContent:(NSArray *)values atIndexes:(NSIndexSet *)indexes;

/* selection */
// bear in mind that indexesOfSelectedObjectsThatPassFilter is actually an array and the changed indexes are actually the first item
- (void)temp_proxy:(NodeProxy *)proxy willChangeSelection:(NSMutableIndexSet *)indexesOfSelectedObjectsThatPassFilter;
- (void)temp_proxy:(NodeProxy *)proxy didChangeSelection:(NSMutableIndexSet *)indexesOfSelectedObjectsThatPassFilter;

@end
