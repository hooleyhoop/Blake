//
//  SHNodeRegisterTests.m
//  BlakeLoader2
//
//  Created by steve hooley on 10/12/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "SHNodeRegister.h"

@interface MockOperatorClass : NSObject <SHOperatorProtocol> {
}
@end
@implementation MockOperatorClass
+ (NSString *)pathWhereResides {
	return @"/Maths/special/3d";
}
@end

@interface MockAttributeClass : NSObject <SHAttributeProtocol> {
}
@end
@implementation MockAttributeClass
@end

#pragma mark -
#pragma mark Test Interface
@interface SHNodeRegisterTests : SenTestCase {
	
	SHNodeRegister *_nodeRegister;
}

@end

#pragma mark Test Implementation
@implementation SHNodeRegisterTests

- (void)setUp {
	
}

- (void)tearDown {
	
}

- (void)testStuff {
	// - (void)registerOperatorClasses:(NSArray *)classes;
	// - (BOOL)registerOperatorClass:(Class)aClass;

//	[_nodeRegister registerOperatorClass:[MockOperatorClass class]];
	
//	[_nodeRegister registerOperatorClass:[MockAttributeClass class]];

}

@end
