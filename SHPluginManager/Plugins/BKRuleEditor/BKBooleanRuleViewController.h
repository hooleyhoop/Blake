//
//  BKBooleanRuleViewController.h
//  Blocks
//
//  Created by Jesse Grosjean on 2/10/06.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Blocks/Blocks.h>
#import "BKRuleEditorProtocols.h"


@interface BKBooleanRuleViewController : NSObject <BKBooleanRuleViewControllerProtocol> {
	IBOutlet NSView *view;
	IBOutlet NSPopUpButton *predicateOperatorPopupButton;
	
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
