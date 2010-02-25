//
//  SHBottomLeftRightDelegate.h
//  InterfaceTest
//
//  Created by Steve Hooley on 27/11/2004.
//  Copyright 2004 HooleyHoop. All rights reserved.
//

@class SHViewport;

@interface SHBottomLeftRightDelegate : SHooleyObject {

	IBOutlet SHViewport *_bottomLeftSHViewport;
	IBOutlet SHViewport *_bottomRightSHViewport;
}

- (void)splitViewDidResizeSubviews:(NSNotification *)aNotification;

- (void)resizeSHViewports;

@end
