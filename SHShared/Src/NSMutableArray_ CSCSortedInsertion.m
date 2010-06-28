//
//  NSMutableArray_ CSCSortedInsertion.m
//  SHShared
//
//  Created by Steven Hooley on 28/06/2010.
//  Copyright 2010 Tinsal Parks. All rights reserved.
//
#import <objc/message.h>

#import "NSMutableArray_ CSCSortedInsertion.h"

typedef NSComparisonResult (*CompareFunction)(id,SEL,id);

@implementation NSMutableArray (CSCSortedInsertion)

static inline NSUInteger FindIndexForInsertionWithKnownBounds( NSArray *array, id object, SEL selector, NSUInteger low, NSUInteger high) {
	
    NSUInteger index = low;
	
    while (index < high) {
        const NSUInteger mid = (index + high)/2;
        id test = [array objectAtIndex: mid];
		
        if (((CompareFunction)objc_msgSend(test, selector, object)) < 0) {
            index = mid + 1;
        } else {
            high = mid;
        }
    }
	
    return index;
}

static inline NSUInteger FindIndexForInsertion( NSArray *array, id object, SEL selector) {
    return FindIndexForInsertionWithKnownBounds(array, object, selector, 0, array.count);
}

- (void)CSC_insertObject:(id)object inArraySortedUsingSelector:(SEL)selector {
    [self insertObject: object atIndex: FindIndexForInsertion(self, object, selector)];
}

- (void)CSC_insertObjects:(NSArray *)objects inArraySortedUsingSelector:(SEL)selector {
	
    objects = [objects sortedArrayUsingSelector: selector];
    NSUInteger  index = 0;
    NSUInteger  count = self.count;
	
    for( id object in objects ) {
        //Since objects is sorted, we can rule out any index that is less than the one for the last insertion
		index = FindIndexForInsertionWithKnownBounds( self, object, selector, index, count++);
        [self insertObject:object atIndex:index];
    }
}

@end
