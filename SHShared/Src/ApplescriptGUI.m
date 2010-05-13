//
//  ApplescriptGUI.m
//  InAppTests
//
//  Created by steve hooley on 11/01/2010.
//  Copyright 2010 BestBefore Ltd. All rights reserved.
//

#import "ApplescriptGUI.h"
#import "ApplescriptUtils.h"

@implementation ApplescriptGUI

#pragma mark Table Scripts

+ (NSArray *)indexesOfSelectedRowsInTableScroll:(NSString *)tableScrollName windowName:(NSString *)windowName app:(NSString *)appName {
	
	NSParameterAssert(tableScrollName);
	NSParameterAssert(appName);
	NSParameterAssert(windowName);
	
	NSString *scriptFileName = @"TableView";
	NSString *scriptMethodName = @"getSelctedRowsInTable";
	NSAppleEventDescriptor *parameters = [ApplescriptUtils parameters:appName, windowName, tableScrollName, nil];
	
	return [ApplescriptUtils executeScript:scriptFileName method:scriptMethodName params:parameters];	
}

+ (NSNumber *)countOfRowsInTableScroll:(NSString *)tableScrollName windowName:(NSString *)windowName app:(NSString *)appName {
	
	NSParameterAssert(tableScrollName);
	NSParameterAssert(appName);
	NSParameterAssert(windowName);
	
	NSString *scriptFileName = @"TableView";
	NSString *scriptMethodName = @"getCountOfRowsInTable";
	NSAppleEventDescriptor *parameters = [ApplescriptUtils parameters:appName, windowName, tableScrollName, nil];
	
	return [ApplescriptUtils executeScript:scriptFileName method:scriptMethodName params:parameters];	
}

#pragma mark TextField Scripts
+ (NSString *)getValueOfTextField:(NSNumber *)txtFieldIndex windowName:(NSString *)windowName app:(NSString *)appName {

	NSParameterAssert(txtFieldIndex);
	NSParameterAssert(appName);
	NSParameterAssert(windowName);

	NSString *scriptFileName = @"TextField";
	NSString *scriptMethodName = @"getValueOfTextField";
	NSAppleEventDescriptor *parameters = [ApplescriptUtils parameters:appName, windowName, [txtFieldIndex stringValue], nil];
	
	return [ApplescriptUtils executeScript:scriptFileName method:scriptMethodName params:parameters];
}

+ (NSString *)setValueOfTextfield:(NSNumber *)txtFieldIndex windowName:(NSString *)windowName app:(NSString *)appName toString:(NSString *)newValue {
	
	NSParameterAssert(txtFieldIndex);
	NSParameterAssert(appName);
	NSParameterAssert(windowName);
	NSParameterAssert(newValue);

	NSString *scriptFileName = @"TextField";
	NSString *scriptMethodName = @"doTypingInTextfield";
	NSAppleEventDescriptor *parameters = [ApplescriptUtils parameters:appName, windowName, [txtFieldIndex stringValue], newValue, nil];
	
	return [ApplescriptUtils executeScript:scriptFileName method:scriptMethodName params:parameters];
}

#pragma mark PopUpButton Scripts
+ (NSString *)selectPopUpButtonItem:(NSString *)itemName ofApp:(NSString *)appName windowName:(NSString *)windowName {

	NSParameterAssert(appName);
	NSParameterAssert(itemName);
	NSParameterAssert(windowName);

	NSString *scriptFileName = @"popupButtonActions";
	NSString *scriptMethodName = @"selectPopUpButtonItem";
	NSAppleEventDescriptor *parameters = [ApplescriptUtils parameters:appName, windowName, itemName, nil];
	
	return [ApplescriptUtils executeScript:scriptFileName method:scriptMethodName params:parameters];
}

+ (NSString *)getTextOfDropDownMenuItemOfApp:(NSString *)appName windowName:(NSString *)windowName {
	
	NSParameterAssert(appName);
	NSParameterAssert(windowName);
	
	NSString *scriptFileName = @"popupButtonActions";
	NSString *scriptMethodName = @"getPopUpMenuButtonText";
	NSAppleEventDescriptor *parameters = [ApplescriptUtils parameters:appName, windowName, nil];
	
	return [ApplescriptUtils executeScript:scriptFileName method:scriptMethodName params:parameters];
}

#pragma mark Main Menu Scripts
+ (NSString *)openMainMenuItem:(NSString *)menuName ofApp:(NSString *)appName {

	NSString *scriptFileName = @"openMenu";
	NSString *scriptMethodName = @"open_mainmenu_item";
	NSAppleEventDescriptor *parameters = [ApplescriptUtils parameters:appName, menuName, nil];
	
	return [ApplescriptUtils executeScript:scriptFileName method:scriptMethodName params:parameters];
}

+ (NSString *)doMainMenuItem:(NSString *)itemName ofMenu:(NSString *)menuName ofApp:(NSString *)appName {

	NSString *scriptFileName = @"doMenuItem";
	NSString *scriptMethodName = @"do_mainmenu_item";
	NSAppleEventDescriptor *parameters = [ApplescriptUtils parameters:appName, menuName, itemName, nil];

	return [ApplescriptUtils executeScript:scriptFileName method:scriptMethodName params:parameters];
}

+ (NSString *)statusOfMenuItem:(NSString *)itemName ofMenu:(NSString *)menuName ofApp:(NSString *)appName {

	NSParameterAssert(itemName);
	NSParameterAssert(menuName);
	NSParameterAssert(appName);

	NSLog(@"Args %@ %@ %@", appName, menuName, itemName);
	
	NSString *scriptFileName = @"openMenu";
	NSString *scriptMethodName = @"is_menu_enabled";
	NSAppleEventDescriptor *parameters = [ApplescriptUtils parameters:appName, menuName, itemName, nil];
	return [ApplescriptUtils executeScript:scriptFileName method:scriptMethodName params:parameters];	
}

#pragma mark Test Utility
+ (NSString *)attachGDBToTask:(int)pid file:(NSString *)fileName {
		
	NSString *scriptFileName = @"AttachToGDB";
	NSString *scriptMethodName = @"attachDebugger";
	NSAppleEventDescriptor *parameters = [ApplescriptUtils parameters:[NSString stringWithFormat:@"%i",pid], fileName, nil];
	
	return [ApplescriptUtils executeScript:scriptFileName method:scriptMethodName params:parameters];	
}

+ (NSString *)doScript:(NSString *)scriptFileName method:(NSString *)scriptMethodName {
	
	NSAppleEventDescriptor *parameters = [ApplescriptUtils parameters:@"steve", nil];
	return [ApplescriptUtils executeScript:scriptFileName method:scriptMethodName params:parameters];	
}

#pragma mark -

// This is the sample code that this stuff is based on
- (IBAction)addLoginItem:(id)sender {
	
    NSDictionary* errorDict;
    NSAppleEventDescriptor* returnDescriptor = NULL;
	
    NSAppleScript* scriptObject = [[NSAppleScript alloc] initWithSource:
								   @"\
								   set app_path to path to me\n\
								   tell application \"System Events\"\n\
								   if \"AddLoginItem\" is not in (name of every login item) then\n\
								   make login item at end with properties {hidden:false, path:app_path}\n\
								   end if\n\
								   end tell"];
	
    returnDescriptor = [scriptObject executeAndReturnError: &errorDict];
    [scriptObject release];
	
    if (returnDescriptor != NULL)
    {
        // successful execution
        if (kAENullEvent != [returnDescriptor descriptorType])
        {
            // script returned an AppleScript result
            if (cAEList == [returnDescriptor descriptorType])
            {
				// result is a list of other descriptors
            }
            else
            {
                // coerce the result to the appropriate ObjC type
            }
        }
    }
    else
    {
        // no script result, handle error here
    }
}

@end
