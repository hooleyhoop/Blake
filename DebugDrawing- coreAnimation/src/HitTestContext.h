//
//  HitTestContext.h
//  DebugDrawing
//
//  Created by steve hooley on 21/11/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

@interface HitTestContext : _ROOT_OBJECT_ {

	CGContextRef		_alphaBitmapCtx;
	NSMutableArray		*_keysToHitObjects;
	BOOL				_hasBeenSetup, _hasBeenCleanedUp;
}

@property (retain) NSMutableArray *keysToHitObjects;

+ (id)hitTestContextWithRect:(CGRect)cntxRect;
+ (id)hitTestContextAtPoint:(CGPoint)hitPt;

- (id)initWithContextSize:(CGSize)size;

- (void)cleanUpHitTesting;

/* Immediately after drawing call this with you desired key. If the object was drawn into the hit text context the key will be pushed onto the hit stack */
- (void)checkAndResetWithKey:(id)key;
- (BOOL)rectIntersectsRect:(const CGRect)rect;

- (int)countOfHitObjects;
- (BOOL)containsKey:(id)key;

- (CGContextRef)offScreenCntx;

- (void)setOrigin:(CGPoint)value;

- (void)cleanContext;
- (BOOL)contextIsClean;

- (void)getColourAtPixelAndClean:(UInt8 *)cols;

@end
