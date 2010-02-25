//
//  ResourceManager.m
//  Oolite
//
/*
 *
 *  Oolite
 *
 *  Created by Giles Williams on Sat Apr 03 2004.
 *  Copyright (c) 2004 for aegidian.org. All rights reserved.
 *

Copyright (c) 2004, Giles C Williams
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

•   Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.

•   Redistributions in binary form must reproduce the above copyright notice, this
list of conditions and the following disclaimer in the documentation and/or other
materials provided with the distribution.

•   Neither the name of aegidian.org nor the names of its contributors may be used
to endorse or promote products derived from this software without specific prior
written permission.

•   Neither this product nor its source code nor any products derived from them may
be offered for sale.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
DAMAGE.

*/

#import "ResourceManager.h"


@implementation ResourceManager

static  NSMutableArray* saved_paths;
static  NSString* errors;

- (id) init
{
	self = [super init];
	paths = [[ResourceManager paths] retain];
	errors = nil;
	return self;
}

- (void) dealloc
{
	if (paths)
		[paths release];
	[super dealloc];
}

+ (NSString *) errors
{
	return errors;
}

+ (NSMutableArray *) paths
{
	if (saved_paths)
		return saved_paths;
	if (errors)
	{
		[errors release];
		errors = nil;
	}
	
	NSString	*app_path = [[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Contents"] stringByAppendingPathComponent:@"Resources"];
	NSString	*addon_path = [[[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"AddOns"];
	NSMutableArray *file_paths = [NSMutableArray arrayWithCapacity:16];
	[file_paths addObject:app_path];
	[file_paths addObject:addon_path];
	NSArray *possibleExpansions = [[NSFileManager defaultManager] directoryContentsAtPath:addon_path];
	for(id loopItem in possibleExpansions)
	{
		NSString *item = (NSString *)loopItem;
		if (([[item pathExtension] isEqual:@"oxp"])||([[item pathExtension] isEqual:@"oolite_expansion_pack"]))
		{
			BOOL require_test;
			BOOL dir_test;
			NSString *possibleExpansionPath = [addon_path stringByAppendingPathComponent:item];
			[[NSFileManager defaultManager] fileExistsAtPath:possibleExpansionPath isDirectory:&dir_test];
			if (dir_test)
			{
				// check for version compatibility
				NSString *version = (NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
				NSString *requiresPath = [possibleExpansionPath stringByAppendingPathComponent:@"requires.plist"];
				require_test = YES;
				//NSLog(@"DEBUG checking possibleExpansionPath '%@'",possibleExpansionPath);
				if ([[NSFileManager defaultManager] fileExistsAtPath:requiresPath])
				{
					NSDictionary *requirements = [NSDictionary dictionaryWithContentsOfFile:requiresPath];
					if ([requirements objectForKey:@"version"])
					{
						//NSLog(@"DEBUG checking requirements '%@'", [requirements description]);
						//NSLog(@"DEBUG checking [requirements objectForKey:@\"version\"] '%@'", [requirements objectForKey:@"version"]);
						require_test = ([version isGreaterThanOrEqualTo:[requirements objectForKey:@"version"]]);
					}
				}
				if (require_test)
					[file_paths addObject:possibleExpansionPath];
				else
				{
					NSBeep();
					NSLog(@"ERROR %@ is incompatible with version %@ of Oolite",possibleExpansionPath,version);
					if (!errors)
						errors = [[NSString alloc] initWithFormat:@"\t'%@' is incompatible with version %@ of Oolite",[possibleExpansionPath lastPathComponent],version];
					else
					{
						NSString* old_errors = errors;
						errors = [[NSString alloc] initWithFormat:@"%@\n\t'%@' is incompatible with version %@ of Oolite",old_errors,[possibleExpansionPath lastPathComponent],version];
						[old_errors release];
					}
				}
			}
		}
	}
	if (!saved_paths)
		saved_paths =[file_paths retain];
	NSLog(@"---> searching paths:\n%@", [file_paths description]);
	return file_paths;
}

+ (NSDictionary *) dictionaryFromFilesNamed:(NSString *)filename inFolder:(NSString *)foldername andMerge:(BOOL) mergeFiles
{
	NSMutableArray *results = [NSMutableArray arrayWithCapacity:16];
	NSMutableArray *fpaths = [ResourceManager paths];
	int i;
	if (!filename)
		return nil;
	for(i = 0; i < [fpaths count]; i++)
	{
		NSString *filepath = [(NSString *)[fpaths objectAtIndex:i] stringByAppendingPathComponent:filename];
		if ([[NSFileManager defaultManager] fileExistsAtPath:filepath])
			[results addObject:[NSDictionary dictionaryWithContentsOfFile:filepath]];
		if (foldername)
		{
			filepath = [[(NSString *)[fpaths objectAtIndex:i] stringByAppendingPathComponent:foldername] stringByAppendingPathComponent:filename];
			if ([[NSFileManager defaultManager] fileExistsAtPath:filepath])
				[results addObject:[NSDictionary dictionaryWithContentsOfFile:filepath]];
		}
	}
	if ([results count] == 0)
		return nil;
	//NSLog(@"---> ResourceManager found %d file(s) with name '%@' (in folder '%@')", [results count], filename, foldername);
	if (!mergeFiles)
		return [NSDictionary dictionaryWithDictionary:(NSDictionary *)[results objectAtIndex:[results count] - 1]];
	NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:128];
	for(i = 0; i < [results count]; i++)
		[result addEntriesFromDictionary:(NSDictionary *)[results objectAtIndex:i]];
	return [NSDictionary dictionaryWithDictionary:result];
}

+ (NSArray *) arrayFromFilesNamed:(NSString *)filename inFolder:(NSString *)foldername andMerge:(BOOL) mergeFiles
{
	NSMutableArray *results = [NSMutableArray arrayWithCapacity:16];
	NSMutableArray *fpaths = [ResourceManager paths];
	int i;
	if (!filename)
		return nil;
	for(i = 0; i < [fpaths count]; i++)
	{
		NSString *filepath = [(NSString *)[fpaths objectAtIndex:i] stringByAppendingPathComponent:filename];
		if ([[NSFileManager defaultManager] fileExistsAtPath:filepath])
			[results addObject:[NSArray arrayWithContentsOfFile:filepath]];
		if (foldername)
		{
			filepath = [[(NSString *)[fpaths objectAtIndex:i] stringByAppendingPathComponent:foldername] stringByAppendingPathComponent:filename];
			
			if ([[NSFileManager defaultManager] fileExistsAtPath:filepath])
				[results addObject:[NSArray arrayWithContentsOfFile:filepath]];
		}
	}
	if ([results count] == 0)
		return nil;
	//NSLog(@"---> ResourceManager found %d file(s) with name '%@' (in folder '%@')", [results count], filename, foldername);
	if (!mergeFiles)
		return [NSArray arrayWithArray:(NSArray *)[results objectAtIndex:[results count] - 1]];
	NSMutableArray *result = [NSMutableArray arrayWithCapacity:128];
	for(i = 0; i < [results count]; i++)
		[result addObjectsFromArray:(NSArray *)[results objectAtIndex:i]];
	return [NSArray arrayWithArray:result];
}

+ (NSSound *) soundNamed:(NSString *)filename inFolder:(NSString *)foldername
{
	NSSound *result = nil;
	NSMutableArray *fpaths = [ResourceManager paths];
	int r;
	r = 0;
	if (!filename)
		return nil;
	for(id loopItem in fpaths)
	{
		NSString *filepath = [(NSString *)loopItem stringByAppendingPathComponent:filename];
		if ([[NSFileManager defaultManager] fileExistsAtPath:filepath])
		{
			result = [[[NSSound alloc] initWithContentsOfFile:filepath byReference:NO] autorelease];
			r++;
		}
		if (foldername)
		{
			filepath = [[(NSString *)loopItem stringByAppendingPathComponent:foldername] stringByAppendingPathComponent:filename];
			//NSLog(@".... checking filepath '%@' for Sounds", filepath);
			if ([[NSFileManager defaultManager] fileExistsAtPath:filepath])
			{
				result = [[[NSSound alloc] initWithContentsOfFile:filepath byReference:NO] autorelease];
				r++;
			}
		}
	}
	//NSLog(@"---> ResourceManager found %d file(s) with name '%@' (in folder '%@')", r, filename, foldername);
	return result;
}


// ===========================================================
//  - imageNamed: inFolder:
// ===========================================================
+ (NSImage *) imageNamed:(NSString *)filename inFolder:(NSString *)foldername
{
	NSImage *result = nil;
	NSMutableArray *fpaths = [ResourceManager paths];
	int r;
	r = 0;
	if (!filename)
		return nil;
	for(id loopItem in fpaths)
	{
		NSString *filepath = [(NSString *)loopItem stringByAppendingPathComponent:filename];
		NSLog(@"looking for file in %@", filepath );
		if ([[NSFileManager defaultManager] fileExistsAtPath:filepath])
		{
			result = [[[NSImage alloc] initWithContentsOfFile:filepath] autorelease];
			r++;
		}
		if(foldername)
		{
			filepath = [[(NSString *)loopItem stringByAppendingPathComponent:foldername] stringByAppendingPathComponent:filename];
			NSLog(@"looking for file in %@", filepath );
			if ([[NSFileManager defaultManager] fileExistsAtPath:filepath])
			{
				result = [[[NSImage alloc] initWithContentsOfFile:filepath] autorelease];
				r++;
			}
		}
	}
	NSLog(@"---> ResourceManager found %d file(s) with name '%@' (in folder '%@')", r, filename, foldername);
	return result;
}


// ===========================================================
//  - bitmapImageRepNamed: inFolder:
// ===========================================================
+ (NSBitmapImageRep *) bitmapImageRepNamed:(NSString *)filename inFolder:(NSString *)foldername
{
	NSBitmapImageRep *result = nil;
	NSMutableArray *fpaths = [ResourceManager paths];
	int r;
	r = 0;
	if (!filename)
		return nil;
	for(id loopItem in fpaths)
	{
		NSString *filepath = [(NSString *)loopItem stringByAppendingPathComponent:filename];
		NSLog(@"looking for file in %@", filepath );
		if ([[NSFileManager defaultManager] fileExistsAtPath:filepath])
		{
			result = [NSBitmapImageRep imageRepWithContentsOfFile:filepath];
			r++;
		}
		if(foldername)
		{
			filepath = [[(NSString *)loopItem stringByAppendingPathComponent:foldername] stringByAppendingPathComponent:filename];
			NSLog(@"looking for file in %@", filepath );
			if ([[NSFileManager defaultManager] fileExistsAtPath:filepath])
			{
				result = [NSBitmapImageRep imageRepWithContentsOfFile:filepath];
				r++;
			}
		}
	}
	NSLog(@"---> ResourceManager found %d file(s) with name '%@' (in folder '%@')", r, filename, foldername);
	return result;
}




+ (NSString *) stringFromFilesNamed:(NSString *)filename inFolder:(NSString *)foldername
{
	NSString *result = nil;
	NSMutableArray *fpaths = [ResourceManager paths];
	int r;
	r = 0;
	if (!filename)
		return nil;
	for(id loopItem in fpaths)
	{
		NSString *filepath = [(NSString *)loopItem stringByAppendingPathComponent:filename];
		if ([[NSFileManager defaultManager] fileExistsAtPath:filepath])
		{
			result = [NSString stringWithContentsOfFile:filepath];
			r++;
		}
		if (foldername)
		{
			filepath = [[(NSString *)loopItem stringByAppendingPathComponent:foldername] stringByAppendingPathComponent:filename];
			if ([[NSFileManager defaultManager] fileExistsAtPath:filepath])
			{
				result = [NSString stringWithContentsOfFile:filepath];
				r++;
			}
		}
	}
	//NSLog(@"---> ResourceManager found %d file(s) with name '%@' (in folder '%@')", r, filename, foldername);
	return result;
}

+ (NSMovie *)movieFromFilesNamed:(NSString *)filename inFolder:(NSString *)foldername
{
	NSMovie *result = nil;
	NSMutableArray *fpaths = [ResourceManager paths];

	if(!filename)
        return nil;
	for( id loopItem in fpaths )
	{
		NSString *filepath = [(NSString *)loopItem stringByAppendingPathComponent:filename];
		if ([[NSFileManager defaultManager] fileExistsAtPath:filepath])
			result = [[NSMovie alloc] initWithURL:[NSURL fileURLWithPath: filepath] byReference: NO];
		if (foldername)
		{
			filepath = [[(NSString *)loopItem stringByAppendingPathComponent:foldername] stringByAppendingPathComponent:filename];
			if ([[NSFileManager defaultManager] fileExistsAtPath:filepath])
			{
				//NSLog(@"DEBUG ResourceManager found %@ at %@",filename,filepath);
				if (result)
					[result release];
				result = [[NSMovie alloc] initWithURL:[NSURL fileURLWithPath: filepath] byReference: NO];
			}
		}
	}
	
	if ((result == nil)&&([filename hasSuffix:@"mp3"]))
	{
		// look for an alternative .mid file
		NSString *midifilename = [[filename stringByDeletingPathExtension] stringByAppendingPathExtension:@"mid"];
		result =[[ResourceManager movieFromFilesNamed:midifilename inFolder:foldername] retain];
	}
	
	return [result autorelease];
}

@end
