//
//  SHNodeRegister.m
//  InterfaceTest
//
//  Created by Steve Hooley on 24/10/2004.
//  Copyright 2004 HooleyHoop. All rights reserved.
//

#import "SHNodeRegister.h"
#import <sys/time.h>
#import <objc/objc-runtime.h>

static SHNodeRegister *sharedNodeRegister;

@implementation SHNodeRegister

@synthesize allNodeGroups=_allNodeGroups;

#pragma mark -
#pragma mark class methods
+ (SHNodeRegister *)sharedNodeRegister {

	if(!sharedNodeRegister)
		sharedNodeRegister = [[SHNodeRegister alloc] init];
	return sharedNodeRegister;
}

+ (void)cleanUpSharedNodeRegister {

	[sharedNodeRegister release];
	sharedNodeRegister = nil;
}

+ (void)scanAllClasses {
	
	struct timeval t;
	gettimeofday(&t, NULL);
	double currentTime = (double) t.tv_sec + (double) t.tv_usec / 1000000.0;
	
	NSInteger i, numClasses = 0, newNumClasses = objc_getClassList(NULL, 0);
	Class *classes = NULL;
	while (numClasses < newNumClasses) 
	{
		numClasses = newNumClasses;
		classes = realloc(classes, sizeof(Class) * numClasses);
		newNumClasses = objc_getClassList(classes, numClasses);
	}	
	NSUInteger count=0;
	int classCount = 0;
	SEL testSel = @selector(isKindOfClass:);
	Protocol *operatorProtocol = NSProtocolFromString(@"SHNodeLikeProtocol");
	
	for( NSUInteger i=0; i<numClasses; i++ )
	{
		Class thisClass = classes[i];
		if( class_getInstanceMethod( thisClass, testSel) )
		{
			if([thisClass conformsToProtocol:operatorProtocol]){
				logInfo( @"%@", NSStringFromClass(thisClass) );
				classCount++;
			}
			count++; 
		}
	}

	gettimeofday(&t, NULL);
	double newTime = (double) t.tv_sec + (double) t.tv_usec / 1000000.0;
	logInfo(@"Time taken to scan all classes is %f - found %i classes", (float)(newTime-currentTime), classCount);
	free(classes);
}

#pragma mark init methods
- (id)init {

	self = [super init];
    if(self) {
		_allNodeGroups = [[NSMutableDictionary alloc] init];
//		[self registerOperatorClass:[SHNode class]];
	}
	return self;
}

- (void)dealloc {
	
	[_allNodeGroups release];
    [super dealloc];
}

#pragma mark action methods
- (void)_registerOperatorClass:(Class)aClass {
	
	NSArray *pathWhereResides = [[(id)aClass pathWhereResides] pathComponents];
	NSMutableDictionary *dictToAddTo = _allNodeGroups;
	
	for( NSString *pathComponent in pathWhereResides )
	{
		if( ![pathComponent isEqualToString:@"/"] )
		{
			NSMutableDictionary *tempDict = (NSMutableDictionary*)[dictToAddTo valueForKey: pathComponent];
			if(tempDict==nil){
				tempDict = [NSMutableDictionary dictionary];
				[dictToAddTo setValue:tempDict forKey:pathComponent];
			}
			dictToAddTo = tempDict;
		}
	}
	[dictToAddTo setObject:aClass forKey:NSStringFromClass(aClass)];
}

- (void)_registerAttributeClass:(Class)aClass {
	
	NSMutableDictionary *dictToAddTo = _allNodeGroups;
	NSMutableDictionary *tempDict = (NSMutableDictionary *)[dictToAddTo valueForKey:@"SHBasic"];
	if(tempDict==nil){
		tempDict = [NSMutableDictionary dictionary];
		[dictToAddTo setValue:tempDict forKey: @"SHBasic"];
	}
	dictToAddTo = tempDict;
	[dictToAddTo setObject:aClass forKey:NSStringFromClass(aClass)];
}

- (void)registerOperatorClasses:(NSArray *)classes {

	for( Class aClass in classes ){
		[self registerOperatorClass:aClass];
	}
}

- (void)registerOperatorClass:(Class)aClass {

	if( [aClass conformsToProtocol:@protocol(SHOperatorProtocol)] ){
		[self _registerOperatorClass:aClass];

	} else if( [aClass conformsToProtocol:@protocol(SHAttributeProtocol)] ){
		[self _registerAttributeClass:aClass];

	} else {
		[NSException raise:@"SHNodeRegister.m: ERROR: failure Not the correct kind of node to load - doesnt conform to protocol%@" format:@"%@", NSStringFromClass(aClass) ];
	}
}

- (BOOL)registerNodeType:(NSString *)aNodeType inGroup:(NSString *)aNodeGroup1 inGroup:(NSString *)aNodeGroup2
{   
	// See if this NodeType is a real Class in the runtime
	Class nodeClass = NSClassFromString( aNodeType );
	
	if(nodeClass!=nil)
	{
		// Here we keep a list of recognized node classes
		NSMutableDictionary *groupDict2 = (NSMutableDictionary*)[_allNodeGroups valueForKey: aNodeGroup2];
		if(groupDict2==nil){
			groupDict2 = [NSMutableDictionary dictionaryWithCapacity:1];
			[_allNodeGroups setValue: groupDict2 forKey: aNodeGroup2];
		}

		NSMutableDictionary *groupDict1 = (NSMutableDictionary*)[groupDict2 valueForKey: aNodeGroup1];
		if(groupDict1==nil){
			groupDict1 = [NSMutableDictionary dictionaryWithCapacity:1];
			[groupDict2 setValue: groupDict1 forKey: aNodeGroup1];
		}

		id classObject = [groupDict1 objectForKey: (id)aNodeType];
		if(classObject==nil) // check for duplicate entry
		{
			//	logInfo(@"SHNodeRegister.m: node %@ isnt already registered so im adding it", aNodeType );
			[groupDict1 setObject: nodeClass forKey: aNodeType];
			return YES;
		} else {
			logInfo(@"SHNodeRegister.m: node %@ wont be added", aNodeType );
			return NO;
		}
	} else {
		logInfo(@"SHNodeRegister.m: The NodeType '%@' Does Not Exist!", aNodeType );
	}
	return NO;
}

- (Class)lookupNode:(NSString *)aNodeType inGroup:(NSString *)aNodeGroup
{
	NSMutableDictionary *groupDict = [_allNodeGroups objectForKey:(id)aNodeGroup];
	if(groupDict!=nil)
	{
		id classObject = [groupDict objectForKey:(id)aNodeType];
		return classObject;
	} else {
		return nil;
	}	
}

- (Class)lookupNode:(NSString *)aNodeType inGroup:(NSString *)aNodeGroup1 inGroup:(NSString *)aNodeGroup2
{
	NSMutableDictionary *groupDict2	= [_allNodeGroups objectForKey:(id)aNodeGroup2];
	if(groupDict2!=nil)
	{
		NSMutableDictionary *groupDict1	= [groupDict2 objectForKey:(id)aNodeGroup1];
		if(groupDict1!=nil)
		{	
			id classObject = [groupDict1 objectForKey:(id)aNodeType];
			return classObject;
		}
	}
	return nil;	
}


@end
