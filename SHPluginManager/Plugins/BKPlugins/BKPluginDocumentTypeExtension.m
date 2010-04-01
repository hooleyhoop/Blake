//
//  BKPluginDocumentTypeExtension.m
//  Blocks
//
//  Created by Jesse Grosjean on 5/31/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKPluginDocumentTypeExtension.h"
#import "BKPluginDocument.h"


@implementation BKPluginDocumentTypeExtension

- (NSArray *)supportedTypes {
	return [NSArray arrayWithObject:@"Blocks Plugin"];
}

- (NSString *)defaultType {
	return nil;
}

- (NSString *)typeForContentsOfURL:(NSURL *)inAbsoluteURL error:(NSError **)outError {
	return nil;
}

- (NSArray *)documentClassNames {
	return [NSArray arrayWithObject:@"BKPluginDocument"];
}

- (Class)documentClassForType:(NSString *)typeName {
	if ([typeName isEqualToString:@"Blocks Plugin"]) {
		return [BKPluginDocument class];
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
