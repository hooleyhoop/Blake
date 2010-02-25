//
//  SHConnectletTEsts.m
//  SHNodeGraph
//
//  Created by Steve Hooley on 30/05/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//
#import "SHProtoAttribute.h"
#import "SHConnectlet.h"
#import "SHInlet.h"
#import "SHOutlet.h"
#import "SHInterConnector.h"

/*
 *
 */
@interface SHConnectletTests : SenTestCase {
	
	OCMockObject *_mockAtt;
	SHConnectlet *_testConnectlet;
}
@end


/*
 *
*/
@implementation SHConnectletTests

- (void)setUp {

	_mockAtt = [MOCK(SHProtoAttribute) retain];
	_testConnectlet = [[SHConnectlet alloc] initWithAttribute:(id)_mockAtt];
}

- (void)tearDown {

	[_testConnectlet release];
	[_mockAtt release];
}

- (void)testCopyWithZone {
	// - (id)copyWithZone:(NSZone *)zone
}

- (void)testEncodeWithCoder {
	// - (void)encodeWithCoder:(NSCoder *)coder
		
//	NSData *archive = [NSKeyedArchiver archivedDataWithRootObject:_testConnectlet];
//	STAssertNotNil(archive, @"ooch");
//	
//	SHConnectlet *con2 = [NSKeyedUnarchiver unarchiveObjectWithData:archive];
//	STAssertNotNil(con2, @"ooch");
//	
//	STAssertTrue([_testConnectlet isEquivalentTo: con2], @"should be roughly the same");
//	STAssertFalse(_testConnectlet==con2, @"christ");
}
	
- (void)testAddAnSHInterConnector {
	//- (BOOL)addAnSHInterConnector:(SHInterConnector *)anSHInterConnector
	
	SHInlet* inC = [[[SHInlet alloc] initWithAttribute:nil] autorelease];
	SHOutlet* outC = [[[SHOutlet alloc] initWithAttribute:nil] autorelease];
	SHInterConnector* testI = [[[SHInterConnector alloc] init] autorelease];
	SHInterConnector* testI2 = [[[SHInterConnector alloc] init] autorelease];
	BOOL f1 = [inC addAnSHInterConnector:testI];
	BOOL f2 = [outC addAnSHInterConnector:testI];
	STAssertTrue(f1==YES, @"Adding interconnector to connectlet failed");
	STAssertTrue(f2==YES, @"Adding interconnector to connectlet failed");
	STAssertThrows([inC addAnSHInterConnector:testI2], @"inlets cant have multiple connections");
	BOOL f3 = [outC addAnSHInterConnector:testI2];
	STAssertTrue(f3==YES, @"Adding interconnector to connectlet failed");

	int ii = [outC numberOfConnections];
	STAssertTrue(ii==2, @"Adding interconnector to connectlet failed");
}


- (void)testRemoveAnSHInterConnector {
	//- (BOOL)removeAnSHInterConnector:(SHInterConnector *)anSHInterConnector

	SHOutlet* outC = [[[SHOutlet alloc] initWithAttribute:nil] autorelease];
	SHInterConnector* testI = [[[SHInterConnector alloc] init] autorelease];
	BOOL f1 = [outC addAnSHInterConnector:testI];
	STAssertTrue(f1, @"eh");

	SHInterConnector* testI2 = [[[SHInterConnector alloc] init] autorelease];
	BOOL f3 = [outC addAnSHInterConnector:testI2];
	STAssertTrue(f3, @"eh");

	[outC removeAnSHInterConnector:testI2];
	int ii = [outC numberOfConnections];
	STAssertTrue(ii==1, @"Removing interconnector to connectlet failed");
	[outC removeAnSHInterConnector:testI];
	ii = [outC numberOfConnections];
	STAssertTrue(ii==0, @"Removing interconnector to connectlet failed");
}


@end
