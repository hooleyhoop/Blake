//
//  SHInlet.m
//  newInterface
//
//  Created by Steve Hooley on 11/02/2005.
//  Copyright 2005 HooleyHoop. All rights reserved.
//

#import "SHInlet.h"
//#import "SHInputAttribute.h"

/*
 *
*/
@implementation SHInlet

#pragma mark -
#pragma mark init methods
- (id)initWithAttribute:(SHProtoAttribute *)parentAtt {

	self=[super initWithAttribute:parentAtt];
	if( self ) {
//31/05/06		isInlet		= YES;
//31/05/06		isOutlet	= NO;
//sh		[self setName:@"default. needs setting!"];
//sh		[self setParentNode: parent];
//sh		[self setIndex:connectletIndex];
//sh		respondsTo = nil;
	}
	return self;
}

//- (id<SHValueProtocol>) getValue
//{
//	return nil;
//}


//- (BOOL)isInlet { return YES; }
//
//- (BOOL)isAttributeConnnectlet 
//{ 
//	// if parent attribute is SHInputAttribute then we are an AttributeConnnectlet
//	if([parentAttribute class] == [SHInputAttribute class]){
//		return YES;
//	}
//	return NO; 
//}

@end



