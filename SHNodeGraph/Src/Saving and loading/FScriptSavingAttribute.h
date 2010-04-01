//
//  FScriptSavingAttribute.h
//  SHNodeGraph
//
//  Created by Steven Hooley on 10/09/2007.
//  Copyright 2007 HooleyHoop. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SHAttribute.h"
#import "FScriptSaving_protocol.h"

@interface SHAttribute (FScriptSavingAttribute) <FScriptSaving_protocol>

/* set the value of auto made attribute */
- (NSString *)fScriptString_duplicateContentsInto:(NSString *)nodeIdentifier_fscript restoreState:(BOOL)restoreFlag;

/* make a new copy */
- (NSString *)fScriptString_duplicate;
- (NSString *)fScriptString_duplicateWithoutValue;

@end
