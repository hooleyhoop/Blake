//
//  SHProtoAttribute.m
//  SHNodeGraph
//
//  Created by Steven Hooley on 2/25/09.
//  Copyright 2009 Bestbefore. All rights reserved.
//

#import "SHProtoAttribute.h"
#import "SHInterConnector.h"
#import "SHInlet.h"
#import "SHOutlet.h"
#import "SHProtoInputAttribute.h"

@implementation SHProtoAttribute

@synthesize theOutlet=_theOutlet, theInlet=_theInlet;

#pragma mark -
#pragma mark class methods
+ (id)attributeWithType:(NSString *)aDataTypeName {
	
	id attr = [[[self alloc] init] autorelease];
	[attr setDataType:aDataTypeName];
	return attr;
}

#pragma mark init methods
/* These bits aren't copied */
- (id)initBase {
	self=[super initBase];
	if(self){
		_dirtyBit = NO;
		_isInletConnected=NO; _isOutletConnected=NO;
		_dirtyRecursionID = -1;
	}
	return self;
}

/* Just init the bits that we dont need in a copy (ie copy will provide these items we dont need init-ed versions of them) */
- (id)init {
	self=[super init];
	if(self){
		_theInlet = [[SHInlet alloc] initWithAttribute:self];
		_theOutlet = [[SHOutlet alloc] initWithAttribute:self];
		_selectorToUse = NSSelectorFromString( @"value" );
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)coder {
	
    self = [super initWithCoder:coder];
	if(self){
		_selectorToUse = NSSelectorFromString([coder decodeObjectForKey:@"selectorToUse"]);
		_dataClass = NSClassFromString([coder decodeObjectForKey:@"dataClass"]);
		_theInlet = [[coder decodeObjectForKey:@"theInlet"] retain];
		_theOutlet = [[coder decodeObjectForKey:@"theOutlet"] retain];
		_value = [[coder decodeObjectForKey:@"value"] retain];
	}
    return self;
}

- (void)dealloc {
	
    [_theOutlet release];
    [_theInlet release];
	[_value release];
	[super dealloc];
}

#pragma mark NSCopyopying, hash, isEqual
- (void)encodeWithCoder:(NSCoder *)coder {
	
	[super encodeWithCoder:coder];
	[coder encodeObject:NSStringFromSelector(_selectorToUse) forKey:@"selectorToUse"];
	[coder encodeObject:NSStringFromClass(_dataClass) forKey:@"dataClass"];
	[coder encodeObject:_theInlet forKey:@"theInlet"];
	[coder encodeObject:_theOutlet forKey:@"theOutlet"];
	[coder encodeObject:_value forKey:@"value"];

	/* we dont need to copy these as all connections are remade on copy */
	// [coder encodeBool:_isInletConnected forKey:@"isInletConnected"];
	// [coder encodeBool:_isOutletConnected forKey:@"isOutletConnected"];
	
	/* not encoding */
	// BOOL _dirtyBit;
	// NSInteger _dirtyRecursionID;
}

- (id)copyWithZone:(NSZone *)zone {
	
	SHProtoAttribute *copy = [super copyWithZone:zone];
	
	// we dont copy the connected state
	copy->_theInlet = [[SHInlet alloc] initWithAttribute:copy];
	copy->_theOutlet = [[SHOutlet alloc] initWithAttribute:copy];
	
	// we do want to copy the value and value-type
	copy->_selectorToUse = _selectorToUse;
	
//TODO: only want to copy the val if not connected.. and not NodeIAffect thingy
	id duplicateVal = [[_value copyWithZone:zone] autorelease];

	[copy setDataType:NSStringFromClass(_dataClass) withValue:duplicateVal];
	
	// we wont need to copy these as will will be reconnected by parent during copy operation
	// _isInletConnected? _isOutletConnected?

	return copy;
}

- (BOOL)isEquivalentTo:(id)anObject {

	NSParameterAssert(anObject);

//TODO: - maybe only test value if input isn't connected
//TODO: - test number of outputs but do we care about value? surely if inputs are the same value is predetermined?
//TODO: - must also take account of the nodesIAffect thing
	if([super isEquivalentTo:anObject]==NO)
		return NO;
	id value1 = _value;
	id value2 = [anObject value];
	if(value1==nil && value2==nil)
		return YES;
	if( [value1 isEquivalentToValue: value2])
		return YES;
	return NO;
}

//// called on an out attribute sending an in attribute
- (BOOL)connectOutletToInletOf:(SHProtoAttribute *)inAttr withConnector:(SHInterConnector *)aConnector {
	
	NSParameterAssert(inAttr!=nil);
	NSParameterAssert(aConnector!=nil);
	NSParameterAssert([aConnector respondsToSelector:@selector(resetNodeSHConnectlets)]);
	
	if(inAttr==self)
		return NO;

	SHInlet *in_con = [inAttr theInlet]; 
	SHOutlet *out_con = [self theOutlet];
	
	// we need to check that there isnt an equivalent connection!!
	NSArray *allInterConnectors = [out_con shInterConnectors];
	for( SHInterConnector *aInterConnector in allInterConnectors )
	{
		SHConnectlet* con1 = (SHConnectlet *)[aInterConnector inSHConnectlet];
		SHConnectlet* con2 = (SHConnectlet *)[aInterConnector outSHConnectlet];
		
		// Erase one of these when we know which one we want
		if(((SHConnectlet *)out_con==con2)&&((SHConnectlet *)in_con==con1))
		{
			// logInfo(@"SHNodeGroup.m: ERROR V1 SHNodePrivateMethods");						
			logWarning(@"SHNodeGroup.m: ERROR: Not connecting because that connection already exists");
			return NO;
		}
	}
	
	// we need to check whether one of the attributes is actually an attribute node.
	// if it is we use the other kind of connectlet (attributeLink not AttributeConnnectlet)
	//	if(outFlag){
	//		out_con = (SHConnectlet *)[self outputAttributeAtIndex:0];
	//	} else {
	//		out_con = [self theConnectlet];
	//	}
	//	if(inFlag){
	//		in_con = (SHConnectlet *)[inAttr inputAttributeAtIndex:0];
	//	} else {
	//		in_con = [inAttr theConnectlet];
	//	}
	//	NSAssert(inAttr != nil, @"SHProtoAttribute.m: inAttr is nil");
	//	NSAssert(_value != nil, @"SHProtoAttribute.m: _value is nil");
	//	NSAssert(_value != nil, @"SHProtoAttribute.m: _value is nil");
	//	NSAssert(in_con != nil, @"SHProtoAttribute.m: in_con is nil");
	//	NSAssert(out_con != nil, @"SHProtoAttribute.m: out_con is nil");
	
	//	logInfo(@"SHProtoAttribute r class is %@",[inAttr class] );
	//	logInfo(@"SHOutputAttribute.m: outAttr class is %@",[self class] );
	BOOL selectorFound=NO;
	NSString* selectorWeWillUse = [(SHProtoInputAttribute *)inAttr willAsk];
	// dataclass might be null for tests.. go ahead anyway
	if(selectorWeWillUse!=nil)
		selectorFound = [self setSelectorToUseWhenAnswering:selectorWeWillUse];
	
	if( selectorWeWillUse==nil || (selectorWeWillUse!=nil && selectorFound))
	{	
		BOOL result1 = [in_con addAnSHInterConnector:aConnector];
		if(!result1)
			return NO;
		BOOL result2 = [out_con addAnSHInterConnector:aConnector];
		if(!result2){
			
//TODO: Test This
			/* we need to clean up - just connected in_con */
			[in_con removeAnSHInterConnector:aConnector];
			return NO;
		}
		/* make the connection */		
		aConnector.outSHConnectlet = out_con;
		aConnector.inSHConnectlet = in_con;
		
		//	NSAssert([inAttr isKindOfClass:[SHProtoAttribute class]], @"wrong");
		//	NSAssert([self isKindOfClass:[SHOutlet class]], @"wrong");
		
		// -- has this connection created a feedback loop?
		// if([inAttr isInFeedbackLoop]==NO){
		// -- if not make the input now dirty
		[inAttr setDirtyBit:YES uid:999];
		[inAttr setDirtyBelow:random()];
		
		// } else {
		//	[in_con setDirtyBit:NO uid:999];
		//}
		return YES;
	} else {
		
		// these two wont talk to each other!
		logWarning(@"SHProtoAttribute.m: THESE 2 Wont talk" );
	}
//TODO: Test This
	return NO;
}

- (BOOL)removeInterConnector:(SHInterConnector *)aConnector {
	
	NSParameterAssert(aConnector);

	SHInlet *in_con = [self theInlet]; 
	SHOutlet *out_con = [self theOutlet];
	BOOL found;// = NO;
	found = NO;
	// locate the interconnector
	NSArray *allInterConnectors = [out_con shInterConnectors];
	NSEnumerator *enumerator = [allInterConnectors objectEnumerator];
	SHInterConnector* aInterConnector;
	while ((aInterConnector=[enumerator nextObject]) && (found==NO)){
		if(aConnector==aInterConnector){
			found = YES;
		}
	}
	if(found==NO){
		allInterConnectors = [in_con shInterConnectors];
		enumerator = [allInterConnectors objectEnumerator];
		while ((aInterConnector = [enumerator nextObject]) && (found==NO)){
			if(aConnector==aInterConnector){
				found = YES;
			}
		}
	}
	// delete it
	if( YES==found )
	{
		// the inlet data needs to be a copy of the outlet data at the time of deletion
		SHConnectlet* inConnectlet = (SHConnectlet *)[aConnector inSHConnectlet];
		SHConnectlet* outConnectlet = (SHConnectlet *)[aConnector outSHConnectlet];		
		SHProtoAttribute* inA = [inConnectlet parentAttribute];
		SHProtoAttribute* outA = [outConnectlet parentAttribute];
		id valToCopy = [outA value];
		id duplicate = [[valToCopy copy] autorelease];
		[aConnector resetNodeSHConnectlets];
		
		NSAssert1([inConnectlet numberOfConnections]==0, @"what? surely we can only have one incoming connection? %i", [inConnectlet numberOfConnections]);
		[inA setIsInletConnected:NO];
		
		//-- however we can legitimatally have many outgoing connections
		if([outConnectlet numberOfConnections]==0)
			[outA setIsOutletConnected:NO];
		
		// replace the value in the input
		[inA setValue:duplicate];
		return YES;
	}
	return NO;
}

- (BOOL)isInletConnected { 
	
	int numberOfCons = [_theInlet numberOfConnections];
	BOOL haveConnections = numberOfCons > 0;
	
	/* hmm, an output att can be 'affected by', in which case _isInletConnected wold be yes even tho numberOfConnections is zero */
	NSAssert(haveConnections==_isInletConnected, @"out of sync");
	/* In that case this assert SHOULD fail */
	
	return _isInletConnected; 
	
}

- (void)setIsInletConnected:(BOOL)flag {
	
	// logInfo(@"in -setIsConnectedFlag, old value of _isInletConnected: %@, changed to: %@", (_isInletConnected ? @"YES": @"NO"), (flag ? @"YES": @"NO") );
    _isInletConnected = flag;
	//	if(flag)
	//		_inletState = SHAttributeState_Connected;
	//	else
	//		_inletState = SHAttributeState_Normal;
}

- (BOOL)isOutletConnected { 
	
	int numberOfCons = [_theOutlet numberOfConnections];
	BOOL haveConnections = numberOfCons > 0;
	NSAssert(haveConnections==_isOutletConnected, @"out of sync");
	return _isOutletConnected; 
}

- (void)setIsOutletConnected:(BOOL)flag {
	
	// logInfo(@"in -setIsConnectedFlag, old value of _isInletConnected: %@, changed to: %@", (_isInletConnected ? @"YES": @"NO"), (flag ? @"YES": @"NO") );
    _isOutletConnected = flag;
	//	if(flag)
	//		_outletState = SHAttributeState_Connected;
	//	else
	//		_outletState = SHAttributeState_Normal;
}

- (NSString*)willAsk {
	
	//	NSAssert(_value != nil, @"SHProtoAttribute.m: _value is nil");
	//	logInfo(@"SHInputAttribute.m: _value is %@",[_value class] );
	if( [_dataClass respondsToSelector:@selector(willAsk)] )
		return [(id)_dataClass willAsk];
	else if(_dataClass!=nil ){
//TODO: Test This
		logError(@"SHProtoAttribute.m: _value is DOESNT RESPOND TO THAT YOU DORK!");
	}
	return nil;
}

- (void)setDirtyBit:(BOOL)flag uid:(int)uid {
	
	if(uid!=_dirtyRecursionID) // test to see if we are in a setDirtyBelowLoop
		_dirtyBit = flag;
}

/*
 *
 * any data type will only ever ask a connected datatype for one type of data (string, number, etc.)
 * however, a single data type might respond to more than one request (string and number, etc.)
 *
 */
- (BOOL)setSelectorToUseWhenAnswering:(NSString *)aSelectorName
{
	SEL method = NSSelectorFromString(aSelectorName);
	if( [_value respondsToSelector:method] )
	{
		_selectorToUse = method;
		return YES;
	} else {
//TODO: Test This
		logError(@"SHProtoAttribute.m: ERROR setting selector to use in attribute. %@ doesnt respond to '%@'",  NSStringFromClass([_value class]), aSelectorName);
	}
	return NO;
}

//// VIRTUAL
- (void)setDirtyBelow:(int)uid
{
	// RIGHT
	// All the nodes in the tree below must be marked as dirty, just because you
	// get to a dirty section, doesnt mean there couldnt be a clean bit below that..
	//	logInfo(@"SHOutputAttribute.m: setDirtyBelow %@", _name);
	
	//09/05/2006 	// WRONG!
	//09/05/2006 	// i think it is a fact that if we are traversing the tree below and
	//09/05/2006 	// we reach a node that is already marked as dirty, 
	//09/05/2006 	// then.. we can can stop traversing as it would be impossible
	//09/05/2006 	// for there to be any clean nodes further down
	//09/05/2006 	
	//09/05/2006 	// RIGHT
	//09/05/2006 	// All the nodes in the tree below must be marked as dirty, just because you
	//09/05/2006 	// get to a dirty section, doesnt mean there couldnt be a clean bit below that..
	//09/05/2006 	
 	// traverse, mark as dirty
	
	SHProtoAttribute* inAtt=nil;
	SHConnectlet* outConnectlet=nil;
	for( SHInterConnector *connector in [_theOutlet shInterConnectors] )
	{		
		outConnectlet = (SHConnectlet *)[connector inSHConnectlet];
		NSAssert(outConnectlet!=(SHConnectlet *)_theOutlet, @"SHOutputAttribute.m: ERROR. looks like we are getting the wrong inlet from the interconnector");
		// here! do we need parentAttribute or hostNode?
		inAtt = [outConnectlet parentAttribute];
		[inAtt setDirtyBit:YES uid:uid];
		[inAtt setDirtyBelow:uid];
	}
}

- (NSObject<SHValueProtocol> *)value {
	return _value;
}

- (void)setValue:(NSObject<SHValueProtocol> *)a_value {
	
    if(_value!=a_value) {
		//		[self setPreviousValue: _value];
		
        [_value release];
        _value = [a_value retain];
		//		NSString* debugObject = [_value displayObject];
		// everything connected below this point is now dirty..
		_dirtyBit = NO;
		[self setDirtyBelow:random()];
	}
}

- (NSMutableArray *)allConnectedInterConnectors {
	
	NSMutableArray* allInterConnectors = [NSMutableArray array];
	SHConnectlet* theConnectlet = (SHConnectlet *)[self theInlet];
	[allInterConnectors addObjectsFromArray: [theConnectlet shInterConnectors]];			
	theConnectlet = (SHConnectlet *)[self theOutlet];
	[allInterConnectors addObjectsFromArray: [theConnectlet shInterConnectors]];
	return allInterConnectors;
}

- (void)setDataType:(NSString *)aClassName {
	[self setDataType:aClassName withValue:nil];
}

//TODO: Test This
- (void)setDataType:(NSString *)aClassName withValue:(id)arg 
{
	// make an object of type 'kind'
	_dataClass = NSClassFromString( aClassName );
	// logInfo(@"SHAttribute.m: setDataType !!! name %@ class %@", aClassName, dataClass );
	// NSAssert(dataClass != nil, @"SHAttribute.m: dataClass is nil");
	if(_dataClass!=nil) 
	{
		if(_dataClass!=[_value class])
		{
			//	[self setValue:	nil];
			
			@try {
				//15/02/2006	id newVal = (id)[[[dataClass alloc] initWithParent:self] autorelease];
				id newVal;
				if(_dataClass==[arg class])
					newVal = arg;
				else
					newVal = (id)[[[_dataClass alloc] initWithObject:arg] autorelease];
				
				//	logInfo(@"SHAttribute.m: Setting datatype %@", newVal );
				//	logInfo(@"SHAttribute.m: Setting datatype %@", [_value class]);
				//	logInfo(@"SHAttribute.m: Setting datatype %@", [[_value class] willAnswer]);
				//	logInfo(@"SHAttribute.m: about to set SEL to use when answering %@", [[[_value class] willAnswer] objectAtIndex:0]);
                [self setValue:	newVal];
				
                id willAnswerArray = [[_value class] willAnswer];
                if([willAnswerArray count]>0)
                {
                    NSString* selectorToUse = [willAnswerArray objectAtIndex:0];
                    [self setSelectorToUseWhenAnswering: selectorToUse]; // Assume for 'willAnswer' is the default - this can change when connected to another node of a different type
                } else {
                    logError(@"SHAttribute.m: ERROR willAnswerArray is empty ");
                }
                //disconnect if no longer applicable
                NSArray* interConnectors = [self allConnectedInterConnectors];
				
                for( SHInterConnector *con in interConnectors ){
                    [_parentSHNode deleteChild:con undoManager:nil];
                }
				
				//	[self performSelectorOnMainThread:@selector(postNodeGuiMayNeedRebuilding_Notification) withObject:nil waitUntilDone:NO];
            } @catch (NSException *exception) {
                logError(@"SHAttribute.m: ERROR Caught %@: %@", [exception name], [exception reason]);
                logError(@"SHAttribute.m: ERROR self is %@", self);
                logError(@"SHAttribute.m: ERROR will ask is %@", [[[_value class] willAnswer] objectAtIndex:0]);
			} @finally {
				/* we really must clean up here */
				// logInfo(@"SHAttribute.m: ERROR You need to add clean up code here incase an exception is thrown.");
			}
        } else {
			/* This gets called too often and is annoying */
			// logInfo(@"SHAttribute.m: ERROR: attribute is already of type %@", _dataClass );
            if( arg!=nil )
            {
                id newVal;
                if(_dataClass==[arg class])
                    newVal = arg;
                else
                    newVal = (id)[[[_dataClass alloc] initWithObject:arg] autorelease];
                [self setValue:	newVal];
            }
        }
	} else {
        
        /* At the moment we cannot copy an attribute that doesn't have a dataclass - is this correct? We should have a default type */
		logError(@"SHAttribute.m: ERROR: Cant make attribute of type %@. Cant find that Class.", _dataClass );

		//	[self setValue:	nil];
		//	_selectorToUse = nil;
	}
}

- (BOOL)dirtyBit {
	// This is overidden because
	// An InAttribute can only be dirty if it's outlet is connected
	// & 
	// An OutAttribute can only be dirty if it's inlet is connected
	return _dirtyBit;
}

- (void)publicSetValue:(id)aValue {
	
	// logInfo(@"SHNumber.m: in -setDisplayString:, old value of _displayString: %@, changed to: %@", _displayString, aDisplayString);
	
	// try to parse the string with fscript
	// [[@"[sys log:'hello world']" asBlock] value];
	
//	if([_value conformsToProtocol: @protocol( SHMutableValueProtocol )])
//	{
//		BOOL f = [(<SHMutableValueProtocol>)_value tryToSetValueWith:aValue];
//		if(f)
//			[self setDirtyBelow:random()];
//	} else {	
		id newVal = (id)[[[_dataClass alloc] initWithObject:aValue] autorelease];
		if(newVal!=nil)
			[self setValue:	newVal];
//	}
}

- (id)displayValue {
	logWarning(@"This needs a significant revamp. Add a StringRepresentation Method. ??");
	return [_value displayObject];
}

@end
