//
//  SHFScriptControl.m
//  Pharm
//
//  Created by Steve Hooley on 11/06/2005.
//  Copyright 2005 HooleyHoop. All rights reserved.
//

#import "SHFScriptControl.h"
#import "SHFScriptModel.h"
#import "SHFScriptView.h"
#import "SHAppControl.h"

@implementation SHFScriptControl

#pragma mark -
#pragma mark init methods
//=========================================================== 
// - initWithAppControl:
//=========================================================== 
- (id)initWithSHAppControl:(SHAppControl*)anAppControl
{
    if ((self = [super init]) != nil)
    {
		_theAppControl		= anAppControl;
		_theSHFScriptModel	= [[SHFScriptModel alloc]initWithController:self];
		_swapableView		= [[SHFScriptView alloc]initWithController:self];
		// NSLog(@"SHFScriptControl.m: initing initWithAppControl");
		[self awakeFromNib];
	}
    return self;
}


//=========================================================== 
// dealloc
//=========================================================== 
- (void) dealloc {
	[_theSHFScriptModel release];
	[(id)_swapableView release];
	_swapableView = nil;
	_theSHFScriptModel = nil;
    _theAppControl = nil;
    [super dealloc];
}


// ===========================================================
// - awakeFromNib:
// ===========================================================
- (void) awakeFromNib
{
	// [theSHObjPaletteView reloadColumn:0];
	
}

#pragma mark action methods
- (void) willBeRemovedFromViewPort{};
- (void) willBeAddedToViewPort{};


#pragma mark accessor methods
// ===========================================================
// - theSHFScriptModel:
// ===========================================================
- (SHFScriptModel *) theSHFScriptModel { return _theSHFScriptModel; }



@end
