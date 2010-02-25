//
//  SHUndoManager.h
//  SHShared
//
//  Created by steve hooley on 28/04/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

//#import <Cocoa/Cocoa.h>

@interface NSUndoManager (SHUndoManager)

//- (void)beginUndoGrouping:(NSString *)acName;
//- (void)beginUndoGrouping:(NSString *)acName reverseName:(NSString *)revName;
//- (void)setActionName:(NSString *)acName reverseName:(NSString *)revName;

- (void)beginDebugUndoGroup;


@end
