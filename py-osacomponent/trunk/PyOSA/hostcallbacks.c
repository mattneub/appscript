/*
 * hostcallbacks.c
 * PyOSA
 *
 * Copyright (C) 2007 HAS
 *
 */

#include "hostcallbacks.h"

// TO CHECK: what is correct thing to do if UPP is null? (currently raises Python error)

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
	PyObject *callbacksObj;
	CallbacksRef callbacks = NULL;
	OSErr err;
	AEEventClass theAEEventClass;
	AEEventID theAEEventID;
	AEAddressDesc target;
	AEReturnID returnID;
	AETransactionID transactionID;
	AppleEvent result;
	
	if (!PyArg_ParseTuple(args, "O&O&O&hlO",
								PyMac_GetOSType, &theAEEventClass,
								PyMac_GetOSType, &theAEEventID,
								AEDescX_Convert, &target,
								&returnID,
								&transactionID,
								&callbacksObj)) return NULL;
	fprintf(stderr, "*****invokeCreateProc callbackobj=%08x\n", (int)callbacksObj);
	PyObject_Print(callbacksObj, stdout, 0);
	fprintf(stderr, "\n\n");
	if (PyCObject_Check(callbacksObj))
		callbacks = (CallbacksRef)PyCObject_AsVoidPtr(callbacksObj);
	else
		fprintf(stderr, "not a COBJECT!\n");
	fprintf(stderr, "    callbacks=%08\n", callbacks);
	if (!callbacks) return PyMac_Error(9999);
	fprintf(stderr, "invoking createproc: \n\t code=(%04x %04x) \n\t target=%04x \n\t refcon=%08x \n\t callback = %08x\n",
			theAEEventClass, theAEEventID, target.descriptorType, 
			(int)callbacks->createRefCon,
			(int)callbacks->createProc);
	if (!callbacks || !(callbacks->createProc)) return PyMac_Error(8000);
	err = InvokeOSACreateAppleEventUPP(theAEEventClass,
										theAEEventID,
										&target,
										returnID,
										transactionID,
										&result,
										callbacks->createRefCon,
										callbacks->createProc);
	fprintf(stderr, "    done\n");
	if (err) return PyMac_Error(err);
	return Py_BuildValue("O&", AEDescX_New, &result);
}


static PyObject* invokeSendProc(PyObject *self, PyObject *args) {
	PyObject *callbacksObj;
	CallbacksRef callbacks = NULL;
	OSErr err;
	AppleEvent theAppleEvent, reply;
	AESendMode sendMode;
	long timeOutInTicks;
	
	if (!PyArg_ParseTuple(args, "O&llO",
								AEDescX_Convert, &theAppleEvent,
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
	return Py_BuildValue("O&", AEDescX_New, &reply);
}


static PyObject* invokeContinueProc(PyObject *self, PyObject *args) { 
	return NULL; // TO DO
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
	}
	callbacks = malloc(sizeof(Callbacks));
	callbacks->activeProc = defaultActiveProc;
	callbacks->createProc = defaultCreateProc;
	callbacks->sendProc = defaultSendProc;
	return PyCObject_FromVoidPtr((void *)callbacks, free);
}



void importCallbacksModule(void) {
	Py_InitModule("pyosa_hostcallbacks", PyOSA_callbacks);
}

