/*
 * hostcallbacks.h
 * PyOSA
 *
 * Copyright (C) 2007 HAS
 *
 *
 * Wraps OSA client callbacks as a Python ADT (CObject + accessor functions
 * in an importable C extension) which can then be accessed from PyOSA's
 * Python code. Note that the C struct is also accessed directly by
 * handleOSASetActiveProc, handleOSAGetActiveProc, etc. when they need to
 * retrieve/replace its contents.
 *
 */

#include <Carbon/Carbon.h>
#include "Python/Python.h"
#include "carbonxtoolbox.h"


#define COMPONENT_NAME "PyOSA"
#define COMPONENT_VERSION 0x00010000
#define COMPONENT_IDENTIFIER "net.sourceforge.appscript.pyosa"
#define COMPONENT_OSTYPE 'PyOC'


#define DEBUG_ON

AEIdleUPP defaultIdleProc;
OSAActiveUPP defaultActiveProc;
OSACreateAppleEventUPP defaultCreateProc;
OSASendUPP defaultSendProc;


typedef struct {
	OSAActiveUPP activeProc;
	long activeRefCon;
	OSACreateAppleEventUPP createProc;
	long createRefCon;
	OSASendUPP sendProc;
	long sendRefCon;
	AEEventHandlerUPP continueProc;
	long continueRefCon;
} Callbacks, *CallbacksRef;


PyObject* createCallbacks(void);

void importCallbacksModule(void);