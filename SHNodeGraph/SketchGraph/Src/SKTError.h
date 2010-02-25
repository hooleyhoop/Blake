/*
	SKTError.h
	Part of the Sketch Sample Code
*/

#import <Cocoa/Cocoa.h>

// Sketch establishes its own error domain, and some errors in that domain.
OBJC_EXPORT NSString *SKTErrorDomain;
enum {
    SKTUnknownFileReadError = 1,
    SKTUnknownPasteboardReadError = 2,
    SKTWriteCouldntMakeTIFFError = 3
};

// Given one of the error codes declared above, return an NSError whose user info is set up to match.
NSError *SKTErrorWithCode(NSInteger code);

/* removed */