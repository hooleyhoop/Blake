//
//  ColourUtilities.h
//  DebugDrawing
//
//  Created by steve hooley on 01/07/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

@interface ColourUtilities : _ROOT_OBJECT_ {

}

+ (CGColorSpaceRef)genericRGBSpace;
+ (CGColorSpaceRef)linearRGBSpace;

+ (CGColorRef)black;
+ (CGColorRef)white;
+ (CGColorRef)backgroundColour;

// generate an arbitrary colour that will need releaseing
+ (CGColorRef)newColorRef:(CGFloat)r :(CGFloat)g :(CGFloat)b :(CGFloat)a;

@end
