<!---

	A custom cache strategy for the MachII framework http://www.mach-ii.com/
	
	This cache strategy will use the CFML engine's native CachePut and CacheGet methods for persistence.

	Author: Joe Roberts

--->
<cfcomponent
 	displayname="TimespanNativeCfmlStrategy"
	extends="MachII.caching.strategies.AbstractCacheStrategy"
	output="false"
	hint="A caching strategy that uses a cfml engine's native CachePut and CacheGet methods">
	
	<!---
	PROPERTIES
	--->
	<cfset variables.instance.strategyTypeName = "Native CachePut/CacheGet" />
	
	<!---
	INITIALIZATION / CONFIGURATION
	--->
	<cffunction name="configure" access="public" returntype="void" output="false"
		hint="Configures the strategy. Override to provide custom functionality.">
		
		<cfscript>
		// set parameters
		
		// Optional: Specify the name of which cache to use - not supported by all cfml engines. To disable named caches, either specify an empty string, or don't provide this parameter.
		if( isParameterDefined("cacheName") )
		{
			setCacheName( getParameter("cacheName") );
		}
		else
		{
			setCacheName( "" );
		}
		
		// The duration until the object is flushed from the cache
		if( isParameterDefined("cacheTimespan") and getAssert().isTrue(listLen(getParameter("cacheTimespan")) eq 4, "Invalid cacheTimespan of '#getParameter("cacheTimespan")#'.", "cacheTimespan must be set to a list of 4 numbers (days, hours, minutes, seconds)." ) )
		{
			setCacheTimespan( getParameter("cacheTimespan") );
		}
		
		// A duration after which the object is flushed from the cache if it is not accessed during that time
		if( isParameterDefined("idleTimespan") and getAssert().isTrue(listLen(getParameter("idleTimespan")) eq 4, "Invalid idleTimespan of '#getParameter("idleTimespan")#'.", "idleTimespan must be set to a list of 4 numbers (days, hours, minutes, seconds)." ) )
		{
			setIdleTimespan( getParameter("idleTimespan") );
		}
		</cfscript>
				
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
		
		<cfscript>
		var hashedKey = hashKey(arguments.key);
		
		// update the cache stats
		if( not keyExists(arguments.key) )
		{
			getCacheStats().incrementTotalElements(1);
			getCacheStats().incrementActiveElements(1);
		}
		else
		{
			getCacheStats().incrementActiveElements(1);
		}
		
		// write the element to the cache
		if( isUsingNamedCache() )
		{
			cachePut( hashedKey, arguments.data, getCacheTimespan(), getIdleTimespan(),	getCacheName() );
		}
		else
		{
			cachePut( hashedKey, arguments.data, getCacheTimespan(), getIdleTimespan() );
		}
		</cfscript>

	</cffunction>
	
	<cffunction name="get" access="public" returntype="any" output="false"
		hint="Gets an element by key from the cache.">
		<cfargument name="key" type="string" required="true"
			hint="The unique key for the data to get from the cache." />

		<cfscript>
		// create a hash of the key (so it's compatible with different cache stores)
		var hashedKey = hashKey(arguments.key);
		
		var element = "";
		
		// attempt to retrieve the element
		if( isUsingNamedCache() )
		{
			element = cacheGet(	hashedKey, false, getCacheName() );
		}
		else
		{
			element = cacheGet(	hashedKey );
		}
		
		// if the requested element is in the cache, return it
		if( isDefined("element") )
		{
			getCacheStats().incrementCacheHits(1);
			return element;
		}
		else
		{
			getCacheStats().incrementCacheMisses(1);
		}
		</cfscript>
		
	</cffunction>
	
	<cffunction name="flush" access="public" returntype="void" output="false"
		hint="Flushes all elements from the cache.">
		
		<cfscript>
		// clear this cache store
		if( isUsingNamedCache() )
		{
			cacheclear( "", getCacheName() );
		}
		else
		{
			cacheclear();
		}
		
		// clear the cache stats
		getCacheStats().reset()
		</cfscript>
		
	</cffunction>
	
	<cffunction name="reap" access="public" returntype="void" output="false"
		hint="Reaps 'expired' cache elements.">
		<cfabort showerror="Reaping expired cache elements is handled natively, this error is intentional as the reap method has not been implemented." />
	</cffunction>
	
	<cffunction name="keyExists" access="public" returntype="boolean" output="false"
		hint="Checks if an element exists by key in the cache.">
		<cfargument name="key" type="string" required="true"
			hint="The unique key for the data to check if it is in the cache." />

		<cfscript>
		var hashedKey = hashKey(arguments.key);
		
		return cachekeyexists( hashedKey, getCacheName() );
		</cfscript>

	</cffunction>
	
	<cffunction name="remove" access="public" returntype="void" output="false"
		hint="Removes a cached element by key.">
		<cfargument name="key" type="string" required="true"
			hint="The unique key for the data to remove from the cache." />

		<cfscript>
		var hashedKey = hashKey(arguments.key);
		
		// remove this element from the cache
		if( isUsingNamedCache() )
		{
			cacheremove( hashedKey, false, getCacheName() );
		}
		else
		{
			cacheremove( hashedKey, false );
		}
		</cfscript>

	</cffunction>
	
	<!---
	PRIVATE FUNCTIONS - UTILS
	--->
	<cffunction name="hashKey" access="private" returntype="string" output="false"
		hint="Creates a hash from a key name.">
		<cfargument name="key" type="string" required="true"
			hint="The key to hash." />
		<cfreturn Hash(UCase(Trim(arguments.key))) />
	</cffunction>
	
	<cffunction name="isUsingNamedCache" access="private" returntype="boolean" output="false" hint="Are we using a named cache, or the default? Not all cfml engines support named caches.">
		<!--- we're using a named cache if the cache name isn't an empty string --->
		<cfreturn len(getCacheName()) gt 0 />
	</cffunction>
	
	<!---
	ACCESSORS
	--->
	
	<cffunction name="setCacheTimespan" access="private" returntype="void" output="false" hint="Sets a timespan for the cache - the max duration it can live in the cache before it is flushed.">
		<cfargument name="timespan" type="string" required="true" hint="Must be in format of 0,0,0,0 (days,hours,minutes,seconds)." />
		<cfset variables.instance.cacheTimespan = createTimeSpan( 
			listGetAt(arguments.timespan, 1),
			listGetAt(arguments.timespan, 2),
			listGetAt(arguments.timespan, 3),
			listGetAt(arguments.timespan, 4)
		) />
	</cffunction>
	<cffunction name="getCacheTimespan" access="public" returntype="any" output="false" hint="Gets the timespan duration">
		<cfreturn variables.instance.cacheTimespan />
	</cffunction>
	
	<cffunction name="setIdleTimespan" access="private" returntype="void" output="false" hint="Sets a timespan for the idle timeout - if an element in the cache hasn't been accessed for this period of time, it is flushed.">
		<cfargument name="timespan" type="string" required="true" hint="Must be in format of 0,0,0,0 (days,hours,minutes,seconds)." />
		<cfset variables.instance.idleTimespan = createTimeSpan( 
			listGetAt(arguments.timespan, 1),
			listGetAt(arguments.timespan, 2),
			listGetAt(arguments.timespan, 3),
			listGetAt(arguments.timespan, 4)
		) />
	</cffunction>
	<cffunction name="getIdleTimespan" access="public" returntype="any" output="false" hint="Gets the timespan duration">
		<cfreturn variables.instance.idleTimespan />
	</cffunction>
	
	<cffunction name="setCacheName" access="private" returntype="void" output="false" hint="Sets the name of the custom cache to use.">
		<cfargument name="name" type="string" required="true" hint="custom cache name - must be defined in your CFML engine's admin" />
		<cfset variables.instance.cacheName = arguments.name />
	</cffunction>
	<cffunction name="getCacheName" access="public" returntype="any" output="false" hint="Sets the name of the custom cache to use.">
		<cfreturn variables.instance.cacheName />
	</cffunction>
	
</cfcomponent>