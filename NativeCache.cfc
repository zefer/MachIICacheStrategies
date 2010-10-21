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
	
	<!---
	ACCESSORS
	--->
	
</cfcomponent>