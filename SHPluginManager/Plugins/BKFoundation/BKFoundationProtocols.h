//
//  BKFoundationProtocols.h
//  Blocks
//
//  Created by Jesse Grosjean on 4/1/06.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SHPluginManager/SHPluginManager.h>

typedef enum _BKDateIntervalType {
    BKDayInterval = 1,
    BKWeekInterval = 2,
    BKMonthInterval = 3,
    BKYearInterval = 4,
} BKDateIntervalType;

@interface NSString (BKFoundationAdditions)

+ (NSString *)uniqueString;
- (NSString *)md5Digest;
- (NSString *)sha1Digest;
- (NSString *)stringByEscapingEntities;
- (NSString *)stringByUnescapingEntities;
- (NSString *)stringByEscapingFilenameBackslashes;
- (NSString *)stringByUnescapingFilenameBackslashes;
- (NSString *)utiFromPath;
- (NSArray *)extensionsAndOSTypesFromUTI;
- (NSString *)extractNameFromContent:(int)maxLength;
- (unsigned int)wordCountInRange:(NSRange)range paragraphCount:(unsigned int *)paragraphCount;
- (NSArray *)componentsSeparatedByLineSeparators;
//- (NSString *)stringFromTextClipping:(NSString *)textClippingPath;

@end

@interface NSArray (BKFoundationAdditions)

- (id)firstObject;
- (unsigned)insertIndexForObject:(id)object withSortDescriptors:(NSArray *)sortDescriptors;
- (NSArray *)arrayByRemovingObject:(id)object;
- (NSArray *)filePathsToFileURLs;

@end

@interface NSAttributedString (BKAttributedStringAdditions)

+ (NSAttributedString *)readStringAtURL:(NSURL *)url error:(NSError **)error;

@end

@interface NSMutableArray (BKFoundationAdditions)

- (void)insertObject:(id)newObject after:(id)object;
- (void)insertObject:(id)newObject before:(id)object;
- (void)fillToLength:(unsigned)length with:(id)object;
- (BOOL)enqueueObject:(id)object;
- (id)dequeueObject;

@end

@interface NSDictionary (BKFoundationAdditions)

- (BOOL)boolForKey:(id)key;
- (NSRect)rectForKey:(id)key;
- (float)floatForKey:(id)key;
- (int)intForKey:(id)key;
- (NSSize)sizeForKey:(id)key;

@end

@interface NSMutableDictionary (BKFoundationAdditions)

- (void)setBool:(BOOL)boolean forKey:(id)key;
- (void)setRect:(NSRect)rect forKey:(id)key;
- (void)setFloat:(float)value forKey:(id)key;
- (void)setInt:(int)value forKey:(id)key;
- (void)setSize:(NSSize)size forKey:(id)key;

@end

@interface NSEnumerator (BKFoundationAdditions)

+ (NSEnumerator *)emptyEnumerator;
- (id)objectAtIndex:(unsigned int)index;
- (unsigned int)indexOfObject:(id)object;

@end

@interface NSDate (BKFoundationAdditions)

- (NSCalendarDate *)startOf:(BKDateIntervalType)intervalType;
- (NSCalendarDate *)endOf:(BKDateIntervalType)intervalType;
- (NSCalendarDate *)back:(int)interval intervalType:(BKDateIntervalType)intervalType;
- (NSCalendarDate *)forward:(int)interval intervalType:(BKDateIntervalType)intervalType;

@end

@interface NSURL (BKFoundationAdditions)

- (NSDictionary *)parameters;
- (NSURL *)URLWithParameters:(NSDictionary *)newParameters;

@end

@interface NSDateFormatter (BKFoundationAdditions)

+ (NSDate *)dateFromString:(NSString *)string;
- (NSString *)osx10_0CompatibleDataFormat;

@end

@interface NSNumberFormatter (BKFoundationAdditions)

+ (NSNumber *)numberFromString:(NSString *)string;
+ (NSString *)stringFromNumber:(NSNumber *)number;

@end

@interface NSFileManager (BKFoundationAdditions)

- (NSString *)uniqueTempPath;
- (NSString *)uniqueFilePathForDirectory:(NSString *)directory preferedName:(NSString *)name;
- (NSString *)processesApplicationSupportFolder;
- (NSString *)findSystemFolderType:(int)folderType forDomain:(int)domain;
- (BOOL)isPathOnWebDAVFileSystem:(NSString *)path;

@end

@interface NSPredicate (BKFoundationAdditions)

+ (NSDictionary *)defaultSubstitutionVariables;
+ (NSPredicate *)predicate:(NSPredicate *)filterPredicate includingObjects:(NSArray *)objects;
+ (NSPredicate *)predicate:(NSPredicate *)filterPredicate excludingObjects:(NSArray *)objects;

@end

@interface NSFetchRequest (BKFoundationAdditions)

+ (void)prefetch:(NSArray *)managedObjects entityName:(NSString *)entityName managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end

@interface NSEntityDescription (BKFoundationAdditions)

- (NSPropertyDescription *)propertyDescriptionForKeyPath:(NSString *)keyPath;

@end

#define NSPredicateStartOfDaySubstitutionVariable @"NSPredicateStartOfDaySubstitutionVariable"
#define NSPredicateStartOfDaySubstitutionVariable @"NSPredicateStartOfDaySubstitutionVariable"
#define NSPredicateEndOfDaySubstitutionVariable @"NSPredicateEndOfDaySubstitutionVariable"
#define NSPredicateStartOfWeekSubstitutionVariable @"NSPredicateStartOfWeekSubstitutionVariable"
#define NSPredicateEndOfWeekSubstitutionVariable @"NSPredicateEndOfWeekSubstitutionVariable"
#define NSPredicateStartOfLastWeekSubstitutionVariable @"NSPredicateStartOfLastWeekSubstitutionVariable"
#define NSPredicateEndOfLastWeekSubstitutionVariable @"NSPredicateEndOfLastWeekSubstitutionVariable"
#define NSPredicateStartOfMonthSubstitutionVariable @"NSPredicateStartOfMonthSubstitutionVariable"
#define NSPredicateEndOfMonthSubstitutionVariable @"NSPredicateEndOfMonthSubstitutionVariable"
#define NSPredicateStartOfYearSubstitutionVariable @"NSPredicateStartOfYearSubstitutionVariable"
#define NSPredicateEndOfYearSubstitutionVariable @"NSPredicateEndOfYearSubstitutionVariable"