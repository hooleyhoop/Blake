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

+ (id)poolFucker {
	AutoreleasePoolFucker *newPoolFucker = [[AutoreleasePoolFucker alloc] init];
	return [newPoolFucker autorelease];
}

+ (NSString *)releasePoolsAsString {

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
	return dataAsString;
}

// Single Objects
+ (BOOL)isLeaking_takingIntoAccountAutoReleases:(NSObject *)arg {
	
	return [arg retainCount] - [self autoreleaseCount:arg]; 
}

+ (NSUInteger)autoreleaseCount:(NSObject *)arg {
	
	NSString *dataAsString = [AutoreleasePoolFucker releasePoolsAsString];
	NSString *addressOfObject = [NSString stringWithFormat:@"%p", arg];
	NSUInteger count=[dataAsString occurrencesOfString:addressOfObject];
	return count;
}

// multiple objects
- (id)init {
	self = [super init];
	if(self){
		_poolDataString = [[AutoreleasePoolFucker releasePoolsAsString] retain];
	}
	return self;
}

- (void)dealloc {

	NSAssert( _poolDataString!=nil, @"oops" );

	[_poolDataString release];
	_poolDataString = nil;
	
	[super dealloc];
}

- (BOOL)mult_isLeaking_takingIntoAccountAutoReleases:(NSObject *)arg {
	
	NSString *addressOfObject = [NSString stringWithFormat:@"%p", arg];
	NSUInteger count=[_poolDataString occurrencesOfString:addressOfObject];
	return count;
}

@end
