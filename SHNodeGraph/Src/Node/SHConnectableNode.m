//
//  SHConnectableNode.m
//  SHNodeGraph
//
//  Created by Steve Hooley on 19/10/2005.
//  Copyright 2005 HooleyHoop. All rights reserved.
//

#import "SHConnectableNode.h"
//#import "SHNodeAttributeMethods.h"
//#import "SHNodePrivateMethods.h"
//#import "SHConnectlet.h"

//#import "SHAttribute.h"

//#import "SHNodeSelectingMethods.h"
//#import "SHInputAttribute.h"

#import <ProtoNodeGraph/SHChildContainer.h>
#import <ProtoNodeGraph/SHProtoInputAttribute.h>
#import <ProtoNodeGraph/SHInterConnector.h>
#import <ProtoNodeGraph/SH_Path.h>
#import <ProtoNodeGraph/SHParent_Connectable.h>

#import <SHShared/BBLogger.h>

/*
 *
*/
@implementation SHNode (SHConnectableNode)

#pragma mark -

#pragma mark action methods

- (SHInterConnector *)connectAttributeAtRelativePath:(SH_Path *)p1 toAttributeAtRelativePath:(SH_Path *)p2 undoManager:(NSUndoManager *)um {

	NSParameterAssert(p1 && p2 && p1!=p2);

	NSObject<SHNodeLikeProtocol> *att1, *att2;

	NSArray *p1c = [p1 pathComponents];
	NSArray *p2c = [p2 pathComponents];
	att1 = [self childAtRelativePath:p1];
	att2 = [self childAtRelativePath:p2];

	/* Recursively calll this method till we are at the correct parent to create the connector */
	if([[p1c objectAtIndex:0] isEqualToString:[p2c objectAtIndex:0] ]){
		// the interconnector belongs to a deeper node
		id<SHNodeLikeProtocol> child = [self childWithKey:[p1c objectAtIndex:0]];
		NSAssert([child isKindOfClass:[SHNode class]], @"wrong type of object");
		SH_Path *newp1 = [(SHNode *)child relativePathToChild:att1];
		SH_Path *newp2 = [(SHNode *)child relativePathToChild:att2];
		return [(SHNode *)child connectAttributeAtRelativePath:newp1 toAttributeAtRelativePath:newp2 undoManager:um];
	}
	return [self connectOutletOfAttribute:(SHProtoAttribute *)att1 toInletOfAttribute:(SHProtoAttribute *)att2 undoManager:um];
}

- (SHInterConnector *)connectOutletOfAttribute:(SHProtoAttribute *)att1 toInletOfAttribute:(SHProtoAttribute *)att2 undoManager:(NSUndoManager *)um {
	
	NSParameterAssert(att1 && att2 && att1!=att2);
	
	SHProtoAttribute *outAttr=att1;
	SHProtoAttribute *inAttr=att2;
	SHInterConnector* interConnector;
	
//doweneedthis?	if( _evaluationInProgress==NO )
//doweneedthis?	{
		// NSAssert(outAttr->_value != inAttr->_value, @"SHConnectableNode.m: ERROR! both attributes have the same value!");

//doweneedthis?		if( (att1!=nil) && (att2!=nil) && (att1!=att2) )
//doweneedthis?		{
			// Check to see if it makes an infinite loop - it will eiher end or get back to itself
			//sh BOOL infiniteLoop = [nodeIn followAllConnectionsLookingFor: nodeOut];
			//sh if( infiniteLoop==YES )
			//sh {
			//sh logInfo(@"WARNING: That connection makes an infinite loop");
			//sh }
			
			/*
			 * could be connecting 1 (in to out), 2 (in to in), 3 (out to out)
			*/
			//int c;
//			if([att1 class] == [SHInputAttribute class])
//				if([att2 class] == [SHInputAttribute class])
//					c=2;
//				else
//					c=1;
//			else
//				if([att2 class] == [SHInputAttribute class])
//					c=1;
//				else
//					c=3;

			/*
			 * 4 possible connection scenarios.. which are we?
			*/
			//if(c==2){
//			
//				// 1) inputAttribute1 to inputAttribute2 where inputAttribute1.parent == inputAttribute2.parent.parent == self
//				if([att1 parentSHNode]==self){
//					if([[att2 parentSHNode] parentSHNode]==self){
//						outAttr=att1; inAttr=att2;
//					} else
//						return nil;
//				} else if([att2 parentSHNode]==self){
//					if([[att1 parentSHNode] parentSHNode]==self){
//						outAttr=att2; inAttr=att1;
//					} else
//						return nil;
//				}
//
//			} else if(c==3){
//			
//				// 2) outputAttribute1 to outputAttribute2 where outputAttribute1.parent == outputAttribute2.parent.parent == self
//				if([att1 parentSHNode]==self){
//					if([[att2 parentSHNode] parentSHNode]==self){
//						outAttr=att2; inAttr=att1;
//					} else
//						return nil;
//				} else if([att2 parentSHNode]==self){
//					if([[att1 parentSHNode] parentSHNode]==self){
//						outAttr=att1; inAttr=att2;
//					} else
//						return nil;
//				}
//
//			} else if(c==1){
//			
//				// 3) inputAttribute1 to outputAttribute1 in same parentSHNode which is self
//				if([att1 parentSHNode]==self && [att2 parentSHNode]==self){
//					if([att1 class] == [SHInputAttribute class]){
//						outAttr=att1; inAttr=att2;
//					} else {
//						outAttr=att2; inAttr=att1;
//					}
//				} else if([[att1 parentSHNode] parentSHNode]==self && [[att2 parentSHNode]parentSHNode]==self) {
//				// 4) inputAttribute1 to outputAttribute1 where parentSHNode.parentSHNode for both nodes is self
//					if([att1 class] == [SHInputAttribute class]){
//						outAttr=att2; inAttr=att1;
//					} else {
//						outAttr=att1; inAttr=att2;
//					}				
//				} else 
//					return nil;
//			}
			
			[self _makeSHInterConnectorBetweenOutletOf:outAttr andInletOfAtt:inAttr undoManager:um];
			interConnector = [self interConnectorFor:outAttr and:inAttr];

			if(interConnector!=nil)
			{
				[inAttr setDirtyBit:YES uid:random()];
				[inAttr setDirtyBelow:random()];
				[interConnector hasBeenAddedToParentSHNode];
				return interConnector;
			} else {
				logError(@"SHConnectableNode.m0: ERROR! CONNECTION FAILED!");
			}
//doweneedthis?		} else {
//doweneedthis?			logError(@"SHConnectableNode.m: ERROR: Cant join an attribute to it's self or nil node");
//doweneedthis?		}
//doweneedthis?	} else {
//doweneedthis?		logError(@"SHConnectableNode.m: ERROR: Sorry, Can't add a node while the script is being evaluated");
//doweneedthis?	}
	return nil;
}

- (NSArray *)interConnectorsDependantOnChildren:(NSArray *)children {
	
	NSMutableArray *interConnectorsToReturn = [NSMutableArray array];
	for( id child in children )
	{
		if([child isKindOfClass:[SHInterConnector class]])
		{
			if( [interConnectorsToReturn indexOfObjectIdenticalTo: child]==NSNotFound ){ 
				[interConnectorsToReturn addObject:child];
			}
		} else if([child isKindOfClass:[SHProtoAttribute class]]){
			NSArray *connectedICS = [child allConnectedInterConnectors];
			for( SHInterConnector *childCon in connectedICS ){
				if( [interConnectorsToReturn indexOfObjectIdenticalTo: childCon]==NSNotFound ){
					[interConnectorsToReturn addObject:childCon];
				}
			}
		}
	}
	return interConnectorsToReturn;
}

#pragma mark accessor methods


//- (id)interConnectorWithKey:(NSString *)key
//{
//	SHInterConnector* con = [_shInterConnectorsInside objectForKey:key];
////	if(outAttr==nil)
////		logInfo(@"SHNode.m: ERRROR: There is no outputAttribute with that key.");
//	return con;
//}



- (int)indexOfInterConnector:(SHInterConnector *)aConnector {

	return [_childContainer.shInterConnectorsInside indexOfObjectIdenticalTo: aConnector];
}

//- (SHOrderedDictionary *)SHInterConnectorsInside {return _shInterConnectorsInside; }

#pragma mark notification methods
//- (void)postSHInterConnectorAdded_Notification:(id)interCon
//{
//	NSDictionary *d = [NSDictionary dictionaryWithObject:interCon forKey:@"theInterConnector"];
//	NSNotification *n = [NSNotification notificationWithName:@"SHInterConnectorAdded" object:self userInfo:d];
//	[[NSNotificationQueue defaultQueue] enqueueNotification:n postingStyle:NSPostASAP ]; // could post when idle
//}

//- (void)postSHInterConnectorDeleted_Notification:(id)interCon
//{
//	NSDictionary *d = [NSDictionary dictionaryWithObject:interCon forKey:@"theInterConnector"];
//	NSNotification *n = [NSNotification notificationWithName:@"SHInterConnectorDeleted" object:self userInfo:d];
//	[[NSNotificationQueue defaultQueue] enqueueNotification:n postingStyle:NSPostASAP ];
//}

@end
