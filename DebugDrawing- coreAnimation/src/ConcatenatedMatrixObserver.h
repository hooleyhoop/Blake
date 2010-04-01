//
//  ConcatenatedMatrixObserver.h
//  DebugDrawing
//
//  Created by steve hooley on 28/09/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

@protocol ConcatenatedMatrixObserverCallBackProtocol;


@interface ConcatenatedMatrixObserver : _ROOT_OBJECT_ {

	BOOL											_wasPublicallyTurnedOn;
	BOOL											_isOn;
	NSObject <ConcatenatedMatrixObserverCallBackProtocol>	*_callBackObject;
	BOOL											_concatenatedMatrixNeedsRecalculating;
	CGAffineTransform								_concatenatedMatrix;
}

@property (readonly) BOOL concatenatedMatrixNeedsRecalculating;
@property (readwrite) CGAffineTransform concatenatedMatrix;

+ (void)recursivelyMarkAsDirty:(NSObject<ConcatenatedMatrixObserverCallBackProtocol>*)dirtyOb;

- (id)initWithCallback:(NSObject <ConcatenatedMatrixObserverCallBackProtocol>*)value;

- (void)beginObservingConcatenatedMatrix;
- (void)endObservingConcatenatedMatrix;

- (void)markDirty;

@end



