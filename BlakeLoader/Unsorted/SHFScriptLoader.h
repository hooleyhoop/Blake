//
//  SHFScriptLoader.h
//  Pharm
//
//  Created by Steve Hooley on 24/01/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

@class SHAppModel;

@interface SHFScriptLoader : SHooleyObject {

	SHAppModel*			_appModel;
}

#pragma mark -
#pragma mark class methods

#pragma mark init methods
- (id)initWithAppModel:(SHAppModel*)appModel;


#pragma mark action methods
- (void)doScript:(NSString*)stringName;


#pragma mark accessorizor methods

@end
