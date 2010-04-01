//
//  BKStringRuleViewController.m
//  Blocks
//
//  Created by Jesse Grosjean on 1/8/06.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKStringRuleViewController.h"


@implementation BKStringRuleViewController

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
	
	int selectedTag = [predicateOperatorPopupButton selectedTag];
	id rightExpressionString = [rightExpressionTextField stringValue];
	NSPredicateOperatorType predicateOperatorType;
	
	switch (selectedTag) {
		case 1: // contains
		case 2: // does not contain
			rightExpressionString = [NSString stringWithFormat:@"*%@*", rightExpressionString];
			predicateOperatorType = NSLikePredicateOperatorType;
			break;
			
			// XXX should be using NSInPredicateOperatorType in this case but for some reason it doesn't seem to work
			// once the context has been saved. I'm not sure why this is, but my guess is that it's because we are searching
			// over a keypath instead of searching the entry data entity directly. and coredata doesn't seem to like that.
//			rightExpressionString = [NSString stringWithFormat:@"%@", rightExpressionString];
//			predicateOperatorType = NSInPredicateOperatorType;
//			break;
			
		case 3: // is equal to
			predicateOperatorType = NSEqualToPredicateOperatorType;
			break;

		case 4: // begins with
			predicateOperatorType = NSBeginsWithPredicateOperatorType;
			break;
			
		case 5: // ends with
			predicateOperatorType = NSEndsWithPredicateOperatorType;
			break;

		case 6: // any text, does not equal nil
			return [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ != nil AND %@ != ''", templateLeftExpression, templateLeftExpression, nil]];

//			predicateOperatorType = NSNotEqualToPredicateOperatorType;
//			rightExpressionString = [NSNull null];
//			break;

		case 7: // no text, equal to nil
			return [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ == nil OR %@ == ''", templateLeftExpression, templateLeftExpression, nil]];

//			predicateOperatorType = NSEqualToPredicateOperatorType;
//			rightExpressionString = [NSNull null];
//			break;
			
		default:
			break;
	}
	
	NSPredicate *predicate = nil;
	
	if (predicateOperatorType == NSInPredicateOperatorType) {
		predicate = [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForConstantValue:rightExpressionString]
													   rightExpression:templateLeftExpression
															  modifier:NSDirectPredicateModifier
																  type:predicateOperatorType
															   options:NSCaseInsensitivePredicateOption | NSDiacriticInsensitivePredicateOption];
	} else {
		predicate = [NSComparisonPredicate predicateWithLeftExpression:templateLeftExpression
										   rightExpression:[NSExpression expressionForConstantValue:rightExpressionString]
												  modifier:NSDirectPredicateModifier
													  type:predicateOperatorType
												   options:NSCaseInsensitivePredicateOption | NSDiacriticInsensitivePredicateOption];
	}
	
	
	if (selectedTag == 2) {
		return [NSCompoundPredicate notPredicateWithSubpredicate:predicate];
	} else {
		return predicate;
	}
}

- (void)setPredicate:(NSPredicate *)newPredicate {
	BOOL isNOTCase = NO;
	BOOL isAnyCase = NO;
	BOOL isNoCase = NO;

	// handle compound cases
	if ([newPredicate isKindOfClass:[NSCompoundPredicate class]]) {
		NSCompoundPredicate *compoundPredicate = (NSCompoundPredicate *) newPredicate;
		
		if ([compoundPredicate compoundPredicateType] == NSNotPredicateType) { // not case
			logAssert([[compoundPredicate subpredicates] count] == 1, @"");
			isNOTCase = YES;
			newPredicate = [[compoundPredicate subpredicates] lastObject];
		} else if ([compoundPredicate compoundPredicateType] == NSAndPredicateType) { // any text case
			isAnyCase = YES;
		} else if ([compoundPredicate compoundPredicateType] == NSOrPredicateType) { // no text case
			isNoCase = YES;
		}
	}
	
	if ([newPredicate isKindOfClass:[NSComparisonPredicate class]]) {
		NSComparisonPredicate *comparisonPredicate = (NSComparisonPredicate *) newPredicate;
		NSExpression *leftExpression = [comparisonPredicate leftExpression];
		NSExpression *rightExpression = [comparisonPredicate rightExpression];
		id rightExpressionString = nil;
		
		if ([comparisonPredicate predicateOperatorType] == NSInPredicateOperatorType) {
			rightExpressionString = [leftExpression constantValue];
		} else {
			rightExpressionString = [rightExpression constantValue];	
		}
		
		[templateLeftExpression autorelease];
		templateLeftExpression = [leftExpression retain];
		
		switch ([comparisonPredicate predicateOperatorType]) {
			case NSLikePredicateOperatorType:
				if (isNOTCase) {
					[predicateOperatorPopupButton selectItemWithTag:2]; // does not contain
				} else {
					[predicateOperatorPopupButton selectItemWithTag:1]; // contains
				}

				NSRange range = NSMakeRange(0, [rightExpressionString length]);

				if (range.length > 0 && [rightExpressionString characterAtIndex:0] == '*') {
					range.location++;
					range.length--;
				}

				if (range.length > 0 && [rightExpressionString characterAtIndex:[rightExpressionString length] - 1] == '*') {
					range.length--;
				}

				rightExpressionString = [rightExpressionString substringWithRange:range];
				
				break;

			case NSEqualToPredicateOperatorType:
				if (rightExpressionString != [NSNull null]) {
					[predicateOperatorPopupButton selectItemWithTag:3]; // is equal to
				} else {
					[predicateOperatorPopupButton selectItemWithTag:7]; // no text, equal to nil
				}
				break;

			case NSNotEqualToPredicateOperatorType:
				[predicateOperatorPopupButton selectItemWithTag:6]; // any text, does not equal nil
				break;

			case NSBeginsWithPredicateOperatorType:
				[predicateOperatorPopupButton selectItemWithTag:4]; // begins with
				break;
				
			case NSEndsWithPredicateOperatorType:
				[predicateOperatorPopupButton selectItemWithTag:5]; // ends with
				break;
				
			default:
				logError(@"unsupported predicate operator");
				break;
		}

		if ([rightExpressionString isKindOfClass:[NSString class]]) {
			[rightExpressionTextField setStringValue:rightExpressionString];
		} else {
			[rightExpressionTextField setStringValue:@""];
		}
	} else if (isAnyCase) {
		[templateLeftExpression autorelease];
		templateLeftExpression = [[[[(NSCompoundPredicate *)newPredicate subpredicates] lastObject] leftExpression] retain];
		[predicateOperatorPopupButton selectItemWithTag:6]; // any text, does not equal nil
	} else if (isNoCase) {
		[templateLeftExpression autorelease];
		templateLeftExpression = [[[[(NSCompoundPredicate *)newPredicate subpredicates] lastObject] leftExpression] retain];
		[predicateOperatorPopupButton selectItemWithTag:7]; // no text, equal to nil
	} else {
		[templateLeftExpression release];
		templateLeftExpression = nil;
		logError(@"unsupported predicate type");
	}
	
	[self predicateOperatorPopupButtonChanged:nil];
}

- (NSView *)view {
    if (!view) {
		if (![NSBundle loadNibNamed:@"BKStringRuleView" owner:self]) {
			logError((@"failed to load view"));
		} else {
			logInfo((@"loaded view"));
		}
		logAssert(view != nil, @"view != nil assert failed");
    }
    return view;
}

- (IBAction)predicateOperatorPopupButtonChanged:(id)sender {
	int selectedTag = [predicateOperatorPopupButton selectedTag];
	if (selectedTag == 6 || selectedTag == 7) {
		[rightExpressionTextField setHidden:YES];
	} else {
		[rightExpressionTextField setHidden:NO];
	}
}

- (void)filterPredicateOperatorsForFolderKind:(NSString *)folderKind {
	if ([folderKind isEqualToString:@"uk.co.stevehooley.mori.tagfolder"]) {
		
	}
}

@end
