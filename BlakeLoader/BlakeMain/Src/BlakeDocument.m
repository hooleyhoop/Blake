//
//  BlakeDocument.m
//  Pharm
//
//  Created by Steve Hooley on 25/03/2007.
//  Copyright 2007 HooleyHoop. All rights reserved.
//
#import "defs.h"
#import "BlakeDocument.h"
#import "HighLevelBlakeDocumentActions.h"
#import "BlakeDocumentController.h"
#import "BlakeController.h"

@implementation BlakeDocument

@synthesize nodeGraphModel = _nodeGraphModel;
@synthesize shDocumentController = _shDocumentController;

#pragma mark class methods
+ (NSArray *)readableTypes {
	return [NSArray arrayWithObjects:documentExtension, @"binary", @"xml", nil];
}
/* woo woo - you can have a little selector box in the save dialog to save different types of doc */
+ (NSArray *)writableTypes {
	// see also - (NSArray *)writableTypesForSaveOperation:(NSSaveOperationType)saveOperation
	return [NSArray arrayWithObjects:documentExtension, @"binary", @"xml", nil];
}

// + (BOOL)isNativeType:(NSString *)type;

#pragma mark init methods
- (id)init {
	
	self = [super init];
	if( self )
    {
		self.nodeGraphModel = [SHNodeGraphModel makeEmptyModel];
		
		NSUndoManager *undoMan1 = [self undoManager];
		NSAssert(undoMan1 && YES==[undoMan1 isUndoRegistrationEnabled], @"undo should be enabled");

		/* Using the document's undomanager should give us some -isDirty functionality on the doc for free */
		[_nodeGraphModel replaceUndomanager:undoMan1];

		/* In order to verify the result immediately we need to temporarily disable groupsByEvent */
		[undoMan1 setGroupsByEvent:NO];
		NSAssert([undoMan1 canUndo]==NO, @"we should not have any changes at this point");
		
		// Must begin an undo group
		[undoMan1 beginUndoGrouping];
		[self makeEmptyGroupInCurrentNodeWithName:@"circle"];
		[self makeEmptyGroupInCurrentNodeWithName:@"square"];
		[self makeEmptyGroupInCurrentNodeWithName:@"triangle"];

		[self makeInputInCurrentNodeWithType:@"mockDataType"];
		[self makeInputInCurrentNodeWithType:@"mockDataType"];
		[self makeInputInCurrentNodeWithType:@"mockDataType"];

		[self makeOutputInCurrentNodeWithType:@"mockDataType"];
		[self makeOutputInCurrentNodeWithType:@"mockDataType"];
		[self makeOutputInCurrentNodeWithType:@"mockDataType"];
		
		NSArray *inputs = [[[_nodeGraphModel currentNodeGroup] inputs] array];
		NSArray *outputs = [[[_nodeGraphModel currentNodeGroup] outputs] array];
		[self connectOutletOfInput:[inputs objectAtIndex:0] toInletOfOutput:[outputs objectAtIndex:0]];
		[self connectOutletOfInput:[inputs objectAtIndex:1] toInletOfOutput:[outputs objectAtIndex:1]];
		[self connectOutletOfInput:[inputs objectAtIndex:2] toInletOfOutput:[outputs objectAtIndex:2]];
		[undoMan1 endUndoGrouping];

		NSAssert([undoMan1 canUndo]==YES, @"we should have 1 change at this point");
		NSAssert([self isDocumentEdited]==YES, @"we should have 1 change at this point");

		[undoMan1 removeAllActions];
		[self updateChangeCount: NSChangeCleared];
		
		NSAssert([undoMan1 canUndo]==NO, @"we should not have any changes at this point");
		NSAssert([self isDocumentEdited]==NO, @"we should be clean at this point");
		
		[undoMan1 setGroupsByEvent:YES];
	}
	return self;
}


- (void)dealloc  {

	// -- we need to kill the window before we kill the document.. to make sure this happens
	// -- we have windowController retaining the document and only releasing it when window controller is released
	// == THEREFORE we clean up in '-close'
	[super dealloc];
}

//- (void)awakeFromNib
//{
//	logInfo(@"BlakeDocument.m: awakeFromNib");
//	[super awakeFromNib];
//}

#pragma mark action methods
- (BOOL)readFromURL:(NSURL *)inAbsoluteURL ofType:(NSString *)inTypeName error:(NSError **)outError  {

	// Default implementation would be..
	// - readFromURL:ofType:error:			// get the fileWrapper
	// - readFromFileWrapper:ofType:error:	// read the fileWrapper from Disk to an NSData
	// - readFromData:ofType:error:			// read the NSData
	
	// depending on the type we should set different delegates
	// [_nodeGraphModel setSavingAndLoadingDelegate:[SHFScriptNodeGraphLoader nodeGraphLoader]];
//	logInfo(@"BlakeDocument.m: readFromURL %@", inAbsoluteURL );
    BOOL readSuccess = NO;
//nov09	SHNode* rootNodeFromFile = [_nodeGraphModel loadNodeFromFile:[inAbsoluteURL path]];
//nov09	if(rootNodeFromFile!=nil){
//nov09		readSuccess = YES;
//nov09		[_nodeGraphModel setRootNodeGroup:rootNodeFromFile];
//nov09		[self setFileURL: inAbsoluteURL];
//nov09		
//nov09		[[self undoManager] removeAllActions];
//nov09		[self updateChangeCount: NSChangeCleared];		
//nov09	}
    return readSuccess;
}

- (BOOL)writeToURL:(NSURL *)inAbsoluteURL ofType:(NSString *)inTypeName error:(NSError **)outError {

	// depending on the type we should set different delegates
	// [_nodeGraphModel setSavingAndLoadingDelegate:[SHFScriptNodeGraphLoader nodeGraphLoader]];

//	logInfo(@"BlakeDocument.m: writeToURL %@ ofType %@", inAbsoluteURL, inTypeName);
	BOOL writeSuccess = [_nodeGraphModel saveNode:nil toFile:[inAbsoluteURL path]];
//nov09	if(writeSuccess){
//nov09		[self setFileURL: inAbsoluteURL];
//nov09		[[NSDocumentController sharedDocumentController] noteNewRecentDocumentURL: inAbsoluteURL];
//nov09		/* What is the rationale behind clearing the undo stack when you save like most apps do ? */
//nov09	//	[[self undoManager] removeAllActions];
//nov09		[self updateChangeCount: NSChangeCleared];		
//nov09	}
//nov09    return writeSuccess;
	return NO;
}

//- (IBAction)revertDocumentToSaved:(id)sender
//{
//	logError(@"Revert document to saved %@", [self fileURL]);
//	[super revertDocumentToSaved:sender];
//}

//- (BOOL)_hasOverrideForSelector:(SEL)aSelector {
//	return [super _hasOverrideForSelector:aSelector];
//}

- (BOOL)revertToContentsOfURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError {

//	logInfo(@"BlakeDocument.m: revertToContentsOfURL");
	return [self readFromURL:absoluteURL ofType:typeName error:outError];
	/* Default implementation does the following, but we already do these in readFromURL */
	// [self setFileModificationDate:theModificationDate]
	// [self updateChangeCount:NSChangeCleared]}
}

- (void)makeWindowControllers {

	NSAssert(_shDocumentController, @"why haven't we got a document controller?");

	//TODO: make highest priority window controller
	NSArray *winClasses = [_shDocumentController windowControllerClasses];
	for( NSString *winControlClass in winClasses ){
		
		Class winCClass = NSClassFromString(winControlClass);
		if(winCClass){
			// dont forget addWindowController - somehow the order of these is important. ie you cant set the windowControllers document if you havent added the windowcontroller
			SHWindowController* newWindowController = [[[winCClass alloc] initWithWindowNibName:[winCClass nibName]] autorelease];
			[self addWindowController:newWindowController];
			[newWindowController setDocument:self];
			/* we need the last window to close the document */
			[newWindowController setShouldCloseDocument:YES];
		}
	}

//	/* This isn't the main window */
//	[treeViewWindowController setShouldCloseDocument:NO];

//	[[treeViewWindowController window] makeMainWindow];
//	[[treeViewWindowController window] makeKeyAndOrderFront:self];
	// the app controller wants to know if the user closes the main window by hitting cmd-w or with the close button on the window
	// it registers to get notified of this event
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMainWindowWillClose:) name:NSWindowWillCloseNotification object:[treeViewWindowController window]];
}

/*	clean up here rather than in dealloc. I dont think you should call this to close a document.. 
	you should close all the documents windows or something un straightforward like that		*/
- (void)close {

	// -- we need to shut down the view and clean up and shit
	if(_isClosed==NO){
        
		[super close];

		self.nodeGraphModel=nil;

	}// else {
//		logWarning(@"How are we trying to close a closed doc?");
//	}

}

//+ (BOOL)_hasOverideForSelector:(SEL)value {
//
//	logInfo(@"hasOverideForSelector %@", NSStringFromSelector(value));
//	return [super _hasOverideForSelector:value];
//}


#pragma mark notification methods
//- (void)windowControllerWillLoadNib:(NSWindowController *)windowController {
//	logInfo(@"BlakeDocument.m: windowControllerWillLoadNib");
//}

//- (void)windowControllerDidLoadWindowNib:(NSWindowController *)aController {
//    // Add any code here that needs to be executed once the windowController has loaded the document's window.
//	logInfo(@"BlakeDocument.m: windowControllerDidLoadWindowNib");
//    [super windowControllerDidLoadWindowNib:aController];
////    [textView setAllowsUndo:YES];
////    if (fileContents != nil) {
////        [textView setString:fileContents];
////        fileContents = nil;
////    }
//}

#pragma mark accessor methods

//- (NSString *)windowNibName {
////	logInfo(@"BlakeDocument.m: windowNibName");
//    // Implement this to return a nib to load OR implement -makeWindowControllers to manually create your controllers.
//    return @"BlakeDocument";
//}

// called from document controller when we shut down. Useful to know about
- (void)canCloseDocumentWithDelegate:(id)delegate shouldCloseSelector:(SEL)shouldCloseSelector contextInfo:(void *)contextInfo {
	
	[super canCloseDocumentWithDelegate:delegate shouldCloseSelector:shouldCloseSelector contextInfo: contextInfo];
}

@end

