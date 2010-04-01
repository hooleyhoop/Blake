//
//  OCMockRecorder_Extras.m
//  SHShared
//
//  Created by steve hooley on 03/12/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "OCMockRecorder_Extras.h"


@implementation OCMockRecorder (OCMockRecorder_Extras)

- (id)andReturnBOOLValue:(BOOL)aValue {

	BOOL valueWithAdress = aValue;
	return [self andReturnValue:OCMOCK_VALUE(valueWithAdress)];
}

- (id)andReturnUIntValue:(NSUInteger)aValue {
	
	NSUInteger valueWithAdress = aValue;
	return [self andReturnValue:OCMOCK_VALUE(valueWithAdress)];
}

@end
