//
//  SHApplication.h
//  Blake
//
//  Created by Steve Hooley on 22/04/2007.
//  Copyright 2007 HooleyHoop. All rights reserved.
//

/*
 * This must be the principle class of our app in order to substitute this class for the default NSApplication
*/
@interface SHApplication : NSApplication <SHAppProtocol> {

	Class _aboutPanelClass;
}

#pragma mark -
- (void)setAboutPanelClass:(Class)aClass;

@end
