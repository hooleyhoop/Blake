//
//  NSResponder_Extras.h
//  SHShared
//
//  Created by steve hooley on 18/03/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import <Appkit/NSResponder.h>


@interface NSResponder (NSResponder_Extras) 

+ (void)insert:(NSResponder *)newItem intoResponderChainAbove:(NSResponder *)existingItem;

@end
