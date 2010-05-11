#import <Foundation/Foundation.h>
#import <Foundation/NSObjCRuntime.h>
#import <objc/message.h>
#import <SHShared/SHSwizzler.h>

#define RUNLOOPMODE kCFRunLoopDefaultMode


@interface GUIFiddler : NSObject {
	
}

@end

static NSDictionary				*_data;
static CFRunLoopObserverRef		_observer;
static NSTimer					*_timer;
static GUIFiddler				*_fiddler;
static int						_parentPID;

@implementation GUIFiddler

//void genericCallback( CFNotificationCenterRef center, void *observer,CFStringRef name, const void *object, CFDictionaryRef userInfo){
//	printf("RN===>\n");
//	CFShow(name);
//}

- (id)init {

	self = [super init];
	if(self){
		[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedRemoteRequest:) name:@"hooley_distrbuted_notification" object:nil];
	
		// lets listen to all notifications
//		[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(allDNs:) name:nil object:nil];

		// CF
//		CFNotificationCenterRef distributedCenter;
//		CFStringRef observer = CFSTR("A CF OBSERVER");
//		distributedCenter = CFNotificationCenterGetDistributedCenter();
//		CFNotificationCenterAddObserver(distributedCenter, observer, genericCallback, NULL, NULL, CFNotificationSuspensionBehaviorDrop);
	}
	return self;
}

- (void)dealloc {

	[[NSDistributedNotificationCenter defaultCenter] removeObserver:self name:@"hooley_distrbuted_notification" object:nil];
	[super dealloc];
}


// Move the mouse pointer! yay
// CGDisplayMoveCursorToPoint()
// CGEventPost()
// CGPostMouseEvent()

//- (oneway void)allDNs:(NSNotification *)eh {
//	NSLog(@"N! - %@", eh );
//}

id _callHooSelector( id target, SEL _cmd, NSArray *args ){
	
	NSCParameterAssert(target);
	NSCParameterAssert(args);

	NSInvocation *invocation = buildInvocationForSelector( target, _cmd );
	NSCAssert( [args count]==([[invocation methodSignature] numberOfArguments]-2), @"wrong number of args?" );
	NSEnumerator *argEnum = [args objectEnumerator];
	for( NSUInteger i=2; i<[[invocation methodSignature] numberOfArguments]; i++){
		[invocation setArgument:[argEnum nextObject] atIndex:(NSInteger)i];
	}
	
	//-- call the original method
	[invocation invoke];
	id returnValue = nil;
	if([[invocation methodSignature] methodReturnLength])
	{
		//	returnValue = (id)malloc( [[invocation methodSignature] methodReturnLength] );
		[invocation getReturnValue: &returnValue];
	}
	return returnValue;
}

- (oneway void)receivedRemoteRequest:(NSNotification *)eh {
	
	NSDictionary *dict = [eh userInfo];
	NSString *object = [eh object];
	NSString *targetClassName = [dict objectForKey:@"TargetClass"];
	NSAssert(targetClassName, @"Need to specify targetClass Name");
	Class targetClass = NSClassFromString(targetClassName);
	NSString *selectorName = [dict objectForKey:@"SelectorName"];
	NSAssert(selectorName, @"Need to specify Selector Name");
	SEL selector = NSSelectorFromString(selectorName);
	NSArray *arguments = [dict objectForKey:@"Arguments"];
	
	id result = _callHooSelector( targetClass, selector, arguments );
	
	// -- construct result dictionary
	NSMutableDictionary *resultDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys: result, @"resultValue", nil];
	
	// post back to main process
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"hooley_distrbuted_notification_callback" object:[object stringByAppendingString:@"_callback"] userInfo:resultDictionary deliverImmediately:NO];

}
		
- (void)timerFire:(id)value {

	ProcessSerialNumber theProcessSerialNumber;
	if( GetProcessForPID( _parentPID, &theProcessSerialNumber)!=noErr ){
		[[NSApplication sharedApplication] terminate:self];
	}
}

@end

// runloop callback
static void cf_observer_delayedNotification( CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info ) {
	
   // NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

	// NSLog(@"woah");
	//	NSDictionary *data = (NSDictionary *)info;
	//	AllChildrenFilter *filter = (AllChildrenFilter *)[data objectForKey:@"key1"];
	//	NSString *methodName = (NSString *)[data objectForKey:@"key2"];
	//	DelayedNotifier *self = (DelayedNotifier*)[data objectForKey:@"key3"];
	//	
	//	NSCAssert( filter, @"dum dum" );
	//	NSCAssert( methodName, @"dum dum" );	
	//	NSCAssert( self->_controller, @"dum dum" );
	//	
	//	[filter performSelector:NSSelectorFromString(methodName)];
	//	
	//	[self->_controller notificationDidFire_callback];
	
  //  [pool drain];
}

/* add a callback to the runloop with our callback objects in an info dictionary */
void addRunloopSource(void) {
	
	NSCAssert(_data==nil, @"hmm");
	NSCAssert(_observer==nil, @"hmm");
	
	_data = nil; //[[NSDictionary dictionaryWithObjectsAndKeys: callBackObject, @"key1", NSStringFromSelector(callbackMethod), @"key2", self, @"key3", nil] retain];
	
	CFRunLoopObserverContext context = {0, _data, NULL, NULL, NULL};
	_observer = CFRunLoopObserverCreate( kCFAllocatorDefault, kCFRunLoopBeforeTimers, YES, 0, &cf_observer_delayedNotification, &context);
	NSRunLoop *myRunLoop = [NSRunLoop currentRunLoop];
	CFRunLoopRef cfLoop = [myRunLoop getCFRunLoop];
	
	/* This is REALLY IMPORTANT
	 * If we use kCFRunLoopDefaultMode it will behave 'normally'
	 * If i use kCFRunLoopCommonModes it will work even when we are in a mouse drag and have hijacked the runloop, this seems better - 
	 * But i don't understand what is happening behind the scenes, which worries me
	 */
	
	CFRunLoopAddObserver( cfLoop, _observer, RUNLOOPMODE );

	BOOL shouldKeepRunning = YES; 
	NSRunLoop *theRL = [NSRunLoop currentRunLoop];
	while (shouldKeepRunning && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]) {
		// -- check parent process is still running
		ProcessSerialNumber theProcessSerialNumber;
		if( GetProcessForPID( _parentPID, &theProcessSerialNumber)!=noErr ){
			[[NSApplication sharedApplication] terminate:nil];
		}
	}
}

void removeRunLoopSource(void) {
	
	NSRunLoop* myRunLoop = [NSRunLoop currentRunLoop];
	CFRunLoopRef cfLoop = [myRunLoop getCFRunLoop];
	CFRunLoopRemoveObserver(cfLoop, _observer, RUNLOOPMODE);
	CFRelease(_observer);
	_observer = nil;
	[_data release];
	_data = nil;
}

void fireOveride(void) {
	cf_observer_delayedNotification( _observer, kCFRunLoopEntry, _data );
}

int main (int argc, const char * argv[]) {

    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSArray *args = [[NSProcessInfo processInfo] arguments];
	for( NSString *earchArg in args) {
		NSLog( @"** arg - %@ **", earchArg );
		_parentPID = [earchArg intValue];
	}
	_fiddler = [[GUIFiddler alloc] init];
	_timer = [[NSTimer scheduledTimerWithTimeInterval:1.0 target:_fiddler selector:@selector(timerFire:) userInfo:nil repeats:YES] retain];
	addRunloopSource();
	
    [pool drain];
    return 0;
}

__attribute__((destructor)) void onExit(void) {
    
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!Closing Down the fiddler.");
	[_fiddler release];
	removeRunLoopSource();
	[_timer invalidate];
	[pool release];
}
