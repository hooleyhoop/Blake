//
//  BKLicenseDocumentTypeExtension.m
//  Blocks
//
//  Created by Jesse Grosjean on 5/31/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKLicenseDocumentTypeExtension.h"
#import "BKLicenseDocument.h"


@implementation BKLicenseDocumentTypeExtension

- (NSArray *)supportedTypes {
	return [NSArray arrayWithObject:@"Blocks License"];
}

- (NSString *)defaultType {
	return nil;
}

- (NSString *)typeForContentsOfURL:(NSURL *)inAbsoluteURL error:(NSError **)outError {
	NSString *path = [inAbsoluteURL path];
	
	// try to load license files even if their extension has been stripped by email system
	NSNumber *bytes = [[[NSFileManager defaultManager] fileAttributesAtPath:path traverseLink:NO] objectForKey:NSFileSize];
	if ([bytes intValue] < 5000) {
		NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
		if ([dictionary objectForKey:@"BKLicenseInfo"]) {
			return @"Blocks License";
		}
	}
	
	return nil;
}

- (NSArray *)documentClassNames {
	return [NSArray arrayWithObject:@"BKLicenseDocument"];
}

- (Class)documentClassForType:(NSString *)typeName {
	if ([typeName isEqualToString:@"Blocks License"]) {
		return [BKLicenseDocument class];
	}
	return nil;
}

- (id)openUntitledDocumentAndDisplay:(BOOL)displayDocument error:(NSError **)outError {
	return nil; // use default implementation;
}

- (id)makeUntitledDocumentOfType:(NSString *)typeName error:(NSError **)outError {
	return nil; // use default implementation;
}

- (id)makeDocumentWithContentsOfURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError {
	return nil; // use default implementation;
}

- (id)failedToOpenDocumentWithContentsOfURL:(NSURL *)absoluteURL display:(BOOL)displayDocument error:(NSError **)outError {
	return nil; // use default implementation;
}

@end
