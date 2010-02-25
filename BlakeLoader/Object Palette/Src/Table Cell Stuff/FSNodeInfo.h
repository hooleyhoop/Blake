//
//  FSNodeInfo.h
//
//  Copyright (c) 2001-2002, Apple. All rights reserved.
//
//  FSNodeInfo encapsulates information about a file or directory.
//  This implementation is not necessarily the best way to do something like this,
//  it is simply a wrapper to make the rest of the browser code easy to follow.

@class SHNode;

@interface FSNodeInfo : _ROOT_OBJECT_ {

    NSString    *relativePath;  // Path relative to the parent.
    FSNodeInfo  *parentNode;	// Containing directory, not retained to avoid retain/release cycles.
	BOOL		isDirectory;
	id			representedObject;
}

+ (FSNodeInfo *)nodeWithParent:(FSNodeInfo*)parent atRelativePath:(NSString *)path representedObject:(id)theRepresentedObject;

- (id)initWithParent:(FSNodeInfo*)parent atRelativePath:(NSString*)path representedObject:(id)theRepresentedObject;

- (void)dealloc;

- (BOOL)isDirectory;
- (void)setIsDirectory:(BOOL)flag;

- (SHNode *)representedObject;
- (void)setRepresentedObject:(id)aRepresentedObject;

- (NSString *)relativePath;
- (void)setRelativePath:(NSString *)aRelativePath;

// - (NSString *)lastPathComponent;


- (BOOL)isDirectory;

- (NSImage*)iconImageOfSize:(NSSize)size; 

@end
