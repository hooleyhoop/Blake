//
//  BKLicense.h
//  Blocks
//
//  Created by Jesse Grosjean on 1/10/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Blocks/Blocks.h>
#import "BKFoundationProtocols.h"


@interface BKLicense : NSObject {
    NSData *publicKey;
    NSData *privateKey;
	NSMutableDictionary *licenseFile;
}

#pragma mark class methods

+ (BOOL)removeLicense:(NSString *)licenseName;
+ (BOOL)isLicenseValid:(NSString *)licenseName;
+ (BOOL)isLicenseValidAtPath:(NSString *)path publicKey:(NSData *)publicKey;
+ (BKLicense *)licenseNamed:(NSString *)licenseName;
+ (void)uncacheLicenseNamed:(NSString *)licenseName;
+ (void)dontShowDonateWindowForLicenseNamed:(NSString *)name;
+ (BOOL)showsDonateWindowForLicenseNamed:(NSString *)name;

#pragma mark init

- (id)initLicenseWithContentsOfFile:(NSString *)path;

#pragma mark accessors

- (NSData *)publicKey;
- (void)setPublicKey:(NSData *)publicKey;
- (NSData *)privateKey;
- (void)setPrivateKey:(NSData *)privateKey;
- (NSString *)licenseKey;
- (void)setLicenseKey:(NSString *)licenseKey;

#pragma mark license data

- (NSString *)licenseName;
- (void)setLicenseName:(NSString *)licenseName;
- (NSString *)firstName;
- (void)setFirstName:(NSString *)firstName;
- (NSString *)lastName;
- (void)setLastName:(NSString *)lastName;
- (NSString *)email;
- (void)setEmail:(NSString *)email;
- (NSString *)numberOfUsers;
- (void)setNumberOfUsers:(NSString *)numberOfUsers;
- (NSString *)orderNumber;
- (void)setOrderNumber:(NSString *)orderNumber;
- (NSString *)licenseInfoAsString;
- (NSString *)licenseInfoForKey:(NSString *)key;
- (void)setLicenseInfo:(NSString *)string forKey:(NSString *)key;

#pragma mark behaviors

- (BOOL)writeToFile:(NSString *)path;
- (NSString *)generateLicenseKey;
- (BOOL)isValid;

@end