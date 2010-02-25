//
//  ConcatenatedMatrixObserver.m
//  DebugDrawing
//
//  Created by steve hooley on 28/09/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "ConcatenatedMatrixObserver.h"
#import "ConcatenatedMatrixObserverCallBackProtocol.h"

/*
 *
*/
@implementation ConcatenatedMatrixObserver

@synthesize concatenatedMatrixNeedsRecalculating=_concatenatedMatrixNeedsRecalculating;
@synthesize concatenatedMatrix=_concatenatedMatrix;

#pragma mark Class methods
+ (void)recursivelyMarkAsDirty:(NSObject<ConcatenatedMatrixObserverCallBackProtocol> *)dirtyOb {
	
	NSParameterAssert(dirtyOb);
	
	[[dirtyOb concatenatedMatrixObserver] markDirty];
	NSArray *childrenToTell = [dirtyOb childrenToTellConcatenatedMatrixIsDirty];
	for( NSObject<ConcatenatedMatrixObserverCallBackProtocol> *each in childrenToTell ){
		[ConcatenatedMatrixObserver recursivelyMarkAsDirty:each];
	}
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)theKey {
	
    if( [theKey isEqualToString:@"concatenatedMatrixNeedsRecalculating"] )
        return NO;
	else
		[NSException raise:@"what else is there?" format:@""];
	return [super automaticallyNotifiesObserversForKey:theKey];
}

#pragma mark Init methods
- (id)initWithCallback:(NSObject<ConcatenatedMatrixObserverCallBackProtocol> *)value {

	self = [super init];
	if(self){
		_callBackObject = value;
		_concatenatedMatrixNeedsRecalculating = YES;
	}
	return self;
}

- (void)dealloc {

	NSAssert(_isOn==NO, @"did we clean up properly?");
	[super dealloc];
}

// This seems messy! Might be better for the xform to setup observers?
- (void)beginObservingConcatenatedMatrix {
	
	NSAssert(_callBackObject, @"need to init with a _callBackObject");
//	NSAssert(_wasPublicallyTurnedOn==NO, @"cant turn on twice");
	NSAssert(_isOn==NO, @"_isOn");

	// -- get xform to tell us when concatenatedMatrix needs Recalculating
	[[_callBackObject xForm] addObserver:self forKeyPath:@"needsRecalculating" options:0 context:@"ConcatenatedMatrixObserver"];
	
	_isOn = YES;

//oct09	_wasPublicallyTurnedOn = YES;

//oct09	[_callBackObject privatelyTurnOnConcatenatedMatrixObserversAbove];
}

- (void)endObservingConcatenatedMatrix {
	
	NSAssert(_callBackObject, @"need to init with a _callBackObject");
//	NSAssert(_wasPublicallyTurnedOn, @"publically turning off incorrect ConcatenatedMatrixObserver?");
	NSAssert(_isOn, @"_isOn");
		
	//-- stop xform from telling us when concatenatedMatrix needs Recalculating
	[[_callBackObject xForm] removeObserver:self forKeyPath:@"needsRecalculating"];

	_isOn = NO;

//oct09	_wasPublicallyTurnedOn = NO;	
//	[self privateTurnOff];
//oct09	[_callBackObject privatelyTurnOffConcatenatedMatrixObserversAbove];
}

//- (void)privateTurnOn {
//	
//	NSAssert(_callBackObject, @"need to init with a _callBackObject");
//	NSAssert(_isOn==NO, @"_isOn");
//}
//
//- (void)privateTurnOff {
//	
//	NSAssert(_callBackObject, @"need to init with a _callBackObject");
//	NSAssert(_isOn, @"_isOn");
//}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(NSObject *)observedObject change:(NSDictionary *)change context:(void *)vcontext {
	
	NSString *context = (NSString *)vcontext;
    if( [context isEqualToString:@"ConcatenatedMatrixObserver"] )
	{
        if ([keyPath isEqualToString:@"needsRecalculating"])
        {
			NSAssert( [_callBackObject conformsToProtocol:@protocol(ConcatenatedMatrixObserverCallBackProtocol)], @"doh");
			[ConcatenatedMatrixObserver recursivelyMarkAsDirty:_callBackObject];
			return;
		}
	}
	[super observeValueForKeyPath:keyPath ofObject:observedObject change:change context:vcontext];
}

- (void)markDirty {

	if(_concatenatedMatrixNeedsRecalculating==NO)
	{
		// -- send some kind of mutha fucking notification
		[self willChangeValueForKey:@"concatenatedMatrixNeedsRecalculating"];
		_concatenatedMatrixNeedsRecalculating = YES;
		[self didChangeValueForKey:@"concatenatedMatrixNeedsRecalculating"];
	}
}

- (void)setConcatenatedMatrix:(CGAffineTransform)value {
	
	NSAssert(_concatenatedMatrixNeedsRecalculating, @"why setting when not dirty?");
	_concatenatedMatrix = value;
	_concatenatedMatrixNeedsRecalculating = NO;
}

- (CGAffineTransform)concatenatedMatrix {
	
	NSAssert(_concatenatedMatrixNeedsRecalculating==NO, @"not valid - xform is dirty");
	return _concatenatedMatrix;
}

@end
