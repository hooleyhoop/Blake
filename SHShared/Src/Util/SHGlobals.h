//
//  globals.h
//  InterfaceTest
//
//  Created by Steve Hooley on Fri Jul 23 2004.
//  Copyright (c) 2004 HooleyHoop. All rights reserved.
//

// #import "ScriptNodeProtocol.h"
// #import "Variable.h"



/*
 * keeps track of the duplicate variable objects
 *
*/
@interface SHGlobals : _ROOT_OBJECT_ {
	
	NSMutableDictionary			*theVariableNodes;
	NSMutableArray				*duplicateVariables;

}

//+ (globals *)theGlobals;

//+ (FSInterpreter*) theFSInterpreter; // return a static interpreter
//- (FSInterpreter*) theFSInterpreter; // return a static interpreter
//- (void) setFSTheInterpreter:(FSInterpreter*)arg; 
//- (void) resetTheInterpreter; 

// keep this globals object upto date on all the variables in our scripts
//sh- (BOOL) addVariableNode:(id<ScriptNodeProtocol>)aNode;
//sh- (BOOL) deleteVariableNode:(id<ScriptNodeProtocol>)aNode;
//sh- (BOOL) deleteVariableNodeWithKey:(NSString*)aName;

//sh- (Variable*) variableNodeNamed:(NSString*)aName;

//sh- (BOOL) addDuplicateVariableNode:(id<ScriptNodeProtocol>)aNode;
//sh- (BOOL) deleteDuplicateVariableNode:(id<ScriptNodeProtocol>)aNode;
//sh- (BOOL) deleteDuplicateVariableNodeNamed:(NSString*)aName;

//sh- (BOOL) isThereADuplicateVariableNamed:(NSString*)aName;
//sh- (Variable*)getDuplicateNamed:(NSString*)aName;

// - (NSMutableDictionary *) theVariableNodes;
// - (void) setTheVariableNodes: (NSMutableDictionary *) aTheVariableNodes;

// - (void) addAllVariableNodesToInterpreter;

@end