//
//  SHFScriptView.h
//  Pharm
//
//  Created by Steve Hooley on 11/06/2005.
//  Copyright 2005 HooleyHoop. All rights reserved.
//

// #import "SHSwapableView.h"

@class SHFSInterpreterView, FSInterpreter, SHCustomViewController;

@interface SHFScriptView : SHSwapableView {

	SHFSInterpreterView*	_SHFSInterpreterView;
}


#pragma mark -
#pragma mark init methods
- (id)initWithController:(SHCustomViewController<SHViewControllerProtocol>*)aController;


#pragma mark accessor methods


@end
