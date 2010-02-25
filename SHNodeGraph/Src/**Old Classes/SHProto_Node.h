//
//  Proto_Node.h
//  InterfaceTest
//
//  Created by Steve Hooley on Fri Jul 23 2004.
//  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
//


#import "SHooleyObject.h"

@class SH_Path;


/*
 * SHProto_Node : VIRTUAL
 * The simplest form of node
 * Every element of a graph is a protoNode including connectlets
 * Conneclets aren't 'full' nodes but are 'proto-nodes'
*/
@interface SHProto_NodeOLD : SHooleyObject
{

}

#pragma mark -
+ (NSMutableArray *)descriptions

#pragma mark init methods
#pragma mark action methods
#pragma mark accessor methods


- (id) getAuxObjectForKey:(NSString*)aKey
- (void) setAuxObject:(id)anObject forKey:(NSString*)aKey

//- (NSMutableDictionary *) auxiliaryData;
//12/10/2005 - (void) setAuxiliaryData: (NSMutableDictionary *) anAuxiliaryData;

- (BOOL)enabled;
- (void)setEnabled:(BOOL)flag;
- (BOOL)locked;
- (void)setLocked: (BOOL) flag;

// - (NSMutableDictionary *) nodesAndAttributesInside_Dict;

- (void) setOrderedInputs: (NSMutableArray *) anOrderedInputs;
- (void) setOrderedOutputs: (NSMutableArray *) anOrderedOutputs;

- (NSMutableDictionary*) nodesInside_Dict;


//temp
- (unsigned int)countOfChildren;
- (id)objectInChildrenAtIndex:(unsigned int)index;
// end temp

@end
