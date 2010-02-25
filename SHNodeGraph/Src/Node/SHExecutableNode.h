//
//  SHExecutableNode.h
//  Pharm
//
//  Created by Steve Hooley on 12/10/2005.
//  Copyright 2005 HooleyHoop. All rights reserved.
//

#import "SHNode.h"


#ifndef _SHExecutableNodeGroup_H
#define _SHExecutableNodeGroup_H

// 0 - call evaluate when asked and when dirty - most once per frame	// PROCESSOR
// 1 - call evaluate when asked - most once per frame					// PROVIDER
// 2 - call once per frame												// CONSUMER
enum SHExecutionModes {	
	PROCESSOR, 
	PROVIDER, 
	CONSUMER
};


/*
 *
*/
@interface SHNode (SHExecutableNode) 

#pragma mark -
#pragma mark class methods
+ (int)executionMode;

#pragma mark action methods

- (BOOL)evaluateOncePerFrame:(id)fp8 head:(id)np time:(CGFloat)compositionTime arguments:(id)fp20;

/* dont call this - not gaurenteed to be once per frame. This is only ever called from evaluateOncePerFrame */
- (BOOL)execute:(id)fp8 head:(id)np time:(CGFloat)compositionTime arguments:(id)fp20;

// badly named and vague action! typically called by evaluateOncePerFrame after execute, but can be called without calling execute
- (void)enforceConsistentState;

#pragma mark accessor methods
//11/06/06 - (void) addAdvanceTimeInvocation:(NSInvocation*)anInvocation;
//11/06/06 - (void) removeAdvanceTimeInvocation:(NSInvocation*)anInvocation;

@end
#endif
