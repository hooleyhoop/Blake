/*
 *  SHPluginManager.h
 *  SHPluginManager
 *
 *  Created by Jesse Grosjean on 12/3/04.
 *  Copyright 2004 Hog Bay Software. All rights reserved.
 *
 */

#import <Cocoa/Cocoa.h>

#import <SHPluginManager/BBPluginRegistry.h>
#import <SHPluginManager/BBPlugin.h>
#import <SHPluginManager/BBExtensionPoint.h>
#import <SHPluginManager/BBExtension.h>
#import <SHPluginManager/BBRequirement.h>

#pragma mark macros

#define BKLocalizedString(key, comment) [[NSBundle bundleForClass:[self class]] localizedStringForKey:(key) value:@"" table:nil]
#define BKLocalizedStringFromTable(key, tbl, comment) [[NSBundle bundleForClass:[self class]] localizedStringForKey:(key) value:@"" table:(tbl)]
#define BKLocalizedStringFromTableInBundle(key, tbl, bundle, comment) [bundle localizedStringForKey:(key) value:@"" table:(tbl)]
#define BKLocalizedStringWithDefaultValue(key, tbl, bundle, val, comment) [bundle localizedStringForKey:(key) value:(val) table:(tbl)]