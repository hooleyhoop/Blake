//
//  SHNodePrivateMethods.h
//  SHNodeGraph
//
//  Created by Steve Hooley on 25/05/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SHNode.h"
//!Alert-putback! #import <SHShared/SHAttributeProtocol.h>

/*
 * Private
*/
@interface SHNode (SHNodePrivateMethods)

//- (void) setOperatorPrivateMember:(BOOL)flag;

- (SHOrderedDictionary *)_targetStorageForObject:(SHChild *)anOb;

//- (BOOL)addChild:(id<SHNodeLikeProtocol>)aNode forKey:(NSString *)aKey atIndex:(unsigned int)ind autoRename:(BOOL)renameFlag;
//- (BOOL)addChild:(id<SHNodeLikeProtocol>)aNode forKey:(NSString *)aKey autoRename:(BOOL)renameFlag;
//
//- (BOOL)addPrivateChild:(id<SHNodeLikeProtocol>)aNode;		// isnt saved as is automatically added by another node
//- (void)deleteChildren:(NSArray *)childrenToDelete;
//
//- (void)deleteNodes:(NSArray *)nodes;
//- (void)deleteInputs:(NSArray *)inputs;
//- (void)deleteOutputs:(NSArray *)outputs;
//- (void)deleteInterconnectors:(NSArray *)ics;


//// these are a bit confusing because for an attribute itself we add connectlets - not attributes
//- (void)_addChildInputAttribute:(id<SHAttributeProtocol>)value withKey:(NSString *) key;
//- (void)_addChildOutputAttribute: (id<SHAttributeProtocol>)value withKey:(NSString *) key;

/* dont use this? Only changes the key. Use setName to change name and key */
- (void)_changeNameOfChild:(SHChild *)child to:(NSString *)value;

// - (void)_addSHInterConnector:(SHInterConnector *)value withKey:(NSString *)key;


@end