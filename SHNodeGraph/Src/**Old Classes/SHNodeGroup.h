//
//  SHScript.h
//  newInterface
//
//  Created by Steve Hooley on 08/02/2005.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

// #import "SHExecutableNode.h"

@class SHConnectlet, SHInterConnector, SHProto_Node, SHInputAttribute, SHOutputAttribute, SHAttribute;


/*
 * SHNodeGroup public (formerly Script)
 * These are the building blocks of your projects
 * Operators are kinds of (descended from) SHNodeGroup
 *
 * Can hold the low level operators as well as other
 * SHNodeGroups, SHInputAttribute(SHInputNodes), SHOutputAttribute(SHOutputNodes) and SHConnectlets
 * can also be 'evaluated'
*/
@interface SHNodeGroup : SHProto_Node
{
	// all input and outputs are visible to the parent script

//	BOOL 				_hasBeenChanged;
}

#pragma mark -

#pragma mark Private Action methods
- (void) initInputs
- (void) initOutputs

#pragma mark accessor methods

// - (BOOL) hasBeenChanged; // called when edited
// - (void) setHasBeenChanged: (BOOL) flag;



@end