//
//  SHFScriptNodeGraphLoader.h
//  Pharm
//
//  Created by Steve Hooley on 15/12/2005.
//  Copyright 2005 HooleyHoop. All rights reserved.
//

#import  "NodeGraphLoaderProtocol.h"

@class SHNode;

@interface SHFScriptNodeGraphLoader : _ROOT_OBJECT_ <NodeGraphLoaderProtocol> {
	
}

#pragma mark -
#pragma mark class methods
+ (SHFScriptNodeGraphLoader *)nodeGraphLoader;

#pragma mark Action methods
- (BOOL)saveNode:aNode toFile:(NSString*) filePath;

- (SHNode*)loadNodeFromFile:(NSString*) filePath;

/* Returns an aml wrapper for copying to the pasteboard where each child is an fscript string */
- (NSXMLElement *)scriptWrapperFromChildren:(NSArray *)childrenToCopy fromNode:(SHNode *)parentNode;
- (BOOL)unArchiveChildrenFromScriptWrapper:(NSXMLElement *)copiedStuffWrapper intoNode:(SHNode *)parentNode;
	
//- (IBAction) saveScript:(id)sender;

//- (IBAction) loadScript:(id)sender;

//- (void) doSave:(NSString*)aPath;
//- (void) loadNodeIntoRoot:(NSString*)aPath;

@end
