//
//  BKDateRuleViewController.m
//  Blocks
//
//  Created by Jesse Grosjean on 1/9/06.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKDateRuleViewController.h"


@implementation BKDateRuleViewController

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

- (void)awakeFromNib {
	[leftExpression1DatePicker setDateValue:[NSDate date]];
	[leftExpression2DatePicker setDateValue:[NSDate date]];
	[self predicateOperatorPopupButtonChanged:predicateOperatorPopupButton];
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
		case 1: { // is today
			NSPredicate *startRange = [NSComparisonPredicate predicateWithLeftExpression:templateLeftExpression rightExpression:[NSExpression expressionForVariable:NSPredicateStartOfDaySubstitutionVariable] modifier:NSDirectPredicateModifier type:NSGreaterThanOrEqualToPredicateOperatorType options:0];
			NSPredicate *endRange = [NSComparisonPredicate predicateWithLeftExpression:templateLeftExpression rightExpression:[NSExpression expressionForVariable:NSPredicateEndOfDaySubstitutionVariable] modifier:NSDirectPredicateModifier type:NSLessThanOrEqualToPredicateOperatorType options:0];
			return [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:startRange, endRange, nil]];
		}
			
		case 2: // is after today
			return [NSComparisonPredicate predicateWithLeftExpression:templateLeftExpression rightExpression:[NSExpression expressionForVariable:NSPredicateEndOfDaySubstitutionVariable] modifier:NSDirectPredicateModifier type:NSGreaterThanOrEqualToPredicateOperatorType options:0];
			
//		case 3: // is before today
//			return [NSComparisonPredicate predicateWithLeftExpression:templateLeftExpression rightExpression:[NSExpression expressionForVariable:NSPredicateStartOfDaySubstitutionVariable] modifier:NSDirectPredicateModifier type:NSLessThanPredicateOperatorType options:0];
			
		case 3: // is today or sooner
			return [NSComparisonPredicate predicateWithLeftExpression:templateLeftExpression rightExpression:[NSExpression expressionForVariable:NSPredicateEndOfDaySubstitutionVariable] modifier:NSDirectPredicateModifier type:NSLessThanPredicateOperatorType options:0];
						
		case 4: // is yesterday
			break;
			
		case 5: { // is this week
			NSPredicate *startRange = [NSComparisonPredicate predicateWithLeftExpression:templateLeftExpression rightExpression:[NSExpression expressionForVariable:NSPredicateStartOfWeekSubstitutionVariable] modifier:NSDirectPredicateModifier type:NSGreaterThanOrEqualToPredicateOperatorType options:0];
			NSPredicate *endRange = [NSComparisonPredicate predicateWithLeftExpression:templateLeftExpression rightExpression:[NSExpression expressionForVariable:NSPredicateEndOfWeekSubstitutionVariable] modifier:NSDirectPredicateModifier type:NSLessThanOrEqualToPredicateOperatorType options:0];
			return [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:startRange, endRange, nil]];
		}
			
		case 6: { // is last week
			NSPredicate *startRange = [NSComparisonPredicate predicateWithLeftExpression:templateLeftExpression rightExpression:[NSExpression expressionForVariable:NSPredicateStartOfLastWeekSubstitutionVariable] modifier:NSDirectPredicateModifier type:NSGreaterThanOrEqualToPredicateOperatorType options:0];
			NSPredicate *endRange = [NSComparisonPredicate predicateWithLeftExpression:templateLeftExpression rightExpression:[NSExpression expressionForVariable:NSPredicateEndOfLastWeekSubstitutionVariable] modifier:NSDirectPredicateModifier type:NSLessThanOrEqualToPredicateOperatorType options:0];
			return [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:startRange, endRange, nil]];
		}
			
		case 7: // is exactly, MUST REWRITE QUERY BEFORE EXECUTION
			return [NSComparisonPredicate predicateWithLeftExpression:templateLeftExpression rightExpression:[NSExpression expressionForVariable:[NSString stringWithFormat:@"BKIsExactly-%i-%i", [leftExpressionNumberPopupButton selectedTag], [leftExpressionNumberTextField intValue]]] modifier:NSDirectPredicateModifier type:NSEqualToPredicateOperatorType options:0];
			
		case 8: // is in the last, MUST REWRITE QUERY BEFORE EXECUTION
			return [NSComparisonPredicate predicateWithLeftExpression:templateLeftExpression rightExpression:[NSExpression expressionForVariable:[NSString stringWithFormat:@"BKIsInTheLast-%i-%i", [leftExpressionNumberPopupButton selectedTag], [leftExpressionNumberTextField intValue]]] modifier:NSDirectPredicateModifier type:NSEqualToPredicateOperatorType options:0];

		case 9: // is not in the last, MUST REWRITE QUERY BEFORE EXECUTION
			return [NSComparisonPredicate predicateWithLeftExpression:templateLeftExpression rightExpression:[NSExpression expressionForVariable:[NSString stringWithFormat:@"BKIsNotInTheLast-%i-%i", [leftExpressionNumberPopupButton selectedTag], [leftExpressionNumberTextField intValue]]] modifier:NSDirectPredicateModifier type:NSEqualToPredicateOperatorType options:0];

		case 10: // is in the next, MUST REWRITE QUERY BEFORE EXECUTION
			return [NSComparisonPredicate predicateWithLeftExpression:templateLeftExpression rightExpression:[NSExpression expressionForVariable:[NSString stringWithFormat:@"BKIsInTheNext-%i-%i", [leftExpressionNumberPopupButton selectedTag], [leftExpressionNumberTextField intValue]]] modifier:NSDirectPredicateModifier type:NSEqualToPredicateOperatorType options:0];
			
		case 11: // is not in the next, MUST REWRITE QUERY BEFORE EXECUTION
			return [NSComparisonPredicate predicateWithLeftExpression:templateLeftExpression rightExpression:[NSExpression expressionForVariable:[NSString stringWithFormat:@"BKIsNotInTheNext-%i-%i", [leftExpressionNumberPopupButton selectedTag], [leftExpressionNumberTextField intValue]]] modifier:NSDirectPredicateModifier type:NSEqualToPredicateOperatorType options:0];
			
		case 12: { // is the date
			NSPredicate *startRange = [NSComparisonPredicate predicateWithLeftExpression:templateLeftExpression rightExpression:[NSExpression expressionForConstantValue:[[leftExpression1DatePicker dateValue] startOf:BKDayInterval]] modifier:NSDirectPredicateModifier type:NSGreaterThanOrEqualToPredicateOperatorType options:0];
			NSPredicate *endRange = [NSComparisonPredicate predicateWithLeftExpression:templateLeftExpression rightExpression:[NSExpression expressionForConstantValue:[[leftExpression1DatePicker dateValue] endOf:BKDayInterval]] modifier:NSDirectPredicateModifier type:NSLessThanOrEqualToPredicateOperatorType options:0];
			return [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:startRange, endRange, nil]];
		}
			
		case 13: // is after the date
			return [NSComparisonPredicate predicateWithLeftExpression:templateLeftExpression rightExpression:[NSExpression expressionForConstantValue:[[leftExpression1DatePicker dateValue] endOf:BKDayInterval]] modifier:NSDirectPredicateModifier type:NSGreaterThanOrEqualToPredicateOperatorType options:0];
			
		case 14: // is before the date
			return [NSComparisonPredicate predicateWithLeftExpression:templateLeftExpression rightExpression:[NSExpression expressionForConstantValue:[[leftExpression1DatePicker dateValue] startOf:BKDayInterval]] modifier:NSDirectPredicateModifier type:NSLessThanOrEqualToPredicateOperatorType options:0];
			
		case 15: { // is in the date range
			NSPredicate *startRange = [NSComparisonPredicate predicateWithLeftExpression:templateLeftExpression rightExpression:[NSExpression expressionForConstantValue:[[leftExpression1DatePicker dateValue] startOf:BKDayInterval]] modifier:NSDirectPredicateModifier type:NSGreaterThanOrEqualToPredicateOperatorType options:0];
			NSPredicate *endRange = [NSComparisonPredicate predicateWithLeftExpression:templateLeftExpression rightExpression:[NSExpression expressionForConstantValue:[[leftExpression2DatePicker dateValue] endOf:BKDayInterval]] modifier:NSDirectPredicateModifier type:NSLessThanOrEqualToPredicateOperatorType options:0];
			return [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:startRange, endRange, nil]];
		}

		case 16: // is any date
			return [NSComparisonPredicate predicateWithLeftExpression:templateLeftExpression rightExpression:[NSExpression expressionForConstantValue:[NSNull null]] modifier:NSDirectPredicateModifier type:NSNotEqualToPredicateOperatorType options:0];
			
		case 17: // has no value
			return [NSComparisonPredicate predicateWithLeftExpression:templateLeftExpression rightExpression:[NSExpression expressionForConstantValue:[NSNull null]] modifier:NSDirectPredicateModifier type:NSEqualToPredicateOperatorType options:0];
			
		default:
			break;
	}
	
	return nil;
}

- (void)setPredicate:(NSPredicate *)newPredicate {
	BOOL isNOTCase = NO;
	
	if ([newPredicate isKindOfClass:[NSComparisonPredicate class]]) {
		NSComparisonPredicate *comparisonPredicate = (NSComparisonPredicate *) newPredicate;
		NSExpression *leftExpression = [comparisonPredicate leftExpression];
		NSExpression *rightExpression = [comparisonPredicate rightExpression];

		if ([rightExpression expressionType] == NSVariableExpressionType) {
			NSString *variable = [rightExpression variable];
			BOOL isExactly = [variable rangeOfString:@"BKIsExactly"].location != NSNotFound;
			BOOL isInTheLast = [variable rangeOfString:@"BKIsInTheLast"].location != NSNotFound;
			BOOL isNotInTheLast = [variable rangeOfString:@"BKIsNotInTheLast"].location != NSNotFound;
			BOOL isInTheNext = [variable rangeOfString:@"BKIsInTheNext"].location != NSNotFound;
			BOOL isNotInTheNext = [variable rangeOfString:@"BKIsNotInTheNext"].location != NSNotFound;
			
			if (isExactly || isInTheLast || isNotInTheLast || isInTheNext || isNotInTheNext) {
				NSArray *variableComponents = [variable componentsSeparatedByString:@"-"];
				
				[leftExpressionNumberPopupButton selectItemWithTag:[[variableComponents objectAtIndex:1] intValue]];
				[leftExpressionNumberTextField setIntValue:[[variableComponents objectAtIndex:2] intValue]];
				
				if (isExactly) {
					[predicateOperatorPopupButton selectItemWithTag:7]; // is exactly
				} else if (isInTheLast) {
					[predicateOperatorPopupButton selectItemWithTag:8]; // is in the last
				} else if (isNotInTheLast) {
					[predicateOperatorPopupButton selectItemWithTag:9]; // is not in the last
				} else if (isInTheNext) {
					[predicateOperatorPopupButton selectItemWithTag:10]; // is in the next
				} else if (isNotInTheNext) {
					[predicateOperatorPopupButton selectItemWithTag:11]; // is not in the next
				}
			} else {
				if ([comparisonPredicate predicateOperatorType] == NSGreaterThanOrEqualToPredicateOperatorType) {
					[predicateOperatorPopupButton selectItemWithTag:2]; // after today
				} else {
					[predicateOperatorPopupButton selectItemWithTag:3]; // before end of today
				}
			}
		} else if ([rightExpression expressionType] == NSConstantValueExpressionType) {
			if ([rightExpression constantValue] == [NSNull null] && [comparisonPredicate predicateOperatorType] == NSNotEqualToPredicateOperatorType) {
				[predicateOperatorPopupButton selectItemWithTag:16]; // is any date
			} else if ([rightExpression constantValue] == [NSNull null] && [comparisonPredicate predicateOperatorType] == NSEqualToPredicateOperatorType) {
				[predicateOperatorPopupButton selectItemWithTag:17]; // has no value
			} else if ([comparisonPredicate predicateOperatorType] == NSGreaterThanOrEqualToPredicateOperatorType) {
				[predicateOperatorPopupButton selectItemWithTag:13]; // is after the date
			} else {
				[predicateOperatorPopupButton selectItemWithTag:14]; // is before the date
			}
			[leftExpression1DatePicker setDateValue:[rightExpression constantValue]];
		} else if ([rightExpression constantValue] == [NSNull null]) {
			if ([comparisonPredicate predicateOperatorType] == NSNotEqualToPredicateOperatorType) {
				[predicateOperatorPopupButton selectItemWithTag:16]; // is any date
			} else {
				[predicateOperatorPopupButton selectItemWithTag:17]; // has no value
			}
		} else {
			logError(@"bad expression type");
			return;
		}
		
		[templateLeftExpression autorelease];
		templateLeftExpression = [leftExpression retain];
	} else if ([newPredicate isKindOfClass:[NSCompoundPredicate class]]) {
		NSCompoundPredicate *compoundPredicate = (NSCompoundPredicate *) newPredicate;
		NSComparisonPredicate *startRange = [[compoundPredicate subpredicates] objectAtIndex:0];
		NSComparisonPredicate *endRange = [[compoundPredicate subpredicates] objectAtIndex:1];
		NSExpression *startRightExpression = [startRange rightExpression];
		NSExpression *startLeftExpression = [startRange leftExpression];
		NSExpression *endRightExpression = [endRange rightExpression];
		NSExpression *endLeftExpression = [endRange leftExpression];
		
		if ([startRightExpression expressionType] == NSVariableExpressionType) {
			if ([[startRightExpression variable] isEqualToString:NSPredicateStartOfDaySubstitutionVariable]) {
				[predicateOperatorPopupButton selectItemWithTag:1]; // is today
			} else if ([[startRightExpression variable] isEqualToString:NSPredicateStartOfWeekSubstitutionVariable]) {
				[predicateOperatorPopupButton selectItemWithTag:5]; // is this week
			} else {
				[predicateOperatorPopupButton selectItemWithTag:6]; // is last week
			}
		} else {
			NSDate *startDate = [startRightExpression constantValue];
			NSDate *endDate = [endRightExpression constantValue];

			if ([endDate timeIntervalSinceDate:startDate] < (60 * 60 * 24)) {
				[predicateOperatorPopupButton selectItemWithTag:12]; // is the date
			} else {
				[predicateOperatorPopupButton selectItemWithTag:15]; // is in the date range
			}

			[leftExpression1DatePicker setDateValue:startDate];
			[leftExpression2DatePicker setDateValue:endDate];
		}

		[templateLeftExpression autorelease];
		templateLeftExpression = [startLeftExpression retain];
	} else {
		logError(@"wrong predicate class");
		return;
	}
	
	[self predicateOperatorPopupButtonChanged:predicateOperatorPopupButton];
}

- (NSView *)view {
    if (!view) {
		if (![NSBundle loadNibNamed:@"BKDateRuleView" owner:self]) {
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
	if (selectedTag <= 6 || selectedTag >= 16) {
		[leftExpression1DatePicker setHidden:YES];
		[toTextField setHidden:YES];
		[leftExpression2DatePicker setHidden:YES];
		[leftExpressionNumberTextField setHidden:YES];
		[leftExpressionNumberPopupButton setHidden:YES];
		[agoTextField setHidden:YES];
	} else if (selectedTag >= 7 && selectedTag <= 11) {
		[leftExpression1DatePicker setHidden:YES];
		[toTextField setHidden:YES];
		[leftExpression2DatePicker setHidden:YES];
		[leftExpressionNumberTextField setHidden:NO];
		[leftExpressionNumberPopupButton setHidden:NO];
		if (selectedTag == 7) {
			[agoTextField setHidden:NO];
		} else {
			[agoTextField setHidden:YES];
		}
	} else if (selectedTag >= 12 && selectedTag <= 14) {
		[leftExpression1DatePicker setHidden:NO];
		[toTextField setHidden:YES];
		[leftExpression2DatePicker setHidden:YES];
		[leftExpressionNumberTextField setHidden:YES];
		[leftExpressionNumberPopupButton setHidden:YES];
		[agoTextField setHidden:YES];
	} else if (selectedTag < 16) {
		[leftExpression1DatePicker setHidden:NO];
		[toTextField setHidden:NO];
		[leftExpression2DatePicker setHidden:NO];
		[leftExpressionNumberTextField setHidden:YES];
		[leftExpressionNumberPopupButton setHidden:YES];
		[agoTextField setHidden:YES];
	}
}

- (void)filterPredicateOperatorsForFolderKind:(NSString *)folderKind {
	if ([folderKind isEqualToString:@"uk.co.stevehooley.mori.tagfolder"]) {
		
	}
}

@end
