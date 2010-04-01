//
//  SHPythonSupport.h
//  BlakeLoader
//
//  Created by steve hooley on 06/05/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#include <Python/Python.h>

@class BBPythonProxy;
@interface SHPythonSupport : SHooleyObject {

	PyThreadState		*newInterpreterTS;

	PyObject			*locals;
	BBPythonProxy		*compiledCode;
	
	NSString*			script;
	
	BOOL				_isCompiled, _hasError;
}

void setUpPython();

- (void)execute;

- (NSString *)script;
- (void)setScript:(NSString *)value;

- (void)setCompiledCode:(BBPythonProxy *)value;

@end
