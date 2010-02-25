//
//  ApplescriptGUI.h
//  InAppTests
//
//  Created by steve hooley on 11/01/2010.
//  Copyright 2010 BestBefore Ltd. All rights reserved.
//

@interface ApplescriptGUI : NSObject {

}

+ (void)openMainMenuItem:(NSString *)menuName ofApp:(NSString *)appName;
+ (void)doMainMenuItem:(NSString *)itemName ofMenu:(NSString *)menuName ofApp:(NSString *)appName;
+ (id)statusOfMenuItem:(NSString *)itemName ofMenu:(NSString *)menuName ofApp:(NSString *)appName;

@end
