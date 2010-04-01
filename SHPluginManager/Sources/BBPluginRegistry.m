//
//  BBPluginRegistry.m
//  Blocks
//
//  Created by Jesse Grosjean on 1/5/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BBPluginRegistry.h"
#import "BBPlugin.h"
#import "BBExtensionPoint.h"
#import "BBExtension.h"
#import "BBRequirement.h"

OBJC_EXPORT int SayHello() __attribute__((weak_import));
BOOL _AUTOLOAD_MAIN_PLUGIN __attribute__((weak));

@interface BBPluginRegistry (BBPrivate)

- (NSMutableArray *)pluginSearchPaths;
- (void)addDefaultSearchPaths;
- (void)registerExtensionPointsFor:(BBPlugin *)plugin;
- (void)registerExtensionsFor:(BBPlugin *)plugin;
- (void)validatePluginConnections;
- (NSMutableDictionary *)pluginIDsToPlugins;
- (NSMutableDictionary *)extensionPointIDsToExtensionPoints;
- (NSMutableDictionary *)extensionPointIDsToExtensions;
- (NSMutableDictionary *)extensionPointIDsToLoadedValidOrderedExtensions;

@end

@implementation BBPluginRegistry

#pragma mark class methods

+ (void)initialize {

	if( [BBPluginRegistry class]==self ) {
		
		//-- test to see if the weakly linked symbol _AUTOLOAD_MAIN_PLUGIN exists
		//-- set it in application -main

//		if(_AUTOLOAD_MAIN_PLUGIN==0){
//			NSLog(@"so we intentionally chose not to load the plugins, eh?");
//		}
//		if(YES==_AUTOLOAD_MAIN_PLUGIN){
            /* Try to load any plugin bundles that extend Blake */
            NSAutoreleasePool *pool = [NSAutoreleasePool new];
            
            NSString *pathToApp = [[NSBundle mainBundle] bundlePath]; 
            int amountToRemoveFromEnd = [[pathToApp lastPathComponent] length];
		
		
            // temporary.. blake main is built in App's dir..
#ifdef DEBUG
			NSString *appsDirectory = [pathToApp substringToIndex:[pathToApp length]-amountToRemoveFromEnd];
			if([appsDirectory hasPrefix:@"/Developer"]==NO && [appsDirectory hasPrefix:@"/Applications"]==NO)
				[[BBPluginRegistry sharedInstance] addAllPathsFrom: appsDirectory];
#endif
            /* we have now loaded any frameworks bundled with the app. If one of the Frameworks was SHPluginManager, see if we are trying to extend the app with plugins */
            /* find plugins that extend from main. Only one is loadable as MainExtension */
            NSString* pluginConfigPath = [[NSBundle mainBundle] pathForResource:@"pluginConfig" ofType:@"txt"];
            if(pluginConfigPath!=nil)
                [[BBPluginRegistry sharedInstance] limitPluginsTo:pluginConfigPath];
			
            [[BBPluginRegistry sharedInstance] scanPlugins];
            //	[[BBPluginRegistry sharedInstance] addPluginWithXML:[[NSBundle mainBundle] pathForResource:@"BlakeMainPlugin" ofType:@"xml"]];            
            [[BBPluginRegistry sharedInstance] validatePluginConnections];
            
            /* find plugins that extend from main. Only one is loadable as MainExtension */
            /* Lifecycle is our uk.co.stevehooley.SHPluginManager.main */
            [[BBPluginRegistry sharedInstance] loadMainExtension];
            
            [pool release];
//		} 
	}
}

static id sharedInstance = nil;

+ (id)sharedInstance {
    
    if (sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

+ (void)tearDownPlugins {

	[sharedInstance release];
}

+ (void)performSelector:(SEL)selector forExtensionPoint:(NSString *)extensionPointID protocol:(Protocol *)protocol {

    BBPluginRegistry *pluginRegistery = [BBPluginRegistry sharedInstance];
    
    for( BBExtension *each in [pluginRegistery loadedValidOrderedExtensionsFor:extensionPointID protocol:protocol] ) {
		@try {
			[[each extensionInstance] performSelector:selector];
		} @catch ( NSException *exception ) {
			logError(@"exception while processing extension point %@ \n %@", extensionPointID, exception);
		}
    }
}

+ (void)performSelector:(SEL)selector withObject:(id)ob forExtensionPoint:(NSString *)extensionPointID protocol:(Protocol *)protocol {

    BBPluginRegistry *pluginRegistery = [BBPluginRegistry sharedInstance];
    
    for( BBExtension *each in [pluginRegistery loadedValidOrderedExtensionsFor:extensionPointID protocol:protocol] ) {
		@try {
			id ee = [each extensionInstance];
			[ee performSelector:selector withObject:ob];
		} @catch ( NSException *exception ) {
			logError(@"exception while processing extension point %@ \n %@", extensionPointID, exception);
		}
    }
}
	
#pragma mark init

- (id)init {
	
	self = [super init];
    if(self) {
		pluginSearchPaths = [[NSMutableArray array] retain];
		[self addDefaultSearchPaths];
		
		specificPluginsToLoad = [[NSMutableArray array] retain];
		_usedBundleIdentifiers = [[NSMutableArray alloc] init];

		fPluginIDsToPlugins = [[NSMutableDictionary alloc] init];
		fExtensionPointIDsToExtensionPoints = [[NSMutableDictionary alloc] init];
		fExtensionPointIDsToExtensions = [[NSMutableDictionary alloc] init];
		fExtensionPointIDsToLoadedValidOrderedExtensions = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc {
	
    [fPluginIDsToPlugins release];
    [fExtensionPointIDsToExtensionPoints release];
    [fExtensionPointIDsToExtensions release];
	[fExtensionPointIDsToLoadedValidOrderedExtensions release];
	[pluginSearchPaths release];
	[specificPluginsToLoad release];
	[_usedBundleIdentifiers release];
	
	pluginSearchPaths = nil;
    [super dealloc];
}


/* specify which plugins to load in a file (see example 'pluginConfig.txt' in viewlayer) */
/* if you dont do this, all found plugins will be loaded */
- (void)limitPluginsTo:(NSString *)filePath
{
	if ([[NSFileManager defaultManager] fileExistsAtPath: filePath])
	{
		NSStringEncoding *enc=nil;
		NSError *error;
		NSString *fileContents = [NSString stringWithContentsOfFile:filePath usedEncoding:enc error:&error];
		// NSString *fileContents = [NSString stringWithContentsOfFile: filePath];
		NSString *pluginString;
		
		for( NSString *lineString in [fileContents componentsSeparatedByString:@"\n"] ) {
		
			// parse the line
			NSScanner *scanner = [NSScanner scannerWithString:lineString];
			if (![scanner scanUpToString:@"#" intoString:&pluginString])
			  continue;
			pluginString = [pluginString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			if([pluginString length]>0){
				[specificPluginsToLoad addObject:pluginString];
			}
			
		   // logInfo(@"pluginString is, %@", pluginString);
			
		}
	}
}


/*
 * Path must be valid
*/
- (void)addPluginWithXML:(NSString *)pathToXML {

	NSParameterAssert(pathToXML!=nil);
	BOOL isDirectory;
	NSParameterAssert([[NSFileManager defaultManager] fileExistsAtPath:pathToXML isDirectory:&isDirectory]);

	BBPlugin *plugin = [[[BBPlugin alloc] initWithXML:pathToXML] autorelease];
	if (!plugin) {
		logError(@"failed to create plugin for path: %@", pathToXML);
	} else {
		// This may return false if plugin wasnt specified in config file
		BOOL result = [self registerPlugin:plugin];
		logInfo(@"Loaded Plugin? %i", result);
	}
}


/*!
	@method
	@discussion Scans for plugin bundles and registers them.
 */
- (void)scanPlugins {
	
	NSMutableArray *pluginsWithErrors = [NSMutableArray array];
	NSMutableArray *duplicatePlugins = [NSMutableArray array];
	NSMutableArray *successPlugins = [NSMutableArray array];

	logInfo(@"/* Plugin loading\n*\n*\n");
    if (fScannedPlugins) {
		logWarning(@"scan plugins can only be run once.");
		return;
    } else {
		fScannedPlugins = YES;
    }
		
    NSBundle *blocksBundle = [NSBundle bundleForClass:[self class]];
    BBPlugin *blocskPlugin = [[[BBPlugin alloc] initWithBundle:blocksBundle] autorelease];
	[_usedBundleIdentifiers addObject: [blocksBundle bundleIdentifier]];

	/* This is required, if user is specifying 'specificPluginsToLoad' then this must be one - this is kinda crazy */
    BOOL result = [self registerPlugin:blocskPlugin];
	if(result==NO){
		logError(@"Couldn't find plugin loader"); // This should read - "Cant find self". Either our plugin.xml is wrong or we didnt specify this in our specifics
		return;
	}
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *eachSearchPath;
    
    while( (eachSearchPath = [pluginSearchPaths lastObject]) ) 
	{
		[pluginSearchPaths removeLastObject];
		// logInfo(@"Searching.. %@", eachSearchPath);
		NSDirectoryEnumerator *directoryEnumerator = [fileManager enumeratorAtPath:eachSearchPath];
		NSString* eachPath;
		
		while( (eachPath = [directoryEnumerator nextObject]) ) 
		{
			if( ([[eachPath pathExtension] caseInsensitiveCompare:@"plugin"]==NSOrderedSame) || ([[eachPath pathExtension] caseInsensitiveCompare:@"framework"]==NSOrderedSame) )
			{
				[directoryEnumerator skipDescendents];
				
				eachPath = [eachSearchPath stringByAppendingPathComponent:eachPath];
				// logInfo(@"Found Plugin %@", eachPath);
				NSBundle *bundle = [NSBundle bundleWithPath:eachPath];
				NSString *bi = [bundle bundleIdentifier];

				if ([_usedBundleIdentifiers containsObject: bi]==NO)
				{
					BBPlugin *plugin = [[[BBPlugin alloc] initWithBundle:bundle] autorelease];
					
					if (!plugin) {
						// logError(@"failed to create plugin for path: %@", eachPath);
						[pluginsWithErrors addObject:eachPath];
					} else {
						// This may return false if plugin wasnt specified in config file
						BOOL result2 = [self registerPlugin:plugin];
						if(result2){
							[pluginSearchPaths addObject:[bundle builtInPlugInsPath]]; // search within plugin for more
							[_usedBundleIdentifiers addObject:bi];
							[successPlugins addObject:eachPath];
						}
					}
				} else {
			//		logInfo(@"Already using a bundle with identifier %@", bi);
					[duplicatePlugins addObject:eachPath];
				}
			}
		}
    }
	logInfo(@"ERRORS - %@", pluginsWithErrors);
	logInfo(@"DUPLICATES - %@", duplicatePlugins);
	logInfo(@"SUCCESS - %@", successPlugins);
}


- (void)addAllPathsFrom:(NSString *)aPath {

	[pluginSearchPaths addObject: aPath ];
	NSLog(@"SHBundleLoader.m: adding path %@",aPath );

	// do a depth scan adding all directory paths - but not bundles
	NSError *err;
	NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:aPath error:&err];
	//	NSArray* dirContents = [[NSFileManager defaultManager] directoryContentsAtPath: aPath];
	
	NSString* fileObject;
	BOOL isDir;
	for( NSUInteger i=0; i<[dirContents count]; i++ )
	{
		fileObject = [aPath stringByAppendingPathComponent:(NSString *)[dirContents objectAtIndex:i]];

		[[NSFileManager defaultManager] fileExistsAtPath:fileObject isDirectory:&isDir];
		if(isDir){
			if(![[NSWorkspace sharedWorkspace] isFilePackageAtPath:fileObject] && (![[fileObject pathExtension]isEqualToString:@"framework"]))
				[self addAllPathsFrom: [aPath stringByAppendingPathComponent:(NSString *)[dirContents objectAtIndex:i]] ];
		}
	}
}


- (void)loadMainExtension {
	
    NSArray *mainExtensions = [self extensionsFor:@"uk.co.stevehooley.SHPluginManager.main"];
    BBExtension *mainExtension = [mainExtensions lastObject];
    
    if ([mainExtensions count] > 1) {
		logWarning(@"found more then one plugin (%@) with a main extension point, loading only one from plugin %@", mainExtensions, [mainExtension plugin]);
    } else if ([mainExtensions count] == 0) {
		logWarning(@"failed to find any plugin with a main extension point");
    }
    
    [mainExtension extensionInstance];
	
	logInfo(@"Plugin loading\n*\n*\n*/\n");
}

#pragma mark accessors

- (NSArray *)plugins {
	NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"loadSequenceNumber" ascending:YES] autorelease];
    return [[[self pluginIDsToPlugins] allValues] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}

- (BBPlugin *)mainPlugin {
    NSArray *mainExtensions = [self extensionsFor:@"com.hogbaysoftware.BBBlocks.main"];
    BBExtension *mainExtension = [mainExtensions lastObject];
	return [mainExtension plugin];
}

- (NSArray *)extensionPoints {
    return [[self extensionPointIDsToExtensionPoints] allValues];
}

- (NSArray *)extensions {

    NSMutableArray *extensions = [NSMutableArray array];
    
    for( BBPlugin *each in [self plugins]) {
		[extensions addObjectsFromArray:[each extensions]];
    }
    
    return extensions;
}

#pragma mark lookup

- (BBPlugin *)pluginFor:(NSString *)pluginID {
    return [[self pluginIDsToPlugins] objectForKey:pluginID];
}

- (BBExtensionPoint *)extensionPointFor:(NSString *)extensionPointID {
	NSMutableDictionary* ipids = [self extensionPointIDsToExtensionPoints];
    return [ipids objectForKey:extensionPointID];
}

- (NSArray *)extensionsFor:(NSString *)extensionPointID {
    return [[self extensionPointIDsToExtensions] objectForKey:extensionPointID];
}

- (NSArray *)loadedValidOrderedExtensionsFor:(NSString *)extensionPointID protocol:(Protocol *)protocol {
	
	NSMutableArray *loadedValidOrderedExtensions = [[self extensionPointIDsToLoadedValidOrderedExtensions] objectForKey:extensionPointID];
	
	if (!loadedValidOrderedExtensions) {
		loadedValidOrderedExtensions = [NSMutableArray array];
		[[self extensionPointIDsToLoadedValidOrderedExtensions] setObject:loadedValidOrderedExtensions forKey:extensionPointID];

		for( BBExtension *each in [self extensionsFor:extensionPointID]) {
			if ([[each plugin] enabled]) {
				Class extensionClass = [each extensionClass];
				if ([extensionClass conformsToProtocol:protocol]) {
					[loadedValidOrderedExtensions addObject:each];
				} else {
					logWarning(@"extension %@ doesn't conform to protocol, skipping", each);
				}
			}
		}

		[loadedValidOrderedExtensions sortedArrayUsingSelector:@selector(compareDeclarationOrder:)];
	}
	
	return loadedValidOrderedExtensions;
}

#pragma mark private

- (NSMutableArray *)pluginSearchPaths
{
 return pluginSearchPaths;
 }
 
 - (void)addDefaultSearchPaths {

    NSString *applicationSupportSubpath = [NSString stringWithFormat:@"Application Support/%@/PlugIns", [[NSProcessInfo processInfo] processName]];
    
    for( NSString *eachSearchPath in NSSearchPathForDirectoriesInDomains( NSLibraryDirectory, NSUserDomainMask, YES) ) {
		[self addAllPathsFrom:[eachSearchPath stringByAppendingPathComponent:applicationSupportSubpath]];
    }
	
	for( NSBundle *eachBundle in [NSBundle allBundles] ) {
		[self addAllPathsFrom:[eachBundle builtInPlugInsPath]];
	}
}

- (BOOL)registerPlugin:(BBPlugin *)plugin 
{
	NSString* identifier = [plugin identifier];
	// have we bothered to specify whichh to load or are we just going to load all found plugins?
	if([specificPluginsToLoad count]>0)
	{
		NSString *attributeName = @"self";
		NSPredicate *inputValidationPredicate = [NSPredicate predicateWithFormat:@"%K like %@", attributeName, identifier]; // AND scene.status = 1 
		NSArray *filtered = [specificPluginsToLoad filteredArrayUsingPredicate:inputValidationPredicate];
		if([filtered count]!=1){
			logInfo(@"Plugin %@ is not specified in plugin config - not loading", identifier);
			return NO;
		}
	 }
	// logInfo(@"loading %@", identifier);

    if ([fPluginIDsToPlugins objectForKey:identifier] != nil) {
		logWarning(@"plugin id %@ not unique, skipping", [plugin identifier]);
		return NO;
	  }
	
    [fPluginIDsToPlugins setObject:plugin forKey:[plugin identifier]];
    
    [self registerExtensionPointsFor:plugin];
    [self registerExtensionsFor:plugin];
	return YES;
}

- (void)registerExtensionPointsFor:(BBPlugin *)plugin {
	
    for( BBExtensionPoint *eachExtensionPoint in [plugin extensionPoints] ) {
		if ([fExtensionPointIDsToExtensionPoints objectForKey:[eachExtensionPoint identifier]]) {
			logWarning(@"extension point id %@ not unique, replacing old with new", [eachExtensionPoint identifier]);
		}
		[fExtensionPointIDsToExtensionPoints setObject:eachExtensionPoint forKey:[eachExtensionPoint identifier]];
    }
}

- (void)registerExtensionsFor:(BBPlugin *)plugin {
    
    for( BBExtension *eachExtension in [plugin extensions] ) {
		NSString *extensionPointID = [eachExtension extensionPointID];
		
		NSMutableArray *extensions = [fExtensionPointIDsToExtensions objectForKey:extensionPointID];
		if (!extensions) {
			extensions = [NSMutableArray array];
			[fExtensionPointIDsToExtensions setObject:extensions forKey:extensionPointID];
		}
		
		[extensions addObject:eachExtension];
    }
}

- (void)validatePluginConnections {
    
    for( BBPlugin *eachPlugin in [self plugins] ) {
		
		for( BBRequirement *eachRequirement in [eachPlugin requirements] ) {
			if (![eachRequirement optional]) {
				if (![NSBundle bundleWithIdentifier:[eachRequirement bundleIdentifier]]) {
					logWarning(@"requirement bundle %@ not found for plugin %@", eachRequirement, eachPlugin);
				}
			}
		}
    }

    for( BBExtension *eachExtension in [self extensions] ) {
		NSString *eachExtensionID = [eachExtension extensionPointID];
		BBExtensionPoint *extensionPoint = [self extensionPointFor:eachExtensionID];
		if (!extensionPoint) {
			logWarning(@"no extension point found for plugin %@'s extension %@", [eachExtension plugin], eachExtension);
		}
    }
}

- (NSMutableDictionary *)pluginIDsToPlugins {

    if (!fPluginIDsToPlugins) {
		[self scanPlugins];
    }
    return fPluginIDsToPlugins;
}

- (NSMutableDictionary *)extensionPointIDsToExtensionPoints {

    if (!fExtensionPointIDsToExtensionPoints) {
		[self scanPlugins];
    }
    return fExtensionPointIDsToExtensionPoints;
}

- (NSMutableDictionary *)extensionPointIDsToExtensions {

    if (!fExtensionPointIDsToExtensions) {
		[self scanPlugins];
    }
    return fExtensionPointIDsToExtensions;
}

- (NSMutableDictionary *)extensionPointIDsToLoadedValidOrderedExtensions {

    if (!fExtensionPointIDsToLoadedValidOrderedExtensions) {
		[self scanPlugins];
    }
    return fExtensionPointIDsToLoadedValidOrderedExtensions;
}

@end