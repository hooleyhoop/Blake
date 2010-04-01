//
//  NSArray_Extensions.h
//
//  Copyright (c) 2001-2002, Apple. All rights reserved.
//

//#import <Foundation/Foundation.h>


/*
*
*/
@interface NSArray (MyExtensions)

- (BOOL)isEquivalentTo:(NSArray *)anotherArray;

- (BOOL)containsObjectIdenticalTo: (id)object;

- (NSMutableArray *)itemsThatRespondToSelector:(SEL)aSelector;

- (NSMutableArray *)itemsThatResultOfSelectorIsNotNIL:(SEL)aSelector;

// aSelector must return an NSNumber
- (NSMutableArray *)itemsThatResultOfSelectorIsTrue:(SEL)aSelector withObject:(id)value;

- (NSMutableArray *)collectResultsOfSelector:(SEL)aSelector;

- (id)firstItemThatResultOfSelectorIsTrue:(SEL)aSelector withObject:(id)value;

@end


/*
 *
*/
@interface NSMutableArray (MyExtensions)

- (void) insertObjectsFromArray:(NSArray *)array atIndex:(int)index;



@end

