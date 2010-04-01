//
//  ItemRotationManipulation.h
//  DebugDrawing
//
//  Created by steven hooley on 17/08/2009.
//  Copyright 2009 Bestbefore. All rights reserved.
//

@class Graphic;

@interface ItemRotationManipulation : _ROOT_OBJECT_ {

}

+ (void)rotateItem:(Graphic *)graphicToRotate byAngleBetweenPt:(NSPoint)lastPoint andPt:(NSPoint)currentMouseLocation;

@end
