//
//  GUI_ApplescriptTestProxy.m
//  SHShared
//
//  Created by steve hooley on 29/04/2010.
//  Copyright 2010 BestBefore Ltd. All rights reserved.
//

#import "GUI_ApplescriptTestProxy.h"

#pragma mark -
@interface GUITestProxy ()
+ (id)guiTestProxyForApplescriptAction:(struct HooAppleScriptFactory)val;
- (void)_setUpDistributedNotificationStuff;
@end

#pragma mark -
@implementation GUI_ApplescriptTestProxy

NSString *_processName;
+ (void)initialize {
	static BOOL isInitialized = NO;
    if( !isInitialized ) {
        isInitialized = YES;	
		_processName = [[[NSProcessInfo processInfo] processName] retain];
	}
}

// Construct The proxy needed for the applescript stuff
+ (id)guiTestProxyForApplescriptAction:(struct HooAppleScriptFactory)val {
	
	GUITestProxy *aRemoteTestProxy = [[[GUITestProxy alloc] init] autorelease];
	aRemoteTestProxy->_debugName = val.name;
	
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys: val.className, @"TargetClass", val.selector, @"SelectorName", val.args, @"Arguments", nil];
	
	/* Construct an Invocation for the Notification - we aren't going to send it till we have a callback set */
	[[NSInvocation makeRetainedInvocationWithTarget: [NSDistributedNotificationCenter defaultCenter]
									  invocationOut:&(aRemoteTestProxy->_remoteInvocation)] 
	 postNotificationName:@"hooley_distrbuted_notification"
	 object:val.name
	 userInfo:dict
	 deliverImmediately:NO
	 ];
	
	[aRemoteTestProxy->_remoteInvocation retain];
	/* IPC callback - Every async action must have a callback */
	aRemoteTestProxy->_recievesAsyncCallback = val.recievesAsync;
	[aRemoteTestProxy _setUpDistributedNotificationStuff];
	
	return aRemoteTestProxy;
}

// set pre and post notification actioons to setup and cleanup
- (void)_setUpDistributedNotificationStuff {
	
	self.preAction = _BLOCK(@"[:arg1 | (NSDistributedNotificationCenter defaultCenter) addObserver:arg1 selector:#getNotifiedBack: name:'hooley_distrbuted_notification_callback' object:nil]");
	self.postAction = _BLOCK(@"[:arg1 | (NSDistributedNotificationCenter defaultCenter) removeObserver:arg1 name:'hooley_distrbuted_notification_callback' object:nil]");
}

#pragma mark TextField
+ (GUITestProxy *)getValueOfTextField:(NSUInteger)txtFieldIndex ofWindow:(NSString *)windowName {
	
	struct HooAppleScriptFactory val;
	
	val.name			= @"getValueOfTextField";
	val.className		= @"ApplescriptGUI";
	val.selector		= @"getValueOfTextField:windowName:app:";
	val.args			= [NSArray arrayWithObjects:[NSNumber numberWithUnsignedLong:txtFieldIndex], windowName, _processName, nil];
	val.recievesAsync	= YES;
	return [GUITestProxy guiTestProxyForApplescriptAction:val];
}

+ (GUITestProxy *)setValueOfTextfield:(NSUInteger)txtFieldIndex ofWindow:(NSString *)windowName toValue:(NSString *)newValue {
	
	struct HooAppleScriptFactory val;
	
	val.name			= @"setValueOfTextfield";
	val.className		= @"ApplescriptGUI";
	val.selector		= @"setValueOfTextfield:windowName:app:toString:";
	val.args			= [NSArray arrayWithObjects:[NSNumber numberWithUnsignedLong:txtFieldIndex], windowName, _processName, newValue, nil];
	val.recievesAsync	= YES;
	return [GUITestProxy guiTestProxyForApplescriptAction:val];
}

#pragma mark PopUp Button
+ (GUITestProxy *)selectPopUpButtonItem:(NSString *)itemName window:(NSString *)windowName {
	
	struct HooAppleScriptFactory val;
	
	val.name			= @"doPopUpButton";
	val.className		= @"ApplescriptGUI";
	val.selector		= @"selectPopUpButtonItem:ofApp:windowName:";
	val.args			= [NSArray arrayWithObjects:itemName, _processName, windowName, nil];
	val.recievesAsync	= YES;
	return [GUITestProxy guiTestProxyForApplescriptAction:val];
}

+ (GUITestProxy *)dropDownMenuButtonText:(NSString *)windowName {
	
	struct HooAppleScriptFactory val;
	
	val.name			= @"dropDownMenuButtonTextIs";
	val.className		= @"ApplescriptGUI";
	val.selector		= @"getTextOfDropDownMenuItemOfApp:windowName:";
	val.args			= [NSArray arrayWithObjects:_processName, windowName, nil];
	val.recievesAsync	= YES;
	return [GUITestProxy guiTestProxyForApplescriptAction:val];
}

#pragma mark Menu
+ (GUITestProxy *)openMainMenuItem:(NSString *)menuName {
	
	struct HooAppleScriptFactory val;
	
	val.name			= @"openMainMenuItem";
	val.className		= @"ApplescriptGUI";
	val.selector		= @"openMainMenuItem:ofApp:";
	val.args			= [NSArray arrayWithObjects:menuName, _processName, nil];
	val.recievesAsync	= YES;
	return [GUITestProxy guiTestProxyForApplescriptAction:val];
}

+ (GUITestProxy *)statusOfMenuItem:(NSString *)menuItemName ofMenu:(NSString *)menuName {
	
	struct HooAppleScriptFactory val;
	
	val.name			= @"status of menu item";
	val.className		= @"ApplescriptGUI";
	val.selector		= @"statusOfMenuItem:ofMenu:ofApp:";
	val.args			= [NSArray arrayWithObjects:menuItemName, menuName, _processName, nil];
	val.recievesAsync	= YES;
	return [GUITestProxy guiTestProxyForApplescriptAction:val];
}

+ (GUITestProxy *)doMenu:(NSString *)menuName item:(NSString *)menuItemName {
	
	struct HooAppleScriptFactory val;
	
	val.name			= @"do menu";
	val.className		= @"ApplescriptGUI";
	val.selector		= @"doMainMenuItem:ofMenu:ofApp:";
	val.args			= [NSArray arrayWithObjects:menuItemName, menuName, _processName, nil];
	val.recievesAsync	= YES;
	return [GUITestProxy guiTestProxyForApplescriptAction:val];
}

- (oneway void)getNotifiedBack:(NSNotification *)eh {
	
	NSAssert(_callbackOb, @"Need a callback ob");
	NSAssert(_recievesAsyncCallback, @"Needs to be _recievesAsyncCallback");
	
	NSDictionary *dict = [eh userInfo];
	NSString *resultStringValue = [dict valueForKey:@"resultValue"];
	if( [resultStringValue isEqualToString:@"true"] || [resultStringValue isEqualToString:@"false"] ) {
		BOOL result = [resultStringValue boolValue];
		_blockResult = result ? [FSBoolean fsTrue] : [FSBoolean fsFalse];
	} else {
		_blockResult = [resultStringValue retain];
	}
	
	[self cleanup];
}

@end
