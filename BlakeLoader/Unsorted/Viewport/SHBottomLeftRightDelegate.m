//
//  SHBottomLeftRightDelegate.m
//  InterfaceTest
//
//  Created by Steve Hooley on 27/11/2004.
//  Copyright 2004 HooleyHoop. All rights reserved.
//

#import "SHBottomLeftRightDelegate.h"


/*
 *
*/
@implementation SHBottomLeftRightDelegate


// ===========================================================
// - splitViewDidResizeSubviews:
// ===========================================================
- (void)splitViewDidResizeSubviews:(NSNotification *)aNotification
{
	[self resizeSHViewports];
}


// ===========================================================
// - resizeSHViewports:
// ===========================================================
- (void)resizeSHViewports
{
	[_bottomLeftSHViewport layOutAtNewSize];
	[_bottomRightSHViewport layOutAtNewSize];
}

@end
