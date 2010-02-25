//
//  SketchModelTests.m
//  BlakeLoader
//
//  Created by steve hooley on 21/05/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "StubContentFilter.h"
#import <SketchGraph/AbtractModelFilter.h>
#import <SHNodeGraph/SHNodeGraphModel.h>
#import <SHNodeGraph/SHNodeSelectingMethods.h>
#import "StubFilterUser.h"
#import "SHNodeGraphModel_sketchAmmends.h"
#import "SKTGraphic.h"

#import <SenTestingKit/SenTestingKit.h>

@interface SketchModelTests : SenTestCase <SHContentProviderUserProtocol> {
	
	SHNodeGraphModel *_model;
}



@end


@implementation SketchModelTests

static BOOL graphicsDidChange = NO;
static int graphicsChangeCount = 0;

static BOOL selectionDidChange = NO;
static int selectionChangeCount = 0;

+ (void)resetObservers {

	selectionDidChange = NO;
	graphicsDidChange = NO;
	selectionChangeCount = 0;
	graphicsChangeCount = 0;
}


static NSAutoreleasePool *pool;

- (void)setUp {

	pool = [[NSAutoreleasePool alloc] init];

	_model = [[SHNodeGraphModel makeEmptyModel] retain];
	STAssertNotNil( [_model.rootNodeGroup nodesInside], @"init failed");
	STAssertNotNil([_model.rootNodeGroup selectedNodesInsideIndexes], @"init failed");
	[_model addObserver:self forKeyPath:@"rootNodeGroup.nodesInside" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SketchModelTests"];
	[_model addObserver:self forKeyPath:@"rootNodeGroup.nodesInside.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SketchModelTests"];
}

- (void)tearDown {

	[_model removeObserver:self forKeyPath:@"rootNodeGroup.nodesInside.selection"];
	[_model removeObserver:self forKeyPath:@"rootNodeGroup.nodesInside"];
	[_model release];
	[pool release];
//	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.32]];
}

/* content */
- (void)temp_proxy:(NodeProxy *)proxy willChangeContent:(NSArray *)values atIndexes:(NSIndexSet *)indexes {}
- (void)temp_proxy:(NodeProxy *)proxy didChangeContent:(NSArray *)values atIndexes:(NSIndexSet *)indexes {}

- (void)temp_proxy:(NodeProxy *)proxy willInsertContent:(NSArray *)proxiesForsuccessFullObjects atIndexes:(NSIndexSet *)indexes {}
- (void)temp_proxy:(NodeProxy *)proxy didInsertContent:(NSArray *)proxiesForsuccessFullObjects atIndexes:(NSIndexSet *)indexes {}

- (void)temp_proxy:(NodeProxy *)proxy willRemoveContent:(NSArray *)values atIndexes:(NSIndexSet *)indexes {}
- (void)temp_proxy:(NodeProxy *)proxy didRemoveContent:(NSArray *)values atIndexes:(NSIndexSet *)indexes {}

/* selection */
- (void)temp_proxy:(NodeProxy *)proxy willChangeSelection:(NSMutableIndexSet *)indexesOfSelectedObjectsThatPassFilter {}
// bear in mind that indexesOfSelectedObjectsThatPassFilter is actually an array and the changed indexes are actually the first item
- (void)temp_proxy:(NodeProxy *)proxy didChangeSelection:(NSMutableIndexSet *)indexesOfSelectedObjectsThatPassFilter {}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)vcontext {
	
	NSString *context = (NSString *)vcontext;
	if(context==nil)
		[NSException raise:@"MUST SUPPLY A CONTEXT" format:@"MUST SUPPLY A CONTEXT"];
	
    if( [context isEqualToString:@"SketchModelTests"] )
	{
		if( [keyPath isEqualToString:@"rootNodeGroup.nodesInside"] ){
			graphicsDidChange = YES;
			graphicsChangeCount++;
			
		 } else if( [keyPath isEqualToString:@"rootNodeGroup.nodesInside.selection"] ){
			selectionDidChange = YES;
			selectionChangeCount++;
		 }
	 } else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	 }
}

- (void)testInsertGraphicAtIndex {
// - (void)insertGraphic:(SKTGraphic *)graphic atIndex:(NSUInteger)index

	[SketchModelTests resetObservers];
	SKTGraphic *newGraphic = [[[SKTGraphic alloc] init] autorelease];
	[_model NEW_addChild:newGraphic toNode:_model.rootNodeGroup atIndex:0];
	
	STAssertTrue(graphicsDidChange, @"didnt get notification");
	STAssertTrue(graphicsChangeCount==1, @"received incorrect number of notifications %i", graphicsChangeCount);
	
	/* if you insert at the beggining rather than append at end selection will have to change (even if there is no selection - shitty automatic KVO behavoir) */
	STAssertFalse(selectionDidChange, @"didnt get notification");
	STAssertTrue(selectionChangeCount==0, @"received incorrect number of notifications %i", selectionChangeCount);
}




// - (void)addInGraphics:(SKTGraphic *)graphic

- (void)testIsSelected {
	// - (BOOL)isSelected:(id)value
	
	SKTGraphic *newGraphic1 = [[[SKTGraphic alloc] init] autorelease];
	SKTGraphic *newGraphic2 = [[[SKTGraphic alloc] init] autorelease];
	SKTGraphic *newGraphic3 = [[[SKTGraphic alloc] init] autorelease];
	[_model insertGraphics:[NSArray arrayWithObjects:newGraphic1, newGraphic2, newGraphic3, nil] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,3)]];
	[_model changeNodeSelectionTo:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1,1)]];
	STAssertFalse([_model isSelected:newGraphic1], @"doh");
	STAssertTrue([_model isSelected:newGraphic2], @"doh");
	STAssertFalse([_model isSelected:newGraphic3], @"doh");
}

- (void)testSetSelectionIndexes {
	
	NSAutoreleasePool *pool2 = [[NSAutoreleasePool alloc] init];

	/* lets add a single graphic that we can select */
	SKTGraphic *newGraphic = [[[SKTGraphic alloc] init] autorelease];
	[_model NEW_addChild:newGraphic toNode:_model.rootNodeGroup atIndex:0];
	
	/* Now lets see what happens when we select it */
	[SketchModelTests resetObservers];
	[_model setSelectionIndexes:[NSIndexSet indexSetWithIndex:0]];
	
	STAssertFalse(graphicsDidChange, @"didnt get notification");
	STAssertTrue(graphicsChangeCount==0, @"received incorrect number of notifications");
	
	STAssertTrue(selectionDidChange, @"didnt get notification");
	STAssertTrue(selectionChangeCount==1, @"received incorrect number of notifications");
	
	[SketchModelTests resetObservers];
	[_model setSelectionIndexes:[NSIndexSet indexSetWithIndex:0]];
	
	/* we check for equality before triggering KVO */
	STAssertTrue(selectionChangeCount==0, @"received incorrect number of notifications %i", selectionChangeCount);

	STAssertThrows( [_model setSelectionIndexes: [NSIndexSet indexSetWithIndex: 50]], @"50 is an invalid index to select" );

	[pool2 release];
}

- (void)testSetSelectedObjects {
// - (void)setSelectedObjects:(NSArray *)value;
	
	/* lets add some graphics that we can select */
	SKTGraphic *newGraphic1 = [[[SKTGraphic alloc] init] autorelease];
	SKTGraphic *newGraphic2 = [[[SKTGraphic alloc] init] autorelease];
	SKTGraphic *newGraphic3 = [[[SKTGraphic alloc] init] autorelease];

	[_model NEW_addChild:newGraphic1 toNode:_model.rootNodeGroup atIndex:0];
	[_model NEW_addChild:newGraphic2 toNode:_model.rootNodeGroup atIndex:1];
	[_model NEW_addChild:newGraphic3 toNode:_model.rootNodeGroup atIndex:2];
	
	[[self class] resetObservers];

	[_model setSelectedObjects:[NSArray arrayWithObjects:newGraphic1, newGraphic3, nil]];
	
	// -- assert selection
	NSArray *selectedObjects = [_model.rootNodeGroup selectedChildNodes];
	STAssertTrue( [selectedObjects count]==2, @"wrong!");
	STAssertTrue( [selectedObjects objectAtIndex:0]==newGraphic1, @"Wrong" );
	STAssertTrue( [selectedObjects objectAtIndex:1]==newGraphic3, @"Wrong" );
	
	STAssertTrue(selectionChangeCount==1, @"received incorrect number of notifications %i", selectionChangeCount);
}

- (void)testSetIndexOfChild {
// - (void)setIndexOfChild:(id)child to:(int)i;
	
	SKTGraphic *newGraphic1 = [[[SKTGraphic alloc] init] autorelease];
	SKTGraphic *newGraphic2 = [[[SKTGraphic alloc] init] autorelease];
	SKTGraphic *newGraphic3 = [[[SKTGraphic alloc] init] autorelease];
	
	[_model NEW_addChild:newGraphic1 toNode:_model.rootNodeGroup atIndex:0];
	[_model NEW_addChild:newGraphic2 toNode:_model.rootNodeGroup atIndex:0];
	[_model NEW_addChild:newGraphic3 toNode:_model.rootNodeGroup atIndex:0];
	
	[[self class] resetObservers];
	
	/* This will trigger graphics changed notification but not selection */
	[_model setIndexOfChild:newGraphic2 to:2]; 
	STAssertTrue([[_model.rootNodeGroup nodesInside] objectAtIndex:2]==newGraphic2, @"wrong!");
	STAssertTrue(graphicsDidChange, @"didnt get notification");
	STAssertTrue(graphicsChangeCount==1, @"received incorrect number of notifications");
	
	[_model setIndexOfChild:newGraphic1 to:1];
	STAssertTrue([[_model.rootNodeGroup nodesInside] objectAtIndex:1]==newGraphic1, @"wrong!");
	STAssertTrue(graphicsChangeCount==2, @"received incorrect number of notifications");

	[_model setIndexOfChild:newGraphic3 to:0];
	STAssertTrue(graphicsChangeCount==3, @"received incorrect number of notifications");

	STAssertTrue([[_model.rootNodeGroup nodesInside] objectAtIndex:0]==newGraphic3, @"wrong!");
	STAssertTrue([[_model.rootNodeGroup nodesInside] objectAtIndex:1]==newGraphic1, @"wrong!");
	STAssertTrue([[_model.rootNodeGroup nodesInside] objectAtIndex:2]==newGraphic2, @"wrong!");
}

@end
