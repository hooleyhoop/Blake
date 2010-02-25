//
//  SHFScriptModel.m
//  Pharm
//
//  Created by Steve Hooley on 11/06/2005.
//  Copyright 2005 HooleyHoop. All rights reserved.
//

#import "SHFScriptModel.h"
#import "SHFScriptControl.h"

// singleton type thing
static SHFScriptModel* _fScriptModel;

@implementation SHFScriptModel


#pragma mark -
#pragma mark class methods
// ===========================================================
// + fScriptModel:
// ===========================================================
+ (SHFScriptModel*) fScriptModel {
	return _fScriptModel;
}

#pragma mark init methods
//=========================================================== 
// - initWithController:
//=========================================================== 
- (id)initWithController:(id<SHViewControllerProtocol>)aController
{
    if ((self = [super init]) != nil)
    {
		// init code
		_fScriptModel = self;

		_theSHFScriptControl = (SHFScriptControl*)aController;

		// NSLog(@"SHFScriptModel.m: initing SHObjPaletteModel");
		// [self awakeFromNib];
	}
    return self;
}


//=========================================================== 
// dealloc
//=========================================================== 
- (void) dealloc {


    _theSHFScriptControl = nil;
    _theFSInterpreter = nil;
    [super dealloc];
}

// ===========================================================
// - awakeFromNib:
// ===========================================================
- (void) awakeFromNib
{
}

#pragma mark action methods
// ===========================================================
// - setObject: forIdentifier:
// ===========================================================
- (void) setObject:(id)obj forIdentifier:(NSString*) str
{
	[_theFSInterpreter setObject:obj forIdentifier:str];	// add variables
}

#pragma mark accessor methods
//=========================================================== 
// - theFSInterpreter:
//=========================================================== 
- (FSInterpreter *)theFSInterpreter { return _theFSInterpreter; }

//=========================================================== 
// - setTheFSInterpreter:
//=========================================================== 
- (void)setTheFSInterpreter:(FSInterpreter *)a_theFSInterpreter
{
    if (_theFSInterpreter != a_theFSInterpreter) {
        [a_theFSInterpreter retain];
        [_theFSInterpreter release];
        _theFSInterpreter = a_theFSInterpreter;
    }
}

@end
