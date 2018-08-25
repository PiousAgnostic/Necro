<cfcomponent displayname="Necronomicon" hint="ColdFusion Component for Necronomicon">

 <cfset ds = "Necrosql">
 
 <cffunction name="retriveClock">
 	<cfargument name="MinimumHour" type="numeric" default="9"> 
	<cfargument name="GamesOnly" type="boolean" default="Yes">
	
	<cfif GamesOnly>
		 <cfquery name="qsession_data" datasource="#ds#">
		 SELECT Sessions.SessionDate, Sessions.SessionBegins, Sessions.SessionEnds, Sessions.MaxLengthGame
		 FROM Sessions
		 WHERE (((Sessions.Type)='Game'))
		 ORDER BY Sessions.SessionDate
		 </cfquery>
	<cfelse>
		 <cfquery name="qsession_data" datasource="#ds#">
		 SELECT Sessions.SessionDate, Sessions.SessionBegins, Sessions.SessionEnds, Sessions.MaxLengthGame
		 FROM Sessions
		 ORDER BY Sessions.SessionDate
		 </cfquery>
	</cfif>

	 <cfquery name="qsession_data_grouped" dbtype="query">
	 SELECT SessionDate, Min(SessionBegins) AS MinOfSessionBegins, Max(SessionEnds) AS MaxOfSessionEnds
	 FROM qsession_data
	 GROUP BY SessionDate
	 </cfquery>


	 <Cfoutput query="qsession_data_grouped">
		<cfset thishr = #datepart("h", MinOfSessionBegins)#>
		<cfif thishr LT MinimumHour>
			<cfset MinimumHour = thishr>
		</cfif>
	 </cfoutput>


	 <cfset clock = QueryNew("SessionDate, MinOfSessionBegins, MaxOfSessionEnds, LastOfMaxLengthGame")>


	 <cfoutput query="qsession_data_grouped">
		<CFSET L_DATE = MaxOfSessionEnds>

		<cfquery name="lookup" dbtype="query">
			select MaxLengthGame
			From qsession_data
			where SessionEnds = '#L_DATE#'
		</cfquery>

		<cfset temp = QueryAddRow(clock)>

		<cfset Temp = QuerySetCell(clock, "SessionDate", SessionDate)>
		<cfset Temp = QuerySetCell(clock, "MinOfSessionBegins", MinofSessionBegins)>
		<cfset Temp = QuerySetCell(clock, "MaxOfSessionEnds", MaxOfSessionEnds)>
		<cfset Temp = QuerySetCell(clock, "LastOfMaxLengthGame", lookup.MaxLengthGame)>
	</cfoutput>

	<cfreturn clock>
 
 </cffunction>
 
</cfcomponent>