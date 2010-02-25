//
//  NSObject_Extras.h
//  SHShared
//
//  Created by steve hooley on 16/11/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//


@interface NSObject (NSObject_Extras) 

// Needed because we swap out hooleyObject
- (id)initBase;

// 2 empty SHooleyObjects are equivalent
- (BOOL)isEquivalentTo:(id)value;

+ (NSString *)classAsString;
- (NSString *)classAsString;

- (BOOL)performInstanceSelectorReturningBool:(SEL)selector;
- (BOOL)performInstanceSelectorReturningBool:(SEL)selector withObject:(id)value;

@end
