//
//  SHAttribute.h
//  SHNodeGraph
//
//  Created by Steve Hooley on 09/05/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SHValueProtocol.h"
#import "SHNodeLikeProtocol.h"
#import "SHChild.h"

@class SHOutlet, SHInlet, SHNode, SHInterConnector, SH_Path, SHNodeGraphModel;

//enum SHAttributeState {
//	SHAttributeState_Normal, 
//	SHAttributeState_Connected, 
//	SHAttributeState_Error, 
//};


/*
 *
*/
@interface SHAttribute : SHChild <SHNodeLikeProtocol, NSCopying> {


//	SH_Path*					_absolutePath;
//	BOOL						_locked;

	@protected
//	int								_inletState, _outletState;					// state is just another expression of _isConnectedFlag
	

	// chaff
//	id nextTimeSliceValue;
//	id previousValue;
//	BOOL						_enabled;
//	BOOL						_selectedFlag;
}



@property(assign, readwrite, nonatomic) int						temporaryID;
@property(assign, readwrite, nonatomic) BOOL					operatorPrivateMember;

#pragma mark class methods
//+ (id)makeAttribute;

#pragma mark NSCopyopying, hash, isEqual
- (id)copyWithZone:(NSZone *)zone;
- (BOOL)isEquivalentTo:(id)anObject;

#pragma mark action methods
- (void)isAboutToBeDeletedFromParentSHNode;
- (void)hasBeenAddedToParentSHNode;


- (BOOL)isAttributeDownstream:(SHAttribute *)anAtt;

#pragma mark notification methods
//- (void)postNodeGuiMayNeedRebuilding_Notification;

#pragma mark acessor methods
//- (SH_Path *)absolutePath;
//- (void)setAbsolutePath: (SH_Path *)anAbsolutePath;
//
//- (BOOL)isLeaf;	// isLeaf always returns YES

/* if you tinker with mutable values data you should notify the attribute */
- (void)valueWasUpdatedManually;	

// custom views shouldnt call this.. it should ony be called within the nodegraph //
// custom Views should only really have access to the display object //
- (NSObject<SHValueProtocol> *)upToDateEvaluatedValue:(double)timeKey head:(SHAttribute *)np error:(NSError **)error;	// can return different types

- (NSString *)dataType;


- (BOOL)isInFeedbackLoop;


@end
