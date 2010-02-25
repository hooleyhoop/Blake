//
//  FilteringArrayControllerTests.m
//  SHShared
//
//  Created by steve hooley on 12/11/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//
#pragma mark -

@interface FiltArrayTestOb: NSObject {
	NSString *myCategory;
}
@property (retain) NSString *myCategory;
@end

@implementation FiltArrayTestOb
@synthesize myCategory;

- (id)initWithCategory:(NSString *)value {

	self = [super init];
	if(self)
		myCategory = [value retain];
	return self;
}

- (void)dealloc {

	[myCategory release];
	[super dealloc];
}

@end

#pragma mark -
@interface FilteringArrayControllerTests : SenTestCase {
	
	FilteringArrayController *_arrayController;
}

@end

#pragma mark -
@implementation FilteringArrayControllerTests


- (void)setUp {
	
	_arrayController = [[FilteringArrayController alloc] init];
}

- (void)tearDown {
	
	[_arrayController release];
}

- (void)testStuff {
	// - (NSArray *)arrangeObjects:(NSArray *)objects
	
	FiltArrayTestOb *ob1 = [[[FiltArrayTestOb alloc] initWithCategory:@"Work"] autorelease];
	FiltArrayTestOb *ob2 = [[[FiltArrayTestOb alloc] initWithCategory:@"Play"] autorelease];
	FiltArrayTestOb *ob3 = [[[FiltArrayTestOb alloc] initWithCategory:@"Play"] autorelease];
	NSArray *stubObjects = [NSArray arrayWithObjects:ob1, ob2, ob3, nil];
	
	_arrayController.propertyToMatch = @"myCategory";
	_arrayController.searchString = @"Play";

	NSArray *matchedObjects = [_arrayController arrangeObjects:stubObjects];
	STAssertTrue([matchedObjects count]==2, @"failed to match all objects");
	STAssertTrue([matchedObjects objectAtIndex:0]==ob2, @"failed to match all objects");
	STAssertTrue([matchedObjects objectAtIndex:1]==ob3, @"failed to match all objects");
}

- (void)testSearch {
	// - (void)search:(id)sender
	
	FiltArrayTestOb *ob1 = [[[FiltArrayTestOb alloc] initWithCategory:@"111"] autorelease];
	FiltArrayTestOb *ob2 = [[[FiltArrayTestOb alloc] initWithCategory:@"222"] autorelease];
	FiltArrayTestOb *ob3 = [[[FiltArrayTestOb alloc] initWithCategory:@"333"] autorelease];
	NSArray *stubObjects = [NSArray arrayWithObjects:ob1, ob2, ob3, nil];
	
	_arrayController.propertyToMatch = @"myCategory";
	[_arrayController search:[NSNumber numberWithInt:111]];
	
	[_arrayController arrangeObjects:stubObjects];
	NSArray *filteredContents = [_arrayController arrangedObjects];
//TODO:	STAssertTrue([filteredContents count]==1, @"failed to match all objects %i", [filteredContents count]);

}

@end
