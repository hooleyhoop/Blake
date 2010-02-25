//
//  NSString_Extras.h
//  Shared
//
//  Created by Steve Hooley on 28/07/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//


@interface NSString (NSString_Extras) 

+ (id)stringWithBOOL:(BOOL)value;

- (unichar)firstCharacter;

- (NSString *)lastLine;
- (NSString *)lastLineNoWhiteSpace;
- (NSString *)firstWordOfLastLine;

void sortIntoLines( NSString* fileContents, NSMutableArray* allLines );

- (BOOL)containsString:(NSString *)aString;
- (BOOL)containsCaseInsensitiveString:(NSString *)aString;

- (BOOL)isNumber:(NSNumber**)aNumber_ptr_ptr;

- (NSUInteger)occurrencesOfString:(NSString*)subString;	// Count the number of occurrences of a given substring

- (NSString *)removeLastCharacter;
- (NSString *)makeFirstCharUppercase;
- (NSString *)prepend:(NSString *)value;
- (NSString *)append:(NSString *)value;
- (BOOL)beginsWith:(NSString *)value;

@end
