//
//  SHNodeGraphScheduler.m
//  SHNodeGraph
//
//  Created by Steve Hooley on 18/06/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import "SHNodeGraphScheduler.h"
#include <sys/time.h>
//#import <SHShared/ThreadWorker.h>
#import "SHExecutableNode.h"

#define TIMEUNITPERSEC (32.*441000.)


// static NSTimeInterval _lastTimeInterval;


/*
 *
 */
@interface SHNodeGraphScheduler (PrivateMethods)

//steve - (ThreadWorker *) executionThread;
//steve - (void) setExecutionThread: (ThreadWorker *) anExecutionThread;

@end

/*
 *
*/
@implementation SHNodeGraphScheduler

// globals

double sched_referencerealtime, sched_referencelogicaltime;

/* the following routines maintain a real-execution-time histogram of the
various phases of real-time execution. */
int sys_bin[] = {0, 2, 5, 10, 20, 30, 50, 100, 1000};
#define NBIN (sizeof(sys_bin)/sizeof(*sys_bin))
#define NHIST 10
int sys_histogram[NHIST][NBIN];
double sys_histtime;
int sched_diddsp, sched_didpoll, sched_didnothing;
double sys_time;
double sys_time_per_msec = TIMEUNITPERSEC / 1000.;

#pragma mark -
#pragma mark class methods

+ (SHNodeGraphScheduler *)scheduler {

	return [[[SHNodeGraphScheduler alloc] init] autorelease];
}

#pragma mark init methods
- (id)init
{
	if ((self = [super init]) != nil)
	{
		_sampleRate = 44100; // sys_dacsr in pd
		_schedblocksize = 44100/2; // 64; // sys_schedblocksize in pd
		_sleepgrain = 5000;
		_schedadvance = 5000;
		_time_per_dsp_tick = 20480;

		_idleHooks = nil;
		_isPlaying = NO;
//steve		_executionThread = nil;
		_shouldLoopProxy = nil;
		_externalTimesource = nil;
		
		//logInfo(@"SHNodeGraphScheduler.m: init");
		//15/05/06		_isEvaluating			= NO;
		//15/05/06		_isPlaying				= NO;
		//_lastTimeInterval = 0;
		
	}
	return self;
}

- (void) dealloc {
	[_idleHooks release];
    [_externalTimesource release];
	[self setShouldLoopProxy:nil];
	
    _externalTimesource = nil;
	_idleHooks = nil;
	[super dealloc];
}

#pragma mark action methods
/* get "real time" in seconds; take the
first time we get called as a reference time of zero. */
double sys_getrealtime(void)    
{
    static struct timeval then;
    struct timeval now;
    gettimeofday(&now, 0);
    if (then.tv_sec == 0 && then.tv_usec == 0) then = now;
    return ((now.tv_sec - then.tv_sec) + (1./1000000.) * (now.tv_usec - then.tv_usec));
}

static t_fdpoll *sys_fdpoll;
static int sys_nfdpoll;
static int sys_maxfd;

static int sys_domicrosleep(int microsec, int pollem)
{
    struct timeval timout;
    int i, didsomething = 0;
    t_fdpoll *fp;
    timout.tv_sec = 0;
    timout.tv_usec = microsec;
    if (pollem)
    {
        fd_set readset, writeset, exceptset;
        FD_ZERO(&writeset);
        FD_ZERO(&readset);
        FD_ZERO(&exceptset);
        for(fp = sys_fdpoll, i = sys_nfdpoll; i--; fp++)
            FD_SET(fp->fdp_fd, &readset);

        select(sys_maxfd+1, &readset, &writeset, &exceptset, &timout);
        for (i = 0; i < sys_nfdpoll; i++)
            if (FD_ISSET(sys_fdpoll[i].fdp_fd, &readset))
        {
            // sys_lock();

            (*sys_fdpoll[i].fdp_fn)(sys_fdpoll[i].fdp_ptr, sys_fdpoll[i].fdp_fd);

            // sys_unlock();
            didsomething = 1;
        }
        return (didsomething);
    }
    else
    {
        select(0, 0, 0, 0, &timout);
        return (0);
    }
}

void sys_microsleep(int microsec){
    sys_domicrosleep(microsec, 1);
}

/* get current logical time.  We don't specify what units this is in;
use clock_gettimesince() to measure intervals from time of this call. 
This was previously, incorrectly named "clock_getsystime"; the old
name is aliased to the new one in m_pd.h. */
double clock_getlogicaltime( void) {
    return (sys_time);
}

/* elapsed time in milliseconds since the given system time */
double clock_gettimesince(double prevsystime)
{
    return ((sys_time - prevsystime)/sys_time_per_msec);
}

/* what value the system clock will have after a delay */
double clock_getsystimeafter(double delaytime){
    return (sys_time + sys_time_per_msec * delaytime);
}

void sys_reportidle(void)
{
}

- (void) clearHist
{
    unsigned int i, j;
    for (i = 0; i < NHIST; i++)
        for (j = 0; j < NBIN; j++)
			sys_histogram[i][j] = 0;
    sys_histtime = sys_getrealtime();
    sched_diddsp = sched_didpoll = sched_didnothing = 0;
}

static int sys_histphase;

- (void)addHist:(int)phase
{
    int j, phasewas = sys_histphase;
    double newtime = sys_getrealtime();
    int msec = (newtime - sys_histtime) * 1000.;
    for (j = NBIN-1; j >= 0; j--)
    {
        if (msec >= sys_bin[j]) 
        {
            sys_histogram[phasewas][j]++;
            break;
        }
    }
    sys_histtime = newtime;
    sys_histphase = phase;
}

- (void) showHist
{
    unsigned int i, j;
    for (i = 0; i < NHIST; i++)
    {
        int doit = 0;
        for (j = 0; j < NBIN; j++) 
			if (sys_histogram[i][j]) doit = 1;
        if (doit)
        {
            logInfo(@"%2d %8d %8d %8d %8d %8d %8d %8d %8d", i, sys_histogram[i][0], sys_histogram[i][1], sys_histogram[i][2], sys_histogram[i][3], sys_histogram[i][4], sys_histogram[i][5], sys_histogram[i][6], sys_histogram[i][7]);
        }
    }
    logInfo(@"dsp %d, pollgui %d, nothing %d", sched_diddsp, sched_didpoll, sched_didnothing);
}


/* take the scheduler forward one DSP tick, also handling clock timeouts */
- (void)sched_tick:(id)node time:(double) next_sys_time
{
//    int countdown = 5000;
//    while (clock_setlist && clock_setlist->c_settime < next_sys_time)
//    {
//        t_clock *c = clock_setlist;
//        sys_time = c->c_settime;
//        clock_unset(clock_setlist);
//        outlet_setstacklim();
//        (*c->c_fn)(c->c_owner);
//        if (!countdown--)
//        {
//            countdown = 5000;
//            sys_pollgui();
//        }
 //steve       if ([_executionThread cancelled])
 //steve          return;
//    }
    sys_time = next_sys_time;
	
	/* 
	* do we need timemodes?
	* we can pass in system time, local time or external time */
//    BOOL flag = [node execute:nil head:nil time:sys_time arguments:nil]; // was dsp_tick() in pd;
//	if(!flag)
//		logError(@"execute:time returned error Node:%@", node);
	sched_diddsp++;
}


//steve- (id)schedulerLoop:(id)userInfo threadWorker:(ThreadWorker *)tw
//steve{
    // int idlecount = 0;
//steve    _time_per_dsp_tick = (TIMEUNITPERSEC) * ((double)_schedblocksize) / _sampleRate;
	
//steve    [self clearHist];
//steve    if (_sleepgrain < 1000)
//steve        _sleepgrain = _schedadvance/4;
//steve    if (_sleepgrain < 100)
//steve        _sleepgrain = 100;
//steve    else if (_sleepgrain > 5000)
//steve        _sleepgrain = 5000;
    
	// sys_initmidiqueue();
	// call set up on nodes

	// notify views that we have started execution
//	[self performSelectorOnMainThread:@selector(postExecutionLoopStarted_Notification:) withObject:userInfo waitUntilDone:NO];
	
//steve	int didsomething;
//steve	int timeforwardResult=SENDDACS_NO;
		
	// The main Loop
//steve    while( [_shouldLoopProxy loopConditionalTest] )
//steve   {
//steve		didsomething = 0;
//steve        [self addHist:0];
// waitfortick:
		
//steve		if( _externalTimesource )
//steve		{
//			timeforwardResult = [_externalTimesource sys_send_dacs()]; // was timeforwardResult = pa_send_dacs();	// send output to portaudio



// thurs, 6th july 2006					[[_advanceTimeInvocations objectAtIndex:i] invoke];
// thurs, 6th july 2006					[[_advanceTimeInvocations objectAtIndex:i] getReturnValue:&timeforwardResult];
// thurs, 6th july 2006			}
		
//                /* if dacs remain "idle" for 1 sec, they're hung up. */
//				if (timeforwardResult != 0)
//					idlecount = 0;
//				else
//				{
//					idlecount++;
//					if (!(idlecount & 31))
//					{
//						static double idletime;
//                        /* on 32nd idle, start a clock watch;  every
//                        32 ensuing idles, check it */
//						if (idlecount == 32)
//							idletime = sys_getrealtime();
//						else if (sys_getrealtime() - idletime > 1.)
//						{
//							post("audio I/O stuck... closing audio\n");
//							sys_close_audio();
//							sched_set_using_dacs(0);
//							goto waitfortick;
//						}
//					}
//				}
		/* Not scheduling using DACS */
//steve		} else {
//steve			if (1000. * (sys_getrealtime() - sched_referencerealtime) > clock_gettimesince(sched_referencelogicaltime)){
//steve				timeforwardResult = SENDDACS_YES;
//steve			} else {
//steve				timeforwardResult = SENDDACS_NO;
//steve			}
//steve		} /* end sched using dacs */
		
		/// sys_setmiditimediff(0, 1e-6 * _schedadvance);
 //steve       [self addHist:1];
//steve        if( (timeforwardResult==SENDDACS_NO)==NO ){
//steve			// do the business
 //steve           [self sched_tick:userInfo time:(sys_time + _time_per_dsp_tick)];
//steve		}
 //steve       if (timeforwardResult == SENDDACS_YES)
//steve            didsomething = 1;
		
 //steve       [self addHist:2];
//        sys_pollmidiqueue();
//        if (sys_pollgui())
//        {
//            if (!didsomething)
//                sched_didpoll++;
//            didsomething = 1;
//        }
 //steve       [self addHist:3];
		/* test for idle; if so, do graphics updates. */
//steve        if (didsomething==0)
  //steve      {
			// sched_pollformeters();
  //steve          sys_reportidle();
			
			/* call externally installed idle function if any. */
  //steve          if (_idleHooks)
//steve           {
//steve				int i, count=[_idleHooks count];
//steve				for(i=0;i<count;i++) {
//steve					[[_idleHooks objectAtIndex:i] invoke];
//steve					[[_idleHooks objectAtIndex:i] getReturnValue:&didsomething];
//steve			}
//steve				
				/* if even that had nothing to do, sleep. */
 //steve               if (timeforwardResult != SENDDACS_SLEPT && !didsomething)
//steve				{
			//		logInfo(@"sceduler: need to sleep");
			//		[self performSelectorOnMainThread:@selector(logInfoOnMainThread:) withObject:@"sceduler: need to sleep" waitUntilDone:NO];
 //steve                  sys_microsleep(_sleepgrain);
	//steve			} else {
					//logInfo(@"sceduler: didsomething= %i, timeforwardResult=%i", didsomething, timeforwardResult);
			//		[self performSelectorOnMainThread:@selector(logInfoOnMainThread:) withObject:@"sceduler: didsomething= %, timeforwardResult=%" waitUntilDone:NO];

//steve				}
 //steve           }
			
 //steve           [self addHist:5];
 //steve           sched_didnothing++;
 //steve       }
 //steve   }

	// notify views that we have stopped execution
//	[self performSelectorOnMainThread:@selector(postExecutionLoopStopped_Notification:) withObject:userInfo waitUntilDone:NO];
	
//steve    return userInfo; // contains a node at the moment
//steve}


//#define MULTITHREADED

- (void)play:(id)aNode
{
//steve	if(!_isPlaying && !_executionThread)
//steve	{
//steve		_isPlaying = YES;
//steve		sched_referencerealtime = sys_getrealtime(); // only need to do this if we are not scheduling using dacs
//steve		sched_referencelogicaltime = clock_getlogicaltime();
//steve		_time_per_dsp_tick = (TIMEUNITPERSEC) * ((double)_schedblocksize) / _sampleRate;
//steve		NSAssert(aNode != nil, @"SCheduler: cant run execute thread on that node");
//steve		SEL selToDo = @selector(schedulerLoop:threadWorker:);
//steve		SEL selToDoOnEnd = @selector(schedulerStopCallBack:);
//steve		NSAssert([self respondsToSelector:selToDo], @"SCheduler: aNode doesnt respond to SEL we are trying to launch in a new thread");
//steve		NSAssert([self respondsToSelector:selToDoOnEnd], @"SCheduler: aNode doesnt respond to SEL to do on exit thread");
#ifdef MULTITHREADED
//steve		ThreadWorker* aNewThreadWorker = [ThreadWorker workOn:self withSelector:selToDo withObject:aNode didEndSelector:selToDoOnEnd];
#else
		// try to run in this thread
//steve		ThreadWorker* aNewThreadWorker = [[[ThreadWorker alloc] initWithTarget:self selector:selToDo argument:aNode didEndSelector:selToDoOnEnd] autorelease];
//steve		[self schedulerLoop:aNode threadWorker:aNewThreadWorker];
#endif
//steve		[self setExecutionThread: aNewThreadWorker];
		
//steve	} else {
//steve		logError(@"SCheduler: ERROR! cant play");
//steve	}
}

- (void) stop
{
//steve	[_executionThread markAsCancelled];
} 

#pragma mark accessor methods
- (BOOL) isPlaying{ return _isPlaying; }

- (void)addIdleHook:(NSInvocation*)anInvocation
{
	if(!_idleHooks)
		_idleHooks = [[NSMutableArray arrayWithCapacity:1] retain];
	[_idleHooks addObject:anInvocation];
}


- (void)removeIdleHook:(NSInvocation *)anInvocation
{
	[_idleHooks removeObjectIdenticalTo:anInvocation ];
	if([_idleHooks count]==0){
		[_idleHooks release];
		_idleHooks = nil;
	}
}


//steve- (ThreadWorker *)executionThread { return _executionThread; }
//steve- (void)setExecutionThread:(ThreadWorker *) anExecutionThread {
//steve	//logInfo(@"in -setExecutionThread:, old value of executionThread: %@, changed to: %@", executionThread, anExecutionThread);
//steve	if (_executionThread != anExecutionThread) {
//steve		[_executionThread release];
//steve		_executionThread = [anExecutionThread retain];
//steve	}
//steve}


- (id) shouldLoopProxy { return _shouldLoopProxy; }
- (void) setShouldLoopProxy:(id<SHLoopTestProxyProtocol>) aLoopTestProxy {
	if (_shouldLoopProxy != aLoopTestProxy) {
		[_shouldLoopProxy release];
		_shouldLoopProxy = [aLoopTestProxy retain];
	}
}


//=========================================================== 
//  externalTimesource 
//=========================================================== 
- (id<SHExternalTimeSourceProtocol>)externalTimesource { return _externalTimesource; }
- (void)setExternalTimesource:(id<SHExternalTimeSourceProtocol>)anExternalTimesource
{
    //logInfo(@"in -setExternalTimesource:, old value of _externalTimesource: %@, changed to: %@", _externalTimesource, anExternalTimesource);
	
    if (_externalTimesource != anExternalTimesource) {
        [_externalTimesource release];
        _externalTimesource = [anExternalTimesource retain];
    }
}


// ===========================================================
// - initEvaluationOfCurrentNodeGroup
// ===========================================================
/* - (BOOL) initEvaluationOfCurrentNodeGroup  {
_isEvaluating = YES;
BOOL i = [_currentNodeGroup evaluate];
_isEvaluating = NO;
return i;
} */

#pragma mark callback methods

/* called by the executing node when it breaks out of its loop */
- (void) schedulerStopCallBack:(id)userInfo
{
	logInfo(@"Scheduler: schedulerStopCallBack");

	// userInfo = returned value
	_isPlaying = NO;
//steve	[self setExecutionThread: nil];
}

#pragma mark notification methods
//- (void)postExecutionLoopStarted_Notification:(SHNode*)aNode
//{
//	// we do this because the notification needs to be sent from the main thread
//	NSDictionary *d = [NSDictionary dictionaryWithObject:aNode forKey:@"theExecutableNode"];
//	NSNotification *n = [NSNotification notificationWithName:@"ExecutionLoopStarted" object:self userInfo:d];
//	[[NSNotificationCenter defaultCenter] postNotification: n ];
//}


//- (void) postExecutionLoopStopped_Notification:(SHNode*) aNode
//{
//	// we do this because the notification needs to be sent from the main thread
//	NSDictionary* d = [NSDictionary dictionaryWithObject:aNode forKey:@"theExecutableNode"];
//	NSNotification* n = [NSNotification notificationWithName:@"ExecutionLoopEnded" object:self userInfo:d];
//	[[NSNotificationCenter defaultCenter] postNotification: n];
//}

//- (void)logInfoOnMainThread:(NSString*) msg
//{
//	logInfo(msg);
//}
@end
