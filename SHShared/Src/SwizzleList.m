//
//  SwizzleList.m
//  iphonePlay
//
//  Created by steve hooley on 13/02/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "SwizzleList.h"
#import "SHSwizzler.h"
#import "LogController.h"
#import "SHInstanceCounter.h"
#import "NSCharacterSet_Extensions.h"
#import "SHGlobalVars.h"

@implementation SwizzleList

// COV_NF_START
+ (void)setupSwizzles {
	
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	static BOOL wasCalled = NO;
	if(wasCalled==NO)
	{
		wasCalled = YES;

	/* Only Swizzle Custom Classes? UIViewController seems ok.. SHooleyObjects are already taken care of */
	
#ifdef DEBUG
	
	/* Surely we cannot swizzle a class and it's super class? */
	if(NSClassFromString(@"EditingWindowController"))
		[SHSwizzler insertDebugCodeForInitMethod:@"initWithWindow:" ofClass:@"EditingWindowController"];
	
//	if(NSClassFromString(@"SHWindowController")){
//		[SHSwizzler insertDebugCodeForInitMethod:@"init" ofClass:@"SHWindowController"];
//		[SHSwizzler insertDebugCodeForInitMethod:@"initWithWindowNibName:" ofClass:@"SHWindowController"];
//	}
	
	if(NSClassFromString(@"EditingViewController"))
		[SHSwizzler insertDebugCodeForInitMethod:@"init" ofClass:@"EditingViewController"];

	if(NSClassFromString(@"CALayerStarView"))
		[SHSwizzler insertDebugCodeForInitMethod:@"initWithFrame:" ofClass:@"CALayerStarView"];
	
	if(NSClassFromString(@"EditingWindow")) {
		[SHSwizzler insertDebugCodeForInitMethod:@"initWithContentRect:styleMask:backing:defer:" ofClass:@"EditingWindow"];
		[SHSwizzler insertDebugCodeForInitMethod:@"initWithContentRect:styleMask:backing:defer:screen:" ofClass:@"EditingWindow"];
		[SHSwizzler insertDebugCodeForInitMethod:@"initWithCoder:" ofClass:@"EditingWindow"];
		[SHSwizzler insertDebugCodeForInitMethod:@"initWithWindowRef:" ofClass:@"EditingWindow"];
	}

	
	if(NSClassFromString(@"SHScrollView")){
		[SHSwizzler insertDebugCodeForInitMethod:@"initWithFrame:" ofClass:@"SHScrollView"];
		[SHSwizzler insertDebugCodeForInitMethod:@"initWithCoder:" ofClass:@"SHScrollView"];
	}
	if(NSClassFromString(@"SHSplitView")){
		[SHSwizzler insertDebugCodeForInitMethod:@"initWithFrame:" ofClass:@"SHSplitView"];
		[SHSwizzler insertDebugCodeForInitMethod:@"initWithCoder:" ofClass:@"SHSplitView"];
	}
	if(NSClassFromString(@"SHView")){
		[SHSwizzler insertDebugCodeForInitMethod:@"initWithFrame:" ofClass:@"SHView"];
		[SHSwizzler insertDebugCodeForInitMethod:@"initWithCoder:" ofClass:@"SHView"];
	}
	if(NSClassFromString(@"SHTableView")){
		[SHSwizzler insertDebugCodeForInitMethod:@"initWithFrame:" ofClass:@"SHTableView"];
		[SHSwizzler insertDebugCodeForInitMethod:@"initWithCoder:" ofClass:@"SHTableView"];
	}

	//        [SHSwizzler insertDebugCodeForInitMethod:@"init" ofClass:@"SHUndoManager"];
	
	if(NSClassFromString(@"SHDocument")){
		[SHSwizzler insertDebugCodeForInitMethod:@"init" ofClass:@"SHDocument"];
	}
    //    [SHSwizzler insertDebugCodeForInitMethod:@"init" ofClass:@"SHDocumentController"]; -- this is a singleton
	

	//        [SHSwizzler insertDebugCodeForInitMethod:@"initWithWindow:" ofClass:@"SHWindowController"];
	
	if(NSClassFromString(@"SHToolbar")){
		[SHSwizzler insertDebugCodeForInitMethod:@"initWithIdentifier:" ofClass:@"SHToolbar"];
	}
	
	if(NSClassFromString(@"SHWindow")){
		[SHSwizzler insertDebugCodeForInitMethod:@"initWithContentRect:styleMask:backing:defer:" ofClass:@"SHWindow"];
	}
	
	if(NSClassFromString(@"SHPanel")){
		[SHSwizzler insertDebugCodeForInitMethod:@"initWithContentRect:styleMask:backing:defer:" ofClass:@"SHPanel"];
	}
	//		[[[SHSwizzler alloc] init] trashME:@"one",@"two", nil]; 
	
//	if(NSClassFromString(@"BlakeGlobalCommandController"))
//		[SHSwizzler insertDebugCodeForInitMethod:@"init" ofClass:@"BlakeGlobalCommandController"];
	
	if(NSClassFromString(@"BlakeDocument"))
		[SHSwizzler insertDebugCodeForInitMethod:@"init" ofClass:@"BlakeDocument"];
	
	if(NSClassFromString(@"BlakeDocumentWindowController"))
		[SHSwizzler insertDebugCodeForInitMethod:@"init" ofClass:@"BlakeDocumentWindowController"];
	
	if(NSClassFromString(@"StubSketchDoc"))
		[SHSwizzler insertDebugCodeForInitMethod:@"init" ofClass:@"StubSketchDoc"];

	//	[SHSwizzler insertDebugCodeForInitMethod:@"init" ofClass:@"BlakeDocumentViewController"];
	
	//	[SHSwizzler insertDebugCodeForInitMethod:@"initWithFrame:" ofClass:@"Window_Base"];
//	[SHSwizzler insertDebugCodeForInitMethod:@"initWithCoder:" ofClass:@"Window_Base"];
//	[SHSwizzler insertDebugCodeForInitMethod:@"initWithNibName:bundle:" ofClass:@"ViewController_Base"];
//	[SHSwizzler insertDebugCodeForInitMethod:@"initWithCoder:" ofClass:@"ViewController_Base"];
//	[SHSwizzler insertDebugCodeForInitMethod:@"initWithFrame:" ofClass:@"View_Base"];
//	[SHSwizzler insertDebugCodeForInitMethod:@"initWithCoder:" ofClass:@"View_Base"];
//	[SHSwizzler insertDebugCodeForInitMethod:@"init" ofClass:@"Layer_Base"];
//	[SHSwizzler insertDebugCodeForInitMethod:@"init" ofClass:@"SHCustomMutableArray"];


#endif
	}
	[pool release];
}

+ (void)tearDownSwizzles {
	
    static BOOL onExitCheck = NO;
    
    if(onExitCheck==NO)
    {
#ifdef DEBUG
		
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        logInfo(@"-- Exiting process -- thread %i", [NSThread isMainThread]);
        [LogController killSharedLogController];
		[NSCharacterSet cleanUpNodeNameCharacterSet];
		[SHGlobalVars cleanUpGlobals];
		
        if( [SHInstanceCounter instanceCount]<0 )
			[NSException raise:NSInvalidArgumentException format:@"freed too many hooleyObjects"];
        [pool release];
        
        pool = [[NSAutoreleasePool alloc] init];
		if( [SHInstanceCounter instanceCount]>0 ){
		//            [SHInstanceCounter printLeakingObjectInfo];
			
			// recursively run the runloop?
			[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
			[SHInstanceCounter cleanUpInstanceCounter];
		}
//		[SHInstanceCounter performSelector:@selector(cleanUpInstanceCounter) withObject:nil afterDelay:0.33];
        [pool release];
//	sleep(100);
        printf("done");
#endif
    } else {
        NSLog(@"!!EXITING AGAIN!!");
    }
}
// COV_NF_END
@end
