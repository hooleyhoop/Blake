//
//  BBPlugin.m
//  Blocks
//
//  Created by Jesse Grosjean on 1/5/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BBPlugin.h"
#import "BBExtensionPoint.h"
#import "BBExtension.h"
#import "BBRequirement.h"
#import <SHShared/NSString_Extras.h>

@implementation BBPlugin

#pragma mark init

static int BBPluginLoadSequenceNumbers = 0;

- (id)initWithBundle:(NSBundle *)bundle  {

	self = [super init];
    if(self) {
		fBundle = [bundle retain];
		//BOOL success = [bundle load];
		//NSLog(@"loading %@", bundle);
		if ([bundle isLoaded]) {
			fLoadSequenceNumber = BBPluginLoadSequenceNumbers++;
		} else {
			fLoadSequenceNumber = NSNotFound;
		}
		
		if (![self scanPluginXML]) {
			// logWarning(@"failed scanPluginXML for bundle %@", [fBundle bundleIdentifier]);
			[self release];
			return nil;
		}
    }
//	logInfo(@"SUCCESS %@", bundle);
    return self;
}

- (id)initWithXML:(NSString *)validXMLPath {

	self = [super init];
    if(self) {
		fLoadSequenceNumber = BBPluginLoadSequenceNumbers++;
		if (![self parseXML:validXMLPath]) {
			logWarning(@"failed scanPluginXML for validXMLPath %@", validXMLPath);
			[self release];
			return nil;
		}
	}
	return self;
}

#pragma mark dealloc

- (void)dealloc {
    
	[fBundle release];
    [fAttributes release];
    [fRequirements release];
    [fExtensionPoints release];
    [fExtensions release];

    [super dealloc];
}

#pragma mark accessors

- (NSString *)description {

    return [NSString stringWithFormat:@"id: %@ loadSequence: %i", [self identifier], [self loadSequenceNumber]];
}

- (NSBundle *)bundle {

    return fBundle;
}

- (NSString *)name {

    return [fAttributes objectForKey:@"name"];
}

- (NSString *)identifier {

	id identifier = [fAttributes objectForKey:@"id"];
    return identifier;
}

- (NSString *)version  {
    return [fAttributes objectForKey:@"version"];
}

- (NSString *)providerName {
    return [fAttributes objectForKey:@"provider-name"];
}

- (NSArray *)requirements {
    return fRequirements;
}

- (NSArray *)extensionPoints {
    return fExtensionPoints;
}

- (NSArray *)extensions {
    return fExtensions;
}

- (NSString *)xmlPath {
	
	id bundle = [self bundle];
	NSArray *xmlPaths = [bundle pathsForResourcesOfType:@"xml" inDirectory:nil]; // nil subpath starts at top level (Resources)
	NSString *eachPath;
	for(eachPath in xmlPaths){
		if([eachPath containsCaseInsensitiveString:@"plugin"])
			return eachPath;
	}

	return [bundle pathForResource:@"plugin" ofType:@"xml"];
}

- (NSString *)protocolsPath {
	return [[self bundle] pathForResource:[[[[self bundle] executablePath] lastPathComponent] stringByAppendingString:@"Protocols"] ofType:@"h"];
}

- (BOOL)enabled {
	return YES; // XXX should alwasy return no if application is not registered and plugin is not in application wrapper.
}

#pragma mark loading
- (void)oneOffInit {

    NSAssert( (fAttributes==nil) && (fRequirements==nil) && (fExtensionPoints==nil) && (fExtensions==nil), @"you can only loadPluginXML once");
    
    fRequirements = [[NSMutableArray alloc] init];
    fExtensionPoints = [[NSMutableArray alloc] init];
    fExtensions = [[NSMutableArray alloc] init];
}

- (BOOL)parseXML:(NSString *)pluginXMLPath {

	if(!fRequirements)
		[self oneOffInit];
	
    NSXMLParser *xmlParser = [[[NSXMLParser alloc] initWithData:[NSData dataWithContentsOfFile:pluginXMLPath]] autorelease];
    
    [xmlParser setDelegate:self];
    BOOL success = [xmlParser parse];
	if(!success){
		logError(@"Error parsing plugin xml %@", [xmlParser parserError]);
	}
	if (success) {
		id ident = [self identifier];
		id bundleIdent = [fBundle bundleIdentifier];
		// logInfo(@"Comparing Identities.. %@ : %@", ident, bundleIdent);
		
		/* for the moment skipping this if we are doing init with xml */
		if (fBundle!=nil && ![ident isEqualToString:bundleIdent]) {
			logError(@"plugin id %@ doesn't match bundleIdentifier %@", [self identifier], [fBundle bundleIdentifier]);
			return NO;
		}
	} else {
		logError(@"failed to parse plugin.xml file %@", pluginXMLPath);
		return NO;
	}
	
    return YES;
}

- (BOOL)scanPluginXML  {

	[self oneOffInit];

    NSString *pluginXMLPath = [self xmlPath];
    
    if (!pluginXMLPath) {
		logError(@"failed to find plugin.xml resource for bundle %@", fBundle);
		return NO;
    }
    return [self parseXML:pluginXMLPath];
}



- (int)loadSequenceNumber {
	return fLoadSequenceNumber;
}

- (BOOL)isLoaded {
	if(fBundle)
		return [fBundle isLoaded];
	return YES;
}

- (BOOL)load {

    if (![fBundle isLoaded]) {
		if (![self enabled]) {
			logError(@"Failed to load plugin %@ because it isn't enabled.", [self identifier]);
			return NO;
		}
		
		for( BBRequirement *eachImport in [self requirements] ) {
			if (![eachImport isLoaded]) {
				if ([eachImport load]) {
					logInfo(@"Loaded code for requirement %@ by plugin %@", eachImport, [self identifier]);
				} else {
					if ([eachImport optional]) {
						logError(@"Failed to load code for optioinal requirement %@ by plugin %@", eachImport, [self identifier]);
					} else {
						logError(@"Failed to load code for requirement %@ by plugin %@", eachImport, [self identifier]);
						return NO;
					}
				}
			}
		}
		
		if (fBundle && ![fBundle load]) {
			logError(@"Failed to load bundle with identifier %@", [self identifier]);
			return NO;
		} else {
			fLoadSequenceNumber = BBPluginLoadSequenceNumbers++;
			// logInfo(@"Loaded bundle with identifier %@", [self identifier]);

//
// this breaks .sdef only applescript support.
//
//			if ([[fBundle objectForInfoDictionaryKey:@"NSAppleScriptEnabled"] boolValue]) {
//				[[NSScriptSuiteRegistry sharedScriptSuiteRegistry] loadSuitesFromBundle:fBundle];
//			}
		}
    }
    
    return YES;
}

#pragma mark xml parser delegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {

    if ([elementName isEqual:@"plugin"]) {
		fAttributes = [attributeDict copy];
    } else if ([elementName isEqual:@"requirement"]) {
		[fRequirements addObject:[[[BBRequirement alloc] initWithIdentifier:[attributeDict objectForKey:@"bundle"]
														  version:[attributeDict objectForKey:@"version"]
														 optional:[[attributeDict objectForKey:@"optional"] isEqual:@"true"]] autorelease]];
    } else if ([elementName isEqual:@"extension-point"]) {
		[fExtensionPoints addObject:[[[BBExtensionPoint alloc] initWithPlugin:self
																   identifier:[NSString stringWithFormat:@"%@.%@", [self identifier], [attributeDict objectForKey:@"id"]]
																 protocolName:[attributeDict objectForKey:@"protocol"]] autorelease]];
    } else if ([elementName isEqual:@"plugIn"]) 
	{
		id attr = [attributeDict objectForKey:@"type"];
		id extClass = [attributeDict objectForKey:@"principleClass"];
		[fExtensions addObject:[[[BBExtension alloc] initWithPlugin:self extensionPointID:attr extensionClassName:extClass] autorelease]];
    }
}

@end