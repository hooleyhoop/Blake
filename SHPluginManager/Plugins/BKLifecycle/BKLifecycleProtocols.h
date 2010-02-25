/*
 *  BKLifecycleProtocols.h
 *  Blocks
 *
 *  Created by Jesse Grosjean on 1/7/05.
 *  Copyright 2006 Hog Bay Software Hog Bay Software. All rights reserved.
 *
 */


@protocol BKLifecycleProtocol <NSObject>

- (void)applicationLaunching;
- (void)applicationWillFinishLaunching;
- (void)applicationDidFinishLaunching;
- (void)applicationWillTerminate;

@end

