//
//  ApplescriptUtils.h
//  SHShared
//
//  Created by steve hooley on 04/02/2010.
//  Copyright 2010 BestBefore Ltd. All rights reserved.
//


@interface ApplescriptUtils : NSObject {

}

+ (NSAppleScript *)applescript:(NSString *)scriptName;
+ (NSAppleEventDescriptor *)eventForApplescriptMethod:(NSString *)methodName arguments:(NSAppleEventDescriptor *)paramList;
+ (NSAppleEventDescriptor *)parameters:(NSString *)firstArg, ...;
+ (NSString *)executeScript:(NSString *)scriptFileName method:(NSString *)scriptMethodName params:(NSAppleEventDescriptor *)parameters;

@end
