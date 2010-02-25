//
//  NSIndexSet_Extras.h
//  SHShared
//
//  Created by steve hooley on 21/12/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

@interface NSIndexSet (NSIndexSet_Extras) 

- (NSUInteger)positionOfIndex:(NSUInteger)index;
- (NSIndexSet *)positionsOfIndexes:(NSIndexSet *)indexes;

- (NSUInteger)countOfIndexesInRange:(NSRange)range;

- (NSMutableIndexSet *)copyIndexesShiftedBy:(NSInteger)shiftAmount;
- (NSIndexSet *)copyIndexesExcluding:(NSIndexSet *)indexesToExclude;

- (NSIndexSet *)offsetAndMerge:(NSIndexSet *)value;
- (NSIndexSet *)reverseOffsetAndMerge:(NSIndexSet *)value;

- (NSIndexSet *)indexesLessThan:(NSUInteger)value;
- (NSIndexSet *)indexesGreaterThanOrEqualTo:(NSUInteger)value;

@end
