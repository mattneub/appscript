/*
 * selectors.h
 * PyOSA
 *
 * Copyright (C) 2007 HAS
 *
 *
 * Implements the OSA functions used by clients to interact with component, and
 * provides a function, getComponentFunction, for retrieving pointers to them.
 * (i.e. Carbon Component Manager components expose their functionality via
 * a single C function, which in PyOSA is PyOSA_main defined in main.c)
 *
 */

#include <Carbon/Carbon.h>
#include "pythonerrors.h"



/* Stores all the information describing a single component function. */
typedef struct {
	char *name; /* name of function; used for debug messages */
	SInt16 selector; /* the selector that requests this function */
	ProcPtr procPtr; /* the function */
	ProcInfoType procInfo; /* parameter info used to construct a UPP */
	ComponentFunctionUPP componentFunctionUPP; /* the function UPP; initialised on the first getComponentFunction call */
} ComponentFunctionDef;


ComponentFunctionUPP getComponentFunction(SInt16 selector);


