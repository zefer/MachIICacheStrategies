<!---
	This is an template containing the absolute basic methods you should write when creating a custom MachII caching strategy
--->
<cfcomponent
 	displayname="BasicCustomStrategyTemplate"
	extends="MachII.caching.strategies.AbstractCacheStrategy"
	output="false"
	hint="A caching strategy that doesn't do anything, it's merely a basic template for creating a custom machII caching strategy">
	
	<!---
	PROPERTIES
	--->
	<cfset variables.instance.strategyTypeName = "A custom name" />
	
	<!---
	INITIALIZATION / CONFIGURATION
	--->
	<cffunction name="configure" access="public" returntype="void" output="false"
		hint="Configures the strategy. Override to provide custom functionality.">
			
		<cfabort showerror="Hey, you shouldn't be trying to instantiate me, I'm just a template to provide an example when writing a custom cache strategy!" />
			
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
		
		<cfabort showerror="The PUT method must be implemented." />

	</cffunction>
	
	<cffunction name="get" access="public" returntype="any" output="false"
		hint="Gets an element by key from the cache.">
		<cfargument name="key" type="string" required="true"
			hint="The unique key for the data to get from the cache." />

		<cfabort showerror="The GET method must be implemented." />
		
	</cffunction>
	
	<cffunction name="flush" access="public" returntype="void" output="false"
		hint="Flushes all elements from the cache.">
		
		<cfabort showerror="The FLUSH method has not been implemented for this cache strategy. It may not be required." />
		
	</cffunction>
	
	<cffunction name="reap" access="public" returntype="void" output="false"
		hint="Reaps 'expired' cache elements.">
		
		<cfabort showerror="The REAP method has not been implemented for this cache strategy. It may not be required." />
	
	</cffunction>
	
	<cffunction name="keyExists" access="public" returntype="boolean" output="false"
		hint="Checks if an element exists by key in the cache.">
		<cfargument name="key" type="string" required="true"
			hint="The unique key for the data to check if it is in the cache." />

		<cfabort showerror="The KEYEXISTS method has not been implemented for this cache strategy. It may not be required." />

	</cffunction>
	
	<cffunction name="remove" access="public" returntype="void" output="false"
		hint="Removes a cached element by key.">
		<cfargument name="key" type="string" required="true"
			hint="The unique key for the data to remove from the cache." />

		<cfabort showerror="The REMOVE method has not been implemented for this cache strategy. It may not be required." />

	</cffunction>
	
	<!---
	PRIVATE FUNCTIONS - UTILS
	--->
	
	<!---
	ACCESSORS
	--->
	
</cfcomponent>