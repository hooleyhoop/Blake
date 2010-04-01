//
//  SHDocument.m
//  SHShared
//
//  Created by steve hooley on 12/06/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "SHDocument.h"

@implementation SHDocument

@synthesize isClosed = _isClosed;

#pragma mark -
#pragma mark init methods

- (id)init {
	
	self = [super init];
	if( self )
    {
        _isClosed=NO;
	}
	return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)close {
    
    _isClosed=YES;
    [super close];        
}

/* Even tho we dont use this in the App (we overide it) it is useful when testing to create a doc with an empty window -
 * ..as the window managing stuff is quite fiddly. We need to have the SHDocument nib in SHShared, but it's only little
 * and not really harming anyone
*/
- (NSString *)windowNibName {

    // Implement this to return a nib to load OR implement -makeWindowControllers to manually create your controllers.
    return @"SHDocument";
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {

    // Insert code here to write your document to data of the specified type. If the given outError != NULL, ensure that you set *outError when returning nil.

    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.

    // For applications targeted for Panther or earlier systems, you should use the deprecated API -dataRepresentationOfType:. In this case you can also choose to override -fileWrapperRepresentationOfType: or -writeToFile:ofType: instead.

    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {

    // Insert code here to read your document from the given data of the specified type.  If the given outError != NULL, ensure that you set *outError when returning NO.

    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead. 
    
    // For applications targeted for Panther or earlier systems, you should use the deprecated API -loadDataRepresentation:ofType. In this case you can also choose to override -readFromFile:ofType: or -loadFileWrapperRepresentation:ofType: instead.
    
    return YES;
}

- (BOOL)hasWindowControllerOfClass:(Class)winControllerClass {
	
	for( id each in self.windowControllers ){
		if( [each isMemberOfClass:winControllerClass] )
			return YES;
	}
	return NO;
}

@end
