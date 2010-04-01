//
//  BlakeAboutBoxControllerTests.m
//  BlakeLoader2
//
//  Created by steve hooley on 09/12/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "BlakeAboutBoxController.h"

@interface BlakeAboutBoxControllerTests : SenTestCase {
	
	BlakeAboutBoxController *_abController;
}

@end

@implementation BlakeAboutBoxControllerTests

- (void)setUp {
	_abController = [[BlakeAboutBoxController sharedBlakeAboutBoxController] retain];
}

- (void)tearDown {
	[_abController release];
	[BlakeAboutBoxController disposeSharedAboutBoxController];
}

- (void)testShow {
// - (void)show
	[_abController show];	
}

@end
