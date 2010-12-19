
#include <Carbon/Carbon.h>

#include "osafunctions.h"

#define COMPONENT_IDENTIFIER "net.sourceforge.appscript.pyosa"



/******************************************************************************/
/* handleComponentOpen() */
/******************************************************************************/


static ComponentResult handleComponentOpen(ComponentInstance ci) {
	OSErr err;
	CIStorageHandle ciStorage;
	
	#ifdef DEBUG_ON
	fprintf(stderr, "PyOSA: opening component instance\n");
	#endif
	if (!loadPythonFramework()) return errOSACantOpenComponent;
	err = createComponentInstanceStorage(&ciStorage);
	if (err) return errOSACantOpenComponent;
	SetComponentInstanceStorage(ci, (Handle)ciStorage);
	#ifdef DEBUG_ON
	fprintf(stderr, "...done.\n");
	#endif
	return noErr;
}


/******************************************************************************/
/* component's entry point */
/******************************************************************************/

ComponentResult PyOSA_main(ComponentParameters *params, Handle ciStorage) {
	/*
		Every component exports a single named function as its entry point. 
		Component Manager calls this function to access the component's services.
	*/
	ComponentResult err;
	SInt16 selector;
	ComponentFunctionUPP componentFunctionUPP;
	
	selector = params->what;
	componentFunctionUPP = getComponentFunction(selector);
	if (componentFunctionUPP)
		err = CallComponentFunctionWithStorage(ciStorage, params, componentFunctionUPP);
	else if (selector == kComponentOpenSelect)
		err = handleComponentOpen((ComponentInstance)(params->params[0]));
	else {
		fprintf(stderr, "PyOSA: unsupported selector: %i\n", selector);
		err = badComponentSelector;
	}
	#ifdef DEBUG_ON
	if (err) fprintf(stderr, "PyOSA_main returned error: %i\n", err);
	#endif
	return err;
}


