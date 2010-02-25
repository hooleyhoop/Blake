//
//  AbstractLayerTests.m
//  DebugDrawing
//
//  Created by steve hooley on 31/07/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import  "AbstractLayer.h"
#import  "Graphic.h"

@interface AbstractLayerTests : SenTestCase {
	
	AbstractLayer *_abstractLayer;
}

@end

@implementation AbstractLayerTests

- (void)setUp {
	_abstractLayer = [[AbstractLayer layer] retain];
}

- (void)tearDown {
	[_abstractLayer release];
}

- (void)testWasAdded {
	
	// - (void)wasAdded
	// - (void)wasRemoved
	[_abstractLayer wasAdded];
	[_abstractLayer wasRemoved];
}

- (void)testAnimations {
	// - (NSDictionary *)animations

	STAssertThrows( [(id)_abstractLayer animations], @"dont know if this is needed yet?");
	
	// if it is...
//	STAssertTrue( [(CALayer *)_abstractLayer animations]==nil, @"wah?");
}

- (void)testActionForLayer {
// - (id<CAAction>)actionForLayer:(CALayer *)layer forKey :(NSString *)key

	STAssertTrue( (id)[_abstractLayer actionForLayer:_abstractLayer forKey:@"dom"]==[NSNull null], @"hmm");
}

- (void)testDescription {
	
	OCMockObject *mockNode = [OCMockObject mockForClass:[Graphic class]];
	_abstractLayer.delegate = mockNode;

	[[[mockNode stub] andReturn:[NodeName makeNameWithString:@"chicken"]] name];
	
	NSString *expectedDescription = [NSString stringWithFormat:@"<AbstractLayer: %p> - chicken\n", _abstractLayer];
	STAssertTrue( [[_abstractLayer description] isEqualToString:expectedDescription], @"%@ != %@", expectedDescription, [_abstractLayer description] );
	 
	[mockNode verify];
}

@end
