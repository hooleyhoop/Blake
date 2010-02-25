//
//  BKScriptsController.h
//  Blocks
//
//  Created by Jesse Grosjean on 1/9/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Blocks/Blocks.h>
#import "BKApplicationProtocols.h"
#import "BKScriptsProtocols.h"


@interface BKScriptsController : NSObject <BKScriptsControllerProtocol> {
    NSMenu *fScriptMenu;
}

#pragma mark class methods

+ (id)sharedInstance;

#pragma mark accessors

- (NSMenu *)scriptMenu;

#pragma mark actions

- (IBAction)openScriptsFolder:(id)sender;
- (IBAction)updateScriptsMenu:(id)sender;
- (IBAction)scriptMenuAction:(id)sender;

#pragma mark behavior

- (NSMenuItem *)menuItemForMenu:(NSMenu *)menu;
- (id <BKScriptsFileControllerProtocol>)fileControllerFor:(NSString *)filePath;
- (BOOL)validateScriptAtPath:(NSString *)path;

#pragma mark locate script files

- (NSString *)applicationScriptsFolderName;
- (NSArray *)scriptFilePaths;
- (NSArray *)validScriptSubpathsFor:(NSString *)filePath;
- (NSArray *)validScriptSubpathsFor:(NSString *)filePath folders:(NSMutableArray *)folders scriptFiles:(NSMutableArray *)scriptFiles recurse:(BOOL)recurse;

#pragma mark commands

- (NSArray *)scriptFilesRespondingToCommand:(NSString *)command;
- (NSArray *)scriptFilesPerformCommand:(NSString *)command withArguments:(NSArray *)arguments;

@end
