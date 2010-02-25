//
//  NodeName.h
//  SHNodeGraph
//
//  Created by steve hooley on 26/02/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//


@class SHChildContainer;


// Immutable !!!!!!!

@interface NodeName : _ROOT_OBJECT_ <NSCoding, NSCopying> {

	@private
		NSString *_value;
}

@property (readonly, nonatomic) NSString *value;

+ (NSUInteger)getNewUniqueID;

+ (id)makeNameWithString:(NSString *)nameStr;

+ (id)makeNameBasedOnClass:(Class)objClass;
+ (NSArray *)uniqueChildNamesBasedOn:(NSArray *)nameStrings forSet:(SHChildContainer *)container;

+ (void)_setNamesOfObjects:(NSArray *)objects toNames:(NSArray *)nodeNames withUndoManager:(NSUndoManager *)um;

+ (NSArray *)stringsFromNodeNames:(NSArray *)nodeNames;
+ (NSArray *)nodeNamesFromStrings:(NSArray *)nodeNames;

+ (NSArray *)currentOrNewNamesForNodes:(NSArray *)objects;

- (BOOL)isEqualToNodeName:(NodeName *)aName;

@end
