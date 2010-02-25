//
//  BKRuleEditorProtocols.m
//  Blocks
//
//  Created by Jesse Grosjean on 1/8/06.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKRuleEditorWindowController.h"
#import "BKStringRuleViewController.h"
#import "BKNumberRuleViewController.h"
#import "BKDateRuleViewController.h"
#import "BKBooleanRuleViewController.h"
#import "BKTriStateRuleViewController.h"
#import "BKTokenRuleViewController.h"


@implementation NSObject (BKRuleEditorProtocols)

+ (id <BKRuleEditorWindowControllerProtocol>)createNewRuleEditorWindowController {
	return [[[BKRuleEditorWindowController alloc] init] autorelease];
}

+ (id <BKStringRuleViewControllerProtocol>)createNewStringRuleViewControllerWithRuleKey:(NSString *)ruleKey predicate:(NSPredicate *)predicate {
	BKStringRuleViewController *stringRuleViewController = [[[BKStringRuleViewController alloc] init] autorelease];
	[stringRuleViewController setRuleKey:ruleKey];
	[stringRuleViewController setPredicate:predicate];
	return stringRuleViewController;
}

+ (id <BKNumberRuleViewControllerProtocol>)createNewNumberRuleViewControllerWithRuleKey:(NSString *)ruleKey predicate:(NSPredicate *)predicate {
	BKNumberRuleViewController *numberRuleViewController = [[[BKNumberRuleViewController alloc] init] autorelease];
	[numberRuleViewController setRuleKey:ruleKey];
	[numberRuleViewController setPredicate:predicate];
	return numberRuleViewController;
}

+ (id <BKDateRuleViewControllerProtocol>)createNewDateRuleViewControllerWithRuleKey:(NSString *)ruleKey predicate:(NSPredicate *)predicate {
	BKDateRuleViewController *dateRuleViewController = [[[BKDateRuleViewController alloc] init] autorelease];
	[dateRuleViewController setRuleKey:ruleKey];
	[dateRuleViewController setPredicate:predicate];
	return dateRuleViewController;
}

+ (id <BKBooleanRuleViewControllerProtocol>)createNewBooleanRuleViewControllerWithRuleKey:(NSString *)ruleKey predicate:(NSPredicate *)predicate {
	BKBooleanRuleViewController *booleanRuleViewController = [[[BKBooleanRuleViewController alloc] init] autorelease];
	[booleanRuleViewController setRuleKey:ruleKey];
	[booleanRuleViewController setPredicate:predicate];
	return booleanRuleViewController;
}

+ (id <BKTriStateRuleViewControllerProtocol>)createNewTriStateRuleViewControllerWithRuleKey:(NSString *)ruleKey predicate:(NSPredicate *)predicate {
	BKTriStateRuleViewController *triStateRuleViewController = [[[BKTriStateRuleViewController alloc] init] autorelease];
	[triStateRuleViewController setRuleKey:ruleKey];
	[triStateRuleViewController setPredicate:predicate];
	return triStateRuleViewController;
}

+ (id <BKTokenRuleViewControllerProtocol>)createNewTokenRuleViewControllerWithRuleKey:(NSString *)ruleKey predicate:(NSPredicate *)predicate {
	BKTokenRuleViewController *tokenRuleViewController = [[[BKTokenRuleViewController alloc] init] autorelease];
	[tokenRuleViewController setRuleKey:ruleKey];
	[tokenRuleViewController setPredicate:predicate];
	return tokenRuleViewController;
}

@end