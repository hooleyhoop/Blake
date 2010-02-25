//
//  SHBundleLoader.h
//  Pharm
//
//  Created by Steve Hooley on 25/10/2005.
//  Copyright 2005 HooleyHoop. All rights reserved.
//

@class SHAppModel;

/*
 *
*/
@interface SHBundleLoader : _ROOT_OBJECT_ {

	NSMutableArray			*_pathsToScan;
	NSMutableDictionary		*_foundFrameworks;
}

@property (readonly, nonatomic) NSMutableArray *pathsToScan;

#pragma mark -
#pragma mark class methods
//nov09+ (SHBundleLoader *)bundleLoader;
+ (void)cleanUpSharedInstance;

#pragma mark notifications methods
//nov09- (void)bindFrameworkLoaded;
//nov09- (void)unBind;

#pragma mark action methods
- (void)addAllPathsFrom:(NSString *)aPath;

//nov09- (void)loadUnitTestBundle:(NSString *)pathToTestBundle;
- (void)loadPlugInFrameworks;
//nov09- (void)loadPlugInDataTypes:(NSMutableDictionary *)store;
//nov09- (void)loadPlugInOperators:(NSMutableDictionary *)store;
//nov09- (void)loadPlugInViews:(NSMutableDictionary *)store;

- (BOOL)checkAvailableClassesFor:(NSArray *)classNames;

//- (void) startLoadingNextFramework;
//- (void) frameworkLoaded:(NSNotification*)note;

#pragma mark accessor methods
//nov09- (NSMutableDictionary *)foundFrameworks;
//nov09- (void)setFoundFrameworks:(NSMutableDictionary *)newFoundFrameworks;

@end


/*
 *
*/
//nov09@interface SHBundleLoader (PrivateMethods)

//nov09- (void)loadFrameworksAtSavedLocations:(NSMutableDictionary *)store;
//nov09- (void)loadBundlesAtSavedLocations:(NSMutableDictionary *)store;

//nov09- (void)loadClassesFromBundlesAtSavedLocations:(NSMutableDictionary *)store thatRespondToSelector:(SEL)testSelector;
//nov09- (void)loadIntoFscript:(NSBundle*)aBundle;

//nov09@end
