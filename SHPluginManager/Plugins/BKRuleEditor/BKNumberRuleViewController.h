//
//  BKNumberRuleViewController.h
//  Blocks
//
//  Created by Jesse Grosjean on 1/9/06.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Blocks/Blocks.h>
#import "BKRuleEditorProtocols.h"
#import "BKApplicationProtocols.h"


@interface BKNumberRuleViewController : NSObject <BKNumberRuleViewControllerProtocol> {
	IBOutlet NSView *view;
	IBOutlet NSPopUpButton *predicateOperatorPopupButton;
	IBOutlet NSControl *rightExpression1Control;
	IBOutlet NSTextField *toTextField;
	IBOutlet NSControl *rightExpression2Control;
	
	NSString *ruleKey;
	NSExpression *templateLeftExpression;
	NSControl *prototypePrototypeExpressionControl;
}

- (NSString *)ruleKey;
- (void)setRuleKey:(NSString *)newRuleKey;
- (NSPredicate *)predicate;
- (void)setPredicate:(NSPredicate *)newPredicate;
- (NSView *)view;

- (NSControl *)prototypePrototypeExpressionControl;
- (void)setPrototypeExpressionControl:(NSControl *)newPrototypeExpressionControl;

- (IBAction)predicateOperatorPopupButtonChanged:(id)sender;

@end