//
//  SHFScriptLoader.m
//  Pharm
//
//  Created by Steve Hooley on 24/01/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import "SHFScriptLoader.h"
#import "SHFScriptModel.h"
#import "SHAppControl.h"


@implementation SHFScriptLoader

#pragma mark -
#pragma mark class methods

#pragma mark init methods
//=========================================================== 
// initWithAppModel
//=========================================================== 
- (id)initWithAppModel:(SHAppModel*)appModel
{
    if (self = [super init]) 
	{
		_appModel = appModel;
	}
	return self;
}

//=========================================================== 
// dealloc
//=========================================================== 
- (void) dealloc {
    _appModel = nil;
    [super dealloc];
}


#pragma mark action methods
//=========================================================== 
// initWithAppModel
//=========================================================== 
- (void) doScript:(NSString*)stringName
{
	// leaking here.. possibly the result???
	
	if([SHFScriptModel fScriptModel])
	{
		[[SHAppControl appControl] disableOpenViews];

		NSError *error;
	//	[self addAllPathsFrom:[[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Contents"] stringByAppendingPathComponent:@"Frameworks"] ];
		NSString* path = [[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Contents/Resources/Scripts"] stringByAppendingPathComponent:stringName];

		// get a script called 'stringName' from the bundle folder called 'Scripts'
		NSString* fileContents = [NSString stringWithContentsOfFile: path encoding:NSASCIIStringEncoding error:&error];

		if(fileContents != nil) {
			// NSLog(@"Successfully read file: '%@'", stringName );
			// execute script
			FSInterpreter* theInterpreter = [[SHFScriptModel fScriptModel] theFSInterpreter];
			FSInterpreterResult* execResult = [theInterpreter execute: fileContents];
			id result = [execResult result];
			if(!result){
				NSLog(@"SHFScriptLoader.m: ERROR! No result from fscript execution %@",[SHFScriptModel fScriptModel]);
			}
			NSLog(@"SHFScriptLoader.m: FSCript result is = %@, %@, %i", result, [result name], [result retainCount] );
		} else {
			NSLog(@"SHFScriptLoader.m: ERROR! Cant open script %@ because %@", stringName, error );
		}
		[[SHAppControl appControl] enableOpenViews];
		[[SHAppControl appControl] syncAllViewsWithModel];
	} else {
		NSLog(@"SHFScriptLoader.m: ERROR! Cant open script %@ because fscript isnt available", stringName );
	}
}

#pragma mark accessorizor methods

@end
