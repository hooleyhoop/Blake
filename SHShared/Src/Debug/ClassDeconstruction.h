

@interface NSObject (ClassDeconstruction)

/* temporary home for this */
void MethodSwizzle(Class aClass, SEL orig_sel, SEL alt_sel)  __attribute__((nonnull(1,2,3)));

// from one place
- (void)deconstruct;
- (void)deconstruct: (Class)aClass;


// from another
// - (NSString *)describeIvarsAndSuperIvars;

- (NSString *)describeIvars;


- (NSArray *) methodsOfSelf;
- (NSArray *) ivarsOfSelf;
- (NSString *) describeSelf;

+ (NSArray *)ivarsOfObject:(id)anObject classObject:(BOOL)flag;
+ (NSArray *) methodsOfObject:(id)anObject classObject:(BOOL)flag;
+ (NSString *)describeObject:(id)anObject classObject:(BOOL)flag;

// all classes in the runtime except zombies etc
// NSMutableArray *allClasses();	// this is in fscript misctools


@end
