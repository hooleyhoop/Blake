//
//  SHOutlet.m
//  newInterface
//
//  Created by Steve Hooley on 11/02/2005.
//  Copyright 2005 HooleyHoop. All rights reserved.
//

#import "SHOutlet.h"
//#import "SHOutputAttribute.h"

/*
 *
*/
@implementation SHOutlet

#pragma mark -
#pragma mark init methods
- (id)initWithAttribute:(SHProtoAttribute *)parentAtt {

	self=[super initWithAttribute:parentAtt];
	if( self ) {
//31/05/06		isInlet		= NO;
//31/05/06		isOutlet	= YES;
//sh		interConnectors = [[NSMutableArray alloc]initWithCapacity:1];
//sh		[self setName:@"default. needs setting!"];
//sh		[self setIndex:connectletIndex];
//sh		respondsTo = nil;
	}
	return self;
}

#pragma mark accessor methods
//- (id<SHValueProtocol>) getValue
//{
//	return nil;
//}

//- (BOOL)isOutlet { return YES; }

//- (BOOL)isAttributeConnnectlet { 
//	// if parent attribute is SHInputAttribute then we are an AttributeConnnectlet
//	if([parentAttribute class]==[SHOutputAttribute class]){
//		return YES;
//	}
//	return NO; 
//}

//- (NSString *)description
//{
//	return( [NSString stringWithFormat:@"SHOut.m: I have %i _shInterConnectors, is isAttributeConnnectlet %i", [_shInterConnectors count], [self isAttributeConnnectlet]] );
//}
@end