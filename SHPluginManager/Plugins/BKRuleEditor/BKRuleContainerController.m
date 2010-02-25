//
//  BKRuleContainerController.m
//  SmartFolder
//
//  Created by Jesse Grosjean on 9/13/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKRuleContainerController.h"
#import "BKRuleEditorWindowController.h"


@interface BKRuleContainerController (BKPrivate)

- (id <BKRuleViewControllerProtocol>)ruleViewController;
- (void)setRuleViewController:(id <BKRuleViewControllerProtocol>)newRuleViewController;

@end
	
@implementation BKRuleContainerController

#pragma mark init

- (id)initWithRuleEditor:(BKRuleEditorWindowController *)aRuleEditor ruleViewController:(id <BKRuleViewControllerProtocol>)aRuleViewController {
	if (self = [super init]) {
		ruleEditor = aRuleEditor; // don't retain
		if (![NSBundle loadNibNamed:@"BKRuleContainerView" owner:self]) {
			NSLog(@"error loding nib");
			[self release];
			return nil;
		}
		[self setRuleViewController:aRuleViewController];
	}
	return self;
}

#pragma mark awakeFromNib like method

- (void)awakeFromNib {
	[placeholderRuleView retain];
	[rulePopUpButton setMenu:[ruleEditor rulesMenu]];
	[rulePopUpButton setTarget:self];
}

#pragma mark dealloc

- (void)dealloc {
	[placeholderRuleView release];
	[ruleViewController release];
	[super dealloc];
}

#pragma mark view

- (BKRuleEditorWindowController *)ruleEditor {
	return ruleEditor;
}

- (void)setRuleEditor:(BKRuleEditorWindowController *)newRuleEditor {
	ruleEditor = newRuleEditor;
}

- (NSView *)ruleContainerView {
	return ruleContainerView;
}

#pragma mark predicate

- (NSPredicate *)predicate {
	return [[self ruleEditor] createPredicateFromRuleViewController:ruleViewController];
}

- (void)setPredicate:(NSPredicate *)newPredicate {
	[self setRuleViewController:[[self ruleEditor] createRuleViewControllerForPredicate:newPredicate]];
}

- (id <BKRuleViewControllerProtocol>)ruleViewController {
	return ruleViewController;
}

- (void)setRuleViewController:(id <BKRuleViewControllerProtocol>)newRuleViewController {
	NSView *oldRuleView = [ruleViewController view];
	NSView *newRuleView = [newRuleViewController view];

	[ruleViewController autorelease];
	ruleViewController = [newRuleViewController retain];

	if (!oldRuleView) oldRuleView = placeholderRuleView;
	if (!newRuleView) newRuleView = placeholderRuleView;
	
	if (newRuleView != oldRuleView) {
		[newRuleView setFrame:[oldRuleView frame]];
		[ruleContainerView replaceSubview:oldRuleView with:newRuleView];
		[rulePopUpButton selectItemAtIndex:[rulePopUpButton indexOfItemWithRepresentedObject:[ruleViewController ruleKey]]];
	}
}

#pragma mark actions

- (IBAction)remove:(id)sender {
	if ([ruleEditor numberOfRuleContainers] > 1) {
		[ruleEditor removeRuleContainer:self];
	} else {
		NSBeep();
	}
}

- (IBAction)add:(id)sender {
	NSArray *ruleKeys = [[[ruleEditor rulesMenu] itemArray] valueForKey:@"representedObject"];
	int nextRuleIndex = [rulePopUpButton indexOfItemWithRepresentedObject:[[self ruleViewController] ruleKey]] + 1;
	NSString *nextRuleKey = (nextRuleIndex < [ruleKeys count]) ? [ruleKeys objectAtIndex:nextRuleIndex] : [ruleKeys objectAtIndex:0];
	id <BKRuleViewControllerProtocol> nextRuleViewController = [ruleEditor createRuleViewControllerForRuleKey:nextRuleKey];
	[ruleEditor addRuleContainer:[[[BKRuleContainerController alloc] initWithRuleEditor:ruleEditor ruleViewController:nextRuleViewController] autorelease] after:self];
}

- (IBAction)rulePopUpButtonChanged:(id)sender {
	[self setRuleViewController:[ruleEditor createRuleViewControllerForRuleKey:[[rulePopUpButton selectedItem] representedObject]]];
}

@end