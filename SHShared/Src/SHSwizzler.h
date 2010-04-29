//
//  SHSwizzler.h
//  Objc-2 swizzle test
//
//  Created by steve hooley on 31/07/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

@interface SHSwizzler : NSObject {

}

+ (void)insertDebugCodeForInitMethod:(NSString *)selString ofClass:(NSString *)classString;

NSInvocation *buildInvocationForSelector( id self, SEL _cmd );

@end