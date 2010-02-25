//
//  NSInvocation(ForwardedConstruction).h
//
//  Created by Matt Gallagher on 19/03/07.
//  Copyright 2007 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file without charge in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

@interface NSInvocation (ForwardedConstruction)

//+ (id)newInvocationWithTarget:(id)target;
+ (id)makeInvocationWithTarget:(id)target invocationOut:(NSInvocation **)invocationOut;

+ (id)makeRetainedInvocationWithTarget:(id)target invocationOut:(NSInvocation **)invocationOut;

@end


//
// InvocationProxy is a private class for receiving invocations via the
// forwarding mechanism and saving the received invocation to an external
// invocation pointer.
//
// To avoid as many instance methods as possible, InvocationProxy is a base
// class (not a subclass of NSObject) and does not implement the NSObject
// protocol (and so is *not* a first-class object).
//
@interface InvocationProxy
{
    Class isa;
	NSInvocation **invocation;
	id target;
	BOOL retainArguments;
//replaced	NSUInteger forwardingAddress;
	NSUInteger *_altForwardingAddress;
}

+ (id)_fake_allo;
+ (void)setValuesForInstance:(InvocationProxy *)instance target:(id)target destinationInvocation:(NSInvocation **)destinationInvocation retainArguments:(BOOL)retain;
- (NSInvocation *)_;
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector;
- (void)forwardInvocation:(NSInvocation *)forwardedInvocation;

@end
