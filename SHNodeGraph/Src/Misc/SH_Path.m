//
//  SH_Path.m
//  newInterface
//
//  Created by Steve Hooley on 15/02/2005.
//  Copyright 2005 HooleyHoop. All rights reserved.
//

#import "SH_Path.h"

/*
 *
*/
@implementation SH_Path

#pragma mark -
#pragma mark class methods
+ (SH_Path *)pathWithString:(NSString *)aPath {

	NSParameterAssert( aPath && [aPath isKindOfClass:[NSString class]]);
	SH_Path *newPath = [[[SH_Path alloc] initWithPath:aPath] autorelease];
	return newPath;
}

+ (SH_Path *)rootPath {
	return [[[SH_Path alloc] initWithPath:@"/"] autorelease];
}

#pragma mark init methods
- (id)initWithPath:(NSString *)aPath {

	NSParameterAssert( aPath && [aPath isKindOfClass:[NSString class]]);
    if( (self=[super init])!=nil ) {
        [self setPathWithString: aPath];
    }
    return self;
}

- (void)dealloc {

	[self setPathWithString:nil];
    [super dealloc];
}

#pragma mark action methods
- (SH_Path *)append:(NSString *)pathComponent {

	NSParameterAssert( pathComponent && [pathComponent isKindOfClass:[NSString class]]);
	NSString* newPath = [[self pathAsString] stringByAppendingPathComponent: pathComponent];
	return [[[SH_Path alloc] initWithPath:newPath] autorelease];
}

- (SH_Path *)insertPathComponentBeforeLast:(SH_Path *)newBit {

	NSParameterAssert(newBit);
	NSString *lastBit = [_path lastPathComponent];
	NSString *firstBit = [_path stringByDeletingLastPathComponent];
	NSString *newPath = [firstBit stringByAppendingPathComponent:[newBit pathAsString]];
	NSString *newPath2 = [newPath stringByAppendingPathComponent:lastBit];
	return [[[SH_Path alloc] initWithPath:newPath2] autorelease];
}

- (SH_Path *)removePathComponentBeforeLast:(SH_Path *)newBit {

	NSParameterAssert(newBit);
	NSArray *pathComponents = [self pathComponents];
	NSAssert([pathComponents count]>1, @"Path too short to remove component before last");
	NSInteger indexOfItemToReserve = [pathComponents count]-2;
	
	NSAssert([[pathComponents objectAtIndex:indexOfItemToReserve] isEqualToString: [newBit pathAsString]], @"doh! wrong argument?");

	NSString *lastBit = [_path lastPathComponent];
	NSString *firstBit = [_path stringByDeletingLastPathComponent];
	firstBit = [firstBit stringByDeletingLastPathComponent];
	NSString *newPath = [firstBit stringByAppendingPathComponent:lastBit];
	return [[[SH_Path alloc] initWithPath:newPath] autorelease];
}

- (BOOL)isEquivalentTo:(id)anObject {

	NSParameterAssert(anObject);

	if([anObject respondsToSelector:@selector(pathAsString)]){
		return [_path isEqualToString:[anObject pathAsString]];
	}
	return NO;
}

#pragma mark accessor methods
- (NSString *)pathAsString { return _path; }
- (void)setPathWithString:(NSString *)aPath {

    //logInfo(@"in -setPath:, old value of _path: %@, changed to: %@", _path, aPath);
    if (_path != aPath) {
		// Is it a valid path?
        [_path release];
        _path = [aPath retain];
    }
}

- (NSArray *)pathComponents {
	return [_path pathComponents];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"%@ : %@", [super description], _path];
}

@end


