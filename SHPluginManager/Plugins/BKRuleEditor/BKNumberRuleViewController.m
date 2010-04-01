//
//  BKNumberRuleViewController.m
//  Blocks
//
//  Created by Jesse Grosjean on 1/9/06.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKNumberRuleViewController.h"


@implementation BKNumberRuleViewController

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
	[prototypePrototypeExpressionControl release];
	[rightExpression1Control release]; // speicial case, see setPrototypeExpressionControl
	[rightExpression2Control release]; // speicial case, see setPrototypeExpressionControl
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

	id rightExpression1 = [rightExpression1Control objectValue];
	id rightExpression2 = [rightExpression2Control objectValue];

	if ([prototypePrototypeExpressionControl isKindOfClass:[NSPopUpButton class]]) {
		rightExpression1 = [[(NSPopUpButton *)rightExpression1Control selectedItem] representedObject];
		rightExpression2 = [[(NSPopUpButton *)rightExpression2Control selectedItem] representedObject];
	}
	
	if (!rightExpression1) rightExpression1 = [NSNumber numberWithInt:0];
	if (!rightExpression2) rightExpression2 = [NSNumber numberWithInt:0];
	
	int selectedTag = [predicateOperatorPopupButton selectedTag];
	NSPredicateOperatorType predicateOperatorType;
	BOOL between = NO;
	
	switch (selectedTag) {
		case 1: // is
			predicateOperatorType = NSEqualToPredicateOperatorType;
			break;
		
		case 2: // is not
			predicateOperatorType = NSNotEqualToPredicateOperatorType;
			break;
		
		case 3: // is greater than
			predicateOperatorType = NSGreaterThanPredicateOperatorType;
			break;
		
		case 4: // is less than
			predicateOperatorType = NSLessThanPredicateOperatorType;
			break;

		case 5: // is in the range
			between = YES;
			break;

		case 6: // is any number
			predicateOperatorType = NSNotEqualToPredicateOperatorType;
			rightExpression1 = [NSNull null];
			break;

		case 7: // has no value
			predicateOperatorType = NSEqualToPredicateOperatorType;
			rightExpression1 = [NSNull null];
			break;
			
		default:
			break;
	}
		
	if (between) {
		NSPredicate *predicate1 = [NSComparisonPredicate predicateWithLeftExpression:templateLeftExpression
																	 rightExpression:[NSExpression expressionForConstantValue:rightExpression1]
																			modifier:NSDirectPredicateModifier
																				type:NSGreaterThanOrEqualToPredicateOperatorType
																			 options:0];		
		NSPredicate *predicate2 = [NSComparisonPredicate predicateWithLeftExpression:templateLeftExpression
																	 rightExpression:[NSExpression expressionForConstantValue:rightExpression2]
																			modifier:NSDirectPredicateModifier
																				type:NSLessThanOrEqualToPredicateOperatorType
																			 options:0];
		return [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:predicate1, predicate2, nil]];
	} else {
		if (predicateOperatorType == NSNotEqualToPredicateOperatorType) {
			// != is a special case for coredata sql stores. once the store is saved then != value will not match null fields, so to work
			// around this problem we add an explicity null matching predicate to != value predicates.
			NSPredicate *predicate = [NSComparisonPredicate predicateWithLeftExpression:templateLeftExpression
													  rightExpression:[NSExpression expressionForConstantValue:rightExpression1]
															 modifier:NSDirectPredicateModifier
																 type:predicateOperatorType
															  options:0];
			NSPredicate *includeNulls = [NSComparisonPredicate predicateWithLeftExpression:templateLeftExpression
																		 rightExpression:[NSExpression expressionForConstantValue:[NSNull null]]
																				modifier:NSDirectPredicateModifier
																					type:NSEqualToPredicateOperatorType
																				 options:0];
			return [NSCompoundPredicate orPredicateWithSubpredicates:[NSArray arrayWithObjects:includeNulls, predicate, nil]];
		} else {
			return [NSComparisonPredicate predicateWithLeftExpression:templateLeftExpression
													  rightExpression:[NSExpression expressionForConstantValue:rightExpression1]
															 modifier:NSDirectPredicateModifier
																 type:predicateOperatorType
															  options:0];	
		}
	}
}

- (void)setPredicate:(NSPredicate *)newPredicate {
	NSComparisonPredicate *comparisonPredicate1 = nil;
	NSComparisonPredicate *comparisonPredicate2 = nil;
	
	// handle between case
	if ([newPredicate isKindOfClass:[NSCompoundPredicate class]]) {
		NSCompoundPredicate *compoundPredicate = (NSCompoundPredicate *) newPredicate;
		if ([compoundPredicate compoundPredicateType] == NSAndPredicateType) {
			logAssert([[compoundPredicate subpredicates] count] == 2, @"");
			comparisonPredicate1 = [[compoundPredicate subpredicates] objectAtIndex:0];
			comparisonPredicate2 = [[compoundPredicate subpredicates] objectAtIndex:1];
		} else if ([compoundPredicate compoundPredicateType] == NSOrPredicateType) {
			// handle != special case by just extracting the second predicate and ignore the match null predicate since it will be recreated
			// when the new predicate is created.
			comparisonPredicate1 = [[compoundPredicate subpredicates] objectAtIndex:1];
		}
	} else if ([newPredicate isKindOfClass:[NSComparisonPredicate class]]) {
		comparisonPredicate1 = (NSComparisonPredicate *) newPredicate;
	} else {
		[templateLeftExpression release];
		templateLeftExpression = nil;
		logError(@"unsupported predicate type");
	}
	
	NSExpression *leftExpression1 = [comparisonPredicate1 leftExpression];
	NSExpression *rightExpression1 = [comparisonPredicate1 rightExpression];
	NSExpression *leftExpression2 = [comparisonPredicate2 leftExpression];
	NSExpression *rightExpression2 = [comparisonPredicate2 rightExpression];
	
	id rightExpression1ConstantValue = [rightExpression1 constantValue];
	id rightExpression2ConstantValue = [rightExpression2 constantValue];
	
	[templateLeftExpression autorelease];
	templateLeftExpression = [leftExpression1 retain];
		
	switch ([comparisonPredicate1 predicateOperatorType]) {
		case NSEqualToPredicateOperatorType:
			if (rightExpression1ConstantValue != [NSNull null]) {
				[predicateOperatorPopupButton selectItemWithTag:1]; // is
			} else {
				[predicateOperatorPopupButton selectItemWithTag:7]; // has no value
			}
			break;
			
		case NSNotEqualToPredicateOperatorType:
			if (rightExpression1ConstantValue != [NSNull null]) {
				[predicateOperatorPopupButton selectItemWithTag:2]; // is not
			} else {
				[predicateOperatorPopupButton selectItemWithTag:6]; // is any number
			}			
			break;
			
		case NSGreaterThanPredicateOperatorType:
			[predicateOperatorPopupButton selectItemWithTag:3]; // is greater than
			break;
			
		case NSLessThanPredicateOperatorType:
			[predicateOperatorPopupButton selectItemWithTag:4]; // is less than
			break;

		case NSLessThanOrEqualToPredicateOperatorType:
		case NSGreaterThanOrEqualToPredicateOperatorType:
			break;
			
		default:
			logError(@"unsupported predicate operator");
			break;
	}
	
	if ([prototypePrototypeExpressionControl isKindOfClass:[NSPopUpButton class]]) {
		[(NSPopUpButton *)rightExpression1Control selectItemWithRepresentedObject:rightExpression1ConstantValue];
		[(NSPopUpButton *)rightExpression2Control selectItemWithRepresentedObject:rightExpression2ConstantValue];
	} else {
		[rightExpression1Control setObjectValue:rightExpression1ConstantValue];
		[rightExpression2Control setObjectValue:rightExpression2ConstantValue];
	}
	
	
	if (comparisonPredicate2 != nil) {
		[predicateOperatorPopupButton selectItemWithTag:5]; // is in the range
	}
	
	[self predicateOperatorPopupButtonChanged:predicateOperatorPopupButton];
}

- (NSView *)view {
	if (!view) {
		if (![NSBundle loadNibNamed:@"BKNumberRuleView" owner:self]) {
			logError((@"failed to load view"));
		} else {
			logInfo((@"loaded view"));
		}
		logAssert(view != nil, @"view != nil assert failed");
		
		[rightExpression1Control retain]; // speicial case, see setPrototypeExpressionControl
		[rightExpression2Control retain]; // speicial case, see setPrototypeExpressionControl
		
		NSNumberFormatter *numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
		[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	}
	
	return view;
}

- (NSControl *)prototypePrototypeExpressionControl {
	return prototypePrototypeExpressionControl;
}

- (void)setPrototypeExpressionControl:(NSControl *)newPrototypeExpressionControl {
	[prototypePrototypeExpressionControl autorelease];
	prototypePrototypeExpressionControl = [newPrototypeExpressionControl retain];
	
	if (prototypePrototypeExpressionControl) {
		NSView *parentView = [rightExpression1Control superview];
		NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:prototypePrototypeExpressionControl];
		NSControl *newRightExpression1Control = [NSKeyedUnarchiver unarchiveObjectWithData:archiveData];
		NSControl *newRightExpression2Control = [NSKeyedUnarchiver unarchiveObjectWithData:archiveData];
		
		[newRightExpression1Control setFrame:[rightExpression1Control frame]];
		[newRightExpression2Control setFrame:[rightExpression2Control frame]];
		
		//[parentView addSubview:newRightExpression1Control positioned:NSWindowAbove relativeTo:rightExpression1Control];
		//[parentView addSubview:newRightExpression2Control positioned:NSWindowAbove relativeTo:rightExpression2Control];
		[parentView replaceSubview:rightExpression1Control with:newRightExpression1Control];
		[parentView replaceSubview:rightExpression2Control with:newRightExpression2Control];
		
		[rightExpression1Control release];
		[rightExpression2Control release];
		
		rightExpression1Control = [newRightExpression1Control retain];
		rightExpression2Control = [newRightExpression2Control retain];
	}
	
	[self predicateOperatorPopupButtonChanged:predicateOperatorPopupButton];
}

- (IBAction)predicateOperatorPopupButtonChanged:(id)sender {
	int selectedTag = [predicateOperatorPopupButton selectedTag];
	if (selectedTag < 5) { // is in the range
		[rightExpression1Control setHidden:NO];
		[toTextField setHidden:YES];
		[rightExpression2Control setHidden:YES];
	} else if (selectedTag == 5) {
		[rightExpression1Control setHidden:NO];
		[toTextField setHidden:NO];
		[rightExpression2Control setHidden:NO];
	} else {
		[rightExpression1Control setHidden:YES];
		[toTextField setHidden:YES];
		[rightExpression2Control setHidden:YES];
	}
}

- (void)filterPredicateOperatorsForFolderKind:(NSString *)folderKind {
	if ([folderKind isEqualToString:@"uk.co.stevehooley.mori.tagfolder"]) {
		[predicateOperatorPopupButton removeItemAtIndex:[predicateOperatorPopupButton indexOfItemWithTag:2]];	
		[predicateOperatorPopupButton removeItemAtIndex:[predicateOperatorPopupButton indexOfItemWithTag:3]];	
		[predicateOperatorPopupButton removeItemAtIndex:[predicateOperatorPopupButton indexOfItemWithTag:4]];	
		[predicateOperatorPopupButton removeItemAtIndex:[predicateOperatorPopupButton indexOfItemWithTag:5]];	
		[predicateOperatorPopupButton removeItemAtIndex:[predicateOperatorPopupButton indexOfItemWithTag:6]];				
		[predicateOperatorPopupButton removeItemAtIndex:[predicateOperatorPopupButton indexOfItemWithTag:7]];
		[predicateOperatorPopupButton removeItemAtIndex:1]; // remove separator
	}
}

@end
