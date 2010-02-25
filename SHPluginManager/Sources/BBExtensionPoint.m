//
//  BBExtensionPoint.m
//  Blocks
//
//  Created by Jesse Grosjean on 1/5/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BBExtensionPoint.h"
#import "BBPluginRegistry.h"
#import "BBPlugin.h"

@implementation BBExtensionPoint

#pragma mark init

- (id)initWithPlugin:(BBPlugin *)plugin identifier:(NSString *)identifier protocolName:(NSString *)protocolName {
	
	NSParameterAssert(plugin);
	NSParameterAssert(identifier);
	NSParameterAssert(protocolName);

	self = [super init];
    if(self) {
		fPlugin = plugin;
		fIdentifier = [identifier retain];
		fProtocolName = [protocolName retain];
    }
    return self;
}

#pragma mark dealloc

- (void)dealloc {

    [fIdentifier release];
    [fProtocolName release];
    [super dealloc];
}

#pragma mark accessors

- (NSString *)description {

    return [NSString stringWithFormat:@"id: %@", [self identifier]];
}

- (BBPlugin *)plugin {

    return fPlugin;
}

- (NSString *)identifier {

    return fIdentifier;
}

- (NSString *)protocolName {

    return fProtocolName;
}

- (NSArray *)extensions {

    return [[BBPluginRegistry sharedInstance] extensionsFor:[self identifier]];
}

@end
