//
//  FScriptSavingProtoNode.m
//  SHNodeGraph
//
//  Created by Steven Hooley on 10/09/2007.
//  Copyright 2007 HooleyHoop. All rights reserved.
//

#import "FScriptSavingProtoNode.h"
#import "FScriptSavingAttribute.h"
#import "SHInputAttribute.h"
#import "SHOutputAttribute.h"
#import "SavingSHAttribute.h"
#import "SavingSHProto_Node.h"
#import "SHInterConnector.h"
#import "SHConnectlet.h"

/*
 *
*/
@implementation SHNode (FScriptSavingProtoNode)


- (NSString *)fScriptString_duplicateContentsInto:(NSString *)nodeIdentifier_fscript
{
	// Obviously, nodeIdentifier_fscript MUST be the same type as self
	NSString* outputString	= [NSString string];	// autoreleased string
	NSString* saveName = nodeIdentifier_fscript;
	
	// write children
	if([_nodesInside count]>0 || [_inputs count]>0 || [_outputs count]>0)
	{
		// call save on all child nodes
		NSString* childSaveString;

		outputString = [outputString stringByAppendingString:@"\"increase indent\"\n"];

		for( id aNode in [self nodesAndAttributesInside] )
		{
			// if child is a private member it has already been made by now
			if([aNode operatorPrivateMember])
			{
				/* is it a node? */
				if([aNode isKindOfClass:[SHNode class]])
				{
					NSString* childSaveName = [aNode saveName];
					int indexOfChild = [self indexOfChild:aNode]; // IMPORTANT that this index doesnt change for private members
					outputString = [outputString stringByAppendingFormat:@"%@ := %@ nodeAtIndex:%i .\n", childSaveName, saveName, indexOfChild];
	
					childSaveString	= [aNode fScriptString_duplicateContentsInto: childSaveName ];
					NSAssert(childSaveString!=nil, @"er, nil string");
					outputString = [outputString stringByAppendingString: childSaveString];

				/* or an input? */
				} else if([aNode isKindOfClass:[SHInputAttribute class]]) {
				
					// !! if we ever manipulate the index of these private member attributes saving will fail !!
					int indexOfChild = [_inputs indexOfObjectIdenticalTo: aNode];
					if(indexOfChild==NSNotFound){
						NSException* myException = [NSException exceptionWithName:@"unknownInput" reason:@"the input is in _nodesAndAttributesInside but not in _orderedInputs" userInfo:nil];
						[myException raise];
					}
					NSString* childSaveName = [aNode saveName];
					outputString = [outputString stringByAppendingFormat:@"%@ := %@ inputAttributeAtIndex:%i .\n", childSaveName, saveName, indexOfChild];
					
					if([aNode shouldRestoreState])
						childSaveString	= [aNode fScriptString_duplicateContentsInto:childSaveName restoreState:YES];
					else
						childSaveString	= [aNode fScriptString_duplicateContentsInto:childSaveName restoreState:NO];
					NSAssert(childSaveString!=nil, @"er, nil string");
					outputString = [outputString stringByAppendingString: childSaveString];

				/* or an output? */
				} else if([aNode isKindOfClass:[SHOutputAttribute class]]) {
					// leave it - it's parent will make it
				} else {
					NSException* myException = [NSException exceptionWithName:@"unKnownGraphMemeber" reason:@"trying to save something other than node, input or output" userInfo:nil];
					[myException raise];
				}
				
			} else {
			// NOT PRIVATE MEMBER
				/* is it a node? */
				if([aNode isKindOfClass:[SHNode class]])
				{
					childSaveString	= [aNode fScriptString_duplicate];
					NSAssert(childSaveString!=nil, @"er, nil string");
					outputString = [outputString stringByAppendingString: childSaveString];
					NSString* lastLine = [outputString firstWordOfLastLine];
					outputString = [outputString stringByAppendingFormat:@"%@ addChild:%@ autoRename:NO .\n\n", saveName, lastLine];	// if you change this you need to change the indent script
	
				/* or an input? */
				} else if([aNode isKindOfClass:[SHInputAttribute class]]) {
				
					/* we save the values of all nodes tht dont have an input or are in feedback loops */
					/* it is upto you to make sure the feedback flag is up-to-date, usually by calling update before you save */
					if( ([aNode isInletConnected]==NO && [aNode shouldRestoreState]==YES) || [aNode isInFeedbackLoop]==YES )
					{
						childSaveString	= [aNode fScriptString_duplicate];
						NSAssert(childSaveString!=nil, @"er, nil string");
						outputString = [outputString stringByAppendingString: childSaveString];
						NSString* lastLine = [outputString firstWordOfLastLine];
						outputString = [outputString stringByAppendingFormat:@"%@ addChild:%@ autoRename:NO .\n\n", saveName, lastLine];	// if you change this you need to change the indent script
						
					} else {
						childSaveString	= [aNode fScriptString_duplicateWithoutValue];
						NSAssert(childSaveString!=nil, @"er, nil string");
						outputString = [outputString stringByAppendingString: childSaveString];
						NSString* lastLine = [outputString firstWordOfLastLine];
						outputString = [outputString stringByAppendingFormat:@"%@ addChild:%@ autoRename:NO .\n\n", saveName, lastLine];	// if you change this you need to change the indent script
					}
					
				/* or an output? */
				} else if([aNode isKindOfClass:[SHOutputAttribute class]]) {
					if([aNode isInFeedbackLoop])
					{
						childSaveString	= [aNode fScriptString_duplicate];
						NSAssert(childSaveString!=nil, @"er, nil string");
						outputString = [outputString stringByAppendingString: childSaveString];
						NSString* lastLine = [outputString firstWordOfLastLine];
						outputString = [outputString stringByAppendingFormat:@"%@ addChild:%@ autoRename:NO .\n\n", saveName, lastLine];	// if you change this you need to change the indent script
						
					} else {
						// no need to save data
						childSaveString	= [aNode fScriptString_duplicateWithoutValue];
						NSAssert(childSaveString!=nil, @"er, nil string");
						outputString = [outputString stringByAppendingString: childSaveString];
						NSString* lastLine = [outputString firstWordOfLastLine];
						outputString = [outputString stringByAppendingFormat:@"%@ addChild:%@ autoRename:NO .\n\n", saveName, lastLine];	// if you change this you need to change the indent script
					}		
				} else {
					NSException* myException = [NSException exceptionWithName:@"unKnownGraphMemeber" reason:@"trying to save something other than node, input or output" userInfo:nil];
					[myException raise];
				}		
		
			}
		} // end while
		outputString = [outputString stringByAppendingString:@"\"decrease indent\"\n"];

	} // end if childeren

	// call save on all interconnectors
	if([_shInterConnectorsInside count]>0)
	{
		outputString = [outputString stringByAppendingString:@"\"add Interconnectors\"\n"];

		// NSString* connectorSaveString;
		for( SHInterConnector *con in _shInterConnectorsInside )
		{

			SHAttribute *inatt, *outatt;
			
			inatt = [[con inSHConnectlet] parentAttribute];
			outatt = [[con outSHConnectlet] parentAttribute];
			// SH_Path* pathToInNode = [self relativePathToChild:inatt];
			// SH_Path* pathToOutNode = [self relativePathToChild:outatt];
		
			//	SHInterConnector* int1 = [copy connectOutletOfAttribute:newOutAtt toInletOfAttribute:newInAtt];
			outputString = [outputString stringByAppendingFormat:@"ic := %@ connectOutletOfAttribute:%@ toInletOfAttribute:%@ .\n\n", saveName, [outatt saveName], [inatt saveName]];	// if you change this you need to change the indent script

		}	
	}
	
	
		//}		
		//	} else {
		
//		outputString			= [outputString stringByAppendingFormat:@"\"get node built and added by parent node.. %@\"\n", [self name] ];
		// get the auto made node node by name
//		outputString			= [outputString stringByAppendingFormat:@"aNode := %@ nodeWithKey:'%@' .\n", parentString, [self name]];
		// outputString			= [outputString stringByAppendingString:@"sys log: aNode .\n"];
//	}	
	
	// outputString			= [outputString stringByAppendingFormat:@"aNode setUniqueModelID:%i .\n", [self uniqueModelID]];
	
	// [graphModel addNodeToCurrentNodeGroup: aNode];
	// Dont add it again if it wasnt user added. Also dont add it if it is a root node
//	if(![parentString isEqualToString:@"nil"] && operatorPrivateMember==NO)
//	{
//		outputString = [outputString stringByAppendingFormat:@"%@ addNodeToNodeGroup:aNode .\n", parentString];
//	}
	
	
	// save auxilliary data
//	if([_auxiliaryData count]>0)
//	{
//		// logInfo(@"SHProto_Node.m: saveStringWithParent. Nsumber of Aux Objects is %i", [_auxiliaryData count] );
//
//		outputString			= [outputString stringByAppendingFormat:@"\n\"%@ auxilliary data\"\n", [self name] ];
//
//		NSEnumerator *enumerator = [_auxiliaryData keyEnumerator];
//		NSString* auxKey, *auxSaveString;
//		id auxDataObject;
//		while (auxKey = [enumerator nextObject])
//		{
//			auxDataObject		= [_auxiliaryData objectForKey:auxKey];
//			if([auxDataObject respondsToSelector:@selector(saveStringWithParent:)])
//			{
//				// the auxDataObject outputString must define the 'auxDataObject' identifier
//				auxSaveString	= [auxDataObject saveStringWithParent:@"aNode"];
//				outputString	= [outputString stringByAppendingString: auxSaveString ];
//				outputString	= [outputString stringByAppendingFormat:@"aNode setAuxObject:%@ forKey:'%@' .\n", @"auxDataObject", auxKey];
//			}
//		}
//	}

	
	// Maybe set the values of the inlets that are in feedback loops after they have all been connected up
	
	return outputString;
}

- (NSString*)fScriptString_duplicate
{
	// logInfo(@"SHProto_Node.m: writing save string for %@. Operator Private Member is %i",[self class], operatorPrivateMember);
	
	NSString* outputString = [NSString string];	// autoreleased string
	NSString* saveName = [self saveName];

	outputString = [outputString stringByAppendingFormat:@"\"building node.. %@\"\n", [self name] ];
	outputString = [outputString stringByAppendingFormat:@"%@ := %@ newNode .\n", saveName, [self class]];
	outputString = [outputString stringByAppendingFormat:@"%@ setName:'%@' .\n", saveName, [self name] ];

	outputString = [outputString stringByAppendingFormat: [self fScriptString_duplicateContentsInto: saveName] ];
	
	outputString = [outputString stringByAppendingFormat:@"%@ . \n", saveName]; // returns this object
	return outputString;
}



@end
