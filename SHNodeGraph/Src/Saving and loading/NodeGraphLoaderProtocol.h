/*
 *  NodeGraphLoaderProtocol.h
 *  SHNodeGraph
 *
 *  Created by steve hooley on 24/02/2008.
 *  Copyright 2008 HooleyHoop. All rights reserved.
 *
 */
#import "SHNode.h"

@protocol NodeGraphLoaderProtocol <NSObject>

- (BOOL)saveNode:aNode toFile:(NSString *)filePath;
- (SHNode *)loadNodeFromFile:(NSString *)filePath;

- (NSXMLElement *)scriptWrapperFromChildren:(NSArray *)childrenToCopy fromNode:(SHNode *)parentNode;
- (BOOL)unArchiveChildrenFromScriptWrapper:(NSXMLElement *)copiedStuffWrapper intoNode:(SHNode *)parentNode;

@end