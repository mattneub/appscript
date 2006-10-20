/*
MacPythonOSA -- OSA language component for MacPython.

(C) 2005 HAS 
*/


/* References: IM: More Macintosh Toolbox: Component Manager (note: some of this is out-of-date; see also OSA headers and Carbon documentation) */

#define UseExtendedThingResource 1

#include <Carbon/Carbon.r>

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

#define componentFlags 0x0000017E

resource 'thng' (128) {
	/* ComponentDescription */
    'osa ',								// OSType componentType
    'McPy',								// OSType componentSubType
    'HHAS', 							// OSType componentManufacturer
	componentFlags,						// long componentFlags				// flags describing component's available services
    0,									// unsigned long componentFlagsMask	// (kAnyComponentFlagsMask = 0)
    /* ComponentResource */
	'dlle', 128,						// ResourceSpec component			// resource ID for name of component's entry point
    'STR ', 128,						// ResourceSpec componentName
    'STR ', 129,						// ResourceSpec componentInfo
    'ICON', 0,							// ResourceSpec componentIcon
	/* ComponentResourceExtension */
    0x00010000,							// SInt32 componentVersion
    8,									// SInt32 componentRegisterFlags	// must include componentHasMultiplePlatforms
    0,									// SInt16 componentIconFamily
    { /* ComponentPlatformInfo */
		componentFlags,					// long componentFlags
		'dlle', 128,					// ResourceSpec component
		1000							// SInt16 platformType
		}
    };

resource 'dlle' (128) {
    "MacPythonOSA_centralDispatch"		// name of function which provides component's entry point
    };


resource 'STR ' (128) {
    "MacPythonOSA"						// component's name
    };


resource 'STR ' (129) {
    "MacPythonOSA Scripting Component"	// component's description
    };
