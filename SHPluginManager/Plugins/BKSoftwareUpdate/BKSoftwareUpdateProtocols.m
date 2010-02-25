//
//  BKSoftwareUpdateProtocols.m
//  Blocks
//
//  Created by Jesse Grosjean on 1/7/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKSoftwareUpdateProtocols.h"
#import "BKSoftwareUpdateController.h"


@implementation NSApplication (BKSoftwareUpdateControllerAccess)

- (id <BKSoftwareUpdateControllerProtocol>)BKSoftwareUpdateProtocols_softwareUpdateController {
	return [BKSoftwareUpdateController sharedInstance];
}

@end