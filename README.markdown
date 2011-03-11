WURFL - CFWheels
========================

[wurfl]: http://wurfl.sourceforge.net/ "WURFL"
[jardownload]: http://sourceforge.net/projects/wurfl/ "Download jars"

The WURFL file is an XML configuration file that contains information on mobile devices such as capabilities and features. The WURFL file is maintained by Luca Passini. More information can be found at [http://wurfl.sourceforge.net][wurfl]. This plugin is a wrapper around the great Java API for accessing information from the WURFL file.

Installation
------------
Before using the plugin, you need to add the WURFL jar file into your class path (e.g. the `lib/` folder in tomcat). This can be found here: [http://sourceforge.net/projects/wurfl/][jardownload]  You will need to restart your CF server to load it. Make sure you download the WURFL file and any patches you want to include. These can be found on the [main site][wurfl]. For this plugin, patches are expected to all be in the same folder.

Since the WURFL API also needs to know where the XML file is, you'll need to set this in you settings. Go to `settings.cfm` in the `config` folder and add these entries:

	set(wurflFile="/Path/To/wurfl.xml");
	set(patchesFolder="/Path/To/patches");
	
Note: The patchesFolder settings is optional. If you're not using patches, simply don't include it. There are also optional settings to use fallback locations for the WURFL file. These could potentially be used in cases where you're accessing the WURFL over a mounted network drive and it fails. It will fallback to these locations:

	set(wurflFileFallBack="/Path/To/Fallback/wurfl.xml");
	set(patchesFolderFallBack="/Path/To/Fallback/patches");
	
You should be ready to start using the wrapper functions. Please note that the WURFL index is rather large, so the java object is stored in the server scope for fast access, and would be used across all sites using it on your server. It may be slow on first usage depending on your setup.

Usage
----------

The WURFL plugin exposes all of the methods that the java API provides. These are injected globally, so you should be able to access them everywhere:

### `getWURFLCapability(capability,[userAgent])`

Get a particular capability for a device. Optionally pass a user-agent string. Defaults to `cgi.HTTP_USER_AGENT`. The following example would return a boolean value depending on if the device is mobile:

	getWURFLCapability('is_wireless_device')
	
### `getWURFLCapabilities([userAgent])`

Get all capabilities for a device. Optionally pass a user-agent string. Defaults to `cgi.HTTP_USER_AGENT`. Warning: This is large.

### `getWURFLMarkup([userAgent])`

Get markup for a device. Optionally pass a user-agent string. Defaults to `cgi.HTTP_USER_AGENT`.

### `getWURFLId([userAgent])`

Get the WURFL ID for a device. Optionally pass a user-agent string. Defaults to `cgi.HTTP_USER_AGENT`.

### `getWURFLUserAgent([userAgent])`

Get the user agent string the WURFL uses for a device. Optionally pass a user-agent string. Defaults to `cgi.HTTP_USER_AGENT`.

### `reinitializeWURFL()`

Re-initializes the WURFLManger and reads in the WURFL file on disk again.

Building From Source
--------------------

	rake build

History
------------

Version 0.1 - Initial Release

Version 0.2 - Added Ability to reload the index when the application is reloaded

Version 0.2.1 - Uses cflock now to ensure no data corruption