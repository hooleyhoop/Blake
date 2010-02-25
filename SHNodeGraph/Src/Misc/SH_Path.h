//
//  SH_Path.h
//  newInterface
//
//  Created by Steve Hooley on 15/02/2005.
//  Copyright 2005 HooleyHoop. All rights reserved.
//


/*
 * A path like a file system path that
 * locates every SHNode
*/
@interface SH_Path : _ROOT_OBJECT_ {

	NSString*	_path;
	
}

#pragma mark -
#pragma mark class methods
+ (SH_Path *)pathWithString:(NSString*)aPath;
+ (SH_Path *)rootPath;

#pragma mark init methods
- (id)initWithPath:(NSString*)aPath;

#pragma mark action methods
- (SH_Path *)append:(NSString*)pathComponent;
- (SH_Path *)insertPathComponentBeforeLast:(SH_Path *)newBit;
- (SH_Path *)removePathComponentBeforeLast:(SH_Path *)newBit;

- (BOOL)isEquivalentTo:(id)anObject;

#pragma mark accessor methods
- (NSString *)pathAsString;
- (void)setPathWithString: (NSString *) aPath;

- (NSArray *)pathComponents;

@end


