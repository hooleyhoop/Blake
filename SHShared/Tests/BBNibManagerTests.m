//
//  BBNibManagerTests.m
//  BBUtilities
//
//  Created by steve hooley on 09/01/2008.
//  Copyright 2008 Best Before. All rights reserved.
//

#import "BBNibManager.h"

#import <Foundation/Foundation.h>
#import <Foundation/NSDebug.h>
#import <Appkit/NSArrayController.h>

@interface BBNibManagerTests : SenTestCase {
	
	BOOL							zombiesWereEnabled;
	BBNibManager					*nibManager;
	
	IBOutlet	NSWindow			*testWindow;
	IBOutlet	NSArrayController	*testArrayController;
	IBOutlet	NSView				*testView;
}

@end

@implementation BBNibManagerTests

- (void)setUp {
	
	zombiesWereEnabled = NSZombieEnabled;
	NSZombieEnabled = YES;
	//+ (id)instantiateNib:(NSString *)nibName withOwner:(id)owner
	//- (id)initWithNibName:(NSString *)nibName withOwner:(id)owner
	
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];		// We need to test retain/release counts.  Use a local pool so autoreleased objects don't stay alive throughout the entire test run
	nibManager = [[BBNibManager instantiateNib:@"nibManagerTest" withOwner:self] retain];
	[pool release];
}

- (void)tearDown {

	[nibManager release];
	NSZombieEnabled = zombiesWereEnabled;
}

- (void)testSetup {

	STAssertNotNil(testWindow, @"nibloading failed");
	STAssertNotNil(testArrayController, @"nibloading failed");
	STAssertNotNil(testView, @"nibloading failed");
}

- (void)testTopLevelObjects {

	//- (NSMutableArray *)topLevelObjects
	//- (void)setTopLevelObjects:(NSMutableArray *)value
	NSMutableArray *tlo = [nibManager topLevelObjects];
	/* is 4 because NSApplication is a topLeveObject - who knew? */
	STAssertTrue([tlo count]==4, @"was topLevelObjects set correctly? Is... %i, %@", [tlo count], tlo);
	STAssertTrue([tlo containsObject:testWindow], @"was topLevelObjects set correctly?");
	STAssertTrue([tlo containsObject:testArrayController], @"was topLevelObjects set correctly?");
	STAssertTrue([tlo containsObject:testView], @"was topLevelObjects set correctly?");
}

- (void)testReleasingNibManager {
	
	[nibManager release];
	
	// These REQUIRE NSZombieEnabled
	BOOL isFreed = NSIsFreedObject(nibManager);
	STAssertTrue( isFreed, @"We failed to properly release Nib Manager");
	STAssertTrue(NSIsFreedObject(testWindow), @"Nib Manager is not releasing top level objects");
	STAssertTrue(NSIsFreedObject(testArrayController),  @"Nib Manager is not releasing top level objects");
	STAssertTrue(NSIsFreedObject(testView), @"Nib Manager is not releasing top level objects");
	
	nibManager = nil;
}


@end
