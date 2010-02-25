//
//  SHPlugInViewManager.m
//  Pharm
//
//  Created by Steve Hooley on 10/01/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import "SHPlugInViewManager.h"
#import "SHAppControl.h"
#import "SHAppView.h"
#import "SHFScriptControl.h"


@implementation SHPlugInViewManager

@interface DKRuntimeHelper : SHooleyObject

+ (NSArray*)    allClasses;
+ (NSArray*)    allClassesOfKind:(Class) aClass;


@end



@implementation DKRuntimeHelper


+ (NSArray*)    allClasses
{
	return [self allClassesOfKind:[NSObject class]];
}


+ (NSArray*)    allClassesOfKind:(Class) aClass
{
	// returns a list of all Class objects that are of kind <aClass> or a
	subclass of it currently registered in the runtime. This caches the
	// result so that the relatively expensive run-through is only
	performed the first time
	
	static NSMutableDictionary* cache = nil;
	
	if ( cache == nil )
		cache = [[NSMutableDictionary alloc] init];
	
	// is the list already cached?
	
	NSArray* cachedList = [cache objectForKey:NSStringFromClass( aClass )];
	
	if ( cachedList != nil )
		return cachedList;
	
	// if here, list wasn't in the cache, so build it the hard way
	
	NSMutableArray* list = [NSMutableArray array];
	
	Class*                  buffer = NULL;
	Class                   cl;
	
	int i, numClasses = objc_getClassList( NULL, 0 );
	
	if( numClasses > 0 )
	{
		buffer = malloc( sizeof(Class) * numClasses );
		
		NSAssert( buffer != nil, @"couldn't allocate the buffer");
		
		(void)  objc_getClassList( buffer, numClasses );
		
		// go through the list and carefully check whether the class can
		respond to isSubclassOfClass: - if so, add it to the list.
			
			for( i = 0; i < numClasses; ++i )
			{
				cl = buffer[i];
				
				if( classIsSubclassOfClass( cl, aClass ))
					[list addObject:cl];
			}
		
		free( buffer );
	}
	
	// save in cache for next time
	
	[cache setObject:list forKey:NSStringFromClass( aClass )];
	
	return list;
}

@end



BOOL    classIsNSObject( const Class aClass )
{
	// returns YES if <aClass> is an NSObject derivative, otherwise NO.
	It does this without invoking any methods on the class being tested.
	
	return classIsSubclassOfClass( aClass, [NSObject class]);
}


BOOL    classIsSubclassOfClass( const Class aClass, const Class subclass )
{
	Class   temp = aClass;
	int             match = -1;
	
	while(( 0 != ( match = strncmp( temp->name, subclass->name,
								   strlen( subclass->name )))) && ( NULL != temp->super_class ))
		temp = temp->super_class;
	
	return ( match == 0 );
}


#pragma mark -
#pragma mark class methods

#pragma mark init methods
//=========================================================== 
// initWithAppModel
//=========================================================== 
- (id)initWithAppModel:(SHAppModel*)appModel
{
    if (self = [super init]) 
	{
		_appModel = appModel;
		NSMutableDictionary* openViews	= [NSMutableDictionary dictionaryWithCapacity:5];
		[[SHGlobalVars globals] setObject:openViews forKey:@"openViews" ];
	}
	return self;
}


//=========================================================== 
// dealloc
//=========================================================== 
- (void)dealloc {
	_appModel = nil;
    [super dealloc];
}


// ===========================================================
// - createViewControllersFromLoadedPlugins:
// ===========================================================
- (void)createViewControllersFromLoadedPlugins
{
	//	SHObjPaletteControl					*_theSHObjPaletteControl;
	//	SHFScriptControl					*_theFscriptScriptControl;
	//	SHNodeGraphInspector_C				*_nodeGraphInspectorControl;
	//	SHObjectListControl					*_theObjectListControl;
	//	SHPropertyInspectorControl			*_thePropertyInspectorControl;

		// AUTOMATE THIS
	//	_theSHObjPaletteControl			= [[SHObjPaletteControl alloc] initWithSHAppControl: _theSHAppControl];
	//	_nodeGraphInspectorControl		= [[SHNodeGraphInspector_C alloc]initWithSHAppControl: _theSHAppControl];
	//	_theFscriptScriptControl		= [[SHFScriptControl alloc]initWithSHAppControl: _theSHAppControl];
	//	_theObjectListControl			= [[SHObjectListControl alloc]initWithSHAppControl: _theSHAppControl];
	//	_thePropertyInspectorControl	= [[SHPropertyInspectorControl alloc]initWithSHAppControl: _theSHAppControl];

	id arrayOfViewFrameworks	= [[SHGlobalVars globals] objectForKey:@"theViewPlugins" ];
	
	NSBundle* viewBundle;
	NSEnumerator* en = [arrayOfViewFrameworks objectEnumerator];
	while ((viewBundle = [en nextObject]) != nil)
	{
		Class viewControlClass = [viewBundle principalClass];	// you did remember to set the principal class, right?
		if(viewControlClass!=nil){
			[self instantiateViewControllerClass: viewControlClass];
		} else {
			NSLog(@"SHPlugInViewManager.m: ERROR Loading view! Plugin View doesnt have a principal class. %@", viewBundle );
		}
		// NSLog(@"SHPlugInViewManager.m: what the fuck am i ? %@", [viewBundle principalClass]);
	}

	// manually add fscriptview which isn't yet a plugin
	[self instantiateViewControllerClass:[SHFScriptControl class]];
}


#pragma mark action methods

// ===========================================================
// - requestSetViewport: withViewControl:
// ===========================================================
- (void)requestSetViewport:(NSString*)aViewPortName withViewControl:(NSString*)aViewControlClass
{
	// get instance of view controller from globals
	NSDictionary* instantiatedViewControllers = (NSDictionary*)[[SHGlobalVars globals] objectForKey:@"instantiatedViewControllers"];
	if(instantiatedViewControllers!=nil)
	{
		// check that this view isnt already open..
		id openViews	= [[SHGlobalVars globals] objectForKey:@"openViews" ];
		id view = [openViews objectForKey:aViewControlClass];
		if(view==nil){
			// get object for key
			// NSLog(@"SHPlugInViewManager.m: instantiatedViewControllers class is. %@", [instantiatedViewControllers class] );
			SHCustomViewController* viewController = (SHCustomViewController*)[instantiatedViewControllers objectForKey:aViewControlClass ];
			if(viewController!=nil)
			{
				// NSLog(@"SHPlugInViewManager.m: SHAppControl class is. %@", [SHAppControl appControl] );
				[[SHAppView appView] setSHViewport:aViewPortName withContent:viewController];
				[openViews setObject:viewController forKey:aViewControlClass];
			}
		}
	}
}


// ===========================================================
// - requestLaunchViewControlInOwnWindow:
// ===========================================================
- (void)requestLaunchViewControlInOwnWindow:(NSString*)aViewControlClass
{
	// get instance of view controller from globals
	NSDictionary* instantiatedViewControllers = (NSDictionary*)[[SHGlobalVars globals] objectForKey:@"instantiatedViewControllers"];
	if(instantiatedViewControllers!=nil)
	{
		// check that this view isnt already open..
		id openViews	= [[SHGlobalVars globals] objectForKey:@"openViews" ];
		id view = [openViews objectForKey:aViewControlClass];
		if(view==nil){
			// get object for key
			// NSLog(@"SHPlugInViewManager.m: instantiatedViewControllers class is. %@", [instantiatedViewControllers class] );
			id viewController = [instantiatedViewControllers objectForKey:aViewControlClass ];
			if(viewController!=nil)
			{
				[[SHAppControl appControl] launchInOwnWindow: viewController ];
				[openViews setObject:viewController forKey:aViewControlClass];
			}
		}
	}
}


// ===========================================================
// - instantiateViewControllerClass:
// ===========================================================
- (void)instantiateViewControllerClass:(Class)aViewControllerClass
{
	// check that class implements protocol and extends viewController
	if([aViewControllerClass conformsToProtocol:@protocol(SHViewControllerProtocol)])
	{
		// see if there is already an array of views in globals
		id instantiatedViewControllers = [[SHGlobalVars globals] objectForKey:@"instantiatedViewControllers"];
		if(instantiatedViewControllers==nil)
		{
			// if not, make it
			instantiatedViewControllers	= [NSMutableDictionary dictionaryWithCapacity:5];
			[[SHGlobalVars globals] setObject:instantiatedViewControllers forKey:@"instantiatedViewControllers" ];
		}
		[instantiatedViewControllers setObject: [[[aViewControllerClass alloc] initWithSHAppControl: [SHAppControl appControl]]autorelease] forKey:NSStringFromClass(aViewControllerClass) ];
	}
}


#pragma mark accessorizor methods


@end
