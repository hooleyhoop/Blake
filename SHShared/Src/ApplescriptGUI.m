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

+ (NSString *)getTextOfDropDownMenuItemOfApp:(NSString *)appName {

	NSParameterAssert(appName);
	
	NSString *result = nil;
	NSAppleScript *appleScript = [ApplescriptUtils applescript:@"popupButtonActions"];
	NSAssert(appleScript, @"could not find script");
	NSDictionary *errors = [NSDictionary dictionary];
	NSAppleEventDescriptor *parameters = [ApplescriptUtils parameters:appName, nil];
	NSAppleEventDescriptor* event = [ApplescriptUtils eventForApplescriptMethod:@"getMenuButtonText" arguments:parameters];
	
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
			NSLog(@"doobie doo? %@", resultEvent);
			result = [resultEvent stringValue];
			NSLog(@"Applescript result is doobie doo? %@", result);
		}
	}
	
	return result;
}

#pragma mark -
+ (void)openMainMenuItem:(NSString *)menuName ofApp:(NSString *)appName {

	NSAppleScript *appleScript = [ApplescriptUtils applescript:@"openMenu"];
	NSDictionary *errors = [NSDictionary dictionary];
	NSAppleEventDescriptor *parameters = [ApplescriptUtils parameters:appName, menuName, nil];
	NSAppleEventDescriptor* event = [ApplescriptUtils eventForApplescriptMethod:@"open_mainmenu_item" arguments:parameters];
	
	// call the event in AppleScript
	NSAppleEventDescriptor *resultEvent = [appleScript executeAppleEvent:event error:&errors];
	if( !resultEvent ) {
		// report any errors from 'errors'
		[NSException raise:@"openMainMenuItem: Fucked up applescript" format:@""];
	}
	// successful execution
	if( kAENullEvent!=[resultEvent descriptorType] )
	{
		// script returned an AppleScript result
		if( cAEList == [resultEvent descriptorType] ) {
			// result is a list of other descriptors
			NSLog(@"who?");
		} else {
			NSLog(@"doobie doo? %@", resultEvent);
		}
	}
	
}

+ (void)doMainMenuItem:(NSString *)itemName ofMenu:(NSString *)menuName ofApp:(NSString *)appName {

	NSAppleScript *appleScript = [ApplescriptUtils applescript:@"doMenuItem"];
	NSDictionary *errors = [NSDictionary dictionary];
	NSAppleEventDescriptor *parameters = [ApplescriptUtils parameters:appName, menuName, itemName, nil];
	NSAppleEventDescriptor* event = [ApplescriptUtils eventForApplescriptMethod:@"do_mainmenu_item" arguments:parameters];
	
	// call the event in AppleScript
	NSAppleEventDescriptor *resultEvent = [appleScript executeAppleEvent:event error:&errors];
	if( !resultEvent ) {
		// report any errors from 'errors'
		[NSException raise:@"doMainMenuItem: Fucked up applescript" format:@""];
	}
	// successful execution
	if( kAENullEvent!=[resultEvent descriptorType] )
	{
		// script returned an AppleScript result
		if( cAEList == [resultEvent descriptorType] ) {
			// result is a list of other descriptors
			NSLog(@"who?");
		} else {
			NSLog(@"doobie doo? %@", resultEvent);
		}
	}	
}

+ (id)statusOfMenuItem:(NSString *)itemName ofMenu:(NSString *)menuName ofApp:(NSString *)appName {

	NSParameterAssert(itemName);
	NSParameterAssert(menuName);
	NSParameterAssert(appName);

	BOOL result = NO;
	NSAppleScript *appleScript = [ApplescriptUtils applescript:@"openMenu"];
	NSAssert(appleScript, @"could not find script");
	NSDictionary *errors = [NSDictionary dictionary];
	NSAppleEventDescriptor *parameters = [ApplescriptUtils parameters:appName, menuName, itemName, nil];
	NSAppleEventDescriptor* event = [ApplescriptUtils eventForApplescriptMethod:@"is_menu_enabled" arguments:parameters];

	// call the event in AppleScript
	NSLog(@"about to call is_menu_enabled");
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
			NSLog(@"doobie doo? %@", resultEvent);
			result = [resultEvent booleanValue];
		}
	}

	return [NSString stringWithBOOL:result];
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
