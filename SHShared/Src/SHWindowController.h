//
//  SHWindowController.h
//  SHShared
//
//  Created by steve hooley on 21/07/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import <Appkit/NSWindowController.h>

@class BBNibManager;

@interface SHWindowController : NSWindowController {

	BBNibManager				*_nibManager;
	BOOL						_isBound;

}

@property( retain, readwrite, nonatomic ) BBNibManager *nibManager;

+ (NSString *)nibName;

- (void)cleanUpUnarchivedObjects;

@end
