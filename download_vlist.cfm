


<html>
<head>
	<title>Untitled</title>
	
<style type="text/css">
<!--
	TD.NORMAL  { font-size: 16pt; background-color: Navy ; color: WHITE}
	TD.SESSION { font-size: 16pt; background-color: Olive ; color: WHITE}
	Td.HEADING { font-size: 20pt; background-color: Maroon ; color: WHITE; text-align: center}
	TD.OVERLAP { background-color: Red; ; color: WHITE; }
	Td.OVERLAPNOBLINK { background-color: Red; color: WHITE }
-->
</style>	
</head>

<!--- <body> --->

<cfquery name="AllVolunteerSessions" datasource="#ds#" dbtype="ODBC">
	SELECT 	Sessions.SessionID, 
			Sessions.Type, 
			Sessions.SessionDate, 
			Sessions.SessionBegins, 
			Sessions.SessionEnds, 
			Sessions.MaxLengthGame, 
			Departments.DepartmentID, 
			Departments.DepartmentName,
			Departments.DepartmentCode,
			Departments.VolunteersPerSession,
			Departments.Multiplier
	FROM Sessions INNER JOIN Departments ON Sessions.Type = Departments.DepartmentCode
	WHERE (((Sessions.Type)<>'Game'))
<cfif IsDefined("Type")> AND Departments.DepartmentCode = '#TYPE#'</cfif>
	ORDER BY Sessions.Type, Sessions.SessionBegins;
</cfquery>


<cfquery name="AllVolunteers" datasource="#ds#" dbtype="ODBC">
SELECT Volunteers.LastName, Volunteers.FirstName, Volunteers.VoleMail, Volunteers.VolId, Volunteers.Telephone, Volunteers.GmId, Count(VolunteerSessions.SessionId) AS NumSessions, ActiveGamesWithSessions.HoursGaming, Sum([sessionLen]*[multiplier]) AS SumOfSessionLen, Max(Departments.Multiplier) AS MaxOfMultiplier
FROM (ActiveGamesWithSessions RIGHT JOIN ((VolunteerSessions INNER JOIN Volunteers ON VolunteerSessions.VolId = Volunteers.VolId) INNER JOIN Sessions ON VolunteerSessions.SessionId = Sessions.SessionID) ON ActiveGamesWithSessions.GMid = Volunteers.GmId) INNER JOIN Departments ON Sessions.Type = Departments.DepartmentCode
GROUP BY Departments.DepartmentCode, Volunteers.LastName, Volunteers.FirstName, Volunteers.VoleMail, Volunteers.VolId, Volunteers.Telephone, Volunteers.GmId, ActiveGamesWithSessions.HoursGaming
<cfif IsDefined("Type")> HAVING Departments.DepartmentCode = '#TYPE#'</cfif>
ORDER BY Volunteers.LastName, Volunteers.FirstName;
</cfquery>

<h1>Volunteer Information</h1>

<p>
<table border="0" cellpadding="10" cellspacing="0"> 

	<cfoutput query="AllVolunteerSessions" group="type">
		<tr>
		<Td class="heading" >#DepartmentName#
		<cfif Multiplier GT 1>
			<br>(#multiplier#X Credit hours)
		</cfif>
		
		</td>
		<cfloop index="i" from="1" to="#VolunteersPerSession#">
			<Td class="heading">Volunteer ###i#</td>
		</cfloop>
		</tr>

		<cfoutput>
			<cfquery name="VolunteersThisSession"  datasource="#ds#" dbtype="ODBC">
				SELECT 	VolunteerSessions.SessionId, Volunteers.FirstName, 
						Volunteers.LastName, Volunteers.VolId
				FROM 	VolunteerSessions INNER JOIN Volunteers ON 
							VolunteerSessions.VolId = Volunteers.VolId
				WHERE 	VolunteerSessions.SessionId=#SessionId#;
			</cfquery>	
			<tr>
				<td align="center" class="session">
					<b>#DateFormat(SessionBegins, "dddd")# #TimeFormat(SessionBegins, "h tt")# - #TimeFormat(SessionEnds, "h tt")#</b>
				</td>				
				<cfloop query="VolunteersThisSession">
					<td class="normal" valign="middle" align="Center" id="SESS_#SESSIONID#_#VolId#">
						<b>&nbsp;#FirstName# #LastName#</b>
					</td>
				</cfloop>
				<cfloop index="i" from="1" to="#Evaluate(VolunteersPerSession - VolunteersThisSession.Recordcount)#">
					<Td valign="middle" align="Center" class="normal">
							<b>&nbsp;<i>open</i>
					</td>
				</cfloop>
			</tr>		
		</cfoutput>

	
		

	</cfoutput>

</table>
<p>

<CFOUTPUT QUERY="AllVolunteers" >
	<font size="+2">
		#FirstName# #LastName#<br>
		#Telephone#<br>
		<a href="mailto:#Volemail#">#Volemail#</a><br>
	</font>
	<font size="+1">
		Hours Volunteering : #SumOfSessionLen#
		<cfif MaxOfMultiplier GT 1>
			&nbsp;(modified)
		</cfif>
		<cfif HoursGaming GT "">
			<br>Hours Running Games : #NumberFormat(HoursGaming)#
			
		</cfif>
		<BR>
		<cfset VGMID = GMID>
		
		<cfquery name="thisGuysSessions" datasource="#ds#">
			SELECT VolunteerSessions.VolId, 
				   VolunteerSessions.SessionId,
				   Sessions.SessionBegins, 
				   Sessions.Type, 
				   Sessions.SessionEnds, 
				   Sessions.MaxLengthGame, 
				   Sessions.SessionLen
			FROM VolunteerSessions 
					INNER JOIN Sessions ON VolunteerSessions.SessionId = Sessions.SessionID
			WHERE (((VolunteerSessions.VolId)=#VolId#))
			<CFIF ISDEFINED("TYPE")>and Sessions.Type = '#TYPE#'</cfif>
			ORDER BY Sessions.SessionBegins, Sessions.Type 
		</cfquery>
		
		<CFLOOP query="thisGuysSessions">
			<cfset currentType = Type>
			<cfset currentSBegins = #DateFormat(SessionBegins, "dddd")#  & " " & #TimeFormat(SessionBegins, "h tt")# &" - " &#TimeFormat(SessionEnds, "h tt")#>
			<cfset CHECK4OVERLAP = #sessionid#>
			<cfquery name="Check4Overlaps" datasource="#ds#" dbtype="ODBC">
				SELECT VolunteerSessions.VolId, 
					   Sessions.SessionBegins, 
					   Sessions.Type, 
					   Sessions.SessionEnds, 
					   Sessions.MaxLengthGame, 
					   Sessions.SessionLen
				FROM VolunteerSessions 
						INNER JOIN Sessions ON VolunteerSessions.SessionId = Sessions.SessionID
				WHERE (((#CreateODBCDAteTime(SessionBegins)# >= SessionBegins) AND 
					    (#CreateODBCDateTime(SessionBegins)# <= SessionEnds   )) OR
					   ((#CreateODBCDAteTime(SessionEnds)# >= SessionBegins) AND 
					    (#CreateODBCDateTime(SessionEnds)# <= SessionEnds  ))) AND
						VolunteerSessions.VolId = #VolId# and
						VolunteerSessions.SessionID <> #SessionID#
			</cfquery>
			<CFIF Check4Overlaps.Recordcount NEQ 0>
				<table><tr><td class="OVERLAPNOBLINK">
				<p>Session <b>#currentType# #currentSBegins#</b> overlaps with:<br>
				<cfloop query="Check4Overlaps">
				
	
				<i>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#Type# #DateFormat(SessionBegins, "dddd")#   #TimeFormat(SessionBegins, "h tt")#  - #TimeFormat(SessionEnds, "h tt")#<br>
				</i>
				<SCRIPT language="JavaScript">
					//alert(document.getElementById("SESS_#CHECK4OVERLAP#_#volID#").className)
					document.getElementById("SESS_#CHECK4OVERLAP#_#volID#").className = "OVERLAP";
				</script>					
				</cfloop>
				</td></tr></table>
			</cfif>
			

		
		
		</cfloop>
		
<!--- 		<form action="#thisfile#" method="post">	
		<select name="GMName" style="font-size: 8pt;">
			<option value="0"
				<CFIF VGMId EQ 0>selected</cfif>
			>-- not running games --</option>
			<cfloop query="AllGameMasters">
				<option value="#GmID#"
					<cfif VGMId EQ #GmID#>selected</cfif>
				>#FirstName# #MiddleName# #LastName#</option>
			</cfloop>
		</select>
		<input type="submit" name="chgGMID" value="Assign GM" style="font-size: 8pt;">
		<input type="Hidden" name="VolID" value="#VOlID#">
		</form> --->
	</font>
	<p>
	<hr>
</cfoutput>

    <cfheader 
    name="Content-Type" 
    value="application/msexcel">
    <cfheader 
    name="Content-Disposition" 
    value="attachment; filename=Volunteers.xls"> 

</body>
</html>
