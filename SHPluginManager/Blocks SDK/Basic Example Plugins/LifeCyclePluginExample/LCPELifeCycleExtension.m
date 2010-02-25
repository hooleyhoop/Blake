//
//  LCPELifeCycleExtension.m
//  Blocks SDK
//
//  Created by Jesse Grosjean on 5/19/05.
//  Copyright 2005 Hog Bay Software. All rights reserved.
//

#import "LCPELifeCycleExtension.h"


@implementation LCPELifeCycleExtension

- (void)applicationLaunching {
	NSLog(@"LCPELifeCycleExtension - applicationLaunching");
}

- (void)applicationWillFinishLaunching {
	NSLog(@"LCPELifeCycleExtension - applicationWillFinishLaunching");
}

- (void)applicationDidFinishLaunching {
	NSLog(@"LCPELifeCycleExtension - applicationDidFinishLaunching");
}

- (void)applicationWillTerminate {
	NSLog(@"LCPELifeCycleExtension - applicationWillTerminate");
}

@end
