//
//  SHPlugInViewManager.h
//  Pharm
//
//  Created by Steve Hooley on 10/01/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

@class SHAppModel;

@interface SHPlugInViewManager : SHooleyObject {

	SHAppModel*		_appModel;

}

#pragma mark -
#pragma mark class methods

#pragma mark init methods
- (id)initWithAppModel:(SHAppModel*)appModel;

- (void)createViewControllersFromLoadedPlugins;


#pragma mark action methods

- (void)requestSetViewport:(NSString*)aViewPortName withViewControl:(NSString*)aViewControlClass;

- (void)requestLaunchViewControlInOwnWindow:(NSString*)aViewControlClass;

- (void)instantiateViewControllerClass:(Class)aViewControllerClass;


#pragma mark accessorizor methods


@end
