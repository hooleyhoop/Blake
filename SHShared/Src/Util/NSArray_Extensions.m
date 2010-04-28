#import "NSArray_Extensions.h"
// #import <Foundation/NSObjCRuntime.h>
#include <objc/objc-runtime.h>
//#import <objc/runtime.h>
#import "NSObject_Extras.h"

/*
 *
*/
@implementation NSArray (MyExtensions)

- (BOOL)isEquivalentTo:(NSArray *)anotherArray {
	
	NSParameterAssert( anotherArray );
	
	if([self count]!=[anotherArray count])
		return NO;

	NSUInteger i=0;
	
	for( id each in self )
	{
		id other = [anotherArray objectAtIndex:i];
		BOOL equivalence = [each isEquivalentTo:other];
		if( !equivalence )
			return NO;
		i++;
	}
	return YES;
}

- (BOOL)containsObjectIdenticalTo:(id)obj { 
    return [self indexOfObjectIdenticalTo: obj]!=NSNotFound; 
}

- (NSMutableArray *)itemsThatRespondToSelector:(SEL)aSelector {

	NSMutableArray *returnedItems = [NSMutableArray array];
	for( id ob in self ) 
	{
		if([ob respondsToSelector:aSelector])
			[returnedItems addObject:ob];
	}
	return returnedItems;
}

- (NSMutableArray *)itemsThatResultOfSelectorIsNotNIL:(SEL)aSelector {

	NSMutableArray *returnedItems = [NSMutableArray array];
	for( id ob in self ) {
		if([ob respondsToSelector:aSelector]){
			id result = [ob performSelector:aSelector];
			if(result!=nil)
				[returnedItems addObject:ob];
		}
	}
	return returnedItems;
}

- (NSMutableArray *)collectResultsOfSelector:(SEL)aSelector {

	NSMutableArray *returnedItems = [NSMutableArray array];
	for( id ob in self ) 
	{
		if([ob respondsToSelector:aSelector]){
			id result = [ob performSelector:aSelector];
			if(result!=nil)
				[returnedItems addObject:result];
		}
	}
	return returnedItems;
}

// This works!
//NSPredicate *elePred1 = [NSPredicate predicateWithFormat:@"self isKindOfClass: %@", ec];
//NSArray *elephants2 = [array filteredArrayUsingPredicate:elePred1];

// Or Blocks! Compare speed!
//NSMutableArray *results = [NSMutableArray array];
//[array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
//	if([obj isKindOfClass:[Elephant class]])
//		[results addObject:obj];
//}];

// aSelector must return an NSNumber
- (NSMutableArray *)itemsThatResultOfSelectorIsTrue:(SEL)aSelector withObject:(id)value {

	NSMutableArray* returnedItems = [NSMutableArray array];
	for( id ob in self ) 
	{
		if([ob respondsToSelector:aSelector]){
			id result = [ob performSelector:aSelector withObject:value];
			if([result respondsToSelector:@selector(boolValue)])
			{
				if([result boolValue]==YES)
					[returnedItems addObject:ob];
			}
		}
	}
	return returnedItems;
}

- (id)firstItemThatResultOfSelectorIsTrue:(SEL)aSelector withObject:(id)value {

	for( NSObject *ob in self ) {
		if([ob respondsToSelector:aSelector]){
			BOOL result =  [ob performInstanceSelectorReturningBool:aSelector withObject:value];
			if(result)
				return ob;
		}
	}
	return nil;
}

@end

/*
 *
*/
@implementation NSMutableArray (MyExtensions)

- (void)insertObjectsFromArray:(NSArray *)array atIndex:(int)oindex {

    for( NSObject *entry in array ) {
        [self insertObject:entry atIndex: oindex++];
    }
}

@end
