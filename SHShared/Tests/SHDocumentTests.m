//
//  SHDocumentTests.m
//  SHShared
//
//  Created by steve hooley on 13/08/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "SHDocument.h"

@interface SHDocumentTests : SenTestCase {
	
	SHDocument *_testDoc;
}

@end

@implementation SHDocumentTests

- (void)setUp {
	
	_testDoc = [[SHDocument alloc] init];
}

- (void)tearDown {
	
	[_testDoc release];
}

- (void)testWindowNibName {
//- (NSString *)windowNibName
	
	STAssertEqualObjects( [_testDoc windowNibName], @"SHDocument", @"Stop changing this you fucker. it's useful!");
}

- (void)testDataOfTypeError {
// - (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError

	NSError *err;
	STAssertNil([_testDoc dataOfType:@"any" error:&err], @"should be abstract");
}

- (void)testReadFromDataOfTypeError {
// - (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
	
	NSError *err;
	STAssertTrue([_testDoc readFromData:nil ofType:@"any" error:&err], @"hmm");
}

- (void)testHasWindowControllerOfClass {
// - (BOOL)hasWindowControllerOfClass:(Class)winControllerClass
	
	
}
	
@end
