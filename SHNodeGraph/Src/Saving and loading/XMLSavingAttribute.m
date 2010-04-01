//
//  XMLSavingAttribute.m
//  SHNodeGraph
//
//  Created by Steven Hooley on 04/09/2007.
//  Copyright 2007 HooleyHoop. All rights reserved.
//

#import "XMLSavingAttribute.h"
#import "SavingSHAttribute.h"
#import "SHNode.h"
#import "SHInputAttribute.h"

@implementation SHAttribute (XMLSavingAttribute)

+ (SHAttribute *)newAttributeWithXMLElement:(NSXMLElement *)value
{	
	id makeAttribute = nil;
	
	// -- get root
	// make a node with name // check that name is 'node'
	NSError* error = nil;
	NSString* name = [value name];
	if([name isEqualToString:@"attribute"])
	{
		NSString* attributeClass = [[value attributeForName:@"class"] stringValue];
		NSString *nameValue = [[[value objectsForXQuery:@"name" error:&error] lastObject] stringValue];
		if(attributeClass!=nil && nameValue!=nil)
		{
			makeAttribute = [NSClassFromString(attributeClass) makeAttribute];
			[(id<SHNodeLikeProtocol>)makeAttribute setName: nameValue];
			
//			NSXMLElement* indexElement = [[value objectsForXQuery:@"index" error:&error] lastObject];
			NSXMLElement* valueElement = [[value objectsForXQuery:@"value" error:&error] lastObject];
			NSXMLNode* dataTypeElement = [valueElement attributeForName:@"dataType"];

			NSString* valueString = [valueElement stringValue];
			NSString* dataTypeString = [dataTypeElement stringValue];
			logInfo(@"duff %i, %@, %@", index, valueString, dataTypeString);
			if([valueString length]==0)
				valueString=nil;
			// where does restore value get set?
			if(valueString && dataTypeString)
				[makeAttribute setDataType:dataTypeString withValue:valueString];
			else if(dataTypeString)
				[makeAttribute setDataType:dataTypeString];
			else 
				logError(@"Please make this an NSERROR");
		}
	}
	return makeAttribute;
}


- (NSXMLElement *)xmlRepresentation
{
	/* make a new xmlNode with class and name */
	NSXMLElement* thisAttribute = [[[NSXMLElement alloc] initWithName:@"attribute"] autorelease];
	[thisAttribute setAttributesAsDictionary: [NSDictionary dictionaryWithObjectsAndKeys:[self class], @"class", nil]]; // This can bite if an object is nil
	NSXMLElement* attrName = [[[NSXMLElement alloc] initWithName:@"name" stringValue:[self saveName]] autorelease];
	[thisAttribute addChild: attrName];
	
	/* index - moved to parent */
	// int myIndex = [parentSHNode indexOfChild:self];
	// NSXMLElement* indexElement = [[[NSXMLElement alloc] initWithName:@"index" stringValue:[[NSNumber numberWithInt:myIndex] stringValue]] autorelease];
	// [thisAttribute addChild: indexElement];

	/* value */
	NSXMLElement* valueElement = [[[NSXMLElement alloc] initWithName:@"value"] autorelease];
	[valueElement setAttributesAsDictionary: [NSDictionary dictionaryWithObjectsAndKeys:[self dataType], @"dataType", nil]]; // This can bite if an object is nil

	if([self isKindOfClass:[SHInputAttribute class]])
	{
		/* we save the values of all nodes tht dont have an input or are in feedback loops */
		/* it is upto you to make sure the feedback flag is up-to-date, usually by calling update before you save */
		if( ([self isInletConnected]==NO && [(SHInputAttribute *)self shouldRestoreState]==YES) || [self isInFeedbackLoop]==YES )
		{
			 [valueElement setStringValue:[_value stringValue]];
		} else {
			/* Dont set value */
		}
	/* or an output? */
	} else if([self isKindOfClass:[SHOutputAttribute class]]) {
		if([self isInFeedbackLoop])
		{
			 [valueElement setStringValue:[_value stringValue]];
		} else {
			// no need to save data
		}		
	}			
	[thisAttribute addChild: valueElement];

	
	return thisAttribute;
}

@end
