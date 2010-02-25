//
//  SHNodeGraphModel_sketchAmmends.h
//  SHNodeGraph
//
//  Created by steve hooley on 02/09/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SHNodeGraph/SHNodeGraphModel.h>
#import <SHShared/SHOrderedDictionary.h>
#import <SHNodeGraph/SHContentProvidorProtocol.h>

@interface SHNodeGraphModel (SHNodeGraphModel_sketchAmmends)

- (void)insertGraphic:(SHNode *)graphic atIndex:(NSUInteger)index DEPRECATED_ATTRIBUTE;   
//june09- (void)removeGraphicAtIndex:(NSUInteger)index DEPRECATED_ATTRIBUTE;

- (void)setIndexOfChild:(id)child to:(int)i DEPRECATED_ATTRIBUTE;

//june09- (void)removeGraphicsAtIndexes:(NSIndexSet *)indexes DEPRECATED_ATTRIBUTE;

- (BOOL)isSelected:(id)value DEPRECATED_ATTRIBUTE;

- (void)setSelectedObjects:(NSArray *)value DEPRECATED_ATTRIBUTE;
- (NSArray *)selectedObjects DEPRECATED_ATTRIBUTE;

- (void)setSelectionIndexes:(NSMutableIndexSet *)value DEPRECATED_ATTRIBUTE;

- (SHOrderedDictionary *)graphics DEPRECATED_ATTRIBUTE;
- (NSMutableIndexSet *)selectionIndexes DEPRECATED_ATTRIBUTE;

@end
