//
//  SHObjPaletteModel.h
//  InterfaceTest
//
//  Created by Steve Hool on Mon Dec 29 2003.
//  Copyright (c) 2003 HooleyHoop. All rights reserved.
//

//#import "SHViewControllerProtocol.h"
//#import "SHCustomViewProtocol.h";
@class SHObjPaletteControl, AppModel, SHNodeRegister, SHScript;


@interface SHObjPaletteModel : _ROOT_OBJECT_ {

//	AppModel							*theSHAppView;
    SHObjPaletteControl					*theSHObjPaletteControl;
	SHNodeRegister						*theSHNodeRegister;
}
#pragma mark --
#pragma mark class methods
+ (SHObjPaletteModel*) objPaletteModel;

#pragma mark init methods
- (id)initWithController:(id<SHViewControllerProtocol>)aController;

#pragma mark action methods
- (void)test_addNodes;

- (int) addNodeToCurrentNodeGroup:(NSString*)aNodeType fromGroup:(NSString*)aNodeGroup0;
- (int) addNodeToCurrentNodeGroup:(NSString*)aNodeType fromGroup:(NSString*)aNodeGroup0 fromGroup:(NSString*)aNodeGroup1;

#pragma mark accessor methods
- (SHNodeRegister *)theSHNodeRegister;
//- (void)setTheSHNodeRegister:(SHNodeRegister *)aTheSHNodeRegister;

- (SHObjPaletteControl *)theSHObjPaletteControl;
//- (void)setTheSHObjPaletteControl:(SHObjPaletteControl *)aTheSHObjPaletteControl;

- (void) setLoadedOperators:(NSMutableDictionary*)dynLoadedOperators;

//- (AppModel *)theSHAppView;
//- (void)setTheAppModel:(AppModel *)aTheAppModel;

#pragma mark Private methods


@end

