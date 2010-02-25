//
//  SHWindowController.m
//  SHShared
//
//  Created by steve hooley on 21/07/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "SHWindowController.h"
#import "BBNibManager.h"

@implementation SHWindowController

@synthesize nibManager = _nibManager;

+ (NSString *)nibName {
	return nil;
}

- (id)initWithWindowNibName:(NSString *)windowNibName {
	
	self=[super initWithWindowNibName: windowNibName];
    if( self ) {
		_isBound = NO;
    }
    return self;
}

- (void)dealloc {

    [self cleanUpUnarchivedObjects];
    [super dealloc];
}

- (void)cleanUpUnarchivedObjects {

    // we must release ALL top level objects
	self.nibManager = nil;
}

/* Default loadWindow method doesnt seem to adequetely deal with topLevelObjects */
- (void)loadWindow {
	
	NSAssert([self isWindowLoaded]==NO, @"there is already a loaded winfdow");
	self.nibManager = [BBNibManager instantiateNib:[self windowNibName] withOwner:self];
}

@end
