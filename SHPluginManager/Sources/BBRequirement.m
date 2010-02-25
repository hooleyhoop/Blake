//
//  BBRequirement.m
//  Blocks
//
//  Created by Jesse Grosjean on 1/27/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BBRequirement.h"
#import "BBPluginRegistry.h"
#import "BBPlugin.h"


@implementation BBRequirement

#pragma mark init

- (id)initWithIdentifier:(NSString *)identifier version:(NSString *)version optional:(BOOL)optional {
	
	self = [super init];
	if(self) {
		fBundleIdentifier = [identifier retain];
		fBundleVersion = [version retain];
		fOptional = optional;
	}
	return self;
}

#pragma mark dealloc

- (void)dealloc {
	[fBundleIdentifier release];
	[fBundleVersion release];
	[super dealloc];
}

#pragma mark accessors

- (NSString *)description {
    return [NSString stringWithFormat:@"bundleIdentifier: %@ optional: %i", [self bundleIdentifier], [self optional]];
}

- (BBPlugin *)requiredPlugin {
	return [[BBPluginRegistry sharedInstance] pluginFor:[self bundleIdentifier]];
}

- (NSBundle *)requiredBundle {
	return [NSBundle bundleWithIdentifier:[self bundleIdentifier]];
}

- (NSString *)bundleIdentifier {
	return fBundleIdentifier;
}

- (NSString *)bundleVersion {
	return fBundleVersion;
}

- (BOOL)optional {
	return fOptional;
}

#pragma mark loading

- (BOOL)isLoaded {
	BBPlugin *plugin = [self requiredPlugin];
	if (plugin) return [plugin isLoaded];
	NSBundle *bundle = [self requiredBundle];
	if (bundle) return [bundle isLoaded];
	return NO;
}

- (BOOL)load {
	BBPlugin *plugin = [self requiredPlugin];
	if (plugin) return [plugin load];
	NSBundle *bundle = [self requiredBundle];
	if (bundle) return [bundle load];
	return NO;
}

@end
