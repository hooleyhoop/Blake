//
//  ApplescriptGUI.h
//  InAppTests
//
//  Created by steve hooley on 11/01/2010.
//  Copyright 2010 BestBefore Ltd. All rights reserved.
//

@interface ApplescriptGUI : NSObject {

}

#pragma mark TextField
+ (NSString *)getValueOfTextField:(NSUInteger)txtFieldIndex windowName:(NSString *)windowName app:(NSString *)appName;
+ (NSString *)setValueOfTextfield:(NSUInteger)txtFieldIndex windowName:(NSString *)windowName app:(NSString *)appName toString:(NSString *)newValue;

#pragma mark PopUpButtons
+ (NSString *)getTextOfDropDownMenuItemOfApp:(NSString *)appName windowName:(NSString *)windowName;
+ (NSString *)selectPopUpButtonItem:(NSString *)itemName ofApp:(NSString *)appName windowName:(NSString *)windowName;

#pragma mark Main Menus	
+ (NSString *)openMainMenuItem:(NSString *)menuName ofApp:(NSString *)appName;
+ (NSString *)doMainMenuItem:(NSString *)itemName ofMenu:(NSString *)menuName ofApp:(NSString *)appName;
+ (NSString *)statusOfMenuItem:(NSString *)itemName ofMenu:(NSString *)menuName ofApp:(NSString *)appName;

#pragma mark Off the Wall
+ (NSString *)attachGDBToTask:(int)pid file:(NSString *)fileName;
+ (NSString *)doScript:(NSString *)scriptFileName method:(NSString *)scriptMethodName;

@end
