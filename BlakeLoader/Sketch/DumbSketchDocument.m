//
//  DumbSketchDocument.m
//  BlakeLoader2
//
//  Created by steve hooley on 19/07/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "DumbSketchDocument.h"


@implementation DumbSketchDocument

@synthesize nodeGraphModel = _nodeGraphModel;

- (id)init {
	if((self=[super init])!=nil){
		[self setNodeGraphModel: [[[SHNodeGraphModel alloc] init] autorelease]];
	}
	return self;
}

- (void)dealloc {
	[super dealloc];
}

- (NSString *)windowNibName {
    // Implement this to return a nib to load OR implement -makeWindowControllers to manually create your controllers.
    return @"DrawWindow";
}

- (void)makeWindowControllers {

	// SKTWindowController* newWindowController = [[[SKTWindowController alloc] init] autorelease];
	
	// dont forget addWindowController - somehow the order of these is important. ie you cant set the windowControllers document if you havent added the windowcontroller
	// [self addWindowController:newWindowController];
    
    /* This is called automatically when you add the windowcontroller to the documents windowcontrollers
    [_sketchWindowController setDocument: doc];
    */
	
#warning leaking
	[[[SketchExtension alloc] init] makeWindowControllerForDocument: self];
}


- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    return YES;
}



@end
