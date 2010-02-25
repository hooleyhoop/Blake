//
//  SavingSHAttribute.h
//  SHNodeGraph
//
//  Created by Steve Hooley on 18/01/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SHAttribute.h"
#import "SHInputAttribute.h"
#import "SHOutputAttribute.h"

/* 
 *
*/
@interface SHAttribute (SavingSHAttribute) 

- (NSString*) saveName;

@end

///* 
// *
//*/
//@interface SHInputAttribute (SavingSHInputAttribute) 
//
//
//@end
//
///* 
// *
//*/
//@interface SHOutputAttribute (SavingSHOutputAttribute) 
//
//
//@end