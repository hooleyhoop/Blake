//
//  AppControlTests.m
//  DebugDrawing
//
//  Created by Steven Hooley on 1/11/09.
//  Copyright 2009 Bestbefore. All rights reserved.
//

#import "AppControl.h"

@interface AppControlTests : SenTestCase {
	
	AppControl	*appControl;
}

@end


@implementation AppControlTests

- (void)setUp {
	
	appControl = [[AppControl alloc] init];
}

- (void)tearDown {
	
	// This is need to clean up
	[appControl applicationWillTerminate:nil];
	[appControl release];
}

- (void)testSomeShit {
	
}
@end
