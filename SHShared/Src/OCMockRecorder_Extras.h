//
//  OCMockRecorder_Extras.h
//  SHShared
//
//  Created by steve hooley on 03/12/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//
#import <OCMock/OCMockRecorder.h>
@interface OCMockRecorder (OCMockRecorder_Extras)

- (id)andReturnBOOLValue:(BOOL)aValue;
- (id)andReturnUIntValue:(NSUInteger)aValue;

@end
