//
//  TADocumentTypeExtension.m
//  TemplateDocumentBasedApplication
//
//  Created by Jesse Grosjean on 6/7/05.
//  Copyright 2005 Hog Bay Software. All rights reserved.
//

#import "TADocumentTypeExtension.h"
#import "TADocument.h"


@implementation TADocumentTypeExtension

- (NSArray *)supportedTypes {
	return [NSArray arrayWithObject:@"TemplateDocumentBasedApplication Document"];
}

- (NSString *)defaultType {
	return @"TemplateDocumentBasedApplication Document";
}

- (NSString *)typeForContentsOfURL:(NSURL *)inAbsoluteURL error:(NSError **)outError {
	return nil;
}

- (NSArray *)documentClassNames {
	return [NSArray arrayWithObject:@"TADocument"];
}

- (Class)documentClassForType:(NSString *)typeName {
	if ([typeName isEqualToString:@"TemplateDocumentBasedApplication Document"]) {
		return [TADocument class];
	}
	return nil;
}

- (id)openUntitledDocumentAndDisplay:(BOOL)displayDocument error:(NSError **)outError {
//	NSURL *url = [MICreateDocumentWindowController urlForNewDocument:outError];
	
//	if (url) {
//		return [[NSDocumentController sharedDocumentController] openNewDocumentAndSaveAs:url display:displayDocument error:outError];
//	}	
	return nil;  // use default implementation;
}

- (id)makeUntitledDocumentOfType:(NSString *)typeName error:(NSError **)outError {
	return nil; // use default implementation;
}

- (id)makeDocumentWithContentsOfURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError {
	return nil; // use default implementation;
}




/*

- (id)makeDocumentWithContentsOfURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError {
	if ([typeName isEqualToString:@"TemplateDocumentBasedApplication Document"]) {
		return [[[TADocument alloc] initWithContentsOfURL:absoluteURL ofType:typeName error:outError] autorelease];
	}
	return nil;
}
*/
@end
