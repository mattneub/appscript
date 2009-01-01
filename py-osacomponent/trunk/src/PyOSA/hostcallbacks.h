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
 
#ifndef PYOSA_HOSTCALLBACKS_H
#define PYOSA_HOSTCALLBACKS_H

#include <Carbon/Carbon.h>
#include "aetoolbox.h"


AEIdleUPP defaultIdleProc;
OSAActiveUPP defaultActiveProc;
OSACreateAppleEventUPP defaultCreateProc;
OSASendUPP defaultSendProc;
AEEventHandlerUPP defaultContinueProc;


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

#endif
