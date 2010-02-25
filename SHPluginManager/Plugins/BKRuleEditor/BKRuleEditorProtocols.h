//
//  BKRuleEditorProtocols.h
//  Blocks
//
//  Created by Jesse Grosjean on 1/8/06.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@protocol BKRuleViewControllerProtocol;
@protocol BKStringRuleViewControllerProtocol;
@protocol BKNumberRuleViewControllerProtocol;
@protocol BKRuleEditorWindowControllerProtocol;
@protocol BKDateRuleViewControllerProtocol;
@protocol BKBooleanRuleViewControllerProtocol;
@protocol BKTriStateRuleViewControllerProtocol;

@protocol BKTokenRuleViewControllerProtocol;

typedef enum _BKRuleEditorMatchRule {
    BKRuleEditorMatchRuleAll = 0,
    BKRuleEditorMatchRuleAny = 1
} BKRuleEditorMatchRule;

@interface NSObject (BKRuleEditorProtocols)

+ (id <BKRuleEditorWindowControllerProtocol>)createNewRuleEditorWindowController;
+ (id <BKStringRuleViewControllerProtocol>)createNewStringRuleViewControllerWithRuleKey:(NSString *)ruleKey predicate:(NSPredicate *)predicate;
+ (id <BKNumberRuleViewControllerProtocol>)createNewNumberRuleViewControllerWithRuleKey:(NSString *)ruleKey predicate:(NSPredicate *)predicate;
+ (id <BKDateRuleViewControllerProtocol>)createNewDateRuleViewControllerWithRuleKey:(NSString *)ruleKey predicate:(NSPredicate *)predicate;
+ (id <BKBooleanRuleViewControllerProtocol>)createNewBooleanRuleViewControllerWithRuleKey:(NSString *)ruleKey predicate:(NSPredicate *)predicate;
+ (id <BKTriStateRuleViewControllerProtocol>)createNewTriStateRuleViewControllerWithRuleKey:(NSString *)ruleKey predicate:(NSPredicate *)predicate;
+ (id <BKTokenRuleViewControllerProtocol>)createNewTokenRuleViewControllerWithRuleKey:(NSString *)ruleKey predicate:(NSPredicate *)predicate;

@end

@protocol BKRuleEditorWindowControllerProtocol <NSObject>

- (NSWindowController *)selfAsWindowController;
- (NSString *)folderName;
- (void)setFolderName:(NSString *)newFolderName;
- (NSString *)folderKind;
- (void)setFolderKind:(NSString *)newFolderKind;
- (BKRuleEditorMatchRule)matchRule;
- (void)setMatchRule:(BKRuleEditorMatchRule)newMatchRule;
- (NSString *)defaultRuleKey;
- (void)setDefaultRuleKey:(NSString *)newDefaultRuleKey;
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

- (NSCompoundPredicate *)predicate;
- (void)setPredicate:(NSCompoundPredicate *)predicate;

@end

@protocol BKRuleContributerProtocol <NSObject>

- (NSArray *)ruleKeys;
- (NSString *)ruleNameForKey:(NSString *)ruleKey;
- (void)filterRulesMenu:(NSMenu *)rulesMenu folderKind:(NSString *)folderKind;
- (NSString *)sortDescriptorKeyForKey:(NSString *)ruleKey;
- (id <BKRuleViewControllerProtocol>)createRuleViewControllerForRuleKey:(NSString *)ruleKey;
- (id <BKRuleViewControllerProtocol>)createRuleViewControllerForPredicate:(NSPredicate *)predicate;
- (NSPredicate *)createPredicateFromRuleViewController:(id <BKRuleViewControllerProtocol>)ruleViewController;

@end

#pragma mark rule view controllers

@protocol BKRuleViewControllerProtocol <NSObject>

- (NSString *)ruleKey;
- (NSPredicate *)predicate;
- (void)setPredicate:(NSPredicate *)newPredicate;
- (NSView *)view;
- (void)filterPredicateOperatorsForFolderKind:(NSString *)folderKind;

@end

@protocol BKStringRuleViewControllerProtocol <BKRuleViewControllerProtocol>
@end

@protocol BKNumberRuleViewControllerProtocol <BKRuleViewControllerProtocol>

- (NSControl *)prototypePrototypeExpressionControl;
- (void)setPrototypeExpressionControl:(NSControl *)newPrototypeExpressionControl;

@end

@protocol BKDateRuleViewControllerProtocol <BKRuleViewControllerProtocol>
@end

@protocol BKBooleanRuleViewControllerProtocol <BKRuleViewControllerProtocol>
@end

@protocol BKTriStateRuleViewControllerProtocol <BKRuleViewControllerProtocol>
@end

@protocol BKTokenRuleViewControllerProtocol <BKRuleViewControllerProtocol>

- (NSArray *)completions;
- (void)setCompletions:(NSArray *)newCompletions;
	
@end