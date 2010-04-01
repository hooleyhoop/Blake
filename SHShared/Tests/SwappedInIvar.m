//
//  SwappedInIvar.m
//  DebugDrawing
//
//  Created by steve hooley on 08/10/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "SwappedInIvar.h"


@implementation SwappedInIvar

+ (SwappedInIvar *)swapFor:(id)obj :(const char *)propertyName :(id)someNewValue {
	
	SwappedInIvar *newSwappedIvar = [[[SwappedInIvar alloc] initWithOb:obj ivarName:propertyName newValue:someNewValue] autorelease];
	
	
	return newSwappedIvar;
}

- (id)initWithOb:(id)obj ivarName:(const char *)propertyName newValue:(id)someNewValue {
	
	self = [super init];
	if(self){
		
		_object = obj;
		
		// get a reference to the ivar, keep a reference to the old value
		_ivar = object_getInstanceVariable( _object, propertyName, (void **)&_oldValue );
		
		// set the new value on the ivar
		object_setIvar( _object, _ivar, someNewValue );
	}
	return self;
}

- (void)putBackOriginal {
	
	object_setIvar( _object, _ivar, _oldValue );
}

@end
