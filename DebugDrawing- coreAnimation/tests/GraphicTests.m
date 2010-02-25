//
//  GraphicTests.m
//  DebugDrawing
//
//  Created by steve hooley on 03/11/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Graphic.h"
#import "ColourUtilities.h"
#import "XForm.h"

@interface GraphicTests : SenTestCase <DirtyRectObserverProtocol> {
	
	Graphic *_graphic;
}

@end

@implementation GraphicTests


- (void)setUp {
	
	_graphic = [[Graphic makeChildWithName:@"graphic"] retain];
//june09	[graphic enforceConsistentState];
}

- (void)tearDown {
	
	[_graphic release];
}

- (void)test_SetupDrawing {
	// - (void)_setupDrawing:(CGContextRef)cntx
	// - (void)_tearDownDrawing:(CGContextRef)cntx

	[_graphic setPosition:CGPointMake(10,10)];
	[_graphic enforceConsistentState];
	
	size_t components = 4;
	size_t bitsPerComponent = 8;
	size_t bytesPerRow = (20 * bitsPerComponent * components + 7)/8;
	size_t dataLength = bytesPerRow * 20;
	UInt32 *bitmap = malloc( dataLength );
	memset( bitmap, 0, dataLength );
	
	CGContextRef cntx = CGBitmapContextCreate (
												  bitmap,
												  20, 20,
												  bitsPerComponent,
												  bytesPerRow, // bytes per row
												  [ColourUtilities genericRGBSpace],
												  kCGImageAlphaPremultipliedFirst
												  );
	
	STAssertTrue( CGAffineTransformEqualToTransform( CGContextGetCTM(cntx), CGAffineTransformIdentity ), @"doh" );
	
	[_graphic _setupDrawing:cntx];
	
	STAssertTrue( CGAffineTransformEqualToTransform( CGContextGetCTM(cntx), CGAffineTransformMakeTranslation(10,10) ), @"doh" );

	[_graphic _tearDownDrawing:cntx];
	
	STAssertTrue( CGAffineTransformEqualToTransform( CGContextGetCTM(cntx), CGAffineTransformIdentity ), @"doh" );

	CGContextRelease( cntx );
	free(bitmap);
}

- (void)testAddObserverForKeyPathOptionsContext {
	// - (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
	// - (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath
	
	[_graphic enforceConsistentState];

	[_graphic addObserver:self forKeyPath:@"transformMatrix" options:0 context:@"GraphicTests"];
	[_graphic addObserver:self forKeyPath:@"geometryRect" options:0 context:@"GraphicTests"];
	
	[_graphic removeObserver:self forKeyPath:@"transformMatrix"];
	[_graphic removeObserver:self forKeyPath:@"geometryRect"];
}

- (void)testDidDrawAt {
	// - (NSRect)didDrawAt;

//june09	NSRect srcRect = NSMakeRect(0,0,100,100);
//june09	[_graphic setGeometryRect:srcRect];
 //june09   [_graphic setScale:1.0];
//june09    [_graphic setPosition:NSMakePoint(0,0)];
//june09    [_graphic setAnchorPt:NSMakePoint(0,0)];
//june09	[_graphic enforceConsistentState];
	
	// simple 1:1
//june09	NSRect drawnRect1 = [_graphic didDrawAt];
//june09	STAssertTrue( NSEqualRects(drawnRect1, NSMakeRect(0,0,100,100)), @"%@", NSStringFromRect(drawnRect1));
	
	// transform
//june09    [_graphic setPosition:NSMakePoint(10,10)];
//june09	[_graphic enforceConsistentState];
//june09	drawnRect1 = [_graphic didDrawAt];
//june09	STAssertTrue( NSEqualRects(drawnRect1, NSMakeRect(10,10,100,100)), @"%@", NSStringFromRect(drawnRect1));	
	
	// transform + anchor
//june09    [_graphic setAnchorPt:NSMakePoint(5,5)];
	[_graphic enforceConsistentState];
//june09	drawnRect1 = [_graphic didDrawAt];
//june09	STAssertTrue( NSEqualRects(drawnRect1, NSMakeRect(5,5,100,100)), @"%@", NSStringFromRect(drawnRect1));	
	
	// throw in some scale
 //june09   [_graphic setScale:2.0];
//june09	[_graphic enforceConsistentState];
//june09	drawnRect1 = [_graphic didDrawAt];
//june09	STAssertTrue( NSEqualRects(drawnRect1, NSMakeRect(0,0,200,200)), @"%@", NSStringFromRect(drawnRect1));	
	
	// some tasty rotation
//june09    [_graphic setRotation:90];
//june09   [_graphic setAnchorPt:NSMakePoint(0,0)];
//june09    [_graphic setPosition:NSMakePoint(0,0)];
//june09	[_graphic enforceConsistentState];
//june09	drawnRect1 = [_graphic didDrawAt];
//june09	STAssertTrue( NSEqualRects(drawnRect1, NSMakeRect(0.0,0.0,-200.0,200.0)), @"%@", NSStringFromRect(drawnRect1));	
	
 //june09   [_graphic setAnchorPt:NSMakePoint(0,50)];
 //june09   [_graphic setPosition:NSMakePoint(100,0)];
//june09	[_graphic enforceConsistentState];
//june09	drawnRect1 = [_graphic didDrawAt];
//june09	STAssertTrue( NSEqualRects(drawnRect1, NSMakeRect(200.0,0.0,-200.0,200.0)), @"%@", NSStringFromRect(drawnRect1));	
	
	#warning! This is the key test to get right.
//june09	NSRect srcRect2 = NSMakeRect(100,100,100,100);
//june09	[_graphic setGeometryRect:srcRect2];
//june09	[_graphic enforceConsistentState];
//june09	NSRect drawnRect2 = [_graphic didDrawAt];
//june09	STAssertTrue( NSEqualRects(drawnRect2, NSMakeRect(0.0,200.0,-200.0,200.0)), @"%@", NSStringFromRect(drawnRect2));	
}

- (void)testHasBeenAddedToParentSHNode {
	//- (void)hasBeenAddedToParentSHNode;
	
//june09	NSRect srcRect = NSMakeRect(-1,-1,1,1);
//june09	[_graphic setGeometryRect:srcRect];
 //june09   [_graphic setScale:1.0];
//june09	_graphic.parentSHNode = (id)[NSNull null];
//june09	[_graphic hasBeenAddedToParentSHNode];
//june09	
//june09	STAssertTrue(_graphic.xformDidChange==NO, @"er");
//june09	STAssertTrue(_graphic.drawingBoundsDidChange==NO, @"er");
}

- (void)testIsAboutToBeDeletedFromParentSHNode {
	// - (void)isAboutToBeDeletedFromParentSHNode;
	
//june09	NSRect srcRect = NSMakeRect(-1,-1,1,1);
//june09	[_graphic setGeometryRect:srcRect];
//june09	[_graphic setScale:1.0];
//june09	_graphic.parentSHNode = (id)[NSNull null];
//june09	[_graphic isAboutToBeDeletedFromParentSHNode];
	
//june09	STAssertTrue(_graphic.xformDidChange==NO, @"er");
//june09	STAssertTrue(_graphic.drawingBoundsDidChange==NO, @"er");
}

- (void)testEnforceConsistentState {
	// - (void)enforceConsistentState;
	
//june09	NSRect srcRect = NSMakeRect(-1,-1,1,1);
//june09	[_graphic setGeometryRect:srcRect];
//june09	[_graphic setScale:1.0];
//june09	[_graphic enforceConsistentState];
//june09	STAssertTrue(_graphic.xformDidChange==NO, @"er");
//june09	STAssertTrue(_graphic.drawingBoundsDidChange==NO, @"er");
}

- (void)testExecutionMode {
	// + (int)executionMode
	
	STAssertTrue([Graphic executionMode]==CONSUMER, @"doh");
}

- (void)testGeometryRect {
	// - (CGRect)geometryRect

	CGRect testRect = CGRectMake(0,0,10,10);
	[_graphic setGeometryRect:testRect];
	STAssertTrue( CGRectEqualToRect([_graphic geometryRect], testRect), @"boo");
}

- (void)testSetScale {
	
	_graphic.scale = 15.0f;
	STAssertTrue( G3DCompareFloat( _graphic.scale, 15.0f, 0.01f)==0, @"boo");
}

- (void)testSetPosition {

	_graphic.position = CGPointMake(15.0f,15.0f);
	STAssertTrue( CGPointEqualToPoint(CGPointMake(15.0f,15.0f), _graphic.position), @"doh");
}

- (void)testRotation {
	_graphic.rotation = 15.0f;
	STAssertTrue( G3DCompareFloat( _graphic.rotation, 15.0f, 0.01f)==0, @"boo");
}

- (void)testxForm {
	// - (XForm *)xForm {

	[_graphic enforceConsistentState];
	
	_graphic.position = CGPointMake(15.0f,15.0f);
	_graphic.rotation = 15.0f;
	_graphic.scale = 15.0f;
	
	STAssertTrue( [[_graphic xForm] needsRecalculating], @"hmm" );
}

- (void)testTurnOnConcatenatedMatrixObserving {
	// - (void)turnOnConcatenatedMatrixObserving
	// - (void)turnOffConcatenatedMatrixObserving
		
	Graphic *graphic1 = [Graphic makeChildWithName:@"graphic1"];
	SHNode *node2 = [SHNode makeChildWithName:@"graphic2"];
	Graphic *graphic3 = [Graphic makeChildWithName:@"graphic3"];
	Graphic *graphic4 = [Graphic makeChildWithName:@"graphic3"];
	Graphic *graphic5 = [Graphic makeChildWithName:@"graphic3"];

	// graphic1 > graphic2 > graphic3
	[graphic1 addChild:node2 undoManager:nil];
	[node2 addChild:graphic3 undoManager:nil];
	[graphic3 addChild:graphic4 undoManager:nil];
	[graphic4 addChild:graphic5 undoManager:nil];

	STAssertNil( [graphic1 concatenatedMatrixObserver], @"doh");
	STAssertNil( [graphic3 concatenatedMatrixObserver], @"doh");
	STAssertNil( [graphic4 concatenatedMatrixObserver], @"doh");
	STAssertNil( [graphic5 concatenatedMatrixObserver], @"doh");

	// this node and all nodes above should have a concatenatedObserver
	[graphic4 turnOnConcatenatedMatrixObserving];
	
	STAssertNotNil( [graphic1 concatenatedMatrixObserver], @"doh");
	STAssertNotNil( [graphic3 concatenatedMatrixObserver], @"doh");
	STAssertNotNil( [graphic4 concatenatedMatrixObserver], @"doh");
	STAssertNil( [graphic5 concatenatedMatrixObserver], @"doh");
	
	[graphic4 turnOffConcatenatedMatrixObserving];

	STAssertNil( [graphic1 concatenatedMatrixObserver], @"doh");
	STAssertNil( [graphic3 concatenatedMatrixObserver], @"doh");
	STAssertNil( [graphic4 concatenatedMatrixObserver], @"doh");
	STAssertNil( [graphic5 concatenatedMatrixObserver], @"doh");
}
	
- (void)testChildrenToTellConcatenatedMatrixIsDirty {
	// - (NSArray)childrenToTellConcatenatedMatrixIsDirty

	Graphic *graphic1 = [Graphic makeChildWithName:@"graphic1"];
	SHNode *node2 = [SHNode makeChildWithName:@"graphic2"];
	Graphic *graphic3 = [Graphic makeChildWithName:@"graphic3"];
	Graphic *graphic4 = [Graphic makeChildWithName:@"graphic3"];
	
	[graphic1 addChild:graphic3 undoManager:nil];
	[graphic1 addChild:node2 undoManager:nil];
	[graphic1 addChild:graphic4 undoManager:nil];
	
	// turn on some observing
	[graphic4 turnOnConcatenatedMatrixObserving];

	NSArray *childrenToTell1 = [graphic1 childrenToTellConcatenatedMatrixIsDirty];
	STAssertTrue( [childrenToTell1 count]==1, @"doh %i", [childrenToTell1 count]);
	STAssertTrue( [childrenToTell1 objectAtIndex:0]==graphic4, @"doh");

	NSArray *childrenToTell2 = [graphic4 childrenToTellConcatenatedMatrixIsDirty];
	STAssertTrue( [childrenToTell2 count]==0, @"doh");
	
	NSArray *childrenToTell3 = [graphic3 childrenToTellConcatenatedMatrixIsDirty];
	STAssertTrue( [childrenToTell3 count]==0, @"doh");
	
	// turn on a second observing
	[graphic3 turnOnConcatenatedMatrixObserving];
	
	NSArray *childrenToTell4 = [graphic1 childrenToTellConcatenatedMatrixIsDirty];
	STAssertTrue( [childrenToTell4 count]==2, @"doh");
	STAssertTrue( [childrenToTell4 objectAtIndex:0]==graphic3, @"doh");
	STAssertTrue( [childrenToTell4 objectAtIndex:1]==graphic4, @"doh");

	[graphic3 turnOffConcatenatedMatrixObserving];
	NSArray *childrenToTell5 = [graphic1 childrenToTellConcatenatedMatrixIsDirty];
	STAssertTrue( [childrenToTell5 count]==1, @"doh %i", [childrenToTell5 count]);
	STAssertTrue( [childrenToTell5 objectAtIndex:0]==graphic4, @"doh");
	
	[graphic4 turnOffConcatenatedMatrixObserving];
	NSArray *childrenToTell6 = [graphic1 childrenToTellConcatenatedMatrixIsDirty];
	STAssertTrue( [childrenToTell6 count]==0, @"doh");
}

// moving graphic should make concated matrix dirty
//graphic1.position = CGPointMake( 10, 10 );
//graphic3.position = CGPointMake( 10, 10 );
//graphic4.position = CGPointMake( 10, 10 );
//graphic5.position = CGPointMake( 10, 10 );

//	STAssertTrue( [graphic1 _concatenatedMatrixIsDirty], @"doh" );
//	STAssertTrue( [graphic2 _concatenatedMatrixIsDirty], @"doh" );
//	STAssertTrue( [graphic3 _concatenatedMatrixIsDirty], @"doh" );
//	
//	// calling it causes it to be recalculated
//	CGAffineTransform xform1 = [graphic1 concatenatedMatrix];
//	CGAffineTransform xform2 = [graphic2 concatenatedMatrix];
//	CGAffineTransform xform3 = [graphic3 concatenatedMatrix];
//	STAssertFalse( [graphic1 _concatenatedMatrixIsDirty], @"doh" );
//	STAssertFalse( [graphic2 _concatenatedMatrixIsDirty], @"doh" );
//	STAssertFalse( [graphic3 _concatenatedMatrixIsDirty], @"doh" );
//	
//	// check that the concated matrix is correct
//	STAssertTrue( CGPointEqualToPoint( CGPointMake(10, 10), CGPointApplyAffineTransform( CGPointZero, xform1 )), @"doh" );
//	STAssertTrue( CGPointEqualToPoint( CGPointMake(20, 20), CGPointApplyAffineTransform( CGPointZero, xform2 )), @"doh" );
//	STAssertTrue( CGPointEqualToPoint( CGPointMake(30, 30), CGPointApplyAffineTransform( CGPointZero, xform3 )), @"doh" );

	// check that it cascades
//october09	graphic2.position = CGPointMake( 5, 10 );
//october09	STAssertFalse( graphic1->_concatenatedMatrixIsDirty, @"doh" );
//october09	STAssertTrue( graphic2->_concatenatedMatrixIsDirty, @"doh" );
//october09	STAssertTrue( graphic3->_concatenatedMatrixIsDirty, @"doh" );
	
//october09	xform3 = [graphic3 concatenatedMatrix];
//october09	STAssertFalse( graphic1->_concatenatedMatrixIsDirty, @"doh" );
//october09	STAssertFalse( graphic2->_concatenatedMatrixIsDirty, @"doh" );
//october09	STAssertFalse( graphic3->_concatenatedMatrixIsDirty, @"doh" );
	
//october09	STAssertTrue( CGPointEqualToPoint(CGPointMake(25, 30), CGPointApplyAffineTransform( CGPointZero, xform3 )), @"doh" );
//}

@end
