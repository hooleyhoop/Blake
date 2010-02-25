//
//  BKRuleContainerController.h
//  SmartFolder
//
//  Created by Jesse Grosjean on 9/13/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BKRuleEditorProtocols.h"


@class BKRuleEditorWindowController;

@interface BKRuleContainerController : NSObject {
	IBOutlet NSView *ruleContainerView;
	IBOutlet NSPopUpButton *rulePopUpButton;
	IBOutlet NSView *placeholderRuleView;

	id <BKRuleViewControllerProtocol> ruleViewController;
	BKRuleEditorWindowController *ruleEditor;
}

#pragma mark init

- (id)initWithRuleEditor:(BKRuleEditorWindowController *)aRuleEditor ruleViewController:(id <BKRuleViewControllerProtocol>)aRuleViewController;

#pragma mark attributes

- (BKRuleEditorWindowController *)ruleEditor;
- (void)setRuleEditor:(BKRuleEditorWindowController *)newRuleEditor;
- (NSView *)ruleContainerView;

#pragma mark predicate

- (NSPredicate *)predicate;
- (void)setPredicate:(NSPredicate *)newPredicate;

#pragma mark actions

- (IBAction)remove:(id)sender;
- (IBAction)add:(id)sender;
- (IBAction)rulePopUpButtonChanged:(id)sender;

@end