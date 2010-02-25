//
//  SHAutoReleasePool.m
//  SHNodeGraph
//
//  Created by Steve Hooley on 15/05/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import "SHAutoReleasePool.h"


@implementation NSAutoreleasePool (SHAutoReleasePool)

- (void)dealloc
{
	logInfo(@"SHAutoReleasePool deallocing autoreleasepool");
	[super dealloc];
}
@end
