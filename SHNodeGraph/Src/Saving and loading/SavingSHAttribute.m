//
//  SavingSHAttribute.m
//  SHNodeGraph
//
//  Created by Steve Hooley on 18/01/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import "SavingSHAttribute.h"



/* 
 * SHAttribute
*/
@implementation SHAttribute (SavingSHAttribute) 

- (NSString*)saveName
{
	NSString* nowhiteSpaceAtEnd = [_name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	// Branch 	NSString* UIDasARString = [NSString stringWithFormat:@"%i", [aNode _temporaryID] ];
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

///* 
// * SHInputAttribute
//*/
//@implementation SHInputAttribute (SavingSHInputAttribute) 
//
//
//
//@end
//
///* 
// * SHOutputAttribute
//*/
//@implementation SHOutputAttribute (SavingSHOutputAttribute) 
//
//
//@end
