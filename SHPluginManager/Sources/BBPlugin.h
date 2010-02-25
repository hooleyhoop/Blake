//
//  BBPlugin.h
//  Blocks
//
//  Created by Jesse Grosjean on 1/5/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#if (MAC_OS_X_VERSION_MAX_ALLOWED <= MAC_OS_X_VERSION_10_5)
@interface BBPlugin : SHooleyObject {
#else
@interface BBPlugin : SHooleyObject <NSXMLParserDelegate> {
#endif
    NSBundle *fBundle;
    NSDictionary *fAttributes;
    NSMutableArray *fRequirements;
    NSMutableArray *fExtensionPoints;
    NSMutableArray *fExtensions;
	int fLoadSequenceNumber;
}

#pragma mark init

- (id)initWithBundle:(NSBundle *)bundle;
- (id)initWithXML:(NSString *)validXMLPath;

#pragma mark accessors

- (NSBundle *)bundle;
- (NSString *)name;
- (NSString *)identifier;
- (NSString *)version;
- (NSString *)providerName;
- (NSArray *)requirements;
- (NSArray *)extensionPoints;
- (NSArray *)extensions;
- (NSString *)xmlPath;
- (NSString *)protocolsPath;
- (BOOL)enabled;

#pragma mark loading
- (BOOL)scanPluginXML;
- (BOOL)parseXML:(NSString *)pluginXMLPath;

- (int)loadSequenceNumber;
- (BOOL)isLoaded;
- (BOOL)load;

@end