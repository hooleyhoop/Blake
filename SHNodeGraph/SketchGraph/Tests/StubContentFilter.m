//
//  StubContentFilter.m
//  BlakeLoader
//
//  Created by steve hooley on 31/05/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "StubContentFilter.h"

StubContentFilter *sharedInstance;

@implementation StubContentFilter

+ (StubContentFilter *)sharedInstance {
    return sharedInstance;
}

- (id)init {
    // -- do a singleton
    if(sharedInstance==nil){
        sharedInstance = [super init];
    }
    return sharedInstance;
}

- (void)dealloc {
    
    sharedInstance = nil;
    [super dealloc];
}



@end
