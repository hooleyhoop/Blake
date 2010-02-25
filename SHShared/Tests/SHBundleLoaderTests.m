//
//  SHBundleLoaderTests.m
//  Shared
//
//  Created by Steve Hooley on 15/04/2007.
//  Copyright 2007 HooleyHoop. All rights reserved.
//

#import "SHBundleLoader.h"

@interface SHBundleLoaderTests : SenTestCase {
	
    NSAutoreleasePool	*_pool;
	SHBundleLoader		*_bundleLoader;
}

@end


@implementation SHBundleLoaderTests

- (void)setUp {
	
	_bundleLoader = [[SHBundleLoader alloc] init];
}

- (void)tearDown {
	
	[SHBundleLoader cleanUpSharedInstance];
	[_bundleLoader release];
}

- (void)testAddAllPathsFrom {
// - (void)addAllPathsFrom:(NSString *)aPath

	NSString *pathToThisBundle = [[NSBundle bundleForClass:[self class]] bundlePath];
	pathToThisBundle = [pathToThisBundle stringByDeletingLastPathComponent];
	
	[_bundleLoader addAllPathsFrom:pathToThisBundle];
	STAssertTrue([[_bundleLoader pathsToScan] count]>1, @"did we recursively scan?");
	
	STAssertThrows([_bundleLoader addAllPathsFrom:@"chicken"], @"not a valid path");
}

- (void)testLoadPlugInFrameworks {
	//- (void)loadPlugInFrameworks

	[_bundleLoader loadPlugInFrameworks];
}

- (void)testCheckAvailableClassesFor {
	// - (BOOL)checkAvailableClassesFor:(NSArray *)classNames

	BOOL success1 = [_bundleLoader checkAvailableClassesFor:[NSArray arrayWithObjects:@"BBExtension", @"FSObjectPointer", @"SHNodeGraphModel", nil]];
	STAssertFalse(success1, @"dont have these classes");
	
	BOOL success2 = [_bundleLoader checkAvailableClassesFor:[NSArray arrayWithObjects:@"SHBundleLoaderTests", @"SHBundleLoader", @"SHooleyObject", nil]];
	STAssertTrue(success2, @"must have these classes");
}


@end
