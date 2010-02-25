//
//  SHApplication_Extras.m
//  BlakeLoader2
//
//  Created by steve hooley on 21/12/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "SHApplication_Extras.h"

@implementation NSApplication (SHApplication_Extras)

/* we can send a message to the first responder by targeting nil*/
// BOOL result = [NSApp sendAction:@selector(canSelectAllChildren) to:nil from:self];
/* Instead i will roll my own that will work in the unit tests */
//- (BOOL)sendSelectorReturningBool:(SEL)theAction {
//	
//	BOOL result = NO;
//	NSResponder *aRes = [self firstResponder];
//	
//	do {
//		if([aRes respondsToSelector:theAction] && aRes!=self)
//			break;
//		aRes = [aRes nextResponder];
//	} while (aRes!=nil);
//	
//	if(aRes!=nil)
//	{
//		// canSelectAllChildren = [(id)aRes canSelectAllChildren];
//		NSMethodSignature* methodSig = [[aRes class] instanceMethodSignatureForSelector: theAction];		
//		NSInvocation *forwardInvocation = [NSInvocation invocationWithMethodSignature: methodSig];
//		[forwardInvocation setTarget: aRes];
//		[forwardInvocation setSelector: theAction];
//		[forwardInvocation invoke];
//		[forwardInvocation getReturnValue: &result];
//	}
//	
//	return result;	
//}

// Isnt there already a provided method that does this?
// -sendAction:to:from:
// -tryToPerform:with:
// -doCommandBySelector:
//- (void)sendSelector:(SEL)theAction {
//	
//	NSResponder *aRes = [self firstResponder];
//	do {
//		if([aRes respondsToSelector:theAction] && aRes!=self)
//			break;
//		aRes = [aRes nextResponder];
//	} while (aRes!=nil);
//	
//	if(aRes!=nil)
//	{
//		// canSelectAllChildren = [(id)aRes canSelectAllChildren];
//		NSMethodSignature* methodSig = [[aRes class] instanceMethodSignatureForSelector: theAction];		
//		NSInvocation *forwardInvocation = [NSInvocation invocationWithMethodSignature: methodSig];
//		[forwardInvocation setTarget: aRes];
//		[forwardInvocation setSelector: theAction];
//		[forwardInvocation invoke];
//	}
//}

- (NSResponder *)firstResponder {
	
	NSWindow *frontWindow = [NSApp myMainWindow]; // This is my custom mainWindow method that should also work in the tests
	NSResponder *aRes = [frontWindow firstResponder];
	return aRes;
}

- (BOOL)itemInResponderChainRespondsToSelector:(SEL)theAction {
	
	NSResponder *aRes = [self firstResponder];
	do {
		if([aRes respondsToSelector:theAction] && aRes!=self)
			break;
		aRes = [aRes nextResponder];
	} while (aRes!=nil);
	return aRes!=nil;
}

@end
