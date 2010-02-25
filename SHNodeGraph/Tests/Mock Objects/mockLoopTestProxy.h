//
//  mockLoopTestProxy.h
//  SHNodeGraph
//
//  Created by Steve Hooley on 21/06/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

@interface mockLoopTestProxy : _ROOT_OBJECT_ {

}

#pragma mark -
#pragma mark class methods
+ (id) loopTestProxy;

#pragma mark action methods

- (void) reset;

#pragma mark accessor methods
- (BOOL) loopConditionalTest;

- (BOOL) success;

@end
