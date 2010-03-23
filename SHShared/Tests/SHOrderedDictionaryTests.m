//
//  SHOrderedDictionaryTests.m
//  Shared
//
//  Created by Steven Hooley on 28/07/2007.
//  Copyright 2007 HooleyHoop. All rights reserved.
//

@interface TestCopyableObject : NSObject <NSCopying> {
	NSString *stringValue;
}
@property(retain) NSString *stringValue;
- (id)initWithStringValue:(NSString *)value;
@end

@implementation TestCopyableObject

@synthesize stringValue;
- (id)initWithStringValue:(NSString *)value {
	self = [super init];
	stringValue = [value retain];
	return self;
}
- (void)dealloc {
	[stringValue release];
	[super dealloc];
}

- (id)copyWithZone:(NSZone *)zone {
	return [[[self class] alloc] initWithStringValue:stringValue];
}

- (BOOL)isEquivalentTo:(id)value {
	
	if(![super isEquivalentTo:value])
		return NO;
	return ([self.stringValue isEqualToString:[(TestCopyableObject *)value stringValue]]);
}
@end

/*
 *
 */
@interface SHOrderedDictionaryTests : SenTestCase {
	
    NSAutoreleasePool *_pool;
	SHOrderedDictionary* _dict;
}

@end


static BOOL selectionDidChange = NO;
static BOOL arrayDidChange = NO;
static int notificationsReceivedCount=0, arrayChangedCount=0, selectionChangedCount=0;

/*
 *
*/
@implementation SHOrderedDictionaryTests

- (void)setUp {
    
    _pool = [[NSAutoreleasePool alloc] init];

	_dict = [[SHOrderedDictionary dictionary] retain];
	STAssertNotNil(_dict, @"SHOrderedDictionaryTests ERROR.. Couldnt make an SHOrderedDictionary");
	
	[_dict addObserver:self forKeyPath:@"selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
	[_dict addObserver:self forKeyPath:@"array" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
	[_dict addObserver:self forKeyPath:@"dict" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
}

- (void)tearDown
{
    [_dict removeObserver:self forKeyPath:@"selection"];
    [_dict removeObserver:self forKeyPath:@"array"];
    [_dict removeObserver:self forKeyPath:@"dict"];
	[_dict release];
	_dict = nil;
    
    [_pool release];
}

- (void)resetObservations {
	
	selectionDidChange = NO;
	arrayDidChange = NO;
	notificationsReceivedCount=0, arrayChangedCount=0, selectionChangedCount=0;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	
	notificationsReceivedCount++;

    if ([keyPath isEqual:@"selection"]) {
			selectionDidChange = YES;
			selectionChangedCount++;
     } else
	if ([keyPath isEqual:@"array"]) {
			arrayDidChange = YES;
			arrayChangedCount++;
     } else
	if ([keyPath isEqual:@"dict"]) {
		logError(@"didct did change");
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];   
    }
}

#pragma mark -
#pragma mark class methods
// used for copying
- (void)test_initWithArray_Dict
{
  	NSMutableArray* array = [NSMutableArray array];
	NSMutableDictionary* dict = [NSMutableDictionary dictionary];
	
	/* we are not bound to this one so cannot test the notifications */
	SHOrderedDictionary* ordered = [[[SHOrderedDictionary alloc] _initWithArray:array dict:dict] autorelease];
	STAssertNotNil(ordered, @"SHOrderedDictionaryTests ERROR.. Couldnt make an SHOrderedDictionary");
	NSString* name1 = @"steve";
	NSString* name2 = @"hooley";
	
	[ordered setObject:name1 forKey:@"name1"];
	[ordered setObject:name2 forKey:@"name2"];

	STAssertTrue([dict count]==2, @"fail");
	STAssertTrue([array count]==2, @"fail");
}

#pragma mark action methods

- (void)testSetObjectsAtIndexesForKeys {
    // - (void)setObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes forKeys:(NSArray *)keys 
    
	NSString* initial = @"i am the first object";
	[_dict setObject:initial forKey:@"initial"];
	[_dict addObjectToSelection:initial];

	NSString *name1 = @"ob1", *name2 = @"ob2", *name3 = @"ob3";

    NSArray *obs = [NSArray arrayWithObjects:name1, name2, name3, nil];
    NSIndexSet *inds = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)];
    NSArray *keys = [NSArray arrayWithObjects:@"name1", @"name2", @"name3", nil];
    
	[self resetObservations];
	[_dict setObjects:obs atIndexes:inds forKeys:keys];
	
	STAssertTrue([_dict count]==4, @"is %i", [_dict count]);
	STAssertTrue([_dict objectAtIndex:0]==name1, @"is %@", [_dict objectAtIndex:0]);
	STAssertTrue([_dict objectAtIndex:1]==name2, @"is %@", [_dict objectAtIndex:0]);
	STAssertTrue([_dict objectAtIndex:2]==name3, @"is %@", [_dict objectAtIndex:0]);
	STAssertTrue([_dict objectForKey:@"name2"]==name2, @"fail");

	// -- check how many notifications we have received
	STAssertTrue( notificationsReceivedCount==2, @"wrong number of notifications %i", notificationsReceivedCount);
	STAssertTrue( arrayChangedCount==1, @"wrong number of notifications %i", arrayChangedCount);
	STAssertTrue( selectionChangedCount==1, @"wrong number of notifications %i", selectionChangedCount );
    
	//-- test selection
	NSMutableIndexSet* selection = [_dict selection];
	STAssertTrue( [selection count]==1, @"ERR, is %i", [selection count] );
	STAssertTrue( [selection firstIndex]==3, @"ERR, is %i", [selection firstIndex] );
	
	/* Try with nil indexes */
    NSArray *obs2 = [NSArray arrayWithObjects:@"add1", @"add2", @"add3", nil];
    NSArray *keys2 = [NSArray arrayWithObjects:@"add1_name", @"add2_name", @"add3_name", nil];
	[_dict setObjects:obs2 atIndexes:nil forKeys:keys2];

	STAssertTrue([_dict count]==7, @"is %i", [_dict count]);
	STAssertTrue([_dict objectAtIndex:4]==@"add1", @"is %@", [_dict objectAtIndex:4]);
	STAssertTrue([_dict objectAtIndex:5]==@"add2", @"is %@", [_dict objectAtIndex:5]);
	STAssertTrue([_dict objectAtIndex:6]==@"add3", @"is %@", [_dict objectAtIndex:6]);
}

- (void)testRemoveObjectsForKeys {
    //- (void)removeObjectsForKeys:(NSArray *)keys;
    
	NSString* name1 = @"steve";
	NSString* name2 = @"hooley";
	NSString* name3 = @"theThird";
    NSArray *obs = [NSArray arrayWithObjects:name1, name2, name3, nil];
    NSIndexSet *inds = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)];
    NSArray *keys = [NSArray arrayWithObjects:@"name1", @"name2", @"name3", nil];
	[self resetObservations];
	[_dict setObjects:obs atIndexes:inds forKeys:keys];
	
	//-- test that the selection state is preserved
	[_dict addObjectToSelection:name2];
	
	//-- remove an object
	[_dict removeObjectsForKeys:[NSArray arrayWithObjects:@"name1", @"name3", nil]];
	
	NSMutableDictionary* dict = [_dict dict];
	NSArray* array = [_dict array];
	STAssertTrue([array count]==1, @"fail %i", [array count]);	
	STAssertTrue([dict count]==1, @"fail %i", [dict count]);
	STAssertTrue([array objectAtIndex:0]==name2, @"fail");
	STAssertTrue([dict objectForKey:@"name2"]==name2, @"fail");
    
	//-- test selection
	NSMutableIndexSet* selection = [_dict selection];
	STAssertTrue( [selection count]==1, @"ERR, is %i", [selection count] );
	STAssertTrue( [selection firstIndex]==0, @"ERR, is %i", [selection firstIndex] );
}

//- (void)testRemoveObjects {
////- (void)removeObjects:(NSArray *)objects;
//    
//	NSString* name1 = @"steve";
//	NSString* name2 = @"hooley";
//	NSString* name3 = @"theThird";
//    NSArray *obs = [NSArray arrayWithObjects:name1, name2, name3, nil];
//    NSIndexSet *inds = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)];
//    NSArray *keys = [NSArray arrayWithObjects:@"name1", @"name2", @"name3", nil];
//	[self resetObservations];
//	[_dict setObjects:obs atIndexes:inds forKeys:keys];
//	
//	//-- test that the selection state is preserved
//	[_dict addObjectToSelection:name2];
//	
//	//-- remove an object
//	[_dict removeObjects:[NSArray arrayWithObjects:name1, name3, nil]];
//
//	NSMutableDictionary* dict = [_dict dict];
//	NSArray* array = [_dict array];
//	STAssertTrue([array count]==1, @"fail %i", [array count]);	
//	STAssertTrue([dict count]==1, @"fail %i", [dict count]);
//	STAssertTrue([array objectAtIndex:0]==name2, @"fail");
//	STAssertTrue([dict objectForKey:@"name2"]==name2, @"fail");
//    
//	//-- test selection
//	NSMutableIndexSet* selection = [_dict selection];
//	STAssertTrue( [selection count]==1, @"ERR, is %i", [selection count] );
//	STAssertTrue( [selection firstIndex]==0, @"ERR, is %i", [selection firstIndex] );
//}

- (void)testRemoveObjectsAtIndexes {
//- (void)removeObjectsAtIndexes:(NSIndexSet *)indexes
    
	NSString* name1 = @"steve";
	NSString* name2 = @"hooley";
	NSString* name3 = @"theThird";
    NSArray *obs = [NSArray arrayWithObjects:name1, name2, name3, nil];
    NSIndexSet *inds = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)];
    NSArray *keys = [NSArray arrayWithObjects:@"name1", @"name2", @"name3", nil];
	[_dict setObjects:obs atIndexes:inds forKeys:keys];
	
	//-- test that the selection state is preserved
	[_dict addObjectToSelection:name2];
	[_dict addObjectToSelection:name3];

	[self resetObservations];

	//-- remove an object
    NSMutableIndexSet *indexesToRemove = [NSMutableIndexSet indexSetWithIndex:0];
    [indexesToRemove addIndex:2];
	[_dict removeObjectsAtIndexes:indexesToRemove];
    
	NSMutableDictionary *dict = [_dict dict];
	NSArray *array = [_dict array];
	STAssertTrue([array count]==1, @"fail %i", [array count]);	
	STAssertTrue([dict count]==1, @"fail %i", [dict count]);
	STAssertTrue([array objectAtIndex:0]==name2, @"fail");
	STAssertTrue([dict objectForKey:@"name2"]==name2, @"fail");
    
	//-- test selection
	NSMutableIndexSet* selection = [_dict selection];
	STAssertTrue( [selection count]==1, @"ERR, is %i", [selection count] );
	STAssertTrue( [selection firstIndex]==0, @"ERR, is %i", [selection firstIndex] );

	// -- check how many notifications we have received
	STAssertTrue( 2==notificationsReceivedCount, @"wrong number of notifications %i", notificationsReceivedCount);
	STAssertTrue( 1==arrayChangedCount, @"wrong number of notifications %i", arrayChangedCount);
	STAssertTrue( 1==selectionChangedCount, @"wrong number of notifications %i", selectionChangedCount );
}

- (void)testSetObjectAtIndexForKey {
// - (void)setObject:(id)anObject atIndex:(int)ind forKey:(id)aKey 

	NSString* name1 = @"steve";
	NSString* name2 = @"hooley";
	arrayDidChange=NO;
	[_dict setObject:name1 atIndex:0 forKey:@"name1"];
	STAssertTrue(arrayDidChange, @"we should have received a notification - arrayDidChange 3");
	arrayDidChange=NO;
	[_dict setObject:name2 atIndex:1 forKey:@"name2"];
	STAssertTrue(arrayDidChange, @"we should have received a notification - arrayDidChange 4");
	arrayDidChange=NO;
	
	//-- select an object
	[_dict addObjectToSelection:name2];

	//-- add another object
	[self resetObservations];
	NSString* name3 = @"theThird";
	[_dict setObject:name3 atIndex:0 forKey:@"name3"];
	
	//
	STAssertTrue([_dict objectAtIndex:0]==name3, @"is %@", [_dict objectAtIndex:0]);

	//-- check that selection has been preserved
	STAssertTrue([_dict count]==3, @"is %i", [_dict count]);
	STAssertTrue([[_dict selectedObjects] count]==1, @"is %i", [[_dict selectedObjects] count]);
	STAssertTrue([[_dict selectedObjects] objectAtIndex:0]==name2, @"should be 'hooley' is %@", [[_dict selectedObjects] objectAtIndex:0]);
	
	// -- check how many notifications we have received
	STAssertTrue( notificationsReceivedCount==2, @"wrong number of notifications %i", notificationsReceivedCount);
	STAssertTrue( arrayChangedCount==1, @"wrong number of notifications %i", arrayChangedCount);
	STAssertTrue( selectionChangedCount==1, @"wrong number of notifications %i", selectionChangedCount );
}

- (void)testSetObjectForKey {
	// - (void)setObject:(id)anObject forKey:(id)aKey
	
	NSString* name1 = @"steve";
	NSString* name2 = @"hooley";
	arrayDidChange=NO;
	[_dict setObject:name1 forKey:@"name1"];
	STAssertTrue(arrayDidChange, @"we should have received a notification - arrayDidChange 3");
	arrayDidChange=NO;
	[_dict setObject:name2 forKey:@"name2"];
	STAssertTrue(arrayDidChange, @"we should have received a notification - arrayDidChange 4");
	arrayDidChange=NO;
	
	//-- select an object
	[_dict addObjectToSelection:name2];
	
	//-- add another object
	NSString* name3 = @"theThird";
	[_dict setObject:name3 forKey:@"name3"];

	//-- check that selection has been preserved
	STAssertTrue([_dict count]==3, @"is %i", [_dict count]);
	STAssertTrue([[_dict selectedObjects] count]==1, @"is %i", [[_dict selectedObjects] count]);
	STAssertTrue([[_dict selectedObjects] objectAtIndex:0]==name2, @"is %@", [[_dict selectedObjects] objectAtIndex:0]);
}

- (void)testRemoveObjectForKey {
	// - (void)removeObjectForKey:(id)aKey
	
	NSString* name1 = @"steve";
	NSString* name2 = @"hooley";
	arrayDidChange=NO;
	[_dict setObject:name1 forKey:@"name1"];
	STAssertTrue(arrayDidChange, @"we should have received a notification - arrayDidChange 3");
	arrayDidChange=NO;
	[_dict setObject:name2 forKey:@"name2"];
	STAssertTrue(arrayDidChange, @"we should have received a notification - arrayDidChange 4");
	arrayDidChange=NO;
	
	//-- test that the selection state is preserved
	[_dict addObjectToSelection:name2];
	
	//-- remove an object
	[_dict removeObjectForKey:@"name1"];
	
	STAssertTrue(arrayDidChange, @"we should have received a notification - arrayDidChange 5");
	arrayDidChange=NO;
	NSMutableDictionary* dict = [_dict dict];
	NSArray* array = [_dict array];
	STAssertTrue([array count]==1, @"fail");	
	STAssertTrue([dict count]==1, @"fail");
	STAssertTrue([array objectAtIndex:0]==name2, @"fail");
	STAssertTrue([dict objectForKey:@"name2"]==name2, @"fail");

	//-- test selection
	NSMutableIndexSet* selection = [_dict selection];
	STAssertTrue([selection count]==1, @"ERR, is %i", [selection count] );
	STAssertTrue([selection firstIndex]==0, @"ERR, is %i", [selection firstIndex] );
}

- (void)testRemoveObject {
	//- (void)removeObject:(id)anObject;
	
	NSString* name1 = @"steve";
	NSString* name2 = @"hooley";
	arrayDidChange=NO;
	[_dict setObject:name1 forKey:@"name1"];
	STAssertTrue(arrayDidChange, @"we should have received a notification - arrayDidChange 3");
	arrayDidChange=NO;
	[_dict setObject:name2 forKey:@"name2"];
	STAssertTrue(arrayDidChange, @"we should have received a notification - arrayDidChange 4");
	arrayDidChange=NO;
	
	//-- test that the selection state is preserved
	[_dict addObjectToSelection:name2];
	
	//-- remove an object
	[_dict removeObject:name1];
	
	STAssertTrue(arrayDidChange, @"we should have received a notification - arrayDidChange 5");
	arrayDidChange=NO;
	NSMutableDictionary* dict = [_dict dict];
	NSArray* array = [_dict array];
	STAssertTrue([array count]==1, @"fail");	
	STAssertTrue([dict count]==1, @"fail");
	STAssertTrue([array objectAtIndex:0]==name2, @"fail");
	STAssertTrue([dict objectForKey:@"name2"]==name2, @"fail");
	NSMutableIndexSet* selection = [_dict selection];
	STAssertTrue([selection count]==1,@"ERR, is %i", [selection count] );
	STAssertTrue([selection firstIndex]==0, @"ERR, is %i", [selection firstIndex] );
}

- (void)testSetObjectsIndexTo {
	// - (void)setObjects:(id)child indexTo:(int)i

	arrayDidChange=NO;
	// 3 possible indexes, 4 possible table drop positions
	NSString* name1 = @"aa steve";
	NSString* name2 = @"bb hooley";
	NSString* name3 = @"cc hooley";
	[_dict setObject:name1 forKey:@"name1"];
	STAssertTrue(arrayDidChange, @"we should have received a notification - arrayDidChange 6");
	
	arrayDidChange=NO;
	[_dict setSelectedObjects:[NSArray array]];
	[_dict setObject:name2 forKey:@"name2"];
	[_dict setObject:name3 forKey:@"name3"];
	STAssertTrue(arrayDidChange, @"we should have received a notification - arrayDidChange 7");
	
	/* see if selection is preserved */
	[_dict addObjectToSelection:name1];

	arrayDidChange=NO;
	[_dict setObjects:name1 indexTo:0];
	STAssertTrue([_dict objectAtIndex:0]==name1, @"fail");
	STAssertTrue([_dict objectAtIndex:1]==name2, @"fail");
	STAssertTrue([_dict objectAtIndex:2]==name3, @"fail");
	STAssertFalse(arrayDidChange, @"we should have received a notification - arrayDidChange 8");

	[_dict setObjects:name1 indexTo:1];
	STAssertTrue([_dict objectAtIndex:0]==name2, @"fail");
	STAssertTrue([_dict objectAtIndex:1]==name1, @"fail");
	STAssertTrue([_dict objectAtIndex:2]==name3, @"fail");
	STAssertTrue(arrayDidChange, @"we should have received a notification - arrayDidChange 8");

	[_dict setObjects:name1 indexTo:2];
	STAssertTrue([_dict objectAtIndex:0]==name2, @"fail");
	STAssertTrue([_dict objectAtIndex:1]==name3, @"fail");
	STAssertTrue([_dict objectAtIndex:2]==name1, @"fail");

	arrayDidChange=NO;
	STAssertThrows( [_dict setObjects:name1 indexTo:3], @"doh");
	STAssertFalse(arrayDidChange, @"we should have received a notification - arrayDidChange 8");
	
	arrayDidChange=NO;
	[_dict setObjects:name2 indexTo:2];
	STAssertTrue(arrayDidChange, @"we should have received a notification - arrayDidChange 9");
	arrayDidChange=NO;

	// test that selection was preserved
	STAssertTrue([_dict objectAtIndex:2]==name2, @"fail");
	NSArray *selectedObjects = [_dict selectedObjects];
	STAssertTrue(1==[selectedObjects count], @"ERR, is %i", [selectedObjects count] );
	STAssertTrue([selectedObjects lastObject]==name1, @"ERR" );
	
	NSMutableIndexSet *selection = [_dict selection];
	STAssertTrue([selection count]==1,@"ERR, is %i", [selection count]);
	STAssertTrue([selection firstIndex]==1, @"ERR, is %i", [selection firstIndex]);
}

- (void)testMoveObjectsToIndexes {
// - (void)moveObjects:(NSArray *)children toIndexes:(NSIndexSet)indexes

	NSString *name1=@"1",*name2=@"2",*name3=@"3",*name4=@"4",*name5=@"5";

	[_dict setObject:name1 forKey:@"name1"];
	[_dict setObject:name2 forKey:@"name2"];
	[_dict setObject:name3 forKey:@"name3"];
	[_dict setObject:name4 forKey:@"name4"];
	[_dict setObject:name5 forKey:@"name5"];
	[_dict setSelectedObjects:[NSArray array]];
	[_dict addObjectToSelection:name1];
	[_dict addObjectToSelection:name4];
	
	arrayDidChange=NO;
	[_dict moveObjects:[NSArray arrayWithObjects:name3,name5,nil] toIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)]];
	STAssertTrue([_dict objectAtIndex:0]==name3, @"fail");
	STAssertTrue([_dict objectAtIndex:1]==name5, @"fail");
	STAssertTrue([_dict objectAtIndex:2]==name1, @"fail");
	STAssertTrue([_dict objectAtIndex:3]==name2, @"fail");
	STAssertTrue([_dict objectAtIndex:4]==name4, @"fail");
	STAssertTrue(arrayDidChange, @"we should have received a notification - arrayDidChange 9");

	arrayDidChange=NO;
	[_dict moveObjects:[NSArray arrayWithObjects:name3,name1,nil] toIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1,2)]];
	STAssertTrue([_dict objectAtIndex:0]==name5, @"fail");
	STAssertTrue([_dict objectAtIndex:1]==name3, @"fail");
	STAssertTrue([_dict objectAtIndex:2]==name1, @"fail");
	STAssertTrue([_dict objectAtIndex:3]==name2, @"fail");
	STAssertTrue([_dict objectAtIndex:4]==name4, @"fail");
	STAssertTrue(arrayDidChange, @"we should have received a notification - arrayDidChange 9");

	arrayDidChange=NO;
	[_dict moveObjects:[NSArray arrayWithObjects:name1,name4,nil] toIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, 2)]];
	STAssertTrue([_dict objectAtIndex:0]==name5, @"fail");
	STAssertTrue([_dict objectAtIndex:1]==name3, @"fail");
	STAssertTrue([_dict objectAtIndex:2]==name1, @"fail");
	STAssertTrue([_dict objectAtIndex:3]==name4, @"fail");
	STAssertTrue([_dict objectAtIndex:4]==name2, @"fail");
	STAssertTrue(arrayDidChange, @"we should have received a notification - arrayDidChange 9");

	arrayDidChange=NO;
	[_dict moveObjects:[NSArray arrayWithObjects:name5,name4,nil] toIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(3, 2)]];
	STAssertTrue([_dict objectAtIndex:0]==name3, @"fail");
	STAssertTrue([_dict objectAtIndex:1]==name1, @"fail");
	STAssertTrue([_dict objectAtIndex:2]==name2, @"fail");
	STAssertTrue([_dict objectAtIndex:3]==name5, @"fail");
	STAssertTrue([_dict objectAtIndex:4]==name4, @"fail");
	STAssertTrue(arrayDidChange, @"we should have received a notification - arrayDidChange 9");

	arrayDidChange=NO;
	[_dict moveObjects:[NSArray arrayWithObjects:name3,nil] toIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(4, 1)]];
	STAssertTrue([_dict objectAtIndex:0]==name1, @"fail");
	STAssertTrue([_dict objectAtIndex:1]==name2, @"fail");
	STAssertTrue([_dict objectAtIndex:2]==name5, @"fail");
	STAssertTrue([_dict objectAtIndex:3]==name4, @"fail");
	STAssertTrue([_dict objectAtIndex:4]==name3, @"fail");
	STAssertTrue(arrayDidChange, @"we should have received a notification - arrayDidChange 9");

	NSArray *selectedObjects = [_dict selectedObjects];
	STAssertTrue(2==[selectedObjects count], @"ERR, is %i", [selectedObjects count] );
	
	arrayDidChange=NO;
	NSArray *woah = [NSArray arrayWithObjects:name1,name2,nil];
	STAssertThrows( [_dict moveObjects:woah toIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(5, 2)]], @"invalid index" );
	STAssertFalse(arrayDidChange, @"we should have received a notification - arrayDidChange 9");

	// test that selection was preserved
	selectedObjects = [_dict selectedObjects];
	STAssertTrue(2==[selectedObjects count], @"ERR, is %i", [selectedObjects count] );
	STAssertTrue([selectedObjects objectAtIndex:0]==name1, @"ERR" );
	STAssertTrue([selectedObjects objectAtIndex:1]==name4, @"ERR" );
	NSMutableIndexSet *selection = [_dict selection];
	STAssertTrue([selection count]==2,@"ERR, is %i", [selection count]);
	STAssertTrue([selection firstIndex]==0, @"ERR, is %i", [selection firstIndex]);
	STAssertTrue([selection indexGreaterThanIndex:0]==3, @"ERR, is %i", [selection indexGreaterThanIndex:0]);
	
	// try moving something to where it already is
	arrayDidChange=NO;
	[_dict moveObjects:[NSArray arrayWithObjects:name1,name2,nil] toIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)]];
	STAssertFalse(arrayDidChange, @"we should have received a notification - arrayDidChange 9");
	
	// the objects that we pass in should really be in their natural order? does it matter?
	NSArray *woah2 = [NSArray arrayWithObjects:name4,name5,nil];
	STAssertThrows( [_dict moveObjects:woah2 toIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)]], @"invalid index" );

	// ok space cadet
	NSMutableIndexSet *moreComplexIndexSet = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 1)];
	[moreComplexIndexSet addIndex:3];
	[_dict moveObjects:[NSArray arrayWithObjects:name1,name5,nil] toIndexes:moreComplexIndexSet];
	STAssertTrue([_dict objectAtIndex:0]==name2, @"fail");
	STAssertTrue([_dict objectAtIndex:1]==name1, @"fail");
	STAssertTrue([_dict objectAtIndex:2]==name4, @"fail");
	STAssertTrue([_dict objectAtIndex:3]==name5, @"fail");
	STAssertTrue([_dict objectAtIndex:4]==name3, @"fail");
}

- (void)testRenameObjectTo {
	// - (void)renameObject:(id)child to:(NSString *)value

	NSString* ob1 = @"ob1";
	NSString* ob2 = @"ob2";
	
	[_dict setObject:ob1 forKey:@"name1"];
	[_dict setObject:ob2 forKey:@"name2"];
	[_dict renameObject:ob1 to:@"larry"];
	[_dict renameObject:ob2 to:@"barry"];

	NSMutableDictionary* dict = [_dict dict];
	STAssertTrue([dict objectForKey:@"larry"]==ob1, @"fail");	
	STAssertTrue([dict objectForKey:@"barry"]==ob2, @"fail");
	STAssertTrue([dict objectForKey:@"name1"]==nil, @"fail");
}

- (void)testObjectForKey
{
	// - (id)objectForKey:(id)aKey;
	NSString* name1 = @"steve";
	NSString* name2 = @"hooley";
	[_dict setObject:name1 forKey:@"name1"];
	[_dict setObject:name2 forKey:@"name2"];
	id ob1 = [_dict objectForKey:@"name1"];
	id ob2 = [_dict objectForKey:@"name2"];
	STAssertTrue(ob1==name1, @"fail, is %@", ob1 );
	STAssertTrue(ob2==name2, @"fail, is %@", ob2 );
	
	[_dict retain];
//	STAssertTrue(NO,@"cheese");
}

//- (void)testDeleteSelectedObjects {
//	
//	// - (void)deleteSelectedObjects;
//	NSString* name1 = @"steve";
//	NSString* name2 = @"hooley";
//	NSString* name3 = @"dave";
//	[_dict setObject:name1 forKey:@"name1"];
//	[_dict setObject:name2 forKey:@"name2"];
//	[_dict setObject:name3 forKey:@"name3"];
//	STAssertTrue(arrayDidChange, @"we should have received a notification - arrayDidChange 10");
//	arrayDidChange=NO;
//	selectionDidChange=NO;
//	[_dict setSelectedObjects:[NSArray arrayWithObjects:name1, name3, nil]];
//	STAssertTrue(selectionDidChange, @"we should have received a notification");
//	selectionDidChange=NO;
//	[_dict deleteSelectedObjects];
//	STAssertTrue(arrayDidChange, @"we should have received a notification - arrayDidChange 11");
//	arrayDidChange=NO;
//	STAssertTrue(selectionDidChange, @"we should have received a notification");
//	selectionDidChange=NO;
//
//	// -- no selected objects
//	STAssertTrue([[_dict selectedObjects] count]==0, @"ERR");
//	STAssertTrue([[_dict selection] count]==0, @"ERR");
//	
//	// -- only object left is object2
//	STAssertTrue([[_dict dict] count]==1, @"ERR");
//	STAssertTrue([[_dict array] count]==1, @"ERR");
//	STAssertTrue([_dict objectForKey:@"name2"]==name2, @"ERR");
//	STAssertTrue([_dict objectAtIndex:0]==name2, @"ERR");
//	
//	// -- index of object2 is 0
//	STAssertTrue([_dict indexOfObjectIdenticalTo:name2]==0, @"ERR");
//}

 #pragma mark Experimental Selection Methods
 
//- (void)selectAll;
// - (void)testSelectAll {
// 
//  	NSString* name1 = @"steve";
//	NSString* name2 = @"hooley";
//	[_dict setObject:name1 forKey:@"name1"];
//	[_dict setObject:name2 forKey:@"name2"];
//	[_dict unSelectAll];
//	selectionDidChange=NO;
//	[_dict selectAll];
//	STAssertTrue(selectionDidChange, @"we should have received a notification");
//	selectionDidChange=NO;
//	NSArray* selectedObjects = [_dict selectedObjects];
//	STAssertTrue([selectedObjects count]==2, @"ERR");
// }
 
 
//- (void)unSelectAll;
// - (void)testUnSelectAll {
// 
// 	NSString* name1 = @"steve";
//	NSString* name2 = @"hooley";
//	[_dict setObject:name1 forKey:@"name1"];
//	[_dict setObject:name2 forKey:@"name2"];
//	[_dict addObjectToSelection:name1];
//	[_dict addObjectToSelection:name2];
//	NSArray* selectedObjects = [_dict selectedObjects];
//	STAssertTrue([selectedObjects count]==2, @"ERR");
//	selectionDidChange=NO;
//	[_dict unSelectAll];
//	STAssertTrue(selectionDidChange, @"we should have received a notification");
//	selectionDidChange=NO;
//	selectedObjects = [_dict selectedObjects];
//	STAssertTrue([selectedObjects count]==0, @"ERR");
//}


- (void)testSelectedObjects {
// - (NSArray *)selectedObjects;

    selectionDidChange =NO;
	NSString* name1 = @"steve";
	NSString* name2 = @"hooley";
	[_dict setObject:name1 forKey:@"name1"];
	[_dict setObject:name2 forKey:@"name2"];
	STAssertFalse(selectionDidChange, @"we should have received a notification");

	selectionDidChange=NO;
	[_dict setSelectedObjects:[NSArray array]];
	STAssertFalse(selectionDidChange, @"we should have received a notification");
	
	selectionDidChange=NO;
	[_dict addObjectToSelection:name2];
	NSArray* selectedObjects = [_dict selectedObjects];
	STAssertTrue([selectedObjects count]==1, @"ERR");
	STAssertTrue([selectedObjects objectAtIndex:0]==name2, @"ERR %@", [_dict objectAtIndex:0]);
}

- (void)testSetSelectedObjects
{
	//- (void)setSelectedObjects:(NSArray *)value
	NSString* name1 = @"steve";
	NSString* name2 = @"hooley";
	[_dict setObject:name1 forKey:@"name1"];
	[_dict setObject:name2 forKey:@"name2"];
	[_dict setSelectedObjects:[NSArray array]];
	STAssertTrue(selectionDidChange, @"we should have received a notification");
	selectionDidChange=NO;
	NSMutableIndexSet* selection = [_dict selection];
	STAssertNotNil(selection, @"ERR");
	STAssertTrue([selection count]==0, @"ERR");
	[_dict setSelectedObjects:[NSArray arrayWithObjects:name1, name2, nil]];
	selection = [_dict selection];
	STAssertTrue([selection count]==2, @"ERR");
	STAssertTrue(selectionDidChange, @"we should have received a notification");
	selectionDidChange=NO;
}

- (void)testAddObjectToSelection {
	// - (void)addObjectToSelection:(id)value
	
	NSString* name1 = @"steve";
	NSString* name2 = @"hooley";
	[_dict setObject:name1 forKey:@"name1"];
	[_dict setObject:name2 forKey:@"name2"];
	[_dict setSelectedObjects:[NSArray array]];
	STAssertFalse(selectionDidChange, @"we should have received a notification");
	
	selectionDidChange=NO;
	[_dict addObjectToSelection:name2];
	STAssertTrue(selectionDidChange, @"we should have received a notification");
	selectionDidChange=NO;
	NSMutableIndexSet* selection = [_dict selection];
	STAssertNotNil(selection, @"ERR");
	STAssertTrue([selection count]==1, @"ERR");
	STAssertTrue([selection firstIndex]==1, @"ERR");
	[_dict addObjectToSelection:name1];
	selection = [_dict selection];
	STAssertTrue([selection count]==2, @"ERR");
}

- (void)testAddObjectsToSelection {
	// - (void)addObjectsToSelection:(NSArray *)objects
	
	NSString* name1 = @"steve";
	NSString* name2 = @"hooley";
	[_dict setObject:name1 forKey:@"name1"];
	[_dict setObject:name2 forKey:@"name2"];
	[_dict setSelectedObjects:[NSArray array]];
	[self resetObservations];
	[_dict addObjectsToSelection:[NSArray arrayWithObjects:name1, name2, nil]];

	NSMutableIndexSet* selection = [_dict selection];
	STAssertTrue([selection count]==2, @"ERR");
	STAssertTrue([selection firstIndex]==0, @"ERR");
	
	STAssertTrue(selectionChangedCount==1, @"fucked up mutating selection %i", selectionChangedCount);
}

- (void)testRemoveObjectFromSelection {
	// - (void)removeObjectFromSelection:(id)value;
	
	NSString* name1 = @"steve";
	NSString* name2 = @"hooley";
	[_dict setObject:name1 forKey:@"name1"];
	[_dict setObject:name2 forKey:@"name2"];
	STAssertTrue(selectionDidChange, @"we should have received a notification");
	selectionDidChange=NO;
	[_dict addObjectToSelection:name1];
	[_dict addObjectToSelection:name2];
	STAssertTrue(selectionDidChange, @"we should have received a notification");
	selectionDidChange=NO;
	
	[_dict removeObjectFromSelection:name1];
	STAssertTrue(selectionDidChange, @"we should have received a notification");
	selectionDidChange=NO;

	NSMutableIndexSet* selection = [_dict selection];
	STAssertNotNil(selection, @"ERR");
	STAssertTrue([selection count]==1, @"ERR");
	STAssertTrue([selection firstIndex]==1, @"ERR");

	[_dict removeObjectFromSelection:name2];
	STAssertTrue(selectionDidChange, @"we should have received a notification");
	selectionDidChange=NO;

	selection = [_dict selection];
	STAssertTrue([selection count]==0, @"ERR");
}


- (void)testRemoveObjectsFromSelection {
	// - (void)removeObjectsFromSelection:(NSArray *)value;
	
	NSString* name1 = @"steve", *name2 = @"hooley", *name3 = @"gary";
	[_dict setObject:name1 forKey:@"name1"], [_dict setObject:name2 forKey:@"name2"], [_dict setObject:name3 forKey:@"name3"];
	[_dict addObjectToSelection:name1], [_dict addObjectToSelection:name2], [_dict addObjectToSelection:name3];
	[self resetObservations];

	[_dict removeObjectsFromSelection:[NSArray arrayWithObjects:name1, name3, nil]];
	NSMutableIndexSet* selection = [_dict selection];

	STAssertTrue([selection count]==1, @"ERR");
	STAssertTrue([selection firstIndex]==1, @"ERR");
	STAssertTrue(selectionChangedCount==1, @"fucked up mutating selection %i", selectionChangedCount);
}

- (void)testIsSelected {
// - (BOOL)isSelected:(id)value;

	NSString* name1 = @"steve";
	[_dict setObject:name1 forKey:@"name1"];
	[_dict removeObjectFromSelection:name1];
	STAssertFalse([_dict isSelected:name1], @"shouldnt be selected by default");
	[_dict addObjectToSelection:name1];
	STAssertTrue([_dict isSelected:name1], @"shouldnt be selected by default");
}

/* Check that the bindings update */
- (void)testSetSelection {
	// - (void)setSelection:(NSMutableIndexSet *)value

	NSString* name1 = @"steve";
	NSString* name2 = @"hooley";
	[_dict setObject:name1 forKey:@"name1"];
	[_dict setObject:name2 forKey:@"name2"];
	selectionDidChange=NO;
	
	[_dict setSelection:[NSMutableIndexSet indexSetWithIndex:0]];
	STAssertTrue(selectionDidChange, @"we should have received a notification");
	selectionDidChange=NO;
	
	[_dict setSelection:[NSIndexSet indexSet]];
	STAssertTrue(selectionDidChange, @"we should have received a notification");
	selectionDidChange=NO;
	
	STAssertThrows( [_dict setSelection:[NSMutableIndexSet indexSetWithIndex:5]] , @"not a valid index");
}

 #pragma mark NSCopying, hash, isEqual
- (void)testIsEqualToOrderedDict {

	//- (BOOL)isEqualToOrderedDict:(SHOrderedDictionary *)value
	SHOrderedDictionary *dict1 = [SHOrderedDictionary dictionary];
	SHOrderedDictionary *dict2 = [SHOrderedDictionary dictionary];
	
	TestCopyableObject *name1 = [[[TestCopyableObject alloc] initWithStringValue:@"steve"] autorelease];
	TestCopyableObject *name2 = [[[TestCopyableObject alloc] initWithStringValue:@"hooley"] autorelease];

	[dict1 setObject:name1 forKey:name1.stringValue];
	[dict1 setObject:name2 forKey:name2.stringValue];
	[dict2 setObject:name1 forKey:name1.stringValue];
	STAssertFalse([dict1 isEqualToOrderedDict:dict2], @"fail, is %@", dict2 );
	[dict2 setObject:name2 forKey:name2.stringValue];
	STAssertTrue([dict1 isEqualToOrderedDict:dict2], @"fail, is %@", dict2 );
	
	TestCopyableObject *name4 = [[[TestCopyableObject alloc] initWithStringValue:@"eggy"] autorelease];
	TestCopyableObject *name5 = [[[TestCopyableObject alloc] initWithStringValue:@"fluggy"] autorelease];
	[dict1 setObject:name4 forKey:name4.stringValue];
	[dict2 setObject:name5 forKey:name5.stringValue];
	STAssertFalse([dict1 isEqualToOrderedDict:dict2], @"fail, is %@", dict2 );
	
	SHOrderedDictionary* dict3 = [SHOrderedDictionary dictionary];
	[_dict setObject:name4 forKey:@"egg"];
	[dict3 setObject:name2 forKey:@"egg"];
	STAssertFalse([_dict isEqualToOrderedDict:dict3], @"fail, is %@", dict3 );
	
	SHOrderedDictionary* dict4 = [SHOrderedDictionary dictionary];
	SHOrderedDictionary* dict5 = [SHOrderedDictionary dictionary];
	[dict4 setObject:name4 forKey:@"toast1"];
	[dict5 setObject:name4 forKey:@"toast2"];
	STAssertFalse([dict4 isEqualToOrderedDict:dict5], @"fail, is %@", dict5 );
}

- (void)testFastEnumeration {
	
	NSString* name1 = @"steve";
	NSString* name2 = @"hooley";	
	[_dict setObject:name1 forKey:@"name1"];
	[_dict setObject:name2 forKey:@"name2"];
	int hitCount=0;
	for( NSString *each in _dict ){
		hitCount++;
	}
	STAssertTrue(hitCount==2, @"doh");
}

/* Shallow copy! */
- (void)testCopy {
	// - (id)copyWithZone:(NSZone *)zone;
}

- (void)testShallowCopy {
	//- (id)shallowCopy

	TestCopyableObject *name1 = [[[TestCopyableObject alloc] initWithStringValue:@"steve"] autorelease];
	TestCopyableObject *name2 = [[[TestCopyableObject alloc] initWithStringValue:@"hooley"] autorelease];
	[_dict setObject:name1 forKey:name1.stringValue];
	[_dict setObject:name2 forKey:name2.stringValue];
	
	SHOrderedDictionary* dict2 = [[_dict shallowCopy] autorelease];
	STAssertTrue([_dict isEqualToOrderedDict:dict2], @"fail, is %@", dict2 );
	
	STAssertTrue([_dict objectAtIndex:0]==[dict2 objectAtIndex:0], @"shallow copy - objects are the same");
}

- (void)testDeepCopyOfObjects {
	// - (NSArray *)deepCopyOfObjects
	
	TestCopyableObject *object1 = [[[TestCopyableObject alloc] init] autorelease];
	TestCopyableObject *object2 = [[[TestCopyableObject alloc] init] autorelease];
	[_dict setObject:object1 forKey:@"name1"];
	[_dict setObject:object2 forKey:@"name2"];
	
	NSArray *deepCopyOfObjects = [[_dict deepCopyOfObjects] autorelease];
	[deepCopyOfObjects makeObjectsPerformSelector:@selector(release)];
	STAssertTrue([deepCopyOfObjects count]==2, @"count of objects in deep copy is wrong %i", [deepCopyOfObjects count] );
	STAssertFalse([deepCopyOfObjects objectAtIndex:0]==[_dict objectAtIndex:0], @"deep copy - objects are not the same");
	STAssertFalse([deepCopyOfObjects objectAtIndex:1]==[_dict objectAtIndex:1], @"deep copy - objects are not the same");
}

- (void)testOrderedKeys {
	// - (NSArray *)orderedKeys
	
	TestCopyableObject *object1 = [[[TestCopyableObject alloc] init] autorelease];
	TestCopyableObject *object2 = [[[TestCopyableObject alloc] init] autorelease];
	TestCopyableObject *object3 = [[[TestCopyableObject alloc] init] autorelease];
	[_dict setObject:object1 forKey:@"name1"];
	[_dict setObject:object2 forKey:@"name2"];
	[_dict setObject:object3 forKey:@"name3"];
	
	NSArray *orderedKeys = [_dict orderedKeys];
	STAssertTrue( [orderedKeys objectAtIndex:0]==@"name1", @"ordered keys incorrect");
	STAssertTrue( [orderedKeys objectAtIndex:1]==@"name2", @"ordered keys incorrect");
	STAssertTrue( [orderedKeys objectAtIndex:2]==@"name3", @"ordered keys incorrect");
}

- (void)testDeepCopy {
	// - (id)deepCopy

	TestCopyableObject *object1 = [[[TestCopyableObject alloc] initWithStringValue:@"name1"] autorelease];
	TestCopyableObject *object2 = [[[TestCopyableObject alloc] initWithStringValue:@"name2"] autorelease];
	[_dict setObject:object1 forKey:object1.stringValue];
	[_dict setObject:object2 forKey:object2.stringValue];
	SHOrderedDictionary* dict2 = [[_dict deepCopy] autorelease];
	STAssertTrue([_dict isEqualToOrderedDict:dict2], @"deepCopy fail, is %@", dict2 );
	
	STAssertFalse([_dict objectAtIndex:0]==[dict2 objectAtIndex:0], @"deep copy - objects are not the same");
}

- (void)testEncodeWithCoder {
	
	NSString* name1 = @"steve";
	NSString* name2 = @"hooley";
	[_dict setObject:name1 forKey:@"name1"];
	[_dict setObject:name2 forKey:@"name2"];

	NSData *archive = [NSKeyedArchiver archivedDataWithRootObject:_dict];
	STAssertNotNil(archive, @"ooch");
	
	SHOrderedDictionary *dict2 = [NSKeyedUnarchiver unarchiveObjectWithData:archive];
	STAssertNotNil(dict2, @"ooch");
	
	STAssertTrue( [[dict2 objectForKey:@"name1"] isEqualToString:name1], @"cock %@ = %@", [dict2 objectForKey:@"name1"], name1 );
	STAssertTrue( [[dict2 objectForKey:@"name2"] isEqualToString:name2], @"cock %@ = %@", [dict2 objectForKey:@"name2"], name2 );
	
	STAssertTrue([dict2 isEqualToOrderedDict:_dict], @"dict must be equal");
}

#pragma mark accessor methods

- (void)testContainsObject
{
	// - (BOOL)containsObject:(id)anObject;
	NSString* name1 = @"steve";
	NSString* name2 = @"hooley";
	[_dict setObject:name1 forKey:@"name1"];
	[_dict setObject:name2 forKey:@"name2"];
	STAssertTrue([_dict containsObject:name1], @"fail");
	STAssertTrue([_dict containsObject:name2], @"fail");
}

- (void)testObjectEnumerator
{
	// - (NSEnumerator *)objectEnumerator;
	NSString* name1 = @"steve";
	NSString* name2 = @"hooley";
	[_dict setObject:name1 forKey:@"name1"];
	[_dict setObject:name2 forKey:@"name2"];
	NSEnumerator* enumer = [_dict objectEnumerator];
	STAssertNotNil(enumer, @"fail");
	NSString* each;
	int count = 0;
	while( (each=[enumer nextObject]) ){
		switch(count){
			case 0:
				STAssertTrue(each==name1, @"fail");
				break;
			case 1:
				STAssertTrue(each==name2, @"fail");
				break;
			default:
				STFail(@"This should not happen");
		}
		STAssertTrue([_dict containsObject:name2], @"fail");
		count++;
	}
	STAssertTrue(count==2, @"fail");
}

- (void)testKeyEnumerator
{
	// - (NSEnumerator *)keyEnumerator;
	NSString* name1 = @"steve";
	NSString* name2 = @"hooley";
	NSString* name3 = @"jones";
	[_dict setObject:name1 forKey:@"name1"];
	[_dict setObject:name2 forKey:@"name2"];
	[_dict setObject:name3 forKey:@"name3"];
	NSEnumerator* enumer = [_dict keyEnumerator];
	STAssertNotNil(enumer, @"fail");
	NSString* each;
	int count = 0;
	while( (each=[enumer nextObject]) ){
		STAssertNotNil(each, @"fail");
//		switch(count){
//			case 0:
//				STAssertTrue(each== isEqualToString @"name1", @"fail");
//				break;
//			case 1:
//				STAssertTrue(each== isEqualToString@"name2", @"fail");
//				break;
//			case 2:
//				STAssertTrue(each== isEqualToString@"name3", @"fail");
//				break;
//			default:
//				STFail(@"This should not happen");
//		}
		// STAssertTrue([_dict containsObject:name2], @"fail");
		count++;
	}
	STAssertTrue(count==3, @"fail");
}

- (void)testObjectAtIndex {
	// - (id)objectAtIndex:(unsigned)index

	NSString* name1 = @"steve";
	NSString* name2 = @"hooley";
	[_dict setObject:name1 forKey:@"name1"];
	[_dict setObject:name2 forKey:@"name2"];
	STAssertTrue([_dict objectAtIndex:0]==name1, @"fail");
	STAssertTrue([_dict objectAtIndex:1]==name2, @"fail");	
}

- (void)testIndexOfObject{
	// - (unsigned)indexOfObject:(id)anObject
	// - (unsigned)indexOfObjectIdenticalTo:(id)anObject

	NSString* name1 = @"steve";
	NSString* name2 = @"hooley";
	[_dict setObject:name1 forKey:@"name1"];
	[_dict setObject:name2 forKey:@"name2"];
	//	STAssertTrue([_dict indexOfObject:name1]==0, @"fail");
	STAssertTrue([_dict indexOfObjectIdenticalTo:name1]==0, @"fail");
	STAssertTrue([_dict indexOfObjectIdenticalTo:name2]==1, @"fail");	
}

- (void)testIndexesOfObjects {
	// - (NSIndexSet *)indexesOfObjects:(NSArray *)children
	
	NSString* name1 = @"steve";
	NSString* name2 = @"hooley";
	NSString* name3 = @"cat";
	[_dict setObject:name1 forKey:@"name1"];
	[_dict setObject:name2 forKey:@"name2"];
	[_dict setObject:name3 forKey:@"name3"];
	
	NSIndexSet *inds = [_dict indexesOfObjects:[NSArray arrayWithObjects:name1,name3,nil]];
	
	STAssertTrue(2==[inds count], @"fail");
	STAssertTrue([inds firstIndex]==0, @"fail");
	STAssertTrue([inds lastIndex]==2, @"fail");
	
	NSArray *incorrectlyOrderedArray = [NSArray arrayWithObjects:name3,name1,nil];
	STAssertThrows([_dict indexesOfObjects:incorrectlyOrderedArray], @"They have to be in the right order, no?");
}


- (void)testAllValues
{
	// - (NSArray *)allValues;
	NSString* name1 = @"steve";
	NSString* name2 = @"hooley";
	[_dict setObject:name1 forKey:@"name1"];
	[_dict setObject:name2 forKey:@"name2"];
	NSArray* allValues = [_dict allValues];
	STAssertTrue([allValues count]==2, @"count is %i", [allValues count] );
	STAssertTrue([allValues objectAtIndex:0]==name1, @"fail");
	STAssertTrue([_dict objectAtIndex:1]==name2, @"fail");
}

- (void)testCount
{
	// - (unsigned)count;
	[_dict setObject:@"steve" forKey:@"name"];
	[_dict setObject:@"hooley" forKey:@"name2"];
	STAssertTrue([_dict count]==2, @"fail");
}

- (void)testArray
{
	// - (NSArray *)array;	
	NSString* name1 = @"steve";
	NSString* name2 = @"hooley";
	[_dict setObject:name1 forKey:@"name1"];
	[_dict setObject:name2 forKey:@"name2"];
	NSArray* allValues = [_dict allValues];
	STAssertTrue([allValues count]==2, @"fail");
	STAssertTrue([allValues objectAtIndex:0]==name1, @"fail");
	STAssertTrue([_dict objectAtIndex:1]==name2, @"fail");
}

- (void)testCountOfArray
{
	// - (unsigned)countOfArray;
	[_dict setObject:@"steve" forKey:@"name"];
	[_dict setObject:@"hooley" forKey:@"name2"];
	STAssertTrue([_dict countOfArray]==2, @"fail");
}

- (void)testObjectInArrayAtIndex
{
	// - (id)objectInArrayAtIndex:(unsigned)theIndex;
	NSString* name1 = @"steve";
	NSString* name2 = @"hooley";
	[_dict setObject:name1 forKey:@"name1"];
	[_dict setObject:name2 forKey:@"name2"];
	STAssertTrue([_dict objectInArrayAtIndex:0]==name1, @"fail");
	STAssertTrue([_dict objectInArrayAtIndex:1]==name2, @"fail");
}

// - (void)testGetArrayrange
// {
	// - (void)getArray:(id *)objsPtr range:(NSRange)range;
// s}

// - (void)testinsertObjectinArrayAtIndex
//{
	// - (void)insertObject:(id)obj inArrayAtIndex:(unsigned)theIndex;
//}

//- (void)testremoveObjectFromArrayAtIndex
//{
	// - (void)removeObjectFromArrayAtIndex:(unsigned)theIndex;
//}

- (void)testreplaceObjectInArrayAtIndexwithObject {
	// - (void)replaceObjectInArrayAtIndex:(unsigned)theIndex withObject:(id)obj
	
	[_dict setObject:@"steve" forKey:@"name"];
	[_dict replaceObjectInArrayAtIndex:0 withObject:@"dave"];
	STAssertTrue([_dict objectAtIndex:0]==@"dave", @"This looks like a dangerous method");
}

- (void)testDict {
	// - (NSMutableDictionary *)dict;

	[_dict setObject:@"steve" forKey:@"name"];
	[_dict setObject:@"hooley" forKey:@"name2"];
	NSMutableDictionary* dict = [_dict dict];
	STAssertTrue([dict count]==2, @"fail");
}

//- (void)testSetDict {
//	// - (void)setDict:(NSMutableDictionary *)value;
//	
//	STAssertThrows([_dict setDict:nil], @"is this right?");
//	STAssertNil([_dict dict], @"eh?");
//}

- (void)testSetArray {
	// - (void)setArray:(NSMutableArray *)value

	[_dict setArray:nil];
	STAssertNil([_dict array], @"eh?");
}

- (void)testKeyForObject {
	// - (NSString *)keyForObject:(id)anObject
	
	NSString *ob1 = @"is in dictionary";
	NSString *ob2 = @"not in dictionary";
	[_dict setObject:ob1 forKey:@"name"];
	STAssertTrue([[_dict keyForObject:ob1] isEqualToString:@"name"], @"fail");
	STAssertNil([_dict keyForObject:ob2], @"fail");
}
@end
