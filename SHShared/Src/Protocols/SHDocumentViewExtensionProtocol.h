/*
 *  SHDocumentViewExtensionProtocol.h
 *  SHShared
 *
 *  Created by steve hooley on 24/11/2008.
 *  Copyright 2008 BestBefore Ltd. All rights reserved.
 *
 */

@protocol SHDocumentViewExtensionProtocol <NSObject>

@required
- (void)installViewMenuItem;
- (void)showWindow:(id)sender;
- (NSString *)windowControllerClassName;

@optional
- (void)shitBag;

@end