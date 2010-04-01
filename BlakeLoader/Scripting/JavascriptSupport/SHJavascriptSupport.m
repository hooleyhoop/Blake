//
//  SHJavascriptSupport.m
//  BlakeLoader
//
//  Created by steve hooley on 06/05/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "SHJavascriptSupport.h"
#import <JavaScriptCore/JavaScriptCore.h>

@implementation SHJavascriptSupport

- (id)init {
	
	if ((self = [super init]) != nil)
	{
		self.mainJSContext = JSGlobalContextCreate( NULL );
		JSObjectRef globalObject = JSContextGetGlobalObject( ctx );
	    JSStringRef propertyName = JSStringCreateWithCFString( (CFStringRef) @"property" ); 
		if ( propertyName != NULL ) { 
			JSStringRef propertyValue = JSStringCreateWithCFString( (CFStringRef) @"property value" ); 
			if ( propertyValue != NULL ) { 
				JSValueRef propertyValueObject = JSValueMakeString( ctx, propertyValue ); 
				if ( propertyValueObject != NULL ) { 
					JSObjectSetProperty( ctx, globalObject, propertyName, propertyValueObject, kJSPropertyAttributeReadOnly, NULL ); 
				} 
				JSStringRelease( propertyValue );
			} 
			JSStringRelease( propertyName ); 
		} 

		/* convert the name to a JavaScript string */ 
		JSStringRef functionName = 
		JSStringCreateWithCFString( (CFStringRef) @"messagebox" ); 
		if ( functionName != NULL ) { 
			
			/* create a function object in the context with the function pointer. */ 
			JSObjectRef functionObject = 
            JSObjectMakeFunctionWithCallback( ctx, functionName, theFunction ); 
			if ( functionObject != NULL ) { 
				
				/* add the function object as a property of the global object */ 
				JSObjectSetProperty( ctx, 
									JSContextGetGlobalObject( ctx ), 
									functionName, functionObject, 
									kJSPropertyAttributeReadOnly, NULL ); 
			} 
			/* done with our reference to the function name */ 
			JSStringRelease( functionName ); 
		} 
		
		
	}
	return self;
}

- (void)dealloc {
	
	   JSGlobalContextRelease( ctx );
	[super dealloc];
}	

JSValueRef MessagBoxFunction( JSContextRef ctx, JSObjectRef function, 
							 JSObjectRef thisObject, size_t argumentCount, 
							 const JSValueRef arguments[], JSValueRef *exception ); 

@end
