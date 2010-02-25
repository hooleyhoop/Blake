//
//  BKScriptsProtocols.m
//  Blocks
//
//  Created by Jesse Grosjean on 1/7/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKScriptsProtocols.h"
#import "BKScriptsController.h"


@implementation NSApplication (BKScriptsControllerAccess)

- (id <BKScriptsControllerProtocol>)BKScriptsProtocols_scriptsController {
	return [BKScriptsController sharedInstance];
}

@end

@interface NSAppleScript (BKScriptsAdditions_Private)
+ (struct ComponentInstanceRecord *)_defaultScriptingComponent;
- (OSAID)_compiledScriptID;
@end

@implementation NSAppleScript (BKScriptsAdditions)

+ (struct ComponentInstanceRecord *)defaultScriptingComponent {
	return [NSAppleScript _defaultScriptingComponent];
}

- (OSAID)compiledScriptID {
	return [self _compiledScriptID];
}

- (NSArray *)arrayOfEventIdentifier {
	if (![self isCompiled]) {
		NSDictionary *errorInfo = nil;
		if (![self compileAndReturnError:&errorInfo]) {
			logError(([errorInfo description]));
			return nil;
		}
	}
	
	AEDescList theEventIdentifierList;
	OSAID contextID = [self compiledScriptID];
	ComponentInstance defaultScriptingComponent = [NSAppleScript defaultScriptingComponent];
	ComponentInstance appleScriptScriptingComponent;
	
	OSAError err = OSAGenericToRealID(defaultScriptingComponent, &contextID, &appleScriptScriptingComponent);
	
	if (err != noErr) {
		logError((@"OSAGenericToRealID failed"));
		return nil;
	}
	
	err = OSAGetHandlerNames(appleScriptScriptingComponent, kOSAModeNull, contextID, &theEventIdentifierList);
	
	if (err != noErr) {
		logError((@"OSAGetHandlerNames failed"));
	}
	
	return [[[[NSAppleEventDescriptor alloc] initWithAEDescNoCopy:&theEventIdentifierList] autorelease] arrayValue];
}

- (BOOL)respondsToEvent:(NSString *)aName {
	return [[self arrayOfEventIdentifier] containsObject:[aName lowercaseString]];
}

- (id)callHandler:(NSString *)handler errorInfo:(NSDictionary **)errorInfo {
	return [self callHandler:handler withArguments:nil errorInfo:errorInfo];
}

- (id)callHandler:(NSString *)handler withArguments:(NSArray *)arguments errorInfo:(NSDictionary **)errorInfo {
	NSAppleEventDescriptor *event = [NSAppleEventDescriptor descriptorWithSubroutineName:handler argumentsArray:arguments];
    NSAppleEventDescriptor* result = [self executeAppleEvent:event error:errorInfo];
	return [result objectValue];
}

@end

@interface NSObject (NSAppleEventDescriptor_BKScriptAdditions_Private)
- (NSAppleEventDescriptor *)_asDescriptor;
+ (NSAppleEventDescriptor *)_objectSpecifierFromDescriptor:(NSAppleEventDescriptor *)appleEventDiscriptor inCommandConstructionContext:(id)inCommandConstructionContext;
@end

@implementation NSAppleEventDescriptor (BKScriptAdditions)

+ (NSAppleEventDescriptor *)currentProcessDescriptor {
	ProcessSerialNumber	theCurrentProcess = { 0, kCurrentProcess };
	return [NSAppleEventDescriptor descriptorWithDescriptorType:typeProcessSerialNumber bytes:(void*)&theCurrentProcess length:sizeof(theCurrentProcess)];
}

+ (id)descriptorWithNumber:(NSNumber *)aNumber {
	const char *theType = [aNumber objCType];
	NSAppleEventDescriptor *theDescriptor = nil;
	unsigned int theIndex;
	
	struct {
		char *objCType;
		DescType descType;
		unsigned short	size;
	}
	
	theTypes[] = {
		{ @encode(float), typeIEEE32BitFloatingPoint, sizeof(float) },
		{ @encode(double), typeIEEE64BitFloatingPoint, sizeof(double) },
		{ @encode(unsigned char), typeUInt32, sizeof(unsigned char) },
		{ @encode(char), typeSInt16, sizeof(char) },
		{ @encode(unsigned short int), typeUInt32, sizeof(unsigned short int) },
		{ @encode(short int), typeSInt16, sizeof(short int) },
		{ @encode(unsigned int), typeUInt32, sizeof(unsigned int) },
		{ @encode(int), typeSInt32, sizeof(int) },
		{ @encode(unsigned long int), typeUInt32, sizeof(unsigned long int) },
		{ @encode(long int), typeSInt32, sizeof(long int) },
		{ @encode(unsigned long long), typeSInt64, sizeof(unsigned long long) },
		{ @encode(long long), typeSInt64, sizeof(long long) },
		{ @encode(BOOL), typeBoolean, sizeof(BOOL) },
		{ NULL, 0, 0 }
	};
	
	for(theIndex = 0; theDescriptor == nil && theTypes[theIndex].objCType != NULL; theIndex++) {
		if(strcmp(theTypes[theIndex].objCType, theType) == 0) {
			char *theBuffer[64];
			[aNumber getValue:theBuffer];
			theDescriptor = [self descriptorWithDescriptorType:theTypes[theIndex].descType bytes:theBuffer length:theTypes[theIndex].size];
		}
	}
	
	return theDescriptor;
}

+ (id)descriptorWithArray:(NSArray *)anArray {
	NSAppleEventDescriptor *theEventList = nil;
	unsigned int theNumOfParam = [anArray count];
	unsigned int theIndex;
	
	if(theNumOfParam > 0) {
		theEventList = [self listDescriptor];
		
		for(theIndex = 0; theIndex < theNumOfParam; theIndex++) {
			[theEventList insertDescriptor:[self descriptorWithObject:[anArray objectAtIndex:theIndex]] atIndex:theIndex+1];
		}
	}
	
	return theEventList;
}

+ (id)descriptorWithDictionary:(NSDictionary *)aDictionary {
	NSAppleEventDescriptor *theRecordDescriptor = [self recordDescriptor];
	[theRecordDescriptor setDescriptor:[NSAppleEventDescriptor userRecordDescriptorWithDictionary:aDictionary] forKeyword:keyASUserRecordFields];
	return theRecordDescriptor;
}

+ (NSAppleEventDescriptor *)userRecordDescriptorWithDictionary:(NSDictionary *)aDictionary {
	NSAppleEventDescriptor *theUserRecord = nil;
	
	if([aDictionary count] > 0 && (theUserRecord = [self listDescriptor]) != nil) {
		NSEnumerator *theEnumerator = [aDictionary keyEnumerator];
		id theKey;
		unsigned int theIndex = 1;
		
		while ((theKey = [theEnumerator nextObject]) != nil) {
			[theUserRecord insertDescriptor:[NSAppleEventDescriptor descriptorWithString:[theKey description]] atIndex:theIndex++];
			[theUserRecord insertDescriptor:[NSAppleEventDescriptor descriptorWithObject:[aDictionary objectForKey:theKey]] atIndex:theIndex++];
		}
	}
	
	return theUserRecord;
}

+ (id)descriptorWithObject:(id)anObject {
	NSAppleEventDescriptor *theDescriptor = nil;
	
	if(anObject == nil || [anObject isKindOfClass:[NSNull class]]) {
		theDescriptor = [NSAppleEventDescriptor nullDescriptor];
	} else if([anObject isKindOfClass:[NSNumber class]]) {
		theDescriptor = [self descriptorWithNumber:anObject];
	} else if([anObject isKindOfClass:[NSString class]]) {
		theDescriptor = [self descriptorWithString:anObject];
	} else if([anObject isKindOfClass:[NSArray class]]) {
		theDescriptor = [self descriptorWithArray:anObject];
	} else if([anObject isKindOfClass:[NSDictionary class]]) {
		theDescriptor = [self descriptorWithDictionary:anObject];
	} else if([anObject isKindOfClass:[NSDate class]]) {
		LongDateTime ldt;
		UCConvertCFAbsoluteTimeToLongDateTime(CFDateGetAbsoluteTime((CFDateRef)anObject), &ldt);
		theDescriptor = [NSAppleEventDescriptor descriptorWithDescriptorType:typeLongDateTime bytes:&ldt length:sizeof(ldt)];
	} else if([anObject isKindOfClass:[NSAppleEventDescriptor class]]) {
		theDescriptor = anObject;
	} else if([anObject isKindOfClass:NSClassFromString(@"NDAppleScriptObject")]) {
		theDescriptor = [self performSelector:NSSelectorFromString(@"descriptorWithAppleScript:") withObject:anObject];
	} else if([anObject isKindOfClass:[NSScriptObjectSpecifier class]]) {
		theDescriptor = [anObject _asDescriptor];
	} else if([anObject respondsToSelector:@selector(objectSpecifier)]) {
		theDescriptor = [[anObject objectSpecifier] _asDescriptor];
	}
	
	return theDescriptor;
}

+ (id)descriptorWithSubroutineName:(NSString *)aRoutineName argumentsListDescriptor:(NSAppleEventDescriptor *)aParam {
	return [[[NSAppleEventDescriptor alloc] initWithSubroutineName:aRoutineName argumentsListDescriptor:aParam] autorelease];
}

+ (id)descriptorWithSubroutineName:(NSString *)aRoutineName argumentsArray:(NSArray *)aParamArray {
	return [[[NSAppleEventDescriptor alloc] initWithSubroutineName:aRoutineName argumentsListDescriptor:aParamArray ? [NSAppleEventDescriptor descriptorWithArray:aParamArray] : nil] autorelease];
}

- (id)initWithSubroutineName:(NSString *)aRoutineName argumentsArray:(NSArray *)aParamArray {
	return [self initWithSubroutineName:aRoutineName argumentsListDescriptor:aParamArray ? [NSAppleEventDescriptor descriptorWithArray:aParamArray] : nil];
}

- (id)initWithSubroutineName:(NSString *)aRoutineName argumentsListDescriptor:(NSAppleEventDescriptor *)aParam {
	if(self = [self initWithEventClass:kASAppleScriptSuite eventID:kASSubroutineEvent targetDescriptor:[NSAppleEventDescriptor currentProcessDescriptor] returnID:kAutoGenerateReturnID transactionID:kAnyTransactionID]) {
		[self setParamDescriptor:[NSAppleEventDescriptor descriptorWithString:[aRoutineName lowercaseString]] forKeyword:keyASSubroutineName];
		[self setParamDescriptor:aParam ? aParam : [NSAppleEventDescriptor listDescriptor] forKeyword:keyDirectObject];
	}
	
	return self;
}

- (unsigned int)unsignedIntValue {
	unsigned int theUnsignedInt = 0;
	if(AEGetDescData([self aeDesc], &theUnsignedInt, sizeof(unsigned int)) != noErr) {
		logError((@"Failed to get unsigned int value from NSAppleEventDescriptor"));
	}
	return theUnsignedInt;
}

- (float)floatValue {
	float theFloat = 0.0;
	if(AEGetDescData([self aeDesc], &theFloat, sizeof(float)) != noErr) {
		logError((@"Failed to get float value from NSAppleEventDescriptor"));
	}
	return theFloat;
}

- (double)doubleValue {
	double theDouble = 0.0;
	if(AEGetDescData([self aeDesc], &theDouble, sizeof(double)) != noErr) {
		logError((@"Failed to get double value from NSAppleEventDescriptor"));
	}	
	return theDouble;
}

- (NSDate *)dateValue {
    LongDateTime dateTime;
	CFAbsoluteTime absTime;
	
    [[[self coerceToDescriptorType:typeLongDateTime] data] getBytes:&dateTime];
	UCConvertLongDateTimeToCFAbsoluteTime(dateTime, &absTime);
	
	NSDate *resultDate = (NSDate *)CFDateCreate(NULL, absTime);
	[resultDate autorelease];
	
    return resultDate;
}

- (NSNumber *)numberValue {
	NSNumber *theNumber = nil;
	
	switch([self descriptorType]) {
		case typeBoolean:
			theNumber = [NSNumber numberWithBool:[self booleanValue]];
			break;
		case typeShortInteger:
			theNumber = [NSNumber numberWithShort:[self int32Value]];
			break;
		case typeLongInteger: {
			int	theInteger;
			
			if(AEGetDescData([self aeDesc], &theInteger, sizeof(int)) == noErr) {
				theNumber = [NSNumber numberWithInt:theInteger];
			}
			
			break;
		}
		case typeShortFloat: {
			theNumber = [NSNumber numberWithFloat:[self floatValue]];
			break;
		}
		case typeFloat: {
			theNumber = [NSNumber numberWithDouble:[self doubleValue]];
			break;
		}
		case typeMagnitude: {
			theNumber = [NSNumber numberWithUnsignedLong:[self unsignedIntValue]];
			break;
		}
		case typeTrue:
			theNumber = [NSNumber numberWithBool:YES];
			break;
		case typeFalse:
			theNumber = [NSNumber numberWithBool:NO];
			break;
		case typeType:
			theNumber = [NSNumber numberWithUnsignedLong:[self typeCodeValue]];
			break;
		default:
			theNumber = nil;
			break;
	}
	
	return theNumber;
}

- (NSArray *)arrayValue {
	int theNumOfItems = [self numberOfItems];
	int theIndex;
	
	NSMutableArray *theArray = [NSMutableArray arrayWithCapacity:theNumOfItems];
	
	for(theIndex = 1; theIndex <= theNumOfItems; theIndex++) {
		NSAppleEventDescriptor *theDescriptor;
		if(theDescriptor = [self descriptorAtIndex:theIndex]) {
			[theArray addObject:[theDescriptor objectValue]];
		}
	}
	
	return theArray;
}

- (NSDictionary *)dictionaryValue {
	NSAppleEventDescriptor *theUserRecordFields = [self descriptorForKeyword:keyASUserRecordFields];
	unsigned int theIndex, theNumOfItems = [theUserRecordFields numberOfItems];
	NSMutableDictionary *theDictionary = theNumOfItems ? [NSMutableDictionary dictionaryWithCapacity:theNumOfItems/2] : nil;
	
	for(theIndex = 1; theIndex+1 <= theNumOfItems; theIndex+=2) {
		[theDictionary setObject:[[theUserRecordFields descriptorAtIndex:theIndex+1] objectValue] forKey:[[theUserRecordFields descriptorAtIndex:theIndex] stringValue]];
	}
	
	return theDictionary;
}


- (NSDictionary *)dictionaryValueFromRecordDescriptor {
	unsigned int theIndex, theNumOfItems = [self numberOfItems];
	NSMutableDictionary	*theDictionary = [NSMutableDictionary dictionaryWithCapacity:theNumOfItems];
	
	NSParameterAssert(sizeof(AEKeyword) == sizeof(unsigned long));
	for(theIndex = 1; theIndex <= theNumOfItems; theIndex++) {
		AEKeyword theKeyword = [self keywordForDescriptorAtIndex:theIndex];
		id theObject = theKeyword == keyASUserRecordFields ? [self descriptorForKeyword:keyASUserRecordFields] : [self descriptorForKeyword:theKeyword];
		[theDictionary setObject:[theObject objectValue] forKey:[NSNumber numberWithUnsignedInt:theKeyword]];
	}
	
	return theDictionary;
}

- (id)objectValue {
	id theResult;
	DescType theDescType = [self descriptorType];
		
	switch(theDescType) {
		case typeBoolean:
		case typeShortInteger:
		case typeLongInteger:
		case typeShortFloat:
		case typeFloat:
		case typeMagnitude:
		case typeTrue:
		case typeFalse:
			theResult = [self numberValue];
			break;
		case typeText:
		case kTXNUnicodeTextData:
			theResult = [self stringValue];
			break;
		case typeAEList:
			theResult = [self arrayValue];
			break;
		case typeAERecord:
			theResult = [self numberOfItems] == 1 && [self keywordForDescriptorAtIndex:1] == keyASUserRecordFields ? [self dictionaryValue] :[self dictionaryValueFromRecordDescriptor];
			break;
		case typeLongDateTime:
			theResult = [self dateValue];
			break;
		case cScript: {
			SEL	theSelector = NSSelectorFromString(@"appleScriptValue");
			theResult = [self respondsToSelector:theSelector] ? [self performSelector:theSelector] :self;
			break;
		}
		case cEventIdentifier: {
			unsigned int *theValues = (unsigned int*)[[self data] bytes];
			theResult = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithUnsignedInt:theValues[0]], @"EventClass", [NSNumber numberWithUnsignedInt:theValues[1]], @"EventID", nil];
			break;
		}
		case typeObjectSpecifier: {
			theResult = [NSScriptObjectSpecifier _objectSpecifierFromDescriptor:self inCommandConstructionContext:nil];
			break;
		}
		case typeNull:
			theResult = [NSNull null];
			break;
		default: {
			OSType typeCodeValue = [self typeCodeValue];
			
			if (typeCodeValue == 'null' || typeCodeValue == 'msng') {
				theResult = nil;
			} else {
				theResult = self;
			}
			
			break;
		}
	}
	
	return theResult;
}

@end