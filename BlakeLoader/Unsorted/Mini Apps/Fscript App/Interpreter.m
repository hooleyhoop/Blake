//
//  Interpreter.m
//  InterfaceTest
//
//  Created by Steve Hool on Fri Dec 26 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import "Interpreter.h"
#import "InterpreterWindow.h"
#import "HooleyPoint.h"
#import "AppControl.h"
#import </usr/include/objc/objc-class.h>


@implementation Interpreter

typedef struct objc_class*				ObjC_Class_Info;
typedef struct objc_ivar_list*          ObjC_DataMemberList;
static FSInterpreter *					theInterpreter; // singleton

//
- (id)init:(AppControl*)controlArg
{
    if ((self = [super init]) != nil)
    {		
        NSPoint result;
        NSSize siz;	
        result.x                        = 10;
        result.y                        = 10;
        siz.width                       = 200;
        siz.height                      = 200;   
        NSRect frameRect		= {result,siz};
        theAppControl			= controlArg;
        theFSInterpreterView            = [[FSInterpreterView alloc]initWithFrame:frameRect];
        theInterpreterWindow            = [[InterpreterWindow alloc]initWithContentRect:frameRect styleMask:NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask backing:NSBackingStoreBuffered defer:YES ];
        [theInterpreterWindow orderFront:nil];
        [theInterpreterWindow setTitle:@"script log"];
        [theInterpreterWindow setContentView: theFSInterpreterView ];
        [theFSInterpreterView notifyUser:@"Hello user"];
        [Interpreter setTheInterpreter: [theFSInterpreterView interpreter]];
        [self setTheFscriptSys: [theInterpreter objectForIdentifier: [[theInterpreter identifiers] objectAtIndex:0] found:NULL]];
    }
    return self;
}


    

//    int i;
//    for(i=0;i<10;i++){
//        [myPropertyInspector addInspectorField:@"hello"];
//    }
    
    // Create a string containing the F-Script code
  //  NSString *fscriptCode = @"[sys log:'hello world']";
    // Create a Block object from the string
 //   Block *myBlock = [fscriptCode asBlock];
    // Execute the block
//    id arg1 = [myBlock value];

    // OR
  // works  [[@"[sys log:'hello world']" asBlock] value];
    
 //    Block *myBlock2 = [System blockFromString:@"sys beep"];
   // [myBlock2 value];
//   [self interpretString];
   
    
    // fscript test
//    NSString *fscriptCode = @"[(NSBezierPath bezierPathWithOvalInRect:(500<>300 extent:100<>100)) stroke]";
//    NSString *fscriptCode = @"[sys browse]";

//    Block *myBlock = [fscriptCode asBlock];
 //   [myBlock value];

   // NSLog(Sys);
 //   NSTextField* txtField1;
 //   myControl = [[NSTextField alloc]initWithFrame: [self frame]];
 //   [ self addSubview:myControl ];

//    [self setContentView:txtField1];
    
  //  initWithFrame:(NSRect)frameRect



// send commands to the interpreter
//a - (int) interpretString
//a { 
//a     NSString* testString = @"5.0001 + 2.333";
//a     // command = [NSString stringWithCString:fgets(c_command, 10000, stdin)];    
//a     execResult = [interpreter execute: testString ]; // execute the F-Script command
//a     
//a     if ([execResult isOk]) // test status of the result
//a     {
//a         id result = [execResult result]; 
//a     
//a         // print the result
//a         if (result == nil)
//a         {
//a             puts("nil");
//a         } else {               
//a             puts([[result printString] cString]);
//a             Class aClass = [NSNumber class];
//a             
//a             if( [result isKindOfClass: aClass ] ){
//a                 NSLog(@"fuck me yes");
//a             }
//a             
//a             ///NSLog( aClass );
//a         //    BOOL flag = [result isKindOfClass: aClass ];
//a         //    NSLog( @"flag" );
//a         }
//a         if (![result isKindOfClass:[FSVoid class]]) putchar('\n'); 
//a     } else { 
//a         // print an error message
//a         puts([[NSString stringWithFormat:@"%@ , character %d\n",[execResult errorMessage],[execResult errorRange].location] cString]);
//a     }
//a //    } 
//a     return 0;      
//a }

// ===========================================================
// - theAppControl:
// ===========================================================
- (AppControl *) theAppControl { return theAppControl; }

// ===========================================================
// - setTheAppControl:
// ===========================================================
- (void) setTheAppControl: (AppControl *) aTheAppControl {
    if (theAppControl != aTheAppControl) {
        [aTheAppControl retain];
        [theAppControl release];
        theAppControl = aTheAppControl;
    }
}

// ===========================================================
// - theInterpreterWindow:
// ===========================================================
- (InterpreterWindow *) theInterpreterWindow { return theInterpreterWindow; }

// ===========================================================
// - setTheInterpreterWindow:
// ===========================================================
- (void) setTheInterpreterWindow: (InterpreterWindow *) aTheInterpreterWindow {
    if (theInterpreterWindow != aTheInterpreterWindow) {
        [aTheInterpreterWindow retain];
        [theInterpreterWindow release];
        theInterpreterWindow = aTheInterpreterWindow;
    }
}

// ===========================================================
// - theFSInterpreterView:
// ===========================================================
- (FSInterpreterView *) theFSInterpreterView { return theFSInterpreterView; }

// ===========================================================
// - setTheFSInterpreterView:
// ===========================================================
- (void) setTheFSInterpreterView: (FSInterpreterView *) aTheFSInterpreterView {
    if (theFSInterpreterView != aTheFSInterpreterView) {
        [aTheFSInterpreterView retain];
        [theFSInterpreterView release];
        theFSInterpreterView = aTheFSInterpreterView;
    }
}

// ===========================================================
// - theInterpreter:
// ===========================================================
// - (FSInterpreter *) theInterpreter { return theInterpreter; }
+ (FSInterpreter *) theInterpreter { return theInterpreter; }

// ===========================================================
// - setTheInterpreter:
// ===========================================================
+ (void) setTheInterpreter: (FSInterpreter *) aTheInterpreter {
    if (theInterpreter != aTheInterpreter) {
        [aTheInterpreter retain];
        [theInterpreter release];
        theInterpreter = aTheInterpreter;
    }
}

// ===========================================================
// - execResult:
// ===========================================================
- (FSInterpreterResult *) execResult { return execResult; }

// ===========================================================
// - setExecResult:
// ===========================================================
- (void) setExecResult: (FSInterpreterResult *) anExecResult {
    if (execResult != anExecResult) {
        [anExecResult retain];
        [execResult release];
        execResult = anExecResult;
    }
}

// ===========================================================
// - theFscriptSys:
// ===========================================================
- (System *) theFscriptSys { return theFscriptSys; }

// ===========================================================
// - setTheFscriptSys:
// ===========================================================
- (void) setTheFscriptSys: (System *) aTheFscriptSys {
    if (theFscriptSys != aTheFscriptSys) {
        [aTheFscriptSys retain];
        [theFscriptSys release];
        theFscriptSys = aTheFscriptSys;
    }
}


//  - dealloc:
// ===========================================================
- (void) dealloc {
    [theAppControl release];
    [theInterpreterWindow release];
    [theFSInterpreterView release];
    [theInterpreter release];
    [execResult release];
    [theFscriptSys release];

    theAppControl = nil;
    theInterpreterWindow = nil;
    theFSInterpreterView = nil;
    theInterpreter = nil;
    execResult = nil;
    theFscriptSys = nil;

    [super dealloc];
}




@end
