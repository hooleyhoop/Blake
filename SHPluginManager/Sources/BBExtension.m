//
//  BBExtension.m
//  Blocks
//
//  Created by Jesse Grosjean on 1/5/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BBExtension.h"
#import "BBPluginRegistry.h"
#import "BBPlugin.h"
#import "BBExtensionPoint.h"


@implementation BBExtension

#pragma mark init

- (id)initWithPlugin:(BBPlugin *)plugin extensionPointID:(NSString *)extensionPointID extensionClassName:(NSString *)extensionClassName {
	
	NSParameterAssert(plugin);
	NSParameterAssert(extensionPointID);
	NSParameterAssert(extensionClassName);

	self = [super init];
    if(self) {
		
		fPlugin = plugin;
		fExtensionPointID = [extensionPointID retain];
		fExtensionClassName = [extensionClassName retain];
    }
    return self;
}

#pragma mark dealloc

- (void)dealloc {
    [fExtensionPointID release];
    [fExtensionClassName release];
    [fExtensionInstance release];
    [super dealloc];
}

#pragma mark accessors

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ point: %@ class: %@>", [self className], [self extensionPointID], [self extensionClassName]];
}

- (BBPlugin *)plugin {
    return fPlugin;
}

- (NSString *)extensionPointID {
    return fExtensionPointID;
}

- (BBExtensionPoint *)extensionPoint {

    BBExtensionPoint *extensionPoint = [[BBPluginRegistry sharedInstance] extensionPointFor:[self extensionPointID]];
    NSAssert( extensionPoint, @"failed to find extension point for id" );
    return extensionPoint;
}

- (NSString *)extensionClassName {
    return fExtensionClassName;
}

- (Class)extensionClass {
    if (!fExtensionClass) {
		@try {
			if ([[self plugin] load]) {
				fExtensionClass = NSClassFromString([self extensionClassName]);
			}
			
			if (!fExtensionClass) {
				logError(@"Failed to load extension class %@", [self extensionClassName]);
			} else {
				// logInfo(@"Loaded extension class %@", [self extensionClassName]);
			}
		} @catch (NSException *e) {
			logError(@"threw exception %@ while loading class of extension %@", e, self);
		}
    }
    
    return fExtensionClass;
}

- (id)extensionInstance {
    if (!fExtensionInstance) {
		fExtensionInstance = [[self extensionNewInstance] retain];
    }
    return fExtensionInstance;
}

- (id)extensionNewInstance {
	id newExtensionInstance = nil;
	
	@try {
		newExtensionInstance = [[[[self extensionClass] alloc] init] autorelease];
	} @catch (NSException *e) {
		logError(@"threw exception %@ while loading instance of extension %@", e, self);
		[newExtensionInstance release];
		newExtensionInstance = nil;
	}
	
	if (!newExtensionInstance) {
		logError(@"Failed to load extension instance of class %@", [self extensionClassName]);
	} else {
		// logInfo(@"Loaded extension instance %@", newExtensionInstance);
	}
	
	return newExtensionInstance;
}

#pragma mark declaration order

- (NSComparisonResult)compareDeclarationOrder:(BBExtension *)extension {
	
	BBPlugin *plugin1 = [self plugin];
	BBPlugin *plugin2 = [extension plugin];
	
	if (plugin1 == plugin2) {
		int index1 = [[plugin1 extensions] indexOfObject:self];
		int index2 = [[plugin2 extensions] indexOfObject:extension];
		
		if (index1 < index2) {
			return NSOrderedAscending;
		} else if (index1 > index2) {
			return NSOrderedDescending;
		} else {
			return NSOrderedSame;
		}
	} else {
		int loadSequenceNumber1 = [plugin1 loadSequenceNumber];
		int loadSequenceNumber2 = [plugin2 loadSequenceNumber];
		
		if (loadSequenceNumber1 < loadSequenceNumber2) {
			return NSOrderedAscending;
		} else if (loadSequenceNumber1 > loadSequenceNumber2) {
			return NSOrderedDescending;
		} else {
			return NSOrderedSame;
		}
	}
}

@end