//
//  SHOrderedDictionary.h
//  Shared
//
//  Created by Steven Hooley on 28/07/2007.
//  Copyright 2007 HooleyHoop. All rights reserved.
//


/*
 *
*/
@interface SHOrderedDictionary : _ROOT_OBJECT_ {

	NSMutableArray			*_array;
	NSMutableDictionary		*_dict;
	NSMutableIndexSet		*_selection;
	
	BOOL					_isInconsistent;
	NSUInteger				_countOveride;
}

#pragma mark -
#pragma mark class methods
+ (id)dictionary;

#pragma mark action methods
- (void)removeObjectForKey:(id)aKey;
- (void)removeObject:(id)anObject;

- (void)removeObjectsForKeys:(NSArray *)keys;
//- (void)removeObjects:(NSArray *)objects;
- (void)removeObjectsAtIndexes:(NSIndexSet *)indexes;
- (void)removeObjectsAtIndexes:(NSIndexSet *)indexes keys:(NSArray *)keys;

- (void)setObject:(id)anObject forKey:(id)aKey;
- (void)setObject:(id)anObject atIndex:(NSUInteger)ind forKey:(id)aKey;

/* 	-- indexes can be nil */
- (void)setObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes forKeys:(NSArray *)keys;

- (id)objectForKey:(id)aKey;
- (void)renameObject:(id)child to:(NSString *)value;
 
// Reorder - Index is not the same as a table drop position! (If you have 3 items any one item could be at 0,1,2 put you could drag it in a table to 0,1,2,3)
// Preserves selection
- (void)setObjects:(id)child indexTo:(NSUInteger)i;
- (void)moveObjects:(NSArray *)children toIndexes:(NSIndexSet *)indexes;
// reorder is dangerous because on the -willInsert notification we will be inconsistant (dict stays the same but object has been removed from array) -count, -objectAtIndex will be broken
- (void)beganInconsistantState;
- (void)endedInconsistantState;

//- (void)deleteSelectedObjects;
 
 #pragma mark Experimental Selection Methods
//- (void)selectAll;
// - (void)unSelectAll;
- (void)setSelectedObjects:(NSArray *)value;
- (NSArray *)selectedObjects;
- (void)addObjectToSelection:(id)value;
- (void)addObjectsToSelection:(NSSet *)objects;
- (void)removeObjectFromSelection:(id)value;
- (void)removeObjectsFromSelection:(NSSet *)value;

- (BOOL)isSelected:(id)value;

 #pragma mark NSCopying, hash, isEqual
- (NSMutableArray *)deepCopyOfObjects;
- (id)shallowCopy;
- (id)deepCopy;
- (BOOL)isEqualToOrderedDict:(SHOrderedDictionary *)value;
 
#pragma mark accessor methods
- (BOOL)containsObject:(id)anObject;

- (NSEnumerator *)objectEnumerator;
// NB! Keys wont be in the same order as the objects
- (NSEnumerator *)keyEnumerator;

- (id)objectAtIndex:(NSUInteger)index;
//- (NSUInteger)indexOfObject:(id)anObject DEPRECATED_ATTRIBUTE;
- (NSUInteger)indexOfObjectIdenticalTo:(id)anObject;
- (NSIndexSet *)indexesOfObjects:(NSArray *)children;

- (NSArray *)allValues;
- (NSUInteger)count;

- (NSArray *)array;
- (NSUInteger)countOfArray;
- (id)objectInArrayAtIndex:(NSUInteger)theIndex;
- (void)getArray:(id *)objsPtr range:(NSRange)range;
- (void)insertObject:(id)obj inArrayAtIndex:(NSUInteger)theIndex;
- (void)removeObjectFromArrayAtIndex:(NSUInteger)theIndex;
- (void)replaceObjectInArrayAtIndex:(NSUInteger)theIndex withObject:(id)obj;
- (void)removeArrayAtIndexes:(NSIndexSet *)indexes;
- (void)insertArray:(NSArray *)objects atIndexes:(NSIndexSet *)indexes;

- (NSMutableDictionary *)dict;
- (void)setDict:(NSMutableDictionary *)value;

- (void)setArray:(NSMutableArray *)value;

- (NSMutableIndexSet *)selection;
- (void)setSelection:(NSMutableIndexSet *)value;

- (NSArray *)allKeysForObject:(id)anObject;    
- (NSString *)keyForObject:(id)anObject;

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len;

- (NSArray *)orderedKeys;

@end


@interface SHOrderedDictionary (Private)

- (id)_initWithArray:(NSMutableArray *)ar dict:(NSMutableDictionary *)dc;
	
@end
