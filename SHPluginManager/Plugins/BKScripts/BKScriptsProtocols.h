/*
 *  BKScriptsProtocols.h
 *  Blocks
 *
 *  Created by Jesse Grosjean on 2/3/05.
 *  Copyright 2006 Hog Bay Software. All rights reserved.
 *
 */

#import <Carbon/Carbon.h>

@protocol BKScriptsFileControllerProtocol <NSObject>

- (NSImage *)scriptToolbarImage;
- (BOOL)acceptsScriptFile:(NSString *)filePath;
- (void)editScriptFile:(NSString *)filePath;
- (void)runScriptFile:(NSString *)filePath;
- (BOOL)scriptFile:(NSString *)filePath respondsToCommand:(NSString *)command;
- (BOOL)scriptFile:(NSString *)filePath performCommand:(NSString *)command withArguments:(NSArray *)arguments result:(id *)result error:(NSDictionary **)errorInfo;

@end

@protocol BKScriptsControllerProtocol <NSObject>

- (NSArray *)scriptFilePaths;
- (NSArray *)scriptFilesRespondingToCommand:(NSString *)command;
- (NSArray *)scriptFilesPerformCommand:(NSString *)command withArguments:(NSArray *)arguments;
- (BOOL)validateScriptAtPath:(NSString *)path;
- (id <BKScriptsFileControllerProtocol>)fileControllerFor:(NSString *)filePath;

@end

#define BKScriptsFilesWillRefresh @"BKScriptsFilesWillRefresh"
#define BKScriptsFilesDidRefresh @"BKScriptsFilesDidRefresh"

@interface NSApplication (BKScriptsControllerAccess)
- (id <BKScriptsControllerProtocol>)BKScriptsProtocols_scriptsController; // exposed this way for applescript support
@end

@interface NSAppleScript (BKScriptsAdditions)

+ (struct ComponentInstanceRecord *)defaultScriptingComponent;
- (unsigned long)compiledScriptID;
- (NSArray *)arrayOfEventIdentifier;
- (BOOL)respondsToEvent:(NSString *)aName;
- (id)callHandler:(NSString *)handler errorInfo:(NSDictionary **)errorInfo;
- (id)callHandler:(NSString *)handler withArguments:(NSArray *)arguments errorInfo:(NSDictionary **)errorInfo;

@end

@interface NSAppleEventDescriptor (BKScriptsAdditions)

+ (NSAppleEventDescriptor *)currentProcessDescriptor;
+ (id)descriptorWithNumber:(NSNumber *)aNumber;
+ (id)descriptorWithArray:(NSArray *)anArray;
+ (id)descriptorWithDictionary:(NSDictionary *)aDictionary;
+ (NSAppleEventDescriptor *)userRecordDescriptorWithDictionary:(NSDictionary *)aDictionary;
+ (id)descriptorWithObject:(id)anObject;
+ (id)descriptorWithSubroutineName:(NSString *)aRoutineName argumentsListDescriptor:(NSAppleEventDescriptor *)aParam;
+ (id)descriptorWithSubroutineName:(NSString *)aRoutineName argumentsArray:(NSArray *)aParamArray;

- (id)initWithSubroutineName:(NSString *)aRoutineName argumentsArray:(NSArray *)aParamArray;
- (id)initWithSubroutineName:(NSString *)aRoutineName argumentsListDescriptor:(NSAppleEventDescriptor *)aParam;

- (unsigned int)unsignedIntValue;
- (float)floatValue;
- (double)doubleValue;
- (NSDate *)dateValue;
- (NSNumber *)numberValue;
- (NSArray *)arrayValue;
- (NSDictionary *)dictionaryValue;
- (NSDictionary *)dictionaryValueFromRecordDescriptor;
- (id)objectValue;

@end
