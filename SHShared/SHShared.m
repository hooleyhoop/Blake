//
//  Shared.h
//  Shared
//
//  Created by Steve Hooley on 22/10/2005.
//  Copyright 2005 HooleyHoop. All rights reserved.
//
#import "LogController.h"
#import "SHInstanceCounter.h"
#import "NSCharacterSet_Extensions.h"
#import "SwizzleList.h"

static NSMutableArray *_destructorCallBacks;

__attribute__((constructor)) void onStart(void) {
	printf("-- Starting Process --");
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	_destructorCallBacks = [[NSMutableArray array] retain];
	[pool release];
}


__attribute__((destructor)) void onExit(void) {
    
    static BOOL onExitCheck = NO;
    
    if(onExitCheck==NO)
    {
		NSCAssert(_destructorCallBacks, @"failed to init _destructorCallBacks");
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		for( NSDictionary *each in _destructorCallBacks ){
			NSString *classString = [each objectForKey:@"classKey"];
			NSString *selString = [each objectForKey:@"selectorKey"];
			[NSClassFromString(classString) performSelector:(NSSelectorFromString(selString))];
		}
		[_destructorCallBacks release];
		[SwizzleList tearDownSwizzles];
		[pool release];
    } else {
        NSLog(@"!!EXITING AGAIN!!");
    }
}

void addDestructorCallback( Class classValue, SEL callback ) {

	NSString *classString = NSStringFromClass(classValue);
	NSString *selString = NSStringFromSelector(callback);
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:classString, @"classKey", selString, @"selectorKey", nil];
	[_destructorCallBacks addObject:dict];
}