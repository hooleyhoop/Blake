//
//  SHCustomViewController.h
//  Pharm
//
//  Created by Steve Hooley on 11/08/2005.
//  Copyright 2005 HooleyHoop. All rights reserved.
//

#import "SHCustomViewProtocol.h"

@class SHAppControl, SHAuxWindow;

@interface SHCustomViewController : _ROOT_OBJECT_ {
	
    SHAppControl						*_theAppControl;

	BOOL								_isInViewPort;
	BOOL								_isInWindow;
	BOOL								_enabled;
    IBOutlet id<SHCustomViewProtocol>	_swapableView;

}

#pragma mark -
#pragma mark init methods

#pragma mark action methods
- (void) hasBeenLaunchedInWindow;

- (void) willBeRemovedFromViewPort;
- (void) willBeAddedToViewPort;

- (void) syncViewWithModel;

- (void) enable;
- (void) disable;

#pragma mark accessor methods
- (id<SHCustomViewProtocol>) swapableView;

- (SHAppControl*)theAppControl;

- (BOOL) isInViewPort;
- (void) setIsInViewPort: (BOOL) flag;
- (BOOL) isInWindow;
- (void) setIsInWindow: (BOOL) flag;

+ (NSString*) windowTitle;

@end