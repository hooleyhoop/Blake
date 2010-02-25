//
//  DelayedNotificationCoalescer.m
//  SHNodeGraph
//
//  Created by steve hooley on 27/08/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "DelayedNotificationCoalescer.h"
#import "NodeProxy.h"
#import "AllChildrenFilter.h"
#import "DelayedNotifier.h"

@implementation DelayedNotificationCoalescer

@synthesize notificationProxy=_notificationProxy;

@synthesize nodesInserted=_nodesInserted, inputsInserted=_inputsInserted, outputsInserted=_outputsInserted, icsInserted=_icsInserted;
@synthesize nodesInsertedIndexes=_nodesInsertedIndexes, inputsInsertedIndexes=_inputsInsertedIndexes, outputsInsertedIndexes=_outputsInsertedIndexes, icsInsertedIndexes=_icsInsertedIndexes;

@synthesize nodesRemoved=_nodesRemoved, inputsRemoved=_inputsRemoved, outputsRemoved=_outputsRemoved, icsRemoved=_icsRemoved;
@synthesize nodesRemovedIndexes=_nodesRemovedIndexes, inputsRemovedIndexes=_inputsRemovedIndexes, outputsRemovedIndexes=_outputsRemovedIndexes, icsRemovedIndexes=_icsRemovedIndexes;

@synthesize selectedNodeIndexes=_selectedNodeIndexes, selectedInputIndexes=_selectedInputIndexes, selectedOutputIndexes=_selectedOutputIndexes, selectedICIndexes=_selectedICIndexes;
@synthesize oldSelectedNodeIndexes=_oldSelectedNodeIndexes, oldSelectedInputIndexes=_oldSelectedInputIndexes, oldSelectedOutputIndexes=_oldSelectedOutputIndexes, oldSelectedICIndexes=_oldSelectedICIndexes;

- (id)initWithFilter:(AllChildrenFilter *)value mode:(NSString *)mode {

	NSParameterAssert(value);
	NSParameterAssert(mode);
	
	self = [super init];
	if(self){
		_mode = [mode retain];
		_filter = value; // watch out retain cycle
		_delayedNotifier = [[DelayedNotifier alloc] initWithController:self];

		if([mode isEqualToString:@"ContentInsert"]){
			_callback1 = @selector(_doPreInsertionNotification);
			_callback2 = @selector(_doDelayedInsertionNotification);
		
		} else if([mode isEqualToString:@"ContentRemoved"]){
			_callback1 = @selector(_doPreRemoveNotification);
			_callback2 = @selector(_doDelayedRemoveNotification);

		} else if([mode isEqualToString:@"SelectionChanged"]){
			_callback1 = @selector(_doPreSelectionNotification);
			_callback2 = @selector(_doDelayedSelectionNotification);

		} else {
			[NSException raise:@"unknown mode" format:@""];
		}
	}
	return self;
}

- (void)dealloc {

	[_mode release];
	NSAssert(_needToSendNotification==NO, @"not needed?");
	NSAssert(_notificationProxy==nil, @"not ready?");
	[_delayedNotifier release];
	[super dealloc];
}

- (void)fireSingleWillChangeNotification:(NodeProxy *)proxy {
	
	NSParameterAssert(proxy);
	NSAssert(_filter, @"not set up correctly");

	if( _notificationProxy==nil ){	// only send once
		_notificationProxy = proxy;
		//[_filter performSelector:_callback1];
		objc_msgSend(_filter,_callback1);
	} else {
		NSAssert(proxy==_notificationProxy, @"we should only receive more than once for the SAME proxy");
	}
}

// a change to nodes, inputs, outputs, selection will call this but it will only send the notification once
- (void)queueSinglePostponedNotification:(NodeProxy *)proxy {
	
	NSParameterAssert(proxy);
	NSAssert(_notificationProxy!=nil && _notificationProxy==proxy, @"gone wrong");
	NSAssert(_delayedNotifier, @"not set up correctly");
	
	// only do it once
	if(_needToSendNotification==NO)
	{
		_needToSendNotification = YES;
		[_delayedNotifier doDelayedNotification:_filter callbackMethod:_callback2];
	}
}

- (void)notificationDidFire_callback {

	NSAssert(_needToSendNotification, @"not needed?");
	NSAssert(_notificationProxy, @"not ready?");
	_needToSendNotification = NO;
	_notificationProxy = nil;
	
	if([_mode isEqualToString:@"ContentInsert"])
	{
		[_nodesInserted release];
		[_inputsInserted release];
		[_outputsInserted release];
		[_icsInserted release];
		_nodesInserted = nil;
		_inputsInserted = nil;
		_outputsInserted = nil;
		_icsInserted = nil;
		[_nodesInsertedIndexes release];
		[_inputsInsertedIndexes release];
		[_outputsInsertedIndexes release];
		[_icsInsertedIndexes release];
		_nodesInsertedIndexes = nil;
		_inputsInsertedIndexes = nil;
		_outputsInsertedIndexes = nil;
		_icsInsertedIndexes = nil;
		
	} else if([_mode isEqualToString:@"ContentRemoved"]) {

		[_nodesRemoved release];
		[_inputsRemoved release];
		[_outputsRemoved release];
		[_icsRemoved release];
		[_nodesRemovedIndexes release];
		[_inputsRemovedIndexes release];
		[_outputsRemovedIndexes release];
		[_icsRemovedIndexes release];
		_nodesRemoved = nil;
		_inputsRemoved = nil;
		_outputsRemoved = nil;
		_icsRemoved = nil;
		_nodesRemovedIndexes = nil;
		_inputsRemovedIndexes = nil;
		_outputsRemovedIndexes = nil;
		_icsRemovedIndexes = nil;
		
	} else if([_mode isEqualToString:@"SelectionChanged"]) {
	
		[_selectedNodeIndexes release]; 
		[_oldSelectedNodeIndexes release];
		[_selectedInputIndexes release];
		[_oldSelectedInputIndexes release];
		[_selectedOutputIndexes release];
		[_oldSelectedOutputIndexes release];
		[_selectedICIndexes release];
		[_oldSelectedICIndexes release];
		_selectedNodeIndexes = nil;
		_oldSelectedNodeIndexes = nil;
		_selectedInputIndexes = nil;
		_oldSelectedInputIndexes = nil;
		_selectedOutputIndexes = nil;
		_oldSelectedOutputIndexes = nil;
		_selectedICIndexes = nil;
		_oldSelectedICIndexes = nil;
	} else {
		[NSException raise:@"Unknown mode" format:@"%@", _mode];
	}
	[_delayedNotifier cleanupAfterFire];
}

- (BOOL)isWaitingForNotificationToBeSent {

	if((_needToSendNotification && _notificationProxy==nil) || (!_needToSendNotification && _notificationProxy!=nil))
		[NSException raise:@"mismatch" format:@""];
	return _needToSendNotification;
}

- (void)postNotification {
	
	NSAssert([self isWaitingForNotificationToBeSent], @"not waiting");
	[_delayedNotifier fireOveride];
}

#pragma mark -
#pragma mark notification objects Accessors
#pragma mark -

#pragma mark Insertion Methods

- (void)_appendInsertedValues:(NSArray *)newValues forKey:(NSString *)key1 indexes:(NSIndexSet *)newIndexes forKey:(NSString *)key2 {
	
	NSArray *target = [self valueForKey:key1];
	NSIndexSet *targetIndexes = [self valueForKey:key2];

	if(target) {
		NSAssert(targetIndexes, @"shit");
	
		// use magic to calculate the new indexes
		NSIndexSet *mergedIndexes = [targetIndexes offsetAndMerge:newIndexes];
		NSIndexSet *compenstaedPositions = [mergedIndexes positionsOfIndexes:newIndexes];

		NSMutableArray *temp = [[target mutableCopy] autorelease];
		[temp insertObjects:newValues atIndexes:compenstaedPositions];
		
		[self setValue:temp forKey:key1];
		[self setValue:mergedIndexes forKey:key2];

	} else {
		[self setValue:newValues forKey:key1];
		[self setValue:newIndexes forKey:key2];
	}
}

- (void)appendNodesInserted:(NSArray *)newValues atIndexes:(NSIndexSet *)changeIndexes {
	
	NSAssert([_mode isEqualToString:@"ContentInsert"], @"wrong mode");
	[self _appendInsertedValues:newValues forKey:@"nodesInserted" indexes:changeIndexes forKey:@"nodesInsertedIndexes"];
}

- (void)appendInputsInserted:(NSArray *)newValues atIndexes:(NSIndexSet *)changeIndexes {
	
	NSAssert([_mode isEqualToString:@"ContentInsert"], @"wrong mode");
	[self _appendInsertedValues:newValues forKey:@"inputsInserted" indexes:changeIndexes forKey:@"inputsInsertedIndexes"];
}

- (void)appendOutputsInserted:(NSArray *)newValues atIndexes:(NSIndexSet *)changeIndexes {
	
	NSAssert([_mode isEqualToString:@"ContentInsert"], @"wrong mode");
	[self _appendInsertedValues:newValues forKey:@"outputsInserted" indexes:changeIndexes forKey:@"outputsInsertedIndexes"];
}

- (void)appendIcsInserted:(NSArray *)newValues atIndexes:(NSIndexSet *)changeIndexes {
	
	NSAssert([_mode isEqualToString:@"ContentInsert"], @"wrong mode");
	[self _appendInsertedValues:newValues forKey:@"icsInserted" indexes:changeIndexes forKey:@"icsInsertedIndexes"];
}

#pragma mark -
#pragma mark Removal Methods
- (void)_appendRemovedValues:(NSArray *)newValues forKey:(NSString *)key1 indexes:(NSIndexSet *)newIndexes forKey:(NSString *)key2 {
		
	NSArray *target = [self valueForKey:key1];
	NSIndexSet *targetIndexes = [self valueForKey:key2];

	if(target) {		
		NSAssert(targetIndexes, @"shit");

		NSIndexSet *mergedIndexes = [targetIndexes reverseOffsetAndMerge:newIndexes];
		NSIndexSet *compenstaedPositions = [mergedIndexes positionsOfIndexes:newIndexes];

		NSMutableArray *temp = [[target mutableCopy] autorelease];
		[temp insertObjects:newValues atIndexes:compenstaedPositions];
		
		[self setValue:temp forKey:key1];
		[self setValue:mergedIndexes forKey:key2];
		
	} else {
		[self setValue:newValues forKey:key1];
		[self setValue:newIndexes forKey:key2];
	}
}

- (void)appendNodesRemoved:(NSArray *)newValues atIndexes:(NSIndexSet *)changeIndexes {
	
	NSAssert([_mode isEqualToString:@"ContentRemoved"], @"wrong mode");
	[self _appendRemovedValues:newValues forKey:@"nodesRemoved" indexes:changeIndexes forKey:@"nodesRemovedIndexes"];
}

- (void)appendInputsRemoved:(NSArray *)newValues atIndexes:(NSIndexSet *)changeIndexes {

	NSAssert([_mode isEqualToString:@"ContentRemoved"], @"wrong mode");
	[self _appendRemovedValues:newValues forKey:@"inputsRemoved" indexes:changeIndexes forKey:@"inputsRemovedIndexes"];
}

- (void)appendOutputsRemoved:(NSArray *)newValues atIndexes:(NSIndexSet *)changeIndexes {

	NSAssert([_mode isEqualToString:@"ContentRemoved"], @"wrong mode");
	[self _appendRemovedValues:newValues forKey:@"outputsRemoved" indexes:changeIndexes forKey:@"outputsRemovedIndexes"];
}

- (void)appendIcsRemoved:(NSArray *)newValues atIndexes:(NSIndexSet *)changeIndexes {

	NSAssert([_mode isEqualToString:@"ContentRemoved"], @"wrong mode");
	[self _appendRemovedValues:newValues forKey:@"icsRemoved" indexes:changeIndexes forKey:@"icsRemovedIndexes"];
}


#pragma mark -
#pragma mark Selection Methods
- (void)_changedSelectedIndexesFrom:(NSIndexSet *)oldValue to:(NSIndexSet *)newValue oldKey:(NSString *)oldKey newKey:(NSString *)newKey {

	NSAssert([_mode isEqualToString:@"SelectionChanged"], @"wrong mode");
	
	NSIndexSet *oldIndexes = [self valueForKey:oldKey];
	NSIndexSet *newIndexes = [self valueForKey:newKey];
	
	if(newIndexes){
		NSAssert(oldIndexes, @"doh");
		NSAssert( [oldValue isEqualToIndexSet:newIndexes], @"muthaFucker");
		[self setValue:newValue forKey:newKey];
	} else {
		[self setValue:oldValue forKey:oldKey];
		[self setValue:newValue forKey:newKey];
	}
}

- (void)changedSelectedNodeIndexesFrom:(NSIndexSet *)oldValue to:(NSIndexSet *)newValue {
	[self _changedSelectedIndexesFrom:oldValue to:newValue oldKey:@"oldSelectedNodeIndexes" newKey:@"selectedNodeIndexes"];
}
- (void)changedSelectedInputIndexesFrom:(NSIndexSet *)oldValue to:(NSIndexSet *)newValue {
	[self _changedSelectedIndexesFrom:oldValue to:newValue oldKey:@"oldSelectedInputIndexes" newKey:@"selectedInputIndexes"];
}
- (void)changedSelectedOutputIndexesFrom:(NSIndexSet *)oldValue to:(NSIndexSet *)newValue {
	[self _changedSelectedIndexesFrom:oldValue to:newValue oldKey:@"oldSelectedOutputIndexes" newKey:@"selectedOutputIndexes"];
}
- (void)changedSelectedICIndexesFrom:(NSIndexSet *)oldValue to:(NSIndexSet *)newValue {
	[self _changedSelectedIndexesFrom:oldValue to:newValue oldKey:@"oldSelectedICIndexes" newKey:@"selectedICIndexes"];
}

@end
