
<cfquery name="GameDays" datasource="#ds#" dbtype="ODBC">
	SELECT * from ConventionDays
	ORDER BY [Date];
</cfquery>

<cfquery name="VolunteerDays" datasource="#ds#" dbtype="ODBC">
	SELECT 	DepartmentDays.ID,
			DepartmentDays.FirstVolSession,
			DepartmentDays.NumVolSessions,
			Departments.DepartmentCode,
			Departments.DepartmentName,
			DepartmentDays.Date,
			Departments.VolunteersPerSession,
			Departments.DepartmentID,
			Departments.HoursPerSession
	FROM DepartmentDays INNER JOIN Departments ON DepartmentDays.DepartmentID = Departments.DepartmentID
	ORDER BY Departments.DepartmentName, DepartmentDays.Date;
</cfquery>

<cfquery name="c" datasource="#ds#">
SELECT * FROM Departments
</cfquery>

<cfquery name="c" datasource="#ds#">
SELECT * FROM DepartmentDays
</cfquery>



<!---
<cfdump var="#volunteerDays#">
 <cfquery name="Rooms" datasource="#ds#">
	SELECT * FROM ROOMS
	ORDER BY ROOMID;
</cfquery>
 --->
<cfset KickOutDateTime = CreateDateTime(
								DatePart("yyyy", lConventionEnds),
								DatePart("m", lConventionEnds),
								DatePart("d", lConventionEnds),
								DatePart("h", lLastGameTime),
								DatePart("n", lLastGameTime),
								DatePart("s", lLastGameTime))>

<cfset twohours = CreateTimeSpan(0,2,0,0)>

<table cellspacing="3" cellpadding="3" style="color: Black;" align="center">
<tr bgcolor="Maroon">
	<th colspan="10" align="center" color="white">Game and Volunteer Sessions</th>
</tr>
	<cfloop query="GameDays">
		<cfset SessionType   = 'Game'>
		<cfset SessionDate = #Date#>
		<cfset SessionBegins = CreateDateTime(
								DatePart("yyyy", Date),
								DatePart("m", Date),
								DatePart("d", Date),
								DatePart("h", FirstGameSession),
								DatePart("n", FirstGameSession),
								DatePart("s", FirstGameSession))>
		<cfset SessionCount  = #NumGameSessions#>
		<Cfset SessionID     = #id#>
		<cfset SaveSessionBegins = SessionBegins>
		<CFSET SessionName = 'Game'>
		<cfset sessionhours = twohours>
		<cfset sessionlen = 2>
		<cfinclude template="AddSession.cfm">


<!--- 		<cfset SessionType   = 'Volunteer'>
		<cfset SessionDate = #Date#>
		<cfset SessionBegins = CreateDateTime(
								DatePart("yyyy", Date),
								DatePart("m", Date),
								DatePart("d", Date),
								DatePart("h", FirstVolSession),
								DatePart("n", FirstVolSession),
								DatePart("s", FirstVolSession))>
		<cfset SessionCount  = #NumVolSessions#>
		<Cfset SessionID     = #id#>
		<CFSET SessionName = 'Volunteer'>
		<cfinclude template="AddSession.cfm"> --->
	</cfloop>

	<cfloop query="VolunteerDays">
		<cfset SessionType   = DepartmentCode>
		<cfset SessionDate = #Date#>
		<cfset SessionBegins = CreateDateTime(
								DatePart("yyyy", Date),
								DatePart("m", Date),
								DatePart("d", Date),
								DatePart("h", FirstVolSession),
								DatePart("n", FirstVolSession),
								DatePart("s", FirstVolSession))>
		<cfset SessionCount  = #NumVOLSessions#>
		<Cfset SessionID     = #id#>
		<CFSET SessionName = DepartmentName>
		<cfset sessionhours = CreateTimeSpan(0,HoursPerSession,0,0)>
		<cfset sessionlen = HoursPerSession>
		<cfinclude template="AddSession.cfm">
	</cfloop>

</table>
