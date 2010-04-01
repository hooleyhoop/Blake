//
//  HitTester.m
//  DebugDrawing
//
//  Created by Steven Hooley on 7/12/09.
//  Copyright 2009 Bestbefore. All rights reserved.
//

#import "HitTester.h"
#import "StarScene.h"
#import "HitTestContext.h"
#import "XForm.h"
#import "Graphic.h"
//#import "MiscUtilities.h"
//#import "MathUtilities.h"

@interface HitTester (private_methods)
- (SHNode *)hitTestLayersFromNode:(NodeProxy *)currentNodeProxy atPoint:(NSPoint)pt;
- (HitTestContext *)_hitTestContextWithRect:(CGRect)hitRect;
- (NSArray *)_setUpMatrixForEachChildInCurrent:(HitTestContext *)hitTestContext callback:(SEL)callback shouldCompleteIteration:(BOOL)keepGoing;
- (BOOL)_recursivelyDoProxy:(NodeProxy *)proxy parent:(SHNode *)parentSortOf hitCntx:(HitTestContext *)hitTestContext callback:(SEL)callback shouldCompleteIteration:(BOOL)keepGoing storeResult:(NSMutableArray *)collectedResults;
@end

@implementation HitTester

#pragma mark Class Methods
+ (BOOL)roughHitTestDrawingBoundsOf:(NSObject<iAmDrawableProtocol> *)each withContext:(HitTestContext *)hitTestCntxt {
	
	const CGRect transformedBounds = [(id)each didDrawAt:hitTestCntxt.offScreenCntx];
	if([hitTestCntxt rectIntersectsRect:transformedBounds] ) {
		return YES;
	}
	return NO;
}

#pragma mark Init Methods
- (id)initWithScene:(StarScene *)aScene {
	
	self=[super init];
    if( self ) {
		_scene = aScene;
	}
    return self;
}

- (void)dealloc {

    [super dealloc];
}

#pragma mark Action Methods

// Selection will likely need to be different dependant on the object
// In Freehand:
//	- to select text or a graphic shape with the marquee the shape's bounds must be entirely within the marquee
//	- to select a path the path geometry itself (but not it's handles - or stroke, or fill) must intersect the marquee
//
// In Illustrator:
//	- to select text or a graphic shape with the marquee the shape (but not it's bounds) must intersect the marquee
//	- to select a path the path geometry itself (but not it's handles - or stroke, or fill) must intersect the marquee
//
- (NSIndexSet *)indexesOfGraphicsIntersectingRect:(const CGRect)rect {
	
	NSAssert(_scene, @"doh");

	// get the objects
	HitTestContext *hitTestCntxt = [self _hitTestContextWithRect: rect];
	NSArray *graphicsIntersectingRect = [self _setUpMatrixForEachChildInCurrent:hitTestCntxt callback:@selector(_hitTestBrains:context:) shouldCompleteIteration:YES];
	NSLog(@"Graphics %@ %i", NSStringFromCGRect(rect), [graphicsIntersectingRect count]);
	
	// get their indexes
	NSMutableIndexSet *indexSetToReturn = [NSMutableIndexSet indexSet];

	/* This could be the wrong way round? */
	for( SHNode *each in graphicsIntersectingRect ){
		[indexSetToReturn addIndex:[_scene indexOfOriginalObjectIdenticalTo:each]];
	}

	[hitTestCntxt cleanUpHitTesting];
    return indexSetToReturn;
}

- (SHNode *)nodeUnderPoint:(const NSPoint)pt {

	SHNode *hitNode = nil;
	NodeProxy *cnp = [_scene currentProxy];
	NSArray *children = cnp.filteredContent;

	if([children count]){
		hitNode = [self hitTestLayersFromNode:cnp atPoint:pt];
	}
	return hitNode;
}

- (void)hitTestTool:(NSObject<iAmDrawableProtocol> *)aTool atPoint:(NSPoint)pt pixelColours:(unsigned char *)cols {
	
	memset( cols, 0, sizeof(CGFloat)*4 );
	
	HitTestContext *hitTestCntxt = [self _hitTestContextWithRect:CGRectMake( pt.x, pt.y, 1, 1 )];
	[aTool _setupDrawing:[hitTestCntxt offScreenCntx]];
	
	BOOL didPassBoundsCheck = [HitTester roughHitTestDrawingBoundsOf:(id)aTool withContext:hitTestCntxt];
#warning! ~Heloo!
//	if(didPassBoundsCheck)
//	{
//
//		[aTool _debugHitTestDrawing:[hitTestCntxt offScreenCntx]];
//		[hitTestCntxt checkAndResetWithKey: [[each.originalNode name] value] ];
//		
//		if( [hitTestCntxt containsKey:[[each.originalNode name] value]] )
//		{
//			NSAssert(didPassBoundsCheck, @"We MUST have passed the bounds check to get here!");
//			clickedNode = each.originalNode;
//		}
//		
//	}
	[aTool _tearDownDrawing:[hitTestCntxt offScreenCntx]];
	[hitTestCntxt cleanUpHitTesting];
}

#pragma mark Private Methods
- (HitTestContext *)_hitTestContextWithRect:(const CGRect)hitRect {

	HitTestContext *hitTestCntxt = [HitTestContext hitTestContextWithRect: hitRect];

	// setup the matrix for the current node
	NSArray *reverseToCurrent = nil;
	if([_scene currentProxy]!=[_scene rootProxy])
		// currentProxy must be a child of rootProxy
		reverseToCurrent = [[_scene rootProxy].originalNode reverseNodeChainToNode:[_scene currentProxy].originalNode];
	else
		reverseToCurrent = [NSArray arrayWithObject:[_scene currentProxy].originalNode];

	for( NSUInteger i=[reverseToCurrent count]; i>0; i-- ) 
	{
		SHNode *n = [reverseToCurrent objectAtIndex:i-1];
		if([n respondsToSelector:@selector(xForm)]){
			XForm *hmmmXForm = [(id)n xForm]; // make a protocol for this
			CGAffineTransform cgaf = [hmmmXForm unCompensatedTransformMatrix];
			CGContextConcatCTM( [hitTestCntxt offScreenCntx], cgaf );
		}
	}
	return hitTestCntxt;
}

- (SHNode *)_hitTestBrains:(NodeProxy *)each context:(HitTestContext *)hitTestCntxt {

	// hmm this should be the same as CALayer's hittest
	id drawableNode = each.originalNode;
	BOOL didPassBoundsCheck = [HitTester roughHitTestDrawingBoundsOf:drawableNode withContext:hitTestCntxt];
	if(!didPassBoundsCheck)
		return nil;
	
	SHNode *clickedNode = nil;

	[(id)(each.originalNode) _debugHitTestDrawing:[hitTestCntxt offScreenCntx]];
	[hitTestCntxt checkAndResetWithKey: [[each.originalNode name] value] ];

	if( [hitTestCntxt containsKey:[[each.originalNode name] value]] )
	{
		NSAssert(didPassBoundsCheck, @"We MUST have passed the bounds check to get here!");
		clickedNode = each.originalNode;
	}
	return clickedNode;
}

/*	The result of a hit test is always a node in the current level - 
	even if the hit test hit a deep, deep child.
	Because of this i need a different routine for children and for nodes in current
*/

- (BOOL)_testNodeProxyInCurrentLevel:(NodeProxy *)proxy parent:(SHNode *)parentSortOf hitCntx:(HitTestContext *)hitTestContext callback:(SEL)callback shouldCompleteIteration:(BOOL)keepGoing storeResult:(NSMutableArray *)collectedResults {
	
	NSParameterAssert(proxy);
	NSParameterAssert(parentSortOf);
	NSParameterAssert(hitTestContext);
	NSParameterAssert(collectedResults);

	BOOL shouldContinue=YES;

	// This is an either OR affair at the moment, whch is skewy.
	// It must have a Matrix OR have children
	// having a matrix is considered the same as implementing -_debugHitTestDrawing, which is also skewy
	if([proxy.originalNode respondsToSelector:@selector(_debugHitTestDrawing:)])
	{
		// each node needs it's own way to test a hit.. a path ignores it's stroke, for example
		// -- apply matrix
		[(id)proxy.originalNode _setupDrawing:[hitTestContext offScreenCntx]];
		
		id result = [self performSelector:callback withObject:proxy withObject:hitTestContext];
		
		if(result){
			// -- swap in parent
			NSAssert( [collectedResults containsObjectIdenticalTo:parentSortOf]==NO, @"what has happened that we are adding this twice?");
			[collectedResults addObject:parentSortOf];
			if(!keepGoing)
				shouldContinue = NO;
		}
		
		// -- pop matrix
		[(id)proxy.originalNode _tearDownDrawing:[hitTestContext offScreenCntx]];
		
	} else {
		// depth traversal
		if(proxy.hasChildren){
			//			!!!! !!!! !!! !! !! 
			//			!!!!!!!!! !!!!!!!!
			shouldContinue = [self _recursivelyDoProxy:proxy parent:parentSortOf hitCntx:hitTestContext callback:callback shouldCompleteIteration:NO storeResult:collectedResults];
			BOOL shitWayToRecogniseRootLevelOfRecursion = (parentSortOf==proxy.originalNode);
			if(keepGoing==YES && shitWayToRecogniseRootLevelOfRecursion)
				shouldContinue=YES;
		}
	}
	return shouldContinue;
}

- (BOOL)_recursivelyDoProxy:(NodeProxy *)proxy parent:(SHNode *)parentSortOf hitCntx:(HitTestContext *)hitTestContext callback:(SEL)callback shouldCompleteIteration:(BOOL)keepGoing storeResult:(NSMutableArray *)collectedResults {
	
	NSParameterAssert(proxy);
	NSParameterAssert(hitTestContext);
	NSParameterAssert(collectedResults);

	NSArray *filteredContent = [proxy filteredContent];
	
	// which way thru should we iterate?
	NSEnumerator *nodeEnmerator = [filteredContent reverseObjectEnumerator];
	NodeProxy *each=nil;
	BOOL shouldContinue=YES;
	
	while( (each=[nodeEnmerator nextObject]) && shouldContinue ) 
	{
		// hmm - funky. First time thru 'parentSortOf' will be nil and the node we want to return upon a successful hit is the node in current
		// as we travel further into further into the tree we still want to return the node in current
		id itemThatWillCountAsHitResult = parentSortOf ? parentSortOf : each.originalNode;
		shouldContinue = [self _testNodeProxyInCurrentLevel:each parent:itemThatWillCountAsHitResult hitCntx:hitTestContext callback:callback shouldCompleteIteration:keepGoing storeResult:collectedResults];
	}
	return shouldContinue;
}

// perform '- selector' with each node and collect results 
- (NSArray *)_setUpMatrixForEachChildInCurrent:(HitTestContext *)hitTestContext callback:(SEL)callback shouldCompleteIteration:(BOOL)keepGoing {

	NSParameterAssert(hitTestContext);

	// draw each child and see if we hit it
	NodeProxy *currentNodeProxy = [_scene currentProxy];
	NSAssert( currentNodeProxy, @"need a current");
	
	NSMutableArray *collectedResults = [NSMutableArray array];
	[self _recursivelyDoProxy:currentNodeProxy parent:nil hitCntx:hitTestContext callback:callback shouldCompleteIteration:keepGoing storeResult:collectedResults];
	return collectedResults;
}

/*	we don't return the node that we clicked on - we return it's parent from currentNode
 ie. you can only click on a node in currentNode
 */
- (SHNode *)hitTestLayersFromNode:(NodeProxy *)currentNodeProxy atPoint:(NSPoint)pt {
    
	NSParameterAssert(currentNodeProxy);

	// node implementation
	HitTestContext *hitTestCntxt = [self _hitTestContextWithRect:CGRectMake( pt.x, pt.y, 1, 1 )];

	NSArray *collectedResults = [self _setUpMatrixForEachChildInCurrent:hitTestCntxt callback:@selector(_hitTestBrains:context:) shouldCompleteIteration:NO];
	
	// index 0 is frontmost
	SHNode *clickedNode = [collectedResults count] ? [collectedResults objectAtIndex:0] : nil;
	
	[hitTestCntxt cleanUpHitTesting];
	return clickedNode;
}

@end
