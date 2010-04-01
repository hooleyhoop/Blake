//
//  BKLicense.m
//  Blocks
//
//  Created by Jesse Grosjean on 1/10/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKLicense.h"

#import <openssl/evp.h>
#import <openssl/rand.h>
#import <openssl/rsa.h>
#import <openssl/engine.h>
#import <openssl/sha.h>
#import <openssl/pem.h>
#import <openssl/bio.h>
#import <openssl/err.h>
#import <openssl/ssl.h>

#define BKLicenseKey @"BKLicense"
#define BKLicenseUsername @"BKLicenseUsername"
#define BKLicenseOrderNumber @"BKLicenseOrderNumber"

@interface BKLicense (Private)
- (NSMutableDictionary *)licenseFile;
- (NSMutableDictionary *)licenseInfo;
- (NSData *)sha1Digest:(NSData *)data;
- (NSData *)encrypt:(NSData *)clearTextData;
- (NSData *)decrypt:(NSData *)cipherTextData;
- (NSData *)base64Encode:(NSData *)data;
- (NSData *)base64Decode:(NSData *)data;
@end

@implementation BKLicense

#pragma mark class methods

+ (BOOL)removeLicense:(NSString *)licenseName {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *supportFolder = [fileManager processesApplicationSupportFolder];
	NSString *licensePath = [supportFolder stringByAppendingPathComponent:licenseName];
	
	if (![fileManager removeFileAtPath:licensePath handler:nil]) {
		logError(([NSString stringWithFormat:@"Failed to removed license file %@", licensePath]));
		return NO;
	}
	
	[self uncacheLicenseNamed:licenseName];
	
	return YES;
}

+ (BOOL)isLicenseValid:(NSString *)licenseName {
	return [[self licenseNamed:licenseName] isValid];
}

+ (BOOL)isLicenseValidAtPath:(NSString *)path publicKey:(NSData *)aPublicKey {
	BKLicense *license = [[[BKLicense alloc] initLicenseWithContentsOfFile:path] autorelease];
	[license setPublicKey:aPublicKey];
	return [license isValid];
}

static NSMutableDictionary *nameToLicense = nil;

+ (BKLicense *)licenseNamed:(NSString *)licenseName {
	if (!nameToLicense) nameToLicense = [[NSMutableDictionary alloc] init];
	if (!licenseName) return nil;
	
	BKLicense *license = [nameToLicense objectForKey:licenseName];
	if (!license) {
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSString *path = [[fileManager processesApplicationSupportFolder] stringByAppendingPathComponent:licenseName];
		
		license = [[[BKLicense alloc] initLicenseWithContentsOfFile:path] autorelease];
		if (license) {
			[nameToLicense setObject:license forKey:licenseName];
		}
	}
	
	return license;
}

+ (void)uncacheLicenseNamed:(NSString *)licenseName {
	[nameToLicense removeObjectForKey:licenseName];
}

+ (void)dontShowDonateWindowForLicenseNamed:(NSString *)name {
	[[NSUserDefaults standardUserDefaults] setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"] forKey:@"BKLicenseDontShowDonationWindowForVersion"];
}

+ (BOOL)showsDonateWindowForLicenseNamed:(NSString *)name {
	int currentVersion = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"] intValue];
	int dontShowVersion = [[NSUserDefaults standardUserDefaults] integerForKey:@"BKLicenseDontShowDonationWindowForVersion"];
	return currentVersion > dontShowVersion;
}

#pragma mark init

- (id)initLicenseWithContentsOfFile:(NSString *)path {
    if (self = [super init]) {
		licenseFile = [[NSDictionary dictionaryWithContentsOfFile:path] retain];
    }
    return self;
}

#pragma mark dealloc

- (void)dealloc {
	[licenseFile release];
    [publicKey release];
    [privateKey release];
    [super dealloc];
}

#pragma mark accessors

- (NSData *)publicKey {
    return publicKey;
}

- (void)setPublicKey:(NSData *)aPublicKey {
    [publicKey autorelease];
    publicKey = [aPublicKey retain];
}

- (NSData *)privateKey {
    return privateKey;
}

- (void)setPrivateKey:(NSData *)aPrivateKey {
    [privateKey autorelease];
    privateKey = [aPrivateKey retain];
}

- (NSString *)licenseKey {
	return [[self licenseFile] objectForKey:@"BKLicenseKey"];
}

- (void)setLicenseKey:(NSString *)licenseKey {
	[[self licenseFile] setObject:licenseKey forKey:@"BKLicenseKey"];
}

- (NSString *)licenseName {
	return [[self licenseFile] objectForKey:@"BKLicenseNameKey"];	
}

- (void)setLicenseName:(NSString *)licenseName {
	[[self licenseFile] setObject:licenseName forKey:@"BKLicenseNameKey"];
}

#pragma mark license data

- (NSString *)firstName {
	return [self licenseInfoForKey:@"BKLicenseFirstNameKey"];
}

- (void)setFirstName:(NSString *)firstName {
	[self setLicenseInfo:firstName forKey:@"BKLicenseFirstNameKey"];
}

- (NSString *)lastName {	
	return [self licenseInfoForKey:@"BKLicenseLastNameKey"];
}

- (void)setLastName:(NSString *)lastName {
	[self setLicenseInfo:lastName forKey:@"BKLicenseLastNameKey"];
}

- (NSString *)email {	
	return [self licenseInfoForKey:@"BKLicenseEmailKey"];
}

- (void)setEmail:(NSString *)email {
	[self setLicenseInfo:email forKey:@"BKLicenseEmailKey"];
}

- (NSString *)numberOfUsers {
	return [self licenseInfoForKey:@"BKLicenseNumberOfUsersKey"];
}

- (void)setNumberOfUsers:(NSString *)numberOfUsers {
	[self setLicenseInfo:numberOfUsers forKey:@"BKLicenseNumberOfUsersKey"];
}

- (NSString *)orderNumber {
	return [self licenseInfoForKey:@"BKLicenseOrderNumberKey"];
}

- (void)setOrderNumber:(NSString *)orderNumber {
	[self setLicenseInfo:orderNumber forKey:@"BKLicenseOrderNumberKey"];
}

- (NSString *)licenseInfoAsString {
	NSMutableString *licenseInfoString = [NSMutableString string];
	NSDictionary *licenseInfo = [self licenseInfo];
	NSArray *keys = [[licenseInfo allKeys] sortedArrayUsingSelector:@selector(compare:)];
	NSEnumerator *enumerator = [keys objectEnumerator];
	NSString *each;
	
	while (each = [enumerator nextObject]) {
		[licenseInfoString appendFormat:@"%@, %@\n", each, [licenseInfo objectForKey:each]];
	}
	
	return licenseInfoString;
}

- (NSString *)licenseInfoForKey:(NSString *)key {
	return [[self licenseInfo] objectForKey:key];
}

- (void)setLicenseInfo:(NSString *)string forKey:(NSString *)key {
	[[self licenseInfo] setObject:string forKey:key];
}

#pragma mark behaviors

- (BOOL)writeToFile:(NSString *)path {
	return [[self licenseFile] writeToFile:path atomically:YES];
}

- (NSString *)generateLicenseKey {
	NSData *licenseInfoData = [[self licenseInfoAsString] dataUsingEncoding:NSUTF8StringEncoding];
	NSData *licenseInfoDigestData = [self sha1Digest:licenseInfoData];
	NSData *encryptedLicenseInfoDigestData = [self encrypt:licenseInfoDigestData];
	NSData *base64EncryptedLicenseInfoDigestData = [self base64Encode:encryptedLicenseInfoDigestData];
	return [[[NSString alloc] initWithData:base64EncryptedLicenseInfoDigestData encoding:NSUTF8StringEncoding] autorelease];
}

- (BOOL)isValid {
    NSString *licenseKey = [[[self licenseKey] componentsSeparatedByLineSeparators] componentsJoinedByString:@"\n"]; // remove any alternate line separators that may have been inserted by mail clients.
	NSString *licenseInfo = [self licenseInfoAsString];
	
    if (!licenseKey) {
		return NO;
	}
	
    if (!licenseInfo) {
		return NO;
	}	
	
	// XXX Baned licenses because they were found on file sharing networks.
	if ([[self email] isEqualToString:@"stubenberg.1@nd.edu"] && [[self orderNumber] isEqualToString:@"184"]) {
		return NO;
	}
	
	// decrypt license key
    NSData *base64EncryptedKeyData = [licenseKey dataUsingEncoding:NSUTF8StringEncoding];

    if (!base64EncryptedKeyData) {
		logWarn(@"base64EncryptedKeyData is nil");
		return NO;
	}
    
	NSData *encryptedkeyData = [self base64Decode:base64EncryptedKeyData];

    if (!encryptedkeyData) {
		logWarn(@"encryptedkeyData is nil");
		return NO;
	}
    
	NSData *keyData = [self decrypt:encryptedkeyData];

    if (!keyData) {
		logWarn(@"keyData is nil");
		return NO;
	}
	
	// compare result with digested license info
	NSData *licenseInfoData = [licenseInfo dataUsingEncoding:NSUTF8StringEncoding];
	
	if (!licenseInfoData) {
		logWarn(@"licenseInfoData is nil");
		return NO;		
	}
	
    NSData *licenseInfoDigestData = [self sha1Digest:licenseInfoData];

    if (!licenseInfoDigestData) {
		logWarn(@"licenseInfoDigestData is nil");
		return NO;		
	}
	
	if (![keyData isEqualToData:licenseInfoDigestData]) {
		logWarn(@"keyData does not equal licenseInfoDigestData");
		return NO;
	} else {
		return YES;
	}
}

#pragma mark private

- (NSMutableDictionary *)licenseFile {
	if (!licenseFile) {
		licenseFile = [[NSMutableDictionary alloc] init];
	}
	return licenseFile;
}

- (NSMutableDictionary *)licenseInfo {
	NSMutableDictionary *licenseInfo = [[self licenseFile] objectForKey:@"BKLicenseInfo"];
	if (!licenseInfo) {
		licenseInfo = [[[NSMutableDictionary alloc] init] autorelease];
		[[self licenseFile] setObject:licenseInfo forKey:@"BKLicenseInfo"];
	}
	return licenseInfo;
}

- (NSData *)sha1Digest:(NSData *)data {
    unsigned char *digest = SHA1([data bytes], [data length], NULL);
    
    if (!digest) {
		return nil;
    }

    return [NSData dataWithBytes:digest length:SHA_DIGEST_LENGTH];
}

- (NSData *)encrypt:(NSData *)clearTextData {
    unsigned char *input = (unsigned char *)[clearTextData bytes];
    unsigned char *outbuf;
    NSData *cipherTextData;
    int outlen, inlen;
    inlen = [clearTextData length];
    
    BIO *privateBIO = NULL;
    RSA *privateRSA = NULL;
    
    if(!(privateBIO = BIO_new_mem_buf((unsigned char*)[[self privateKey] bytes], -1))) {
		logWarn((@"BIO_new_mem_buf() failed!"));
		return nil;
    }
    
    if (!PEM_read_bio_RSAPrivateKey(privateBIO, &privateRSA, NULL, NULL)) {
		logWarn((@"PEM_read_bio_RSAPrivateKey() failed!"));
		return nil;
    }
    
    unsigned long check = RSA_check_key(privateRSA);
    if (check != 1) {
		logWarn(([NSString stringWithFormat:@"RSA_check_key() failed with result %d!", check]));
		return nil;
    }			
    
    outbuf = (unsigned char *)malloc(RSA_size(privateRSA));
    
    if (!(outlen = RSA_private_encrypt(inlen,
				       input,
				       (unsigned char*)outbuf,
				       privateRSA,
				       RSA_PKCS1_PADDING))) {
		logWarn(([NSString stringWithFormat:@"RSA_private_encrypt failed!", outlen]));
		return nil;
    }
    
    if (outlen == -1) {
		NSString *error = [NSString stringWithFormat:@"Encrypt error: %s (%s)",
			ERR_error_string(ERR_get_error(), NULL),
			ERR_reason_error_string(ERR_get_error())];
		logWarn((error));
		return nil;
    }

    if (privateBIO) BIO_free(privateBIO);
    if (privateRSA) RSA_free(privateRSA);

    cipherTextData = [NSData dataWithBytes:outbuf length:outlen];
    
    if (outbuf) {
		free(outbuf);
    }
    
    return cipherTextData;
}

- (NSData *)decrypt:(NSData *)cipherTextData {
    unsigned char *outbuf;
    int outlen, inlen;
    inlen = [cipherTextData length];
    unsigned char *input = (unsigned char *)[cipherTextData bytes];
    
    BIO *publicBIO = NULL;
    RSA *publicRSA = NULL;
    
    if (!(publicBIO = BIO_new_mem_buf((unsigned char *)[[self publicKey] bytes], -1))) {
		logWarn((@"BIO_new_mem_buf() failed!"));
		return nil;
    }
    
    if (!PEM_read_bio_RSA_PUBKEY(publicBIO, &publicRSA, NULL, NULL)) {
		logWarn((@"PEM_read_bio_RSA_PUBKEY() failed!"));
		return nil;
    }			
    
    outbuf = (unsigned char *)malloc(RSA_size(publicRSA));
    
    if (!(outlen = RSA_public_decrypt(inlen,
				      input,
				      outbuf,
				      publicRSA,
				      RSA_PKCS1_PADDING))) {
		logWarn((@"RSA_public_decrypt() failed!"));
		return nil;
    }
    
    if (outlen == -1) {
		NSString *error = [NSString stringWithFormat:@"Decrypt error: %s (%s)",
			ERR_error_string(ERR_get_error(), NULL),
			ERR_reason_error_string(ERR_get_error())];
		logWarn((error));
		return nil;
    }
    
    if (publicBIO) BIO_free(publicBIO);
    if (publicRSA) RSA_free(publicRSA);
    
    NSData *clearTextData = [NSData dataWithBytes:outbuf length:outlen];
    
    if (outbuf) {
		free(outbuf);
    }
    
    return clearTextData;
}

- (NSData *)base64Encode:(NSData *)data {
    NSData *base64Data;
    long length;
    BIO *bio, *b64;
    BUF_MEM *bptr;
	
    bio = BIO_new(BIO_s_mem());
    b64 = BIO_new(BIO_f_base64());
    bio = BIO_push(b64, bio);
    BIO_write(bio, [data bytes], [data length]);
    BIO_flush(bio);
    length = BIO_get_mem_data(bio, &bptr);
    base64Data = [NSData dataWithBytes:bptr length:length];
    BIO_free_all(bio);
    
    return base64Data;
}

- (NSData *)base64Decode:(NSData *)base64Data {
    NSMutableData *decodedData;
    BIO *bio, *b64;
    char inbuf[512];
    int inlen;
    
    b64 = BIO_new(BIO_f_base64());
    bio = BIO_new_mem_buf((unsigned char *)[base64Data bytes], [base64Data length]);
    bio = BIO_push(b64, bio);
    decodedData = [NSMutableData data];    
    inlen = BIO_read(bio, inbuf, 512);
    while(inlen > 0) {
		[decodedData appendBytes:inbuf length:inlen];
		inlen = BIO_read(bio, inbuf, 512);
    }    
    BIO_free_all(bio);

    return decodedData;
}

@end