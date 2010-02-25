//
//  NodeName.m
//  SHNodeGraph
//
//  Created by steve hooley on 26/02/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "NodeName.h"
#import "SHChildContainer.h"
#import "SHNodeLikeProtocol.h"

static NSUInteger uniqueIDTracker = 0;  // 0 is reserved for 'ERROR'

@implementation NodeName

@synthesize value=_value;

+ (NSUInteger)getNewUniqueID {
	return ++uniqueIDTracker;
}

+ (BOOL)_testString:(NSString *)str {
	
	NSParameterAssert(str);
	static NSCharacterSet* cs=nil;
	if(!cs)
		cs = [[[NSCharacterSet nodeNameCharacterSet] invertedSet] retain];
	
	BOOL isValid = NO;
	NSRange sr = [str rangeOfCharacterFromSet:cs];
	if(sr.location==NSNotFound)
		isValid = YES;
	return isValid;
}

+ (id)makeNameWithString:(NSString *)nameStr {
	
	NSParameterAssert(nameStr);
	NodeName *chld = [[[[self class] alloc] initWithName:nameStr] autorelease];
	return chld;
}

+ (id)makeNameBasedOnClass:(Class)objClass {
	
	NSString *nameRoot = [NSString stringWithFormat:@"%@%i", [objClass className], 1 ];
	return [self makeNameWithString:nameRoot];
}

+ (NSArray *)uniqueChildNamesBasedOn:(NSArray *)nameStrings forSet:(SHChildContainer *)container {
	
	NSParameterAssert([nameStrings count]);

	static NSCharacterSet *decimalCS=nil;
	if(!decimalCS)
		decimalCS = [NSCharacterSet decimalDigitCharacterSet];

	NSMutableArray *newNameStrings = [NSMutableArray array];
	for( NodeName *each in nameStrings )
	{
		NSUInteger i=1;
		NSString *newName = each.value;
		while([container childWithKey:newName] || [newNameStrings containsObject:newName]) 
		{
			// is there already a number at the end of the string?
			newName = [newName stringByTrimmingCharactersInSet: decimalCS];
			newName = [NSString stringWithFormat:@"%@%i", newName, i ];
			i++;
		}
		[newNameStrings addObject:newName];
	}
	
	NSAssert([newNameStrings count]==[nameStrings count], @"fuck up bad");
	NSMutableArray *newNames = [NSMutableArray array];
	for( NSString *each in newNameStrings ){
		[newNames addObject:[NodeName makeNameWithString:each]];
	}
	return newNames;
}

+ (void)_setNamesOfObjects:(NSArray *)objects toNames:(NSArray *)nodeNames withUndoManager:(NSUndoManager *)um {
	
	NSParameterAssert([objects count]);
	NSParameterAssert( [objects count]==[nodeNames count]);
	NSUInteger i=0;
	for( SHChild<SHNodeLikeProtocol> *child in objects )
	{
		NodeName *nm = [nodeNames objectAtIndex:i];
		NSAssert([nm isKindOfClass:[NodeName class]], @"fucked");
		
		/* we didnt add it yet so strictly speaking are not changing the name so don't need to provide the parent */
		[child changeNameTo:nm fromParent:[child parentSHNode] undoManager:um];
		i++;
	}
}

- (id)initWithName:(NSString *)nameStr {
	
	NSParameterAssert(nameStr);
	self=[super init];
	if(self) {
		BOOL isValid = [NodeName _testString:nameStr];
		if(!isValid){
			[self release];
			return nil;
		}
		_value = [nameStr copy];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)coder {

    self = [super init];
	if(self){
		_value = [[coder decodeObjectForKey: @"value"] retain];
	}
    return self;
}

- (void)dealloc {
	
	[_value release];
	[super dealloc];
}


/* As long as we are 100% immutable this is ok */
- (id)copyWithZone:(NSZone *)zone {
//	NodeName *copy = [super copyWithZone:zone];
//	copy->_value = [_value copy];
//	return copy;
	return [self retain];
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_value forKey:@"value"];
}

- (BOOL)isEqualToNodeName:(NodeName *)aName {

	NSParameterAssert(aName);
    if(self==aName)
        return YES;
	if([self class]!=[aName class])
		return NO;
    if (![_value isEqualToString:[aName value]])
        return NO;
    return YES;
}

- (BOOL)isEqual:(id)other {

	// TableView does this - why? I think it was an error in how tableView was set up
    if(other==nil){
        //return NO;
		[NSException raise:@"dumb ass" format:@""];
	}
    if( other==self){
        return YES;
	}
	if([other isKindOfClass:[self class]]==NO){
        return NO;
	}
    return [self isEqualToNodeName:other];
}

- (NSUInteger)hash {
	
	int prime = 31;
	int result = 1;
	result = prime * result + [_value hash];
	return result;
}

+ (NSArray *)stringsFromNodeNames:(NSArray *)nodeNames {
	
	NSParameterAssert([nodeNames count]);

	NSMutableArray *nameStrings = [NSMutableArray array];
	for( NodeName *nm in nodeNames ) {
		NSAssert([nm isKindOfClass:[NodeName class]], @"no");
		[nameStrings addObject:nm.value];
	}
	return nameStrings;
}

+ (NSArray *)nodeNamesFromStrings:(NSArray *)nodeNameStrings {

	NSParameterAssert([nodeNameStrings count]);

	NSMutableArray *nodeNames = [NSMutableArray array];
	for( NSString *nm in nodeNameStrings ){
		NSAssert([nm isKindOfClass:[NSString class]], @"no");
		[nodeNames addObject:[NodeName makeNameWithString:nm]];
	}
	return nodeNames;
}

// if 1 of the nodes doesn't have a name insert a default name - doesn't have to be unique
+ (NSArray *)currentOrNewNamesForNodes:(NSArray *)objects {
	
	NSParameterAssert([objects count]);
	NSMutableArray *startingFileNames = [NSMutableArray array];
	for( NSObject<SHNodeLikeProtocol> *child in objects )
	{
		NodeName *name = [child name];
		if(name==nil) {
			// make up a unique name
			name = [NodeName makeNameBasedOnClass:[child class]];
			NSAssert(name, @"This can't fail can it? You would need a wierd class name.");
		}
		[startingFileNames addObject:name];
	}
	NSAssert2([objects count]==[startingFileNames count], @"not the correct amont of StartingFileName for objects %i - %i", [objects count], [startingFileNames count]);
	return startingFileNames;
}


- (NSString *)description {
	return( [NSString stringWithFormat:@"%@ - %@", [super description], _value] );
}

@end
