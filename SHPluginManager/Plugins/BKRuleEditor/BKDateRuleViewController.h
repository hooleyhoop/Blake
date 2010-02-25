//
//  BKDateRuleViewController.h
//  Blocks
//
//  Created by Jesse Grosjean on 1/9/06.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Blocks/Blocks.h>
#import "BKFoundationProtocols.h"
#import "BKRuleEditorProtocols.h"


@interface BKDateRuleViewController : NSObject <BKDateRuleViewControllerProtocol> {
	IBOutlet NSView *view;
	IBOutlet NSPopUpButton *predicateOperatorPopupButton;
	IBOutlet NSDatePicker *leftExpression1DatePicker;
	IBOutlet NSTextField *toTextField;
	IBOutlet NSDatePicker *leftExpression2DatePicker;
	IBOutlet NSTextField *leftExpressionNumberTextField;
	IBOutlet NSPopUpButton *leftExpressionNumberPopupButton;
	IBOutlet NSTextField *agoTextField;
	
	NSString *ruleKey;
	NSExpression *templateLeftExpression;
}

- (NSString *)ruleKey;
- (void)setRuleKey:(NSString *)newRuleKey;
- (NSPredicate *)predicate;
- (void)setPredicate:(NSPredicate *)newPredicate;
- (NSView *)view;

- (IBAction)predicateOperatorPopupButtonChanged:(id)sender;

@end