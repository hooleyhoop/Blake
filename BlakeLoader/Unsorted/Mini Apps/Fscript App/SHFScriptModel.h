//
//  SHFScriptModel.h
//  Pharm
//
//  Created by Steve Hooley on 11/06/2005.
//  Copyright 2005 HooleyHoop. All rights reserved.
//

//#import "SHViewControllerProtocol.h"
//#import "SHCustomViewProtocol.h";

@class SHFScriptControl, FSInterpreter;


@interface SHFScriptModel : SHooleyObject {

	SHFScriptControl*		_theSHFScriptControl;
	FSInterpreter*			_theFSInterpreter;

}

#pragma mark -
#pragma mark class methods
+ (SHFScriptModel*) fScriptModel;


#pragma mark init methods
- (id)initWithController:(id<SHViewControllerProtocol>)aController;

#pragma mark action methods
- (void) setObject:(id)obj forIdentifier:(NSString*) str;

#pragma mark accessor methods
- (FSInterpreter *)theFSInterpreter;
- (void) setTheFSInterpreter:(FSInterpreter*)a_theFSInterpreter;


@end
