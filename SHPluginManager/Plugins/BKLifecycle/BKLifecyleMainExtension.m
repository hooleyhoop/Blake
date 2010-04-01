//
//  BKLifecyleMainExtension.m
//  Blocks
//
//  Created by Jesse Grosjean on 1/10/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKLifecyleMainExtension.h"
#import "BKLifecycleController.h"


@implementation BKLifecyleMainExtension

- (id)init {
	
	self = [super init];
    if(self) {
		[BKLifecycleController sharedInstance];
    }
    return self;
}

@end
