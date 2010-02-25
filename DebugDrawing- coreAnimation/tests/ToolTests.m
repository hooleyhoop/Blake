//
//  ToolTests.m
//  DebugDrawing
//
//  Created by Steven Hooley on 1/11/09.
//  Copyright 2009 Bestbefore. All rights reserved.
//

#import "Tool.h"
#import "StarScene.h"
#import "TestUtilities.h"
#import "Star.h"
#import "CALayerStarView.h"
#import "DomainContext.h"


@interface ToolTests : SenTestCase {
	
	Tool			*_aTool;
}

@end

@implementation ToolTests

 
- (void)setUp {
	
	_aTool = [[Tool alloc] init];
}

- (void)tearDown {
	
	[_aTool release];
}

- (void)testIdentifier {
	// - (NSString *)identifier
	
	STAssertTrue( [[_aTool identifier] isEqualToString:@"TOOL_ABSTRACT"], @"erm %@", [_aTool identifier] );
}

@end
