//
//  BKFoundationProtocols.m
//  Blocks
//
//  Created by Jesse Grosjean on 4/1/06.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKFoundationProtocols.h"
#include <openssl/md5.h>
#include <openssl/sha.h>
#include <sys/param.h>
#include <sys/mount.h>

@implementation NSString (BKFoundationAdditions)

+ (NSString *)uniqueString {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    NSString *uString = (NSString *)CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return [uString autorelease];
}

- (NSString *)md5Digest {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char* digest = MD5([data bytes], [data length], NULL);
    return [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
	digest[0], digest[1], 
	digest[2], digest[3],
	digest[4], digest[5],
	digest[6], digest[7],
	digest[8], digest[9],
	digest[10], digest[11],
	digest[12], digest[13],
	digest[14], digest[15]];
}

- (NSString *)sha1Digest {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char* digest = SHA1([data bytes], [data length], NULL);
    return [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
	digest[0], digest[1], 
	digest[2], digest[3],
	digest[4], digest[5],
	digest[6], digest[7],
	digest[8], digest[9],
	digest[10], digest[11],
	digest[12], digest[13],
	digest[14], digest[15],
	digest[16], digest[17],
	digest[18], digest[19]];
}

- (NSString *)stringByEscapingEntities {
    int length = [self length];
    int i;
    
    NSMutableString *result = nil;
    
    for (i = 0; i < length; i++) {
		unichar ch = result ? [result characterAtIndex:i] : [self characterAtIndex:i];
		
		switch (ch) {
			case '&':
				if (!result) result = [[self mutableCopy] autorelease];
				[result replaceCharactersInRange:NSMakeRange(i, 1) withString:@"&amp;"];
				i += 4;
				length += 4;
				break;
			
			case '>':
				if (!result) result = [[self mutableCopy] autorelease];
				[result replaceCharactersInRange:NSMakeRange(i, 1) withString:@"&gt;"];
				i += 3;
				length += 3;
				break;
			
			case '<':
				if (!result) result = [[self mutableCopy] autorelease];
				[result replaceCharactersInRange:NSMakeRange(i, 1) withString:@"&lt;"];
				i += 3;
				length += 3;
				break;
			
			case '"':
				if (!result) result = [[self mutableCopy] autorelease];
				[result replaceCharactersInRange:NSMakeRange(i, 1) withString:@"&quot;"];
				i += 5;
				length += 5;
				break;
			
//			case '\n':
//				if (!result) result = [[self mutableCopy] autorelease];
//				[result replaceCharactersInRange:NSMakeRange(i, 1) withString:@"&#10;"];
//				i += 4;
//				length += 4;
//				break;
			
			default:
				break;
		}
    }
    
    if (result) {
		return result;
    } else {
		return self;
    }
}

- (NSString *)stringByUnescapingEntities {
    NSMutableString *result = [[self mutableCopy] autorelease];
    [result replaceOccurrencesOfString:@"&amp;" withString:@"&" options:0 range:NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString:@"&gt;" withString:@">" options:0 range:NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString:@"&lt;" withString:@"<" options:0 range:NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString:@"&quot;" withString:@"\"" options:0 range:NSMakeRange(0, [result length])];
//    [result replaceOccurrencesOfString:@"&#10;" withString:@"\n" options:0 range:NSMakeRange(0, [result length])];
    return result;
}

- (NSString *)stringByEscapingFilenameBackslashes {
	if ([self rangeOfString:@"/"].location != NSNotFound) {
		NSMutableString *result = [NSMutableString stringWithString:self];
		[result replaceOccurrencesOfString:@"/" withString:@":" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [result length])];
		return result;
	}
	return self;
}

- (NSString *)stringByUnescapingFilenameBackslashes {
	if ([self rangeOfString:@":"].location != NSNotFound) {
		NSMutableString *result = [NSMutableString stringWithString:self];
		[result replaceOccurrencesOfString:@":" withString:@"/" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [result length])];
		return result;
	}
	return self;
}

- (NSString *)utiFromPath {
	NSString *result = nil;
	
//	if ([[NSFileManager defaultManager] fileExistsAtPath:self]) {
		MDItemRef item = MDItemCreate(kCFAllocatorDefault, (CFStringRef)self);
		if (item != NULL) {
			result = (NSString *) MDItemCopyAttribute(item, kMDItemContentType);
			CFRelease(item);
		}
//	}
	
	return [result autorelease];
}

- (NSArray *)extensionsAndOSTypesFromUTI {
	NSMutableSet *types = [NSMutableSet set];
	NSDictionary *declaration = (NSDictionary *) UTTypeCopyDeclaration((CFStringRef)self);
	NSDictionary *specification = [declaration objectForKey:@"UTTypeTagSpecification"];
	id extensions = [specification objectForKey:@"public.filename-extension"];
	id osTypes = [specification objectForKey:@"com.apple.ostype"];
	
	if (extensions) {
		if ([extensions isKindOfClass:[NSArray class]]) {
			[types addObjectsFromArray:extensions];
		} else {
			[types addObject:extensions];
		}
	}

	if (osTypes) {
		if ([osTypes isKindOfClass:[NSArray class]]) {
			[types addObjectsFromArray:osTypes];
		} else {
			[types addObject:osTypes];
		}
	}
			
	[declaration release];

	return [types allObjects];
}

- (NSString *)extractNameFromContent:(int)maxLength {
	NSString *trimmedString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *name = [[trimmedString substringWithRange:[trimmedString lineRangeForRange:NSMakeRange(0,0)]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];    
    if ([name length] > maxLength) {
		name = [[name substringWithRange:NSMakeRange(0, maxLength - 3)] stringByAppendingString:@"..."];
    }
	return name;
}

- (unsigned int)wordCountInRange:(NSRange)inRange paragraphCount:(unsigned int *)paragraphCount {
    if (inRange.length == 0) {
        if (paragraphCount) *paragraphCount = 0;        
        return 0;
    }

    if (paragraphCount) {
		unsigned int length = [self length];
		NSRange range = NSMakeRange(0, 0);
		*paragraphCount = 0;
		
		while (range.location != NSNotFound) {
			range = [self paragraphRangeForRange:range];
			range.location = NSMaxRange(range);
			range.length = 0;
			*paragraphCount = *paragraphCount + 1;
			
			if (NSMaxRange(range) == NSMaxRange(inRange)) {
				range.location = NSNotFound;
			}
		}
	}
	
	return [[NSSpellChecker sharedSpellChecker] countWordsInString:self language:nil];
}

- (NSArray *)componentsSeparatedByLineSeparators {
	NSMutableArray *result = [NSMutableArray array];
	NSRange range = NSMakeRange(0,0);
	unsigned int length = [self length];
	unsigned int start = 0;
	unsigned int end = 0;
	unsigned int contentsEnd = 0;
	
	while (contentsEnd < length) {
		[self getLineStart:&start end:&end contentsEnd:&contentsEnd forRange:range];
		[result addObject:[self substringWithRange:NSMakeRange(start,contentsEnd-start)]];
		range.location = contentsEnd + 1;
		range.length = 0;
	}
	
	return result;
}

/*
- (NSString *)stringFromTextClipping:(NSString *)textClippingPath {
	FSRef ref;
	
    if (FSPathMakeRef ((const UInt8 *)[textClippingPath fileSystemRepresentation], &ref, NULL) == noErr) {
        short res = FSOpenResFile (&ref, fsRdPerm);
        if (ResError() == noErr) {
			NSData *theData = [self dataForType:aType Id:anID];
			
			return theData ? [NSString stringWithPascalString:(ConstStr255Param)[theData bytes]] : nil;
			
            // Code that calls Resource Manager functions to read resources
            // goes here.
            CloseResFile(res);
        }
    }
	
	return nil;
}
*/

@end

NSComparisonResult NBCompareUsingSortSelectors(id object1, id object2, NSArray *sortDescriptors) {
    unsigned index = 0;
    unsigned count = [sortDescriptors count];
    NSComparisonResult result = NSOrderedSame;
    
    while (index < count && result == NSOrderedSame) {
		NSSortDescriptor *sortDescriptor = [sortDescriptors objectAtIndex:0];
		result = [sortDescriptor compareObject:object1 toObject:object2];
		index++;
    }
    return result;    
}

unsigned NBInsertIndex(NSArray *array, id object, unsigned start, unsigned count, NSArray *sortDescriptors) {
    if (count == 0) {
		return start;
    } else if (count == 1) {
		switch (NBCompareUsingSortSelectors([array objectAtIndex:start], object, sortDescriptors)) {
			case NSOrderedAscending:
			case NSOrderedSame:
				return start + 1;
			case NSOrderedDescending:
				return start;
		}
    } else {
		unsigned j = start + count / 2;
		
		switch (NBCompareUsingSortSelectors([array objectAtIndex:j], object, sortDescriptors)) {
			case NSOrderedAscending:
				return NBInsertIndex(array, object, j, count - count / 2, sortDescriptors);
			case NSOrderedSame:
				return j + 1;
			case NSOrderedDescending:
				return NBInsertIndex(array, object, start, count / 2, sortDescriptors);
		}
    }
    
    return NSNotFound;
}

@implementation NSArray (BKFoundationAdditions)

- (id)firstObject {
    if ([self count] > 0) return [self objectAtIndex:0];
    return nil;
}

- (unsigned)insertIndexForObject:(id)object withSortDescriptors:(NSArray *)sortDescriptors {
    return NBInsertIndex(self, object, 0, [self count], sortDescriptors);
}

- (NSArray *)arrayByRemovingObject:(id)object {
	NSMutableArray *copy = [self mutableCopy];
	[copy removeObject:object];
	return [copy autorelease];
}

#pragma mark util

- (NSArray *)filePathsToFileURLs {
	NSMutableArray *fileURLs = [[[NSMutableArray alloc] initWithCapacity:[self count]] autorelease];
	NSEnumerator *enumerator = [self objectEnumerator];
	id each;
	
	while (each = [enumerator nextObject]) {
		[fileURLs addObject:[NSURL fileURLWithPath:each]];
	}
	
	return fileURLs;
}

@end

@implementation NSMutableArray (BKFoundationAdditions)

- (void)insertObject:(id)newObject after:(id)object {
    [self insertObject:newObject atIndex:[self indexOfObject:object] + 1];
}

- (void)insertObject:(id)newObject before:(id)object {
    [self insertObject:newObject atIndex:[self indexOfObject:object]];
}

- (void)fillToLength:(unsigned)length with:(id)object {
    unsigned i;
    for (i = 0; i < length; i++) {
		[self addObject:object];
    }
}

#pragma mark queue

- (BOOL)enqueueObject:(id)object {
	if (!object) 
		return NO;
	
	[self addObject:object];
}

- (id)dequeueObject {
	if ([self count] > 0) {
		id result = [[self objectAtIndex:0] retain];
		[self removeObjectAtIndex:0];
		return [result autorelease];
	}
	return nil;
}

@end

@implementation NSAttributedString (BKAttributedStringAdditions)

+ (NSAttributedString *)readStringAtURL:(NSURL *)url error:(NSError **)error {
	NSMutableAttributedString *reader = [[[NSMutableAttributedString alloc] init] autorelease];
	
	if ([reader readFromURL:url options:nil documentAttributes:nil error:error]) {
		return reader;
	} else {
		return nil;
	}	
}

@end

@implementation NSDictionary (BKFoundationAdditions)

- (BOOL)boolForKey:(id)key {
    id object = [self objectForKey:key];
    if (!object) {
		return NO;
    } else {
		return [object boolValue];
    }
}

- (NSRect)rectForKey:(id)key {
    NSString *rectString = [self objectForKey:key];
    if (!rectString) {
		return NSZeroRect;
    } else {
		return NSRectFromString(rectString);
    }
}

- (float)floatForKey:(id)key {
    NSNumber *value = [self objectForKey:key];
    if (value) {
		return [value floatValue];
    } else {
		return 0;
    }
}

- (int)intForKey:(id)key {
    NSNumber *value = [self objectForKey:key];
    if (value) {
		return [value intValue];
    } else {
		return 0;
    }
}

- (NSSize)sizeForKey:(id)key {
    NSString *sizeString = [self objectForKey:key];
    if (!sizeString) {
		return NSZeroSize;
    } else {
		return NSSizeFromString(sizeString);
    }
}

@end

@implementation NSMutableDictionary (BKFoundationAdditions)

- (void)setBool:(BOOL)boolean forKey:(id)key {
    [self setObject:[NSNumber numberWithBool:boolean] forKey:key];
}

- (void)setRect:(NSRect)rect forKey:(id)key {
    [self setObject:NSStringFromRect(rect) forKey:key];
}

- (void)setFloat:(float)value forKey:(id)key {
    [self setObject:[NSNumber numberWithFloat:value] forKey:key];
}

- (void)setInt:(int)value forKey:(id)key {
    [self setObject:[NSNumber numberWithInt:value] forKey:key];
}

- (void)setSize:(NSSize)size forKey:(id)key {
    [self setObject:NSStringFromSize(size) forKey:key];
}

@end

@implementation NSEnumerator (BKFoundationAdditions)

+ (NSEnumerator *)emptyEnumerator {
    static NSEnumerator *emptyEnumerator = nil;
    if (!emptyEnumerator) {
        emptyEnumerator = [[[NSArray array] objectEnumerator] retain];
    }
    return emptyEnumerator;
}

- (id)objectAtIndex:(unsigned int)index {
	unsigned int i = 0;
	id each;
	
	while (each = [self nextObject]) {
		if (i == index) return each;
		i++;
	}
	
	return nil;
}

- (unsigned int)indexOfObject:(id)object {
	unsigned int i = 0;
	id each;
	
	while (each = [self nextObject]) {
		if (each == object) return i;
		i++;
	}
	
	return NSNotFound;
}

@end

@implementation NSDate (BKFoundationAdditions)

- (NSCalendarDate *)startOf:(BKDateIntervalType)intervalType {
	NSCalendarDate *date = [NSCalendarDate dateWithTimeIntervalSinceReferenceDate:[self timeIntervalSinceReferenceDate]];
	
	switch (intervalType) {
		case BKDayInterval:
			return [[[NSCalendarDate alloc] initWithYear:[date yearOfCommonEra] month:[date monthOfYear] day:[date dayOfMonth] hour:0 minute:0 second:0 timeZone:[date timeZone]] autorelease];
			
		case BKWeekInterval:
			return [[[NSCalendarDate alloc] initWithYear:[date yearOfCommonEra] month:[date monthOfYear] day:[date dayOfMonth] - [date dayOfWeek] hour:0 minute:0 second:0 timeZone:[date timeZone]] autorelease];
			
		case BKMonthInterval:
			return [[[NSCalendarDate alloc] initWithYear:[date yearOfCommonEra] month:[date monthOfYear] day:1 hour:0 minute:0 second:0 timeZone:[date timeZone]] autorelease];
			
		case BKYearInterval:
			return [[[NSCalendarDate alloc] initWithYear:[date yearOfCommonEra] month:1 day:1 hour:0 minute:0 second:0 timeZone:[date timeZone]] autorelease];
		
		default:
			logError(@"got bad interval type");
			break;
	}
	
	return nil;
}

- (NSCalendarDate *)endOf:(BKDateIntervalType)intervalType {
	NSCalendarDate *date = [NSCalendarDate dateWithTimeIntervalSinceReferenceDate:[self timeIntervalSinceReferenceDate]];
	
	switch (intervalType) {
		case BKDayInterval:
			return [[[[NSCalendarDate alloc] initWithYear:[date yearOfCommonEra] month:[date monthOfYear] day:[date dayOfMonth] + 1 hour:0 minute:0 second:0 timeZone:[date timeZone]] autorelease] addTimeInterval:-0.1];
			
		case BKWeekInterval:
			return [[[[NSCalendarDate alloc] initWithYear:[date yearOfCommonEra] month:[date monthOfYear] day:[date dayOfMonth] + (7 - [date dayOfWeek]) hour:0 minute:0 second:0 timeZone:[date timeZone]] autorelease]  addTimeInterval:-0.1];
			
		case BKMonthInterval:
			return [[[[NSCalendarDate alloc] initWithYear:[date yearOfCommonEra] month:[date monthOfYear] + 1 day:1 hour:0 minute:0 second:0 timeZone:[date timeZone]] autorelease] addTimeInterval:-0.1];
			
		case BKYearInterval:
			return [[[[NSCalendarDate alloc] initWithYear:[date yearOfCommonEra] + 1 month:1 day:1 hour:0 minute:0 second:0 timeZone:[date timeZone]] autorelease] addTimeInterval:-0.1];
			
		default:
			logError(@"got bad interval type");
			break;
	}
	
	return nil;
}

- (NSCalendarDate *)back:(int)interval intervalType:(BKDateIntervalType)intervalType {
	NSCalendarDate *date = [NSCalendarDate dateWithTimeIntervalSinceReferenceDate:[self timeIntervalSinceReferenceDate]];
	
	switch (intervalType) {
		case BKDayInterval:
			return [[[NSCalendarDate alloc] initWithYear:[date yearOfCommonEra] month:[date monthOfYear] day:[date dayOfMonth] - interval hour:[date hourOfDay] minute:[date minuteOfHour] second:[date secondOfMinute] timeZone:[date timeZone]] autorelease];
			
		case BKWeekInterval:
			return [[[NSCalendarDate alloc] initWithYear:[date yearOfCommonEra] month:[date monthOfYear] day:[date dayOfMonth] - (7 * interval) hour:[date hourOfDay] minute:[date minuteOfHour] second:[date secondOfMinute] timeZone:[date timeZone]] autorelease];
			
		case BKMonthInterval:
			return [[[NSCalendarDate alloc] initWithYear:[date yearOfCommonEra] month:[date monthOfYear] - interval day:[date dayOfMonth] hour:[date hourOfDay] minute:[date minuteOfHour] second:[date secondOfMinute] timeZone:[date timeZone]] autorelease];
			
		case BKYearInterval:
			return [[[NSCalendarDate alloc] initWithYear:[date yearOfCommonEra] - interval month:[date monthOfYear] day:[date dayOfMonth] hour:[date hourOfDay] minute:[date minuteOfHour] second:[date secondOfMinute] timeZone:[date timeZone]] autorelease];
			
		default:
			logError(@"got bad interval type");
			break;
	}
	
	return nil;
}

- (NSCalendarDate *)forward:(int)interval intervalType:(BKDateIntervalType)intervalType {
	return [self back:-interval intervalType:intervalType];
}

@end

@implementation NSURL (BKFoundationAdditions)

- (NSDictionary *)parameters {
	NSString *parameterString = [self parameterString];
	
	if ([parameterString length] > 0) {
		NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
		NSScanner *scanner = [NSScanner scannerWithString:parameterString];
		
		while (![scanner isAtEnd]) {
			NSString *key = nil;
			NSString *value = nil;
			
			if ([scanner scanUpToString:@"=" intoString:&key] && [scanner scanString:@"=" intoString:NULL] && [scanner scanUpToString:@"&" intoString:&value]) {
				[parameters setObject:value forKey:key];
			}
		}
		
		return parameters;
	}
	
	return nil;
}

- (NSURL *)URLWithParameters:(NSDictionary *)newParameters {
	NSString *relativeString = [self relativeString];
	NSString *parameterString = [self parameterString];
	
	if ([parameterString length] > 0) {
		relativeString = [relativeString substringToIndex:[relativeString rangeOfString:parameterString].location - 1];
	}
	
	NSMutableString *newRelativeString = [[relativeString mutableCopy] autorelease];
	
	BOOL isFirst = YES;
	NSEnumerator *enumerator = [newParameters keyEnumerator];
	NSString *key;
	
	while (key = [enumerator nextObject]) {
		if (isFirst) {
			[newRelativeString appendFormat:@";%@=%@", key, [newParameters objectForKey:key], nil];
			isFirst = NO;
		} else {
			[newRelativeString appendFormat:@"&%@=%@", key, [newParameters objectForKey:key], nil];
		}
	}
	
	return [NSURL URLWithString:newRelativeString];
}

@end

@implementation NSDateFormatter (BKFoundationAdditions)

static NSDateFormatter *sharedDateFormatter = nil;

+ (NSDate *)dateFromString:(NSString *)string {
	if (!sharedDateFormatter) sharedDateFormatter = [[NSDateFormatter alloc] initWithDateFormat:nil allowNaturalLanguage:YES];
	return [sharedDateFormatter dateFromString:string];
}

// XXX not complete, but seems to work with 10.4 formats generated by NSDateFormatterShortStyle, NSDateFormatterMediumStyle, and NSDateFormatterLongStyle
- (NSString *)osx10_0CompatibleDataFormat {
	if ([self formatterBehavior] == NSDateFormatterBehavior10_4) {
		NSDictionary *newFormatToOldFormatLookUpTable = [NSDictionary dictionaryWithObjectsAndKeys:
			//		@"%a", @"",
			//		@"%A", @"",
			@"%b", @"MMM",
			@"%B", @"MMMM",
			@"%d", @"dd",
			@"%e", @"d",
			//		@"%F", @"",
			@"%H", @"H",
			@"%H", @"HH",
			@"%I", @"h",
			@"%I", @"hh",
			@"%j", @"D",
			@"%j", @"DD",
			@"%m", @"MM",
			@"%m", @"M",
			@"%M", @"mm",
			@"%M", @"m",
			@"%p", @"a",
			@"%S", @"s",
			//		@"%w", @"",
			@"%y", @"y",
			@"%y", @"yy",
			@"%Y", @"yyy",
			@"%Y", @"yyyy",
			@"%Z", @"Z",
			@"%Z", @"ZZ",
			nil];
		
		NSMutableString *resultOldStyleStringFormat = [NSMutableString string];
		NSScanner *scanner = [NSScanner scannerWithString:[self dateFormat]];
		NSCharacterSet *alphanumericCharacterSet = [NSCharacterSet alphanumericCharacterSet];
		NSCharacterSet *invertedAlphanumericCharacterSet = [alphanumericCharacterSet invertedSet];
		BOOL scanAlphanumberic = YES;
		
		[scanner setCharactersToBeSkipped:nil];
		
		while ([scanner isAtEnd] == NO) {
			NSString *scanString = nil;
			if (scanAlphanumberic) {
				if ([scanner scanCharactersFromSet:alphanumericCharacterSet intoString:&scanString]) {
					NSString *lookUpString = [newFormatToOldFormatLookUpTable objectForKey:scanString];
					if (lookUpString) {
						[resultOldStyleStringFormat appendString:lookUpString];
					} else {
						[resultOldStyleStringFormat appendString:scanString];
					}
				}
			} else {
				if ([scanner scanCharactersFromSet:invertedAlphanumericCharacterSet intoString:&scanString]) {
					[resultOldStyleStringFormat appendString:scanString];
				}
			}
			
			scanAlphanumberic = !scanAlphanumberic;
		}
		
		return resultOldStyleStringFormat;	
	} else {
		return [self dateFormat];
	}
}

@end

@implementation NSNumberFormatter (BKFoundationAdditions)

static NSNumberFormatter *sharedNumberFormatter = nil;

+ (NSNumber *)numberFromString:(NSString *)string {
	if (!sharedNumberFormatter) {
		sharedNumberFormatter = [[NSNumberFormatter alloc] init];
		[sharedNumberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	}
	return [sharedNumberFormatter numberFromString:string];
}

+ (NSString *)stringFromNumber:(NSNumber *)number {
	if (!sharedNumberFormatter) {
		sharedNumberFormatter = [[NSNumberFormatter alloc] init];
		[sharedNumberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	}
	return [sharedNumberFormatter stringFromNumber:number];
}

@end

@implementation NSFileManager (BKFoundationAdditions)

- (NSString *)uniqueTempPath {
    return [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString uniqueString]];
}

- (NSString *)uniqueFilePathForDirectory:(NSString *)directory preferedName:(NSString *)preferedName {
    if (!preferedName) preferedName = BKLocalizedString(@"Untitled", nil);
    if ([preferedName length] > 250) {
		preferedName = [preferedName substringToIndex:250];	
	}
    if ([preferedName rangeOfString:@"/"].location != NSNotFound) {
		NSMutableString *mutableString = [NSMutableString stringWithString:preferedName];
		[mutableString replaceOccurrencesOfString:@"/"
									   withString:@":"
										  options:NSCaseInsensitiveSearch
											range:NSMakeRange(0, [mutableString length])];
		preferedName = mutableString;
    }
    
    NSString *name = [preferedName stringByDeletingPathExtension];
    NSString *extension = [preferedName pathExtension];
    BOOL hasExtension = [extension length] > 0;
    unsigned count = 0;
	
    NSString *result = nil;
	
    do {
		result = name;
		
		if (count == 0) {
			if (hasExtension) {
				result = [name stringByAppendingPathExtension:extension];
			}
		} else {
			result = [name stringByAppendingString:[NSString stringWithFormat:@" %i", count, nil]];
			if (hasExtension) {
				result = [result stringByAppendingPathExtension:extension];
			}
		}
		
		result = [directory stringByAppendingPathComponent:result];
		count++;
    } while ([self fileExistsAtPath:result]);
	
    return result;
}

- (NSString *)processesApplicationSupportFolder {
	NSString *process = [[NSProcessInfo processInfo] processName];
	NSString *applicationSupportFolder = [[NSFileManager defaultManager] findSystemFolderType:kApplicationSupportFolderType forDomain:kUserDomain];
	NSString *processesApplicationSupportFolder = [applicationSupportFolder stringByAppendingPathComponent:process];
	BOOL isDirectory;
	
	if (![self fileExistsAtPath:processesApplicationSupportFolder isDirectory:&isDirectory]) {
		if (![self createDirectoryAtPath:processesApplicationSupportFolder attributes:nil]) {
			logError(([NSString stringWithFormat:@"failed to create directory %@", processesApplicationSupportFolder]));
			return nil;
		}
	} else if (!isDirectory) {
		logError(([NSString stringWithFormat:@"non directory file already exists at %@", processesApplicationSupportFolder]));
		return nil;
	}
	
	return processesApplicationSupportFolder;
}

- (NSString *)findSystemFolderType:(int)folderType forDomain:(int)domain { 
	FSRef folder; 
	OSErr err = noErr; 
	CFURLRef url; 
	NSString *result = nil; 
	
	err = FSFindFolder(domain, folderType, false, &folder); 
	
	if (err == noErr) {
		url = CFURLCreateFromFSRef(kCFAllocatorDefault, &folder); 
		result = [(NSURL *)url path];
		CFRelease(url);
	}
	
	return result; 
} 

- (BOOL)isPathOnWebDAVFileSystem:(NSString *)path {
	struct statfs fsInfo;
	
	if (statfs([path UTF8String], &fsInfo) == -1) {
		if (statfs([[path stringByDeletingLastPathComponent] UTF8String], &fsInfo) == -1) {
			return NO;
		}
	}
	
	if ([[NSString stringWithFormat:@"%s", fsInfo.f_fstypename] isEqualToString:@"webdav"]) {
		return YES;
	}
	
	return NO;
}

@end

@interface BKIncludePredicate : NSPredicate {
	NSArray *includedObjects;
}

- (id)initWithIncludedObjects:(NSArray *)newIncludedObjects;

@end

@interface BKExcludePredicate : NSPredicate {
	NSArray *excludedObjects;
}

- (id)initWithExcludedObjects:(NSArray *)newExcludedObjects;

@end

@implementation NSPredicate (BKFoundationAdditions)

+ (NSDictionary *)defaultSubstitutionVariables {
	NSDate *date = [NSDate date];
	
	return [NSDictionary dictionaryWithObjectsAndKeys:
		[date startOf:BKDayInterval], NSPredicateStartOfDaySubstitutionVariable,
		[date endOf:BKDayInterval], NSPredicateEndOfDaySubstitutionVariable,
		[date startOf:BKWeekInterval], NSPredicateStartOfWeekSubstitutionVariable,
		[date endOf:BKWeekInterval], NSPredicateEndOfWeekSubstitutionVariable,
		[[date back:1 intervalType:BKWeekInterval] startOf:BKWeekInterval], NSPredicateStartOfLastWeekSubstitutionVariable,
		[[date back:1 intervalType:BKWeekInterval] endOf:BKWeekInterval], NSPredicateEndOfLastWeekSubstitutionVariable,
		[date startOf:BKMonthInterval], NSPredicateStartOfMonthSubstitutionVariable,
		[date endOf:BKMonthInterval], NSPredicateEndOfMonthSubstitutionVariable,
		[date startOf:BKYearInterval], NSPredicateStartOfYearSubstitutionVariable,
		[date endOf:BKYearInterval], NSPredicateEndOfYearSubstitutionVariable,
		nil];
}

+ (NSPredicate *)predicate:(NSPredicate *)filterPredicate includingObjects:(NSArray *)objects {
	BKIncludePredicate *includePredicate = [[[BKIncludePredicate alloc] initWithIncludedObjects:objects] autorelease];
	if (filterPredicate) {
		return [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:filterPredicate, includePredicate, nil]];
	} else {
		return includePredicate;
	}
}

+ (NSPredicate *)predicate:(NSPredicate *)filterPredicate excludingObjects:(NSArray *)objects {
	BKExcludePredicate *excludePredicate = [[[BKExcludePredicate alloc] initWithExcludedObjects:objects] autorelease];
	if (filterPredicate) {
		return [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:filterPredicate, excludePredicate, nil]];
	} else {
		return excludePredicate;
	}
}

@end

@implementation BKIncludePredicate

- (id)initWithIncludedObjects:(NSArray *)newIncludedObjects {
	if (self = [super init]) {
		includedObjects = [newIncludedObjects retain];
	}
	return self;
}

- (void)dealloc {
	[includedObjects release];
	[super dealloc];
}

- (BOOL)evaluateWithObject:(id)object {
	return [includedObjects containsObject:object];
}

- (BOOL)evaluateWithObject:(id)object variableBindings:(id)bindings { // XXX private method hack?
	return [includedObjects containsObject:object];
}

@end

@implementation BKExcludePredicate

- (id)initWithExcludedObjects:(NSArray *)newExcludedObjects {
	if (self = [super init]) {
		excludedObjects = [newExcludedObjects retain];
	}
	return self;
}

- (void)dealloc {
	[excludedObjects release];
	[super dealloc];
}

- (BOOL)evaluateWithObject:(id)object {
	return ![excludedObjects containsObject:object];
}

- (BOOL)evaluateWithObject:(id)object variableBindings:(id)bindings { // XXX private method hack?
	return ![excludedObjects containsObject:object];
}

@end

@implementation NSFetchRequest (BKFoundationAdditions)

+ (void)prefetch:(NSArray *)managedObjects entityName:(NSString *)entityName managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
	NSArray *faultedManagedObjects = [managedObjects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isFault == YES"]];
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	NSError *fetchError;
	
	@try {
		[fetchRequest setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext]];		
		[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"self IN %@", faultedManagedObjects]];
		[managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
	} @catch (NSException *e) {
		logErrorWithException(@"failed executeFetchRequest", e);
	}
}

@end

@implementation NSEntityDescription (BKFoundationAdditions)

- (NSPropertyDescription *)propertyDescriptionForKeyPathArray:(NSMutableArray *)keyPathArray {
	NSPropertyDescription *propertyDescription = [[self propertiesByName] objectForKey:[keyPathArray objectAtIndex:0]];
	
	if ([keyPathArray count] == 1) {
		return propertyDescription;
	} else if ([propertyDescription isKindOfClass:[NSRelationshipDescription class]]) {
		NSRelationshipDescription *relationshipDescription = (NSRelationshipDescription *) propertyDescription;
		[keyPathArray removeObjectAtIndex:0];
		return [[relationshipDescription destinationEntity] propertyDescriptionForKeyPathArray:keyPathArray];
	}
	
	return nil;
}

- (NSPropertyDescription *)propertyDescriptionForKeyPath:(NSString *)keyPath {
	return [self propertyDescriptionForKeyPathArray:[[[keyPath componentsSeparatedByString:@"."] mutableCopy] autorelease]];
	/*
	 NSPropertyDescription *result = nil;
	 NSEntityDescription *currentEntityDescription = self;
	 NSEnumerator *enumerator = [[keyPath componentsSeparatedByString:@"."] objectEnumerator];
	 NSString* eachPathElement;
	 
	 while (eachPathElement = [enumerator nextObject]) {
		 result = [[currentEntityDescription propertiesByName] objectForKey:eachPathElement];
		 
		 if ([propertyDescription isKindOfClass:[NSRelationshipDescription class]]) {
			 NSRelationshipDescription *relationshipDescription = (NSRelationshipDescription *) propertyDescription;
			 currentEntityDescription = [relationshipDescription destinationEntity];
		 }
	 }
	 
	 return propertyDescription;*/
}

@end