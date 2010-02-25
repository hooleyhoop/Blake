//
//  SHNodeGraph.h
//  SHNodeGraph
//
//  Created by Steve Hooley on 22/10/2005.
//  Copyright 2005 HooleyHoop. All rights reserved.
//

#import <SHNodeGraph/SHNodeGraphModel.h>
#import <SHNodeGraph/SHNode.h>
#import <SHNodeGraph/SHInputAttribute.h>
#import <SHNodeGraph/SHOutputAttribute.h>
#import <SHNodeGraph/AllChildrenFilter.h>
#import <SHNodeGraph/SHNodeSelectingMethods.h>
#import <SHNodeGraph/SHConnectableNode.h>

#import <SHNodeGraph/NodeClassFilter.h>
#import <SHNodeGraph/AbtractModelFilter.h>
#import <SHNodeGraph/SHContentProvidorProtocol.h>
#import <SHNodeGraph/NodeProxy.h>

#import <SHNodeGraph/SKTAudio.h>

//!Alert-putback!#import <SHNodeGraph/SH_Path.h>
//!Alert-putback!#import <SHNodeGraph/SHAttribute.h>
//!Alert-putback!#import <SHNodeGraph/SHInterConnector.h>
//!Alert-putback!#import <SHNodeGraph/SHNodePrivateMethods.h>
//!Alert-putback!#import <SHNodeGraph/SHNodeAttributeMethods.h>
#import <SHNodeGraph/SHExecutableNode.h>
//!Alert-putback!#import <SHNodeGraph/SHNodeGraphScheduler.h>
//!Alert-putback!#import <SHNodeGraph/SHLoopTestProxyProtocol.h>
//!Alert-putback!#import <SHNodeGraph/SHCustomMutableArray.h>
//!Alert-putback!#import <SHNodeGraph/SHFScriptNodeGraphLoader.h>
//!Alert-putback!#import <SHNodeGraph/SHConnectlet.h>
//!Alert-putback!#import <SHNodeGraph/SHInlet.h>
//!Alert-putback!#import <SHNodeGraph/SHOutlet.h>
//!Alert-putback!#import <SHNodeGraph/SavingSHProto_Node.h>
//!Alert-putback!#import <SHNodeGraph/SavingSHAttribute.h>
//!Alert-putback!#import <SHNodeGraph/FScriptSaving_protocol.h>
//!Alert-putback!#import <SHNodeGraph/SHChild.h>

// DataTypes
//!Alert-putback!#import <SHNodeGraph/mockDataType.h>
//!Alert-putback!#import <SHNodeGraph/SHNumber.h>
//!Alert-putback!#import <SHNodeGraph/SHMutableBool.h>
//!Alert-putback!#import <SHNodeGraph/SHMutableInt.h>
//!Alert-putback!#import <SHNodeGraph/SHMutableFloat.h>

// Operators
#import <SHNodeGraph/SHAbstractOperator.h>

// math
//!Alert-putback!#import <SHNodeGraph/SHPlusOperator.h>
//!Alert-putback!#import <SHNodeGraph/SHMinusOperator.h>
//!Alert-putback!#import <SHNodeGraph/SHDivideOperator.h>
//!Alert-putback!#import <SHNodeGraph/SHMultiplyOperator.h>
//!Alert-putback!#import <SHNodeGraph/SHAbsOperator.h>
