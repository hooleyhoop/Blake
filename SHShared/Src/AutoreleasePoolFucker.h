//
//  AutoreleasePoolFucker.h
//  SHShared
//
//  Created by steve hooley on 25/03/2010.
//  Copyright 2010 BestBefore Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AutoreleasePoolFucker : NSObject {
	
	NSString *_poolDataString;
}

// single objects
+ (BOOL)isLeaking_takingIntoAccountAutoReleases:(NSObject *)arg;
+ (NSUInteger)autoreleaseCount:(NSObject *)arg;

// multiple objects
+ (id)poolFucker;
- (BOOL)mult_isLeaking_takingIntoAccountAutoReleases:(NSObject *)arg;

@end
