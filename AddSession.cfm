


<cfoutput>
<cfloop index="x" from="1" to="#SessionCount#">
	<cfset SessionEnds = SessionBegins + sessionhours>
	
	<cfif SessionType EQ "Game">
		<cfset HrsUntillKickOut = DateDiff("h", SessionBegins, KickOutDateTime)>
		
		<cfif HrsUntillKickOut GT 6>
			<cfset MAXLENGAME = 6>
		<CFELSE>
			<CFSET MAXLENGAME = HrsUntillKickOut>
		</cfif>
	<cfelse>
		<cfset MAXLENGAME = 0>
	</cfif>
	<CFTRY>
		<CFSET INSERTRESULT = "Added">
	
		<cfquery datasource="#ds#" dbtype="ODBC">
			INSERT INTO Sessions (Type, SessionDate, SessionBegins, SessionEnds, MaxLengthGame, SessionLen)
			VALUES ( '#SessionType#',
					 #CreateODBCDate(SessionDate)#,
					 #CreateODBCDateTime(SessionBegins)#,
					 #CreateODBCDateTime(SessionEnds)#,
					 #MAXLENGAME#,
					 #sessionlen#);
		</cfquery>
	<CFCATCH>
		<CFSET INSERTRESULT = "Existing">
	</CFCATCH>
	</CFTRY>
	
	<tr>
		<td class="#SessionType#">#SessionName#</td>
		<td class="#SessionType#">#DateFormat(SessionDate, "ddd, mmm d")#</td>
		<td class="#SessionType#">#DateFormat(SessionBegins, "ddd, mmm d")# @ #TimeFormat(SessionBegins, "h:mm tt")#</td>
		<td class="#SessionType#">#DateFormat(SessionEnds, "ddd, mmm d")# @ #TimeFormat(SessionEnds, "h:mm tt")#</td>	
		<TD class="#SessionType#">#MAXLENGAME#</td>
		<td class="#SessionType#">#INSERTRESULT#</td>
	</tr>
	
	<cfset SessionBegins = SessionBegins + sessionhours>
</cfloop>
</cfoutput>