//
//  SHGlobalVars.h
//  Shared
//
//  Created by Steve Hooley on 31/10/2005.
//  Copyright 2005 HooleyHoop. All rights reserved.
//

// some of the objects in globals..

// (NSDictionary) instantiatedViewControllers
// (NSDictionary) openViews
// (NSDictionary) theframeworkPlugins
// (NSDictionary) theDataTypePlugins
// (NSDictionary) theOperatorPlugins
// (NSDictionary) theViewPlugins

@interface SHGlobalVars : _ROOT_OBJECT_ {
	
	NSMutableDictionary *_vars;
}

#pragma mark -
#pragma mark class methods
+ (SHGlobalVars *)globals;
+ (void)cleanUpGlobals;

#pragma mark acessor methods
- (NSObject *)objectForKey:(NSObject *) key;
- (void)setObject:(NSObject *)Object forKey:(NSObject *)key;

@end
