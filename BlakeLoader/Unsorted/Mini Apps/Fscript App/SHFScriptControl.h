//
//  SHFScriptControl.h
//  Pharm
//
//  Created by Steve Hooley on 11/06/2005.
//  Copyright 2005 HooleyHoop. All rights reserved.
//

//#import "SHViewControllerProtocol.h"
//#import "SHCustomViewProtocol.h"
//#import "SHCustomViewController.h"


@class SHFScriptModel, SHFScriptView, SHAppControl;


@interface SHFScriptControl : SHCustomViewController <SHViewControllerProtocol>
{
  //  SHAppControl			*_theAppControl;
    SHFScriptModel			*_theSHFScriptModel;
   // SHFScriptView			*_theSHFScriptView;
}

#pragma mark -
#pragma mark init methods
- (id)initWithSHAppControl:(SHAppControl*)anAppControl;

#pragma mark action methods
- (void) willBeRemovedFromViewPort;
- (void) willBeAddedToViewPort;

#pragma mark accessor methods

- (SHFScriptModel *) theSHFScriptModel;

// - (SHFScriptView *) theSHFScriptView;

@end
