//
//  FScriptSavingProtoNode.h
//  SHNodeGraph
//
//  Created by Steven Hooley on 10/09/2007.
//  Copyright 2007 HooleyHoop. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SHNode.h"
#import "FScriptSaving_protocol.h"

@interface SHNode (FScriptSavingProtoNode) <FScriptSaving_protocol>

- (NSString *)fScriptString_duplicateContentsInto:(NSString *)nodeIdentifier_fscript;

- (NSString *)fScriptString_duplicate;

@end
