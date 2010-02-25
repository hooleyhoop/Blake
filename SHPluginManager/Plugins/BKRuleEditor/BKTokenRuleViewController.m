//
//  BKTokenRuleViewController.m
//  Blocks
//
//  Created by Jesse Grosjean on 2/11/06.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKTokenRuleViewController.h"


@implementation BKTokenRuleViewController

- (id)init {
	if (self = [super init]) {
		[self view]; // load early
	}
	return self;
}

- (void)dealloc {
	[ruleKey release];
	[templateLeftExpression release];
	[completions release];
	[super dealloc];
}

- (NSString *)ruleKey {
	return ruleKey;
}

- (void)setRuleKey:(NSString *)newRuleKey {
	[ruleKey autorelease];
	ruleKey = [newRuleKey retain];
}

- (NSPredicate *)predicate {
	if (!templateLeftExpression) {
		logError(@"templateLeftExpression not set.");
		return nil;
	}
	
	int selectedTag = [predicateOperatorPopupButton selectedTag];
	NSArray *rightExpressionArray = [rightExpressionTokenField objectValue];
	NSPredicateOperatorType predicateOperatorType;
	
	switch (selectedTag) {
		case 1: // contains all
			return [NSComparisonPredicate predicateWithLeftExpression:templateLeftExpression rightExpression:[NSExpression expressionForConstantValue:rightExpressionArray] modifier:NSAllPredicateModifier type:NSInPredicateOperatorType options:0];

		case 2: // contains any
			return [NSComparisonPredicate predicateWithLeftExpression:templateLeftExpression rightExpression:[NSExpression expressionForConstantValue:rightExpressionArray] modifier:NSAnyPredicateModifier type:NSInPredicateOperatorType options:0];
			
		case 3: { // does not contain all
			NSPredicate *comparisonPredicate = [NSComparisonPredicate predicateWithLeftExpression:templateLeftExpression rightExpression:[NSExpression expressionForConstantValue:rightExpressionArray] modifier:NSAllPredicateModifier type:NSInPredicateOperatorType options:0];
			return [NSCompoundPredicate notPredicateWithSubpredicate:comparisonPredicate];
		}
			
		case 4: { // does not contain any
			NSPredicate *comparisonPredicate = [NSComparisonPredicate predicateWithLeftExpression:templateLeftExpression rightExpression:[NSExpression expressionForConstantValue:rightExpressionArray] modifier:NSAnyPredicateModifier type:NSInPredicateOperatorType options:0];
			return [NSCompoundPredicate notPredicateWithSubpredicate:comparisonPredicate];
		}
			
		default:
			break;
	}
	
	return nil;
}

- (void)setPredicate:(NSPredicate *)newPredicate {
	NSComparisonPredicate *comparisonPredicate = nil;
	BOOL isNotCase = NO;
	
	if ([newPredicate isKindOfClass:[NSComparisonPredicate class]]) {
		comparisonPredicate = (NSComparisonPredicate *) newPredicate;
		logAssert([comparisonPredicate predicateOperatorType] == NSInPredicateOperatorType, @"predicate type should always be NSInPredicateOperatorType");
		logAssert([comparisonPredicate comparisonPredicateModifier] == NSAllPredicateModifier || [comparisonPredicate comparisonPredicateModifier] == NSAnyPredicateModifier, @"predicate modifier should always be NSAllPredicateModifier or NSAnyPredicateModifier");
	} else if ([newPredicate isKindOfClass:[NSCompoundPredicate class]]) {
		NSCompoundPredicate *compoundPredicate = (NSCompoundPredicate *) newPredicate;
		logAssert([compoundPredicate compoundPredicateType] == NSNotPredicateType, @"only expect NOT types because that's what is created in above predicate method");
		logAssert([[[compoundPredicate subpredicates] lastObject] isKindOfClass:[NSComparisonPredicate class]], @"only expect comparison predicate because that's what is created in above predicate method");
		comparisonPredicate = [[compoundPredicate subpredicates] lastObject];
		isNotCase = YES;
	} else {
		[templateLeftExpression release];
		templateLeftExpression = nil;
		logError(@"unsupported predicate type");
	}
	
	NSExpression *leftExpression = [comparisonPredicate leftExpression];
	NSExpression *rightExpression = [comparisonPredicate rightExpression];
	
	[templateLeftExpression autorelease];
	templateLeftExpression = [leftExpression retain];
	
	[rightExpressionTokenField setObjectValue:[rightExpression constantValue]];
	
	if ([comparisonPredicate comparisonPredicateModifier] == NSAllPredicateModifier) {
		if (isNotCase) {
			[predicateOperatorPopupButton selectItemWithTag:3]; // does not contain all			
		} else {
			[predicateOperatorPopupButton selectItemWithTag:1]; // contains all
		}
	} else if ([comparisonPredicate comparisonPredicateModifier] == NSAnyPredicateModifier) {
		if (isNotCase) {
			[predicateOperatorPopupButton selectItemWithTag:4]; // does not contains any						
		} else {
			[predicateOperatorPopupButton selectItemWithTag:2]; // contains any			
		}
	} else {
		logError(@"unsupported predicate type");
	}
}

- (NSView *)view {
    if (!view) {
		if (![NSBundle loadNibNamed:@"BKTokenRuleView" owner:self]) {
			logError((@"failed to load view"));
		} else {
			logInfo((@"loaded view"));
		}
		logAssert(view != nil, @"view != nil assert failed");
		
		[[rightExpressionTokenField cell] setPlaceholderString:BKLocalizedString(@"Use ',' to separate items", nil)];
    }
    return view;
}

- (NSArray *)completions {
	return completions;
}

- (void)setCompletions:(NSArray *)newCompletions {
	[completions autorelease];
	completions = [newCompletions retain];
}

#pragma mark token delegate

- (NSArray *)tokenField:(NSTokenField *)tokenField completionsForSubstring:(NSString *)substring indexOfToken:(int)tokenIndex indexOfSelectedItem:(int *)selectedIndex {
	return [completions filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self beginswith %@", substring]];
}

- (void)filterPredicateOperatorsForFolderKind:(NSString *)folderKind {
	if ([folderKind isEqualToString:@"uk.co.stevehooley.mori.tagfolder"]) {
		[predicateOperatorPopupButton removeItemAtIndex:[predicateOperatorPopupButton indexOfItemWithTag:2]];		
		[predicateOperatorPopupButton removeItemAtIndex:[predicateOperatorPopupButton indexOfItemWithTag:3]];		
	}
}

@end
