//
//  SHInstanceCounter.h
//  Objc-2 swizzle test
//
//  Created by steve hooley on 01/08/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

@interface SHInstanceCounter : _ROOT_OBJECT_ {

}

#ifdef DEBUG
+ (void)cleanUpInstanceCounter;

+ (void)objectCreated:(id)value;
+ (void)objectDestroyed:(id)value;

+ (NSString *)instanceDescription:(id)value;

+ (void)printLeakingObjectInfo;
+ (void)printSmallLeakingObjectInfo;
+ (void)printSmallLeakingObjectInfoSinceMark;

+ (void)newMark;
+ (NSInteger)instanceCount;
+ (NSInteger)instanceCountSinceMark;

+ (NSUInteger)indexOfSinceMark:(id)value;
+ (NSUInteger)indexOf:(id)value;
#endif

@end
