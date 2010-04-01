//
//  ItemRotationManipulation.m
//  DebugDrawing
//
//  Created by steven hooley on 17/08/2009.
//  Copyright 2009 Bestbefore. All rights reserved.
//

#import "ItemRotationManipulation.h"


@implementation ItemRotationManipulation

// currentMouseLocation
// centrePoint
// initialAngleFromYaxis2
// startRotation

+ (void)rotateItem:(Graphic *)graphicToRotate byAngleBetweenPt:(NSPoint)mm andPt:(NSPoint)currentMouseLocation {
	
//	CGPoint yAxis = CGPointMake( centrePoint.x, centrePoint.y+1.0f );
//
//	CGFloat newAngleFromYaxis2= [RotateTool angleBetweenTwoPts:yAxis :currentMouseLocation centre: centrePoint];
//	CGFloat totalAngleRotatedDuringDrag = newAngleFromYaxis2 - initialAngleFromYaxis2;
//
//	[graphicToRotate setRotation:startRotation-totalAngleRotatedDuringDrag];
}

@end
