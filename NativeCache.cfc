<!---

	A custom cache strategy for the MachII framework http://www.mach-ii.com/
	
	This cache strategy will use the CFML engine's native CachePut and CacheGet methods for persistence.

	Author: Joe Roberts

--->
<cfcomponent
 	displayname="NativeCache"
	extends="MachII.caching.strategies.AbstractCacheStrategy"
	output="false"
	hint="A caching strategy that uses a cfml engine's native CachePut and CacheGet methods">
	
	<!---
	PROPERTIES
	--->
	<cfset variables.instance = StructNew() />
	<cfset variables.instance.strategyTypeName = "Native CachePut/CacheGet" />
	<cfset variables.parameters = StructNew() />
	<cfset variables.parameters.cachingEnabled = true />
	<cfset variables.cacheStats = CreateObject("component", "MachII.caching.CacheStats").init() />
	<cfset variables.log = 0 />
	<cfset variables.assert = "" />
	
	<!---
	INITIALIZATION / CONFIGURATION
	--->
	<cffunction name="configure" access="public" returntype="void" output="false"
		hint="Configures the strategy. Override to provide custom functionality.">
		<!--- Does nothing. Override to provide custom functionality. --->
	</cffunction>
	
	<!---
	PUBLIC FUNCTIONS
	--->
	<cffunction name="put" access="public" returntype="void" output="false" 
		hint="Puts an element by key into the cache.">
		<cfargument name="key" type="string" required="true"
			hint="The unique key for the data to put in the cache." />
		<cfargument name="data" type="any" required="true"
			hint="The data to cache." />
		<cfabort showerror="This method is abstract and must be overrided." />
	</cffunction>
	
	<cffunction name="get" access="public" returntype="any" output="false"
		hint="Gets an element by key from the cache.">
		<cfargument name="key" type="string" required="true"
			hint="The unique key for the data to get from the cache." />
		<cfabort showerror="This method is abstract and must be overrided." />
	</cffunction>
	
	<cffunction name="flush" access="public" returntype="void" output="false"
		hint="Flushes all elements from the cache.">
		<cfabort showerror="This method is abstract and must be overrided." />
	</cffunction>
	
	<cffunction name="reap" access="public" returntype="void" output="false"
		hint="Reaps 'expired' cache elements.">
		<cfabort showerror="This method is abstract and must be overrided." />
	</cffunction>
	
	<cffunction name="keyExists" access="public" returntype="boolean" output="false"
		hint="Checks if an element exists by key in the cache.">
		<cfargument name="key" type="string" required="true"
			hint="The unique key for the data to check if it is in the cache." />
		<cfabort showerror="This method is abstract and must be overrided." />
	</cffunction>
	
	<cffunction name="remove" access="public" returntype="void" output="false"
		hint="Removes a cached element by key.">
		<cfargument name="key" type="string" required="true"
			hint="The unique key for the data to remove from the cache." />
		<cfabort showerror="This method is abstract and must be overrided." />
	</cffunction>
	
	<!---
	PUBLIC FUNCTIONS - UTILS
	--->
	<cffunction name="getCacheStats" access="public" returntype="MachII.caching.CacheStats" output="false"
		hint="Gets the cache stats for this caching strategy.">
		<cfreturn variables.cacheStats />
	</cffunction>
	
	<cffunction name="getConfigurationData" access="public" returntype="struct" output="false"
		hint="Gets pretty configuration data for this caching strategy. Override to provide nicer looking information for Dashboard integration.">
		<cfreturn variables.instance />
	</cffunction>
	
	<cffunction name="setParameter" access="public" returntype="void" output="false"
		hint="Sets a configuration parameter.">
		<cfargument name="name" type="string" required="true"
			hint="The parameter name." />
		<cfargument name="value" type="any" required="true"
			hint="The parameter value." />
		<cfset variables.parameters[arguments.name] = arguments.value />
	</cffunction>
	<cffunction name="getParameter" access="public" returntype="any" output="false"
		hint="Gets a configuration parameter value, or a default value if not defined.">
		<cfargument name="name" type="string" required="true"
			hint="The parameter name." />
		<cfargument name="defaultValue" type="any" required="false" default=""
			hint="The default value to return if the parameter is not defined. Defaults to a blank string." />
		<cfif isParameterDefined(arguments.name)>
			<cfreturn variables.parameters[arguments.name] />
		<cfelse>
			<cfreturn arguments.defaultValue />
		</cfif>
	</cffunction>
	<cffunction name="isParameterDefined" access="public" returntype="boolean" output="false"
		hint="Checks to see whether or not a configuration parameter is defined.">
		<cfargument name="name" type="string" required="true"
			hint="The parameter name." />
		<cfreturn StructKeyExists(variables.parameters, arguments.name) />
	</cffunction>
	<cffunction name="getParameterNames" access="public" returntype="string" output="false"
		hint="Returns a comma delimited list of parameter names.">
		<cfreturn StructKeyList(variables.parameters) />
	</cffunction>
	
	<!---
	ACCESSORS
	--->
	<cffunction name="getStrategyTypeName" access="public" returntype="string" output="false"
		hint="Returns the type name of the strategy. Required for Dashboard integration.">
		<cfreturn variables.instance.strategyTypeName />
	</cffunction>
	<cffunction name="getStrategyType" access="public" returntype="string" output="false"
		hint="Returns the dot path type of the strategy. Required for Dashboard integration.">
		<cfreturn GetMetadata(this).name />
	</cffunction>
	
	<cffunction name="setCacheEnabled" access="public" returntype="void" output="false"
		hint="Sets the boolean suggestion that isCacheEnabled() returns.">
		<cfargument name="cachingEnabled" type="boolean" required="true" />
		<cfset variables.parameters.cachingEnabled = arguments.cachingEnabled />
	</cffunction>
	<cffunction name="isCacheEnabled" access="public" returntype="boolean" output="false"
		hint="Provides a boolean suggestion to the *calling code* if caching should be used. This does not explicitly turn caching on/off.">
		<cfreturn variables.parameters.cachingEnabled />
	</cffunction>
	
	<cffunction name="setAssert" access="private" returntype="void" output="false"
		hint="Sets the assert utility.">
		<cfargument name="assert" type="MachII.util.Assert" required="true" />
		<cfset variables.assert = arguments.assert />
	</cffunction>
	<cffunction name="getAssert" access="public" returntype="MachII.util.Assert" output="false"
		hint="Gets the assert utility.">
		<cfreturn variables.assert />
	</cffunction>

	<cffunction name="setParameters" access="public" returntype="void" output="false"
		hint="Sets the full set of configuration parameters for the component.">
		<cfargument name="parameters" type="struct" required="true" />
		
		<cfset var key = "" />
		
		<cfloop collection="#arguments.parameters#" item="key">
			<cfset setParameter(key, arguments.parameters[key]) />
		</cfloop>
	</cffunction>
	<cffunction name="getParameters" access="public" returntype="struct" output="false"
		hint="Gets the full set of configuration parameters for the component.">
		<cfreturn variables.parameters />
	</cffunction>
	
	<cffunction name="setLog" access="public" returntype="void" output="false"
		hint="Uses the log factory to create a log.">
		<cfargument name="logFactory" type="MachII.logging.LogFactory" required="true" />
		<cfset variables.log = arguments.logFactory.getLog(getMetadata(this).name) />
	</cffunction>
	<cffunction name="getLog" access="public" returntype="MachII.logging.Log" output="false"
		hint="Gets the log.">
		<cfreturn variables.log />
	</cffunction>
	
</cfcomponent>