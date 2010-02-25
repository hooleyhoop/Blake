//
//  SHNodeGraphModel_DebugDrawing.m
//  DebugDrawing
//
//  Created by steve hooley on 28/10/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "SHNodeGraphModel_DebugDrawing.h"


@implementation SHNodeGraphModel (DebugDrawing)


/* Where are we with this? Only execute outputs or have special per-thread nodes, or what? */
//- (void)updateForTime:(CGFloat)drawtime {
//	
//	[_rootNodeGroup evaluateOncePerFrame:nil head:_rootNodeGroup time:drawtime arguments:nil];
//	
//	if(_graphUpdatedCallBackObject)
//		(_graphUpdatedCallBackMethod)( _graphUpdatedCallBackObject, _graphUpdatedCallBackSEL );
//}

//- (void)addGraphUpdatedCallback:(id)value selector:(SEL)callbackSEL {
//	
//	_graphUpdatedCallBackObject = value;
//	_graphUpdatedCallBackSEL = callbackSEL;
//	_graphUpdatedCallBackMethod = [_graphUpdatedCallBackObject methodForSelector:_graphUpdatedCallBackSEL];
//}

#warning! !here!
//- (void)enforceGraphConsistentState:(SHNode *)node {
	
	//	SHOrderedDictionary *stars = [node nodenodesInside];
	//	for(NSUInteger i=0; i<[stars count]; i++){
	//		SHNode *eachStar = [stars objectAtIndex:i];
	//		[self enforceGraphConsistentState: eachStar];
	//		[eachStar enforceConsistentState];
	//	}
//}

// not updating - just beating
//- (void)enforceGraphConsistentState {
//    [self enforceGraphConsistentState:_rootNodeGroup];
//}

@end
