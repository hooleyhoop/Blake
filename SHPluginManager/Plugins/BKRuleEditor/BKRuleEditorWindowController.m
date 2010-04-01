//
//  BKRuleEditorWindowController.m
//  SmartFolder
//
//  Created by Jesse Grosjean on 9/13/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKRuleEditorWindowController.h"
#import "BKRuleEditorView.h"
#import "BKRuleContainerController.h"


@implementation BKRuleEditorWindowController

#pragma mark init

- (id)init {
    if (self = [super initWithWindowNibName:@"BKRuleEditorWindow"]) {
		ruleContainers = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark dealloc

- (void)dealloc {
	[folderName release];
	[folderKind release];
	[defaultRuleKey release];
	[defaultSortDescriptorKey release];
	[ruleContainers release];
	[usesSortDescriptors release];
	[usesFetchLimit release];
	[fetchLimit release];
	[liveUpdatesOfSearchResults release];
	[includeEntriesFromTrash release];
	[super dealloc];
}

- (void)awakeFromNib {
	logAssert([[self ruleKeys] count] > 0, @"must have rule keys defined");
	
	id <BKRuleViewControllerProtocol> firstRuleViewController = [self createRuleViewControllerForRuleKey:[self defaultRuleKey]];
	[self addRuleContainer:[[[BKRuleContainerController alloc] initWithRuleEditor:self ruleViewController:firstRuleViewController] autorelease] after:nil];
	[sortByPopUpButton setMenu:[self sortDescriptorsMenu]];
	[sortByPopUpButton selectItem:[[sortByPopUpButton menu] itemWithRepresentedObject:[self defaultSortDescriptorKey]]];
	[self setUsesSortDescriptors:[NSNumber numberWithBool:NO]];
	[self setUsesFetchLimit:[NSNumber numberWithBool:NO]];
	[self setFetchLimit:[NSNumber numberWithUnsignedInt:25]];
	[self setLiveUpdatesOfSearchResults:[NSNumber numberWithBool:YES]];
	[self setFolderKind:[self folderKind]];
	[[self window] performSelector:@selector(recalculateKeyViewLoop) withObject:nil afterDelay:0];
}

#pragma mark properties

- (NSWindowController *)selfAsWindowController {
	return self;
}

- (NSString *)folderName {
	return folderName;
}

- (void)setFolderName:(NSString *)newFolderName {
	[folderName autorelease];
	folderName = [newFolderName retain];
}

- (NSString *)folderKind {
	return folderKind;
}

- (void)setFolderKind:(NSString *)newFolderKind {
	[folderKind autorelease];
	folderKind = [newFolderKind retain];
	
	if ([folderKind isEqualToString:@"uk.co.stevehooley.mori.tagfolder"]) {
		[self setMatchRule:BKRuleEditorMatchRuleAll];
		[matchRuleBox setHidden:YES];
		[tagFolderDescription setHidden:NO];
	} else {
		[matchRuleBox setHidden:NO];
		[tagFolderDescription setHidden:YES];
	}
}

- (BKRuleEditorMatchRule)matchRule {
	return matchRule;
}

- (void)setMatchRule:(BKRuleEditorMatchRule)newMatchRule {
	matchRule = newMatchRule;
}

- (NSString *)defaultRuleKey {
	if (!defaultRuleKey) {
		defaultRuleKey = @"entryData.title";
	}
	return defaultRuleKey;
}

- (void)setDefaultRuleKey:(NSString *)newDefaultRuleKey {
	[defaultRuleKey release];
	defaultRuleKey = [newDefaultRuleKey retain];
}

- (NSString *)defaultSortDescriptorKey {
	if (!defaultSortDescriptorKey) {
		NSEnumerator *enumerator = [[self ruleKeys] objectEnumerator];
		NSString *each;
		
		while (each = [enumerator nextObject]) {
			defaultSortDescriptorKey = [self sortDescriptorKeyForKey:each];
			
			if (defaultSortDescriptorKey) {
				return defaultSortDescriptorKey;
			}
		}
	}
	
	return defaultSortDescriptorKey;
}

- (void)setDefaultSortDescriptorKey:(NSString *)newDefaultSortDescriptorKey {
	[defaultSortDescriptorKey release];
	defaultSortDescriptorKey = [newDefaultSortDescriptorKey retain];
	
	if (defaultSortDescriptorKey) {
		[sortByPopUpButton selectItem:[[sortByPopUpButton menu] itemWithRepresentedObject:defaultSortDescriptorKey]];
	}
}

- (NSNumber *)usesSortDescriptors {
	return usesSortDescriptors;
}

- (void)setUsesSortDescriptors:(NSNumber *)newUsesSortDescriptors {
	[usesSortDescriptors autorelease];
	usesSortDescriptors = [newUsesSortDescriptors retain];
}

- (NSArray *)sortDescriptors {
	NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:[[sortByPopUpButton selectedItem] representedObject] ascending:[orderByPopUpButton selectedTag]] autorelease];
	return [NSArray arrayWithObject:sortDescriptor];
}

- (void)setSortDescriptors:(NSArray *)sortDescriptors {
	NSSortDescriptor *sortDescriptor = [sortDescriptors lastObject];
	
	if (sortDescriptor) {
		[sortByPopUpButton selectItemAtIndex:[[sortByPopUpButton menu] indexOfItemWithRepresentedObject:[sortDescriptor key]]];
		[orderByPopUpButton selectItemWithTag:[sortDescriptor ascending]];
	}
}

- (NSNumber *)usesFetchLimit {
	return usesFetchLimit;
}

- (void)setUsesFetchLimit:(NSNumber *)newUsesFetchLimit {
	[usesFetchLimit autorelease];
	usesFetchLimit = [newUsesFetchLimit retain];
}

- (NSNumber *)fetchLimit {
	return fetchLimit;
}

- (void)setFetchLimit:(NSNumber *)newFetchLimit {
	[fetchLimit autorelease];
	fetchLimit = [newFetchLimit retain];
}

- (NSNumber *)liveUpdatesOfSearchResults {
	return liveUpdatesOfSearchResults;
}

- (void)setLiveUpdatesOfSearchResults:(NSNumber *)newLiveUpdatesOfSearchResults {
	[liveUpdatesOfSearchResults autorelease];
	liveUpdatesOfSearchResults = [newLiveUpdatesOfSearchResults retain];
}

- (NSNumber *)includeEntriesFromTrash {
	return includeEntriesFromTrash;
}

- (void)setIncludeEntriesFromTrash:(NSNumber *)newIncludeEntriesFromTrash {
	[includeEntriesFromTrash autorelease];
	includeEntriesFromTrash = [newIncludeEntriesFromTrash retain];
}

#pragma mark predicate

- (NSCompoundPredicate *)predicate {
	NSMutableArray *rulePredicates = [NSMutableArray array];
    int count = [ruleContainers count];
    int index;
	
    for (index = 0; index < count; index++) {
		[rulePredicates addObject:[[ruleContainers objectAtIndex:index] predicate]];
	}
	
	// must always wrap in one level of AND / OR group so that we can latter parse the predicate properly.
	if ([self matchRule] == BKRuleEditorMatchRuleAll) {
		return [[[NSCompoundPredicate alloc] initWithType:NSAndPredicateType subpredicates:rulePredicates] autorelease];
	} else {
		return [[[NSCompoundPredicate alloc] initWithType:NSOrPredicateType subpredicates:rulePredicates] autorelease];
	}
}

- (void)setPredicate:(NSCompoundPredicate *)newPredicate {
	NSArray *subpredicates = [newPredicate subpredicates];
	
	switch ([newPredicate compoundPredicateType]) {
		case NSAndPredicateType:
			[self setMatchRule:BKRuleEditorMatchRuleAll];
			break;
		case NSOrPredicateType:
			[self setMatchRule:BKRuleEditorMatchRuleAny];
			break;
		default:
			break; // don't support NOT, leave matchRule in default state if NOT is passed in.
	}
	
	BOOL hasRemovedDefaultPredicates = NO;
	NSEnumerator *enumerator = [subpredicates objectEnumerator];
	NSPredicate *eachPredicate;
	
	while (eachPredicate = [enumerator nextObject]) {
		id <BKRuleViewControllerProtocol> ruleViewController = [self createRuleViewControllerForPredicate:eachPredicate];
		
		if (ruleViewController) {
			if (!hasRemovedDefaultPredicates) { // only remove existing predicates when we know that we have a valid new predicate. One case where the new predicate
												// might not be valid is when a column has been deleted that the new predicate queries.
				NSEnumerator *ruleEnumerator = [[[ruleContainers copy] autorelease] objectEnumerator];
				BKRuleContainerController *each;
				
				while (each = [ruleEnumerator nextObject]) {
					[self removeRuleContainer:each];
				}
				hasRemovedDefaultPredicates = YES;
			}
			
			BKRuleContainerController *ruleContainer = [[[BKRuleContainerController alloc] initWithRuleEditor:self ruleViewController:ruleViewController] autorelease];
			[self addRuleContainer:ruleContainer after:nil];
		}
 	}
}

#pragma mark rule contributers

- (NSArray *)ruleContributers {
	NSMutableArray *ruleControllers = [NSMutableArray array];
    BKPluginRegistry *pluginRegistery = [BKPluginRegistry sharedInstance];
    NSEnumerator *enumerator = [[pluginRegistery loadedValidOrderedExtensionsFor:@"uk.co.stevehooley.BKRuleEditor.rulecontributer" protocol:@protocol(BKRuleContributerProtocol)] objectEnumerator];
    BKExtension *each;
	
    while (each = [enumerator nextObject]) {
		id <BKRuleContributerProtocol> extension = [each extensionInstance];
		if (extension) {
			[ruleControllers addObject:extension];
		}
	}
	
	return ruleControllers;
}

- (NSArray *)ruleKeys {
	NSMutableArray *ruleKeys = [NSMutableArray array];
	NSEnumerator *enumerator = [[self ruleContributers] objectEnumerator];
	id <BKRuleContributerProtocol> each;
	
	while (each = [enumerator nextObject]) {
		[ruleKeys addObjectsFromArray:[each ruleKeys]];
	}
	
	[ruleKeys sortUsingSelector:@selector(caseInsensitiveCompare:)];

	return ruleKeys;
}

- (NSString *)ruleNameForKey:(NSString *)ruleKey {
	NSEnumerator *enumerator = [[self ruleContributers] objectEnumerator];
	id <BKRuleContributerProtocol> each;
	
	while (each = [enumerator nextObject]) {
		if ([[each ruleKeys] containsObject:ruleKey]) {
			return [each ruleNameForKey:ruleKey];
		}
	}
	
	return nil;
}

- (NSString *)sortDescriptorKeyForKey:(NSString *)ruleKey {
	NSEnumerator *enumerator = [[self ruleContributers] objectEnumerator];
	id <BKRuleContributerProtocol> each;
	
	while (each = [enumerator nextObject]) {
		if ([[each ruleKeys] containsObject:ruleKey]) {
			return [each sortDescriptorKeyForKey:ruleKey];
		}
	}
	
	return nil;
}

- (id <BKRuleViewControllerProtocol>)createRuleViewControllerForRuleKey:(NSString *)ruleKey {
	NSEnumerator *enumerator = [[self ruleContributers] objectEnumerator];
	id <BKRuleContributerProtocol> each;
	
	while (each = [enumerator nextObject]) {
		if ([[each ruleKeys] containsObject:ruleKey]) {
			id <BKRuleViewControllerProtocol> result = [each createRuleViewControllerForRuleKey:ruleKey];
			[result filterPredicateOperatorsForFolderKind:[self folderKind]];
			return result;
		}
	}
	
	return nil;
}

- (id <BKRuleViewControllerProtocol>)createRuleViewControllerForPredicate:(NSPredicate *)predicate {
	NSEnumerator *enumerator = [[self ruleContributers] objectEnumerator];
	id <BKRuleContributerProtocol> each;
	
	while (each = [enumerator nextObject]) {
		id <BKRuleViewControllerProtocol> result = [each createRuleViewControllerForPredicate:predicate];
		if (result) {
			[result filterPredicateOperatorsForFolderKind:[self folderKind]];
			return result;
		}
	}
	
	return nil;
}

- (NSPredicate *)createPredicateFromRuleViewController:(id <BKRuleViewControllerProtocol>)ruleViewController {
	NSString *ruleKey = [ruleViewController ruleKey];
	NSEnumerator *enumerator = [[self ruleContributers] objectEnumerator];
	id <BKRuleContributerProtocol> each;
	
	while (each = [enumerator nextObject]) {
		if ([[each ruleKeys] containsObject:ruleKey]) {
			return [each createPredicateFromRuleViewController:ruleViewController];
		}
	}
	
	return nil;
}

#pragma mark rules gui

- (NSMenu *)rulesMenu {
	NSMenu *rulesMenu = [[[NSMenu alloc] init] autorelease];
	NSEnumerator *enumerator = [[self ruleKeys] objectEnumerator];
	NSString *each;
	
	while (each = [enumerator nextObject]) {
		NSMenuItem *item = [[[NSMenuItem alloc] initWithTitle:[self ruleNameForKey:each] action:nil keyEquivalent:@""] autorelease];
		[item setRepresentedObject:each];
		[rulesMenu addItem:item];
	}
	
	[rulesMenu sortMenuItemsUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES]]];

	
	NSEnumerator *contributersEnumerator = [[self ruleContributers] objectEnumerator];
	id <BKRuleContributerProtocol> eachContributer;
		
	while (eachContributer = [contributersEnumerator nextObject]) {
		[eachContributer filterRulesMenu:rulesMenu folderKind:[self folderKind]];
	}
	
	return rulesMenu;
}

- (NSMenu *)sortDescriptorsMenu {
	NSMenu *sortDescriptorsMenu = [[[NSMenu alloc] init] autorelease];
	NSEnumerator *enumerator = [[self ruleKeys] objectEnumerator];
	NSString *each;
	
	while (each = [enumerator nextObject]) {
		NSString *sortDescriptorKey = [self sortDescriptorKeyForKey:each];
		if (sortDescriptorKey) {
			NSMenuItem *item = [[[NSMenuItem alloc] initWithTitle:[self ruleNameForKey:each] action:nil keyEquivalent:@""] autorelease];
			[item setRepresentedObject:sortDescriptorKey];
			[sortDescriptorsMenu addItem:item];
		}
	}
	
	[sortDescriptorsMenu sortMenuItemsUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES]]];
	
	return sortDescriptorsMenu;
}

- (void)updateLayout {
	NSWindow *window = [ruleEditorView window];
	NSRect newFrame = [window frame];
	float changeInHeight = [ruleEditorView updateLayoutReturningChangeInHeight];
	newFrame.origin.y -= changeInHeight;
	newFrame.size.height += changeInHeight;
	[window setFrame:newFrame display:YES animate:YES];
}

- (void)addRuleContainer:(BKRuleContainerController *)newRuleContainer after:(BKRuleContainerController *)ruleContainer {
	if (!ruleContainers) ruleContainers = [[NSMutableArray alloc] init];
	
	[newRuleContainer setRuleEditor:self];
	
	if ([ruleContainers indexOfObject:ruleContainer] != NSNotFound) {
		[ruleContainers insertObject:newRuleContainer atIndex:[ruleContainers indexOfObject:ruleContainer] + 1];
		[ruleEditorView addSubview:[newRuleContainer ruleContainerView] positioned:NSWindowAbove relativeTo:[ruleContainer ruleContainerView]];
	} else {
		[ruleContainers addObject:newRuleContainer];
		[ruleEditorView addSubview:[newRuleContainer ruleContainerView]];
	}

	[self updateLayout];
}

- (void)removeRuleContainer:(BKRuleContainerController *)oldRuleContainer {
	[oldRuleContainer setRuleEditor:nil];
	[[oldRuleContainer ruleContainerView] removeFromSuperview];
	[oldRuleContainer setRuleEditor:nil];
	[ruleContainers removeObject:oldRuleContainer];
	[self updateLayout];
}

- (int)numberOfRuleContainers {
	return [ruleContainers count];
}

#pragma mark actions

- (IBAction)cancel:(id)sender {
	[NSApp endSheet:[self window] returnCode:NSCancelButton];
}

- (IBAction)ok:(id)sender {
	if ([controller commitEditing]) {
		[NSApp endSheet:[self window] returnCode:NSOKButton];
	} else {
		NSBeep();
	}
}

@end