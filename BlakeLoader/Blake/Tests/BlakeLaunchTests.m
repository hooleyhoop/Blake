//
//  BlakeLaunchTests.m
//  BlakeLoader experimental
//
//  Created by steve hooley on 13/06/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

@interface BlakeLaunchTests : SenTestCase {
	
}

@end

@implementation BlakeLaunchTests

- (void)setUp {
	// STFail(@"test are working");
}


- (void)tearDown {
}

- (void)testAppLaunch {
	
	Class appClass = [[NSApplication sharedApplication] class];
//dec09		STAssertTrue(appClass==NSClassFromString(@"SHApplication"), @"Fucked up App launch - app class is %@", NSStringFromClass(appClass));
	
//dec09	SHAppControl *appControlSingleTon = [SHAppControl appControl];
//dec09		STAssertNotNil(appControlSingleTon, @"appControlSingleTon should be made from Blake main menu nib");
}

@end
