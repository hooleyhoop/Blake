//
//  BBExtensionPoint.h
//  Blocks
//
//  Created by Jesse Grosjean on 1/5/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

@class BBPlugin;

@interface BBExtensionPoint : SHooleyObject {
    BBPlugin *fPlugin;
    NSString *fIdentifier;
    NSString *fProtocolName;
}

#pragma mark init

- (id)initWithPlugin:(BBPlugin *)plugin identifier:(NSString *)identifier protocolName:(NSString *)protocolName;

#pragma mark accessors

- (BBPlugin *)plugin;
- (NSString *)identifier;
- (NSString *)protocolName;
- (NSArray *)extensions;

@end
