//
//  HitTestContext.m
//  DebugDrawing
//
//  Created by steve hooley on 21/11/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "HitTestContext.h"
#import "ColourUtilities.h"

@implementation HitTestContext

@synthesize keysToHitObjects = _keysToHitObjects;

/* Static, singleton context */
//+ (void)disposeCachedContext {

	//	CGContextRelease(_alphaBitmapCtx);
	//	free(_hitTestPixelBuffer);
	//	_alphaBitmapCtx = nil;
	//	_hitTestPixelBuffer = nil;
//}

+ (CGContextRef)_myArbitrarySizeBitmapContext:(const CGSize)cntxSizes {
	
	const size_t components = 4;
	const size_t bitsPerComponent = 8;
	const size_t bytesPerRow = (cntxSizes.width * bitsPerComponent * components + 7)/8;
	
	// we have to manage the memory so we can iterate thru it
	size_t dataLength = bytesPerRow * cntxSizes.height;
	UInt32 *restrict bitmap = malloc( dataLength );
	memset( bitmap, 0, dataLength );

	CGContextRef context = CGBitmapContextCreate (
										bitmap,
										cntxSizes.width, cntxSizes.height,
										bitsPerComponent,
										bytesPerRow,						// bytes per row
										[ColourUtilities genericRGBSpace],
										kCGImageAlphaPremultipliedFirst		// AAAAAAAARRRRRRRRRGGGGGGGGBBBBBBBB
										);

	//	size_t width = 1;
	//	size_t height = 1;
	//	size_t bitsPerComponent = 8;
	//	size_t bytesPerRow = (width * bitsPerComponent * components + 7)/8;

	//	context = CGBitmapContextCreate(bitmap, width, height, bitsPerComponent, bytesPerRow, NULL/*colorSpace*/, kCGImageAlphaOnly);

	CGContextSetFillColorSpace( context, [ColourUtilities genericRGBSpace]);
	CGContextSetStrokeColorSpace( context, [ColourUtilities genericRGBSpace]);

	return context;
}

/* 1 pixel context is cached */
+ (CGContextRef)_my1x1BitmapContext {

    static CGContextRef context = NULL;
    if( context==NULL ){	
		context = [self _myArbitrarySizeBitmapContext:CGSizeMake(1,1)];
	}
    return context;
}

/* arbitrary size contexts aren't cached */
+ (CGContextRef)_bitmapContextWithSize:(CGSize)cntxSize {
	
	CGContextRef newContext;
	NSUInteger roundedWidth = lrintf(cntxSize.width);
	NSUInteger roundedHeight = lrintf(cntxSize.height);
	if(roundedWidth<1)
		roundedWidth=1;
	if(roundedHeight<1)
		roundedHeight=1;

	if(roundedWidth==1 && roundedHeight==1)
		newContext = [HitTestContext _my1x1BitmapContext];
	else
		newContext = [HitTestContext _myArbitrarySizeBitmapContext:CGSizeMake(roundedWidth, roundedHeight)];
	return newContext;
}

+ (id)hitTestContextWithRect:(CGRect)cntxRect {
	
	CGSize cntxSize = cntxRect.size;
	HitTestContext *cntx = [[[HitTestContext alloc] initWithContextSize: cntxSize] autorelease];
	[cntx setOrigin:cntxRect.origin];
	
	return cntx;
}

+ (id)hitTestContextAtPoint:(CGPoint)hitPt {

	HitTestContext *cntx = [[[HitTestContext alloc] initWithContextSize:CGSizeMake(1, 1)] autorelease];
	[cntx setOrigin:hitPt];

	
#ifdef DEBUG
	// this point should be zero
//	CGAffineTransform currentXform2 = CGContextGetCTM([cntx offScreenCntx]);
//	CGPoint xformedHitPoint = CGPointApplyAffineTransform( CGPointMake(hitPt.x, hitPt.y), currentXform2 );
	
	UInt32 *baseAddr = (UInt32 *) CGBitmapContextGetData ([cntx offScreenCntx]);
	NSAssert(baseAddr!=nil, @"eh");
	
	NSAssert( baseAddr[0]==0, @"hitTest context doesn't seem to have been initialised to Zero correctly!");
//	baseAddr[0] = 0;
	
	CGContextSetRGBFillColor([cntx offScreenCntx], 1.0f, 1.0f, 1.0f, 1.0f);
	CGContextFillRect([cntx offScreenCntx], CGRectMake( hitPt.x, hitPt.y, 1, 1 ));
	UInt32 alpha = baseAddr[0];
	NSAssert(alpha!=0, @"shit - hittesting doesnt work");
	baseAddr[0] = 0;
	alpha = baseAddr[0];
	NSAssert(alpha==0, @"shit - hittesting doesnt work");
#endif

	return cntx;
}

- (id)initWithContextSize:(CGSize)size {

	self = [super init];
	if(self){
		_keysToHitObjects = [[NSMutableArray array] retain];
		_alphaBitmapCtx = [HitTestContext _bitmapContextWithSize:size];
		
#ifdef DEBUG
		UInt32 *baseAddr = (UInt32 *)CGBitmapContextGetData( _alphaBitmapCtx );
		NSAssert(baseAddr!=nil, @"eh");
		
		// -- is it clean? or do we need to clean it each time as we are caching 1 pixel bitmap?
		NSAssert([self contextIsClean], @"new context is somehow dirty");
		
		CGContextSetRGBFillColor(_alphaBitmapCtx, 1.0f, 1.0f, 1.0f, 1.0f);
		CGContextFillRect(_alphaBitmapCtx, CGRectMake(0,0,1,1));

		NSAssert([self contextIsClean]==NO, @"new context is somehow dirty");
		[self cleanContext];
		
		baseAddr[0] = 0;
#endif
	}
	return self;
}

- (void)dealloc {

	NSAssert(_hasBeenCleanedUp, @"Must clean up hit test context");
	
	//!shit, dont free it if it is supposed to be cached
	size_t cW = CGBitmapContextGetWidth(_alphaBitmapCtx);
	size_t cH = CGBitmapContextGetHeight(_alphaBitmapCtx);
	if(cW!=1 || cH!=1){
		UInt32 *baseAddr = (UInt32 *)CGBitmapContextGetData( _alphaBitmapCtx );
		CGContextRelease( _alphaBitmapCtx );
		free(baseAddr);
	}

	[_keysToHitObjects release];
	[super dealloc];
}

- (void)cleanUpHitTesting {
	
	NSAssert(_hasBeenSetup, @"Must have been used before cleaning up");

	CGContextRestoreGState(_alphaBitmapCtx);
	_hasBeenCleanedUp = YES;
}

/* did this node draw into our pixel? */
- (void)checkAndResetWithKey:(id)key {
	
	NSAssert(_alphaBitmapCtx!=nil, @"eh?");

	if([self contextIsClean]==NO)
	{
		NSAssert([_keysToHitObjects containsObject:key]==NO, @"doh! - used the same key twice");
		[_keysToHitObjects addObject:key];
		[self cleanContext];
	}
}

// a crude bounds check before we do the full hit test
- (BOOL)rectIntersectsRect:(const CGRect)rect {
	
	size_t cW = CGBitmapContextGetWidth(_alphaBitmapCtx);
	size_t cH = CGBitmapContextGetHeight(_alphaBitmapCtx);
	
	// NB! I have no idea if this is correct - i am solely relying on thourough testing - keep the tests upto date!
	CGAffineTransform cntxCTM = CGContextGetCTM(_alphaBitmapCtx);
	
	CGRect untransformedContextBounds = CGRectMake(0,0,cW,cH);
	CGRect contextRect = CGRectApplyAffineTransform( untransformedContextBounds, cntxCTM );
	
	return CGRectIntersectsRect( contextRect, rect );
}

- (int)countOfHitObjects {

	return [_keysToHitObjects count];
}

- (BOOL)containsKey:(id)key {
	if([_keysToHitObjects containsObjectIdenticalTo:key])
		return YES;
	return NO;
}

- (CGContextRef)offScreenCntx {

	NSAssert(_alphaBitmapCtx!=nil, @"yikes");
	return _alphaBitmapCtx;
}

- (void)setOrigin:(CGPoint)value {
	
	NSAssert(_hasBeenSetup==NO, @"can't use for more than one positionss");

	// you must pop this off later by calling cleanup
	CGContextSaveGState( _alphaBitmapCtx );

	CGContextTranslateCTM( _alphaBitmapCtx, -value.x, -value.y );
	_hasBeenSetup = YES;
}

- (void)cleanContext {
	
	size_t cW = CGBitmapContextGetWidth(_alphaBitmapCtx);
	size_t cH = CGBitmapContextGetHeight(_alphaBitmapCtx);
	UInt32 * restrict baseAddr = (UInt32 *) CGBitmapContextGetData (_alphaBitmapCtx);
	size_t components = 4;
	size_t bitsPerComponent = 8;
	size_t bytesPerRow = (cW * bitsPerComponent * components + 7)/8;
	size_t dataLength = bytesPerRow * cH;
	memset( baseAddr, 0, dataLength );
}

- (BOOL)contextIsClean {
	
	size_t cW = CGBitmapContextGetWidth(_alphaBitmapCtx);
	size_t cH = CGBitmapContextGetHeight(_alphaBitmapCtx);
	size_t totalPixels = cW*cH;
	
	// valid use of restrict type modifier?
	UInt32 * restrict baseAddr = (UInt32 *)CGBitmapContextGetData(_alphaBitmapCtx);
	NSAssert(baseAddr!=nil, @"eh");
	
	// wrong! just check alpha - argb
	// correct! the UInt32 i contains r, g, b, a bytes
	for( UInt32 i=0; i<totalPixels; i++ )
	{
		if(baseAddr[i]!=0)
			return NO;
	}
	return YES;
}

- (void)getColourAtPixelAndClean:(UInt8 *)cols {
	
	memset( cols, 0, sizeof(unsigned char)*4 );
	NSAssert( CGBitmapContextGetWidth(_alphaBitmapCtx)==1, @"only works with 1 pixel contexts" );
	NSAssert( CGBitmapContextGetHeight(_alphaBitmapCtx)==1, @"only works with 1 pixel contexts" );
	
//	CGColorSpaceRef aaa6 = CGBitmapContextGetColorSpace(_alphaBitmapCtx);
//	CGImageAlphaInfo aaa7 = CGBitmapContextGetAlphaInfo(_alphaBitmapCtx);
//	CGBitmapInfo aaa8 = CGBitmapContextGetBitmapInfo(_alphaBitmapCtx);
//	CGImageRef debugImg = CGBitmapContextCreateImage(_alphaBitmapCtx);
//	
//	NSImage *image = [[NSImage alloc] initWithCGImage:debugImg size:NSZeroSize];
//	[[image TIFFRepresentation] writeToFile:@"/myImage.tif" atomically:YES];
					  
	void *baseAddr = CGBitmapContextGetData(_alphaBitmapCtx);
	NSAssert(baseAddr!=nil, @"eh");

	UInt8 *pixAddress = (UInt8 *)baseAddr;
//	UInt32 *imageData = (UInt32 *)baseAddr;
//	UInt32 tmp = imageData[0];
//	tmp = OSSwapBigToHostConstInt32(tmp); // no effect on PPC, swaps byteorder on Intel

	UInt8 red = pixAddress[1];
	UInt8 green = pixAddress[2];
	UInt8 blue = pixAddress[3];
	UInt8 alpha = pixAddress[0];
	
	cols[0] = red;
	cols[1] = green;
	cols[2] = blue;
	cols[3] = alpha;
	
//	free(baseAddr);
	
	[self cleanContext];
}

@end
