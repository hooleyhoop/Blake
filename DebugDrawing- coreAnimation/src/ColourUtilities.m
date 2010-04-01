//
//  ColourUtilities.m
//  DebugDrawing
//
//  Created by steve hooley on 01/07/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "ColourUtilities.h"


@implementation ColourUtilities

+ (CGColorSpaceRef)genericRGBSpace {

	static CGColorSpaceRef space = NULL;
	if(NULL == space) {
		space = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
	}
	return space;
}

+ (CGColorSpaceRef)linearRGBSpace {
	
	static CGColorSpaceRef space = NULL;
	if(NULL == space) {
		space = CGColorSpaceCreateWithName(kCGColorSpaceSRGB);
	}
	return space;
}

+ (CGColorRef)black {

	static CGColorRef black = NULL;
	if(black == NULL) {
		CGFloat values[4] = {0.0f, 0.0f, 0.0f, 1.0f};
		black = CGColorCreate([self genericRGBSpace], values);
	}
	return black;
}

+ (CGColorRef)white {

	static CGColorRef white = NULL;
	if(white == NULL) {
		CGFloat values[4] = {1.0f, 1.0f, 1.0f, 1.0f};
		white = CGColorCreate([self genericRGBSpace], values);
	}
	return white;
}

+ (CGColorRef)newColorRef:(CGFloat)r :(CGFloat)g :(CGFloat)b :(CGFloat)a {

	CGFloat values[4] = {r, g, b, a};
	CGColorRef aColour = CGColorCreate([self genericRGBSpace], values);
	return aColour;
}

+ (CGColorRef)backgroundColour {

	static CGColorRef backgroundColour = NULL;
	if(backgroundColour == NULL) {
		CGFloat values[4] = {0.8f, 0.8f, 0.8f, 1.0f};
		backgroundColour = CGColorCreate([self genericRGBSpace], values);
	}
	return backgroundColour;
}


@end
