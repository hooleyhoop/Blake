//
//  NSInvocation(ForwardedConstuction).m
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

#import "NSInvocation(ForwardedConstruction).h"
#import <objc/objc-runtime.h>


#ifndef __OBJC_GC__

//
// DeallocatorHelper is a basic object which takes an id
// and deallocates it when the DeallocatorHelper is deallocated.
//
// Not used in a garbage collected environment (which should deallocate the
// id automatically).
//
@interface DeallocatorHelper : NSObject
{
	id object;
}

- (id)initWithObject:(id)newObject;
- (void)dealloc;

@end

@implementation DeallocatorHelper


- (id)initWithObject:(id)newObject {
    
	self = [super init];
	if (self != nil){
		object = newObject;
	}
	return self;
}

//
// dealloc
//
// Deallocates the id.
//
- (void)dealloc
{
	NSDeallocateObject(object);
	[super dealloc];
}

@end

#endif

@implementation InvocationProxy

//
// initialize
//
// This empty method is required because the runtime tries to invoke it when
// the first message is sent to the Class. If it doesn't exist, the runtime
// gets mad.
//
+ (void)initialize
{
}

//
// alloc
//
// Allocator for the class. Also sets the 
//
+ (id)_fake_allo
{
	//
	// Allocate the object using the default allocator.
	//
	InvocationProxy *newObject =
#ifdef __OBJC_GC__
		objc_allocate_object(self, 0);
#else
		NSAllocateObject(self, 0, nil);
#endif
	return newObject;
}

//
// setValuesForInstance:target:destinationInvocation:retainArguments:
//
// Method to set the attributes on the instance passed in. We use a class
// method instead of an instance method to avoid extra instance methods on
// the class.
//
+ (void)setValuesForInstance:(InvocationProxy *)instance target:(id)destinationTarget destinationInvocation:(NSInvocation **)destinationInvocation retainArguments:(BOOL)retain;
{
	instance->target = destinationTarget;
	instance->invocation = destinationInvocation;
	instance->retainArguments = retain;
}

- (NSInvocation *)_ {
	NSInvocation *actualInv = *invocation;
	return actualInv;
}

//
// methodSignatureForSelector:
//
// Invoked by the runtime whenever a message is sent for a method that doesn't
// exist.
//
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
	//
	// This method should be invoked once before attributes are set (as an
	// "init" invocation).
	//
	if (target == nil)
	{
		//
		// If the invocation is something other than "init", complain using
		// NSObject's standard doesNotRecognizeSelector:
		//
		if (aSelector != @selector(init))
		{
			SEL failSEL = @selector(doesNotRecognizeSelector:);
			Method failMethod = class_getInstanceMethod([NSObject class], failSEL);
			IMP failImp = method_getImplementation(failMethod);
			failImp(self, failSEL, aSelector);
		}
		
		//
		// Otherwise, we use the forwarded "init" to preserve the return
		// address of the forwarding code (which we can use later to determine
		// if this is a forwarded or direct invocation).
		//
//replaced		forwardingAddress = (NSUInteger)__builtin_return_address(0);
		_altForwardingAddress = (NSUInteger *)__builtin_return_address(0);
		//
		// Return the NSMethodSignature from NSObject's init method (just
		// so we have something to return).
		//
		return [NSObject instanceMethodSignatureForSelector:aSelector];
	}
	
	//
	// On subsequent invocations, check if we are a forwarded invocation or
	// a direct invocation.
	//
	
//replaced	NSUInteger returnAddress = (NSUInteger)__builtin_return_address(0);
	NSUInteger *returnAddress2 = (NSUInteger *)__builtin_return_address(0);

//replaced	BOOL original = returnAddress!= forwardingAddress;
	BOOL new = returnAddress2!= _altForwardingAddress;
//replaced	NSAssert(original==new, @"little dance to get rid of compiler warnings when we are sure these do the same thing");
	
	if(new)
	{
		//
		// Handle the case where methodSignatureForSelector: is the message sent
		// directly to the proxy.
		//
		// There is a chance that we have guessed wrong (i.e. if this is sent
		// from __forward__ but from a different code branch) but that won't
		// cause a fatal problem, just a redundant autoreleased NSInvocation
		// that will get safely autoreleased and ignored.
		//
		// Create an NSInvocation for methodSignatureForSelector: 
		//
		NSMethodSignature *signature = [target methodSignatureForSelector:_cmd];
		*invocation = [NSInvocation invocationWithMethodSignature:signature];
		[*invocation setTarget:target];
		[*invocation setSelector:_cmd];
		[*invocation setArgument:&aSelector atIndex:2];
		if (retainArguments)
		{
			[*invocation retainArguments];
		}
		
		//
		// Deliberately fall through and still return the target's
		// methodSignatureForSelector: result (in case we guessed wrong).
		//
	}
	
	//
	// This is the "normal" case: after initialization, we have been correctly
	// invoked from the forwarding code. Return the target's
	// methodSignatureForSelector: for the given selector.
	//
	NSMethodSignature *signature = [target methodSignatureForSelector:aSelector];
	
	NSAssert3(signature != nil, @"NSInvocation(ForwardedConstruction) error: object 0x%x of class '%@' does not implement %s", target, [target className], sel_getName(aSelector));
	
	return signature;
}

//
// forwardInvocation:
//
// This method is invoked by message forwarding.
//
- (void)forwardInvocation:(NSInvocation *)forwardedInvocation
{
	//
	// This method will be invoked once on initialization (before target is set).
	// Do nothing.
	//
	if (target == nil)
	{
		//
		// This branch will be followed when "init" is invoked on the newly
		// allocated object. Since "init" returns "self" we need to set that
		// on the forwardedInvocation.
		//
		[forwardedInvocation setReturnValue:&self];
		return;
	}

	//
	// Check if the target of the forwardedInvocation is equal to self. If
	// it is, then this is a genuine forwardedInvocation. If it isn't, then
	// forwardInvocation: was directly the message sent to this proxy.
	//
	if ([forwardedInvocation target] == self)
	{
		[forwardedInvocation setTarget:target];
		*invocation = forwardedInvocation;
		if (retainArguments)
		{
			[*invocation retainArguments];
		}
		return;
	}
	
	//
	// Handle the case where forwardedInvocation is the message sent directly
	// to the proxy. We create an NSInvocation representing a forwardInvocation:
	// sent to the target instead.
	//
	NSMethodSignature *signature = [target methodSignatureForSelector:_cmd];
	*invocation = [NSInvocation invocationWithMethodSignature:signature];
	[*invocation setTarget:target];
	[*invocation setSelector:_cmd];
	[*invocation setArgument:&forwardedInvocation atIndex:2];
	if (retainArguments)
	{
		[*invocation retainArguments];
	}
}

@end

@implementation NSInvocation (ForwardedConstruction)

//+ (id)newInvocationWithTarget:(id)target {
//	
//	NSInvocation **reallyWillThisWork = calloc(1, sizeof(NSInvocation *));
//	InvocationProxy *justToTest = [self newInvocationWithTarget:target invocationOut:reallyWillThisWork];
//	return justToTest;
//}

//
// invocationWithTarget:invocationOut:
//
// Basic constructor for NSIncoation using forwarded construction.
//
// ns_returns_retained is like starting a method with new or copy

+ (id)makeInvocationWithTarget:(id)target invocationOut:(NSInvocation **)invocationOut
{
	//
	// Check that invocationOut isn't nil.
	//
	NSAssert2(target != nil && invocationOut != nil, @"%@ method %s requires target that isn't nil and a valid NSInvocation** for the second parameter", [self className], sel_getName(_cmd));

	//
	// Alloc and init the proxy
	//
	InvocationProxy *invocationProxy = [InvocationProxy _fake_allo];

	//
	// Set the instance attributes on the proxy
	//
	[InvocationProxy setValuesForInstance:invocationProxy target:target destinationInvocation:invocationOut retainArguments:NO];

	//
	// Create the DeallocatorHelper if needed
	//
#ifndef __OBJC_GC__
	[[[DeallocatorHelper alloc] initWithObject:invocationProxy] autorelease];
#endif

	return invocationProxy;
}

//
// retainedInvocationWithTarget:invocationOut:
//
// Same as above but sends retainArguments to the NSInvocation created.
//
+ (id)makeRetainedInvocationWithTarget:(id)target invocationOut:(NSInvocation **)invocationOut
{
	//
	// Check that invocationOut isn't nil.
	//
	NSAssert2(target != nil && invocationOut != nil, @"%@ method %s requires target that isn't nil and a valid NSInvocation** for the second parameter", [self className], sel_getName(_cmd));

	//
	// Alloc and init the proxy
	//
	InvocationProxy *invocationProxy = [InvocationProxy _fake_allo];

	//
	// Set the instance attributes on the proxy
	//
	[InvocationProxy setValuesForInstance:invocationProxy target:target destinationInvocation:invocationOut retainArguments:YES];

	//
	// Create the DeallocatorHelper if needed
	//
#ifndef __OBJC_GC__
	[[[DeallocatorHelper alloc] initWithObject:invocationProxy] autorelease];
#endif

	return invocationProxy;
}

@end
