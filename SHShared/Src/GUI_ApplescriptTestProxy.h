//
//  GUI_ApplescriptTestProxy.h
//  SHShared
//
//  Created by steve hooley on 29/04/2010.
//  Copyright 2010 BestBefore Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GUITestProxy.h"

struct HooAppleScriptFactory 
{
	NSString *name;
	NSString *className;
	NSString *selector;
	NSArray *args;
	BOOL recievesAsync;
};

@interface GUI_ApplescriptTestProxy : GUITestProxy {

}

#pragma mark Main Menu
+ (GUITestProxy *)openMainMenuItem:(NSString *)menuName;
+ (GUITestProxy *)statusOfMenuItem:(NSString *)val1 ofMenu:(NSString *)val2;
+ (GUITestProxy *)doMenu:(NSString *)val1 item:(NSString *)val2;

#pragma mark Popup Button
+ (GUITestProxy *)dropDownMenuButtonText:(NSString *)windowName;
+ (GUITestProxy *)selectPopUpButtonItem:(NSString *)itemName window:(NSString *)windowName;

#pragma mark TextField
+ (GUITestProxy *)getValueOfTextField:(NSUInteger)txtFieldIndex ofWindow:(NSString *)windowName;
+ (GUITestProxy *)setValueOfTextfield:(NSUInteger)txtFieldIndex ofWindow:(NSString *)windowName toValue:(NSString *)newValue;

#pragma mark Table
+ (GUITestProxy *)countOfRowsInTableScroll:(NSString *)tableScrollName ofWindow:(NSString *)windowName;
+ (GUITestProxy *)indexesOfSelectedRowsInTableScroll:(NSString *)tableScrollName ofWindow:(NSString *)windowName;
+ (GUITestProxy *)selectRowAtIndex:(NSUInteger)tableRow inTableScroll:(NSString *)tableScrollName ofWindow:(NSString *)windowName;
+ (GUITestProxy *)setSelectedRows:(NSArray *)tableRows inTableScroll:(NSString *)tableScrollName ofWindow:(NSString *)windowName;
+ (GUITestProxy *)itemNameAtIndex:(NSUInteger)tableRow ofTableScroll:(NSString *)tableScrollName ofWindow:(NSString *)windowName;
+ (GUITestProxy *)dragSelectedRowsToIndex:(NSUInteger)tableRow ofTableScroll:(NSString *)tableScrollName ofWindow:(NSString *)windowName;

@end
