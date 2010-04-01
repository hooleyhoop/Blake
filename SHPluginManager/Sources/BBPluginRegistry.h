//
//  BBPluginRegistry.h
//  Blocks
//
//  Created by Jesse Grosjean on 1/5/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

@class BBPlugin;
@class BBExtensionPoint;

/*!
	@class BBPluginRegistry
	@discussion The BBPluginRegistry is responsible for finding and loading plugins. 
*/
@interface BBPluginRegistry : NSObject {

    NSMutableDictionary *fPluginIDsToPlugins;
    NSMutableDictionary *fExtensionPointIDsToExtensionPoints;
    NSMutableDictionary *fExtensionPointIDsToExtensions;
    NSMutableDictionary *fExtensionPointIDsToLoadedValidOrderedExtensions;
	NSMutableArray		*_usedBundleIdentifiers;
	
    BOOL				fScannedPlugins;
	NSMutableArray		*pluginSearchPaths;
	
	/* you can limit which plugins are loaded */
	NSMutableArray		*specificPluginsToLoad;

}

#pragma mark class methods

+ (id)sharedInstance;
+ (void)tearDownPlugins;

+ (void)performSelector:(SEL)selector forExtensionPoint:(NSString *)extensionPointID protocol:(Protocol *)protocol;
+ (void)performSelector:(SEL)selector withObject:(id)ob forExtensionPoint:(NSString *)extensionPointID protocol:(Protocol *)protocol;

#pragma mark init

- (void)addPluginWithXML:(NSString *)pathToXML;

- (void)limitPluginsTo:(NSString *)filePath;
- (void)addAllPathsFrom:(NSString *)aPath;
- (void)scanPlugins;

- (BOOL)registerPlugin:(BBPlugin *)plugin;

- (void)validatePluginConnections;
- (void)loadMainExtension;

#pragma mark accessors

- (NSArray *)plugins;
- (BBPlugin *)mainPlugin;
- (NSArray *)extensionPoints;
- (NSArray *)extensions;

#pragma mark lookup

- (BBPlugin *)pluginFor:(NSString *)pluginID;
- (BBExtensionPoint *)extensionPointFor:(NSString *)extensionPointID;
- (NSArray *)extensionsFor:(NSString *)extensionPointID;
- (NSArray *)loadedValidOrderedExtensionsFor:(NSString *)extensionPointID protocol:(Protocol *)protocol;

@end