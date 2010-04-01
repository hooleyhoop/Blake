//
//  XMLSavingInterConnector.m
//  SHNodeGraph
//
//  Created by Steven Hooley on 04/09/2007.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "XMLSavingInterConnector.h"


@implementation SHInterConnector (XMLSavingInterConnector)


- (NSXMLElement *)xmlRepresentation
{
	NSXMLElement* thisInterConnector = [[[NSXMLElement alloc] initWithName:@"interConnector" stringValue:[self saveName]] autorelease];

// destinationNode
// destinationPort
// sourceNode
// sourcePort

	// [thisNode setAttributes: [NSArray arrayWithObjects:]];
	//NSXMLElement* childHolder = [[[NSXMLElement alloc] initWithName:@"children"] autorelease];
//	NSXMLElement* nodeHolder = [[[NSXMLElement alloc] initWithName:@"nodes"] autorelease];
//		
//	// go thru all child nodes and add their xml to this
//	NSEnumerator *enumerator = [_nodesInside objectEnumerator];
//	SHNode* aNode;
//	while (aNode = [enumerator nextObject]) {
//		NSXMLElement* childNode = [aNode xmlRepresentation];
//		[nodeHolder addChild: childNode];
//	}
//	[childHolder addChild: nodeHolder];
//
//	// add inputs
//	NSXMLElement* inputHolder = [[[NSXMLElement alloc] initWithName:@"inputs"] autorelease];
//	enumerator = [_inputs objectEnumerator];
//	SHInputAttribute* inputChild;
//	while (inputChild = [enumerator nextObject]) {
//		NSXMLElement* childNode = [inputChild xmlRepresentation];
//		[inputHolder addChild: childNode];
//	}
//	[childHolder addChild: inputHolder];
//	
//	// add outputs
//	NSXMLElement* outputHolder = [[[NSXMLElement alloc] initWithName:@"outputs"] autorelease];
//	enumerator = [_outputs objectEnumerator];
//	SHOutputAttribute* outputChild;
//	while (outputChild = [enumerator nextObject]) {
//		NSXMLElement* childNode = [outputChild xmlRepresentation];
//		[outputHolder addChild: childNode];
//	}
//	[childHolder addChild: outputHolder];	
//	
//	// add connections
//	NSXMLElement* connectionHolder = [[[NSXMLElement alloc] initWithName:@"connections"] autorelease];
//	enumerator = [_sHInterConnectorsInside objectEnumerator];
//	SHInterConnector* connectorChild;
//	while (connectorChild = [enumerator nextObject]) {
//		NSXMLElement* childNode = [connectorChild xmlRepresentation];
//		[connectionHolder addChild: childNode];
//	}
//	[childHolder addChild: connectionHolder];	
//	
//	[thisNode addChild: childHolder];
	return thisInterConnector;
}
@end
