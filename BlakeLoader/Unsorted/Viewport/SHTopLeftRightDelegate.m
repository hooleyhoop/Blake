//
//  SHTopLeftRightDelegate.m
//  InterfaceTest
//
//  Created by Steve Hooley on 27/11/2004.
//  Copyright 2004 HooleyHoop. All rights reserved.
//

#import "SHTopLeftRightDelegate.h"


/*
 *
*/
@implementation SHTopLeftRightDelegate



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
	[_topLeftSHViewport layOutAtNewSize];
	[_topRightSHViewport layOutAtNewSize];
}



@end
