//
//  TemporaryRealViewStuff.h
//  BlakeLoader
//
//  Created by steve hooley on 19/05/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "SKTUserAdaptor.h"

@class SKTGraphicViewController, SHooleyObject, SKTTool;


@interface TemporaryRealViewStuff : SHView {

	IBOutlet SKTGraphicViewController		*_sketchViewController;	//-- viewController is the contentSource
	
	id<SKTUserAdaptor>						_mouseInputAdaptor;
}

@property (assign, readwrite, nonatomic) SKTGraphicViewController *sketchViewController;
@property (retain, readwrite, nonatomic) id<SKTUserAdaptor> mouseInputAdaptor;

@end
