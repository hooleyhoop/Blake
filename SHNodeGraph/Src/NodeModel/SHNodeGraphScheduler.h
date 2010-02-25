//
//  SHNodeGraphScheduler.h
//  SHNodeGraph
//
//  Created by Steve Hooley on 18/06/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import"SHLoopTestProxyProtocol.h"
#import <SHShared/SHExternalTimeSourceProtocol.h>

@class ThreadWorker, SHNode;

#define SENDDACS_NO 0           /* return values for sys_send_dacs() */
#define SENDDACS_YES 1 
#define SENDDACS_SLEPT 2

typedef void (*t_fdpollfn)(void *ptr, int fd);

typedef struct _fdpoll
{
    int fdp_fd;
    t_fdpollfn fdp_fn;
    void *fdp_ptr;
} t_fdpoll;

@interface SHNodeGraphScheduler : _ROOT_OBJECT_ {
	
	int _sampleRate;
	int _schedblocksize;
    int _sleepgrain;
	int _schedadvance;
	double _time_per_dsp_tick;

	NSMutableArray* _idleHooks;
	BOOL _isPlaying;
//steve	ThreadWorker* _executionThread;
	id _shouldLoopProxy;
	
	id<SHExternalTimeSourceProtocol> _externalTimesource;
}

#pragma mark -
#pragma mark class methods
+ (SHNodeGraphScheduler*) scheduler;

#pragma mark init methods
#pragma mark action methods
- (void) clearHist;
- (void) addHist:(int)phase;
- (void) showHist;

- (void) sched_tick:(id)node time:(double) next_sys_time;
//steve- (id) schedulerLoop:(id)userInfo threadWorker:(ThreadWorker *)tw;

- (void) stop;
- (void) play:(id)aNode;

#pragma mark accessor methods
- (BOOL) isPlaying;

- (void) addIdleHook:(NSInvocation*)anInvocation;
- (void) removeIdleHook:(NSInvocation*)anInvocation;

//steve- (ThreadWorker *) executionThread;
//steve- (void) setExecutionThread: (ThreadWorker *) anExecutionThread;

- (id) shouldLoopProxy;
- (void) setShouldLoopProxy:(id<SHLoopTestProxyProtocol>) aLoopTestProxy;

- (id<SHExternalTimeSourceProtocol>)externalTimesource;
- (void)setExternalTimesource:(id<SHExternalTimeSourceProtocol>)anExternalTimesource;

#pragma mark call back methods
- (void) schedulerStopCallBack:(id)userInfo;

#pragma mark notification methods
//- (void)postExecutionLoopStarted_Notification:(SHNode *) aNode;
//- (void)postExecutionLoopStopped_Notification:(SHNode *) aNode;

@end


