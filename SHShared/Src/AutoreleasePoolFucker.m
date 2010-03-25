//
//  AutoreleasePoolFucker.m
//  SHShared
//
//  Created by steve hooley on 25/03/2010.
//  Copyright 2010 BestBefore Ltd. All rights reserved.
//

#import "AutoreleasePoolFucker.h"
#import <Foundation/NSDebug.h>
#include <sys/stat.h>

@implementation AutoreleasePoolFucker

+ (BOOL)isLeaking_takingIntoAccountAutoReleses:(NSObject *)arg {
	
	return [arg retainCount] - [self autoreleaseCount:arg]; 
}

+ (NSUInteger)autoreleaseCount:(NSObject *)arg {
	
	NSUInteger count=0;
	
	fflush(stderr);
	int o = dup(fileno(stderr));
	
	// pipe way
	NSPipe *pipe = [NSPipe pipe];
	NSFileHandle *fileHandleForWriting = [pipe fileHandleForWriting];
	dup2( [fileHandleForWriting fileDescriptor], fileno(stderr) );
	
	[NSAutoreleasePool showPools];
	fflush(stderr);
	NSFileHandle *readFileHandle = [pipe fileHandleForReading];
	NSData *data = [readFileHandle availableData];
	
	dup2(o,fileno(stderr));
	close(o);
	
	NSString *dataAsString = [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
	NSString *addressOfObject = [NSString stringWithFormat:@"%p", arg];
	NSRange foundRange;
	
	while( foundRange=[dataAsString rangeOfString:addressOfObject options:NSLiteralSearch], foundRange.location!=NSNotFound ) {
		dataAsString = [dataAsString substringFromIndex:foundRange.location + foundRange.length];
		count++;
	}
	
	return count;
}

@end
