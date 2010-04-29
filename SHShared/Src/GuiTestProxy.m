//
//  GuiTestProxy.m
//  InAppTests
//
//  Created by steve hooley on 08/02/2010.
//  Copyright 2010 BestBefore Ltd. All rights reserved.
//

#import "GuiTestProxy.h"
#import "DelayedPerformer.h"
#import <SHShared/NSInvocation(ForwardedConstruction).h>
#import "FScript/FScript.h"
#import <objc/message.h>

#pragma mark -
@implementation GUITestProxy

#pragma mark -
+ (GUITestProxy *)wait {

	GUITestProxy *aRemoteTestProxy = [[GUITestProxy alloc] init];
	aRemoteTestProxy.debugName = @"wait";
	
	/* Construct an Invocation for the Notification - we aren't going to send it till we have a callback set */
	[[NSInvocation makeRetainedInvocationWithTarget:aRemoteTestProxy
	invocationOut: &(aRemoteTestProxy->_remoteInvocation)] 
	 wait];
	
	[aRemoteTestProxy->_remoteInvocation retain];
	
	/* _waitTimerFire */
	aRemoteTestProxy.recievesAsyncCallback = YES;

	return [aRemoteTestProxy autorelease];
}

// Fire a selector on an instance
+ (GUITestProxy *)doTo:(id)object selector:(SEL)method {

	GUITestProxy *aRemoteTestProxy = [[GUITestProxy alloc] init];
	aRemoteTestProxy->_debugName = @"doto";

	NSInvocation *inv = [NSInvocation makeRetainedInvocationWithTarget:object 
													 invocationOut:&(aRemoteTestProxy->_remoteInvocation)];
	objc_msgSend(inv,method,nil);
	[aRemoteTestProxy->_remoteInvocation retain];
	return [aRemoteTestProxy autorelease];
}

+ (GUITestProxy *)lockTestRunner {

	GUITestProxy *aRemoteTestProxy = [[[GUITestProxy alloc] init] autorelease];
	aRemoteTestProxy->_debugName = @"lockTestRunner";

	NSString *exprString = @"[HooAsyncTestRunner lock]";
	FSBlock *exprBlock = _BLOCK(exprString);
	aRemoteTestProxy.boolExpressionBlock = exprBlock;

	return aRemoteTestProxy;
}

// we lock directly, brut of course need to unlock asyncronously when all queued methods have finished
+ (GUITestProxy *)unlockTestRunner {

	GUITestProxy *aRemoteTestProxy = [[[GUITestProxy alloc] init] autorelease];
	aRemoteTestProxy->_debugName = @"unlockTestRunner";

	NSString *exprString = @"[HooAsyncTestRunner unlock]";
	FSBlock *exprBlock = _BLOCK(exprString);
	aRemoteTestProxy.boolExpressionBlock = exprBlock;

	return aRemoteTestProxy;
}

#pragma mark -

// set up a delayed action
// fire will be called on this
+ (GUITestProxy *)documentCountIs:(NSUInteger)intValue {

	GUITestProxy *aRemoteTestProxy = [[GUITestProxy alloc] init];
	aRemoteTestProxy.debugName = @"assert Document Count Is";
	
	// As this doesnt need to capture any arguments i am going to use the FScript block instead of the invocation
	NSString *exprString = [NSString stringWithFormat:@"[(((NSDocumentController sharedDocumentController) documents) count) isEqualToNumber: (NSNumber numberWithInt: %i)]", intValue];
	FSBlock *exprBlock = _BLOCK(exprString);

	aRemoteTestProxy.boolExpressionBlock = exprBlock;
	return [aRemoteTestProxy autorelease];
}

#pragma mark -
#pragma mark Hmm
- (void)_waitTimerFire:(id)value {

	[self cleanup]; // clean up calls our callback, der..
}

- (void)wait {
	
	[DelayedPerformer delayedCallSelector:@selector(_waitTimerFire:) onObject:self withArg:nil afterDelay:0.3f];
}



@end

