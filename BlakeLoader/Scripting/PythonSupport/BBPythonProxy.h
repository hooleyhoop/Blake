//
//  BBPythonProxy.h
//  SHExtras
//
//  Created by Steven Hooley on 06/07/2007.
//  Copyright 2007 HooleyHoop. All rights reserved.
//

#include <Python/Python.h>

@interface BBPythonProxy : SHooleyObject {
	PyObject *pyObj;
}

+ (id)proxyFor:(PyObject *)obj;
+ (id)proxyFor:(PyObject *)obj steal:(BOOL)steal;
- (id)initWithPythonObject:(PyObject *)obj steal:(BOOL)steal;

- (PyObject *)original;

@end

