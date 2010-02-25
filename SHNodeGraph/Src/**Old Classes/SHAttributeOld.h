//
//  SHAttribute.h
//  newInterface
//
//  Created by Steve Hooley on 03/03/2005.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "SHooleyObject.h"
@class SHConnectlet, SHInterConnector, SHooleyObject, SHProto_Node;


						
/*
 * A Special Node that acts as a property to operators and scripts
 * It has its own connectlet so that it can be wired to other attributes
 *
 * VIRTUAL
*/
@interface SHAttribute : SHooleyObject {
	

	
}

#pragma mark -
#pragma mark init methods

- (void)initInputs;
- (void)initOutputs;

#pragma mark action methods

#pragma mark accessor methods

/* The main purpose of this is to circumvent the KVO on value & setValue methods */
/* The view that is calling this method will know what kind of object is being returned */

//@public
/* you should bind the propert inspector views directly this if the object is immutable */
/* if you bind to properties inside this then the node wont be marked as dirty.. this is
ok if the object cant be updated by the property inspector, like an image or soundwave */
- (id) displayObject;
- (void) setDisplayObject:(id)val;


@end