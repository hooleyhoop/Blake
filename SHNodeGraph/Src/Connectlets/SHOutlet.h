//
//  SHOutlet.h
//  newInterface
//
//  Created by Steve Hooley on 11/02/2005.
//  Copyright 2005 HooleyHoop. All rights reserved.
//

#import "SHConnectlet.h"


/*
 * Each output property has an SHOutlet
 * If it is connected the property 
 * will share it's value with the connected input property
*/
@interface SHOutlet : SHConnectlet {

}

#pragma mark -
#pragma mark accessor methods
// overiding Virtual parent method
//- (id<SHValueProtocol>) getValue;


@end



