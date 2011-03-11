<cfcomponent displayname="WURFL Helper" output="false">
	
	<cffunction name="init">
        <cfset this.version = "1.1,1.1.1,1.1.2">
		
		<cfif structKeyExists(server,"wurflManager")>
			<cflock timeout="5" scope="server">
				<cfset structDelete(server,"wurflManager")/>
			</cflock>
		</cfif>
		
        <cfreturn this>
    </cffunction>
	
	<cffunction name="getWURFLCapability" returntype="any">
		<cfargument name="capability" type="string" required="true"/>
		<cfargument name="userAgent" type="string" default="#cgi.HTTP_USER_AGENT#"/>
		
		<cflock timeout="5" scope="server">
			<cfset device = $getWURFLManager().getDeviceForRequest(Trim(arguments.userAgent))/>
			<cfset ret = device.getCapability(Trim(arguments.capability))/>
		</cflock>
		
		<cfreturn ret/>
	</cffunction> 
	
	<cffunction name="getWURFLCapabilities" returntype="any">
		<cfargument name="userAgent" type="string" default="#cgi.HTTP_USER_AGENT#"/>
		
		<cflock timeout="5" scope="server">
			<cfset device = $getWURFLManager().getDeviceForRequest(Trim(arguments.userAgent))/>
			<cfset ret = device.getCapabilities()/>
		</cflock>
		
		<cfreturn ret/>
	</cffunction>
	
	<cffunction name="getWURFLMarkup" returntype="any">
		<cfargument name="userAgent" type="string" default="#cgi.HTTP_USER_AGENT#"/>

		<cflock timeout="5" scope="server">
			<cfset device = $getWURFLManager().getDeviceForRequest(Trim(arguments.userAgent))/>
			<cfset ret = device.getMarkUp()/>
		</cflock>
		
		<cfreturn ret/>
	</cffunction>
	
	<cffunction name="getWURFLId" returntype="any">
		<cfargument name="userAgent" type="string" default="#cgi.HTTP_USER_AGENT#"/>
		
		<cflock timeout="5" scope="server">
			<cfset device = $getWURFLManager().getDeviceForRequest(Trim(arguments.userAgent))/>
			<cfset ret = device.getId()/>
		</cflock>
		
		<cfreturn ret/>
	</cffunction>
	
	<cffunction name="getWURFLUserAgent" returntype="any">
		<cfargument name="userAgent" type="string" default="#cgi.HTTP_USER_AGENT#"/>
		
		<cfset device = $getWURFLManager().getDeviceForRequest(Trim(arguments.userAgent))/>
		<cflock timeout="5" scope="server">
			<cfset device = $getWURFLManager().getDeviceForRequest(Trim(arguments.userAgent))/>
			<cfset ret = device.getUserAgent()/>
		</cflock>
		
		<cfreturn ret/>
	</cffunction>
	
	<cffunction name="reinitializeWURFL" returntype="void">
		<cfscript>$getWURFLManager(true);</cfscript>
	</cffunction>
	
	<cffunction name="$getWURFLManager" returntype="any">
		<cfargument name="reinitialize" type="boolean" default="false"/>
		
		<cfif !isDefined("server.wurflManager") OR arguments.reinitialize>
			<cflock timeout="30" scope="server">
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
			</cflock>
		</cfif>
		
		<cfreturn server.wurflManager/>
		
	</cffunction>
	
</cfcomponent>