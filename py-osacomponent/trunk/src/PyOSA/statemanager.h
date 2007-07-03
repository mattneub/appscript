/*
 * statemanager.h
 * PyOSA
 *
 * Copyright (C) 2007 HAS
 *
 *
 * Defines C types used by PyOSA to manage component and script instances.
 *
 */

#include <Carbon/Carbon.h>
#include "hostcallbacks.h"


// Types

/* Stores the state for a single component instance; see componentOpen(). */
typedef struct {
	CFMutableDictionaryRef scripts;
	OSAID idCount;
	PyObject *terminologyCache;
	PyObject *callbacks;
	PyObject *appscriptServices;
	PyObject *resourcesFolderPath;
	char setupScriptPath[PATH_MAX];
	OSAID errorScriptID;
	PyObject *errorValue;
} ComponentInstanceStorage, **CIStorageHandle;

/* Stores everything needed to execute a script. */
typedef struct {
	UInt32 refcount;
	PyThreadState *context;
	PyObject *scriptManagerModule;
} ExecutionContext, *ExecutionContextRef;

/* Store a single script. */
typedef struct {
	OSAID scriptID;
	PyObject *scriptManager;
	ExecutionContextRef context;
} ScriptState, *ScriptStateRef;


// TO DO: need a PyOSACallbacks Python type that holds a CIStorageHandle and provides createAppleEvent and sendAppleEvent methods; an instance of this type is created for each ExecutionContext

// note: ExecutionContext should import osaappscript module, which extends standard appscript classes to use PyOSACallbacks' create and send methods; each scriptwrapper should inject osaappscript's public attributes into client script's namespace (users shouldn't import appscript themselves)


OSErr createComponentInstanceStorage(CIStorageHandle *ciStorage);
OSErr disposeComponentInstanceStorage(CIStorageHandle ciStorage);

OSErr createScriptState(CIStorageHandle ciStorage,
						ScriptStateRef parent,
						OSAID *scriptID,
						ScriptStateRef *state);
OSErr disposeScriptState(CIStorageHandle ciStorage, OSAID scriptID);

ScriptStateRef getScriptState(CIStorageHandle ciStorage, OSAID scriptID);
PyObject* getContextManager(CIStorageHandle ciStorage, OSAID contextID);

OSErr createValue(CIStorageHandle ciStorage, PyObject *value, ScriptStateRef parent, OSAID *valueID);

