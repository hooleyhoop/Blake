//
//  MyDocument.m
//  SimpleDocumentUndo
//
//  Created by steve hooley on 10/12/2009.
//  Copyright BestBefore Ltd 2009 . All rights reserved.
//

#import "MyDocument.h"

@implementation MyDocument

- (id)init
{
    self = [super init];
    if (self) {
    
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
    
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"MyDocument";
}

- (void)addAnObjectToTheModel {
	
	if(![self.undoManager isUndoing])
		[self.undoManager setActionName:@"add object"];		
	[[self.undoManager prepareWithInvocationTarget:self] removeAnObjectFromTheModel];
}

- (void)removeAnObjectFromTheModel {
	
	if(![self.undoManager isUndoing])
		[self.undoManager setActionName:@"remove object"];		
	[[self.undoManager prepareWithInvocationTarget:self] addAnObjectToTheModel];
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
	
	NSAssert([self isDocumentEdited]==NO, @"Doc should be clean");
	NSAssert([self.undoManager canUndo]==NO, @"UndoManager should be clean");
	
	[self.undoManager setGroupsByEvent:NO];
	[self.undoManager beginUndoGrouping];

	// do something
	[self addAnObjectToTheModel];

	[self.undoManager endUndoGrouping];	
	[self.undoManager setGroupsByEvent:YES];
	
	NSAssert([self isDocumentEdited]==YES, @"Doc should be dirty");
	NSAssert([self.undoManager canUndo]==YES, @"UndoManager should be dirty");
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If the given outError != NULL, ensure that you set *outError when returning nil.

    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.

    // For applications targeted for Panther or earlier systems, you should use the deprecated API -dataRepresentationOfType:. In this case you can also choose to override -fileWrapperRepresentationOfType: or -writeToFile:ofType: instead.

    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
	return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type.  If the given outError != NULL, ensure that you set *outError when returning NO.

    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead. 
    
    // For applications targeted for Panther or earlier systems, you should use the deprecated API -loadDataRepresentation:ofType. In this case you can also choose to override -readFromFile:ofType: or -loadFileWrapperRepresentation:ofType: instead.
    
    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
    return YES;
}

@end
