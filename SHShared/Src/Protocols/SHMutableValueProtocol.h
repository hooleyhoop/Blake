



// [object conformsToProtocol: @protocol( SomeProtocol )] 
// returns a BOOL if the object conforms to that protocol. 
// This works the same for classes as well: 
// [SomeClass conformsToProtocol: @protocol( SomeProtocol )]


@protocol SHMutableValueProtocol <SHValueProtocol>

#pragma mark class methods

#pragma mark action methods
- (BOOL) tryToSetValueWith:(id)aValue;

#pragma mark init methods

#pragma mark accessor methods



@end