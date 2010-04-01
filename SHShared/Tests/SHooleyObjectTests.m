//
//  SHooleyObjectTests.m
//  SHShared
//
//  Created by steve hooley on 28/04/2008.
//  Copyright 2008 bestbefore. All rights reserved.
//


@class SHooleyObject;
@interface SHooleyObjectTests : SenTestCase {
	
    NSAutoreleasePool *_pool;
	SHooleyObject *hooOb;
}

@end


/*
 * We need these to test the method recording
 */
@interface SHooleyObject (testingMethods)

- (void)testMethod1;
- (void)testMethod2;
- (void)testMethod3;

@end

@implementation SHooleyObject (testingMethods)

- (void)testMethod1 {
	
	[self recordHit:_cmd];
}

- (void)testMethod2 {
	
	[self recordHit:_cmd];
}

- (void)testMethod3 {
	

	[self recordHit:_cmd];
	[self testMethod1];
	[self testMethod2];
}

@end

/*
 *
*/
@implementation SHooleyObjectTests

- (void)setUp {
	
    _pool = [[NSAutoreleasePool alloc] init];
	hooOb = [[SHooleyObject alloc] init];
}

- (void)tearDown {
	
	[hooOb release];
    [_pool drain];
}

- (void)testClassAsString {
	//+ (NSString *)classAsString
	//- (NSString *)classAsString
	STAssertTrue([[SHooleyObject classAsString] isEqualToString:@"SHooleyObject"], @"no");
	STAssertTrue([[hooOb classAsString] isEqualToString:@"SHooleyObject"], @"no");
}

- (void)testValueForUndefinedKey{
	//- (id)valueForUndefinedKey:(NSString *)key
	STAssertThrows([hooOb valueForUndefinedKey:@"chickychickchick"], @"doh");
}

- (void)testClearRecordedHits {
// - (void)clearRecordedHits

	[hooOb testMethod1];
	[hooOb testMethod2];
	[hooOb clearRecordedHits];
	NSMutableArray *recordedStrings = [hooOb recordedSelectorStrings];
	STAssertTrue([recordedStrings count]==0, @"failed to clear record");
}

- (void)testRecordHit {
// - (void)recordHit:(SEL)aSelector

	[hooOb testMethod1];
	[hooOb testMethod2];
	NSMutableArray *recordedStrings = [hooOb recordedSelectorStrings];
	STAssertTrue([recordedStrings count]==2, @"failed to record");
	STAssertTrue([[recordedStrings objectAtIndex:0] isEqualToString:@"testMethod1"], @"failed to record %@", [recordedStrings objectAtIndex:0]);
	STAssertTrue([[recordedStrings objectAtIndex:1] isEqualToString:@"testMethod2"], @"failed to record %@", [recordedStrings objectAtIndex:1]);
}

- (void)testAssertRecordsIs {
// - (BOOL)assertRecordsIs:

	[hooOb testMethod3];
	BOOL result1 = [hooOb assertRecordsIs:@"testMethod3", @"testMethod2", @"testMethod3", nil];
	STAssertFalse(result1, @"That isnt what happened! %@", [hooOb recordedSelectorStrings]);
	
	BOOL result2 = [hooOb assertRecordsIs:@"testMethod3", @"testMethod1", @"testMethod2", nil];
	STAssertTrue(result2, @"That is what happened %@", [hooOb recordedSelectorStrings]);
	
	BOOL result3 = [hooOb assertRecordsIs:@"testMethod3", @"testMethod1", nil, nil];
	STAssertFalse(result3, @"That isnt what happened! %@", [hooOb recordedSelectorStrings]);
	
	BOOL result4 = [hooOb assertRecordsIs:@"testMethod3", @"testMethod1", @"testMethod2", @"non-existent method", nil];
	STAssertFalse(result4, @"That isnt what happened! %@", [hooOb recordedSelectorStrings]);
}

- (void)testInstanceCount {
    
    SHooleyObject *anOb = [[SHooleyObject alloc] init];
    STAssertTrue( [SHInstanceCounter indexOf:anOb]!=NSNotFound , @"should contain this");
    [anOb release];
}
//
//- (void)testEncodeWithCoder {
//	//- (void)encodeWithCoder:(NSCoder *)coder
//	//- (id)initWithCoder:(NSCoder *)coder
//
//	NSData *archive = [NSKeyedArchiver archivedDataWithRootObject:hooOb];
//	STAssertNotNil(archive, @"ooch");
//	
//	SHooleyObject *child2 = [NSKeyedUnarchiver unarchiveObjectWithData:archive];
//	STAssertNotNil(child2, @"ooch");
//}

- (void)testAddObserver {
	//- (void)addObserver:(NSObject *)anObserver forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
	//- (void)removeObserver:(NSObject *)anObserver forKeyPath:(NSString *)keyPath
	
	[hooOb addObserver:self forKeyPath:@"shInstanceDescription" options:0 context:nil];
	STAssertThrows([hooOb addObserver:self forKeyPath:@"shInstanceDescription" options:0 context:nil], @"cant add twice");
	[hooOb removeObserver:self forKeyPath:@"shInstanceDescription"];
	STAssertThrows([hooOb removeObserver:self forKeyPath:@"shInstanceDescription"], @"cant remove twice");
	
	SHooleyObject *hooOb2 = [[SHooleyObject alloc] init];
	[hooOb2 addObserver:self forKeyPath:@"shInstanceDescription" options:0 context:nil];	
	STAssertThrows([hooOb2 release], @"doh");
}

static BOOL wasCalled;
- (void)_performSelectorCallback {
	wasCalled = YES;
}
- (void)testPerformSelector {
	[self performSelector:@selector(_performSelectorCallback)];
	STAssertTrue(wasCalled,@"help my world has collapsed");
}

@end
