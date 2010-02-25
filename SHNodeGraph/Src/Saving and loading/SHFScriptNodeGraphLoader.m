//
//  SHFScriptNodeGraphLoader.m
//  Pharm
//
//  Created by Steve Hooley on 15/12/2005.
//  Copyright 2005 HooleyHoop. All rights reserved.
//

#import "SHFScriptNodeGraphLoader.h"
#import <FScript/FScript.h>
#import "SavingSHAttribute.h"
#import "FScriptSavingAttribute.h"
#import "FScriptSavingProtoNode.h"
#import "FScriptSaving_protocol.h"
#import "SHInterConnector.h"
#import "SHConnectlet.h"
#import "SHConnectableNode.h"

// static SHFScriptNodeGraphLoader* _nodeGraphLoader;

/*
 *
*/
@interface SHFScriptNodeGraphLoader (PrivateMethods)

- (NSString *)indentScript:(NSString*)aScript;

@end


/*
 *
*/
@implementation SHFScriptNodeGraphLoader

#pragma mark -
#pragma mark class methods

+ (SHFScriptNodeGraphLoader *)nodeGraphLoader {
	return  [[[SHFScriptNodeGraphLoader alloc] init] autorelease];
}

#pragma mark init methods

- (id)init
{
    if ((self = [super init]) != nil) {

	}
    return self;
}

- (void)dealloc {
	
    [super dealloc];
}


#pragma mark Action methods

- (BOOL)saveNode:aNode toFile:(NSString *)filePath
{
	// prepare node
	
	// make output string
	NSString* outputString = [NSString string];
	outputString = [outputString stringByAppendingString:@"\"Pharm v1.1 fscript file. s.hooley\"\n\n"];
	
	// recursively build the script
	NSString* as=[aNode fScriptString_duplicate];
	NSAssert(as!=nil, @"er, nil string");
	outputString = [outputString stringByAppendingString: as];
	outputString = [outputString stringByAppendingString:@"\n\"finito\""];
	
	// addTabs
	outputString = [self indentScript:outputString]; // maybe do it on the file? i dont know!
	
	// save to file
	NSError *errorStr; 
	if ([outputString writeToFile:filePath atomically:YES encoding:NSASCIIStringEncoding error:&errorStr])
	{
		logInfo(@"SHFScriptNodeGraphLoader.m: Success saving file");
	} else {
		logError (@"SHFScriptNodeGraphLoader.m: Failure saving file: %@ ", [errorStr localizedDescription] );
		return NO;
	}
	return YES;
}

- (SHNode *)loadNodeFromFile:(NSString *)filePath
{
	// [[SHAppControl appControl] disableOpenViews]; move to interface code
	
	NSError *errorStr; 
	NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSASCIIStringEncoding error:&errorStr];
	if (fileContents == nil)
	{
		logError (@"SHFScriptNodeGraphLoader.m: Problem reading file.. '%@' : %@", filePath, [errorStr localizedDescription]);
		return nil;
    }
	
	// execute script
	FSInterpreter* theInterpreter = [FSInterpreter interpreter];
	FSInterpreterResult* execResult = [theInterpreter execute: fileContents];
	id result = nil;
	if([execResult isOK]){
		result = [execResult result];
	} else {
		logError(@"Opening Failed.. ERROR MSG %@", [execResult errorMessage]);
		logError(@"Opening Failed.. ERROR Range %@", NSStringFromRange([execResult errorRange]));
		logError(@"Opening Failed.. ERROR CALL STACK %@", [execResult callStack]);
		logError(@"Opening Failed.. ERROR Is Syntax Error? %i", [execResult isSyntaxError]);
	}
//	logInfo(@"SHFScriptNodeGraphLoader.m: setting new root name result = %@, %@", result, [result name] );
//	[[SHNodeGraphModel graphModel] addRootNode:result forKey:[result name]];
	
	// important - nodes get there temporary ids when they are added to a nodegroup
	// as root nodes donrt live inside a node group we must asign them a uid manually
	//moved-[result setTemporaryID: [SHNodeGraphModel getNewUniqueID] ];	 
	
//	[[SHNodeGraphModel graphModel] setTheCurrentNodeGroup:result];
	
//	[[SHAppControl appControl] enableOpenViews];
//	[[SHAppControl appControl] syncAllViewsWithModel];
	
	logInfo(@"SHFScriptNodeGraphLoader.m: Loaded Script, result = %@, %@", result, [result name] );
	
	return result;
}

- (NSString *)indentScript:(NSString *)aScript
{
	NSString* tabString		= [NSString string];
	NSString* outputString	= [NSString string];
	int numberOfTabs = 0;
	
	// go through all lines
	NSString *aLine, *newLine;
	int indexCase = 0;
	unsigned numberOfLines, i, stringLength = [aScript length], startOfNextLine;
	for (i = 0, numberOfLines = 0; i < stringLength; numberOfLines++)
	{
		startOfNextLine = NSMaxRange([aScript lineRangeForRange:NSMakeRange(i, 0)]);
		aLine = [aScript substringWithRange:NSMakeRange(i, (startOfNextLine-i))];

		// logInfo(@"SHFScriptNodeGraphLoader.m:indentScript %@", aLine );

		if( [aLine containsString:@"increase indent"])
		{
			indexCase = 1;
			// logInfo(@"SHFScriptNodeGraphLoader.m:indentScript YES YES YES YES YES YES YES YES YES YES YES YES YES DOWN" );
			// go down a level
			tabString = [tabString stringByAppendingString:@"\t"];
			// logInfo(@"SHFScriptNodeGraphLoader.m: tabString length is %i", [tabString length] );
			numberOfTabs++;
		} else if( [aLine containsString:@"decrease indent"]) {
			indexCase = 2;
			// logInfo(@"SHFScriptNodeGraphLoader.m:indentScript YES YES YES YES YES YES YES YES YES YES YES YES YES UP" );
			// go up a level
		//	@try {
			tabString = [tabString substringFromIndex:1];
			numberOfTabs--;
			
		//	} @catch (NSException *exception) {
		//		logInfo(@"SHFScriptNodeGraphLoader.m: ERROR Caught %@: %@", [exception name], [exception reason]);
	//		} @finally {
			/* we really must clean up here */
			// logInfo(@"SHAttribute.m: ERROR You need to add clean up code here incase an exception is thrown.");
	//		}
		} else {
			indexCase = 0;
		}
		
		// line	= tabString + line
		switch(indexCase){
			case 1:
				outputString = [outputString stringByAppendingString:@"\n"];
				break;
			case 2:
	//			outputString = [outputString stringByAppendingString:@"\n"];
				break;
			case 0:

				NSAssert(aLine!=nil, @"er, nil string");
				newLine	= [tabString stringByAppendingString:aLine];

				NSAssert(newLine!=nil, @"er, nil string");
				outputString = [outputString stringByAppendingString:newLine];
				break;
		}
		
		i = startOfNextLine;
	}	
	return outputString;
}

- (NSXMLElement *)scriptWrapperFromChildren:(NSArray *)childrenToCopy fromNode:(SHNode *)parentNode {

	NSXMLElement* rootElement = [[[NSXMLElement alloc] initWithName:@"nodes"] autorelease];
	id eachChild;
	NSMutableArray *attributesCopied = [NSMutableArray array];

	for (eachChild in childrenToCopy) 
	{	
		if([eachChild conformsToProtocol:@protocol(FScriptSaving_protocol)] ) // dont directly copy interconnectors, they are indirectly copied if we copy 2 attributes that are linked
		{
			if([eachChild isKindOfClass:[SHAttribute class]])
				[attributesCopied addObject:eachChild];

			NSString* saveString1 = [(id<FScriptSaving_protocol>)eachChild fScriptString_duplicate];
			NSXMLElement* childElement = [[[NSXMLElement alloc] initWithName:@"node" stringValue:saveString1] autorelease];
			[childElement addAttribute:[NSXMLNode attributeWithName:@"saveName" stringValue:[eachChild saveName]]];
			[rootElement addChild:childElement];
		}
	}
	
	// somehow save the interconnectors in a way that will always connect the pasted nodes
	NSMutableArray *interConnectorsCopied = [NSMutableArray array];
	
	for( SHAttribute *copiedAttribute in attributesCopied )
	{
		NSMutableArray *allConnectedInterConnectors = [copiedAttribute allConnectedInterConnectors];
		for( SHInterConnector *eachInterConnector in allConnectedInterConnectors )
		{
			SHAttribute *inend = [[eachInterConnector inSHConnectlet] parentAttribute];
			SHAttribute *outend = [[eachInterConnector outSHConnectlet] parentAttribute];
			NSAssert(inend!=outend, @"I didnt know you could connect like this - but then again ive forgotten what you can do");
			/* check that we are copying both ends of the connector and ensure that we only copy it once */
			if([attributesCopied containsObject:inend] && [attributesCopied containsObject:outend] && [interConnectorsCopied containsObject:eachInterConnector]==NO){
				[interConnectorsCopied addObject: eachInterConnector];
			}
		}
	}

	for( SHInterConnector *eachInterConnector in interConnectorsCopied ){
		// -- add the interconnector
		// THIS BIT IS NOT FSCRIPT!!!
		SHAttribute *inend = [[eachInterConnector inSHConnectlet] parentAttribute];
		SHAttribute *outend = [[eachInterConnector outSHConnectlet] parentAttribute];
		NSXMLElement* connectorElement = [[[NSXMLElement alloc] initWithName:@"interConnector"] autorelease];
		[connectorElement addAttribute:[NSXMLNode attributeWithName:@"inAtt" stringValue:[inend saveName]]];
		[connectorElement addAttribute:[NSXMLNode attributeWithName:@"outAtt" stringValue:[outend saveName]]];
		[rootElement addChild:connectorElement];
	}
	return rootElement;
}

- (BOOL)unArchiveChildrenFromScriptWrapper:(NSXMLElement *)copiedStuffWrapper intoNode:(SHNode *)parentNode {

	NSError *error = nil;
	NSMutableDictionary *savedObjectsDictionary = [NSMutableDictionary dictionary];
	NSArray* nodeStrings = [copiedStuffWrapper objectsForXQuery:@"node" error:&error];
	if(!error)
	{
		NSMutableArray* objectsToAdd = [NSMutableArray array];
		NSString *eachNodeFscript;
		for( NSXMLElement *xmlElement in nodeStrings ) 
		{	
			NSXMLNode* saveNameXML = [xmlElement attributeForName:@"saveName"];
			NSString *saveName = [saveNameXML stringValue]; // we encoded the saveName as an attribute
			eachNodeFscript = [xmlElement stringValue];
			FSInterpreter* theInterpreter = [FSInterpreter interpreter];
			FSInterpreterResult* execResult = [theInterpreter execute: eachNodeFscript];
			id result = nil;
			if([execResult isOK])
			{
				result = [execResult result];
				if(!result){
					logError(@"Failed to execute save string for node");
					return NO;
				}

				if([result conformsToProtocol:@protocol(SHNodeLikeProtocol)]) // could be an interconnector?
				{
					[objectsToAdd addObject:result];
					[savedObjectsDictionary setObject:result forKey:saveName]; // so we can look up when we are addeding the interconnectors
				} else{
					logError(@"unexpected result returned from fscript");
				}
			}
		}
		
		if([objectsToAdd count]>0){
			for( id<SHNodeLikeProtocol> each in objectsToAdd )
				[parentNode addChild:each autoRename:YES];
		}
		
		//	add the connectors - These are !not! FScript! Is this wrong?
		NSArray* connectorStrings = [copiedStuffWrapper objectsForXQuery:@"interConnector" error:&error];
		{
			if(!error)
			{
				for( xmlElement in connectorStrings ) 
				{
					NSXMLNode* inAttXML = [xmlElement attributeForName:@"inAtt"];
					NSXMLNode* outAttXML = [xmlElement attributeForName:@"outAtt"];
					NSString *inAttSaveName = [inAttXML stringValue]; // we encoded the saveName as an attribute
					NSString *outAttSaveName = [outAttXML stringValue]; // we encoded the saveName as an attribute
					SHAttribute *outAtt = [savedObjectsDictionary objectForKey:outAttSaveName];
					SHAttribute *inAtt = [savedObjectsDictionary objectForKey:inAttSaveName];
	
					//		connect
					// SHInterConnector *ic1 =
					[parentNode connectOutletOfAttribute:outAtt toInletOfAttribute:inAtt ];
				}
			}
		}
	}
	return YES;
}

@end
