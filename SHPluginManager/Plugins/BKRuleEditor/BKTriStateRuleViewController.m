//
//  BKTriStateRuleViewController.m
//  Blocks
//
//  Created by Jesse Grosjean on 9/19/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "BKTriStateRuleViewController.h"


@implementation BKTriStateRuleViewController

- (id)init {
	if (self = [super init]) {
		[self view]; // load early
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
	
	switch ([predicateOperatorPopUpButton selectedTag]) {
		case NSOffState:
			return [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ = nil OR %@ = %i", templateLeftExpression, templateLeftExpression, NSOffState, nil]];
			
		case NSOnState:
			return [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ = %i", templateLeftExpression, NSOnState, nil]];
			
		case NSMixedState:
			return [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ = %i", templateLeftExpression, NSMixedState, nil]];
	}
	
	return nil;
}

- (void)setPredicate:(NSPredicate *)newPredicate {
	NSComparisonPredicate *comparisonPredicate = nil;
	
	if ([newPredicate isKindOfClass:[NSComparisonPredicate class]]) {
		comparisonPredicate = (NSComparisonPredicate *) newPredicate;
		logAssert([comparisonPredicate predicateOperatorType] == NSEqualToPredicateOperatorType, @"predicate type should always be NSEqualToPredicateOperatorType or NSNotEqualToPredicateOperatorType");
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
	
	[predicateOperatorPopUpButton selectItemWithTag:[[rightExpression constantValue] intValue]];
}

- (NSView *)view {
    if (!view) {
		if (![NSBundle loadNibNamed:@"BKTriStateRuleView" owner:self]) {
			logError((@"failed to load view"));
		} else {
			logInfo((@"loaded view"));
		}
		logAssert(view != nil, @"view != nil assert failed");
    }
    return view;
}

- (void)filterPredicateOperatorsForFolderKind:(NSString *)folderKind {
	if ([folderKind isEqualToString:@"uk.co.stevehooley.mori.tagfolder"]) {
		[predicateOperatorPopUpButton removeItemAtIndex:[predicateOperatorPopUpButton indexOfItemWithTag:NSMixedState]];			
	}
}

@end
