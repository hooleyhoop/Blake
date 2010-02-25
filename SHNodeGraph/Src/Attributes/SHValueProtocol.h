

// [object conformsToProtocol: @protocol( SomeProtocol )] 
// returns a BOOL if the object conforms to that protocol. 
// This works the same for classes as well: 
// [SomeClass conformsToProtocol: @protocol( SomeProtocol )]


@protocol SHValueProtocol <NSObject, NSCopying, NSCoding>

#pragma mark class methods
+ (NSString* ) willAsk;		// any data type will only ever ask a connected datatype for one type of data (string, number, etc.)
+ (NSArray *) willAnswer;	// however, a single data type might respond to more than one request (string and number, etc.)

#pragma mark init methods
- (id)initWithObject:(id)ob;

//- (id) duplicate;

- (BOOL)isEquivalentToValue:(id)anObject;

#pragma mark accessor methods
// return a new instance of this type initialized with value from the string
//+ (id) dataTypeFromString:(NSString*)stringVal;

- (NSString *)stringValue;
- (id)displayObject;
//- (void) setDisplayObject:(id)val;

- (NSString *)fScriptSaveString;


@end