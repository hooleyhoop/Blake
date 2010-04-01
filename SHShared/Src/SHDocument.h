//
//  SHDocument.h
//  SHShared
//
//  Created by steve hooley on 12/06/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//
#import <Appkit/NSDocument.h>

@interface SHDocument : NSDocument {

    BOOL			_isClosed;

}

@property (readwrite, nonatomic) BOOL isClosed;

- (BOOL)hasWindowControllerOfClass:(Class)winControllerClass;

@end
