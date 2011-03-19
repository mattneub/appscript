/*
 * SEReferenceGlue.h
 * /System/Library/CoreServices/System Events.app
 * osaglue 0.5.1
 *
 */

#import <Foundation/Foundation.h>
#import "Appscript/Appscript.h"
#import "SECommandGlue.h"
#import "SEReferenceRendererGlue.h"
#define SEApp ((SEReference *)[SEReference referenceWithAppData: nil aemReference: AEMApp])
#define SECon ((SEReference *)[SEReference referenceWithAppData: nil aemReference: AEMCon])
#define SEIts ((SEReference *)[SEReference referenceWithAppData: nil aemReference: AEMIts])

@interface SEReference : ASReference

/* +app, +con, +its methods can be used in place of SEApp, SECon, SEIts macros */

+ (SEReference *)app;
+ (SEReference *)con;
+ (SEReference *)its;

/* ********************************* */

- (NSString *)description;

/* Commands */

- (SEAbortTransaction_Command *)abortTransaction_;
- (SEAbortTransaction_Command *)abortTransaction_:(id)directParameter;
- (SEActivateCommand *)activate;
- (SEActivateCommand *)activate:(id)directParameter;
- (SEAttachActionToCommand *)attachActionTo;
- (SEAttachActionToCommand *)attachActionTo:(id)directParameter;
- (SEAttachedScriptsCommand *)attachedScripts;
- (SEAttachedScriptsCommand *)attachedScripts:(id)directParameter;
- (SEBeginTransaction_Command *)beginTransaction_;
- (SEBeginTransaction_Command *)beginTransaction_:(id)directParameter;
- (SECancelCommand *)cancel;
- (SECancelCommand *)cancel:(id)directParameter;
- (SEClickCommand *)click;
- (SEClickCommand *)click:(id)directParameter;
- (SECloseCommand *)close;
- (SECloseCommand *)close:(id)directParameter;
- (SEConfirmCommand *)confirm;
- (SEConfirmCommand *)confirm:(id)directParameter;
- (SEConnectCommand *)connect;
- (SEConnectCommand *)connect:(id)directParameter;
- (SECountCommand *)count;
- (SECountCommand *)count:(id)directParameter;
- (SEDecrementCommand *)decrement;
- (SEDecrementCommand *)decrement:(id)directParameter;
- (SEDeleteCommand *)delete;
- (SEDeleteCommand *)delete:(id)directParameter;
- (SEDisconnectCommand *)disconnect;
- (SEDisconnectCommand *)disconnect:(id)directParameter;
- (SEDoFolderActionCommand *)doFolderAction;
- (SEDoFolderActionCommand *)doFolderAction:(id)directParameter;
- (SEDoScriptCommand *)doScript;
- (SEDoScriptCommand *)doScript:(id)directParameter;
- (SEDuplicateCommand *)duplicate;
- (SEDuplicateCommand *)duplicate:(id)directParameter;
- (SEEditActionOfCommand *)editActionOf;
- (SEEditActionOfCommand *)editActionOf:(id)directParameter;
- (SEEndTransaction_Command *)endTransaction_;
- (SEEndTransaction_Command *)endTransaction_:(id)directParameter;
- (SEExistsCommand *)exists;
- (SEExistsCommand *)exists:(id)directParameter;
- (SEGetCommand *)get;
- (SEGetCommand *)get:(id)directParameter;
- (SEIncrementCommand *)increment;
- (SEIncrementCommand *)increment:(id)directParameter;
- (SEKeyCodeCommand *)keyCode;
- (SEKeyCodeCommand *)keyCode:(id)directParameter;
- (SEKeyDownCommand *)keyDown;
- (SEKeyDownCommand *)keyDown:(id)directParameter;
- (SEKeyUpCommand *)keyUp;
- (SEKeyUpCommand *)keyUp:(id)directParameter;
- (SEKeystrokeCommand *)keystroke;
- (SEKeystrokeCommand *)keystroke:(id)directParameter;
- (SELaunchCommand *)launch;
- (SELaunchCommand *)launch:(id)directParameter;
- (SELogOutCommand *)logOut;
- (SELogOutCommand *)logOut:(id)directParameter;
- (SEMakeCommand *)make;
- (SEMakeCommand *)make:(id)directParameter;
- (SEMoveCommand *)move;
- (SEMoveCommand *)move:(id)directParameter;
- (SEOpenCommand *)open;
- (SEOpenCommand *)open:(id)directParameter;
- (SEOpenLocationCommand *)openLocation;
- (SEOpenLocationCommand *)openLocation:(id)directParameter;
- (SEPerformCommand *)perform;
- (SEPerformCommand *)perform:(id)directParameter;
- (SEPickCommand *)pick;
- (SEPickCommand *)pick:(id)directParameter;
- (SEPrintCommand *)print;
- (SEPrintCommand *)print:(id)directParameter;
- (SEQuitCommand *)quit;
- (SEQuitCommand *)quit:(id)directParameter;
- (SERemoveActionFromCommand *)removeActionFrom;
- (SERemoveActionFromCommand *)removeActionFrom:(id)directParameter;
- (SEReopenCommand *)reopen;
- (SEReopenCommand *)reopen:(id)directParameter;
- (SERestartCommand *)restart;
- (SERestartCommand *)restart:(id)directParameter;
- (SERunCommand *)run;
- (SERunCommand *)run:(id)directParameter;
- (SESaveCommand *)save;
- (SESaveCommand *)save:(id)directParameter;
- (SESelectCommand *)select;
- (SESelectCommand *)select:(id)directParameter;
- (SESetCommand *)set;
- (SESetCommand *)set:(id)directParameter;
- (SEShutDownCommand *)shutDown;
- (SEShutDownCommand *)shutDown:(id)directParameter;
- (SESleepCommand *)sleep;
- (SESleepCommand *)sleep:(id)directParameter;

/* Elements */

- (SEReference *)CDAndDVDPreferencesObject;
- (SEReference *)ClassicDomainObjects;
- (SEReference *)QuickTimeData;
- (SEReference *)QuickTimeFiles;
- (SEReference *)UIElements;
- (SEReference *)XMLAttributes;
- (SEReference *)XMLData;
- (SEReference *)XMLElements;
- (SEReference *)XMLFiles;
- (SEReference *)actions;
- (SEReference *)aliases;
- (SEReference *)annotation;
- (SEReference *)appearancePreferencesObject;
- (SEReference *)applicationProcesses;
- (SEReference *)applications;
- (SEReference *)attachment;
- (SEReference *)attributeRuns;
- (SEReference *)attributes;
- (SEReference *)audioData;
- (SEReference *)audioFiles;
- (SEReference *)browsers;
- (SEReference *)busyIndicators;
- (SEReference *)buttons;
- (SEReference *)characters;
- (SEReference *)checkboxes;
- (SEReference *)colorWells;
- (SEReference *)colors;
- (SEReference *)columns;
- (SEReference *)comboBoxes;
- (SEReference *)configurations;
- (SEReference *)deskAccessoryProcesses;
- (SEReference *)desktops;
- (SEReference *)diskItems;
- (SEReference *)disks;
- (SEReference *)dockPreferencesObject;
- (SEReference *)documents;
- (SEReference *)domains;
- (SEReference *)drawers;
- (SEReference *)exposePreferencesObject;
- (SEReference *)filePackages;
- (SEReference *)files;
- (SEReference *)folderActions;
- (SEReference *)folders;
- (SEReference *)groups;
- (SEReference *)growAreas;
- (SEReference *)images;
- (SEReference *)incrementors;
- (SEReference *)insertionPreference;
- (SEReference *)interfaces;
- (SEReference *)items;
- (SEReference *)lists;
- (SEReference *)localDomainObjects;
- (SEReference *)locations;
- (SEReference *)loginItems;
- (SEReference *)menuBarItems;
- (SEReference *)menuBars;
- (SEReference *)menuButtons;
- (SEReference *)menuItems;
- (SEReference *)menus;
- (SEReference *)movieData;
- (SEReference *)movieFiles;
- (SEReference *)networkDomainObjects;
- (SEReference *)networkPreferencesObject;
- (SEReference *)outlines;
- (SEReference *)paragraphs;
- (SEReference *)popUpButtons;
- (SEReference *)printSettings;
- (SEReference *)processes;
- (SEReference *)progressIndicators;
- (SEReference *)propertyListFiles;
- (SEReference *)propertyListItems;
- (SEReference *)radioButtons;
- (SEReference *)radioGroups;
- (SEReference *)relevanceIndicators;
- (SEReference *)rows;
- (SEReference *)screenCorner;
- (SEReference *)scripts;
- (SEReference *)scrollAreas;
- (SEReference *)scrollBars;
- (SEReference *)securityPreferencesObject;
- (SEReference *)services;
- (SEReference *)sheets;
- (SEReference *)shortcut;
- (SEReference *)sliders;
- (SEReference *)spacesPreferencesObject;
- (SEReference *)spacesShortcut;
- (SEReference *)splitterGroups;
- (SEReference *)splitters;
- (SEReference *)staticTexts;
- (SEReference *)systemDomainObjects;
- (SEReference *)tabGroups;
- (SEReference *)tables;
- (SEReference *)text;
- (SEReference *)textAreas;
- (SEReference *)textFields;
- (SEReference *)toolBars;
- (SEReference *)tracks;
- (SEReference *)userDomainObjects;
- (SEReference *)users;
- (SEReference *)valueIndicators;
- (SEReference *)windows;
- (SEReference *)words;

/* Properties */

- (SEReference *)CDAndDVDPreferences;
- (SEReference *)Classic;
- (SEReference *)ClassicDomain;
- (SEReference *)FolderActionScriptsFolder;
- (SEReference *)MACAddress;
- (SEReference *)POSIXPath;
- (SEReference *)UIElementsEnabled;
- (SEReference *)URL;
- (SEReference *)acceptsHighLevelEvents;
- (SEReference *)acceptsRemoteEvents;
- (SEReference *)accountName;
- (SEReference *)active;
- (SEReference *)activity;
- (SEReference *)allWindowsShortcut;
- (SEReference *)animate;
- (SEReference *)appearance;
- (SEReference *)appearancePreferences;
- (SEReference *)appleMenuFolder;
- (SEReference *)applicationBindings;
- (SEReference *)applicationFile;
- (SEReference *)applicationSupportFolder;
- (SEReference *)applicationWindowsShortcut;
- (SEReference *)applicationsFolder;
- (SEReference *)architecture;
- (SEReference *)arrowKeyModifiers;
- (SEReference *)audioChannelCount;
- (SEReference *)audioCharacteristic;
- (SEReference *)audioSampleRate;
- (SEReference *)audioSampleSize;
- (SEReference *)autoPlay;
- (SEReference *)autoPresent;
- (SEReference *)autoQuitWhenDone;
- (SEReference *)autohide;
- (SEReference *)automatic;
- (SEReference *)automaticLogin;
- (SEReference *)backgroundOnly;
- (SEReference *)blankCD;
- (SEReference *)blankDVD;
- (SEReference *)bottomLeftScreenCorner;
- (SEReference *)bottomRightScreenCorner;
- (SEReference *)bounds;
- (SEReference *)bundleIdentifier;
- (SEReference *)busyStatus;
- (SEReference *)capacity;
- (SEReference *)changeInterval;
- (SEReference *)class_;
- (SEReference *)closeable;
- (SEReference *)collating;
- (SEReference *)color;
- (SEReference *)connected;
- (SEReference *)container;
- (SEReference *)contents;
- (SEReference *)controlPanelsFolder;
- (SEReference *)controlStripModulesFolder;
- (SEReference *)copies;
- (SEReference *)creationDate;
- (SEReference *)creationTime;
- (SEReference *)creatorType;
- (SEReference *)currentConfiguration;
- (SEReference *)currentDesktop;
- (SEReference *)currentLocation;
- (SEReference *)currentUser;
- (SEReference *)customApplication;
- (SEReference *)customScript;
- (SEReference *)dashboardShortcut;
- (SEReference *)dataFormat;
- (SEReference *)dataRate;
- (SEReference *)dataSize;
- (SEReference *)defaultApplication;
- (SEReference *)description_;
- (SEReference *)deskAccessoryFile;
- (SEReference *)desktopFolder;
- (SEReference *)desktopPicturesFolder;
- (SEReference *)dimensions;
- (SEReference *)displayName;
- (SEReference *)displayedName;
- (SEReference *)dockPreferences;
- (SEReference *)dockSize;
- (SEReference *)document;
- (SEReference *)documentsFolder;
- (SEReference *)doubleClickMinimizes;
- (SEReference *)downloadsFolder;
- (SEReference *)duplex;
- (SEReference *)duration;
- (SEReference *)ejectable;
- (SEReference *)enabled;
- (SEReference *)endingPage;
- (SEReference *)entireContents;
- (SEReference *)errorHandling;
- (SEReference *)exposePreferences;
- (SEReference *)extensionsFolder;
- (SEReference *)favoritesFolder;
- (SEReference *)faxNumber;
- (SEReference *)file;
- (SEReference *)fileName;
- (SEReference *)fileType;
- (SEReference *)floating;
- (SEReference *)focused;
- (SEReference *)folderActionsEnabled;
- (SEReference *)font;
- (SEReference *)fontSmoothingLimit;
- (SEReference *)fontSmoothingStyle;
- (SEReference *)fontsFolder;
- (SEReference *)format;
- (SEReference *)freeSpace;
- (SEReference *)frontmost;
- (SEReference *)fullName;
- (SEReference *)fullText;
- (SEReference *)functionKey;
- (SEReference *)functionKeyModifiers;
- (SEReference *)hasScriptingTerminology;
- (SEReference *)help_;
- (SEReference *)hidden;
- (SEReference *)highQuality;
- (SEReference *)highlightColor;
- (SEReference *)homeDirectory;
- (SEReference *)homeFolder;
- (SEReference *)href;
- (SEReference *)id_;
- (SEReference *)ignorePrivileges;
- (SEReference *)index;
- (SEReference *)insertionAction;
- (SEReference *)interface;
- (SEReference *)keyModifiers;
- (SEReference *)kind;
- (SEReference *)launcherItemsFolder;
- (SEReference *)libraryFolder;
- (SEReference *)localDomain;
- (SEReference *)localVolume;
- (SEReference *)location;
- (SEReference *)logOutWhenInactive;
- (SEReference *)logOutWhenInactiveInterval;
- (SEReference *)looping;
- (SEReference *)magnification;
- (SEReference *)magnificationSize;
- (SEReference *)maximumValue;
- (SEReference *)miniaturizable;
- (SEReference *)miniaturized;
- (SEReference *)minimizeEffect;
- (SEReference *)minimumValue;
- (SEReference *)modal;
- (SEReference *)modificationDate;
- (SEReference *)modificationTime;
- (SEReference *)modified;
- (SEReference *)modifiers;
- (SEReference *)mouseButton;
- (SEReference *)mouseButtonModifiers;
- (SEReference *)moviesFolder;
- (SEReference *)mtu;
- (SEReference *)musicCD;
- (SEReference *)musicFolder;
- (SEReference *)name;
- (SEReference *)nameExtension;
- (SEReference *)naturalDimensions;
- (SEReference *)networkDomain;
- (SEReference *)networkPreferences;
- (SEReference *)numbersKeyModifiers;
- (SEReference *)orientation;
- (SEReference *)packageFolder;
- (SEReference *)pagesAcross;
- (SEReference *)pagesDown;
- (SEReference *)partitionSpaceUsed;
- (SEReference *)path;
- (SEReference *)physicalSize;
- (SEReference *)picture;
- (SEReference *)pictureCD;
- (SEReference *)picturePath;
- (SEReference *)pictureRotation;
- (SEReference *)picturesFolder;
- (SEReference *)position;
- (SEReference *)preferencesFolder;
- (SEReference *)preferredRate;
- (SEReference *)preferredVolume;
- (SEReference *)presentationMode;
- (SEReference *)presentationSize;
- (SEReference *)previewDuration;
- (SEReference *)previewTime;
- (SEReference *)productVersion;
- (SEReference *)properties;
- (SEReference *)publicFolder;
- (SEReference *)quitDelay;
- (SEReference *)randomOrder;
- (SEReference *)recentApplicationsLimit;
- (SEReference *)recentDocumentsLimit;
- (SEReference *)recentServersLimit;
- (SEReference *)requestedPrintTime;
- (SEReference *)requirePasswordToUnlock;
- (SEReference *)requirePasswordToWake;
- (SEReference *)resizable;
- (SEReference *)role;
- (SEReference *)scriptMenuEnabled;
- (SEReference *)scriptingAdditionsFolder;
- (SEReference *)scriptsFolder;
- (SEReference *)scrollArrowPlacement;
- (SEReference *)scrollBarAction;
- (SEReference *)secureVirtualMemory;
- (SEReference *)securityPreferences;
- (SEReference *)selected;
- (SEReference *)server;
- (SEReference *)settable;
- (SEReference *)sharedDocumentsFolder;
- (SEReference *)shortName;
- (SEReference *)shortVersion;
- (SEReference *)showDesktopShortcut;
- (SEReference *)showSpacesShortcut;
- (SEReference *)shutdownFolder;
- (SEReference *)sitesFolder;
- (SEReference *)size;
- (SEReference *)smoothScrolling;
- (SEReference *)spacesColumns;
- (SEReference *)spacesEnabled;
- (SEReference *)spacesPreferences;
- (SEReference *)spacesRows;
- (SEReference *)speakableItemsFolder;
- (SEReference *)speed;
- (SEReference *)startTime;
- (SEReference *)startingPage;
- (SEReference *)startup;
- (SEReference *)startupDisk;
- (SEReference *)startupItemsFolder;
- (SEReference *)stationery;
- (SEReference *)storedStream;
- (SEReference *)subrole;
- (SEReference *)systemDomain;
- (SEReference *)systemFolder;
- (SEReference *)targetPrinter;
- (SEReference *)temporaryItemsFolder;
- (SEReference *)timeScale;
- (SEReference *)title;
- (SEReference *)titled;
- (SEReference *)topLeftScreenCorner;
- (SEReference *)topRightScreenCorner;
- (SEReference *)totalPartitionSize;
- (SEReference *)trash;
- (SEReference *)type;
- (SEReference *)typeClass;
- (SEReference *)typeIdentifier;
- (SEReference *)unixId;
- (SEReference *)userDomain;
- (SEReference *)utilitiesFolder;
- (SEReference *)value;
- (SEReference *)version_;
- (SEReference *)videoDVD;
- (SEReference *)videoDepth;
- (SEReference *)visible;
- (SEReference *)visualCharacteristic;
- (SEReference *)volume;
- (SEReference *)workflowsFolder;
- (SEReference *)zone;
- (SEReference *)zoomable;
- (SEReference *)zoomed;

/* ********************************* */


/* ordinal selectors */

- (SEReference *)first;
- (SEReference *)middle;
- (SEReference *)last;
- (SEReference *)any;

/* by-index, by-name, by-id selectors */

- (SEReference *)at:(long)index;
- (SEReference *)byIndex:(id)index;
- (SEReference *)byName:(id)name;
- (SEReference *)byID:(id)id_;

/* by-relative-position selectors */

- (SEReference *)previous:(ASConstant *)class_;
- (SEReference *)next:(ASConstant *)class_;

/* by-range selector */

- (SEReference *)at:(long)fromIndex to:(long)toIndex;
- (SEReference *)byRange:(id)fromObject to:(id)toObject;

/* by-test selector */

- (SEReference *)byTest:(SEReference *)testReference;

/* insertion location selectors */

- (SEReference *)beginning;
- (SEReference *)end;
- (SEReference *)before;
- (SEReference *)after;

/* Comparison and logic tests */

- (SEReference *)greaterThan:(id)object;
- (SEReference *)greaterOrEquals:(id)object;
- (SEReference *)equals:(id)object;
- (SEReference *)notEquals:(id)object;
- (SEReference *)lessThan:(id)object;
- (SEReference *)lessOrEquals:(id)object;
- (SEReference *)beginsWith:(id)object;
- (SEReference *)endsWith:(id)object;
- (SEReference *)contains:(id)object;
- (SEReference *)isIn:(id)object;
- (SEReference *)AND:(id)remainingOperands;
- (SEReference *)OR:(id)remainingOperands;
- (SEReference *)NOT;
@end

