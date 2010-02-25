//
//  Proto_Node.m
//  InterfaceTest
//
//  Created by Steve Hooley on Fri Jul 23 2004.
//  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
//

//#import "SHProto_Node.h"
//#import "SHNodeGraphModel.h"
//#import "SH_Path.h"

@implementation SHProto_NodeOLD


#pragma mark -
#pragma mark class methods
// ===========================================================
// - descriptions:
// ===========================================================
+ (NSMutableArray *) descriptions
{
	// to do
	return nil;
}

#pragma mark init methods




#pragma mark awakeFromNib-like methods
// ===========================================================
// - initGUI:
// ===========================================================
//12/10/2005- (void)initGUI	// called when added to view
//12/10/2005{
	// virtual
//12/10/2005}


#pragma mark action methods		
#pragma mark accessor methods





//=========================================================== 
//  auxiliaryData 
//=========================================================== 
- (NSMutableDictionary *) auxiliaryData { return _auxiliaryData; }
//12/10/2005- (void) setAuxiliaryData: (NSMutableDictionary *) anAuxiliaryData {
//12/10/2005    //NSLog(@"in -setAuxiliaryData:, old value of _auxiliaryData: %@, changed to: %@", _auxiliaryData, anAuxiliaryData);
//12/10/2005    if (_auxiliaryData != anAuxiliaryData) {
//12/10/2005        [anAuxiliaryData retain];
//12/10/2005        [_auxiliaryData release];
//12/10/2005        _auxiliaryData = anAuxiliaryData;
//12/10/2005   }
//12/10/2005}

//- (BOOL) guiNeedsRebuilding{ return _guiNeedsRebuilding;}
//- (void) setGuiNeedsRebuilding:(BOOL) aFlag {
//	_guiNeedsRebuilding = aFlag;
//}

- (id) getAuxObjectForKey:(NSString*)aKey
{
	return [_auxiliaryData objectForKey:aKey];
}

- (void) setAuxObject:(id)anObject forKey:(NSString*)aKey
{
	[_auxiliaryData setObject:anObject forKey:aKey];
}


//=========================================================== 
//  ignore 
//=========================================================== 
- (BOOL)enabled { return _enabled; }
- (void)setEnabled:(BOOL)flag {
    // NSLog(@"SHProto_Node.m: in -setEnabled, old value of _ignore: %@, changed to: %@", (_ignore ? @"YES": @"NO"), (flag ? @"YES": @"NO") );
    _enabled = flag;
}

//=========================================================== 
//  locked 
//=========================================================== 
- (BOOL)locked { return _locked; }
- (void)setLocked:(BOOL)flag {
    NSLog(@"SHProto_Node.m: in -setLocked, old value of _locked: %@, changed to: %@", (_locked ? @"YES": @"NO"), (flag ? @"YES": @"NO") );
	_locked = flag;
}




- (void) setOrderedInputs: (NSMutableArray *) anOrderedInputs {
    //NSLog(@"in -setOrderedInputs:, old value of _orderedInputs: %@, changed to: %@", _orderedInputs, anOrderedInputs);
	
    if (_orderedInputs != anOrderedInputs) {
        [anOrderedInputs retain];
        [_orderedInputs release];
        _orderedInputs = anOrderedInputs;
    }
}


- (void) setOrderedOutputs: (NSMutableArray *) anOrderedOutputs {
    //NSLog(@"in -setOrderedOutputs:, old value of _orderedOutputs: %@, changed to: %@", _orderedOutputs, anOrderedOutputs);
	
    if (_orderedOutputs != anOrderedOutputs) {
        [anOrderedOutputs retain];
        [_orderedOutputs release];
        _orderedOutputs = anOrderedOutputs;
    }
}



- (NSMutableDictionary*) nodesInside_Dict{return _nodesInside_Dict;}
	//- (NSMutableDictionary *) nodesAndConnectletsInside_Dict{return _nodesAndAttributesInside_Dict;}



// ===========================================================
// - objectInChildrenAtIndex:
// ===========================================================
- (id) objectInChildrenAtIndex:(unsigned int)ind {
	// NSLog(@"SHNode.m: objectInChildrenAtIndex %i", index);
	return [_nodesAndAttributesInside objectAtIndex:ind];
}
// end temp

@end
