//
//  SHPythonSupport.m
//  BlakeLoader
//
//  Created by steve hooley on 06/05/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "SHPythonSupport.h"
#import <sys/types.h>
#import "pyobjc-api.h"
#import "BBPythonProxy.h"

@implementation SHPythonSupport

#define COMILE_TO_BYTECODES 1

static PyThreadState * mainThreadState;
static PyObject *globals;

#pragma mark -
#pragma mark class methods
+ (void)initialize {
	static BOOL isInitialized = NO;
	if(!isInitialized)
	{
		setUpPython();
	}
}

// expose module entry point
void setUpPython()
{
	static BOOL initialized = FALSE;
	if( !initialized ) {
		initialized=YES;
		BOOL pyobjcInstalled = ( PyObjC_ImportAPI != NULL ? YES : NO );
		if( ! pyobjcInstalled ) {
			logError(@"PyObjc not installed");
		}
		Py_Initialize();
		PyObjC_ImportAPI( Py_None );
		PyEval_InitThreads();

		PyObject *mname = PyString_FromString("__main__");
		PyObject* mainmod = PyImport_Import(mname);
		globals = PyModule_GetDict(mainmod);

		PyRun_SimpleString("import sys\n");
		PyRun_SimpleString("from Foundation import *\n");
		PyRun_SimpleString("from AppKit import *\n");
		//  PyRun_SimpleString("import BBPython\n");
		// PyThreadState * mainThreadState = NULL;
		// save a pointer to the main PyThreadState object
		mainThreadState = PyThreadState_Get();
		// release the lock
		PyEval_ReleaseLock();
		initialized = YES;
	}
}


- (id)init {

	if ((self = [super init]) != nil)
	{
		_isCompiled = NO;
		_hasError = NO;

		// [self setScript:@"myObject = NSObject.alloc().init()"];
		// myString = NSString.alloc().initWithString_(u'my string')
		// myValue = valueContainer.value()
		// valueContainer.setValue_(myNewValue)
		// pool = NSAutoreleasePool.alloc().init()
		// del pool
		
		//ignore line wrap on following line
		PyRun_SimpleString("sys.stdout.write('Hello from an embedded Python Script')");
		newInterpreterTS = PyThreadState_Swap(NULL);
	//	PyEval_AcquireLock();
		// PyInterpreterState * mainInterpreterState = mainThreadState->interp;
		newInterpreterTS = Py_NewInterpreter();
		if(newInterpreterTS==NULL)
		{
			PyEval_ReleaseLock();
			// NSError* err = [[[NSError alloc] initWithDomain:@"PYTHONINITERROR" code:1 userInfo:nil] autorelease];
			return nil;			
		}
		PyThreadState_Swap(newInterpreterTS);

		// initBBPython();
		// tortoise_initialize();
		
		// printf("CREATED THREAD %i\n", newInterpreterTS->thread_id);
		PyImport_ImportModule("sys");

		PyRun_SimpleString("import sys\n");
		PyRun_SimpleString("import marshal\n");
		PyRun_SimpleString("from Foundation import *\n");
		PyRun_SimpleString("from AppKit import *\n");
		// PyImport_ImportModule("BBPython");
		// PyImport_ImportModule("ctypes");

		// import PyObjCTools
		if(!globals){
			PyObject *mname = PyString_FromString("__main__");
			PyObject* mainmod = PyImport_Import(mname);
			globals = PyModule_GetDict(mainmod);		
		}

		/* Display modules to check we have imported objc successfully */
//		PyRun_SimpleString("print sys.builtin_module_names\n");
//		PyRun_SimpleString("print sys.modules.keys()\n");
		// [BBPythonProxy proxyFor:mname steal:YES];
		
		locals = PyDict_New();
		
		// what is this? - cant find reference to PyEval_SimpleString anywhere
		// PyEval_SimpleString("import sys\n");
		PyThreadState_Swap(NULL);
		PyEval_ReleaseLock();

		// [self resetLocalVariables];
		
		/* Test Script */
		// NSMenu *mainMenu = [[NSApplication sharedApplication] mainMenu];
		// NSMenuItem *helpMenu = [mainMenu itemWithTitle:@"Help"];
		// [mainMenu removeItem:helpMenu];

		[self setScript:[NSString stringWithFormat:@"%@\n%@\n%@",
													@"mainMenu = NSApplication.sharedApplication().mainMenu()",
													@"helpMenu = mainMenu.itemWithTitle_('Help')",
													@"mainMenu.removeItem_(helpMenu)"
													]];
		NSAssert([[[NSApplication sharedApplication] mainMenu] itemWithTitle:@"Help"]!=nil, @"help item needs to be there for this script to run");
		[self execute];
		NSAssert([[[NSApplication sharedApplication] mainMenu] itemWithTitle:@"Help"]==nil, @"test script should have removed help item");
		/* Test Script */
	}
	return self;
}

- (void)dealloc
{	
	// grab the lock
	PyEval_AcquireLock();
	PyThreadState_Clear(newInterpreterTS);
	Py_EndInterpreter(newInterpreterTS);
	
	// swap my thread state out of the interpreter
	PyThreadState_Swap(NULL);
	// clear out any cruft from thread state object
	// delete my thread state object
	PyThreadState_Delete(newInterpreterTS);
	
	Py_XDECREF(locals);
	
	// release the lock
	PyEval_ReleaseLock();

	[super dealloc];
}	

// PyObject_CallObect()
// PyObject_CallFunction
#pragma mark action methods

- (void)execute
{
	if(!_hasError)
	{
		// grab the global interpreter lock
		PyEval_AcquireLock();
		// swap in my thread state
		PyThreadState_Swap(newInterpreterTS);
		
		// [BBPythonProxy proxyFor:globals steal:YES];
		// [BBPythonProxy proxyFor:locals steal:YES];

		/* TODO check the string length before executing ! */
		PyObject *result;
		BBPythonProxy *pxRes;

#ifdef COMILE_TO_BYTECODES
		PyObject *code;
		
		if( !_isCompiled )
		{
			if([script length]<1){
				_hasError = YES;
				logError(@"script is empty");
				goto home;
			}
				
			if (!(code = Py_CompileString((char *)[script UTF8String], (char *)"<console>", Py_file_input))) {
				logError(@"cant compile script");
				PyErr_Print();
				_hasError = YES;
				goto home;
			}
			[self setCompiledCode: [BBPythonProxy proxyFor:code steal:YES]];
			_isCompiled = YES;
		}
		@try {

			result = PyEval_EvalCode((PyCodeObject *)[compiledCode original], globals, locals);
		} @catch( NSException* e ) {
//			} @finally {
			logError(@"BBPythonPatch.m: Exception while executing script %@", e);
		}
		if (!result) {
			PyErr_Print();
			logError(@"Error execution returned NULL");
			_hasError = YES;
			goto home;
		}
#else
		// execute some python code	
		// PyRun_SimpleString([script UTF8String]);
		result = PyRun_StringFlags([script UTF8String], Py_file_input, globals, locals, NULL);

#endif
		pxRes = [BBPythonProxy proxyFor:result steal:YES];
	//	logInfo(@"Result was %@", [[[NSAttributedString alloc] initWithString:[pxRes description] attributes:[NSDictionary dictionary]] autorelease]);

	home:
		// clear the thread state
		PyThreadState_Swap(NULL);
		// release our hold on the global interpreter
		PyEval_ReleaseLock();
	}
}

- (NSString *)script 
{
    return script;
}

- (void)setScript:(NSString *)value {
    if (script != value) {
        [script release];
        script = [value retain];
		_isCompiled = NO;
		_hasError = NO;
		// [self resetLocalVariables];
    }
}

- (PyThreadState *)newInterpreterTS
{
	return newInterpreterTS;
}

- (BBPythonProxy *)compiledCode
{
	return compiledCode;
}

- (void)setCompiledCode:(BBPythonProxy *)value
{
	if(compiledCode!=value){
		[compiledCode release];
		compiledCode = [value retain];
	}
}

@end
