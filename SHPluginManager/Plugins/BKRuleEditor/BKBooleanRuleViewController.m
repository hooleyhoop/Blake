//
//  BKBooleanRuleViewController.m
//  Blocks
//
//  Created by Jesse Grosjean on 2/10/06.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKBooleanRuleViewController.h"


@implementation BKBooleanRuleViewController

- (id)init {
	if (self = [super init]) {
		[self view]; // load early
		[self predicateOperatorPopupButtonChanged:predicateOperatorPopupButton];
	}
	return self;
}

- (void)dealloc {
	[ruleKey release];
	[templateLeftExpression release];
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
	
	switch (selectedTag) {
		case 0: // false
			return [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ = nil OR %@ = NO", templateLeftExpression, templateLeftExpression, nil]];
			
		case 1: // true
			return [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ = YES", templateLeftExpression, nil]];
			
		case 2: // is any value
			return [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ != nil", templateLeftExpression, nil]];

		case 3: // is not set
			return [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ = nil", templateLeftExpression, nil]];
	}
	
	return nil;
}

- (void)setPredicate:(NSPredicate *)newPredicate {
	NSComparisonPredicate *comparisonPredicate = nil;
	
	if ([newPredicate isKindOfClass:[NSComparisonPredicate class]]) {
		comparisonPredicate = (NSComparisonPredicate *) newPredicate;
		logAssert([comparisonPredicate predicateOperatorType] == NSEqualToPredicateOperatorType || [comparisonPredicate predicateOperatorType] == NSNotEqualToPredicateOperatorType, @"predicate type should always be NSEqualToPredicateOperatorType or NSNotEqualToPredicateOperatorType");
	} else if ([newPredicate isKindOfClass:[NSCompoundPredicate class]]) {
		NSCompoundPredicate *compoundPredicate = (NSCompoundPredicate *) newPredicate;
		logAssert([compoundPredicate compoundPredicateType] == NSOrPredicateType, @"only expect OR types because that's what is created in above predicate method");
		logAssert([[[compoundPredicate subpredicates] lastObject] isKindOfClass:[NSComparisonPredicate class]], @"only expect comparison predicate because that's what is created in above predicate method");
		comparisonPredicate = [[compoundPredicate subpredicates] lastObject];
	} else {
		[templateLeftExpression release];
		templateLeftExpression = nil;
		logError(@"unsupported predicate type");
	}
	
	NSExpression *leftExpression = [comparisonPredicate leftExpression];
	NSExpression *rightExpression = [comparisonPredicate rightExpression];
	
	[templateLeftExpression autorelease];
	templateLeftExpression = [leftExpression retain];

	if ([rightExpression constantValue] == [NSNull null]) {
		if ([comparisonPredicate predicateOperatorType] == NSNotEqualToPredicateOperatorType) {
			[predicateOperatorPopupButton selectItemWithTag:2]; // is any value
		} else {
			[predicateOperatorPopupButton selectItemWithTag:3]; // is not set
		}
	} else if ([[rightExpression constantValue] boolValue]) {
		[predicateOperatorPopupButton selectItemWithTag:1]; // true
	} else {
		[predicateOperatorPopupButton selectItemWithTag:0]; // false
	}
	
	[self predicateOperatorPopupButtonChanged:predicateOperatorPopupButton];
}

- (NSView *)view {
    if (!view) {
		if (![NSBundle loadNibNamed:@"BKBooleanRuleView" owner:self]) {
			logError((@"failed to load view"));
		} else {
			logInfo((@"loaded view"));
		}
		logAssert(view != nil, @"view != nil assert failed");
    }
    return view;
}

- (IBAction)predicateOperatorPopupButtonChanged:(id)sender {
}

- (void)filterPredicateOperatorsForFolderKind:(NSString *)folderKind {
	if ([folderKind isEqualToString:@"uk.co.stevehooley.mori.tagfolder"]) {
		[predicateOperatorPopupButton removeItemAtIndex:[predicateOperatorPopupButton indexOfItemWithTag:2]];
		[predicateOperatorPopupButton removeItemAtIndex:[predicateOperatorPopupButton indexOfItemWithTag:3]];
		[predicateOperatorPopupButton removeItemAtIndex:2]; // remove separator.
	}
}

@end
