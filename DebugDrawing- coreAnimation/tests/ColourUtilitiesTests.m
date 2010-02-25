//
//  ColourUtilitiesTests.m
//  DebugDrawing
//
//  Created by steve hooley on 14/07/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//


#import "ColourUtilities.h"


@interface ColourUtilitiesTests : SenTestCase {
	
}

@end


@implementation ColourUtilitiesTests

- (void)setUp {

}

- (void)tearDown {

}

- (void)testGenericRGBSpace {
	//+ (CGColorSpaceRef)genericRGBSpace
	
	CGColorSpaceRef colSpace = [ColourUtilities genericRGBSpace];
	STAssertTrue( colSpace!=NULL, @"doh");
}

- (void)testLinearRGBSpace {
	// + (CGColorSpaceRef)linearRGBSpace

	CGColorSpaceRef colSpace = [ColourUtilities linearRGBSpace];
	STAssertTrue( colSpace!=NULL, @"doh");
}

- (void)testBlack {
	//+ (CGColorRef)black
	
	CGColorRef black = [ColourUtilities black];
	STAssertTrue( CGColorGetNumberOfComponents(black)==4, @"color failed? %i", CGColorGetNumberOfComponents(black));
}
	
- (void)testWhite {
	//+ (CGColorRef)white
	
	CGColorRef white = [ColourUtilities white];
	STAssertTrue( CGColorGetNumberOfComponents(white)==4, @"color failed? %i", CGColorGetNumberOfComponents(white));
}
		
- (void)testColor {
	// + (CGColorRef)newColorRef:(CGFloat)r :(CGFloat)g :(CGFloat)b :(CGFloat)a
	
	CGColorRef aCol = [ColourUtilities newColorRef:0.4f :0.3f :0.2f :0.1f];
	STAssertTrue( CGColorGetNumberOfComponents(aCol)==4, @"color failed? %i", CGColorGetNumberOfComponents(aCol));
	STAssertTrue( G3DCompareFloat(CGColorGetAlpha(aCol), 0.1f, 0.001f)==0, @"doh! %f", CGColorGetAlpha(aCol) );
	CGColorRelease(aCol);
	
	CGColorRef aCol2 = [ColourUtilities newColorRef:0.4f :0.3f :0.2f :0.3f];
	STAssertTrue( G3DCompareFloat(CGColorGetAlpha(aCol2), 0.3f, 0.001f)==0, @"doh! %f", CGColorGetAlpha(aCol2) );
	CGColorRelease(aCol2);
}
			
- (void)testBackgroundColour {
	// + (CGColorRef)backgroundColour
	
	CGColorRef backCol = [ColourUtilities backgroundColour];
	STAssertTrue( CGColorGetNumberOfComponents(backCol)==4, @"color failed? %i", CGColorGetNumberOfComponents(backCol));
}
	
@end
