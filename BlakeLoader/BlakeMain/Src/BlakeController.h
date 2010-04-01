//
//  BlakeController.h
//  Blake
//
//  Created by Steve Hooley on 06/03/2007.
//  Copyright 2007 HooleyHoop. All rights reserved.
//

#import "BKLifecycleProtocols.h"
@class BlakeAboutBoxController;


/*
 * This is the main class for the plugin. Initializaton is done by pluginManager
*/
@interface BlakeController : _ROOT_OBJECT_ <BKLifecycleProtocol> {
	
	BlakeAboutBoxController		*_aboutBoxController;
//	BOOL						didFinishLaunching;
}

#pragma mark -
#pragma mark class methods
+ (BlakeController *)blakeController;

//@property (nonatomic) BOOL didFinishLaunching;

@end
