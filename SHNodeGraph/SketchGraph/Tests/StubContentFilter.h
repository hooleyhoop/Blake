//
//  StubContentFilter.h
//  BlakeLoader
//
//  Created by steve hooley on 31/05/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SHNodegraph/SHContentProvidorProtocol.h>
#import <SHNodegraph/AbtractModelFilter.h>

@class SHooleyObject;

@interface StubContentFilter : AbtractModelFilter <SHContentProvidorProtocol> {
    
}

+ (StubContentFilter *)sharedInstance;

@end