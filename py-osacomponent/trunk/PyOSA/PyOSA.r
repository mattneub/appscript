/*
** PyOSA -- OSA language component for Python.
**
** (C) 2007 HAS
**
** References: 
** - IM: More Macintosh Toolbox: Component Manager (note: some of this is out-of-date)
** - OSA headers and Carbon documentation
*/

#define thng_RezTemplateVersion 1

#include <Carbon/Carbon.r>

#define COMPONENT_VERSION 0x00010000

#define COMPONENT_FLAGS 0x0000015E

/* 
	ResourceSpec: // identifies a resource
		OSType resType, SInt16 resID
	
	componentRegisterFlags: // constants describing additional registration information
		componentDoAutoVersion = 1;
		componentWantsUnregister = 2;
		componentAutoVersionIncludeFlags = 4;
		componentHasMultiplePlatforms = 8;
		componentLoadResident = 16;
	
	componentFlags: // constants describing component's available services
		kOSASupportsCompiling = $0002;
		kOSASupportsGetSource = $0004;
		kOSASupportsAECoercion = $0008;
		kOSASupportsAESending = $0010;
		kOSASupportsRecording = $0020;
		kOSASupportsConvenience = $0040;
		kOSASupportsDialects = $0080; // not used
		kOSASupportsEventHandling = $0100;
	
	[note: SE doesn't seem to heed these flags or componentCanDo() when manipulating scripts]
*/

resource 'thng' (128) {
	/* ComponentDescription */
    'osa ',								// OSType componentType
    'PyOC',								// OSType componentSubType
    'HHAS', 							// OSType componentManufacturer
	COMPONENT_FLAGS,					// long componentFlags				// flags describing component's available services
    0,									// unsigned long componentFlagsMask	// (kAnyComponentFlagsMask = 0)
    /* ComponentResource */
	'dlle', 128,						// ResourceSpec component			// resource ID for name of component's entry point
    'STR ', 128,						// ResourceSpec componentName
    'STR ', 129,						// ResourceSpec componentInfo
    'ICON', 0,							// ResourceSpec componentIcon
	/* ComponentResourceExtension */
    COMPONENT_VERSION,					// SInt32 componentVersion
    componentHasMultiplePlatforms,		// SInt32 componentRegisterFlags	// must include componentHasMultiplePlatforms
    0,									// SInt16 componentIconFamily
    { /* ComponentPlatformInfo */
		COMPONENT_FLAGS,				// long componentFlags
		'dlle', 128,					// ResourceSpec component
#if defined(ppc_YES)
		platformPowerPCNativeEntryPoint	// SInt16 platformType
#else
		platformIA32NativeEntryPoint	// SInt16 platformType
#endif
	}
};

resource 'dlle' (128) {
	"PyOSA_main"						// name of function which provides component's entry point
};


resource 'STR ' (128) {
    "PyOSA"								// component's name
};


resource 'STR ' (129) {
	"PyOSA Scripting Component"			// component's description
};
