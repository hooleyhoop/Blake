//
//  NSMutableArray_ CSCSortedInsertion.h
//  SHShared
//
//  Created by Steven Hooley on 28/06/2010.
//  Copyright 2010 Tinsal Parks. All rights reserved.
//


@interface NSMutableArray (CSCSortedInsertion)


// Array must already be sorted
- (void)CSC_insertObject:(id)object inArraySortedUsingSelector:(SEL)selector;
- (void)CSC_insertObjects:(NSArray*)objects inArraySortedUsingSelector:(SEL)selector;

@end