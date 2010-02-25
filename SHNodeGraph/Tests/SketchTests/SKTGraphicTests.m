//
//  SKTGraphicTests.m
//  SHNodeGraph
//
//  Created by steve hooley on 20/09/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SKTGraphicTests.h"
#import "SKTGraphic.h"

@implementation SKTGraphicTests

- (void)setUp {
    
    _graphic =  [[SKTGraphic alloc] init];
}

- (void)tearDown {
    
	[_graphic release];
}

- (void)testSingleNotificationIsReceived {
    
}

@end
