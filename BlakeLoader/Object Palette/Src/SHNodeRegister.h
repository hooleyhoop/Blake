//
//  SHNodeRegister.h
//  InterfaceTest
//
//  Created by Steve Hooley on 24/10/2004.
//  Copyright 2004 HooleyHoop. All rights reserved.
//

@interface SHNodeRegister : _ROOT_OBJECT_ {

	NSMutableDictionary	*_allNodeGroups;
}

@property (retain, nonatomic) NSMutableDictionary *allNodeGroups;

#pragma mark class methods
+ (SHNodeRegister *)sharedNodeRegister;
+ (void)cleanUpSharedNodeRegister;

+ (void)scanAllClasses; // takes 1.5 secs on my g5

#pragma mark action methods
- (void)registerOperatorClasses:(NSArray *)classes;
- (void)registerOperatorClass:(Class)aClass;

- (Class)lookupNode:(NSString *) aNodeType inGroup:(NSString *)aNodeGroup;
- (Class)lookupNode:(NSString *) aNodeType inGroup:(NSString *)aNodeGroup1 inGroup:(NSString *)aNodeGroup2;

@end