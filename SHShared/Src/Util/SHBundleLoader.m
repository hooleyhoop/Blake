//
//  SHBundleLoader.m
//  Pharm
//
//  Created by Steve Hooley on 25/10/2005.
//  Copyright 2005 HooleyHoop. All rights reserved.
//

#import "SHBundleLoader.h"
//#import <mach-o/dyld.h>
//#import <SHShared/BBLogger.h>
//#import <ExceptionHandling/NSExceptionHandler.h>
#import <Appkit/NSWorkspace.h>

static SHBundleLoader *_bundleLoader;

/*
 * Handle our dynamic loading of bundles and frameworks
*/
@implementation SHBundleLoader

@synthesize pathsToScan=_pathsToScan;

#pragma mark -
#pragma mark class methods
//nov09+ (SHBundleLoader *)bundleLoader {
//nov09	return _bundleLoader;
//nov09}

+ (void)cleanUpSharedInstance {
	_bundleLoader = nil;
}

#pragma mark init methods
- (id)init {
	
	self = [super init];
	if(self) {
		NSAssert(_bundleLoader==nil, @"This is a kinda do once sort of affair");
		_bundleLoader = self;
		// set up to observe when framework completes loading
//nov09		[self bindFrameworkLoaded];
		_pathsToScan = [[NSMutableArray arrayWithCapacity:16] retain];
	}
	return self;
}

//b		NSMutableArray *file_paths = [NSMutableArray arrayWithCapacity:16];
//b		NSString		*aDirPath;
//b		NSArray			*dirContents;
//b		NSEnumerator	*en;
		
//28/10/05		NSString* appEnclosingPath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
		// search outside the bundle
		// [file_paths addObject:[appEnclosingPath stringByAppendingPathComponent:@"Frameworks"]];
		// [file_paths addObject:[appEnclosingPath stringByAppendingPathComponent:@"Views"]];
//28/10/05		[file_paths addObject:[appEnclosingPath stringByAppendingPathComponent:@"Operators"]];
		
		// search inside the bundle
//b		[file_paths addObject:[[[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Contents"] stringByAppendingPathComponent:@"PlugIns"] stringByAppendingPathComponent:@"Operators" ]];


		// load key frameworks first
	//	[_frameworksToLoad addObject: [[appEnclosingPath stringByAppendingPathComponent:@"Frameworks"] stringByAppendingPathComponent:@"Shared.framework"] ];
	//	[_frameworksToLoad addObject: [[appEnclosingPath stringByAppendingPathComponent:@"Frameworks"] stringByAppendingPathComponent:@"SHNodeGraph.framework"] ];
//b		NSEnumerator	*en;
//b		en = [file_paths objectEnumerator];

//b		while ((aDirPath = [en nextObject]) != nil)
//b		{
//b			dirContents = [fileManager directoryContentsAtPath: aDirPath];
//b			int i;
//b			for(i = 0; i < [dirContents count]; i++)
//b			{
//b				[_frameworksToLoad addObject: [aDirPath stringByAppendingPathComponent:(NSString *)[dirContents objectAtIndex:i]] ];
//b			}
//b		}

//	NSArray* anarray = [NSBundle allFrameworks];
//	NSLog(@"SHBundleLoader.m: All Frameworks %@", anarray);



// then send a call back when all fraeworks have loaded

// when loaded get principle class

// add to a list of nodes

// or add to a list of views

- (void)dealloc {
	
	[_pathsToScan release];
    [super dealloc];
}

#pragma mark notification methods

//nov09- (void)bindFrameworkLoaded {
//nov09
//nov09	NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
//nov09	[nc removeObserver:self];
//nov09	[nc addObserver: self selector:@selector(frameworkLoaded:) name:@"NSBundleDidLoadNotification" object:nil ];
//nov09}

//nov09- (void)unBind {
//nov09
//nov09	NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
//nov09	[nc removeObserver:self];
//nov09}

#pragma mark action methods
//nov09- (void)loadUnitTestBundle:(NSString *)pathToTestBundle {

//nov09	BOOL isDir;
//nov09    NSFileManager *fileManager = [NSFileManager defaultManager];
//nov09	[fileManager fileExistsAtPath:pathToTestBundle isDirectory:&isDir];
//nov09	if([[pathToTestBundle pathExtension]isEqualToString:@"octest"])
//nov09	{
//nov09		NSBundle* aBundle = [NSBundle bundleWithPath:pathToTestBundle];
//nov09		BOOL loadResult = [aBundle load];
//nov09		if(loadResult==NO)
//nov09			logWarning(@"Init test bundle failed to load");
//nov09	}
//nov09}

- (void)loadPlugInFrameworks {

//nov09	NSMutableDictionary* foundFrameworks = [NSMutableDictionary dictionaryWithCapacity:5];
//nov09	[self loadFrameworksAtSavedLocations:foundFrameworks];
//nov09	[self setFoundFrameworks:foundFrameworks];
}

//nov09- (void)loadPlugInDataTypes:(NSMutableDictionary *)store {
//nov09	
//nov09	// NSLog(@"SHBundleLoader.m: loadAllDataTypes TEMPORARILY DISABLED" );
//nov09	[_pathsToScan removeAllObjects];
//nov09	[self addAllPathsFrom:[[[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Contents"] stringByAppendingPathComponent:@"PlugIns"] stringByAppendingPathComponent:@"DataTypes" ]];
//nov09	[self loadClassesFromBundlesAtSavedLocations:store thatRespondToSelector: @selector(willAsk)];
//nov09}

//nov09- (void)loadPlugInOperators:(NSMutableDictionary *)store {

//nov09	[_pathsToScan removeAllObjects];
//nov09	[self addAllPathsFrom:[[[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Contents"] stringByAppendingPathComponent:@"PlugIns"] stringByAppendingPathComponent:@"Operators" ]];

	// add primitive
//nov09	[store setObject: NSClassFromString(@"SHEmptyGroupOperator") forKey:@"SHEmptyGroupOperator"];
//nov09	[store setObject: NSClassFromString(@"SHInputAttribute") forKey:@"SHInputAttribute"];
//nov09	[store setObject: NSClassFromString(@"SHOutputAttribute") forKey:@"SHOutputAttribute" ];
	
//nov09	[self loadClassesFromBundlesAtSavedLocations:store thatRespondToSelector: @selector(pathWhereResides)];	// not a good test but must be a class method
//nov09}

//nov09- (void) loadPlugInViews:(NSMutableDictionary *)store {

//nov09	[_pathsToScan removeAllObjects];
//nov09	[self addAllPathsFrom:[[[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Contents"] stringByAppendingPathComponent:@"PlugIns"] stringByAppendingPathComponent:@"Views" ]];
//nov09	[self loadFrameworksAtSavedLocations:store];
//nov09}


// stores the framework in a dictionary
//nov09- (void)loadFrameworksAtSavedLocations:(NSMutableDictionary *)store {

//nov09	NSFileManager *fileManager = [NSFileManager defaultManager];

//nov09	NSString* aDirPath, *fileObject;
//nov09	BOOL isDir;
//nov09	for(aDirPath in _pathsToScan)
//nov09	{
//nov09		NSError *err;
//nov09		NSArray *dirContents = [fileManager contentsOfDirectoryAtPath:aDirPath error:&err];
//nov09		for( id loopItem in dirContents )
//nov09		{			
//nov09			fileObject = [aDirPath stringByAppendingPathComponent:(NSString *)loopItem];
			
//nov09			BOOL exists = [fileManager fileExistsAtPath:fileObject isDirectory:&isDir];
//nov09			NSAssert(exists, @"what? fuck crap");
		
//nov09			if(exists && isDir){
//nov09				if([[fileObject pathExtension]isEqualToString:@"framework"] || [[fileObject pathExtension]isEqualToString:@"octest"])
//nov09				{
//nov09					NSBundle* aBundle = [NSBundle bundleWithPath:fileObject];
//nov09					// NSLog(@"SHBundleLoader.m: got a framework %@", aBundle ); // yes,if you rebind the doneAdded and deleted
//nov09					BOOL loadResult = [aBundle load];
//nov09					if(!loadResult){
//nov09					//	NSLog(@"SHBundleLoader.m: ERROR loading framework %@", [dirContents objectAtIndex:i] ); // yes,if you rebind the doneAdded and deleted
//nov09					} else {
//nov09						// get bundle name from path (without file extension)- 
//nov09						NSString* bundleName = [[[fileObject lastPathComponent] componentsSeparatedByString:@"."] objectAtIndex:0];
//nov09						// id bundleName = [aBundle infoDictionary];
//nov09						[store setObject:aBundle forKey:bundleName];
//nov09						[self loadIntoFscript:aBundle];
//nov09					}
//nov09				}
//nov09			} else {
//nov09			//	NSLog(@"SHBundleLoader.m: ERROR %@ is not a dir %@", [dirContents objectAtIndex:i] ); // yes,if you rebind the doneAdded and deleted
//nov09			}
//nov09		}
//nov09	}
//nov09}

// stores the framework in a dictionary
//nov09- (void)loadBundlesAtSavedLocations:(NSMutableDictionary *)store {
//nov09
//nov09	NSFileManager *fileManager = [NSFileManager defaultManager];
//nov09
//nov09	NSString* aDirPath, *fileObject;
//nov09	BOOL isDir;
//nov09	for(aDirPath in _pathsToScan)
//nov09	{
//nov09		// NSArray* dirContents = [fileManager directoryContentsAtPath: aDirPath];
//nov09		NSError *err;
//nov09		NSArray *dirContents = [fileManager contentsOfDirectoryAtPath:aDirPath error:&err];
//nov09
//nov09		for( id loopItem in dirContents)
//nov09		{			
//nov09			fileObject = [aDirPath stringByAppendingPathComponent:(NSString *)loopItem];
//nov09			
//nov09			[fileManager fileExistsAtPath:fileObject isDirectory:&isDir];
//nov09			if(isDir){
//nov09				if([[fileObject pathExtension]isEqualToString:@"bundle"])
//nov09				{
//nov09					NSBundle* aBundle = [NSBundle bundleWithPath:fileObject];
//nov09					// NSLog(@"SHBundleLoader.m: got a framework %@", aBundle ); // yes,if you rebind the doneAdded and deleted
//nov09					BOOL loadResult = [aBundle load];
//nov09					if(!loadResult){
//nov09						logError(@"SHBundleLoader.m: ERROR loading framework %@", loopItem ); // yes,if you rebind the doneAdded and deleted
//nov09					} else {
//nov09						// get bundle name from path (without file extension)- 
//nov09						NSString* bundleName = [[[fileObject lastPathComponent] componentsSeparatedByString:@"."] objectAtIndex:0];
//nov09						// id bundleName = [aBundle infoDictionary];
//nov09						[store setObject:aBundle forKey:bundleName];
//nov09						[self loadIntoFscript:aBundle];
//nov09					}
//nov09				}
//nov09			} else {
//nov09			//	NSLog(@"SHBundleLoader.m: ERROR %@ is not a dir %@", [dirContents objectAtIndex:i] ); // yes,if you rebind the doneAdded and deleted
//nov09			}
//nov09		}
//nov09	}
//nov09}



// fill the _pathsToScan array before you call this
// asks the principal class for a classDictionary, if classes are of the correct type stores these classes in store
//nov09- (void)loadClassesFromBundlesAtSavedLocations:(NSMutableDictionary *)store thatRespondToSelector:(SEL)testSelector {

//nov09	NSFileManager *fileManager = [NSFileManager defaultManager];

//nov09	NSString *aDirPath, *fileObject;
//nov09	BOOL isDir;
//nov09	for(aDirPath in _pathsToScan)
//nov09	{
		//		NSArray* dirContents = [fileManager directoryContentsAtPath: aDirPath];
//nov09		NSError *err;
//nov09		NSArray *dirContents = [fileManager contentsOfDirectoryAtPath:aDirPath error:&err];

//nov09		for( id loopItem in dirContents )
//nov09		{			
//nov09			fileObject = [aDirPath stringByAppendingPathComponent:(NSString *)loopItem];
			
//nov09			[fileManager fileExistsAtPath:fileObject isDirectory:&isDir];
//nov09			if(isDir){
//nov09				if([[NSWorkspace sharedWorkspace] isFilePackageAtPath:fileObject]){
//nov09					NSBundle* aBundle = [NSBundle bundleWithPath:fileObject];
//nov09					BOOL loadResult = [aBundle load];
//nov09					if(!loadResult) {
//nov09						logError(@"SHBundleLoader.m: ERROR loading framework %@", fileObject ); 
//						NSLinkEditErrors editError;
//						int errorNumber;
//						const char *name, *msg;
//						NSLinkEditError(&editError, &errorNumber, &name, &msg);
//						if (editError == NSLinkEditFileAccessError) {
//							logError(@"SHBundleLoader.m: NSLinkEditFileAccessError.. file not found" ); 
//						} else if (editError == NSLinkEditFileFormatError) {
//							logError(@"SHBundleLoader.m: NSLinkEditFileFormatError.. file found but wrong kind" ); 
//						} else if (editError == NSLinkEditMachResourceError) {
//							logError(@"SHBundleLoader.m: NSLinkEditMachResourceError" ); 
//						} else if (editError == NSLinkEditUnixResourceError) {
//							logError(@"SHBundleLoader.m: NSLinkEditUnixResourceError" ); 
//						} else if (editError == NSLinkEditOtherError) {
//							logError(@"SHBundleLoader.m: NSLinkEditOtherError" ); 
//						} else if (editError == NSLinkEditWarningError) {
//							logError(@"SHBundleLoader.m: NSLinkEditWarningError" ); 
//						} else if (editError == NSLinkEditMultiplyDefinedError) {
//							logError(@"SHBundleLoader.m: NSLinkEditMultiplyDefinedError" ); 
//						} else if (editError == NSLinkEditUndefinedError) {
//							logError(@"SHBundleLoader.m: NSLinkEditUndefinedError" ); 
//						}
//nov09					} // else {
						// NSString* bundleName = [[[fileObject lastPathComponent] componentsSeparatedByString:@"."] objectAtIndex:0];
						// id bundleName = [aBundle infoDictionary];
//nov09						Class principalClass = [aBundle principalClass];
//nov09						SEL classDictSelector = @selector(classDictionary);
//nov09						if([principalClass respondsToSelector:classDictSelector] )
//nov09						{
//nov09							NSDictionary* classDict = [principalClass performSelector:classDictSelector];
//nov09							if(classDict)
//nov09							{
//nov09								NSEnumerator *enumerator = [classDict objectEnumerator];
//nov09								Class classFromBundle;

//nov09								while( (classFromBundle=[enumerator nextObject]) )
//nov09								{
									//if([classFromBundle isKindOfClass:[NSObject class]])
									// NSLog(@"SHBundleLoader.m: yay! class is an object %@", [classFromBundle superclass]); // yes,if you rebind the doneAdded and deleted
									// NSArray* methodsOfClass = [NSObject methodsOfObject:classFromBundle classObject:NO];
									// NSLog(@"SHBundleLoader.m: methodsOfClass %@", methodsOfClass); // yes,if you rebind the doneAdded and deleted

									//SEL testSelector = @selector(testSelectorName);
//nov09									if([classFromBundle respondsToSelector:testSelector])
//nov09									{	// check that the right kind of class
//nov09										[store setObject:classFromBundle forKey:NSStringFromClass(classFromBundle)];

//nov09									} else {
//nov09										logError(@"SHBundleLoader.m: class '%@' from bundle doesnt respond to required selector", classFromBundle); // yes,if you rebind the doneAdded and deleted
//nov09									}
//nov09								}
//nov09								[self loadIntoFscript:aBundle];

//nov09							} else {
//nov09								logError(@"SHBundleLoader.m: NO classDict!" ); // yes,if you rebind the doneAdded and deleted
//nov09							}
//nov09						} else {
//nov09							logError(@"SHBundleLoader.m: ERROR.. principalClass '%@' of bundle doesnt respond to +classDictionary", principalClass ); // yes,if you rebind the doneAdded and deleted
//nov09						}

				//	}
//nov09				}
//nov09			} else {
//nov09				logError(@"SHBundleLoader.m: ERROR %@ is not a dir", fileObject ); // yes,if you rebind the doneAdded and deleted
//nov09			}
//nov09		}
//nov09	}
//nov09}


- (void)addAllPathsFrom:(NSString *)aPath {

	BOOL isDir;
    NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL fileExists = [fileManager fileExistsAtPath:aPath isDirectory:&isDir];
	if(fileExists && isDir)
	{
		[_pathsToScan addObject:aPath];

		// do a depth scan adding all directory paths - but not bundles
		NSDirectoryEnumerator *directoryEnumerator = [fileManager enumeratorAtPath:aPath];
		
		NSString *eachPath;
		NSString *fileObject;
		while( (eachPath = [directoryEnumerator nextObject]) ) 
		{
			if( ([[eachPath pathExtension] caseInsensitiveCompare:@"plugin"]==NSOrderedSame) || ([[eachPath pathExtension] caseInsensitiveCompare:@"framework"]==NSOrderedSame) )
			{
				[directoryEnumerator skipDescendents];
			} else {
				fileObject = [aPath stringByAppendingPathComponent:eachPath];
				if([[NSWorkspace sharedWorkspace] isFilePackageAtPath:fileObject])
					[directoryEnumerator skipDescendents];
				else {
					[fileManager fileExistsAtPath:fileObject isDirectory:&isDir];
					if(isDir){
						[_pathsToScan addObject:fileObject];
					}
				}
			}
		}

	} else {
		[NSException raise:@"Not a dir!" format:@"%@", aPath];
	}
}

//nov09- (void)loadIntoFscript:(NSBundle *)aBundle {

//nov09	[aBundle load];
//nov09}

- (BOOL)checkAvailableClassesFor:(NSArray *)classNames {
	
	for( NSString *className in classNames ) {
		Class foundClass=NSClassFromString(className);
		if(!foundClass){
			return NO;
		}
	}
	return YES;
}

//nov09- (void)frameworkLoaded:(NSNotification *)note {

//	NSLog(@"SHBundleLoader.m: frameworkLoaded %@", [note userInfo] ); // yes, if you rebind the doneAdded and deleted
// _frameworksToLoad	SHNode* aNode = [[note userInfo] objectForKey:@"theNode"];

//30/10/2005	[self startLoadingNextFramework];
//nov09}


#pragma mark accessor methods
//nov09- (NSMutableDictionary *)foundFrameworks {

//nov09	return _foundFrameworks;
//nov09}

//nov09- (void)setFoundFrameworks:(NSMutableDictionary *)newFoundFrameworks {
    
//nov09	if (_foundFrameworks != newFoundFrameworks) {
 //nov09       [_foundFrameworks release];
 //nov09       _foundFrameworks = [newFoundFrameworks retain];
//nov09   }
//nov09}

@end
