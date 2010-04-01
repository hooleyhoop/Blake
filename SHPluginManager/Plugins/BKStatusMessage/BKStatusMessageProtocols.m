//
//  BKStatusMessageProtocols.m
//  Blocks
//
//  Created by Jesse Grosjean on 10/29/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKStatusMessageProtocols.h"
#import "BKStatusMessageController.h"


@implementation NSApplication (BKStatusMessageControllerProtocolAccess)

- (id <BKStatusMessageControllerProtocol>)BKStatusMessageProtocols_statusMessageController {
	return [BKStatusMessageController sharedInstance];
}

@end