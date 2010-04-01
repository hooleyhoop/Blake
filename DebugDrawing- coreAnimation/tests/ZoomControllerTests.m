//
//  ZoomControllerTests.m
//  DebugDrawing
//
//  Created by shooley on 06/09/2009.
//  Copyright 2009 bestbefore. All rights reserved.
//

#import "ZoomController.h"

@interface ZoomControllerTests : SenTestCase {
	
	ZoomController *_zoomer;
}

@end

@implementation ZoomControllerTests

static CGAffineTransform _zoomMatrix;
static NSUInteger _zoomChanged;

- (void)reset {
	
	_zoomChanged = 0;
	_zoomMatrix = CGAffineTransformIdentity;
}

- (void)setUp {
	
	_zoomer = [[ZoomController alloc] init];
	[_zoomer addObserver:self forKeyPath:@"zoomMatrix" options:0 context: @"ZoomController"];
	
	[self reset];
}

- (void)tearDown {
	
	[_zoomer removeObserver:self forKeyPath:@"zoomMatrix"];
	[_zoomer release];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(NSObject *)observedObject change:(NSDictionary *)change context:(void *)vcontext {
	
	NSString *context = (NSString *)vcontext;
    if( [context isEqualToString:@"ZoomController"] )
	{
        if ([keyPath isEqualToString:@"zoomMatrix"])
        {
			_zoomChanged++;
			_zoomMatrix = [(ZoomController *)observedObject zoomMatrix];
			return;
		}
	}
	[super observeValueForKeyPath:keyPath ofObject:observedObject change:change context:vcontext];
}

- (void)testpanByXy {
	// - (void)panByX:(CGFloat)xVal y:(CGFloat)yVal
	
	[_zoomer panByX:10 y:10];
	STAssertTrue( _zoomChanged==1, @"doh");
}

- (void)testSetCentrePt {
	// - (void)setCentrePt:(CGPoint)pt
	
	[_zoomer setCentrePt:CGPointMake(10,10)];
	STAssertTrue( _zoomChanged==1, @"doh");
}

- (void)testZoomByXY {
	//- (void)zoomByX:(CGFloat)xVal y:(CGFloat)yVal

	[_zoomer zoomByX:2.0f y:2.0f];
	STAssertTrue( _zoomChanged==1, @"doh");
	
	CGAffineTransform expectedXForm = CGAffineTransformMakeScale( 2.0f, 2.0f );
	CGAffineTransform newMatrix = [_zoomer zoomMatrix];
	
	STAssertTrue( CGAffineTransformEqualToTransform( newMatrix, expectedXForm ), @"doh!" );
}

- (void)testUpdateMatrix {
	// - (void)updateMatrix
	
	[_zoomer updateMatrix];
	STAssertTrue( _zoomChanged==1, @"doh");
}

// Is it possible to work out the toatl concat of a node, then concat that with the view's xForm?
- (void)testMatrixOrderOfOperations {
	
	CATransform3D xForm1 = CATransform3DMakeScale( 2.0f, 4.0f, 1.0f );
	xForm1 = CATransform3DTranslate( xForm1, 2, 3, 4 );
	CATransform3D xForm2 = CATransform3DMakeScale( 3.0f, 5.0f, 1.0f );
	xForm2 = CATransform3DTranslate( xForm2, 2, 3, 4 );
	CATransform3D xForm3 = CATransform3DMakeScale( 4.0f, 6.0f, 1.0f );
	xForm3 = CATransform3DTranslate( xForm3, 2, 3, 4 );

	CATransform3D resultXForm1 = CATransform3DConcat (xForm1, xForm2);
	CATransform3D resultXForm2 = CATransform3DConcat( resultXForm1, xForm3 );

	CATransform3D resultXForm3 = CATransform3DConcat( xForm2, xForm3);
	CATransform3D resultXForm4 = CATransform3DConcat( xForm1, resultXForm3);
	
	STAssertTrue( CATransform3DEqualToTransform( resultXForm2, resultXForm4), @"doh!" );

	// YAY - it seems so!
}


@end
