//
//  AutoreleasePoolFucker.h
//  SHShared
//
//  Created by steve hooley on 25/03/2010.
//  Copyright 2010 BestBefore Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AutoreleasePoolFucker : NSObject {
	
}

+ (BOOL)isLeaking_takingIntoAccountAutoReleses:(NSObject *)arg;
+ (NSUInteger)autoreleaseCount:(NSObject *)arg;

@end
