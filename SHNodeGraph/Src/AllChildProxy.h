//
//  AllChildProxy.h
//  SHNodeGraph
//
//  Created by steve hooley on 04/06/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "NodeProxy.h"

@interface AllChildProxy : NodeProxy {
	
	BOOL _icWasRemovedHint;
}

@property (readonly, nonatomic) BOOL icWasRemovedHint;

- (void)interConnectorsWereRemoved;

- (void)removeICsNoLongerInNode;

- (NSArray *)nodeProxies;
- (NSArray *)inputProxies;
- (NSArray *)outputProxies;
- (NSArray *)icProxies;

@end
