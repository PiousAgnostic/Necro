<cfquery name="bigGameList" datasource="#ds#" dbtype="ODBC">
SELECT [Game Masters].AFTERDEADLINE AS GMDate, [Game Masters].GMId, [Game Masters].Cancelled, [Game Masters].LastName, [Game Masters].FirstName, [Game Masters].MiddleName, [Game Masters].Alias, [Game Masters].Telephone, [Game Masters].email, Games.Cancelled, Games.Approved, Games.Title, Games.LengthOfGame, Games.AFTERDEADLINE AS GameDate, Sessions.SessionBegins
FROM (Games INNER JOIN [Game Masters] ON Games.GMid = [Game Masters].GMId) INNER JOIN Sessions ON Games.Session = Sessions.SessionID
GROUP BY [Game Masters].AFTERDEADLINE, [Game Masters].GMId, [Game Masters].Cancelled, [Game Masters].LastName, [Game Masters].FirstName, [Game Masters].MiddleName, [Game Masters].Alias, [Game Masters].Telephone, [Game Masters].email, Games.Cancelled, Games.Approved, Games.Title, Games.LengthOfGame, Games.AFTERDEADLINE, Sessions.SessionBegins
HAVING ((([Game Masters].Cancelled)=0) AND ((Games.Approved)=1))
ORDER BY [Game Masters].LastName, [Game Masters].FirstName, Sessions.SessionBegins;
</cfquery>

<!--- SELECT Volunteers.VolId, Volunteers.AFTERDEADLINE, Volunteers.LastName, Volunteers.FirstName, Volunteers.Telephone, Volunteers.VoleMail, Count(VolunteerSessions.SessionId) AS CountOfSessionId, Sessions.SessionLen, Sessions.SessionBegins, Departments.DepartmentName, Departments.Multiplier
FROM ((Volunteers INNER JOIN VolunteerSessions ON Volunteers.VolId = VolunteerSessions.VolId) INNER JOIN Sessions ON VolunteerSessions.SessionId = Sessions.SessionID) INNER JOIN Departments ON Sessions.Type = Departments.DepartmentCode
GROUP BY Volunteers.VolId, Volunteers.AFTERDEADLINE, Volunteers.LastName, Volunteers.FirstName, Volunteers.Telephone, Volunteers.VoleMail, Sessions.SessionLen, Sessions.SessionBegins, Departments.DepartmentName, Volunteers.GmId, Departments.Multiplier
HAVING (((Volunteers.GmId)=0 Or (Volunteers.GmId) In (SELECT Volunteers.GmId FROM Volunteers LEFT JOIN Games ON Volunteers.GmId = Games.GMid GROUP BY Volunteers.GmId HAVING (((Count(Games.GameId))=0)))))
ORDER BY Volunteers.LastName, Volunteers.FirstName, Sessions.SessionBegins; --->

<cfquery name="bigVolunteerList" datasource="#ds#" dbtype="ODBC">


SELECT Volunteers.VolId, Volunteers.AFTERDEADLINE, Volunteers.LastName, Volunteers.FirstName, Volunteers.Telephone, Volunteers.VoleMail, Count(VolunteerSessions.SessionId) AS CountOfSessionId, Sessions.SessionLen, Sessions.SessionBegins, Departments.DepartmentName, Departments.Multiplier
FROM ((Volunteers INNER JOIN VolunteerSessions ON Volunteers.VolId = VolunteerSessions.VolId) INNER JOIN Sessions ON VolunteerSessions.SessionId = Sessions.SessionID) INNER JOIN Departments ON Sessions.Type = Departments.DepartmentCode
GROUP BY Volunteers.VolId, Volunteers.AFTERDEADLINE, Volunteers.LastName, Volunteers.FirstName, Volunteers.Telephone, Volunteers.VoleMail, Sessions.SessionLen, Sessions.SessionBegins, Departments.DepartmentName, Departments.Multiplier, Volunteers.GmId
HAVING (((Volunteers.GmId)=0 Or (Volunteers.GmId) In (SELECT Volunteers.GmId
FROM Volunteers

LEFT JOIN (select * from Games where Approved=1) g

ON Volunteers.GmId = g.GMid
GROUP BY Volunteers.GmId
HAVING (((Count(g.GameId))=0))
)))
ORDER BY Volunteers.LastName, Volunteers.FirstName, Sessions.SessionBegins;

</cfquery>


<cfquery name="avid" datasource="#ds#" dbtype="ODBC">
	SELECT TOP 1 HoursForFree, DropDeadDate
	FROM ADMIN
</cfquery>

<cfset Participants_proto = QueryNew("GmID, FirstName, LastName, Telephone, Email, Title, SessionBegins, LengthOfGame, Multiplier, Hours, Name")>


<cfoutput query="bigGameList" group="GmId">
	<cfquery name="GMvolunteer" datasource="#ds#" dbtype="ODBC">
	SELECT Volunteers.GmId, Count(VolunteerSessions.SessionId) AS CountOfSessionId, Volunteers.AFTERDEADLINE, Sessions.SessionBegins, Departments.DepartmentName, Sessions.SessionLen, Departments.Multiplier
	FROM ((Volunteers INNER JOIN VolunteerSessions ON Volunteers.VolId = VolunteerSessions.VolId) INNER JOIN Sessions ON VolunteerSessions.SessionId = Sessions.SessionID) INNER JOIN Departments ON Sessions.Type = Departments.DepartmentCode
	GROUP BY Volunteers.GmId, Volunteers.AFTERDEADLINE, Sessions.SessionBegins, Departments.DepartmentName, Sessions.SessionLen, Departments.Multiplier		HAVING (((Volunteers.GmId)=#GmID#))
		ORDER BY Sessions.SessionBegins;
	</cfquery>

	<CFSET TFIRSTNAME = FirstName>
	<cfset TLastName = LastName>
	<cfset TTelephone = Telephone>
	<cfset Temail = email>

	<cfoutput>
		<cfset temp = QueryAddRow(Participants_proto)>
		<cfset temp = querySetCell(Participants_proto, "GmID", GmID)>
		<cfset temp = querySetCell(Participants_proto, "FirstName", tFirstName)>
		<cfset temp = querySetCell(Participants_proto, "LastName", tLastName)>
		<cfset temp = querySetCell(Participants_proto, "Telephone", tTelephone)>
		<cfset temp = querySetCell(Participants_proto, "email", temail)>
		<cfset temp = querySetCell(Participants_proto, "Title", Title)>
		<cfset temp = querySetCell(Participants_proto, "SessionBegins", SessionBegins)>
		<cfset temp = querySetCell(Participants_proto, "LengthOfGame", LengthOfGame)>
		<cfset temp = querySetCell(Participants_proto, "Multiplier", 1)>
		<cfset temp = querySetCell(Participants_proto, "Hours", LengthOfGame)>
		<cfset temp = querySetCell(Participants_proto, "Name", tLastName & ", " & tFirstName)>
	</cfoutput>

		<cfloop query="GMVolunteer">

			<cfset temp = QueryAddRow(Participants_proto)>
			<cfset temp = querySetCell(Participants_proto, "GmID", GmID)>
			<cfset temp = querySetCell(Participants_proto, "FirstName", tFirstName)>
			<cfset temp = querySetCell(Participants_proto, "LastName", tLastName)>
			<cfset temp = querySetCell(Participants_proto, "Telephone", tTelephone)>
			<cfset temp = querySetCell(Participants_proto, "email", temail)>
			<cfset temp = querySetCell(Participants_proto, "Title", "Volunteering - " & DepartmentName)>
			<cfset temp = querySetCell(Participants_proto, "SessionBegins", SessionBegins)>
			<cfset temp = querySetCell(Participants_proto, "LengthOfGame", #SessionLen#)>
			<cfset temp = querySetCell(Participants_proto, "Multiplier", #Multiplier#)>
		    <cfset temp = querySetCell(Participants_proto, "Hours", SessionLen * iif(IsNumeric(Multiplier),Multiplier, 1))>
   		    <cfset temp = querySetCell(Participants_proto, "Name", tLastName & ", " & tFirstName)>
		</cfloop>

</cfoutput>


<CFQUERY name="Participants" dbtype="query">

SELECT * FROM Participants_proto
order by GMID, SessionBegins

</cfquery>

<cfset ttemp = 10000>

<cfoutput query="bigVolunteerList" group="firstname">
	<cfset ttemp = ttemp + 1>
		<cfoutput>
		<cfset temp = QueryAddRow(Participants)>
		<cfset temp = querySetCell(Participants, "GmID", ttemp)>
		<cfset temp = querySetCell(Participants, "FirstName", FirstName)>
		<cfset temp = querySetCell(Participants, "LastName", LastName)>
		<cfset temp = querySetCell(Participants, "Telephone", Telephone)>
		<cfset temp = querySetCell(Participants, "email", Volemail)>
		<cfset temp = querySetCell(Participants, "Title", "Volunteering - " & DepartmentName)>
		<cfset temp = querySetCell(Participants, "SessionBegins", SessionBegins)>
		<cfset temp = querySetCell(Participants, "LengthOfGame", #SessionLen#)>
		<cfset temp = querySetCell(Participants, "Multiplier", #Multiplier#)>
		</cfoutput>
</cfoutput>