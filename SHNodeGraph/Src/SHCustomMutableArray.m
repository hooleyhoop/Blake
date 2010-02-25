//
//  SHCustomMutableArray.m
//  SHNodeGraph
//
//  Created by steve hooley on 25/03/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "SHCustomMutableArray.h"
#import "SHNode.h"
#import "SHInputAttribute.h"
#import "SHOutputAttribute.h"
#import "SHInterConnector.h"
#import "SHNodeAttributeMethods.h"

@implementation SHCustomMutableArray

@synthesize node;

- (id)init {

	self=[super init];
	if(self) {
	}
	return self;
}

- (void)dealloc {

	[super dealloc];
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)oindex {

	NSParameterAssert(anObject!=nil);

	BOOL success = [node addChild:anObject undoManager:nil];
	if(success)
		[node setIndexOfChild:anObject to:oindex undoManager:nil];
}

- (void)removeObjectAtIndex:(NSUInteger)oindex {

	id child = [node childAtIndex: oindex];
	[node deleteChild:child undoManager:nil];
}

- (void)addObject:(id)anObject {

	NSParameterAssert(anObject);
	NSAssert(node, @"not setup yet");
	[node addChild:anObject undoManager:nil];
}

// If otherArray has fewer objects than are specified by aRange, the extra objects in the receiver are removed. If otherArray has more objects than are specified by aRange, the extra objects from otherArray are inserted into the receiver.
- (void)replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray *)otherArray {

	NSParameterAssert(range.length==[otherArray count]);
//	[super replaceObjectsInRange:range withObjectsFromArray:otherArray];
	NSUInteger location = range.location;

	NSUInteger i=0;
	for( id ob in otherArray ){
		[self replaceObjectAtIndex:location+i withObject:ob];
		i++;
	}
}

/* anObject might be NSNull */
- (void)replaceObjectAtIndex:(NSUInteger)oindex withObject:(id)anObject {

	[NSException raise:@"what is this method for?" format:@""];
	
//	logInfo(@"replaceObjectAtIndex %i, withObject %@", oindex, anObject);
//	unsigned correctedIndex = oindex;
//	unsigned nodeCount = [[node nodesInside] count];
//	unsigned previousCorrectedTotal = 0;
//	unsigned correctedTotal = nodeCount;
//	
//	if(oindex < correctedTotal){
//		correctedIndex = oindex;
//		NSAssert([anObject isKindOfClass:[SHNode class]] || [anObject isKindOfClass:[NSNull class]], @"cant insert that kind of object there");
//		[(NSMutableArray *)[[node nodesInside] array] replaceObjectAtIndex:correctedIndex withObject:anObject];
//		return;
//	}
//	
//	unsigned inputCount = [[node inputs] count];
//	previousCorrectedTotal = correctedTotal;
//	correctedTotal = correctedTotal + inputCount;
//		
//	if(oindex < correctedTotal){
//		correctedIndex = oindex - previousCorrectedTotal;
//		NSAssert([anObject isKindOfClass:[SHInputAttribute class]] || [anObject isKindOfClass:[NSNull class]], @"cant insert that kind of object there");
//		[(NSMutableArray *)[[node inputs] array] replaceObjectAtIndex:correctedIndex withObject:anObject];
//		return;
//	}
//			
//	unsigned outputCount = [[node outputs] count];
//	previousCorrectedTotal = correctedTotal;
//	correctedTotal = correctedTotal + outputCount;
//
//	if(oindex < correctedTotal){
//		correctedIndex = oindex - previousCorrectedTotal;
//		NSAssert([anObject isKindOfClass:[SHOutputAttribute class]] || [anObject isKindOfClass:[NSNull class]], @"cant insert that kind of object there");
//		[(NSMutableArray *)[[node outputs] array] replaceObjectAtIndex:correctedIndex withObject:anObject];
//		return;
//	}
//	
//	unsigned connectortCount = [[node shInterConnectorsInside] count];
//	previousCorrectedTotal = correctedTotal;
//	correctedTotal = correctedTotal + connectortCount;
//
//	if(oindex < correctedTotal ){
//		correctedIndex = oindex - previousCorrectedTotal;
//		NSAssert([anObject isKindOfClass:[SHInterConnector class]] || [anObject isKindOfClass:[NSNull class]], @"cant insert that kind of object there");
//		[(NSMutableArray *)[[node shInterConnectorsInside] array] replaceObjectAtIndex:correctedIndex withObject:anObject];
//		return;
//	}
//
//	[NSException raise:@"unknown Object or index for replace" format:@"we cant replaceObjectAtIndex with this object"];
}

- (id)objectAtIndex:(NSUInteger)oindex {

	return [node childAtIndex: oindex];
}

- (NSUInteger)count {

	NSAssert(node, @"fakeArray not set up properly");
	return [node countOfChildren];
}

#pragma mark -
#pragma mark NOT TO BE USED

- (void)removeLastObject {
	NSException* myException = [NSException exceptionWithName:@"Not Done YET" reason:@"removeLastObject - custom stuff needs doing" userInfo:nil];
	@throw myException;
}

- (void)addObjectsFromArray:(NSArray *)otherArray {
	NSException* myException = [NSException exceptionWithName:@"Not Done YET" reason:@"addObjectsFromArray - custom stuff needs doing" userInfo:nil];
	@throw myException;
}

- (void)exchangeObjectAtIndex:(unsigned)idx1 withObjectAtIndex:(unsigned)idx2 {
	NSException* myException = [NSException exceptionWithName:@"Not Done YET" reason:@"exchangeObjectAtIndex - custom stuff needs doing" userInfo:nil];
	@throw myException;
}

- (void)removeAllObjects {
	NSException* myException = [NSException exceptionWithName:@"Not Done YET" reason:@"removeAllObjects - custom stuff needs doing" userInfo:nil];
	@throw myException;
}

- (void)removeObject:(id)anObject inRange:(NSRange)range {
	NSException* myException = [NSException exceptionWithName:@"Not Done YET" reason:@"removeObject-inRange custom stuff needs doing" userInfo:nil];
	@throw myException;
}

- (void)removeObject:(id)anObject {
	NSException* myException = [NSException exceptionWithName:@"Not Done YET" reason:@"removeObject custom stuff needs doing" userInfo:nil];
	@throw myException;
}

- (void)removeObjectsFromIndices:(unsigned *)indices numIndices:(unsigned)count {
	NSException* myException = [NSException exceptionWithName:@"Not Done YET" reason:@"removeObjectsFromIndices - custom stuff needs doing" userInfo:nil];
	@throw myException;
}

- (void)removeObjectsInArray:(NSArray *)otherArray {
	NSException* myException = [NSException exceptionWithName:@"Not Done YET" reason:@"removeObjectsInArray - custom stuff needs doing" userInfo:nil];
	@throw myException;
}

- (void)removeObjectsInRange:(NSRange)range {
	NSException* myException = [NSException exceptionWithName:@"Not Done YET" reason:@"removeObjectsInRange - custom stuff needs doing" userInfo:nil];
	@throw myException;
}

- (void)setArray:(NSArray *)otherArray {
	NSException* myException = [NSException exceptionWithName:@"Not Done YET" reason:@"setArray - custom stuff needs doing" userInfo:nil];
	@throw myException;
}

- (void)sortUsingFunction:(int (*)(id, id, void *))compare context:(void *)context {
	NSException* myException = [NSException exceptionWithName:@"Not Done YET" reason:@"sortUsingFunction - custom stuff needs doing" userInfo:nil];
	@throw myException;
}

- (void)sortUsingSelector:(SEL)comparator {
	NSException* myException = [NSException exceptionWithName:@"Not Done YET" reason:@"sortUsingSelector - custom stuff needs doing" userInfo:nil];
	@throw myException;
}

- (void)insertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes {
	NSException* myException = [NSException exceptionWithName:@"Not Done YET" reason:@"insertObjects-atIndexes custom stuff needs doing" userInfo:nil];
	@throw myException;
}

- (void)removeObjectsAtIndexes:(NSIndexSet *)indexes {
	NSException* myException = [NSException exceptionWithName:@"Not Done YET" reason:@"custom stuff needs doing" userInfo:nil];
	@throw myException;
}

- (void)replaceObjectsAtIndexes:(NSIndexSet *)indexes withObjects:(NSArray *)objects {
	NSException* myException = [NSException exceptionWithName:@"Not Done YET" reason:@"replaceObjectsAtIndexes-withObjects custom stuff needs doing" userInfo:nil];
	@throw myException;
}



@end
