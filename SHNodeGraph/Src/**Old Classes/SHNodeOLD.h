//
//  SHNode.h
//  newInterface
//
//  Created by Steve Hooley on 15/02/2005.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "SHProto_Node.h"


// @class SH_Path, SHInterConnector;
@class SHNodeGroup;

/*
 * SHNode: VIRTUAL
 * nodeGroups(scripts) and properties are types of SHNodes
 * But they themselves are virtual.
 * THESE HOLD ALL THE DATA FOR THE NODEGROUP
*/
@interface SHProto_Node (SHNodeOLD) 


#pragma mark -

#pragma mark action methods
- (void) moveNodeUpInExecutionOrder:(SHProto_Node*)aNode
- (void) moveNodeDownInExecutionOrder:(SHProto_Node*)aNode

#pragma mark accessor methods
- (id) inputAttribute:(int)uID;
- (id) outputAttribute:(int)uID;



- (id) inputAttributeWithName:(NSString*)name;
- (id) outputAttributeWithName:(NSString*)name;

-(SHProto_Node*) nodeFromNodesAndAttributesInside:(int)uID;
- (id) nodeFromTheNodesInside:(int)uID;



@end