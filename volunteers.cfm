
<style type="text/css">
<!--
	TD.NORMAL { background-color: Navy; color: white; }
	TD.SESSION { background-color: Olive }
	TH.HEADING { background-color: Maroon; color:white;}
	TD.OVERLAP { background-color: Red; text-decoration: blink }
	TD.OVERLAPNOBLINK { background-color: Red; }
-->
</style>
	
<CFIF Not IsDefined("Session.Administrator")>
	<cflocation url="admin.cfm" addtoken="No">
</cfif>	

<script language="JavaScript">
</script>	

<cfif isDefined("form.Free")>
	<cfquery datasource="#ds#" dbtype="ODBC">
		DELETE FROM VolunteerSessions
		WHERE (VolId = #FORM.VOLID#) AND
			  (SessionID = #FORM.SESSIONID#);
	</cfquery>

</cfif>

<Cfif isDefined("form.Assign")>
	<cfquery name="findVol" datasource="#ds#">
		select * from Volunteers
		where VoleMail = '#form.Volemail#'
	</cfquery>
	
	<cfif findVol.Recordcount EQ 0>
		<cfquery datasource="#ds#">
			INSERT INTO VOLUNTEERS
				(VoleMail, FirstName, LastName, Telephone)
			VALUES('#form.volemail#',
			       '#form.VOlFName#',
				   '#form.VolLName#',
				   '#form.VolPhone#')
		</cfquery>
		<cfquery name="findVol" datasource="#ds#">
			select * from Volunteers
			where VoleMail = '#form.Volemail#'
		</cfquery>		
		
	</cfif>


	<cfquery datasource="#ds#">
		INSERT INTO VolunteerSessions (VolID, SessionID)
		VALUES (#FindVol.VolID#, #form.SessionID#)
	</cfquery>
	
</cfif>


<cfquery name="AllGameMasters" datasource="#ds#">
	SELECT * FROM [Game Masters]
	Order by LastName, FirstName
</cfquery>

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
	ORDER BY Sessions.Type, Sessions.SessionBegins;
</cfquery>

<cfquery name="AllVolunteers" datasource="#ds#" dbtype="ODBC">
SELECT Volunteers.LastName, Volunteers.FirstName, Volunteers.VoleMail, Volunteers.VolId, Volunteers.Telephone, Volunteers.GmId, Count(VolunteerSessions.SessionId) AS NumSessions, ActiveGamesWithSessions.HoursGaming, Sum([sessionLen]*[multiplier]) AS SumOfSessionLen, Max(Departments.Multiplier) AS MaxOfMultiplier
FROM (ActiveGamesWithSessions RIGHT JOIN ((VolunteerSessions INNER JOIN Volunteers ON VolunteerSessions.VolId = Volunteers.VolId) INNER JOIN Sessions ON VolunteerSessions.SessionId = Sessions.SessionID) ON ActiveGamesWithSessions.GMid = Volunteers.GmId) INNER JOIN Departments ON Sessions.Type = Departments.DepartmentCode
GROUP BY Volunteers.LastName, Volunteers.FirstName, Volunteers.VoleMail, Volunteers.VolId, Volunteers.Telephone, Volunteers.GmId, ActiveGamesWithSessions.HoursGaming
ORDER BY Volunteers.LastName, Volunteers.FirstName;
</cfquery>

<script language="JavaScript">

function assignVol(sid)
{
	if (confirm("Do you wish to assign a volunteer to this session?"))
	{
		while ((sid.VolFName.value == "undefined")||(sid.VolFName.value == ""))
			sid.VolFName.value = prompt("Please enter the First Name of the volunteer");
		
		while ((sid.VolLName.value == "undefined")||(sid.VolLName.value == ""))
			sid.VolLName.value = prompt("Please enter the Last Name of the volunteer");		
			
		while ((sid.Volemail.value == "undefined")||(sid.Volemail.value == ""))
			sid.Volemail.value = prompt("Please enter the email addy of the volunteer");					
		
		while ((sid.VolPhone.value == "undefined")||(sid.VolPhone.value == ""))
			sid.VolPhone.value = prompt("Please enter the phone number of the volunteer");			

		return true
	}
	else return false;
}
</script>



</head>

<link rel="stylesheet" type="text/css" href="styles/main.css">



<h2>Volunteer Information</h2>


<a  href="download_vlist.cfm?type=Gaming">Download Volunteer List</a>
<p>
<table border="0" cellpadding="10" cellspacing="10"> 

	<cfoutput query="AllVolunteerSessions" group="type">
		<tr>
		<Th class="heading" >#DepartmentName#
		<cfif Multiplier GT 1>
			<br>(#multiplier#X Credit hours)
		</cfif>
		
		</th>
		<cfloop index="i" from="1" to="#VolunteersPerSession#">
			<Th class="heading">Volunteer ###i#</th>
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
	<!--- 			<td align="center" bgcolor="Olive">
					 <b>#DateFormat(SessionEnds, "dddd")# #TimeFormat(SessionEnds, "h tt")#</b>
				</td>
	 --->			<cfloop query="VolunteersThisSession">
					<td class="normal" valign="middle" id="SESS_#SESSIONID#_#VolId#">
						<form action="#thisfile#" method="post" onSubmit="return confirm('Are you sure you wish to free this slot?')">
							<input type="submit" name="Free" value="Free" style="font-size: 8pt;" title="Click here to Free this Session"><b>&nbsp;<a style="color:##FFFFFF" href="###VolId#">#FirstName# #LastName#</a></b>
							<input type="hidden" name="SessionID" value="#SessionID#">
							<input type="hidden" name="VolId" value ="#VolId#">
						</form>
					</td>
				</cfloop>
				<cfloop index="i" from="1" to="#Evaluate(VolunteersPerSession - VolunteersThisSession.Recordcount)#">
					<Td valign="middle" align="Center" class="normal">
						<form action="#thisfile#" method="post" name="asn#SessionID#" onSubmit="return assignVol(this)">
							<input type="submit" name="Assign" value="Assign" style="font-size: 8pt;" title="Click here to Assign this Session"><b>&nbsp;<i>open</i>
							<input type="hidden" name="SessionID" value="#SessionID#">
							<input type="hidden" name="VolFName" value ="">
							<input type="hidden" name="VolLName" value ="">
							<input type="hidden" name="Volemail" value ="">
							<input type="hidden" name="VolPhone" value ="">
						</form>					
					</td>
				</cfloop>
			</tr>		
		</cfoutput>

	
		

	</cfoutput>

</table>

<p>
<CFOUTPUT QUERY="AllVolunteers" >
	<font size="+2">
		<a id="#VolId#">#FirstName# #LastName#</a><br>
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
			ORDER BY Sessions.SessionBegins, Sessions.Type 
		</cfquery>
		
		<CFLOOP query="thisGuysSessions">
			<cfset currentType = Type>
			<cfset currentSBegins = #DateFormat(SessionBegins, "dddd")#  & " " & #TimeFormat(SessionBegins, "h tt")# &" - " &#TimeFormat(SessionEnds, "h tt")#>
			<cfset CHECK4OVERLAP = #sessionid#>
			<cfset oneMinuteSessionBegins = SessionBegins + CreateTimeSpan(0,0,1,0)>
			<cfset oneMinuteSessionEnds = SessionEnds - CreateTimeSpan(0,0,1,0)>
			<cfquery name="Check4Overlaps" datasource="#ds#" dbtype="ODBC">
				SELECT VolunteerSessions.VolId, 
					   Sessions.SessionBegins, 
					   Sessions.Type, 
					   Sessions.SessionEnds, 
					   Sessions.MaxLengthGame, 
					   Sessions.SessionLen
				FROM VolunteerSessions 
						INNER JOIN Sessions ON VolunteerSessions.SessionId = Sessions.SessionID
				WHERE (((#CreateODBCDAteTime(oneMinuteSessionBegins)# >= SessionBegins) AND 
					    (#CreateODBCDateTime(oneMinuteSessionBegins)# <= SessionEnds   )) OR
					   ((#CreateODBCDAteTime(oneMinuteSessionEnds)# >= SessionBegins) AND 
					    (#CreateODBCDateTime(oneMinuteSessionEnds)# <= SessionEnds  ))) AND
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
</cfoutput>


</body>
</html>
