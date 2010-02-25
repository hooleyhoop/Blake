//
//  SHooleyObject.m
//  Pharm
//
//  Created by Steve Hooley on 12/10/2005.
//  Copyright 2005 HooleyHoop. All rights reserved.
//
#import "SHooleyObject.h"
#import "SHInstanceCounter.h"


@implementation SHooleyObject

#pragma mark -
#pragma mark action methods

+ (void)initialize  {
	
	static BOOL isInitialized = NO;
	if(!isInitialized) {
		isInitialized = YES;
	}
}

/* initBase is just for initializeation of objects that aren't copied in copyWithZone */
- (id)initBase {
	self=[super init];
    if(self) {
#ifdef DEBUG
        [SHInstanceCounter objectCreated:self];
        NSAssert( _recordedSelectorStrings==nil, @"what? double initing?");
		_recordedSelectorStrings = [[NSMutableArray array] retain];        
#endif
    }
	return self;
}

- (id)init {
    return [self initBase];
}

/* Didnt encode anything so just call init */
//- (id)initWithCoder:(NSCoder *)coder {
//    return [self init];
//}
//- (void)encodeWithCoder:(NSCoder *)coder {
//	/* Nothing to encode right now */
//}

- (void)dealloc {
	
	#ifdef DEBUG
        [SHInstanceCounter objectDestroyed:self];
		[_recordedSelectorStrings release];
		if([_currentObservers count]){
			for( id each in _currentObservers ){
				logWarning(@"deallocing %@ with observer attached - %@", self, each);
			}
		}
		NSAssert([_currentObservers count]==0, @"deallocing hooleyobject with observers attached");
		[_currentObservers release];
		[_shInstanceDescription release];
	#endif

    [super dealloc];
}

- (id)valueForUndefinedKey:(NSString *)key {
	return [super valueForUndefinedKey:key];
}

- (void)clearRecordedHits {
	#ifdef DEBUG
		[_recordedSelectorStrings removeAllObjects];
	#endif
}

- (void)recordHit:(SEL)aSelector {
	#ifdef DEBUG
		NSString *selAsString = NSStringFromSelector(aSelector);
		[_recordedSelectorStrings addObject:selAsString];
	#endif
}

- (BOOL)assertRecordsIs:(NSString *)firstString,... {

	#ifdef DEBUG
	
	NSParameterAssert([firstString isKindOfClass: NSClassFromString(@"NSString")]);
	NSAssert(_recordedSelectorStrings!=nil, @"what?");
	
	NSString *eachObject;
	va_list argumentList;
	if(firstString!=nil)					// The first argument isn't part of the varargs list,
	{										// so we'll handle it separately.
		if([_recordedSelectorStrings count]<1)
			return NO;
		NSString *str21 = [_recordedSelectorStrings objectAtIndex:0];
		if( [firstString isEqualToString: str21]==NO )
			return NO;
		
		NSUInteger argIndex = 1;
		va_start(argumentList, firstString);					// Start scanning for arguments after firstString.
		while( (eachObject=va_arg(argumentList, NSString*)) )	// As many times as we can get an argument of type "id"
		{
			if(argIndex>=[_recordedSelectorStrings count])
				return NO;	/* have we got too many args? */
			if([eachObject isEqualToString:[_recordedSelectorStrings objectAtIndex:argIndex]]==NO)
				return NO;
			argIndex++;
		}
		va_end(argumentList);
		if(argIndex<[_recordedSelectorStrings count])
			return NO;	/* have we got too few args? */
		return YES;
	}
	#else
        logWarning(@"you shouldn't be calling 'assertRecordsIs' when not debugging. If you are debugging set NSDevbugEnabled.");
	#endif
	return NO;
}

- (NSMutableArray *)recordedSelectorStrings {

	#ifdef DEBUG
		return _recordedSelectorStrings;
	#endif
	return nil;
}

#ifdef DEBUG
- (NSString *)uniqueStringForObject:(NSObject *)anObject andKeyPath:(NSString *)keyPath {

	NSString *uniqueStringForObject = [NSString stringWithFormat:@"%@-%p", keyPath, anObject];
	return uniqueStringForObject;
}

- (void)addObserver:(NSObject *)anObserver forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {
	
	NSParameterAssert(anObserver!=nil);
	NSParameterAssert(keyPath!=nil);

	/* I can think of one way to find out if the keyPath is valid */
    [self valueForKeyPath:keyPath];
	
	if(_currentObservers==nil)
		_currentObservers = [[NSMutableDictionary alloc] init];
	
	NSString *uniqueStringForObject = [self uniqueStringForObject:anObserver andKeyPath:keyPath];
	
	// logInfo(@"%@ adding observer %@", self, uniqueStringForObject);
	id existingObject = [_currentObservers objectForKey:uniqueStringForObject];
	if(existingObject!=nil)
		[NSException raise:@"Adding an observer twice!" format:@"%@, %@ path - %@", self, anObserver, keyPath];
	[super addObserver:anObserver forKeyPath:keyPath options:options context:context];
	[_currentObservers setObject:keyPath forKey:uniqueStringForObject];
	
	NSAssert([_currentObservers objectForKey:uniqueStringForObject]!=nil, @"Failed to add observer");
}

- (void)removeObserver:(NSObject *)anObserver forKeyPath:(NSString *)keyPath {

	NSParameterAssert(anObserver!=nil);
	NSParameterAssert(keyPath!=nil);
	
	/* I can think of one way to find out if the keyPath is valid */
    [self valueForKeyPath:keyPath];

	NSString *uniqueStringForObject = [self uniqueStringForObject:anObserver andKeyPath:keyPath];
	// logInfo(@"%@ removing observer %@", self, uniqueStringForObject);

	id existingObject = [_currentObservers objectForKey:uniqueStringForObject];
	if(existingObject==nil)
		[NSException raise:@"Trying to remove an observer that doesn't exist!!" format:@""];
	[super removeObserver:anObserver forKeyPath:keyPath];
	
	/* undo the correction we made when we added anObserver to the dict */
	[_currentObservers removeObjectForKey:uniqueStringForObject];
	
	NSAssert([_currentObservers objectForKey:uniqueStringForObject]==nil, @"Failed to Remove observer");
}

- (NSString *)shInstanceDescription {
	
	return _shInstanceDescription;
}

- (void)setShInstanceDescription:(NSString *)value {
	
	_shInstanceDescription = [value retain];
}

//- (void)bind:(NSString *)binding toObject:(id)observableController withKeyPath:(NSString *)keyPath options:(NSDictionary *)options {
//
//	[super bind:binding toObject:observableController withKeyPath:keyPath options:options];
//}
//
//- (void)unbind:(NSString *)binding {
//
//	[super unbind:binding];
//}

#endif


@end
