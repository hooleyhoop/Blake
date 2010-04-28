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

#pragma mark TextField
+ (NSString *)getValueOfTextField:(NSUInteger)txtFieldIndex windowName:(NSString *)windowName app:(NSString *)appName {

	NSParameterAssert(appName);
	NSParameterAssert(windowName);

	NSString *result = nil;
	NSAppleScript *appleScript = [ApplescriptUtils applescript:@"TextField"];
	NSAssert(appleScript, @"could not find script");
	
	NSDictionary *errors = [NSDictionary dictionary];
	NSAppleEventDescriptor *parameters = [ApplescriptUtils parameters:appName, windowName, [NSString stringWithFormat:@"%i", txtFieldIndex], nil];
	NSAppleEventDescriptor* event = [ApplescriptUtils eventForApplescriptMethod:@"selectPopUpButtonItem" arguments:parameters];
	
	NSAppleEventDescriptor *resultEvent = [appleScript executeAppleEvent:event error:&errors];
	if(!resultEvent)
	{
		// report any errors from 'errors'
		[NSException raise:@"statusOfMenuItem: Fucked up applescript" format:@""];
	}
	// successful execution
	if (kAENullEvent != [resultEvent descriptorType])
	{
		// script returned an AppleScript result
		if (cAEList == [resultEvent descriptorType])
		{
			// result is a list of other descriptors
			NSLog(@"who?");
		}
		else
		{
			// coerce the result to the appropriate ObjC type
			NSLog(@"doobie doo getValueOfTextField? %@", resultEvent);
			result = [resultEvent stringValue];
			NSLog(@"Applescript result is doobie doo? %@", result);
		}
	}
	return result;
}

+ (NSString *)setValueOfTextfield:(NSUInteger)txtFieldIndex windowName:(NSString *)windowName app:(NSString *)appName toString:(NSString *)newValue {
	
	NSParameterAssert(appName);
	NSParameterAssert(windowName);
	NSParameterAssert(newValue);

	NSString *result = nil;
	NSAppleScript *appleScript = [ApplescriptUtils applescript:@"TextField"];
	NSAssert(appleScript, @"could not find script");
	
	NSDictionary *errors = [NSDictionary dictionary];
	NSAppleEventDescriptor *parameters = [ApplescriptUtils parameters:appName, windowName, [NSString stringWithFormat:@"%i", txtFieldIndex], newValue, nil];
	NSAppleEventDescriptor* event = [ApplescriptUtils eventForApplescriptMethod:@"selectPopUpButtonItem" arguments:parameters];
	
	NSAppleEventDescriptor *resultEvent = [appleScript executeAppleEvent:event error:&errors];
	if(!resultEvent)
	{
		// report any errors from 'errors'
		[NSException raise:@"statusOfMenuItem: Fucked up applescript" format:@""];
	}
	// successful execution
	if (kAENullEvent != [resultEvent descriptorType])
	{
		// script returned an AppleScript result
		if (cAEList == [resultEvent descriptorType])
		{
			// result is a list of other descriptors
			NSLog(@"who?");
		}
		else
		{
			// coerce the result to the appropriate ObjC type
			NSLog(@"doobie doo setValueOfTextfield? %@", resultEvent);
			result = [resultEvent stringValue];
			NSLog(@"Applescript result is doobie doo? %@", result);
		}
	}
	return result;
}

#pragma mark PopUpButton
+ (NSString *)selectPopUpButtonItem:(NSString *)itemName ofApp:(NSString *)appName windowName:(NSString *)windowName {

	NSParameterAssert(appName);
	NSParameterAssert(itemName);
	NSParameterAssert(windowName);

	NSString *result = nil;
	NSAppleScript *appleScript = [ApplescriptUtils applescript:@"popupButtonActions"];
	NSAssert(appleScript, @"could not find script");
	NSDictionary *errors = [NSDictionary dictionary];
	NSAppleEventDescriptor *parameters = [ApplescriptUtils parameters:appName, windowName, itemName, nil];
	NSAppleEventDescriptor* event = [ApplescriptUtils eventForApplescriptMethod:@"selectPopUpButtonItem" arguments:parameters];
	NSAppleEventDescriptor *resultEvent = [appleScript executeAppleEvent:event error:&errors];
	if(!resultEvent)
	{
		// report any errors from 'errors'
		[NSException raise:@"statusOfMenuItem: Fucked up applescript" format:@""];
	}
	// successful execution
	if (kAENullEvent != [resultEvent descriptorType])
	{
		// script returned an AppleScript result
		if (cAEList == [resultEvent descriptorType])
		{
			// result is a list of other descriptors
			NSLog(@"who?");
		}
		else
		{
			// coerce the result to the appropriate ObjC type
			NSLog(@"doobie doo selectPopUpButtonItem? %@", resultEvent);
			result = [resultEvent stringValue];
			NSLog(@"Applescript result is doobie doo? %@", result);
		}
	}
	return result;
}
carry on refactoring these
+ (NSString *)getTextOfDropDownMenuItemOfApp:(NSString *)appName windowName:(NSString *)windowName {
	
	NSParameterAssert(appName);
	NSParameterAssert(windowName);
	
	NSString *result = nil;
	NSAppleScript *appleScript = [ApplescriptUtils applescript:@"popupButtonActions"];
	NSAssert(appleScript, @"could not find script");
	NSDictionary *errors = [NSDictionary dictionary];
	NSAppleEventDescriptor *parameters = [ApplescriptUtils parameters:appName, windowName, nil];
	NSAppleEventDescriptor* event = [ApplescriptUtils eventForApplescriptMethod:@"getPopUpMenuButtonText" arguments:parameters];
	
	// call the event in AppleScript
	NSAppleEventDescriptor *resultEvent = [appleScript executeAppleEvent:event error:&errors];
	if(!resultEvent)
	{
		// report any errors from 'errors'
		[NSException raise:@"statusOfMenuItem: Fucked up applescript" format:@""];
	}
	// successful execution
	if (kAENullEvent != [resultEvent descriptorType])
	{
		// script returned an AppleScript result
		if (cAEList == [resultEvent descriptorType])
		{
			// result is a list of other descriptors
			NSLog(@"who?");
		}
		else
		{
			// coerce the result to the appropriate ObjC type
			NSLog(@"doobie doo getTextOfDropDownMenuItemOfApp? %@", resultEvent);
			result = [resultEvent stringValue];
			NSLog(@"Applescript result is doobie doo? %@", result);
		}
	}
	
	return result;
}

#pragma mark -
#pragma mark Main Menu
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
