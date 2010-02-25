//
//  BBNibManager.h
//  QCFileManipulation
//
//  Created by Steven Hooley on 28/06/2007.
//  Copyright 2007 Best Before. All rights reserved.
//

@interface BBNibManager : _ROOT_OBJECT_ {

	NSMutableArray *_topLevelObjects;
}

+ (id)instantiateNib:(NSString *)nibName withOwner:(id)owner;
+ (id)instantiateNib:(NSString *)nibName fromBundle:(NSBundle *)bundle withOwner:(id)owner;

- (id)initWithNibName:(NSString *)nibName withOwner:(id)owner;
- (id)initWithNibName:(NSString *)nibName fromBundle:(NSBundle *)bundle withOwner:(id)owner;

- (NSMutableArray *)topLevelObjects;
- (void)setTopLevelObjects:(NSMutableArray *)value;


@end
