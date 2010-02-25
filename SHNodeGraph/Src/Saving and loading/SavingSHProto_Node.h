//
//  SavingSHProto_Node.h
//  SHNodeGraph
//
//  Created by Steve Hooley on 18/01/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SHNode.h"

/*
 *
*/
@interface SHNode (SavingSHProto_Node) 

+ (NSString *)reverseSaveName:(NSString *)value;

- (NSString *)saveName;

@end
