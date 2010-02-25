//
//  SKTFilteringArrayControllerProviderTests.m
//  BlakeLoader experimental
//
//  Created by steve hooley on 20/06/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SKTFilteringArrayControllerProviderTests.h"
#import "SKTFilteringArrayControllerProvider.h"
#import "SketchModel.h"
#import "StubFilterUser.h"
#import "StubGraphic.h"

@implementation SKTFilteringArrayControllerProviderTests

static BOOL arrangedObjectsDidChange = NO;
static BOOL selectionIndexestDidChange = NO;
static int arrangedObjectsChangeCount = 0;
static int selectionIndexesChangeCount = 0;

+ (void)resetObservers {
	
	arrangedObjectsDidChange = NO;
	selectionIndexestDidChange = NO;
	arrangedObjectsChangeCount = 0;
	selectionIndexesChangeCount=0;
}

- (void)setUp {
	
	_model = [[SketchModel alloc] init];
	_graphicsProvider = [[SKTFilteringArrayControllerProvider alloc] init];
    [_graphicsProvider setClassFilter:@"SKTGraphic"];
	
    [_graphicsProvider setModel:_model];
	
 	[_graphicsProvider addObserver:self forKeyPath:@"arrayController.arrangedObjects" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SKTFilteringArrayControllerProviderTests"];
 	[_graphicsProvider addObserver:self forKeyPath:@"arrayController.selectionIndexes" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SKTFilteringArrayControllerProviderTests"];
}

- (void)tearDown {
	
	[_graphicsProvider cleanUpFilter];
	
 	[_graphicsProvider removeObserver:self forKeyPath:@"arrayController.selectionIndexes"];
 	[_graphicsProvider removeObserver:self forKeyPath:@"arrayController.arrangedObjects"];

	[_graphicsProvider release];
	[_model release];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)vcontext {
	
	NSString *context = (NSString *)vcontext;
	if(context==nil)
		[NSException raise:@"MUST SUPPLY A CONTEXT" format:@"MUST SUPPLY A CONTEXT"];
	
    if( [context isEqualToString:@"SKTFilteringArrayControllerProviderTests"] )
	{
		if( [keyPath isEqualToString:@"arrayController.arrangedObjects"] ){
			arrangedObjectsDidChange = YES;
			arrangedObjectsChangeCount++;
			
		} else if( [keyPath isEqualToString:@"arrayController.selectionIndexes"] ){
			selectionIndexestDidChange = YES;
			selectionIndexesChangeCount++;
		}
		
	} else {
		NSLog(@"Unknown context is %@", context);
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

- (void)testRecieveNotificationWhenAddingToModel2 {
	
	/* filter is set for SKTGraphics */
	SKTGraphic *newGraphic1 = [[[SKTGraphic alloc] init] autorelease];
	SKTGraphic *newGraphic2 = [[[SKTGraphic alloc] init] autorelease];
	SKTGraphic *newGraphic3 = [[[SKTGraphic alloc] init] autorelease];
	StubGraphic *stubGraphic1 = [[[StubGraphic alloc] init] autorelease];
	StubGraphic *stubGraphic2 = [[[StubGraphic alloc] init] autorelease];
	StubGraphic *stubGraphic3 = [[[StubGraphic alloc] init] autorelease];
	
	[[self class] resetObservers];
	[_model insertGraphics:[NSArray arrayWithObjects:newGraphic1, stubGraphic1, newGraphic2, stubGraphic2, newGraphic3, stubGraphic3, nil] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 6)]];
	
	/* we should be able to observe a change to the filtered indexes */
	STAssertTrue(arrangedObjectsDidChange, @"should not get notification here!");
	STAssertTrue(arrangedObjectsChangeCount==1, @"received incorrect number of notifications %i", arrangedObjectsChangeCount);

	//-- A MUCH TRICKIER CASE - INSERT AN OBJECT AT AN INDEX WHERE THERE IS ALREADY AN INDEX
	[[self class] resetObservers];
	SKTGraphic *newGraphic4 = [[[SKTGraphic alloc] init] autorelease];
	
	//-- index 4 in model should make this the third SKTGraphic in the filtered content
	//-- newGraphic1, stubGraphic1, newGraphic2, stubGraphic2, NEWGRAPHIC4, newGraphic3, stubGraphic3
	[_model insertGraphic:newGraphic4 atIndex:4]; 
	
	STAssertTrue(arrangedObjectsDidChange, @"didnt get notification");
	STAssertTrue(arrangedObjectsChangeCount==1, @"received incorrect number of notifications");
	
	//-- verify that filtered content doesn't update when we add an object that should be ignorned
	[[self class] resetObservers];
	StubGraphic *stubGraphic4 = [[[StubGraphic alloc] init] autorelease];
	[_model insertGraphic:stubGraphic4 atIndex:0];
	STAssertFalse(arrangedObjectsDidChange, @"should not get notification here!");
	STAssertTrue(arrangedObjectsChangeCount==0, @"received incorrect number of notifications %i", arrangedObjectsChangeCount);
	//	filteredContent = [_graphicsProvider filteredContent];
	
	//	STAssertTrue([filteredContent count]==4, @"filter isn't working!");
	//	STAssertTrue( [_graphicsProvider.registeredUsers count]==0, @"eh?");
}

@end
