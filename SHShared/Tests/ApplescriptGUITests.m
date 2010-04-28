//
//  ApplescriptGUITests.m
//  SHShared
//
//  Created by steve hooley on 28/04/2010.
//  Copyright 2010 BestBefore Ltd. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <AppKit/AppKit.h>

@interface ApplescriptGUITests : SenTestCase {
	
}

@end

@implementation ApplescriptGUITests

// attach gdb?
// [ApplescriptGUI attachGDBToTask:_psn file:guiFiddler];

- (void)test {
	// + (id)statusOfMenuItem:(NSString *)itemName ofMenu:(NSString *)menuName ofApp:(NSString *)appName
	
	NSString *result = [ApplescriptGUI doScript:@"TestScript" method:@"methodReturningString"];
	STAssertTrue( [result isEqualToString:@"true"], nil);
}

@end
