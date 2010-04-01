//
//  BKRuleEditorWindowController.h
//  SmartFolder
//
//  Created by Jesse Grosjean on 9/13/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Blocks/Blocks.h>
#import "BKApplicationProtocols.h"
#import "BKRuleEditorProtocols.h"


@class BKRuleEditorView;
@class BKRuleContainerController;

@interface BKRuleEditorWindowController : NSWindowController {
	IBOutlet BKRuleEditorView *ruleEditorView;
	IBOutlet NSObjectController *controller;
	IBOutlet NSPopUpButton *sortByPopUpButton;
	IBOutlet NSPopUpButton *orderByPopUpButton;
	IBOutlet NSBox *matchRuleBox;
	IBOutlet NSTextField *tagFolderDescription;

	NSString *folderName;
	NSString *folderKind;
	BKRuleEditorMatchRule matchRule;
	NSString *defaultRuleKey;
	NSString *defaultSortDescriptorKey;
	NSMutableArray *ruleContainers;
	NSNumber *usesSortDescriptors;
	NSNumber *usesFetchLimit;
	NSNumber *fetchLimit;
	NSNumber *liveUpdatesOfSearchResults;
	NSNumber *includeEntriesFromTrash;
}

#pragma mark properties

- (NSWindowController *)selfAsWindowController;
- (NSString *)folderName;
- (void)setFolderName:(NSString *)newFolderName;
- (NSString *)folderKind;
- (void)setFolderKind:(NSString *)newFolderKind;
- (BKRuleEditorMatchRule)matchRule;
- (void)setMatchRule:(BKRuleEditorMatchRule)newMatchRule;
- (NSString *)defaultRuleKey;
- (void)setDefaultRuleKey:(NSString *)newDefaultRuleKey;
- (NSString *)defaultSortDescriptorKey;
- (void)setDefaultSortDescriptorKey:(NSString *)newDefaultSortDescriptorKey;
- (NSNumber *)usesSortDescriptors;
- (void)setUsesSortDescriptors:(NSNumber *)newUsesSortDescriptors;
- (NSArray *)sortDescriptors;
- (void)setSortDescriptors:(NSArray *)sortDescriptors;
- (NSNumber *)usesFetchLimit;
- (void)setUsesFetchLimit:(NSNumber *)newUsesFetchLimit;
- (NSNumber *)fetchLimit;
- (void)setFetchLimit:(NSNumber *)newFetchLimit;
- (NSNumber *)liveUpdatesOfSearchResults;
- (void)setLiveUpdatesOfSearchResults:(NSNumber *)newLiveUpdatesOfSearchResults;
- (NSNumber *)includeEntriesFromTrash;
- (void)setIncludeEntriesFromTrash:(NSNumber *)newIncludeEntriesFromTrash;

#pragma mark predicate

- (NSCompoundPredicate *)predicate;
- (void)setPredicate:(NSCompoundPredicate *)predicate;

#pragma mark rule contributers

- (NSArray *)ruleContributers;
- (NSArray *)ruleKeys;
- (NSString *)ruleNameForKey:(NSString *)ruleKey;
- (NSString *)sortDescriptorKeyForKey:(NSString *)ruleKey;
- (id <BKRuleViewControllerProtocol>)createRuleViewControllerForRuleKey:(NSString *)ruleKey;
- (id <BKRuleViewControllerProtocol>)createRuleViewControllerForPredicate:(NSPredicate *)predicate;
- (NSPredicate *)createPredicateFromRuleViewController:(id <BKRuleViewControllerProtocol>)ruleViewController;

#pragma mark rules gui

- (NSMenu *)rulesMenu;
- (NSMenu *)sortDescriptorsMenu;
- (void)addRuleContainer:(BKRuleContainerController *)newRuleContainer after:(BKRuleContainerController *)ruleContainer;
- (void)removeRuleContainer:(BKRuleContainerController *)ruleContainer;
- (int)numberOfRuleContainers;

#pragma mark actions

- (IBAction)cancel:(id)sender;
- (IBAction)ok:(id)sender;

@end