//
//  SHParent_Connectable.m
//  SHNodeGraph
//
//  Created by steve hooley on 09/04/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "SHParent_Connectable.h"
#import "SHConnectlet.h"
#import "SHProtoAttribute.h"
#import "SHChildContainer.h"

@implementation SHParent (SHParent_Connectable)

- (NSMutableArray *)allConnectionsToChild:(id)aChild {
	
	NSParameterAssert(aChild);
	if([self isChild:aChild]==NO) {
		[NSException raise:@"Not a child" format:@""];
	}

	NSMutableArray* allInterConnectors = [NSMutableArray array];
	// is child a node or an attribute?
	if([aChild respondsToSelector:@selector(theInlet)])
	{	
		[allInterConnectors addObjectsFromArray: [aChild allConnectedInterConnectors]];
	} else {
		// must be a node
		// iterate through all connectors associated with the node we are going to delete
		for( SHProtoAttribute *inAtt in [aChild inputs] )
		{
			SHConnectlet* theConnectlet = (SHConnectlet *)[inAtt theInlet];
			[allInterConnectors addObjectsFromArray: [theConnectlet shInterConnectors]];		
		}
		
		for( SHProtoAttribute *outAtt in [aChild outputs] )
		{
			SHConnectlet* theConnectlet = (SHConnectlet *)[outAtt theOutlet];
			[allInterConnectors addObjectsFromArray: [theConnectlet shInterConnectors]];
		}				
	}	
	return allInterConnectors;
}

- (SHInterConnector *)interConnectorFor:(SHProtoAttribute *)inAtt1 and:(SHProtoAttribute *)inAtt2 {

	NSParameterAssert(inAtt1);
	NSParameterAssert(inAtt2);
	return [_childContainer interConnectorFor:inAtt1 and:inAtt2];
}

@end
