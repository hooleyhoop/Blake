#!/bin/sh
export MallocStackLogging=YES
export NSDebugEnabled=YES
export NSZombieEnabled=YES
export NSHangOnUncaughtException=YES
export NSAutoreleaseFreedObjectCheckEnabled=YES
export MallocScribble=1
export MallocPreScribble=1

"${SYSTEM_DEVELOPER_DIR}/Tools/RunUnitTests"
