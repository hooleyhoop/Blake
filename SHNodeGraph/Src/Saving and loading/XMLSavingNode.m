//
//  XMLSavingNode.m
//  SHNodeGraph
//
//  Created by Steven Hooley on 01/09/2007.
//  Copyright 2007 HooleyHoop. All rights reserved.
//

#import "XMLSavingNode.h"
#import "SHInputAttribute.h"
#import "SHOutputAttribute.h"
#import "SavingSHProto_Node.h"
#import "XMLSavingAttribute.h"
#import "XMLSavingInterConnector.h"
#import "SavingSHAttribute.h"
#import "SHConnectlet.h"
#import "SHConnectableNode.h"


/*
 *
*/
@implementation SHNode (XMLSavingNode)

+ (SHNode *)newNodeWithXMLElement:(NSXMLElement *)value
{	
	id newNode = nil;
	
	// -- get root
	// make a node with name // check that name is 'node'
	NSError* error = nil;
	NSString* name = [value name];
	if([name isEqualToString:@"node"])
	{
		NSString* nodeClass = [[value attributeForName:@"class"] stringValue];
		NSString *nameValue = [[[value objectsForXQuery:@"name" error:&error] lastObject] stringValue];
		nameValue = [SHNode reverseSaveName:nameValue];
		
		if(nodeClass!=nil && nameValue!=nil)
		{
			newNode = [NSClassFromString(nodeClass) newNode];
			[(id<SHNodeLikeProtocol>)newNode setName: nameValue];
			
			// -- get childHolder <children>
			NSXMLElement* childrenElement = [[value objectsForXQuery:@"children" error:&error] lastObject];
			if(childrenElement)
			{	
				// -- get <nodes>
				NSArray *nodes = [childrenElement objectsForXQuery:@"nodes/node" error:&error];

				for( NSXMLElement *anNodeElement in nodes )
				{
					SHNode* childNode = [SHNode newNodeWithXMLElement: anNodeElement];
					[newNode addChild:childNode autoRename:YES];
					NSString* savedChildIndex = [[[anNodeElement elementsForName:@"index"] lastObject] stringValue];
					if(savedChildIndex){
						logInfo(@"yay - now verify");
						int newIndex = [savedChildIndex intValue];
						int indexCheck = [newNode indexOfChild: childNode];
						NSAssert(newIndex==indexCheck, @"Bum");
					}
				}
				
				// -- get <inputs>
				NSArray *inputs = [childrenElement objectsForXQuery:@"inputs/attribute" error:&error];
				NSEnumerator *inputEnumerator = [inputs objectEnumerator];

				for( NSXMLElement *anInputElement in inputEnumerator )
				{
					SHAttribute* newChildInput = [SHInputAttribute makeAttributeWithXMLElement: anInputElement];
					NSXMLElement* indexElement = [[anInputElement objectsForXQuery:@"index" error:&error] lastObject];
					int sindex = [[indexElement stringValue] intValue];

					[newNode addChild:newChildInput autoRename:NO];
					
					int indexCheck = [newNode indexOfChild: newChildInput];
					NSAssert(sindex==indexCheck, @"Bum");
				}
					
				// -- get <outputs>
				NSArray *outputs = [childrenElement objectsForXQuery:@"outputs/attribute" error:&error];

				for( NSXMLElement *anOutputElement in outputs )
				{
					SHAttribute* newChildOutput = [SHOutputAttribute newAttributeWithXMLElement: anOutputElement];
					NSXMLElement* indexElement = [[anOutputElement objectsForXQuery:@"index" error:&error] lastObject];
					int sindex = [[indexElement stringValue] intValue];

					[newNode addChild:newChildOutput autoRename:NO];
					
					int indexCheck = [newNode indexOfChild:newChildOutput];
					NSAssert(sindex==indexCheck, @"Bum");
				}
					
				// -- get <connections>
				NSArray *connections = [childrenElement objectsForXQuery:@"connections/connection" error:&error];

				for( NSXMLElement *anConnectionElement in connections )
				{
					NSXMLElement* inElement = [[anConnectionElement elementsForName:@"inAt"] lastObject];
					NSXMLElement* outElement = [[anConnectionElement elementsForName:@"outAt"] lastObject];
					int inIndex = [[[inElement attributeForName:@"index"] stringValue] intValue];
					int outIndex = [[[outElement attributeForName:@"index"] stringValue] intValue];
					NSString* inAttName = [inElement stringValue];
					NSString* outAttName = [outElement stringValue];

					id<SHNodeLikeProtocol> inatt1 = [newNode childWithKey:inAttName];
					id<SHNodeLikeProtocol> outatt1 = [newNode childWithKey:outAttName];
					id<SHNodeLikeProtocol> inatt2 = [newNode inputAtIndex:inIndex];
					id<SHNodeLikeProtocol> outatt2 = [newNode outputAtIndex:outIndex];					
					
					NSAssert(inatt1==inatt2, @"ho hum");
					NSAssert(outatt1==outatt2, @"ho hum");
					
					SHInterConnector* newCon = [newNode connectOutletOfAttribute:(SHAttribute *)inatt1 toInletOfAttribute:(SHAttribute *)outatt1];
					NSAssert(newCon!=nil, @"yay");
				}
				
			}
		}
	}
	return newNode;
}

- (NSXMLElement *)xmlRepresentation
{
	/*
	 * This much i know.
	 * -----------------
	 *
	 * operatorPrivateMember nodes and attributes are instantiated by their parents. You don't have to save them as such
	*/
	
	/* make a new xmlNode with class and name */
	NSXMLElement* thisNode = [[[NSXMLElement alloc] initWithName:@"node"] autorelease];
	[thisNode setAttributesAsDictionary: [NSDictionary dictionaryWithObjectsAndKeys:[self class], @"class", nil]]; // This can bite if an object is nil
	
	/* attributes of the node */
	NSXMLElement* nodeName = [[[NSXMLElement alloc] initWithName:@"name" stringValue:[self saveName]] autorelease];
//later	NSXMLElement* privateMember = [[[NSXMLElement alloc] initWithName:@"operatorPrivateMember" stringValue:[self operatorPrivateMember]] autorelease];

	[thisNode addChild: nodeName];
//later	[thisNode addChild: privateMember];	
	
//later	operatorPrivateMember is in nodes ans attributes
//later	shouldRestoreState is in input attributes only
//later	isInFeedbackLoop is in attribute
	

	NSXMLElement* childHolder = [[[NSXMLElement alloc] initWithName:@"children"] autorelease];
	
	// add sub nodes
	if([_nodesInside count]>0)
	{
		int nodesAdded = 0;
		NSXMLElement* nodeHolder = [[[NSXMLElement alloc] initWithName:@"nodes"] autorelease];
			
		// go thru all child nodes and add their xml to this
		for( SHNode *aNode in  _nodesInside ) 
		{
			/* we dont save info about operatorPrivateMember nodes - what about there inputs etc? */
			if([aNode operatorPrivateMember]==NO){
				NSXMLElement* childNode = [aNode xmlRepresentation];
				int childIndex = [self indexOfChild:aNode];
				NSXMLElement* sindex = [[[NSXMLElement alloc] initWithName:@"index" stringValue:[[NSNumber numberWithInt:childIndex] stringValue]] autorelease];
				[childNode addChild: sindex];

				[nodeHolder addChild: childNode];
				nodesAdded = nodesAdded+1;
			}
		}
		if(nodesAdded>0)
			[childHolder addChild: nodeHolder];
	}
	
	// add inputs
	if([_inputs count]>0)
	{
		int inputsAdded = 0;
		NSXMLElement* inputHolder = [[[NSXMLElement alloc] initWithName:@"inputs"] autorelease];
		for( SHInputAttribute *inputChild in _inputs )
		{
			NSXMLElement* childNode = [inputChild xmlRepresentation];
			int childIndex = [self indexOfChild:inputChild];
			NSXMLElement* sindex = [[[NSXMLElement alloc] initWithName:@"index" stringValue:[[NSNumber numberWithInt:childIndex] stringValue]] autorelease];
			[childNode addChild: sindex];
			[inputHolder addChild: childNode];
			inputsAdded = inputsAdded+1;
		}
		if(inputsAdded>0)
			[childHolder addChild: inputHolder];
	}
	
	// add outputs
	if([_outputs count]>0)
	{
		int outputsAdded = 0;
		NSXMLElement* outputHolder = [[[NSXMLElement alloc] initWithName:@"outputs"] autorelease];

		for( SHOutputAttribute *outputChild in _outputs ) 
		{
			NSXMLElement* childNode = [outputChild xmlRepresentation];
			int childIndex = [self indexOfChild:outputChild];
			NSXMLElement* sindex = [[[NSXMLElement alloc] initWithName:@"index" stringValue:[[NSNumber numberWithInt:childIndex] stringValue]] autorelease];
			[childNode addChild: sindex];
			[outputHolder addChild: childNode];
			outputsAdded = outputsAdded+1;
		}
		if(outputsAdded>0)
			[childHolder addChild: outputHolder];	
	}
	
	// add connections
	if([_shInterConnectorsInside count]>0)
	{
		int connectionsAdded = 0;
		NSXMLElement* connectionHolder = [[[NSXMLElement alloc] initWithName:@"connections"] autorelease];
		for( SHInterConnector *connectorChild in _shInterConnectorsInside )
		{
			SHAttribute *inat, *outat;
			inat = [[connectorChild outSHConnectlet] parentAttribute];
			outat = [[connectorChild inSHConnectlet] parentAttribute];

			NSString* outAtName = [outat saveName];
			NSString* inAtName = [inat saveName];
			NSNumber* outAtIndex = [NSNumber numberWithInt: [self indexOfChild:outat]];
			NSNumber* inAtIndex = [NSNumber numberWithInt: [self indexOfChild:inat]];
			NSAssert([inat saveName]!=nil, @"err");
			NSAssert([outat saveName]!=nil, @"err");
	
			NSXMLElement* connectionNode = [[[NSXMLElement alloc] initWithName:@"connection"] autorelease];
			NSXMLElement* inNode = [[[NSXMLElement alloc] initWithName:@"inAt" stringValue:inAtName] autorelease];
			NSXMLElement* outNode = [[[NSXMLElement alloc] initWithName:@"outAt" stringValue:outAtName] autorelease];
			
			[inNode setAttributesAsDictionary: [NSDictionary dictionaryWithObjectsAndKeys:inAtIndex, @"index", nil]]; // This can bite if an object is nil
			[outNode setAttributesAsDictionary: [NSDictionary dictionaryWithObjectsAndKeys:outAtIndex, @"index", nil]]; // This can bite if an object is nil			
			[connectionNode addChild: inNode];
			[connectionNode addChild: outNode];
			[connectionHolder addChild: connectionNode];
			connectionsAdded = connectionsAdded+1;
		}
		if(connectionsAdded>0)
			[childHolder addChild: connectionHolder];	
	}
	
	if([childHolder childCount])
		[thisNode addChild: childHolder];

	return thisNode;
}

@end
