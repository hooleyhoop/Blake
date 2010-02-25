//
//  BKPreferencesProtocols.m
//  Blocks
//
//  Created by Jesse Grosjean on 1/7/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKPreferencesProtocols.h"
#import "BKPreferencesController.h"


@implementation NSApplication (BKPreferencePaneControllerAccess)

- (id <BKPreferencePaneControllerProtocol>)BKPreferencesProtocols_preferencesController {
	return [BKPreferencesController sharedInstance];
}

@end
