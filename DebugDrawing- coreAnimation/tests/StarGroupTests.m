//
//  StarGroupTests.m
//  DebugDrawing
//
//  Created by steve hooley on 24/09/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "StarGroup.h"
#import "Star.h"
#import "DrawDestination_protocol.h"

@class StarGroup;

@interface StarGroupTests : SenTestCase <DrawDestination_protocol> {
	
	StarGroup *starGroup;
}

- (void)graphic:(id)obj drewAt:(NSRect)dst;

@end

static NSMutableArray *drawObjects;
static NSMutableArray *drawnRects;

@implementation StarGroupTests

BOOL rectIsNearlyEqualToRect( NSRect rect1, NSRect rect2 ) {

	BOOL xIsNearlyEqual = rect1.origin.x>(rect2.origin.x-0.5) && rect1.origin.x<(rect2.origin.x+0.5);
	BOOL yIsNearlyEqual = rect1.origin.y>(rect2.origin.y-0.5) && rect1.origin.y<(rect2.origin.y+0.5);
	BOOL widthIsNearlyEqual = rect1.size.width>(rect2.size.width-0.5) && rect1.size.width<(rect2.size.width+0.5);
	BOOL heightIsNearlyEqual = rect1.size.height>(rect2.size.height-0.5) && rect1.size.height<(rect2.size.height+0.5);

	NSCAssert1( xIsNearlyEqual, @"Fucked Up x pos - %f", rect1.origin.x );
	NSCAssert1( yIsNearlyEqual, @"Fucked Up y pos - %f", rect1.origin.y );
	NSCAssert1( widthIsNearlyEqual, @"Fucked Up width - %f", rect1.size.width );
	NSCAssert1( heightIsNearlyEqual, @"Fucked Up height - %f", rect1.size.height );
	
	return xIsNearlyEqual && yIsNearlyEqual && widthIsNearlyEqual && heightIsNearlyEqual;
}

- (void)graphic:(id)obj drewAt:(NSRect)dst {
	
	NSParameterAssert(obj!=nil);
	
	[drawObjects addObject:obj];
	[drawnRects addObject:[NSValue valueWithRect:dst]];
}

- (void)setUp {
	
	starGroup = [StarGroup new];
}

- (void)tearDown {
	
	[starGroup release];
}

- (void)testAddNode {
	
	Star *star1 = [Star new];	
	[starGroup addNode:star1];
	STAssertTrue( [[starGroup nodes] count]==1, @" failed to add star" );
}

#pragma mark - simple cases - no stretch - 
- (void)testSetPhysicalBounds {
	
	// what does it mean for an empty group to have width and height? Fuck all…
	NSRect targetRect = NSMakeRect( 500.0f, 510.0f, 520.0f, 530.0f );
	starGroup.bounds = targetRect;
	NSRect emptyGroupBounds = [starGroup bounds];
	
	STAssertTrue( rectIsNearlyEqualToRect( emptyGroupBounds, NSMakeRect(targetRect.origin.x, targetRect.origin.y, 0.0f, 0.0f)), @"Rect not equal");
	
	// add a child star
	Star *star1 = [Star new];
	NSRect starBounds = NSMakeRect( 100, 50, 300, 100 );
	star1.bounds = starBounds;
	[starGroup addNode:star1];
	
	NSRect fullGroupBounds = [starGroup bounds];
	STAssertTrue( rectIsNearlyEqualToRect( fullGroupBounds, NSMakeRect(targetRect.origin.x, targetRect.origin.y, starBounds.size.width, starBounds.size.height)), @"Rect not equal");
}

- (void)testDraw {
	
	drawObjects = [NSMutableArray array]; drawnRects = [NSMutableArray array];
	
	// set position
	NSRect targetRect = NSMakeRect( 500.0f, 510.0f, 0, 0 );
	starGroup.bounds = targetRect;
	[starGroup setDrawingDestination:self];

	// add a child star
	Star *star1 = [Star new];
	NSRect starBounds = NSMakeRect( 100, 50, 300, 100 );
	star1.bounds = starBounds;
	[star1 setDrawingDestination:self];
	[starGroup addNode:star1];
	
	// check that star drew in the correct place
	[starGroup drawWithHint:];
	STAssertTrue( [drawnRects count]==2, @"failed to draw all objects %i", [drawnRects count]);
	STAssertTrue( [drawObjects objectAtIndex:0]==starGroup, @"failed to draw all objects %@", [drawObjects objectAtIndex:0] );
	STAssertTrue( [drawObjects objectAtIndex:1]==star1, @"failed to draw all objects %@", [drawObjects objectAtIndex:1] );

//	assert rect1 = offset star bounds
//	assert rect2 = group bounds
	NSRect starGroupBnds = [starGroup bounds];
	NSRect offsetStarBnds = NSMakeRect(600.0f, 560.0f, 300.0f, 100.0f);
	NSRect drawn1Bnds = [[drawnRects objectAtIndex:0] rectValue];
	NSRect drawn2Bnds = [[drawnRects objectAtIndex:1] rectValue];
	STAssertTrue( rectIsNearlyEqualToRect( drawn1Bnds, NSMakeRect( starGroupBnds.origin.x, starGroupBnds.origin.y, starGroupBnds.size.width, starGroupBnds.size.height)), @"Rect not equal");
	STAssertTrue( rectIsNearlyEqualToRect( drawn2Bnds, NSMakeRect( offsetStarBnds.origin.x, offsetStarBnds.origin.y, offsetStarBnds.size.width, offsetStarBnds.size.height)), @"Rect not equal");

	drawObjects=nil, drawnRects=nil;
}

#pragma mark - complex cases - stretching stretch - 
- (void)testSetPhysicalBounds_stretch_draw {

	drawObjects = [NSMutableArray array]; drawnRects = [NSMutableArray array];

	// add a child star
	Star *star1 = [Star new];
	[star1 setDrawingDestination:self];
	NSRect starBounds = NSMakeRect( 100, 50, 300, 100 );
	NSRect offsetStarBnds = NSMakeRect(550.0f, 535.0f, starBounds.size.width/2.0f, starBounds.size.height/2.0f );

	star1.bounds = starBounds;
	[starGroup addNode:star1];
	[starGroup setDrawingDestination:self];

	// position and scale the group
	NSRect targetRect = NSMakeRect( 500.0f, 510.0f, starBounds.size.width/2.0f, starBounds.size.height/2.0f );
	starGroup.bounds = targetRect;
	NSRect stretchedGroupBounds = [starGroup bounds];

	STAssertTrue( rectIsNearlyEqualToRect( stretchedGroupBounds, NSMakeRect( targetRect.origin.x, targetRect.origin.y, offsetStarBnds.size.width, offsetStarBnds.size.height) ), @"Rect not equal");

	[starGroup drawWithHint:];

	NSRect drawn1Bnds = [[drawnRects objectAtIndex:0] rectValue];
	NSRect drawn2Bnds = [[drawnRects objectAtIndex:1] rectValue];
	STAssertTrue( rectIsNearlyEqualToRect( drawn1Bnds, NSMakeRect( stretchedGroupBounds.origin.x, stretchedGroupBounds.origin.y, stretchedGroupBounds.size.width, stretchedGroupBounds.size.height)), @"Rect not equal");
	STAssertTrue( rectIsNearlyEqualToRect( drawn2Bnds, NSMakeRect( offsetStarBnds.origin.x, offsetStarBnds.origin.y, offsetStarBnds.size.width, offsetStarBnds.size.height)), @"Rect not equal");

//	NSRect fullGroupBounds = [starGroup bounds];
//	STAssertTrue( rectIsNearlyEqualToRect( fullGroupBounds, NSMakeRect(targetRect.origin.x, targetRect.origin.y, , )), @"Rect not equal");
	
	drawObjects=nil, drawnRects=nil;
}



@end
