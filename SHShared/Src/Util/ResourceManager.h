//
//  ResourceManager.h
/*
 *
 *  Oolite
 *
 *  Created by Giles Williams on Sat Apr 03 2004.
 *  Copyright (c) 2004 for aegidian.org. All rights reserved.
 *

Copyright (c) 2004, Giles C Williams
All rights reserved.

*/


@interface ResourceManager : _ROOT_OBJECT_
{
	NSMutableArray  *paths;
}

+ (NSString *) errors;
+ (NSMutableArray *) paths;
+ (NSDictionary *) dictionaryFromFilesNamed:(NSString *)filename inFolder:(NSString *)foldername andMerge:(BOOL) mergeFiles;
+ (NSArray *) arrayFromFilesNamed:(NSString *)filename inFolder:(NSString *)foldername andMerge:(BOOL) mergeFiles;
+ (NSSound *) soundNamed:(NSString *)filename inFolder:(NSString *)foldername;
+ (NSImage *) imageNamed:(NSString *)filename inFolder:(NSString *)foldername;
+ (NSBitmapImageRep *) bitmapImageRepNamed:(NSString *)filename inFolder:(NSString *)foldername;
+ (NSString *) stringFromFilesNamed:(NSString *)filename inFolder:(NSString *)foldername;
+ (NSMovie *) movieFromFilesNamed:(NSString *)filename inFolder:(NSString *)foldername;

@end
