//
//  Interpreter.h
//  InterfaceTest
//
//  Created by Steve Hool on Fri Dec 26 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

@class AppControl, InterpreterWindow, FSInterpreterView;


@interface Interpreter : NSObject {

    AppControl				*theAppControl;
	InterpreterWindow		*theInterpreterWindow;
	FSInterpreterView		*theFSInterpreterView;
	//	FSInterpreter			*theInterpreter; // replaced with class method
    FSInterpreterResult		*execResult;
	System					*theFscriptSys;
}


// initializer
- (id)init:(AppControl*)controlArg;

- (AppControl *) theAppControl;
- (void) setTheAppControl: (AppControl *) aTheAppControl;

- (InterpreterWindow *) theInterpreterWindow;
- (void) setTheInterpreterWindow: (InterpreterWindow *) aTheInterpreterWindow;

- (FSInterpreterView *) theFSInterpreterView;
- (void) setTheFSInterpreterView: (FSInterpreterView *) aTheFSInterpreterView;

// - (FSInterpreter *) theInterpreter;
+ (FSInterpreter *) theInterpreter;
+ (void) setTheInterpreter: (FSInterpreter *) aTheInterpreter;


- (FSInterpreterResult *) execResult;
- (void) setExecResult: (FSInterpreterResult *) anExecResult;

- (System *) theFscriptSys;
- (void) setTheFscriptSys: (System *) aTheFscriptSys;



/* FSInterpreterView Commands 
- (float)fontSize;
- (FSInterpreter *)interpreter;
- (void)notifyUser:(NSString *)message;
- (void)putCommand:(NSString *)command;
- (void)setFontSize:(float)theSize;
*/


@end
