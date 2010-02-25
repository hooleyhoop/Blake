//
//  ModelToolTests.m
//  DebugDrawing
//
//  Created by steve hooley on 29/10/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "Tool.h"
#import "StarScene.h"
#import "TestUtilities.h"
#import "Star.h"
#import "ModelTool.h"
#import "DomainContext.h"

@interface ModelToolTests : SenTestCase {
	
	ModelTool			*_aTool;
	OCMockObject	*_mockDomain;
}

@end


@implementation ModelToolTests

- (void)setUp {
	
	_mockDomain = [MOCK(DomainContext) retain];	
	_aTool = [[ModelTool alloc] initWithDomainContext:(id)_mockDomain];
}

- (void)tearDown {
	
	[_aTool release];
	[_mockDomain release];
}

- (void)testIdentifier {
	// - (NSString *)identifier
	
	STAssertTrue( [[_aTool identifier] isEqualToString:@"MODELTOOL_ABSTRACT"], @"erm %@", [_aTool identifier] );
}

- (void)testNodeUnderPoint {
	// - (SHNode *)nodeUnderPoint:(NSPoint)pt
	
	NSPoint hitPt = NSMakePoint(10,10);
	[[[_mockDomain expect] andReturn:nil] nodeUnderPoint:hitPt];
	SHNode *nup = [_aTool nodeUnderPoint:hitPt];
}



@end
