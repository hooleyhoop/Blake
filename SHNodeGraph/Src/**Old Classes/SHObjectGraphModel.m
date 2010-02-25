//
//  SHNodeGraphModel.m
//  Pharm
//
//  Created by Steve Hooley on 08/08/2005.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//



/*
 *
*/
@implementation SHNodeGraphModel

#pragma mark -
#pragma mark class methods

/* unsigned int UpTimeInMilliseconds()
{
   unsigned int result;
   Nanoseconds n = AbsoluteToNanoseconds(UpTime());
   unsigned long long int i = n.hi;
   i <<= 32;
   i += n.lo;
   i /= 1000000;
   result = i;
   return result;
} */


//NSTimeInterval TimeStampToTimeInterval(NSTimeInterval aTime) {
//	UInt64 realTimeStamp;
//	Nanoseconds nanoTimeStamp;
//	AbsoluteTime absTimeStamp;
//	NSTimeInterval timeInterval;	
	
//	absTimeStamp=UInt64ToUnsignedWide(aTime);
//	nanoTimeStamp=AbsoluteToNanoseconds(absTimeStamp);
//	realTimeStamp=UnsignedWideToUInt64(nanoTimeStamp);
//	timeInterval=((NSTimeInterval)realTimeStamp)/1000000000;
//	return timeInterval;
//}


#pragma mark action methods


// ===========================================================
// - deleteAllSelectedFromCurrentNodeGroup:
// ===========================================================
//- (void) deleteRootNode:(SHNodeGroup*)aNode forKey:(NSString*)aName
//{
//	[_rootNodeGroups removeObject:aNode forKey:aName];
//}


// ===========================================================
// - addNodeToCurrentNodeGroup:
// ===========================================================
/* - (int) addNodeToCurrentNodeGroup:(SHNode*) aNode{
	return [_currentNodeGroup addNodeToNodeGroup:aNode];
} */


//=========================================================== 
//  addDefaultNodes 
//=========================================================== 
//- (void)addDefaultNodes
//{
//}



#pragma mark accessor methods


// ===========================================================
// - rootNodeGroups:
// ===========================================================
/* - (NSMutableDictionary *) rootNodeGroups { return _rootNodeGroups; }
- (NSArray *) rootNodeGroupsArray { return [_rootNodeGroups allValues]; }
- (void) setRootNodeGroups: (NSMutableDictionary *) anNodeGroups {
	if (_rootNodeGroups != anNodeGroups) {
		[anNodeGroups retain];
		[_rootNodeGroups release];
		_rootNodeGroups = anNodeGroups;
	}
} */

// ===========================================================
// - nodeFromCurrentNodeGroup:
// ===========================================================
/* - (id) nodeFromCurrentNodeGroup:(int)uID {
	return [_currentNodeGroup nodeFromTheNodesInside: uID];
} */



// ===========================================================
// - makeNodeGroupCurrent:
// ===========================================================
//- (BOOL) makeNodeGroupCurrent:(SH_Path*)pathToNodeGroup
//{
// here
//	set current node group
	
//	clear the view / scene
	
//	add all nodes from node group to current view / scene
//	return nil;
//}


// ===========================================================
// - deleteNodeFromCurrentNodeGroup:
// ===========================================================
//- (BOOL) deleteNodeFromCurrentNodeGroup:(id) aNode
//{   
//	return [_currentNodeGroup deleteChildNode:aNode];
//}


// ===========================================================
// - connectOutput: ofNode_inCurrentNodeGroup: toInput: ofNodeInCurrentNodeGroup:
// ===========================================================
//- (SHInterConnector*) connectOutputAttribute:(GLint)out_attUID ofNode_inCurrentNodeGroup:(GLint)anode toInputAtttribute:(GLint)in_attUID ofNodeInCurrentNodeGroup:(GLint)anotherNode
//{
//	return [_currentNodeGroup connectOutputAttribute:out_attUID ofNode:anode toInputAtttribute:in_attUID ofNode:anotherNode];
//}


// ===========================================================
// - deleteSHInterConnectorFromCurrentNodeGroup:
// ===========================================================
//- (BOOL) deleteSHInterConnectorFromCurrentNodeGroup:(int) connectorID
//{
//	return [_currentNodeGroup deleteChildInterConnector:connectorID];
//}

/* - (void) yay
{
	NSLog(@"graphModel.m: YAY!");
} */


/* - (void) debugCurrentNodeGroup
{
	NSLog(@"debugCurrentNodeGroup: %@",_currentNodeGroup);
	// SHNode* t = _currentNodeGroup;
} */



@end
