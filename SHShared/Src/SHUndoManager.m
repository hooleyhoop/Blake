//
//  SHUndoManager.m
//  SHShared
//
//  Created by steve hooley on 28/04/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "SHUndoManager.h"

@implementation NSUndoManager (SHUndoManager)

//- (id)init
//{
//    if ((self = [super init]) != nil)
//    {
//	}
//    return self;
//}

//- (void)dealloc {
//
//	[super dealloc];
//}

//- (void)forwardInvocation:(NSInvocation *)anInvocation {
//
//	logInfo(@"Register Undo: %@", NSStringFromSelector([anInvocation selector]));
//	[super forwardInvocation:anInvocation];
//}

//- (void)beginUndoGrouping:(NSString *)acName {
//
//	[self beginUndoGrouping];
//	[self setActionName:acName];	
//}

//- (void)beginUndoGrouping:(NSString *)acName reverseName:(NSString *)revName {
//
//	[self beginUndoGrouping];
//	[self setActionName:acName reverseName:revName];
//}

//- (void)setActionName:(NSString *)acName reverseName:(NSString *)revName {
//	
//	if([self isUndoing])
//		[self setActionName:revName];
//	else
//		[self setActionName:acName];
//}

#ifdef DEBUG
- (void)beginDebugUndoGroup {

	[self removeAllActions];
	[self setGroupsByEvent:NO];
	[self beginUndoGrouping];
}
#endif



@end
