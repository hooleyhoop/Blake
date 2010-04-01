//
//  EditingViewControllerTests.m
//  DebugDrawing
//
//  Created by steve hooley on 18/09/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//
#import "EditingViewController.h"
#import "CALayerStarView.h"
#import "MouseInputAdaptorProtocol.h"
#import "ToolBarController.h"
#import "DomainContext.h"
#import "StarScene.h"
#import "SceneDisplay.h"
#import "WidgetDisplay.h"
#import "SwappedInIvar.h"
#import "ZoomController.h"

@interface EditingViewControllerTests : SenTestCase {
	
	EditingViewController *_viewController;
}

@end

@implementation EditingViewControllerTests

- (void)setUp {
	
	_viewController = [[EditingViewController alloc] init];
}

- (void)tearDown {
	
	[_viewController release];
}

- (void)testSetupWithDomainContext {
	// - (void)setupWithDomainContext:(DomainContext *)cntx
	
	OCMockObject *mockDC = MOCK(DomainContext);
	OCMockObject *mockView = MOCK(CALayerStarView);
	OCMockObject *mockLayer = MOCK(CALayer);
	OCMockObject *mockScene = MOCK(StarScene);
	OCMockObject *mockRootProxy = MOCK(NodeProxy);
	OCMockObject *mockRootNode = MOCK(SHNode);

	[[[mockScene expect] andReturn:mockRootProxy] rootProxy];
	[[[mockRootProxy stub] andReturn:mockRootNode] originalNode];
	Class testClass = [Graphic class];
	[[[mockRootNode stub] andReturnBOOLValue:NO] isKindOfClass:testClass];
	[[[mockRootNode stub] andReturn:[NodeName makeNameWithString:@"node1"]] name];
	[[[mockRootNode stub] andReturnBOOLValue:NO] allowsSubpatches];

	[_viewController setView:(id)mockView];
	
	[[mockView expect] setupCALayerStuff];
	[[[mockView stub] andReturn:mockLayer] layer];
	NSRect mockFrame = NSMakeRect(0,0,10,10);
	[[[mockView stub] andReturnValue:OCMOCK_VALUE(mockFrame)] frame];
	
	[[[mockLayer stub] andReturn:[NSArray array]] sublayers];

	[[mockLayer stub] insertSublayer:OCMOCK_ANY atIndex:0];

	[[[mockDC expect] andReturn:mockScene] starScene];
	
	[[mockScene expect] addObserver:OCMOCK_ANY forKeyPath:@"currentProxy" options:NSKeyValueObservingOptionOld context:@"SceneDisplay"];
	[[mockScene expect] addObserver:OCMOCK_ANY forKeyPath:@"currentFilteredContent" options:NSKeyValueObservingOptionOld context:@"SceneDisplay"];
	[[mockScene expect] addObserver:OCMOCK_ANY forKeyPath:@"currentFilteredContentSelectionIndexes" options:0 context:@"SceneDisplay"];
	
	// do it
	[_viewController setupWithDomainContext:(id)mockDC];
	STAssertTrue( [_viewController domainContext]==(id)mockDC, @"hmm");
	
	[_viewController setView:nil];
	
	// verify
	[mockView verify];
	[mockScene verify];
	
	[[mockScene expect] removeObserver:OCMOCK_ANY forKeyPath:@"currentProxy"];
	[[mockScene expect] removeObserver:OCMOCK_ANY forKeyPath:@"currentFilteredContent"];
	[[mockScene expect] removeObserver:OCMOCK_ANY forKeyPath:@"currentFilteredContentSelectionIndexes"];
	[[[mockScene stub] andReturn:mockRootProxy] rootProxy];

	[_viewController unSetupWithDomainContext:(id)mockDC];
}

- (void)testFlagsChanged {
	// - (void)flagsChanged:(NSEvent *)event

	OCMockObject *mockEvent = MOCKFORCLASS([NSEvent class]);
	OCMockObject *mockToolBarController = MOCKFORCLASS([ToolBarController class]);
	
	unsigned short shiftKeyCode = 0x38; //SHIFT
	unsigned short altKeyCode = 0x38; //ALT
	[[[mockEvent expect] andReturnValue:OCMOCK_VALUE(shiftKeyCode)] keyCode];
	[[[mockEvent expect] andReturnUIntValue:0] modifierFlags];
	
	[[mockToolBarController expect] shift:NO];
	_viewController.inputController = (id)mockToolBarController;

	[_viewController flagsChanged:(id)mockEvent];
}

- (void)testMouseDown {
	// - (void)mouseDown:(NSEvent *)event
	
	CALayerStarView *stubbedView = [[[CALayerStarView alloc] initWithFrame:NSMakeRect(0, 0, 100, 100)] autorelease];
	
	OCMockObject *mockEvent = [OCMockObject mockForClass:[NSEvent class]];
	OCMockObject *mockMouseAdaptor = [OCMockObject mockForProtocol:@protocol(MouseInputAdaptorProtocol)];
	
	[_viewController setView:stubbedView];
	_viewController.inputController = (id)mockMouseAdaptor;
	
	[[mockMouseAdaptor expect] _mouseDownEvent:(id)mockEvent inStarView:(id)stubbedView];
	
	[_viewController mouseDown:(id)mockEvent];
	
	[mockEvent verify];
	[mockMouseAdaptor verify];
	
	[_viewController setView:nil];
}

- (void)testGraphDidUpdate {
	// - (void)graphDidUpdate
	
	OCMockObject *mockSceneRenderer = MOCK(SceneDisplay);
	OCMockObject *mockWidgetRenderer = MOCK(WidgetDisplay);

	SwappedInIvar *swapIn1 = [SwappedInIvar swapFor:_viewController :"_sceneRenderer" :mockSceneRenderer];
	SwappedInIvar *swapIn2 = [SwappedInIvar swapFor:_viewController :"_widgetRenderer" :mockWidgetRenderer];

	[[mockSceneRenderer expect] graphDidUpdate];
	[[mockWidgetRenderer expect] graphDidUpdate];

	[_viewController graphDidUpdate];
	[mockSceneRenderer verify];
	[mockWidgetRenderer verify];
	
	[swapIn1 putBackOriginal];
	[swapIn2 putBackOriginal];
}

- (void)testObserveZoomWithContext {
	// - (void)observeZoom:(id)observer withContext:(void *)context
	// - (void)removeZoomObserver:(NSObject *)observer
	
	OCMockObject *mockZoomer = MOCK(ZoomController);
	SwappedInIvar *swapIn1 = [SwappedInIvar swapFor:_viewController :"_contentZoomController" :mockZoomer];

	[[mockZoomer expect] addObserver:self forKeyPath:@"zoomMatrix" options:0 context:@"Tests"];
	[[mockZoomer expect] removeObserver:self forKeyPath:@"zoomMatrix"];

	[_viewController observeZoom:self withContext:@"Tests"];
	[_viewController removeZoomObserver:self];
	[mockZoomer verify];
	
	[swapIn1 putBackOriginal];
}

- (void)testAddWidget {
	// - (void)addWidget:(NSObject<Widget_protocol> *)value
	// - (void)removeWidget:(NSObject<Widget_protocol> *)value
	
	OCMockObject *mockWidgetRenderer = MOCK(WidgetDisplay);
	OCMockObject *mockWidget = MOCKFORPROTOCOL(Widget_protocol);
	
	SwappedInIvar *swapIn2 = [SwappedInIvar swapFor:_viewController :"_widgetRenderer" :mockWidgetRenderer];

	[[mockWidgetRenderer expect] addWidget:(id)mockWidget];
	[[mockWidgetRenderer expect] removeWidget:(id)mockWidget];

	[_viewController addWidget:(id)mockWidget];
	[_viewController removeWidget:(id)mockWidget];
	
	[mockWidgetRenderer verify];
	
	[swapIn2 putBackOriginal];
}

- (void)testEventPtToViewPoint {
	// - (NSPoint)eventPtToViewPoint:(NSPoint)pt

	OCMockObject *mockView = MOCK(CALayerStarView);
	[_viewController setView:(id)mockView];
	
	NSPoint testPt = NSMakePoint(10, 10);
	[[[mockView expect] andReturnValue:OCMOCK_VALUE(testPt)] convertPoint:testPt fromView:nil];
	[[[mockView expect] andReturnValue:OCMOCK_VALUE(testPt)] convertPointToBase:testPt];

	NSPoint resultPt = [_viewController eventPtToViewPoint:testPt];
	STAssertTrue( NSEqualPoints(resultPt, testPt), @"doh" );
	[mockView verify];
	
	[_viewController setView:nil];
}

- (void)testEventPointToContentPoint {
	// - (CGPoint)eventPointToContentPoint:(NSPoint)pt
	
	OCMockObject *mockView = MOCK(CALayerStarView);
	[_viewController setView:(id)mockView];
	
	NSPoint testPt = NSMakePoint(10, 10);
	CGPoint resultPt = CGPointMake(20,20);
	[[[mockView expect] andReturnValue:OCMOCK_VALUE(testPt)] convertPoint:testPt fromView:nil];
	[[[mockView expect] andReturnValue:OCMOCK_VALUE(testPt)] convertPointToBase:testPt];
	
	OCMockObject *mockZoomer = MOCK(ZoomController);
	[[[mockZoomer expect] andReturnValue:OCMOCK_VALUE(resultPt)] inversePt:testPt];
	SwappedInIvar *swapIn1 = [SwappedInIvar swapFor:_viewController :"_contentZoomController" :mockZoomer];

	CGPoint result = [_viewController eventPointToContentPoint:testPt];
	[mockView verify];
	[mockZoomer verify];
	[swapIn1 putBackOriginal];
}

- (void)testViewPointToScenePoint {
	// - (CGPoint)viewPointToScenePoint:(NSPoint)pt

	NSPoint testPt = NSMakePoint(10, 10);
	CGPoint resultPt = CGPointMake(20,20);
	
	OCMockObject *mockZoomer = MOCK(ZoomController);
	[[[mockZoomer expect] andReturnValue:OCMOCK_VALUE(resultPt)] inversePt:testPt];
	SwappedInIvar *swapIn1 = [SwappedInIvar swapFor:_viewController :"_contentZoomController" :mockZoomer];
	
	CGPoint result = [_viewController viewPointToScenePoint:testPt];
	
	[swapIn1 putBackOriginal];
}

- (void)testPanByXy {
	// - (void)panByX:(CGFloat)xVal y:(CGFloat)yVal

	OCMockObject *mockZoomer = MOCK(ZoomController);
	SwappedInIvar *swapIn1 = [SwappedInIvar swapFor:_viewController :"_contentZoomController" :mockZoomer];
	[[mockZoomer expect] panByX:1.0f y:2.0f];
	
	[_viewController panByX:1.0f y:2.0f];
	
	[mockZoomer verify];
	[swapIn1 putBackOriginal];
}

- (void)testzoomFromTo {
	// - (void)zoomFrom:(NSPoint)pt1 to:(NSPoint)pt2

	OCMockObject *mockZoomer = MOCK(ZoomController);
	SwappedInIvar *swapIn1 = [SwappedInIvar swapFor:_viewController :"_contentZoomController" :mockZoomer];

	NSPoint p1 = NSMakePoint(10, 10);
	NSPoint p2 = NSMakePoint(20, 20);
	[[mockZoomer expect] zoomByX:2.0f y:0.0f];

	[_viewController zoomFrom:p1 to:p2];
	
	[mockZoomer verify];
	[swapIn1 putBackOriginal];
}
				
@end
