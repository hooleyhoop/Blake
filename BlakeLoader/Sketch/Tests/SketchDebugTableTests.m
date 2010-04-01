//
//  SketchDebugTableTests.m
//  BlakeLoader experimental
//
//  Created by steve hooley on 03/07/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "SketchDebugTableTests.h"
#import "SKTGraphicView.h"

#import "SKTGraphicViewModel.h"
#import "SKTGraphicViewController.h"
#import "StubSketchDoc.h"

@interface SketchDebugTableTests : SenTestCase {
	
	SKTGraphicViewController *skViewControl;
}

@end	

@implementation SketchDebugTableTests



// make the control

// add a view and a tableview

// manipulate the tableview and check the model

static NSAutoreleasePool *pool;
- (void)setUp {
	
    pool = [[NSAutoreleasePool alloc] init];

	// [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];

	skViewControl = [[SKTGraphicViewController alloc] init];
}

static SKTGraphicView *standInView;

- (void)tearDown {
	
	// [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];

	// the model has to stick around for longer than the view controller..
	[skViewControl release];
    [pool release];

//	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.2]];

	// sleep(20);
	//-- On viewControl you must call setUpGraphicViewController or setDocument in EVERY test
}


- (void)testDebugTableResponses {
	// - (void)setDocument:(BlakeDocument *)value;
	
	standInView = [[[SKTGraphicView alloc] init] autorelease];
	SHTableView *standInTableView = [[[SHTableView alloc] init] autorelease];
	
	// give the doc a mock sketch Model
	id mockDoc = [OCMockObject mockForClass:NSClassFromString(@"StubSketchDoc")];
	id mockSketchModel = [OCMockObject mockForClass:NSClassFromString(@"SHNodeGraphModel")];
	[[mockSketchModel stub] isKindOfClass:OCMOCK_ANY];
	[[[mockDoc stub] andReturnValue:OCMOCK_VALUE(mockSketchModel)] nodeGraphModel];
	
	STAssertEqualObjects([mockDoc nodeGraphModel], mockSketchModel, @"mock document not correctly setup");
	
	// replace the real viewModel (which is made by skViewControl on initialization) with a mock - more of an experiment really
	id mockSketchViewModel = [OCMockObject mockForClass:NSClassFromString(@"SKTGraphicViewModel")];
	[[mockSketchViewModel stub] cleanUpSketchViewModel];
    
	int options = 3;
	NSString *keyPath1 = @"sktSceneItems";
	NSString *keyPath2 = @"sktSceneSelectionIndexes";
	
	BOOL expectedValue = YES;
	NSString *cntx = @"SKTGraphicViewController";
	
	[[[mockSketchViewModel stub] andReturn:OCMOCK_VALUE(expectedValue)] isKindOfClass:[SKTGraphicViewModel class]];
	
	// there isn't an OCMOCK_ANY for int values for(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
	[[mockSketchViewModel expect] addObserver:standInView forKeyPath:@"sktSceneItems" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context: OCMOCK_ANY];
	[[mockSketchViewModel expect] addObserver:standInView forKeyPath:keyPath2 options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context: OCMOCK_ANY];
	[[mockSketchViewModel expect] setSketchModel:mockSketchModel];
	[[mockSketchViewModel expect] removeObserver:standInView forKeyPath:keyPath1];
	[[mockSketchViewModel expect] removeObserver:standInView forKeyPath:keyPath2];
	[[mockSketchViewModel expect] sktSceneItems];

	[skViewControl.sketchViewModel cleanUpSketchViewModel];
	skViewControl.sketchViewModel = [[mockSketchViewModel retain] autorelease];
	
	// This is normally called from awakeFromNib - it will fail if controller doesn't have a table view and a sketchView */
	skViewControl->_sketchView = standInView;
	skViewControl->_sketchLayerTable = standInTableView;
	[skViewControl setUpGraphicViewController]; 
	
	/* set the document on our controller.
	 * This will cause _sketchViewModel to have it's model set
	 * This will cause controller to observe changes to sktSceneItems & sktSceneSelectionIndexes in _sketchViewModel
	 * However, using this mock model will NOT trigger the notifications we need when a new model is set - 
	 * We need to do some tests with the real deal. Real Model, etc..
	 */
	[skViewControl setDocument: mockDoc];
	STAssertEqualObjects([skViewControl document], mockDoc, @"Didnt we just set the document");
	
	[skViewControl unSetupViewController];
	
	[mockSketchViewModel verify];	
	
	
	/* Difficult clean up */
	[[mockSketchViewModel stub] addObserver:standInView forKeyPath:keyPath1 options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context: OCMOCK_ANY];
	[[mockSketchViewModel stub] addObserver:standInView forKeyPath:keyPath2 options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context: OCMOCK_ANY];
	[[mockSketchViewModel stub] setSketchModel:OCMOCK_ANY];
	[[mockSketchViewModel stub] removeObserver:standInView forKeyPath:keyPath1];
	[[mockSketchViewModel stub] removeObserver:standInView forKeyPath:keyPath2];
	[[mockSketchViewModel stub] sktSceneItems];


	[skViewControl setDocument:nil];
	[skViewControl unSetupViewController];

}

@end
