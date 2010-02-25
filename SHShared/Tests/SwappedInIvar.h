//
//  SwappedInIvar.h
//  DebugDrawing
//
//  Created by steve hooley on 08/10/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import <objc/runtime.h>

@interface SwappedInIvar : NSObject {

	id		_object;
	id		_oldValue;
	Ivar	_ivar;
}

+ (SwappedInIvar *)swapFor:(id)obj :(const char *)propertyName :(id)someNewValue;

- (id)initWithOb:(id)obj ivarName:(const char *)propertyName newValue:(id)someNewValue;
- (void)putBackOriginal;

@end
