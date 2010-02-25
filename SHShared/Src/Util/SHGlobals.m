//
//  SHGlobals.m
//  InterfaceTest
//
//  Created by Steve Hooley on Fri Jul 23 2004.
//  Copyright (c) 2004 HooleyHoop. All rights reserved.
//

#import "globals.h"
#import <SHShared/BBLogger.h>

//#import "ScriptNodeProtocol.h"
//#import "Variable.h"

@implementation SHGlobals

//static FSInterpreter* theFSInterpreter = nil; // return a static interpreter
// static  globals	*theGlobals	= nil;
static  BOOL createdFlag		= NO;   // not a class variable because only visible to this file?


/*
 * Called once per class. Set up class variables
 * Ideal for setting up singletons
*/
+ (void)initialize
{
    static BOOL tooLate = NO;
    if ( !tooLate ) {
        logInfo( @"initializing Globals class for singleton" );
        // create one static globals object
 //      theGlobals			= [[globals alloc]init];
//		theFSInterpreter	= [[FSInterpreter alloc]init];
        tooLate				= YES;
        createdFlag			= YES;
    }
}

/*
 * Constructor, only ever makes one copy due to static Variable
*/
- (id)init
{
    if(createdFlag==NO){
		// somehow this is how the singleton works. On Calll to innit
		// we get here, but this calls init again and this time it returns the singleton
		theVariableNodes	= [[NSMutableDictionary alloc]initWithCapacity:1];
		duplicateVariables  = [[NSMutableArray alloc]initWithCapacity:1];
        return [super init];
    } else {
    //    return [globals theGlobals];
		return self;
    }
}

// ===========================================================
// + theFSInterpreter:
// ===========================================================
//- (FSInterpreter *)theFSInterpreter { return theFSInterpreter; }
//+ (FSInterpreter *)theFSInterpreter { return theFSInterpreter; }
// ===========================================================
// + setFSTheInterpreter:
// ===========================================================
//- (void)setFSTheInterpreter:(FSInterpreter *)arg
//{
//    if (theFSInterpreter != arg) {
//        [arg retain];
//        [theFSInterpreter release];
//        theFSInterpreter = arg;
//    }
//}

// ===========================================================
// + theGlobals:
// ===========================================================
//+ (globals *)theGlobals { return theGlobals; }


// ===========================================================
// + resetTheInterpreter:
// ===========================================================
//- (void) resetTheInterpreter
//{
//	[self setFSTheInterpreter :[[FSInterpreter alloc]init]]; // make new interpreter
//	[self addAllVariableNodesToInterpreter];
//}


// ===========================================================
// - addVariableNode:
// ===========================================================
//sh- (BOOL) addVariableNode:(id<ScriptNodeProtocol>)aNode
//sh{
//sh	if( [theVariableNodes objectForKey:[aNode name]]!=nil && aNode!=nil )
//sh	{
//sh		[theVariableNodes setObject:aNode forKey:[aNode name] ];
//sh		return YES;
//sh	} else {
//sh		NSLog(@"ERROR: Cant add node to globals. Already there or is nil");
//sh	}
//sh	return NO;
//sh}

// ===========================================================
// - deleteVariableNode:
// ===========================================================
//sh- (BOOL) deleteVariableNode:(id<ScriptNodeProtocol>)aNode
//sh{
//sh	NSArray *temp = [theVariableNodes allKeysForObject:aNode];
//sh	if( [temp count]>0 ){
//sh		[theVariableNodes removeObjectForKey:[temp objectAtIndex:0]];
//sh		return YES;
//sh	}
//sh	NSLog(@"WARNING:CANT DELETE VARIABLE");
//sh	return NO;
//sh}


// ===========================================================
// - addDuplicateVariableNode:
// ===========================================================
- (BOOL) deleteVariableNodeWithKey:(NSString*)aName
{
	if( [theVariableNodes objectForKey:aName]!=nil ){
		[theVariableNodes removeObjectForKey:aName];
		return YES;
	}
	NSLog(@"WARNING:CANT DELETE VARIABLE");
	return NO;
}


// ===========================================================
// - variableNodeNamed:
// ===========================================================
//sh- (Variable*) variableNodeNamed:(NSString*)aName
//sh{
//sh	if( [theVariableNodes objectForKey:aName]!=nil ){
//sh		return [theVariableNodes removeObjectForKey:aName];
//sh	}
//sh	return nil;
//sh}


// ===========================================================
// - addDuplicateVariableNode:
// ===========================================================
//sh- (BOOL) addDuplicateVariableNode:(id<ScriptNodeProtocol>)aNode
//sh{
//sh	if(aNode!=nil && ![duplicateVariables containsObject:aNode]){
//sh		[duplicateVariables addObject:aNode];
//sh		return YES;
//sh	}
//sh	NSLog(@"WARNING:CANT STORE DUPLICATE VARIABLES");
//sh	return NO;
//sh}

// ===========================================================
// - deleteDuplicateVariableNode:
// ===========================================================
//sh- (BOOL) deleteDuplicateVariableNode:(id<ScriptNodeProtocol>)aNode
//sh{
//sh	if(aNode!=nil && [duplicateVariables containsObject:aNode]){
//sh		[duplicateVariables removeObject:aNode];
//sh		return YES;
//sh	}
//sh	NSLog(@"WARNING:CANT REMOVE DUPLICATE VARIABLE");
//sh	return NO;
//sh}



- (BOOL)deleteDuplicateVariableNodeNamed:(NSString *)aName {

	for( id value in duplicateVariables )
	{
		if( [[value name]isEqualToString:aName ] )
		{
//a			[self deleteDuplicateVariableNode: value];
			return YES;
		}
	}
	NSLog(@"WARNING:CANT REMOVE DUPLICATE VARIABLE");
	return NO;
}

- (BOOL) isThereADuplicateVariableNamed:(NSString *)aName {
	
	for( id value in duplicateVariables ) {
		if( [[value name]isEqualToString:aName] ){
			return YES;
		}
	}
	return NO;
}


//sh- (Variable*)getDuplicateNamed:(NSString*)aName
//sh{
//sh	NSEnumerator *enumerator = [duplicateVariables objectEnumerator];
//sh	id value;
//sh	while ((value = [enumerator nextObject])) {
//sh		if( [[value name]isEqualToString:aName] ){
//sh			return value;
//sh		}
//sh	}
//sh	return nil;
//sh}



// ===========================================================
//  - dealloc:
// ===========================================================
- (void) dealloc {
    [theVariableNodes release];
	[duplicateVariables release];
	
    theVariableNodes	= nil;
	duplicateVariables  = nil;
    [super dealloc];
}


@end




@implementation globals (PrivateMethods)




// ===========================================================
// - theVariableNodes:
// ===========================================================
- (NSMutableDictionary *) theVariableNodes { return theVariableNodes; }

// ===========================================================
// - setTheVariableNodes:
// ===========================================================
- (void) setTheVariableNodes: (NSMutableDictionary *) aTheVariableNodes {
    if (theVariableNodes != aTheVariableNodes) {
        [aTheVariableNodes retain];
        [theVariableNodes release];
        theVariableNodes = aTheVariableNodes;
    }
}


// [myInterpreter setObject:[NSDate date] forIdentifier:@"myDate"];	// add variables
// BOOL found;
// id result = [myInterpreter objectForIdentifier:@"myDate" found:&found];
// NSArray *identifiers = [myInterpreter identifiers];
//- (void) addAllVariableNodesToInterpreter
//{
//	NSEnumerator *enumerator = [theVariableNodes objectEnumerator];
//	id value;
//	while ((value = [enumerator nextObject])) {
//		[theFSInterpreter setObject:value forIdentifier:[value name] ];
//	}
//}


@end