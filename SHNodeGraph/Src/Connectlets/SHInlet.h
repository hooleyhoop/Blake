//
//  SHInlet.h
//  newInterface
//
//  Created by Steve Hooley on 11/02/2005.
//  Copyright 2005 HooleyHoop. All rights reserved.
//

#import "SHConnectlet.h"

/*
 * Each input property has an SHInlet
 * If it is connected the property knows how
 * to reference the connected output property.
*/
@interface SHInlet : SHConnectlet {

}

#pragma mark -
#pragma mark accessor methods
// overiding Virtual parent method
//- (id<SHValueProtocol>) getValue;



@end
