//
//  SHSwizzler.m
//  Objc-2 swizzle test
//
//  Created by steve hooley on 31/07/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "SHSwizzler.h"
#import <Foundation/NSObjCRuntime.h>
#import <objc/runtime.h>
#import "SHInstanceCounter.h"
#import "BBLogger.h"

#define myva_arg(ap, sizeOfType) (ap += (sizeOfType+3)&~3)



@implementation SHSwizzler

NSInvocation* buildInvocationForSelector( id self, SEL _cmd ) {
	
	NSString *selString = NSStringFromSelector(_cmd);
	NSString *originalSelString = [NSString stringWithFormat:@"sh_%@", selString];
	SEL originalSelector = NSSelectorFromString( originalSelString );
	NSMethodSignature *signature=[self methodSignatureForSelector: originalSelector];
	NSInvocation *invocation=nil;
	if(signature)
	{
		invocation=[NSInvocation invocationWithMethodSignature:signature];
		/* set Invocation's arguments 0 and 1 */
		[invocation setTarget:self];
		[invocation setSelector:originalSelector];
	} else {
		logWarning(@"WE tried to replace a method that doesn't exist - it has to be in this class - %@. Just cause it is in the superclass doesnt count!!!!!", NSStringFromClass([self class]) );
        [NSException raise:NSInvalidArgumentException format:@"There is no Selector %@ in %@", originalSelString, NSStringFromClass([self class])];
	}
	return invocation;
}


//- (void)trashME:(id)firstObject, ... {
//	
//	Method thisMethod = class_getInstanceMethod( [self class], _cmd );
//	const char *methodTypeEncoding = method_getTypeEncoding(thisMethod);
//	
//	size_t dst_len = 24;
//	char dst[dst_len];
//	method_getArgumentType(thisMethod, 1, &dst, dst_len);
//	NSLog(@"what?");
//}

void fillInvocationsArgumentsFrom_va_list( va_list args, NSInvocation *invocation ){
	
	for( NSUInteger i=2; i<[[invocation methodSignature] numberOfArguments]; i++){
		
		NSUInteger size;
		const char *argTType = [[invocation methodSignature] getArgumentTypeAtIndex:i];
		NSGetSizeAndAlignment( argTType, &size, NULL );
		[invocation setArgument:args atIndex:(NSInteger)i];
		
		// increment to next variable in va_list - using this instead of the standard way because i dont know 
		// the arguments type but i do know it's size. Unfortunately type is needed for va_arg
		myva_arg( args, size );
	}
	va_end(args);
}

id callOriginalMethod( id self, SEL _cmd, va_list args ){
	
	/* Build an invocation pointing to the original method */
	NSInvocation *invocation = buildInvocationForSelector( self, _cmd );
	
	fillInvocationsArgumentsFrom_va_list( args, invocation );
	
	//-- call the original method
	[invocation invoke];
	id returnValue = nil;
	if([[invocation methodSignature] methodReturnLength])
	{
	//	returnValue = (id)malloc( [[invocation methodSignature] methodReturnLength] );
		[invocation getReturnValue: &returnValue];
	}
	return returnValue;
}

id replacementInit( id self, SEL _cmd, ... ) {

	va_list args;
	va_start(args, _cmd);
	id returnValue = callOriginalMethod( self, _cmd, args );

#ifdef DEBUG
	// -- create an object in hooley reference counter
	[SHInstanceCounter objectCreated:self];
#endif

	return returnValue;
}

id replacementDealloc( id self, SEL _cmd, ... ) {
	
	va_list args;
	va_start(args, _cmd);
    
#ifdef DEBUG
	// -- remove the object from hooley reference counter
	[SHInstanceCounter objectDestroyed:self];
#endif

	id returnValue = callOriginalMethod( self, _cmd, args );
	return returnValue;
}

id replacementWithLog( id self, SEL _cmd, ... ) {
	
	va_list args;
	va_start(args, _cmd);
	id returnValue = callOriginalMethod( self, _cmd, args );
	
	NSLog (@"Hello");
	return returnValue;
}

+ (void)swapImplementationOfMethodNamed:(NSString *)selString ofClassNamed:(NSString *)classString withIMP:(IMP)replacementMethodBody {
	
	// -- replace original method with custom init method
	Class targetClass = NSClassFromString(classString);
	SEL targetSEL = NSSelectorFromString(selString);
    NSAssert2(targetClass!=nil && targetSEL!=nil, @"Cant swap SEL %@ or class %@ as they are NIL!", classString, selString );
	//    logInfo(@"swapping %@", classString);
    if(class_respondsToSelector(targetClass, targetSEL))
    {
        Method methodToReplace = class_getInstanceMethod( targetClass, targetSEL );
        SEL replacementSEL = NSSelectorFromString( [NSString stringWithFormat:@"sh_%@", selString] );
        
        BOOL allreadyHasSubstitute = class_respondsToSelector(targetClass, replacementSEL);
        if(allreadyHasSubstitute==NO)
        {
            /* add the dummy method */
            class_addMethod( targetClass, replacementSEL, replacementMethodBody, method_getTypeEncoding( methodToReplace ) );
            
            /* Replace original method with our new one */
            Method replacementMethod = class_getInstanceMethod( targetClass, replacementSEL );
            method_exchangeImplementations( methodToReplace, replacementMethod );
        } else {
            logInfo(@"we have already swapped out %@ of class %@", selString, classString);
        }
    } else {
        logError(@"Class %@ doesn't respond to selector %@ so can't swizzle it", classString, selString );
    }
}

+ (void)insertDebugObjectCreationAfterInstanceMethod:(NSString *)selString ofClass:(NSString *)classString {

	//-- replace original method with custom init method
	IMP replacementMethodBody = (IMP)replacementInit;
	[SHSwizzler swapImplementationOfMethodNamed:selString ofClassNamed:classString withIMP:replacementMethodBody];
}
	
+ (void)insertDebugObjectDestructionBeforeInstanceMethod:(NSString *)selString ofClass:(NSString *)classString {

	//-- replace original method with custom dealloc mthod
	IMP replacementMethodBody = (IMP)replacementDealloc;
	[SHSwizzler swapImplementationOfMethodNamed:selString ofClassNamed:classString withIMP:replacementMethodBody];
}

+ (void)insertDebugStringAfterInstanceMethod:(NSString *)selString ofClass:(NSString *)classString {
	
	//-- Add a new method with a log at the end
	IMP replacementMethodBody = (IMP)replacementWithLog;
	[SHSwizzler swapImplementationOfMethodNamed:selString ofClassNamed:classString withIMP:replacementMethodBody];
}


+ (void)insertDebugCodeForInitMethod:(NSString *)selString ofClass:(NSString *)classString {
 
	logInfo(@"Swizzling %@ of %@", selString, classString);
    [SHSwizzler insertDebugObjectCreationAfterInstanceMethod:selString ofClass: classString];
	[SHSwizzler insertDebugObjectDestructionBeforeInstanceMethod:@"dealloc" ofClass:classString];
}

+ (void)initialize {
// COV_NF_START
    static BOOL isInitialized = NO;
	if(!isInitialized) {
		isInitialized = YES;
    }
	// COV_NF_END
}


@end
