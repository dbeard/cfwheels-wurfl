<cfcomponent displayname="WURFL Helper" output="false">
	
	<cffunction name="init">
        <cfset this.version = "1.1,1.1.1,1.1.2">
        <cfreturn this>
    </cffunction>
	
	<cffunction name="getWURFLCapability" returntype="any">
		<cfargument name="capability" type="string" required="true"/>
		<cfargument name="userAgent" type="string" default="#cgi.HTTP_USER_AGENT#"/>
		
		<cfset device = $getWURFLManager().getDeviceForRequest(Trim(arguments.userAgent))/>
		
		<cfreturn device.getCapability(Trim(arguments.capability))/>
	</cffunction> 
	
	<cffunction name="getWURFLCapabilities" returntype="any">
		<cfargument name="userAgent" type="string" default="#cgi.HTTP_USER_AGENT#"/>
		
		<cfset device = $getWURFLManager().getDeviceForRequest(Trim(arguments.userAgent))/>
		
		<cfreturn device.getCapabilities()/>
	</cffunction>
	
	<cffunction name="getWURFLMarkup" returntype="any">
		<cfargument name="userAgent" type="string" default="#cgi.HTTP_USER_AGENT#"/>
		
		<cfset device = $getWURFLManager().getDeviceForRequest(Trim(arguments.userAgent))/>
		
		<cfreturn device.getMarkUp()/>
	</cffunction>
	
	<cffunction name="getWURFLId" returntype="any">
		<cfargument name="userAgent" type="string" default="#cgi.HTTP_USER_AGENT#"/>
		
		<cfset device = $getWURFLManager().getDeviceForRequest(Trim(arguments.userAgent))/>
		
		<cfreturn device.getId()/>
	</cffunction>
	
	<cffunction name="getWURFLUserAgent" returntype="any">
		<cfargument name="userAgent" type="string" default="#cgi.HTTP_USER_AGENT#"/>
		
		<cfset device = $getWURFLManager().getDeviceForRequest(Trim(arguments.userAgent))/>
		
		<cfreturn device.getUserAgent()/>
	</cffunction>
	
	<cffunction name="reinitializeWURFL" returntype="void">
		<cfscript>$getWURFLManager(true);</cfscript>
	</cffunction>
	
	<cffunction name="$getWURFLManager" returntype="any">
		<cfargument name="reinitialize" type="boolean" default="false"/>
		
		<cfif !isDefined("server.wurflManager") OR arguments.reinitialize>
			<!--- We need to create the wurfl manager --->
			<cfscript>
				
				wurflFile = "";
				
				try{
					if(FileExists(get('wurflFile'))){
						wurflFile = get('wurflFile');
					}
					else if(FileExists(get('wurflFileFallBack'))){
						wurflFile = get('wurflFileFallBack');
					}
					else{
						throw();
					}
				}
				catch(any e){
					//Always fail if no wurfl is found
					throw(message="WURFL file could not be found");
				}
				
				patchesFolder = "";
				
				try{
					if(FileExists(get('patchesFolder'))){
						patchesFolder = get('patchesFolder');
					}
					else if(FileExists(get('patchesFolderFallBack'))){
						patchesFolder = get('patchesFolderFallBack');
					}
					else{
						throw();
					}
				}
				catch(any e){ 
					//Fail Silently
				}
				
				wurflFileJ = createObject("java","java.io.File").init(wurflFile);
				wurflHolder = "";
				
				if(patchesFolder eq ""){
					wurflHolder = createObject("java","net.sourceforge.wurfl.core.CustomWURFLHolder").init(wurflFileJ);
				}
				else{
					//There is a patches folder
					patchesFolderJ = createObject("java","java.io.File").init(patchesFolder);
					patchFiles = patchesFolderJ.listFiles();
					wurflHolder = createObject("java","net.sourceforge.wurfl.core.CustomWURFLHolder").init(wurflFileJ,patchFiles);
				}

				server.wurflManager = wurflHolder.getWURFLManager();
			</cfscript>
		</cfif>
		
		<cfreturn server.wurflManager/>
		
	</cffunction>
	
</cfcomponent>