//
//  SHObjectGraphModel.h
//  Pharm
//
//  Created by Steve Hooley on 08/08/2005.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
// #import "SHProto_Node.h"

@class SHConnectlet;
@class SHInterConnector, SHNodeGroup, SHNode, SH_Path;


/*
 * The object Graph.
 * Independant of any views. 
*/
@interface  SHObjectGraphModel : NSObject {
	
	BOOL _isEvaluating;
}

#pragma mark -
#pragma mark class methods

#pragma mark init methods
//- (id)initWithController:(SHScriptControl*)aController;

#pragma mark action methods
/*
- (int) addNodeToCurrentNodeGroup:(SHNode*) aNode;
*/

#pragma mark callback methods
#pragma mark accessor methods
/* 
- (NSMutableDictionary *) rootNodeGroups;
- (NSArray *) rootNodeGroupsArray;
- (void) setRootNodeGroups: (NSMutableDictionary *) aDictOfNodeGroups;
- (id) nodeFromCurrentNodeGroup:(int)uID;
*/

/*
- (void) yay;
- (void) debugCurrentNodeGroup; */

// - (int) addNodeGroup:(SHNodeGroup*) aNode toNodeGroup:(NSString*) aNodeGroupName;
// - (BOOL) deleteNodeFromCurrentNodeGroup:(int) nodeID;
// - (BOOL) connectOutput:(int)opN ofNode_inCurrentNodeGroup:(int)anode toInput:(int)ipN ofNodeInCurrentNodeGroup:(int)anotherNode;
// - (SHInterConnector*) connectOutputAttribute:(GLint)out_attUID ofNode_inCurrentNodeGroup:(GLint)anode toInputAtttribute:(GLint)in_attUID ofNodeInCurrentNodeGroup:(GLint)anotherNode;
// - (BOOL) deleteSHInterConnectorFromCurrentNodeGroup:(int) connectorID;



@end
