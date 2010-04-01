//
//  SKTWindowControllerTests.m
//  BlakeLoader
//
//  Created by steve hooley on 11/05/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "SKTWindowControllerTests.h"
#import "SKTWindowController.h"
#import "StubSketchDoc.h"
#import "SketchPanel.h"

@interface SKTWindowControllerTests : SenTestCase {
	
	SKTWindowController *_sketchWindowController;
    StubSketchDoc *_doc;
}

@end

@implementation SKTWindowControllerTests

- (void)setUp {
	
	_sketchWindowController = [[SKTWindowController alloc] init];
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0]];

	//-- obviously not a real BlakeDocument document - just for DumbSketch
    _doc = [[StubSketchDoc alloc] init];
	SHNodeGraphModel *sModel = [[[SHNodeGraphModel alloc] init] autorelease];
	[_doc setNodeGraphModel: sModel];
	[_sketchWindowController setDocument: _doc];

	//-- make a default window
	[_sketchWindowController showWindow:self];
}

- (void)tearDown {
	
	[_sketchWindowController.window close];

	/*
	 * When a window controller is properly registered with a document
	 * the document would automatically call [_sketchWindowController setDocument:nil] when the window closses
	 * That isnt happening here so we must do it ourselves to clean up properly
	 */
	[_sketchWindowController setDocument:nil];
	
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0]];

	[_sketchWindowController release];
    [_doc release];
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0]];
}

- (void)testWindowClass {
	
	STAssertTrue([_sketchWindowController.window isKindOfClass:[SketchPanel class]], @"what is the window class? %@", _sketchWindowController.window );
}

@end
