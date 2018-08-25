<cfparam name="likevalue" default="Like">

<cfif IsDefined("gameid")>


	<cfif likevalue EQ "Like">
	
		<cftry>
		
		<cfif isDefined("SESSION.LOGGEDINGMN")>
			<CFSET IPADDRESS = SESSION.LOGGEDINGMN>
		<CFELSE>
			<CFSET IPADDRESS = CGI.REMOTE_ADDR>	
		</cfif>
		
		
		<cfquery datasource="#ds#">
			INSERT INTO GameInterest (GameID, InterestDate, IPAddress)
			Values( #gameid#, #CreateODBCDate(Now())#, '#IPADDRESS#')
		</cfquery>
		<cfcatch></cfcatch>
		</cftry>

	<cfelse>
	
		<cftry>
		
		<cfif isDefined("SESSION.LOGGEDINGMN")>
			<CFSET IPADDRESS = SESSION.LOGGEDINGMN>
		<CFELSE>
			<CFSET IPADDRESS = CGI.REMOTE_ADDR>	
		</cfif>
		
		
		<cfquery datasource="#ds#">
			DELETE from GameInterest
			where gameID = #gameID#
			  and (IPAddress = '#IPADDRESS#'
			  or  IPAddress = '#CGI.REMOTE_ADDR#');
		</cfquery>
		<cfcatch></cfcatch>
		</cftry>	
	
	</cfif>
	
</cfif>
