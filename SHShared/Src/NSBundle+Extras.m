//
//  NSBundle+Extras.m
//  BBUtilities
//
//  Created by Jonathan del Strother on 18/10/2007.
//  Copyright 2007 Best Before. All rights reserved.
//

#import "NSBundle+Extras.h"


@implementation NSBundle(Extras)
-(NSString*)nameAndVersionString {	// Returns a string containing the bundle name & git version identifier
	NSString* name = [[self infoDictionary] objectForKey:(id)kCFBundleNameKey];
	if (!name)
		name = [self bundleIdentifier];
	NSString* version = [[self infoDictionary] objectForKey:@"BBBuildDescription"];
	if (!version)
		version = [NSString stringWithFormat:@"unknown version (%@)", [[self infoDictionary] objectForKey:(id)kCFBundleVersionKey]];
	return [NSString stringWithFormat:@"%@ %@", name, version];
}
@end
