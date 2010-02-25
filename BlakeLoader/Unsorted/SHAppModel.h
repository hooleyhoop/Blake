//
//  SHAppModel.h
//  InterfaceTest
//
//  Created by Steve Hool on Fri Dec 26 2003.
//  Copyright (c) 2003 HooleyHoop. All rights reserved.
//

@class SHAppControl, SHNodeGraphInspector_C, SHObjPaletteControl, SHObjPaletteModel, ResourceManager;
@class SHFScriptControl, SHObjectListControl, SHPropertyInspectorControl, SHNodeGraphModel, SHBundleLoader;
@class SHPlugInViewManager, SHFScriptLoader;


@interface SHAppModel : SHooleyObject {


    IBOutlet SHAppControl				*_theSHAppControl;
//blake	SHNodeGraphModel					*_nodeGraphModel;
	
	// link to the status bar
	// StatusBar						*theSStatusbar;
//blake	SHPlugInViewManager					*_viewPlugInManager;
	
//blake	SHFScriptLoader						*_fscriptLoader;

	
//	NSMutableArray						*_theViews, *_theOperators, *_theframeworks;
//RR	ResourceManager						*myResourceManager;
//RR	OutputControl						*myOutputControl;
}

#pragma mark -
#pragma mark class methods
+ (SHAppModel*)appModel;

#pragma mark init methods
- (id)init;

- (void)setUpApp;


@end
