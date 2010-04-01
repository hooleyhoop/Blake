//
//  SHDocumentController.m
//  SHShared
//
//  Created by steve hooley on 13/06/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "SHDocumentController.h"


static NSMutableDictionary *_dynamicDocTypes;

@implementation SHDocumentController

+ (void)cleanUpSharedDocumentController {
	
	[_dynamicDocTypes release];
	_dynamicDocTypes = nil;
}

- (id)init {
	
	self = [super init];
	if(self)
    {

	}
	return self;
}

- (void)dealloc {
	[super dealloc];
}

- (NSString *)defaultType {
	
	return @"SHDocument";
}

- (void)setDocClass:(Class)aClass forDocType:(NSString *)docType {

	if(_dynamicDocTypes==nil)
		_dynamicDocTypes = [[NSMutableDictionary dictionary] retain];
	[_dynamicDocTypes setObject:NSStringFromClass(aClass) forKey:docType];
}

- (Class)documentClassForType:(NSString *)documentTypeName {
	
	Class docClass;
	NSString *docClassName = [_dynamicDocTypes objectForKey:documentTypeName];
	if(docClassName)
		docClass = NSClassFromString(docClassName);
	else
		docClass = NSClassFromString(@"SHDocument");
	return docClass;
}

/* callback from document after calling closeAllDocumentsWithDelegate */
- (void)documentController:(NSDocumentController *)docController didCloseAll:(BOOL)didCloseAll contextInfo:(void *)contextInfo {
}

@end
