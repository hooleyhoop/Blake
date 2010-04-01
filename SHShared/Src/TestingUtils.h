/*
 *  TestingUtils.h
 *  SHShared
 *
 *  Created by steve hooley on 09/11/2009.
 *  Copyright 2009 BestBefore Ltd. All rights reserved.
 *
 */

#define MOCK(x) [OCMockObject mockForClass:[x class]]
#define MOCKFORCLASS(x) [OCMockObject mockForClass:x]
#define MOCKFORPROTOCOL(x) [OCMockObject mockForProtocol:@protocol(x)]
