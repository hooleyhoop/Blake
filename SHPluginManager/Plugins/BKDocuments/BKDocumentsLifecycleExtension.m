//
//  BKDocumentsLifecycleExtension.m
//  Blocks
//
//  Created by Jesse Grosjean on 5/31/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKDocumentsLifecycleExtension.h"
#import "BKDocumentsDocumentController.h"


@implementation BKDocumentsLifecycleExtension

- (void)applicationLaunching {
	[[BKDocumentsDocumentController sharedInstance] documentTypeExtensions]; // load document plugins early
}

- (void)applicationWillFinishLaunching {
}

- (void)applicationDidFinishLaunching {
}

- (void)applicationWillTerminate {
}

@end
