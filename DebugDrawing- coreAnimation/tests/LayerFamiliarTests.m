//
//  LayerFamiliarTests.m
//  DebugDrawing
//
//  Created by steve hooley on 18/07/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//


#import "LayerFamiliar.h"
#import "ColourUtilities.h"

@interface LayerFamiliarTests : SenTestCase {
	
	LayerFamiliar *_layerFamiliar;
	NSUInteger _matrixChangedCount, _geomRectChangeCount;
}

@end

@implementation LayerFamiliarTests

- (void)setUp {

	_layerFamiliar = [[LayerFamiliar alloc] init];
	[_layerFamiliar enforceConsistentState];

	_matrixChangedCount = 0;
	_geomRectChangeCount = 0;
}

- (void)tearDown {

	[_layerFamiliar release];
}

- (void)testDidDrawAt {
 // - (CGRect)didDrawAt:(CGContextRef)cntx

	size_t components = 4;
	size_t bitsPerComponent = 8;
	size_t bytesPerRow = (1 * bitsPerComponent * components + 7)/8;
	size_t dataLength = bytesPerRow * 1;
	UInt32 *bitmap = malloc( dataLength );
	memset( bitmap, 0, dataLength );
	
	CGContextRef cntx = CGBitmapContextCreate (
											   bitmap,
											   1, 1,
											   bitsPerComponent,
											   bytesPerRow, // bytes per row
											   [ColourUtilities genericRGBSpace],
											   kCGImageAlphaPremultipliedFirst
											   );

	
	_layerFamiliar.geometryRect = CGRectMake(0,0,10,10);
	_layerFamiliar.position = CGPointMake(10,10);	
	[_layerFamiliar enforceConsistentState];
	
	[_layerFamiliar applyMatrixToContext:cntx];
	CGRect drawAtRect1 = [_layerFamiliar didDrawAt:cntx];
	[_layerFamiliar restoreContext:cntx];
		
	STAssertTrue( nearlyEqualCGRects( drawAtRect1, CGRectMake(10,10,10,10) ), @"hmm %@", NSStringFromCGRect(drawAtRect1) );
	
	CGContextTranslateCTM( cntx, 10, 10);
	[_layerFamiliar applyMatrixToContext:cntx];
	CGRect drawAtRect2 = [_layerFamiliar didDrawAt:cntx];
	[_layerFamiliar restoreContext:cntx];

	STAssertTrue( nearlyEqualCGRects( drawAtRect2, CGRectMake(20,20,10,10) ), @"hmm %@", NSStringFromCGRect(drawAtRect2) );

	CGContextRelease( cntx );
	free(bitmap);
}

//june09- (void)testTransformedGeometryRectBoundingBox {
	// - (CGRect)transformedGeometryRectBoundingBox 
	
//	_xForm.DEBUG_drawingDestination = self;
	
//	CGRect srcRect1 = CGRectMake(0,0,2,2);
//june09	CGRect targetRect1 = CGRectMake(-1,-1,4,4);

//	_geom.geometryRect = srcRect1;

//	[_xForm setScale:2.0];
//	[_xForm setPosition:CGPointMake(1,1)];
//	[_xForm setAnchorPt:CGPointMake(1, 1)];
//	[_xForm enforceConsistentState];

//june09	STAssertTrue( CGRectEqualToRect( [_layerFamiliar transformedGeometryRectBoundingBox], targetRect1), @"eh? %@", NSStringFromCGRect( [_layerFamiliar transformedGeometryRectBoundingBox]) );
//	STAssertTrue( CGRectEqualToRect( [_xForm didDrawAt], targetRect1 ) , @"%@", NSStringFromCGRect([_xForm didDrawAt]));

//	[_xForm drawWithHint:SKTGraphicNormalFill];

//	STAssertTrue( CGRectEqualToRect( lastDrawnRect, targetRect1 ) , @"%@", NSStringFromCGRect(lastDrawnRect));

//	CGRect srcRect2 = CGRectMake(0,0,1,2);
//	CGRect targetRect2 = CGRectMake(-1,-1,2,4);

//	_geom.geometryRect = srcRect2;

//june09	[_layerFamiliar enforceConsistentState];
//june09	STAssertTrue( CGRectEqualToRect( [_layerFamiliar transformedGeometryRectBoundingBox], targetRect2), @"eh? %@", NSStringFromCGRect([_layerFamiliar transformedGeometryRectBoundingBox]) );
//	[_xForm drawWithHint:SKTGraphicNormalFill];
//	STAssertTrue( CGRectEqualToRect( lastDrawnRect, targetRect2 ) , @"%@", NSStringFromCGRect(lastDrawnRect));
//	STAssertTrue( CGRectEqualToRect( [_xForm didDrawAt], targetRect2 ) , @"%@", NSStringFromCGRect([_xForm didDrawAt]));
//june09}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(NSObject *)observedObject change:(NSDictionary *)change context:(void *)vcontext {
	
	NSString *context = (NSString *)vcontext;
	NSAssert( [context isEqualToString:@"LayerFamiliarTests"], @"doh");

    if( [context isEqualToString:@"LayerFamiliarTests"] )
	{
        if ([keyPath isEqualToString:@"transformMatrix"])
        {
			_matrixChangedCount++;
			return;
		} else if ([keyPath isEqualToString:@"geometryRect"]) {
			_geomRectChangeCount++;
			return;
		}
	}
	[super observeValueForKeyPath:keyPath ofObject:observedObject change:change context:vcontext];
}

- (void)testObservancies {
		
	[_layerFamiliar addObserver:self forKeyPath:@"geometryRect" options:0 context:@"LayerFamiliarTests"];
	[_layerFamiliar addObserver:self forKeyPath:@"transformMatrix" options:0 context:@"LayerFamiliarTests"];
	STAssertThrows([_layerFamiliar addObserver:self forKeyPath:@"chicken" options:0 context:@"LayerFamiliarTests"], @"meaningless");
	
	_layerFamiliar.geometryRect = CGRectMake(0,0,10,10);
	_layerFamiliar.position = CGPointMake(10,10);
	_layerFamiliar.scale = 2.0f;
	_layerFamiliar.rotation = 12.0f;
	
	[_layerFamiliar enforceConsistentState];

	STAssertTrue( _matrixChangedCount==1, @"dog %i", _matrixChangedCount );
	STAssertTrue( _geomRectChangeCount==1, @"dog %i", _geomRectChangeCount );
	
	[_layerFamiliar removeObserver:self forKeyPath:@"geometryRect"];
	[_layerFamiliar removeObserver:self forKeyPath:@"transformMatrix"];
}

- (void)testSomeAccessors {

	STAssertTrue( CGPointEqualToPoint( _layerFamiliar.position, CGPointMake(0.0f,0.0f)), @"not ready");
	STAssertTrue( G3DCompareFloat(_layerFamiliar.rotation, 0.0f, 0.01f)==0, @"not ready");
	STAssertTrue( G3DCompareFloat(_layerFamiliar.scale, 1.0f, 0.01f)==0, @"not ready");
	
	STAssertNotNil( [_layerFamiliar xForm], @"yeah");
}

@end
