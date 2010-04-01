//
//  SHApplication_Extras.h
//  BlakeLoader2
//
//  Created by steve hooley on 21/12/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//


@interface NSApplication (SHApplication_Extras)

// send selector to the first responder
- (NSResponder *)firstResponder;
- (BOOL)itemInResponderChainRespondsToSelector:(SEL)theAction;

//- (BOOL)sendSelectorReturningBool:(SEL)theAction;
//- (void)sendSelector:(SEL)theAction;

@end
