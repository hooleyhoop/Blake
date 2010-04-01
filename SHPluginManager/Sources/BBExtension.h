//
//  BBExtension.h
//  Blocks
//
//  Created by Jesse Grosjean on 1/5/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//
@class BBPlugin;
@class BBExtensionPoint;

@interface BBExtension : SHooleyObject {
	
    BBPlugin *fPlugin;
    NSString *fExtensionPointID;
    NSString *fExtensionClassName;
    Class fExtensionClass;
    id fExtensionInstance;
}

#pragma mark init

- (id)initWithPlugin:(BBPlugin *)plugin extensionPointID:(NSString *)extensionPointID extensionClassName:(NSString *)className;

#pragma mark accessors

- (BBPlugin *)plugin;
- (NSString *)extensionPointID;
- (BBExtensionPoint *)extensionPoint;
- (NSString *)extensionClassName;
- (Class)extensionClass;
- (id)extensionInstance;
- (id)extensionNewInstance;

#pragma mark declaration order

// Compare the load ordering of this extension with the given extension. If the extensions plugins are different the load order of the plugin is used to compare. If the plugins are the same then the extension declaration order is used to compare. This ordering is used by some extension points (such as menu extensions) to decide which extensions are processed first.
- (NSComparisonResult)compareDeclarationOrder:(BBExtension *)extension;

@end