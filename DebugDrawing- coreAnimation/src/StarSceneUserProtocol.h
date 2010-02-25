/*
 *  StarSceneUserProtocol.h
 *  DebugDrawing
 *
 *  Created by steve hooley on 26/06/2009.
 *  Copyright 2009 BestBefore Ltd. All rights reserved.
 *
 */

@class SHNode;


@protocol StarSceneUserProtocol <NSObject>

@end


@protocol ProxyLikeProtocol <NSObject>

- (SHNode *)originalNode;
- (NSMutableArray *)filteredContent;
- (id)objectsInFilteredContentAtIndexes:(NSIndexSet *)theIndexes;

@end