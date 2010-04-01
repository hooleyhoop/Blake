//
//  MiscUtilities.h
//  DebugDrawing
//
//  Created by steve hooley on 10/07/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

@interface MiscUtilities : _ROOT_OBJECT_ {

}

#define NSStringWithCGPoint(__PT__) (NSStringFromPoint(NSPointFromCGPoint(__PT__))) 
#define NSStringFromCGRect(__RECT__) (NSStringFromRect(NSRectFromCGRect(__RECT__))) 

OBJC_EXPORT const BOOL expectedNegativeValue;
OBJC_EXPORT const BOOL expectedPositiveValue;

@end
