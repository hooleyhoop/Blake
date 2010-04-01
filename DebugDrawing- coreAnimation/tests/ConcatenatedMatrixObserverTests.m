//
//  ConcatenatedMatrixObserverTests.m
//  DebugDrawing
//
//  Created by steve hooley on 12/10/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "ConcatenatedMatrixObserver.h"
#import "ConcatenatedMatrixObserverCallBackProtocol.h"
#import "XForm.h"

static NSUInteger _concatenatedMatrixNeedsRecalculatingCount;
static NSMutableArray *_childrenToTellDirty;

@interface ConcatenatedMatrixObserverTests : SenTestCase <ConcatenatedMatrixObserverCallBackProtocol> {
	
	ConcatenatedMatrixObserver	*_matrixObserver;
	OCMockObject				*_mockXForm;
}

@end

@implementation ConcatenatedMatrixObserverTests

#pragma mark-
#pragma mark callbacks from observer
//- (void)tellAllChildrenConcatenatedMatrixIsDirty {
//	
//	_tellAllChildrenCount++;
//}

- (XForm *)xForm {
	return (id)_mockXForm;
}

- (NSArray *)childrenToTellConcatenatedMatrixIsDirty {
	return _childrenToTellDirty;
}

- (ConcatenatedMatrixObserver *)concatenatedMatrixObserver {
	return _matrixObserver;
}

#pragma mark Notification callbacks
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(NSObject *)observedObject change:(NSDictionary *)change context:(void *)vcontext {
	
	NSString *context = (NSString *)vcontext;
	NSAssert( [context isEqualToString:@"ConcatenatedMatrixObserverTests"], @"doh");
	if ([keyPath isEqualToString:@"concatenatedMatrixNeedsRecalculating"]) {
		_concatenatedMatrixNeedsRecalculatingCount++;
		return;
	}
	[super observeValueForKeyPath:keyPath ofObject:observedObject change:change context:vcontext];
}

#pragma mark setup
- (void)setUp {
	
	_matrixObserver = [[ConcatenatedMatrixObserver alloc] initWithCallback:self];
}

- (void)tearDown {
	
	[_matrixObserver release];
}

#pragma mark Tests
- (void)testBeginObservingConcatenatedMatrix {
	// - (void)beginObservingConcatenatedMatrix
	// - (void)endObservingConcatenatedMatrix
	
	_mockXForm = MOCKFORCLASS([XForm class]);
	[[_mockXForm expect] addObserver:_matrixObserver forKeyPath:@"needsRecalculating" options:0 context:@"ConcatenatedMatrixObserver"];
	
	// will ask for xForm and add an observer
	[_matrixObserver beginObservingConcatenatedMatrix];
	[_mockXForm verify];

	[[_mockXForm expect] removeObserver:_matrixObserver forKeyPath:@"needsRecalculating"];
	 
	// will ask for xform and remove observer
	[_matrixObserver endObservingConcatenatedMatrix];
	[_mockXForm verify];	
}

- (void)testRecursivelyMarkAsDirty {
	// - (void)recursivelyMarkAsDirty:(NSObject<ConcatenatedMatrixObserverCallBackProtocol> *)dirtyOb
	
	//-- self
	//-- -- child1
	//-- -- -- child2
	
	OCMockObject *obj1 = MOCKFORPROTOCOL(ConcatenatedMatrixObserverCallBackProtocol);
	OCMockObject *obj2 = MOCKFORPROTOCOL(ConcatenatedMatrixObserverCallBackProtocol);
	OCMockObject *obj3 = MOCKFORPROTOCOL(ConcatenatedMatrixObserverCallBackProtocol);

	_childrenToTellDirty = [NSMutableArray arrayWithObjects:obj1, nil];

	[[[obj1 expect] andReturn:[NSMutableArray arrayWithObjects:obj2, obj3, nil] ] childrenToTellConcatenatedMatrixIsDirty];
	[[[obj2 expect] andReturn:nil] childrenToTellConcatenatedMatrixIsDirty];
	[[[obj3 expect] andReturn:nil] childrenToTellConcatenatedMatrixIsDirty];

	[[[obj1 expect] andReturn:_matrixObserver] concatenatedMatrixObserver];
	[[[obj2 expect] andReturn:_matrixObserver] concatenatedMatrixObserver];
	[[[obj3 expect] andReturn:_matrixObserver] concatenatedMatrixObserver];

	[ConcatenatedMatrixObserver recursivelyMarkAsDirty:self];

	[obj1 verify];
	[obj2 verify];
	[obj3 verify];

	_childrenToTellDirty = nil;
}

- (void)testMarkDirty {
	// - (void)markDirty
	
	_concatenatedMatrixNeedsRecalculatingCount=0;
	
	// -- add observer
	[_matrixObserver addObserver:self forKeyPath:@"concatenatedMatrixNeedsRecalculating" options:0 context:@"ConcatenatedMatrixObserverTests"];

	// hmm, slightly flakey. Starts off as dirty. You must clean it then re-dirty it to get the first notification
	[_matrixObserver setConcatenatedMatrix:CGAffineTransformIdentity];

	[_matrixObserver markDirty];
	STAssertTrue(_matrixObserver.concatenatedMatrixNeedsRecalculating, @"doh");
	
	// -- check that we receive notification
	STAssertTrue(_concatenatedMatrixNeedsRecalculatingCount==1, @"doh");
	
	[_matrixObserver markDirty];
	
	// -- check that we do not receive notification
	STAssertTrue(_concatenatedMatrixNeedsRecalculatingCount==1, @"doh");

	[_matrixObserver removeObserver:self forKeyPath:@"concatenatedMatrixNeedsRecalculating"];
}

- (void)testSetConcatenatedMatrix {
	// - (CGAffineTransform)concatenatedMatrix
	// - (void)setConcatenatedMatrix:(CGAffineTransform)value
	
	[_matrixObserver markDirty];
	STAssertTrue(_matrixObserver.concatenatedMatrixNeedsRecalculating, @"doh");
	[_matrixObserver setConcatenatedMatrix:CGAffineTransformIdentity];
	STAssertFalse(_matrixObserver.concatenatedMatrixNeedsRecalculating, @"doh");
	STAssertTrue( CGAffineTransformEqualToTransform([_matrixObserver concatenatedMatrix], CGAffineTransformIdentity), @"doh" );
}

@end
