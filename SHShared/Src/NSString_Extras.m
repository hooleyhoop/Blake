//
//  NSString_Extras.m
//  Shared
//
//  Created by Steve Hooley on 28/07/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import "NSString_Extras.h"


@implementation NSString (NSString_Extras) 

+ (id)stringWithBOOL:(BOOL)value {
	
	return value ? @"YES" : @"NO";
}

- (unichar)firstCharacter
{
    if ([self length]==0)
		return '\0';
    return [self characterAtIndex:0];
}

- (NSString *)lastLine {

	NSUInteger stringLength = [self length];
	NSAssert(stringLength>0, @"er");
	NSRange lastLineRange = [self lineRangeForRange:NSMakeRange(stringLength-1, 0)];
	NSString *aLine = [self substringWithRange:lastLineRange];
	return aLine;
}

- (NSString *)lastLineNoWhiteSpace
{
	NSString* nowhiteSpaceAtEnd = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSString* lastLine = [nowhiteSpaceAtEnd lastLine];
	return lastLine;
}

- (NSString *)firstWordOfLastLine {

	NSString* lastLine = [self lastLineNoWhiteSpace];
	NSArray* lineComponants = [lastLine componentsSeparatedByString:@" "];
	NSString* firstWord = [lineComponants objectAtIndex:0];
	return firstWord;
}

void sortIntoLines( NSString* fileContents, NSMutableArray* allLines ) {
	
	NSCParameterAssert(fileContents);
	NSCParameterAssert(allLines);

	// break the string into lines
	NSString *string = fileContents;
	NSString *aLine;
	unsigned numberOfLines, cindex, stringLength = [string length], startOfNextLine;
	for(cindex = 0, numberOfLines = 0; cindex < stringLength; numberOfLines++)
	{
		startOfNextLine = NSMaxRange([string lineRangeForRange:NSMakeRange(cindex, 0)]);
		aLine = [string substringWithRange:NSMakeRange(cindex, (startOfNextLine-cindex))];
		[allLines addObject:aLine];
		cindex = startOfNextLine;
	}
}

- (BOOL)containsString:(NSString *)aString {
	return [self rangeOfString:aString].location != NSNotFound;
}

- (BOOL)containsCaseInsensitiveString:(NSString *)aString {
	return [self rangeOfString:aString options:NSCaseInsensitiveSearch].location != NSNotFound;
}

//=========================================================== 
// - isNumber:
// - Discussion:
// - Where the hell did i pick up this leaky piece of shit from?
//=========================================================== 
- (BOOL)isNumber:(NSNumber**)aNumber_ptr_ptr
{
	unichar *theCharacters = nil;
	size_t characterCount = 0;	
	characterCount = [self length];
	theCharacters = malloc( (characterCount + 1) * sizeof(unichar) );

	if (theCharacters)
		[self getCharacters: theCharacters];
	else characterCount = 0;


	// do something with each entry in our array
	if (theCharacters != nil) 
	{
		size_t arrayIndex;
		// 1st char must be + - or number
		NSCharacterSet* plusMinus_cs = [NSCharacterSet characterSetWithCharactersInString:@"+-"];
		NSCharacterSet* decimal_cs = [NSCharacterSet decimalDigitCharacterSet];
	
		unichar thisCharacter = theCharacters[0];

		if( [plusMinus_cs characterIsMember:thisCharacter] )
		{
			// + or minus must be followed by a number
			if(characterCount<2){
				free( theCharacters );
				return NO;
			}
			if( ![decimal_cs characterIsMember:theCharacters[1]] ){
				free( theCharacters );
				return NO;
			}
			arrayIndex = 2;
		} else if( [decimal_cs characterIsMember:thisCharacter] )
		{
			// ok
			arrayIndex = 1;
		} else {
			logError(@"charSetNumbers: %@", decimal_cs);
			free( theCharacters );
			return NO;
		}
				// loop through remaining chars
		BOOL decimalPointFound = NO;

		for(arrayIndex=arrayIndex; arrayIndex < characterCount; arrayIndex++)
		{
			thisCharacter = theCharacters[arrayIndex];
			if(!decimalPointFound)
			{
				// see if it is the decimal point
				if(thisCharacter=='.')
				{
					decimalPointFound = YES;
					if(characterCount<arrayIndex+2){
						free( theCharacters );
						return NO; // must be a number after the decimal point
					}
					if(![decimal_cs characterIsMember:theCharacters[arrayIndex+1]] ){
						free( theCharacters );
						return NO;
					}
					arrayIndex++;	// skip the next one as we've just checked it
					continue;
				}
			} 
			
			// all remaining chars must be decimal numbers
			if(![decimal_cs characterIsMember:thisCharacter]){
				free( theCharacters );
				return NO;
			}
		}
		double d = [self doubleValue];
		NSNumber* returnVal = [[[NSNumber alloc] initWithDouble:d ] autorelease];
		// objectPointed To by aNumber_ptr_ptr is *aNumber_ptr_ptr

		*aNumber_ptr_ptr = returnVal;
		free( theCharacters );
		return YES;
	}

	// free the memory allocated for the array so that it doesn't leak
	if (theCharacters)
		free( theCharacters );

	return NO;
}

// Count the number of occurrences of a given substring
- (NSUInteger) occurrencesOfString:(NSString*)subString {
	NSUInteger total = 0;
	NSScanner* scanner = [NSScanner scannerWithString:self];
	[scanner setCaseSensitive:YES];
	[scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@""]];
	[scanner scanUpToString:subString intoString:NULL];
	while ([scanner scanString:subString intoString:NULL]) {
		total++;
		[scanner scanUpToString:subString intoString:NULL];
	}
	return total;
}

- (NSString *)removeLastCharacter {

	return [self substringToIndex:[self length]-1];
}

- (NSString *)makeFirstCharUppercase {

	NSString *firstChar = [[self substringToIndex:1] uppercaseString];
	NSString *theRest = [self substringFromIndex:1];
	return [firstChar stringByAppendingString:theRest];
}

- (NSString *)prepend:(NSString *)value {

	return [value stringByAppendingString:self];
}

- (NSString *)append:(NSString *)value {
	
	return [self stringByAppendingString:value];
}

- (BOOL)beginsWith:(NSString *)value {
	return [self rangeOfString:value].location==0;
}
@end

