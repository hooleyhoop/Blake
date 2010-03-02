#!/bin/sh
export MallocStackLogging=YES
export NSDebugEnabled=YES
export NSZombieEnabled=YES
export NSHangOnUncaughtException=YES
export NSAutoreleaseFreedObjectCheckEnabled=YES
export MallocScribble=1
export MallocPreScribble=1
export OBJC_DISABLE_GC=YES
export DYLD_PRINT_LIBRARIES=1
export DYLD_PRINT_OPTS=1
export DYLD_PRINT_INITIALIZERS=1

"${SYSTEM_DEVELOPER_DIR}/Tools/RunUnitTests"
