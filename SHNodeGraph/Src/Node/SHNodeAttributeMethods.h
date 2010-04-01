//
//  SHNodeAttributeMethods.h
//  SHNodeGraph
//
//  Created by Steven Hooley on 09/11/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SHNode.h"
//!Alert-putback! #import <SHShared/SHAttributeProtocol.h>

/*
 *
*/
@interface SHNode (SHNodeAttributeMethods) 

#pragma mark action methods
//- (void)setContentsOfInputWithKey:(NSString *)aKey with:(id)aValue;

#pragma mark accessor methods
- (int)numberOfInputs;
- (int)numberOfOutputs;

// @properties
// - (SHOrderedDictionary *)inputs;
// - (SHOrderedDictionary *)outputs;

//!Alert-putback!- (id<SHAttributeProtocol>)inputAttributeAtIndex:(int)index;
//!Alert-putback!- (id<SHAttributeProtocol>)outputAttributeAtIndex:(int)index;

//!Alert-putback!- (id<SHAttributeProtocol>)inputAttributeWithKey:(NSString *)key;
//!Alert-putback!- (id<SHAttributeProtocol>)outputAttributeWithKey:(NSString *)key;

@end
