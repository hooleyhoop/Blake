//
//  BKTriStateRuleViewController.h
//  Blocks
//
//  Created by Jesse Grosjean on 9/19/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Blocks/Blocks.h>
#import "BKRuleEditorProtocols.h"


@interface BKTriStateRuleViewController : NSObject <BKTriStateRuleViewControllerProtocol> {
	IBOutlet NSView *view;
	IBOutlet NSPopUpButton *predicateOperatorPopUpButton;
	
	NSString *ruleKey;
	NSExpression *templateLeftExpression;
}

- (NSString *)ruleKey;
- (void)setRuleKey:(NSString *)newRuleKey;
- (NSPredicate *)predicate;
- (void)setPredicate:(NSPredicate *)newPredicate;
- (NSView *)view;

@end
