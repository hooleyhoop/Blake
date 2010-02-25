//
//  SHAppControl.h
//  Pharm
//
//  Created by Steve Hooley on 01/04/2007.
//  Copyright 2007 HooleyHoop. All rights reserved.
//


@class SHBundleLoader;

/*
 * App control initiates the loading of plugins and stuff
*/
@interface SHAppControl : _ROOT_OBJECT_ {

	SHBundleLoader *_SHBundleLoader;
}

#pragma mark -
#pragma mark class methods
+ (SHAppControl *)appControl;

@end
