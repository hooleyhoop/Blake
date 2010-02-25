//
//  SHooleyObject.h
//  Pharm
//
//  Created by Steve Hooley on 12/10/2005.
//  Copyright 2005 HooleyHoop. All rights reserved.
//

@interface SHooleyObject : NSObject {

	NSMutableArray			*_recordedSelectorStrings;
	NSMutableDictionary		*_currentObservers;
	
	NSString				*_shInstanceDescription;
}

// #define clearRecordedHits(message,...) BBDetailedLog(BB_LOG_INFO, __LINE__, __FILE__, __PRETTY_FUNCTION__, message, ##__VA_ARGS__)

#pragma mark -
#pragma mark action methods

- (id)initBase;

- (void)clearRecordedHits;
- (void)recordHit:(SEL)aSelector;

- (BOOL)assertRecordsIs:(NSString *)firstString,...; // nil terminated

- (NSMutableArray *)recordedSelectorStrings;

#ifdef DEBUG
- (NSString *)shInstanceDescription;
- (void)setShInstanceDescription:(NSString *)value;
#endif
@end
