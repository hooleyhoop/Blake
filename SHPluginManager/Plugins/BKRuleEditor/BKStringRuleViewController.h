//
//  BKStringRuleViewController.h
//  Blocks
//
//  Created by Jesse Grosjean on 1/8/06.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Blocks/Blocks.h>
#import "BKRuleEditorProtocols.h"


@interface BKStringRuleViewController : NSObject <BKStringRuleViewControllerProtocol> {
	IBOutlet NSView *view;
	IBOutlet NSPopUpButton *predicateOperatorPopupButton;
	IBOutlet NSTextField *rightExpressionTextField;
	
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
