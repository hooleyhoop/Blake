//
//  SHOrderedDictionary.m
//  Shared
//
//  Created by Steven Hooley on 28/07/2007.
//  Copyright 2007 HooleyHoop. All rights reserved.
//

#import "SHOrderedDictionary.h"
#import "NSArray_Extensions.h"
#import "NSObject_Extras.h"

/*
 *
*/
@implementation SHOrderedDictionary

#pragma mark -
#pragma mark class methods
+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)theKey {
	
	BOOL automatic = NO;
    if ([theKey isEqualToString:@"array"] || [theKey isEqualToString:@"selection"]) {
        automatic=NO;
    } else {
        automatic=[super automaticallyNotifiesObserversForKey:theKey];
    }
    return automatic;
}

+ (id)dictionary {
	SHOrderedDictionary* dict = [[[self alloc] init] autorelease];
	return dict;
}

#pragma mark init methods

- (id)init {
	
  	NSMutableArray* array = [NSMutableArray array];
	NSMutableDictionary* dict = [NSMutableDictionary dictionary];
	self=[self _initWithArray:array dict:dict];
	return self;
}

/* This will be called by [HooleyObject init] - dont call directly! */
- (id)initBase {
	
	self=[super initBase];
    if(self) {
		[self setSelection:[NSMutableIndexSet indexSet]];
	}
	return self;
}

- (id)_initWithArray:(NSMutableArray *)ar dict:(NSMutableDictionary *)dc {

	NSParameterAssert(ar!=nil);
	NSParameterAssert(dc!=nil);
	self=[super init];
    if(self)
	{
		_array = [ar retain];
		_dict = [dc retain];
		NSAssert(self!=nil, @"init failed");
		NSAssert(_array!=nil, @"init failed");
		NSAssert(_dict!=nil, @"init failed");
		NSAssert(_selection!=nil, @"init failed");
	}
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {

    self = [self _initWithArray:[coder decodeObjectForKey:@"array"] dict:[coder decodeObjectForKey:@"dict"]];
	if(self) {
	}
    return self;
}

- (void)dealloc {
	[_selection release];
	[_array release];
	[_dict release];
    [super dealloc];
}

//- (id)retain {
//	id res = [super retain];
//	logInfo(@"New retaincount is %i", [self retainCount]);
//	return res;
//}

#pragma mark action methods

/*
 * pre condition - key is NSString and !=nil
 * pre condition - dict contains object for key
 * pre condition - array contains object
 * pre condition - selection may or may not contain that index 
 * post condition - dict, array and selection will not contain object
*/
- (void)removeObjectForKey:(id)aKey {

	NSParameterAssert(aKey!=nil);
	NSParameterAssert([aKey isKindOfClass:[NSString class]]);

	id object = [_dict objectForKey:aKey];
	NSAssert(object!=nil, @"cant remove object not in dict");
	
	NSUInteger oindex = [_array indexOfObjectIdenticalTo:object];
	NSAssert(oindex!=NSNotFound, @"removeObjectForKey failed - not found");
	
	// this has fucked up the selection indexes for objects after this..
	NSMutableArray* selectedObjects = nil;
	if([_selection count]){
		selectedObjects = [[[_array objectsAtIndexes:_selection] mutableCopy] autorelease];
		/* Temporarily remove the selection, so it doesnt get out of sync */
		[self setSelectedObjects:[NSArray array]];
	}
	[_dict removeObjectForKey:aKey];

	/* Remove and update observers */
	// er. this will update the bindings, but the selection is incorrect..
	[self removeObjectFromArrayAtIndex: oindex];
	
	if(selectedObjects){
		[selectedObjects removeObjectIdenticalTo:object];

		/* reset the selection */
		[self setSelectedObjects:selectedObjects];
	}
	NSAssert([_dict objectForKey:aKey]==nil, @"Remove failed");
}

/*
 * pre condition - anObject !=nil
 * pre condition - dict and array contain object
 * post condition - dict, array and selection will not contain object
*/
- (void)removeObject:(id)anObject {

	NSParameterAssert(anObject!=nil);
	NSParameterAssert([_array containsObject:anObject]);
	NSParameterAssert([[_dict allValues] containsObject:anObject]);

	[self removeObjectForKey:[self keyForObject:anObject]];
	
	NSAssert([_array containsObject:anObject]==NO, @"Remove failed");
	NSAssert([[_dict allValues]  containsObject:anObject]==NO, @"Remove failed");
}

- (void)removeObjectsForKeys:(NSArray *)keys {

	NSParameterAssert([keys count]>0);

    NSArray *objects = [_dict objectsForKeys:keys notFoundMarker:[NSNull null]];
	NSIndexSet *indexesToRemove = [self indexesOfObjects:objects];
    [self removeObjectsAtIndexes:indexesToRemove keys:keys];
}

//- (void)removeObjects:(NSArray *)objects {
//    
//    NSParameterAssert([objects count]>0);
//
//    NSMutableIndexSet *indexesToRemove = [NSMutableIndexSet indexSet];
//    for(id eachOb in objects)
//        [indexesToRemove addIndex:[_array indexOfObjectIdenticalTo:eachOb]];;
//    [self removeObjectsAtIndexes:indexesToRemove];
//}

- (void)removeObjectsAtIndexes:(NSIndexSet *)indexes {
   
    NSParameterAssert([indexes count]>0);
    NSParameterAssert([indexes lastIndex]<[_array count]);

    NSMutableArray *keys = [NSMutableArray array];
    
 	NSUInteger current = [indexes firstIndex];
	while (current != NSNotFound) {
		id each = [_array objectAtIndex:current];
        NSArray *keysForObject = [_dict allKeysForObject:each];
        NSAssert1([keysForObject count]==1, @"cant delete object that doesn't have a key %i", [keysForObject count]);
        [keys addObject:[keysForObject lastObject]];
        current = [indexes indexGreaterThanIndex: current];
	}
    [self removeObjectsAtIndexes:indexes keys:keys];
}

- (void)removeObjectsAtIndexes:(NSIndexSet *)indexes keys:(NSArray *)keys {
    
    NSParameterAssert([indexes count]>0);
    NSParameterAssert([indexes count]==[keys count]);

	NSArray* selectedObjects=nil;
	if([_selection count]){
        [_selection removeIndexes:indexes];
		selectedObjects = [_array objectsAtIndexes:_selection];
		[_selection removeAllIndexes];
	}
    
// if we use manual KVO can we get rid of the special accessors?
//trygetrid    [self removeArrayAtIndexes:indexes];
    
//trygetrid	- (void)removeArrayAtIndexes:(NSIndexSet *)indexes {
		
		[self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"array"];
		
		[_dict removeObjectsForKeys:keys];
		[_array removeObjectsAtIndexes:indexes];
		
		[self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"array"];
//trygetrid	}
	
	
	if(selectedObjects){
		[self setSelectedObjects:selectedObjects];
	}
}
    
/*
 * pre condition - dict and array dont contain object or key
 * pre condition - object!=nil, aKey!=nil
 * post condition - dict and array contain object
 * post condition - object is appended, selection is preserved
*/
- (void)setObject:(id)anObject forKey:(id)aKey {

	NSParameterAssert(anObject!=nil);
	NSParameterAssert(aKey!=nil);
	NSParameterAssert([aKey isKindOfClass:[NSString class]]);
	NSAssert([_array containsObject:anObject]==NO, @"setObject: forKey: failed! as we already have that object?");
	NSAssert([_dict objectForKey:aKey]==nil, @"setObject: forKey: failed! as we already have that object?");
	
	[_dict setObject:anObject forKey:aKey];
	
	NSUInteger newArrayIndex = [_array count];
	[self insertObject:anObject inArrayAtIndex:newArrayIndex];

	NSAssert([_array containsObject:anObject]==YES, @"setObject failed");
	NSAssert([[_dict allValues]  containsObject:anObject]==YES, @"setObject failed");
}

/* 	-- indexes can be nil */
- (void)setObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes forKeys:(NSArray *)keys {

    NSParameterAssert([objects count]==[keys count]);
	NSAssert([_dict count]==[_array count], @"ordered dict got out of whack!");
	int dictCount = [_dict count];

    NSDictionary *tempDict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    [_dict addEntriesFromDictionary:tempDict];
    
	NSArray* selectedObjects=nil;
	if([_selection count]){
		selectedObjects = [_array objectsAtIndexes:_selection];
		[_selection removeAllIndexes];
	}
	if(indexes==nil)
		indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange([_array count], [objects count])];
	NSParameterAssert([objects count]==[indexes count]);
	[self insertArray:objects atIndexes:indexes];

	if(selectedObjects){
		[self setSelectedObjects:selectedObjects];
	}
	
	NSAssert([_dict count]==[_array count], @"ordered dict got out of whack! 2");
	NSAssert([_dict count]==dictCount+[objects count], @"didn't add all items?");
}

- (void)setObject:(id)anObject atIndex:(NSUInteger)ind forKey:(id)aKey {
	
	NSParameterAssert(anObject!=nil);
	NSParameterAssert(aKey!=nil);
	NSParameterAssert([aKey isKindOfClass:[NSString class]]);
	NSAssert([_array containsObject:anObject]==NO, @"setObject: forKey: failed! as we already have that object?");
	NSAssert([_dict objectForKey:aKey]==nil, @"setObject: forKey: failed! as we already have that object?");
	
	NSArray* selectedObjects=nil;
	if([_selection count]){
		selectedObjects = [_array objectsAtIndexes:_selection];
		[_selection removeAllIndexes];
	}
	[_dict setObject:anObject forKey:aKey];
	[self insertObject:anObject inArrayAtIndex:ind];
	if(selectedObjects){
		[self setSelectedObjects:selectedObjects];
	}
	NSAssert([_array containsObject:anObject]==YES, @"setObject failed");
	NSAssert([[_dict allValues]  containsObject:anObject]==YES, @"setObject failed");
}

- (id)objectForKey:(id)aKey {

	NSParameterAssert(aKey!=nil);
	NSParameterAssert([aKey isKindOfClass:[NSString class]]);
	
	id foundOb = [_dict objectForKey:aKey];
	//if(foundOb==nil){
	//	NSArray *allKeys = [_dict allKeys];
	//	logError(@"could not find %@ in %@", aKey, allKeys);
	//}
	return foundOb;
}

/* This doesnt trigger KVO */
- (void)renameObject:(id)child to:(NSString *)value {

	NSParameterAssert(child!=nil);
	NSParameterAssert(value!=nil);
	NSParameterAssert([value isKindOfClass:[NSString class]]);
	
	/* in order to change the dictionary key we need to remove the object and re-ad it */
	NSString *foundKey = [self keyForObject:child];
	NSAssert1(foundKey!=nil, @"cant find %@ in storage", value);

	[_dict removeObjectForKey:foundKey];
	[_dict setObject:child forKey:value];
}

// Reorder
- (void)setObjects:(id)child indexTo:(NSUInteger)i {

	NSParameterAssert(child!=nil);
	NSParameterAssert( (i!=NSNotFound) && (i<[_array count]));
	NSAssert([_array containsObject:child]==YES, @"setObject failed");
	NSAssert([[_dict allValues]  containsObject:child]==YES, @"setObject failed");
	
	NSUInteger currentIndex = [_array indexOfObjectIdenticalTo:child];
	NSAssert(currentIndex!=NSNotFound, @"cant reposition");
	if(currentIndex==i)
		return;

	NSArray *selectedObjects=nil;
	if([_selection count]){
		selectedObjects = [_array objectsAtIndexes:_selection];
		[_selection removeAllIndexes];
	}
	
	[self beganInconsistantState];
		// when we trigger the 
		// - willChange:NSKeyValueChangeInsertion valuesAtIndexes:
		// notification, we will be in an inconsistant state so it is very dangerous to do anything on this notification
		
		/* Won't trigger the notification here */
		[_array removeObjectAtIndex:currentIndex];
		/* trigger the KVO notification */
		[self insertObject:child inArrayAtIndex:i];
	[self endedInconsistantState];
	
	if(selectedObjects)
		[self setSelectedObjects:selectedObjects];
	
	NSAssert([_array containsObject:child]==YES, @"setObject failed");
	NSAssert([_array indexOfObjectIdenticalTo:child]==i, @"setObject failed");
	NSAssert([[_dict allValues]  containsObject:child]==YES, @"setObject failed");
}

// destination index must be a literal index ie if three objects index must be 0, 1 or 2
// unlike a tableView reorder which (with 3 objects) would let you drop at 0, 1, 2 or 3
// the objects that we pass in should really be in their natural order? does it matter?
- (void)moveObjects:(NSArray *)children toIndexes:(NSIndexSet *)indexes {

	NSParameterAssert( [children count] );
	NSParameterAssert( [children count]==[indexes count] );
	NSParameterAssert( [indexes lastIndex]<[_array count] );
		
	NSIndexSet *objectIndexes = [self indexesOfObjects:children];
	// dont bother if not moving anywhere
	if([objectIndexes isEqualToIndexSet:indexes] )
		return;

	NSArray *selectedObjects=nil;
	if([_selection count]){
		selectedObjects = [_array objectsAtIndexes:_selection];
		
		// this doesnt trigger a notification
//		[_selection removeAllIndexes];
		
		// i think we must trigger a deselct or proxy selection will get out of sync
		[self setSelection:[NSIndexSet indexSet]];

	}

	[self beganInconsistantState];
	// when we trigger the 
	// - willChange:NSKeyValueChangeInsertion valuesAtIndexes:
	// notification, we will be in an inconsistant state so it is very dangerous to do anything on this notification
	
	/* Won't trigger the notification here */
	[_array removeObjectsAtIndexes:objectIndexes];
	/* trigger the KVO notification */
	[self insertArray:children atIndexes:indexes];

	[self endedInconsistantState];
	
	// this will trigger a selection notification
	if(selectedObjects)
		[self setSelectedObjects:selectedObjects];
}

// array and dict are out of sync due to move index
- (void)beganInconsistantState {
//	[[NSNotificationCenter defaultCenter] postNotificationName:@"storageOutOfSync" object:self];
	
	_countOveride = [self count];
	_isInconsistent =YES;
}

- (void)endedInconsistantState {
	NSLog(@"back to normal -  become inconstant");
	_isInconsistent =NO;
}

//- (void)deleteSelectedObjects {
//
//	NSArray* selectedObjects = [[[self selectedObjects] copy] autorelease];
//	id ob;
//	for(ob in selectedObjects){
//		NSArray* allKeysForObject = [_dict allKeysForObject:ob];
//		NSAssert([allKeysForObject count]==1, @"this should never happen");
//		[self removeObjectForKey: [allKeysForObject lastObject]];
//	}
//	NSAssert1([_selection count]==0, @"deleteSelectedObjects failed %i", [_selection count]);
//}

#pragma mark Experimental Selection Methods
//- (void)selectAll {
//  [self setSelectedObjects: _array];
//}
  
//- (void)unSelectAll {
//	NSMutableIndexSet *updatedSelection = [NSIndexSet indexSet];
//	[self setSelection:updatedSelection];
//}

- (NSArray *)selectedObjects {

	NSMutableArray* selectedObjects = [NSMutableArray arrayWithCapacity: [_selection count]];
	NSUInteger current = [_selection firstIndex];
	while (current != NSNotFound) {

		[selectedObjects addObject:[_array objectAtIndex:current]];
        current = [_selection indexGreaterThanIndex: current];
	}
	NSAssert(selectedObjects!=nil, @"selectedObjects");
	return selectedObjects;
}

- (void)setSelectedObjects:(NSArray *)value {

	NSParameterAssert(value!=nil);
	
	NSIndexSet *updatedSelection = [self indexesOfObjects:value];
	if([updatedSelection isEqualToIndexSet:_selection]==NO)
		[self setSelection:[[updatedSelection mutableCopy] autorelease]];
}

- (void)addObjectsToSelection:(NSSet *)objects {
	
	NSParameterAssert(objects!=nil);
	
	/* NB : we send a notification that selection has changed - not that items have been added to the selection */
	[self willChangeValueForKey:@"selection"];
	for( id each in objects ){
		NSParameterAssert([_array containsObject:each]==YES);
		NSParameterAssert([[_dict allValues] containsObject:each]==YES);
		NSUInteger oindex = [_array indexOfObjectIdenticalTo:each];
		NSAssert(oindex!=NSNotFound, @"cant addObjectToSelection we dont contain");
		[_selection addIndex:oindex];
	}
	[self didChangeValueForKey:@"selection"];
}

- (void)addObjectToSelection:(id)value {

	NSParameterAssert(value!=nil);
	NSParameterAssert([_array containsObject:value]==YES);
	NSParameterAssert([[_dict allValues] containsObject:value]==YES);
	
	NSUInteger oindex = [_array indexOfObjectIdenticalTo:value];
	NSAssert(oindex!=NSNotFound, @"cant addObjectToSelection we dont contain");

	[self willChangeValueForKey:@"selection"];
	[_selection addIndex:oindex];
	[self didChangeValueForKey:@"selection"];
	
	NSAssert([_selection containsIndex:[_array indexOfObjectIdenticalTo:value]]==YES, @"addObjectToSelection failed");
}

- (void)removeObjectFromSelection:(id)value {

	NSParameterAssert(value!=nil);
	NSParameterAssert([_array containsObject:value]==YES);
	NSParameterAssert([[_dict allValues] containsObject:value]==YES);

	NSUInteger oindex = [_array indexOfObjectIdenticalTo:value];
	
	if([self isSelected:value]){
		[self willChangeValueForKey:@"selection"];
		[_selection removeIndex: oindex];
		[self didChangeValueForKey:@"selection"];
	} //else
	// this might happen to an interconnector
	//	logError(@"Cant DeSelect That Object %@", value);
	
	NSAssert([_selection containsIndex:[_array indexOfObjectIdenticalTo:value]]==NO, @"removeObjectFromSelection failed");
}

- (void)removeObjectsFromSelection:(NSSet *)objects {

	NSParameterAssert(objects!=nil);
	
	/* NB : we send a notification that selection has changed - not that items have been added to the selection */
	[self willChangeValueForKey:@"selection"];
	for( id each in objects ){
		NSParameterAssert([_array containsObject:each]==YES);
		NSParameterAssert([[_dict allValues] containsObject:each]==YES);
		NSUInteger oindex = [_array indexOfObjectIdenticalTo:each];
		NSAssert(oindex!=NSNotFound, @"cant addObjectToSelection we dont contain");
		[_selection removeIndex:oindex];
	}
	[self didChangeValueForKey:@"selection"];
}

- (BOOL)isSelected:(id)value {

	NSParameterAssert([_array containsObject:value]==YES);
	NSParameterAssert([[_dict allValues] containsObject:value]==YES);

	NSUInteger ind = [_array indexOfObjectIdenticalTo:value];
	if(ind!=NSNotFound && [_selection containsIndex:ind])
		return YES;
	return NO;
}

#pragma mark NSCopying, hash, isEqual

- (id)shallowCopy {

	SHOrderedDictionary* copy = [[[self class] alloc] initBase];
	NSMutableArray *array2 = [_array mutableCopy];
	NSMutableDictionary *dict2 = [_dict mutableCopy];
	copy->_array = array2;
	copy->_dict = dict2;
	return copy;
}

- (NSMutableArray *)deepCopyOfObjects {
	return [[_array collectResultsOfSelector:@selector(copy)] retain];
}

- (id)deepCopy {
	
	// -- copy all elements from array
	NSMutableArray *arrayCopy = [[self deepCopyOfObjects] autorelease];
	NSAssert([arrayCopy count]==[_array count], @"copy fucked up");
	[arrayCopy makeObjectsPerformSelector:@selector(release)];

	// 	-- keys are copied
	NSArray *orderedKeys = [self orderedKeys];
	NSMutableDictionary *dictCopy = [NSMutableDictionary dictionaryWithObjects:arrayCopy forKeys:orderedKeys];
	SHOrderedDictionary *orderedDictCopy = [[SHOrderedDictionary alloc] _initWithArray:arrayCopy dict:dictCopy];
	return orderedDictCopy;
}

/* Shhheeeeet! This is a shallow copy only ! */
//- (id)copyWithZone:(NSZone *)zone {
//}

- (void)encodeWithCoder:(NSCoder *)coder {

	[coder encodeObject:_array forKey:@"array"];
	[coder encodeObject:_dict forKey:@"dict"];
}

 - (BOOL)isEqualToOrderedDict:(SHOrderedDictionary *)value {
 
	NSParameterAssert(value!=nil);
	NSParameterAssert([value isKindOfClass:[self class]]);

	/* We dont do isEqual here as.. erm.. I dont want to overide isEqual for SHNode, as i would also need to overide the hash 
	as i understand it this would mean that i wouldn't be able to change the name of a node once it is in the container
	*/
	 if([self count]!=[value count])
		 return NO;
	 
	 NSArray *array2 = [value array];
	 NSDictionary *dict2 = [value dict];

	 NSUInteger i=0;
	 for( id each in _array )
	 {
		 id other = [array2 objectAtIndex:i];
		 if([each isEquivalentTo:other]==NO)
			 return NO;
		 
		 id key1 = [[_dict allKeysForObject:each] objectAtIndex:0];
		 id key2 = [[dict2 allKeysForObject:other] objectAtIndex:0];
		 if([key1 isEqual:key2]==NO)
			 return NO;
		 i++;
	 }
	return YES;
 }
 

/* redirect fast enumeration calls to the array */
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len {
	return [_array countByEnumeratingWithState:state objects:stackbuf count:len];
}

#pragma mark accessor methods

- (BOOL)containsObject:(id)anObject {

 	NSParameterAssert(anObject!=nil);
	NSUInteger ind = [_array indexOfObjectIdenticalTo: anObject];
	return (ind!=NSNotFound);
	
	// NB containsObject will send -isEqual to each object, we just want to know for objects identicle to
	// return [_array containsObject:anObject];
}

- (NSEnumerator *)objectEnumerator {

	return [_array objectEnumerator];
}

- (NSEnumerator *)keyEnumerator {

	return [_dict keyEnumerator];
}

- (id)objectAtIndex:(NSUInteger)oindex {

	NSParameterAssert(oindex!=NSNotFound);
	NSParameterAssert(oindex<[_array count]);
	id ob = [_array objectAtIndex: oindex];
	return ob;
}

- (NSUInteger)indexOfObjectIdenticalTo:(id)anObject {
 	NSParameterAssert(anObject!=nil);
	return [_array indexOfObjectIdenticalTo:anObject];
}

- (NSIndexSet *)indexesOfObjects:(NSArray *)children {
	
	NSMutableIndexSet *objectIndexes = [NSMutableIndexSet indexSet];
	NSInteger previousIndex = -1;
	for( id each in children ){
		NSUInteger currentIndex = [self indexOfObjectIdenticalTo:each];
		NSAssert(currentIndex!=NSNotFound, @"cant reposition");
		[objectIndexes addIndex:currentIndex];
		// check that the objects passed in are in the correct order
		if((NSInteger)currentIndex<=previousIndex)
			[NSException raise:@"I think you must pass the objects in in the correct order" format:@"Dick wad"];
		previousIndex = currentIndex;
	}
	return objectIndexes;
}

//- (NSUInteger)indexOfObject:(id)anObject {
//	
// 	NSParameterAssert(anObject!=nil);
//	return [_array indexOfObjectIdenticalTo:anObject];
//}

- (NSArray *)allValues {

	return [self array];
}

- (NSUInteger)count {
	
	if(_isInconsistent)
		return _countOveride;
	
    NSAssert2( [_array count]==[_dict count], @"count in orderedDict is out of whack -- array(%i), dict(%i)", [_array count],[_dict count]);
	return [_array count];
}

- (NSArray *)array {
    return [[_array copy] autorelease];
}

- (NSUInteger)countOfArray {
    return [_array count];
}

- (id)objectInArrayAtIndex:(NSUInteger)theIndex {

    return [_array objectAtIndex:theIndex];
}

- (void)getArray:(id *)objsPtr range:(NSRange)range {

    [_array getObjects:objsPtr range:range];
}

- (void)insertObject:(id)obj inArrayAtIndex:(NSUInteger)theIndex {
	
	NSIndexSet *set = [NSIndexSet indexSetWithIndex:theIndex];
	[self willChange:NSKeyValueChangeInsertion valuesAtIndexes:set forKey:@"array"];
    [_array insertObject:obj atIndex:theIndex];
	NSAssert2([_array count]==[_dict count], @"oops %i vs %i", [_array count], [_dict count]);
	[self didChange:NSKeyValueChangeInsertion valuesAtIndexes:set forKey:@"array"];
}

- (void)removeObjectFromArrayAtIndex:(NSUInteger)theIndex {

	[self willChange:NSKeyValueChangeRemoval valuesAtIndexes:[NSIndexSet indexSetWithIndex:theIndex] forKey:@"array"];

    [_array removeObjectAtIndex:theIndex];
	NSAssert2([_array count]==[_dict count], @"_array has %i, _dict has %i", [_array count], [_dict count]);
	
	[self didChange:NSKeyValueChangeRemoval valuesAtIndexes:[NSIndexSet indexSetWithIndex:theIndex] forKey:@"array"];
}

- (void)replaceObjectInArrayAtIndex:(NSUInteger)theIndex withObject:(id)obj {

	[self willChange:NSKeyValueChangeReplacement valuesAtIndexes:[NSIndexSet indexSetWithIndex:theIndex] forKey:@"array"];

    [_array replaceObjectAtIndex:theIndex withObject:obj];
	NSAssert([_array count]==[_dict count], @"oops");
	
	[self didChange:NSKeyValueChangeReplacement valuesAtIndexes:[NSIndexSet indexSetWithIndex:theIndex] forKey:@"array"];
}

/* newish(?) kvc indexed accessors for multiple replacements NSKeyValueCoding.h */
- (void)insertArray:(NSArray *)objects atIndexes:(NSIndexSet *)indexes {
    
	NSParameterAssert([objects count]==[indexes count]);

	[self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"array"];
    [_array insertObjects:objects atIndexes:indexes];
	[self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"array"];
}

- (void)removeArrayAtIndexes:(NSIndexSet *)indexes {
    
	[self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"array"];
    [_array removeObjectsAtIndexes:indexes];
	[self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"array"];
}

/* There is a reason to use the retain] autorelease] pattern:
 id someObject = [foo bar];
 [foo setBar:nil];
 [someObject doSomething]; // CRASH
*/
- (NSMutableDictionary *)dict {
    return [[_dict copy] autorelease];
}

- (void)setDict:(NSMutableDictionary *)value {

    if (_dict != value) {
        [_dict release];
        _dict = [value retain];
    }
}

- (void)setArray:(NSMutableArray *)value {

    if (_array != value) {
        [_array release];
        _array = [value retain];
    }
}

- (NSMutableIndexSet *)selection { return [[_selection mutableCopy] autorelease]; }
- (void)setSelection:(NSMutableIndexSet *)value {

	// we have to do manual KVO notifications if we wanted to test for equality before triggering a change in value
	if(value!=_selection  && [value isEqualToIndexSet:_selection]==NO )
	{
		if(value!=nil && [value count]!=0){
			NSUInteger lastIndex = [value lastIndex]; 
			if(lastIndex>=[self count])
				[NSException raise:@"selected indexes are impossible" format:@""];
		}
	
		if(value!=nil && [value class]!=[NSMutableIndexSet class])
		{
			value = [[value mutableCopy] autorelease];
		}

		[self willChangeValueForKey:@"selection"];
		[_selection release];
		_selection = [value retain];
		[self didChangeValueForKey:@"selection"];
	}
}

- (NSArray *)allKeysForObject:(id)anObject {

	return [_dict allKeysForObject:anObject];
}

- (NSString *)keyForObject:(id)anObject {

	NSArray *allKeys = [self allKeysForObject:anObject];
	NSAssert1([allKeys count]<2, @"an object should not have more than one key %i", [allKeys count] );

	if([allKeys count]==1)
		return [allKeys objectAtIndex:0];
		
	return nil;
}

- (NSArray *)orderedKeys {

	NSMutableArray *orderedKeys = [NSMutableArray arrayWithCapacity:[_array count]];
	for( id each in _array ){
		id existingKey = [self keyForObject:each];
		[orderedKeys addObject:existingKey];
	}
	return orderedKeys;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"%@(%@)", [super description], [_array description]];
}

@end
