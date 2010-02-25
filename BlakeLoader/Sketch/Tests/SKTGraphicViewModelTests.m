e//
//  SKTGraphicViewModelTests.m
//  BlakeLoader
//
//  Created by steve hooley on 29/05/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "SKTGraphicViewModelTests.h"
#import "SKTGraphicViewModel.h"
#import "SKTCircle.h"

static BOOL selectionDidChange = NO;
static BOOL graphicsDidChange = NO;
static int selectionChangeCount = 0;
static int graphicsChangeCount = 0;
static int addedGraphicsCount = 0;
static int removedGraphicsCount = 0;
static int addedSelectionCount = 0;
static int removedSelectionCount = 0;
static NSIndexSet *_changeIndexes;
static id insertedGraphics;
static id removedGraphics;

@interface SKTGraphicViewModelTests : SenTestCase {
	
    SKTGraphicViewModel		*_viewModel;
    NSLock					*_testLock;
}

@end

@implementation SKTGraphicViewModelTests

//-- view model has a current SketchModel

//-- it signs up to the currentSketchModel for certain content - if a filter isnt installed for that content
//-- it is installed on our request

//-- the model then sorts this and things like rulers and grids into 'drawable content'

// static NSAutoreleasePool *pool;

+ (void)resetObservers {
    
	selectionDidChange = NO;
	graphicsDidChange = NO;
	selectionChangeCount = 0;
	graphicsChangeCount = 0;
	addedGraphicsCount = 0;
	removedGraphicsCount = 0;
	addedSelectionCount = 0;
	removedSelectionCount = 0;
}

- (void)setUp {

//	[[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.3]];
//	pool = [[NSAutoreleasePool alloc] init];
		
     _viewModel = [[SKTGraphicViewModel alloc] init];
	[_viewModel setUpSketchViewModel];
}

- (void)tearDown {
	
    [_viewModel cleanUpSketchViewModel];
	[_viewModel release];
	
//	[pool release];	
//	[[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.3]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)vcontext {
	
	NSString *context = (NSString *)vcontext;
	if(context==nil)
		[NSException raise:@"MUST SUPPLY A CONTEXT" format:@"MUST SUPPLY A CONTEXT"];
	
	id changeKind = [change objectForKey:NSKeyValueChangeKindKey];
	// id changeIndexes = [change objectForKey:NSKeyValueChangeIndexesKey];
	id newStuff = [change objectForKey:NSKeyValueChangeNewKey];
	id oldStuff = [change objectForKey:NSKeyValueChangeOldKey];
	
	if( [context isEqualToString:@"SKTGraphicViewModelTests"] )
	{
		if( [keyPath isEqualToString:@"sktSceneItems"] ){
            
			graphicsDidChange = YES;
			graphicsChangeCount++;

			switch ([changeKind intValue]) 
			{
				case NSKeyValueChangeInsertion:
					STAssertTrue([newStuff count]>0, @"dd");
					addedGraphicsCount = [newStuff count];
					insertedGraphics = newStuff;
					break;
				case NSKeyValueChangeReplacement:
					[NSException raise:@"UNSUPPORTED" format:@"UNSUPPORTED"];
					break;
				case NSKeyValueChangeSetting:
					
					break;
				case NSKeyValueChangeRemoval:
					STAssertTrue([oldStuff count]>0, @"dd");
					removedGraphicsCount = [oldStuff count];
					removedGraphics = oldStuff;
					break;
				default:
					[NSException raise:@"unpossible" format:@"unpossible"];
					break;
			}
			
	} else if( [keyPath isEqualToString:@"sktSceneSelectionIndexes"] ){

		selectionDidChange = YES;
		selectionChangeCount++;
		_changeIndexes = newStuff; // it is the indexes that we are observing. Not the indexes of the items that we are observing
		
		switch ([changeKind intValue]) 
		{
			case NSKeyValueChangeInsertion:
				STAssertTrue([newStuff count]>0, @"dd");
				addedSelectionCount = [newStuff count];
				break;
			case NSKeyValueChangeReplacement:
				[NSException raise:@"UNSUPPORTED" format:@"UNSUPPORTED"];
				break;
			case NSKeyValueChangeSetting:
				NSLog(@"change");
				break;
			case NSKeyValueChangeRemoval:
				STAssertTrue([oldStuff count]>0, @"dd");
				removedSelectionCount = [oldStuff count];
				break;
			default:
				[NSException raise:@"unpossible" format:@"unpossible"];
				break;
		}
        }
    } else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

+ (OCMockObject *)mockSketchModel {
	
	BOOL expectedValue = NO; // you need to asign expectedValue to a variable or it doesn't work !(?)
	id mockModel = [OCMockObject mockForClass:NSClassFromString(@"SHNodeGraphModel")];
	[[mockModel expect] registerContentFilter:OCMOCK_ANY andUser:OCMOCK_ANY options:OCMOCK_ANY];
	[[mockModel expect] unregisterContentFilter:[SKTGraphicsProvidor class] andUser:OCMOCK_ANY options:OCMOCK_ANY];
	[[[mockModel stub] andReturn:OCMOCK_VALUE(expectedValue)] performSelector: NSSelectorFromString(@"isNSString__")];
	[[[mockModel stub] andReturn:OCMOCK_VALUE(expectedValue)] respondsToSelector:@selector(descriptionWithLocale:indent:)];
	[[[mockModel stub] andReturn:OCMOCK_VALUE(expectedValue)] respondsToSelector:@selector(descriptionWithLocale:)];
	return mockModel;
}

/*
 * Verify that we are notified that graphics and selection change when we change the model
 */
- (void)testSetSketchModel {
	// - (void)setSketchModel:(SHNodeGraphModel *)value {
	
	SHNodeGraphModel *sModel = [[[SHNodeGraphModel alloc] init] autorelease];
	
	[_viewModel addObserver:self forKeyPath:@"sktSceneItems" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SKTGraphicViewModelTests"];
	[_viewModel addObserver:self forKeyPath:@"sktSceneSelectionIndexes" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SKTGraphicViewModelTests"];
	
	[[self class] resetObservers];
	[_viewModel setSketchModel: sModel];
	
	STAssertTrue( graphicsDidChange==YES, @"oops - %i", graphicsDidChange );
	STAssertTrue( selectionDidChange==YES, @"oops - %i", selectionDidChange );
	STAssertTrue( graphicsChangeCount==1, @"oops - %i", graphicsChangeCount );
	STAssertTrue( selectionChangeCount==1, @"oops - %i", selectionChangeCount );
	
	SHNodeGraphModel *sModel2 = [[[SHNodeGraphModel alloc] init] autorelease];
	SKTCircle *newGraphic = [[[SKTCircle alloc] init] autorelease];
	[sModel2 insertGraphic:newGraphic atIndex:0];	
	[[self class] resetObservers];
		 
	/* This model needs to have register content filter called */
	[_viewModel setSketchModel: sModel2];
	STAssertTrue([_viewModel.sktSceneItems count]==1, @"eh %i", [_viewModel.sktSceneItems count]);

	[_viewModel removeObserver:self forKeyPath:@"sktSceneSelectionIndexes"];
	[_viewModel removeObserver:self forKeyPath:@"sktSceneItems"];
}

- (void)testObservencies {

	SHNodeGraphModel *sModel = [[[SHNodeGraphModel alloc] init] autorelease];
    
    // this already has expectations on it
	SHNodeGraphModel *mockModel = [[[SHNodeGraphModel alloc] init] autorelease];

    // -- check that it observes itself a new model being set
	[_viewModel setSketchModel: mockModel];

	[_viewModel setSketchModel: sModel];

    // -- check that we are now observing relevant changes to the model
	[_viewModel addObserver:self forKeyPath:@"sktSceneItems" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SKTGraphicViewModelTests"];
	[_viewModel addObserver:self forKeyPath:@"sktSceneSelectionIndexes" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SKTGraphicViewModelTests"];

	[[self class] resetObservers];
	SKTCircle *newGraphic = [[[SKTCircle alloc] init] autorelease];
	[sModel insertGraphic:newGraphic atIndex:0];
    
    // very we got more sktSceneItems
	STAssertTrue(graphicsDidChange==YES, @"oops");
	STAssertTrue(selectionDidChange==NO, @"oops");
	STAssertTrue(graphicsChangeCount==1, @"oops");
	STAssertTrue(addedGraphicsCount==1, @"oops");

    // verify we are observing selection
	[[self class] resetObservers];
	[_viewModel changeSktSceneSelectionIndexes:[NSIndexSet indexSetWithIndex:0]];
	STAssertTrue(graphicsDidChange==NO, @"oops");
	STAssertTrue(selectionDidChange==YES, @"oops");
	STAssertTrue(selectionChangeCount==1, @"oops");
    
	// try removing
	[_viewModel changeSktSceneSelectionIndexes:[NSIndexSet indexSet]];
	[[self class] resetObservers];
	[sModel removeGraphicAtIndex:0];
	STAssertTrue(graphicsDidChange==YES, @"oops");
	STAssertTrue(selectionDidChange==NO, @"oops");
	STAssertTrue(graphicsChangeCount==1, @"oops");
	STAssertTrue(removedGraphicsCount==1, @"oops");

	[_viewModel removeObserver:self forKeyPath:@"sktSceneSelectionIndexes"];
	[_viewModel removeObserver:self forKeyPath:@"sktSceneItems"];
}

- (void)testSketchModelCanPretendToBeADataSource_eek {

	SHNodeGraphModel *sModel = [[[SHNodeGraphModel alloc] init] autorelease];
	[_viewModel setSketchModel: sModel];
	SKTCircle *newGraphic = [[[SKTCircle alloc] init] autorelease];
	SKTCircle *anotherNewGraphic = [[[SKTCircle alloc] init] autorelease];
	[sModel insertGraphic:newGraphic atIndex:0];
	[sModel insertGraphic:anotherNewGraphic atIndex:1];

    id graphics = _viewModel;
    NSInteger graphicCount = [graphics countOfSktSceneItems];
    for( NSInteger index = graphicCount - 1; index>=0; index-- )
	{
		logInfo([graphics objectInSktSceneItemsAtIndex:index]);
	}

	STAssertTrue([graphics countOfSktSceneItems]==2, @"wha? %i", [graphics countOfSktSceneItems]);
	id anOb = [graphics objectInSktSceneItemsAtIndex:0];
	STAssertTrue(anOb==newGraphic, @"wha? %@", anOb);
}

- (void)testSetSktSceneSelectionIndexes {
	// - (void)setSktSceneSelectionIndexes:(NSMutableIndexSet *)value
	
	SHNodeGraphModel *sModel = [[[SHNodeGraphModel alloc] init] autorelease];
	SKTGraphic *newGraphic1 = [[[SKTGraphic alloc] init] autorelease];
	SKTGraphic *newGraphic2 = [[[SKTGraphic alloc] init] autorelease];
	SKTGraphic *newGraphic3 = [[[SKTGraphic alloc] init] autorelease];
	[sModel insertGraphic:newGraphic1 atIndex:0];
	[sModel insertGraphic:newGraphic2 atIndex:0];
	[sModel insertGraphic:newGraphic3 atIndex:0];

	[[self class] resetObservers];
	[_viewModel addObserver:self forKeyPath:@"sktSceneItems" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SKTGraphicViewModelTests"];
	[_viewModel addObserver:self forKeyPath:@"sktSceneSelectionIndexes" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SKTGraphicViewModelTests"];
	[_viewModel setSketchModel: sModel];
	
	// -- select some items in nodegraph - verify that we received the correct selection notification
	STAssertTrue([_viewModel.sktSceneItems count]==3, @"eh %i", [_viewModel.sktSceneItems count]);
	
	[sModel setSelectionIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)]];
	STAssertTrue( [_changeIndexes count]==2 && [_changeIndexes containsIndex:1], @"failed to get the correct selection notification %i, %i", [_changeIndexes count], [_changeIndexes containsIndex:1] );
	
	// -- The selected SKTGraphics should have been swapped for decorators
	STAssertTrue([[_viewModel objectInSktSceneItemsAtIndex:0] isKindOfClass: NSClassFromString(@"SKTDecorator_Selected")], @"oh no!");
	STAssertTrue([[_viewModel objectInSktSceneItemsAtIndex:1] isKindOfClass: NSClassFromString(@"SKTDecorator_Selected")], @"oh no!");

	// -- unselect the items in nodegraph
	[sModel setSelectionIndexes:[NSIndexSet indexSet]];
	STAssertTrue([[_viewModel objectInSktSceneItemsAtIndex:0] isKindOfClass: NSClassFromString(@"SKTGraphic")], @"oh no!");
	STAssertTrue([[_viewModel objectInSktSceneItemsAtIndex:1] isKindOfClass: NSClassFromString(@"SKTGraphic")], @"oh no!");
		
	[_viewModel removeObserver:self forKeyPath:@"sktSceneSelectionIndexes"];
	[_viewModel removeObserver:self forKeyPath:@"sktSceneItems"];
}

- (void)testInsertSktSceneItemsAtIndexes {
	// - (void)insertSktSceneItems:(NSArray *)items atIndexes:(NSIndexSet *)indexes;
	
	SHNodeGraphModel *sModel = [[[SHNodeGraphModel alloc] init] autorelease];
	[_viewModel setSketchModel: sModel];
	[_viewModel addObserver:self forKeyPath:@"sktSceneItems" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SKTGraphicViewModelTests"];
	[_viewModel addObserver:self forKeyPath:@"sktSceneSelectionIndexes" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SKTGraphicViewModelTests"];
	[[self class] resetObservers];
	[sModel insertGraphic:[[[SKTGraphic alloc] init] autorelease] atIndex:0];
	
	//-- check that we have 1 inserted graphic.
	STAssertTrue( [insertedGraphics count]==1, @"doh %i", [insertedGraphics count] );
	
	[_viewModel removeObserver:self forKeyPath:@"sktSceneSelectionIndexes"];
	[_viewModel removeObserver:self forKeyPath:@"sktSceneItems"];
}

- (void)testRemoveSktSceneItemsAtIndexes {
	// - (void)removeSktSceneItemsAtIndexes:(NSIndexSet *)indexes;
	
	SHNodeGraphModel *sModel = [[[SHNodeGraphModel alloc] init] autorelease];
	[_viewModel setSketchModel: sModel];
	[sModel insertGraphic:[[[SKTGraphic alloc] init] autorelease] atIndex:0];
	[sModel setSelectionIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)]];

	[_viewModel addObserver:self forKeyPath:@"sktSceneItems" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SKTGraphicViewModelTests"];
	[_viewModel addObserver:self forKeyPath:@"sktSceneSelectionIndexes" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SKTGraphicViewModelTests"];
	[[self class] resetObservers];
	
	//	-- the 'old items' we observe here should not contain proxies
	[_viewModel changeSktSceneSelectionIndexes:[NSIndexSet indexSet]]; // selection must be empty before deleting
	[sModel removeGraphicAtIndex:0];
	STAssertTrue( [removedGraphics count]==1, @"doh %i", [removedGraphics count] );
	STAssertTrue( [[removedGraphics objectAtIndex:0] isKindOfClass: NSClassFromString(@"SKTGraphic")], @"oh no!");

	[_viewModel removeObserver:self forKeyPath:@"sktSceneSelectionIndexes"];
	[_viewModel removeObserver:self forKeyPath:@"sktSceneItems"];
}

// [NSException raise:@"WE NEVER MUTATE THE SELECTION!" format:@"UNSUPPORTED"];
// -- test the insertion and removal of selection on the model gives us the correct notifications here
// - (void)test {
// addedSelectionCount = 0;
// removedSelectionCount = 0;
//}

@end