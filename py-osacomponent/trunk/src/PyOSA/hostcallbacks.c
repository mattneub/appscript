/*
 * hostcallbacks.c
 * PyOSA
 *
 * Copyright (C) 2007 HAS
 *
 */

#include "hostcallbacks.h"


/**************************************/


static Boolean idleProc(EventRecord *theEvent, SInt32 *sleepTime, RgnHandle *mouseRgn) {
	// Idle callback used by invokeSendUPP
	return PyOS_InterruptOccurred();
}

static OSErr activeProc(void) {
	if (PyOS_InterruptOccurred()) return userCanceledErr;
	return noErr;
}


/**************************************/
/* Functions to invoke callback functions (UPPs) supplied by client. */



static PyObject* invokeActiveProc(PyObject *self, PyObject *args) {
	OSErr err;
	PyObject *callbacksObj;
	CallbacksRef callbacks = NULL;
	
	if (!PyArg_ParseTuple(args, "(O)",
								&callbacksObj)) return NULL;
	if (PyCObject_Check(callbacksObj))
		callbacks = (CallbacksRef)PyCObject_AsVoidPtr(callbacksObj);
	if (!callbacks || !(callbacks->activeProc)) return PyMac_Error(8000);
	err = InvokeOSAActiveUPP(callbacks->activeRefCon,
							 callbacks->activeProc);
	return Py_BuildValue("l", err);
}


static PyObject* invokeCreateProc(PyObject *self, PyObject *args) {
	OSErr err;
	PyObject *callbacksObj;
	CallbacksRef callbacks = NULL;
	AEEventClass theAEEventClass;
	AEEventID theAEEventID;
	AEAddressDesc target;
	AEReturnID returnID;
	AETransactionID transactionID;
	AppleEvent result;
	
	if (!PyArg_ParseTuple(args, "O&O&O&hlO",
								PyMac_GetOSType, &theAEEventClass,
								PyMac_GetOSType, &theAEEventID,
								AE_AEDesc_Convert, &target,
								&returnID,
								&transactionID,
								&callbacksObj)) return NULL;
	if (PyCObject_Check(callbacksObj))
		callbacks = (CallbacksRef)PyCObject_AsVoidPtr(callbacksObj);
	if (!callbacks) return PyMac_Error(9999);
	if (!callbacks || !(callbacks->createProc)) return PyMac_Error(8000);
	err = InvokeOSACreateAppleEventUPP(theAEEventClass,
										theAEEventID,
										&target,
										returnID,
										transactionID,
										&result,
										callbacks->createRefCon,
										callbacks->createProc);
	if (err) return PyMac_Error(err);
	return Py_BuildValue("O&", AE_AEDesc_New, &result);
}


static PyObject* invokeSendProc(PyObject *self, PyObject *args) {
	OSErr err;
	PyObject *callbacksObj;
	CallbacksRef callbacks = NULL;
	AppleEvent theAppleEvent, reply;
	AESendMode sendMode;
	long timeOutInTicks;
	
	if (!PyArg_ParseTuple(args, "O&llO",
								AE_AEDesc_Convert, &theAppleEvent,
								&sendMode,
								&timeOutInTicks,
								&callbacksObj)) return NULL;
	if (PyCObject_Check(callbacksObj))
		callbacks = ((CallbacksRef)PyCObject_AsVoidPtr(callbacksObj));
	if (!callbacks || !(callbacks->sendProc)) return PyMac_Error(8000);
	err = InvokeOSASendUPP(&theAppleEvent,
							&reply,
							sendMode,
							kAENormalPriority,
							timeOutInTicks,
							defaultIdleProc,
							(AEFilterUPP)0,
							callbacks->sendRefCon,
							callbacks->sendProc);
	if (err) return PyMac_Error(err);
	return Py_BuildValue("O&", AE_AEDesc_New, &reply);
}


static PyObject* invokeContinueProc(PyObject *self, PyObject *args) { 
	OSErr err = noErr;
	PyObject *callbacksObj;
	CallbacksRef callbacks = NULL;
	AppleEvent theAppleEvent, reply;
	AEAddressDesc target = {'null', NULL};
	AEEventHandlerUPP eventHandlerUPP;
	long refCon;
	
	
	err = AECreateAppleEvent(kCoreEventClass,
							kAEAnswer,
							&target,
							0,
							0,
							&reply);
	
	
	if (!PyArg_ParseTuple(args, "O&O",
							AE_AEDesc_Convert, &theAppleEvent,
							&callbacksObj)) return NULL;
	if (PyCObject_Check(callbacksObj))
		callbacks = ((CallbacksRef)PyCObject_AsVoidPtr(callbacksObj));
	if (!callbacks) return PyMac_Error(8000);
	eventHandlerUPP = callbacks->continueProc;
	refCon = callbacks->continueRefCon;
	#ifdef DEBUG_ON
//	fprintf(stderr, "invoking continue: upp=%08x refcon=%08x\n", (int)eventHandlerUPP, refCon);
	#endif
	err = AEResumeTheCurrentEvent(&theAppleEvent,
								  &reply,
								  eventHandlerUPP,
								  refCon);
	#ifdef DEBUG_ON
//	fprintf(stderr, "done (err = %i)\n", err);
	#endif
	if (err != noErr) return PyMac_Error(err);
	return Py_BuildValue("O&", AE_AEDesc_New, &reply);
}


/**********************************************************************/


PyMethodDef PyOSA_callbacks[] = {
	{"invokeactiveproc", invokeActiveProc, METH_VARARGS, 
			"invokeactiveproc(CObject callbacksobj) -> None)"},
	{"invokecreateproc", invokeCreateProc, METH_VARARGS, 
			"invokecreateproc(AEEventClass theAEEventClass, AEEventID theAEEventID, "
					"AEAddressDesc target, AEReturnID returnID, AETransactionID transactionID, "
					"CObject callbacksObj) -> AppleEvent result"},
	{"invokesendproc", invokeSendProc, METH_VARARGS, 
			"invokesendproc(AEDesc theAppleEvent, AESendMode sendMode, long timeOutInTicks, "
					"CObject callbacksObj) -> AEDesc reply"},
	{"invokecontinueproc", invokeContinueProc, METH_VARARGS, 
			"invokecontinueproc(AppleEvent theAppleEvent, AppleEvent reply, "
					"CObject callbacksObj) -> None"},
	{NULL, NULL, 0, NULL}
};


/**********************************************************************/


PyObject* createCallbacks(void) {
	CallbacksRef callbacks;
	
	if (!defaultIdleProc) {
		defaultIdleProc = NewAEIdleUPP((AEIdleProcPtr)idleProc);
		defaultActiveProc = NewOSAActiveUPP((OSAActiveProcPtr)activeProc);
		defaultCreateProc = NewOSACreateAppleEventUPP((OSACreateAppleEventProcPtr)AECreateAppleEvent);
		defaultSendProc = NewOSASendUPP((OSASendProcPtr)AESend);
		defaultContinueProc = (AEEventHandlerUPP)kOSAUseStandardDispatch;
	}
	callbacks = malloc(sizeof(Callbacks));
	callbacks->activeProc = defaultActiveProc;
	callbacks->activeRefCon = 0;
	callbacks->createProc = defaultCreateProc;
	callbacks->createRefCon = 0;
	callbacks->sendProc = defaultSendProc;
	callbacks->sendRefCon = 0;
	callbacks->continueProc = defaultContinueProc;
	callbacks->continueRefCon = 0;
	return PyCObject_FromVoidPtr((void *)callbacks, free);
}



void importCallbacksModule(void) {
	Py_InitModule("pyosa_hostcallbacks", PyOSA_callbacks);
}

