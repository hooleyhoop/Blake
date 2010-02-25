//
//  MathUtilitiesTests.m
//  DebugDrawing
//
//  Created by steve hooley on 15/07/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "XForm.h"
#import "MoreMathUtilities.h"

@interface MathUtilitiesTests : SenTestCase {
	
}

@end

@implementation MathUtilitiesTests

- (void)setUp {
	
}

- (void)tearDown {
	
}

- (void)testnearlyEqualNSRects {
	//BOOL nearlyEqualNSRects( NSRect rect1, NSRect rect2 )
	
	NSRect rect1 = NSMakeRect(-10.f,11.f,100.f,50.5f);
	NSRect rect2 = NSMakeRect(-10.f,11.f,100.f,50.5f);
	NSRect rect3 = NSMakeRect(-10.f,11.f,100.f,51.f);

	STAssertTrue(nearlyEqualNSRects(rect1, rect2), @"fail");
	STAssertFalse(nearlyEqualNSRects(rect1, rect3), @"fail");
}

- (void)testNearlyEqualCGRects {
	//BOOL nearlyEqualCGRects( CGRect rect1, CGRect rect2 )
	
	CGRect rect1 = CGRectMake(-10.f,11.f,100.f,50.5f);
	CGRect rect2 = CGRectMake(-10.f,11.f,100.f,50.5f);
	CGRect rect3 = CGRectMake(-10.f,11.f,100.f,51.f);
	
	STAssertTrue(nearlyEqualCGRects(rect1, rect2), @"fail");
	STAssertFalse(nearlyEqualCGRects(rect1, rect3), @"fail");
}

- (void)testnearlyEqualNSPoints {
	//BOOL nearlyEqualNSPoints( NSPoint pt1, NSPoint pt2 )
	
	NSPoint point1 = NSMakePoint(-100.f,50.f);
	NSPoint point2 = NSMakePoint(-100.f,50.f);
	NSPoint point3 = NSMakePoint(-100.f,51.f);

	STAssertTrue(nearlyEqualNSPoints(point1, point2), @"fail");
	STAssertFalse(nearlyEqualNSPoints(point1, point3), @"fail");
}

- (void)testNearlyEqualCGPoints {
	//BOOL nearlyEqualCGPoints( CGPoint pt1, CGPoint pt2 )
	
	CGPoint point1 = CGPointMake(-100,50);
	CGPoint point2 = CGPointMake(-100,50);
	CGPoint point3 = CGPointMake(-100,51);
	
	STAssertTrue(nearlyEqualCGPoints(point1, point2), @"fail");
	STAssertFalse(nearlyEqualCGPoints(point1, point3), @"fail");
}
			
- (void)testG3DCompareFloat {
	//NSInteger G3DCompareFloat( CGFloat a, CGFloat b, CGFloat tol )
	
	CGFloat a = 1.001f;
	CGFloat b = 1.00100001f;
	CGFloat c = 1.00200001f;
	STAssertTrue(G3DCompareFloat(a, b, 0.0001f)==0, @"fail");
	STAssertTrue(G3DCompareFloat(a, c, 0.0001f)!=0, @"fail");
}

#pragma mark test new matrix stuff
- (void)testConvertPtToChildSpace {
	// CGPoint convertPtToChildSpace( CGPoint pt, NSArray *xForms )

	XForm *xForm1 = [[[XForm alloc] init] autorelease];
	XForm *xForm2 = [[[XForm alloc] init] autorelease];
	XForm *xForm3 = [[[XForm alloc] init] autorelease];
	xForm1.position = CGPointMake( 5, 1 );
	xForm2.position = CGPointMake( 50, 20 );
	xForm3.position = CGPointMake( 3, 3 );
	
	//! need to make sure that each xform is uptodate - build it in!
	[xForm1 enforceConsistentState];
	[xForm2 enforceConsistentState];
	[xForm3 enforceConsistentState];
	
	CGPoint resultPt = convertPtToChildSpace( CGPointZero, [NSArray arrayWithObjects:xForm1, xForm2, xForm3, nil] );
	STAssertTrue( nearlyEqualCGPoints( resultPt, CGPointMake(-58.f, -24.f)), @"doh %@", NSStringWithCGPoint(resultPt) );
	
	/* more complicated transforms - i really need some good data 
		This is from After Effects comp "transform tests.aep"
	*/
	xForm1 = [[[XForm alloc] init] autorelease];
	xForm2 = [[[XForm alloc] init] autorelease];
	xForm1.scale = 1.25f;
	xForm1.anchorPt = CGPointMake( 0.f, 0.f );
	xForm1.position = CGPointMake( 10.0f, 5.0f );
	xForm1.rotation = 20.0f;

	xForm2.scale = 1.33f;
	xForm2.anchorPt = CGPointZero;
	xForm2.position = CGPointMake( 20.0f, 25.0f );
	xForm2.rotation =10.0f;

	[xForm1 enforceConsistentState];
	[xForm2 enforceConsistentState];

	CGPoint resultPt2 = convertPtToChildSpace( CGPointMake(30.f, 80.f), [NSArray arrayWithObjects:xForm1, xForm2, nil] );
	STAssertTrue( nearlyEqualCGPoints( resultPt2, CGPointMake(14.901539f, 17.15360f)), @"doh %@", NSStringWithCGPoint(resultPt2) );
}

// for convertPtToChildSpace i used after effects
// In this test i am just trying to get the reverse values
- (void)testConvertPtFromChildSpace {
	//CGPoint convertPtFromChildSpace( CGPoint pt, NSArray *xForms )

	XForm *xForm1 = [[[XForm alloc] init] autorelease];
	XForm *xForm2 = [[[XForm alloc] init] autorelease];
	XForm *xForm3 = [[[XForm alloc] init] autorelease];
	
	xForm1.position = CGPointMake( 5, 1 );
	xForm2.position = CGPointMake( 50, 20 );
	xForm3.position = CGPointMake( 3, 3 );
	
	//! need to make sure that each xform is uptodate - build it in!
	[xForm1 enforceConsistentState];
	[xForm2 enforceConsistentState];
	[xForm3 enforceConsistentState];

	CGPoint resultPt = convertPtFromChildSpace( CGPointMake(0,0), [NSArray arrayWithObjects:xForm1, xForm2, xForm3, nil] );
	STAssertTrue( nearlyEqualCGPoints( resultPt, CGPointMake(58,24)), @"doh %@", NSStringWithCGPoint(resultPt) );
	
	/* 
	 * More complex
	*/
	xForm1 = [[[XForm alloc] init] autorelease];
	xForm2 = [[[XForm alloc] init] autorelease];
	xForm1.scale = 1.25f;
	xForm1.anchorPt = CGPointMake( 0.f, 0.f );
	xForm1.position = CGPointMake( 10.0f, 5.0f );
	xForm1.rotation = 20.0f;
	
	xForm2.scale = 1.33f;
	xForm2.anchorPt = CGPointMake( 0.f, 0.f );
	xForm2.position = CGPointMake( 20.0f, 25.0f );
	xForm2.rotation = 10.0f;
	
	[xForm1 enforceConsistentState];
	[xForm2 enforceConsistentState];
	
	CGPoint resultPt2 = convertPtFromChildSpace( CGPointMake(0, 0), [NSArray arrayWithObjects:xForm1, xForm2, nil] );
	STAssertTrue( nearlyEqualCGPoints( resultPt2, CGPointMake(22.8041f, 42.915897f) ), @"doh %@", NSStringWithCGPoint(resultPt2) );
}

- (void)testSmallestRectEnclosingPoints {
	// CGRect smallestRectEnclosingPoints( CGPoint point1, CGPoint point2 )
	
	CGPoint p1 = CGPointMake( 10.f,10.f );
	CGPoint p2 = CGPointMake( 20.f,20.f );
	CGRect enclosingRect1 = smallestRectEnclosingPoints(p1,p2);
	STAssertTrue( nearlyEqualCGRects( enclosingRect1, CGRectMake(10.f,10.f,10.f,10.f)), @"what gone wrong big boy?");
	
	CGPoint p3 = CGPointMake( 9.6f, 7.2f );
	CGPoint p4 = CGPointMake( 2.6f, 3.4f );
	CGRect enclosingRect2 = smallestRectEnclosingPoints(p3,p4);
	STAssertTrue( nearlyEqualCGRects( enclosingRect2, CGRectMake(2.6f, 3.4f, 7.f, 3.8f)), @"what gone wrong big boy? %@", NSStringFromCGRect(enclosingRect2) );
}

- (void)testAngleDegressBetweenTwoPtsAboutCentre {
	// CGFloat angleDegressBetweenTwoPtsAboutCentre( CGPoint pt1, CGPoint pt2, CGPoint centrePt )

	CGPoint centrePt = CGPointMake(0,0);
	CGPoint p1 = CGPointMake(0,10);
	CGPoint p2 = CGPointMake(10,0);
	CGFloat angle = angleDegressBetweenTwoPtsAboutCentre( p1, p2, centrePt );
	STAssertTrue( G3DCompareFloat( angle, 90.0f, 0.001f)==0, @"No - %f", angle);
}


@end

