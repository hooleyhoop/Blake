//
//  BKConfigurationProtocols.m
//  Blocks
//
//  Created by Jesse Grosjean on 2/3/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKConfigurationProtocols.h"
#import "BKConfigurationController.h"


@implementation NSApplication (BKConfigurationControllerProtocolAccess)

- (id <BKConfigurationControllerProtocol>)BKConfigurationProtocols_configurationController {
	return [BKConfigurationController sharedInstance];
}

@end