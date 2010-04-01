//
//  BKTokenRuleViewController.h
//  Blocks
//
//  Created by Jesse Grosjean on 2/11/06.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Blocks/Blocks.h>
#import "BKRuleEditorProtocols.h"


@interface BKTokenRuleViewController : NSObject <BKTokenRuleViewControllerProtocol> {
	IBOutlet NSView *view;
	IBOutlet NSPopUpButton *predicateOperatorPopupButton;
	IBOutlet NSTokenField *rightExpressionTokenField;
	
	NSString *ruleKey;
	NSExpression *templateLeftExpression;
	NSArray *completions;
}

- (NSString *)ruleKey;
- (void)setRuleKey:(NSString *)newRuleKey;
- (NSPredicate *)predicate;
- (void)setPredicate:(NSPredicate *)newPredicate;
- (NSView *)view;

- (NSArray *)completions;
- (void)setCompletions:(NSArray *)newCompletions;

@end