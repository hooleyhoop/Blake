//
//  SHPathTests.m
//  SHNodeGraph
//
//  Created by Steve Hooley on 09/05/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import "SH_Path.h"


@interface SHPathTests : SenTestCase {
}
@end


@implementation SHPathTests

- (void)setUp {
}

- (void)tearDown {
}

- (void)testRootPath {
	// + (SH_Path *)rootPath
	
	SH_Path *rootPath = [SH_Path rootPath];
	STAssertNotNil(rootPath, @"eh?");
	STAssertTrue([[rootPath pathComponents] count]==1, @"oh");
	STAssertEqualObjects([rootPath pathAsString], @"/", @"oh");
}

- (void)testDescription {

	SH_Path *rootPath = [SH_Path rootPath];
	NSString *description = [rootPath description];
	NSString *template = [NSString stringWithFormat:@"<SH_Path: %p> : /",rootPath];
	STAssertTrue([description isEqualToString:template], @"%@--%@--", template,description);
}

- (void)testAppend {
	// - (SH_Path *)append:(NSString *)pathComponent

	SH_Path* p1 = [SH_Path pathWithString:@"/aa/bb/cc"];
	SH_Path* p2 = [p1 append:@"dd"];
	
	STAssertTrue([[p2 pathAsString] isEqualToString:@"/aa/bb/cc/dd"]==YES, @"path append ERROR is %@", [p2 pathAsString] );
	
	p2 = [p1 append:@"/dd"];
	STAssertTrue([[p2 pathAsString] isEqualToString:@"/aa/bb/cc/dd"]==YES, @"path append ERROR is %@", [p2 pathAsString] );
}

- (void)testInsertPathComponentBeforeLast {
// - (SH_Path *)insertPathComponentBeforeLast:(SH_Path *)newBit;

	SH_Path *p1 = [SH_Path pathWithString:@"/aa/bb/cc/dd"];
	SH_Path *p2 = [SH_Path pathWithString:@"/monkey"];
	SH_Path *newPath = [p1 insertPathComponentBeforeLast:p2];
	NSString * desiredResult = @"/aa/bb/cc/monkey/dd";
	STAssertTrue([[newPath pathAsString] isEqualToString:desiredResult], @"path insertion failed %@ %@", [newPath pathAsString], desiredResult);
}

- (void)testRemovePathComponentBeforeLast {
// - (SH_Path *)removePathComponentBeforeLast:(SH_Path *)newBit

	SH_Path *p1 = [SH_Path pathWithString:@"/aa/bb/cc/monkey/dd"];
	SH_Path *p2 = [SH_Path pathWithString:@"monkey"];
	
	SH_Path *newPath = [p1 removePathComponentBeforeLast:p2];
	NSString * desiredResult = @"/aa/bb/cc/dd";
	STAssertTrue([[newPath pathAsString] isEqualToString:desiredResult], @"path insertion failed %@ %@", [newPath pathAsString], desiredResult);
	
	STAssertThrows([newPath removePathComponentBeforeLast:p2], @"Doesnt contain that path");
}

- (void)testIsEquivalentTo {
// - (BOOL)isEquivalentTo:(id)anObject;
	
	SH_Path* p1 = [SH_Path pathWithString:@"/aa/bb/cc"];
	SH_Path* p2 = [SH_Path pathWithString:@"/aa/bb"];
	BOOL isEquiv = [p1 isEquivalentTo:p2];
	STAssertFalse(isEquiv, @"How can these 2 different paths be equivalent?");
	
	p2 = [p2 append:@"cc"];
	isEquiv = [p1 isEquivalentTo:p2];
	STAssertTrue(isEquiv, @"Surely now they are the same? %@, %@", [p1 pathAsString], [p2 pathAsString]);
	
	STAssertFalse([p1 isEquivalentTo:self], @"How can these 2 different paths be equivalent?");
}

@end
