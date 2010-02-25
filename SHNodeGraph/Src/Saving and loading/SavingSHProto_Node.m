//
//  SavingSHProto_Node.m
//  SHNodeGraph
//
//  Created by Steve Hooley on 18/01/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import "SavingSHProto_Node.h"
#import "SHOutputAttribute.h"
#import "SHInputAttribute.h"
#import "SavingSHAttribute.h"
#import "SHInterConnector.h"
#import "SHConnectlet.h"

#define	RESERVED_SAVE_CHAR _

/*
 * NB. feedback loops will not have there input values saved
*/
@implementation SHNode (SavingSHProto_Node)

/*	I cant honestly remember what this save name stuff is all about and whether it is really needed but it 
	definitely was once so i'll keep it for now.. underscore '_' is therefore a reserved character in the name
	(not a very good choice)
*/
+ (NSString *)reverseSaveName:(NSString *)value
{
	return [value substringToIndex:[value rangeOfString:@"_"].location];
}

- (NSString *)saveName
{
	NSString* nowhiteSpaceAtEnd = [_name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	// Branch 	NSString* UIDasARString = [NSString stringWithFormat:@"%i", [aNode temporaryID] ];
	NSRange wsr = [nowhiteSpaceAtEnd rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSString* outputString;
	if(wsr.location==NSNotFound)
	{
		outputString = nowhiteSpaceAtEnd;
	} else {
		// eek this might not work.. what i need is componentsSeparatedByCharacterFromSet.. but i dont think it works
		// it will work as long as the name doesnt have any stupid characters in it
		NSArray* lineComponants = [nowhiteSpaceAtEnd componentsSeparatedByString:@" "];
		outputString = [lineComponants objectAtIndex:0];
		int wordComponents = [lineComponants count];
		for( NSUInteger i=1; i<wordComponents; i++ ){
			NSString *as = [lineComponants objectAtIndex:i];
			NSAssert(as!=nil, @"er, nil string");
			outputString = [outputString stringByAppendingString:as];
		}
	}
	outputString = [outputString stringByAppendingFormat:@"_%i", _temporaryID];
	return outputString;
}


@end


