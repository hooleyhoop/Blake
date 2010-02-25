//
//  SHTopLeftRightDelegate.h
//  InterfaceTest
//
//  Created by Steve Hooley on 27/11/2004.
//  Copyright 2004 HooleyHoop. All rights reserved.
//

@class SHViewport;

@interface SHTopLeftRightDelegate : SHooleyObject {


	IBOutlet SHViewport *_topLeftSHViewport;
	IBOutlet SHViewport *_topRightSHViewport;
	
}

- (void)splitViewDidResizeSubviews:(NSNotification *)aNotification;

- (void)resizeSHViewports;


@end
