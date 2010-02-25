//
//  NSIndexSet_Extras.m
//  SHShared
//
//  Created by steve hooley on 21/12/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "NSIndexSet_Extras.h"


@implementation NSIndexSet (NSIndexSet_Extras)

/* I think this is becaue we call -willChange:NSKeyValueChangeReplacement valuesAtIndexes:notUsed forKey:@"currentFilteredContentSelectionIndexes" for the selction indexes - it thinks it is an array or something
 
 I guess this is pretty terrible but KVO for NSMutableIndexSet doesn't seem to work well, so what can you do?
*/

- (NSArray *)objectsAtIndexes:(NSIndexSet *)indexes {
	return nil;
}

- (NSUInteger)positionOfIndex:(NSUInteger)cindex {
	return [self countOfIndexesInRange: NSMakeRange(0, cindex)];
}

- (NSIndexSet *)positionsOfIndexes:(NSIndexSet *)indexes {

	NSMutableIndexSet *newIndexes = [[NSMutableIndexSet alloc] init];
	NSUInteger firstIndex = [indexes firstIndex];
	while( firstIndex!=NSNotFound ) {
		NSUInteger pos = [self positionOfIndex:firstIndex];
		[newIndexes addIndex:pos];
		firstIndex=[indexes indexGreaterThanIndex:firstIndex];
	}
	return [newIndexes autorelease];
}

- (NSUInteger)countOfIndexesInRange:(NSRange)range {
	
	NSUInteger start, end, count;
	if ((range.length == 0)) {
		return 0;	
	}
	
	start	= range.location;
	end		= start + range.length;
	count	= 0;
	
	NSUInteger currentIndex = [self indexGreaterThanOrEqualToIndex:start];
	
	while ((currentIndex != NSNotFound) && (currentIndex < end)) {
		count++;
		currentIndex = [self indexGreaterThanIndex:currentIndex];
	}
	
	return count;
}

- (NSMutableIndexSet *)copyIndexesShiftedBy:(NSInteger)shiftAmount {

	NSMutableIndexSet *newIndexes = [self mutableCopy];
	[newIndexes shiftIndexesStartingAtIndex:0 by:shiftAmount];
	return newIndexes;
}

- (NSIndexSet *)copyIndexesExcluding:(NSIndexSet *)indexesToExclude {

	NSMutableIndexSet *newIndexes = [[NSMutableIndexSet alloc] init];
	NSUInteger firstIndex = [self firstIndex];

	while( firstIndex!=NSNotFound ) {
		if( ![indexesToExclude containsIndex:firstIndex] )
			[newIndexes addIndex:firstIndex];
		firstIndex=[self indexGreaterThanIndex:firstIndex];
	}

	return newIndexes;
}

// I think this is useful
// what it is supposed to do is.. say you have an array of nodes,
// Then you insert three nodes at {2,4,6}
// Then you insert three more nodes at {0,2,5}
// What are the indexes of the 6 nodes you have inserted?
- (NSIndexSet *)offsetAndMerge:(NSIndexSet *)value {

	NSMutableIndexSet *newIndexes = [self mutableCopy];

	NSUInteger firstIndex = [value firstIndex];
	while( firstIndex!=NSNotFound ) {

		// -- all indexes in self greater than or equal to firstIndex shift right by 1
		[newIndexes shiftIndexesStartingAtIndex:firstIndex by:1];   
		firstIndex=[value indexGreaterThanIndex:firstIndex];
	}
	[newIndexes addIndexes:value];
	return [newIndexes autorelease];
}

- (NSIndexSet *)reverseOffsetAndMerge:(NSIndexSet *)value {
	return [value offsetAndMerge:self];
}

- (NSIndexSet *)indexesLessThan:(NSUInteger)value {
		
	if(value==0)
		return [NSIndexSet indexSet];
	NSMutableIndexSet *mutableCopy = [[self mutableCopy] autorelease];
	NSRange removeRange = NSMakeRange(value,[self lastIndex]+1);
	[mutableCopy removeIndexesInRange:removeRange];
	return mutableCopy;
}

- (NSIndexSet *)indexesGreaterThanOrEqualTo:(NSUInteger)value {
		
	NSMutableIndexSet *mutableCopy = [[self mutableCopy] autorelease];
	[mutableCopy removeIndexesInRange:NSMakeRange(0,value)];
	return mutableCopy;
}

@end
