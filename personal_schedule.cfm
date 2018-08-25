
<CFQUERY name="avid" datasource="#ds#" dbtype="ODBC">
SELECT TOP 1 CONVENTIONDATE, DropDeadDate, ConventionName, ConventionEnds, Announcement
	FROM ADMIN
</CFQUERY>
<html>
<head>
	<title><cfoutput>#avid.ConventionName#</cfoutput> Your Schedule</title>
</head>

<cfif NOT IsDefined("SESSION.LOGGEDINGMN")>
	<cfset PSgmID = -1>
<CFELSE>
	<cfset PSgmID = SESSION.LOGGEDINGMN>
</cfif>

<cfif IsDefined("PSgmID")>
	<cfquery name="GMs" datasource="#ds#" dbtype="ODBC">
		SELECT * FROM [Game Masters]
		WHERE GmId = #PSgmID#
	</cfquery>

</cfif>





	<CFQUERY name="ScheduleGames" datasource="#ds#">
			SELECT 		SessionDate,
						SessionBegins,
						Type,
						System,
						Title,
						GM,
						Schedule.GMid,
						Description,
						AdultOnly,
						NumPlayers,
						RoleplayingStressed,
						Schedule.GameId,
						LengthOfGame,
						CLUBICON
			FROM Schedule
				LEFT JOIN GameInterest PSE ON Schedule.GameId = PSE.GameID
			WHERE PSE.IPAddress = '#PSgmID#'
			   or Schedule.GMID = #psgmid#
	</cfquery>


	<cfquery name="ScheduleLarps" datasource="#ds#" dbtype="ODBC">

			SELECT	    DateOfLarp as SessionDate,
						CAST (
						CONVERT(char(10), [DateOfLarp],126) + ' ' +
						(Left([Larps].[DATEOFLARPSTRING],CHARINDEX (' ',[DATEOFLARPSTRING])-3) + ':00:00 ' + SUBSTRING ([DATEOFLARPSTRING],CHARINDEX (' ',[DATEOFLARPSTRING])-2,2)) AS DATETIME) as SessionBegins,
						'LARP' as Type,
						GAME_SYSTEM as System,
						GAME_TITLE as title,
						GM_NAME as GM,
						-2 as GMid,
						[SYNOPSIS] as Description,
						0 as AdultOnly,
						CAST(MINPLAYERS AS INT)  as NumPlayers,
						1 as RoleplayingStressed ,
						LarpID+10000 as GameID,
						LengthOfGame, ''
			FROM        Larps
				LEFT JOIN GameInterest PSE ON Larps.LarpID+10000 = PSE.GameID
			WHERE APPROVED = 1
			and PSE.IPAddress = '#PSgmID#'
	</cfquery>

	<cfif IsDefined("SESSION.LOGGEDINGMN")>
		<cfset thisGM = SESSION.LOGGEDINGMN>
	<cfelse>
		<cfset thisGM = -1>
	</cfif>

	<cfquery name="ScheduleVolunteering" datasource="#ds#">
			SELECT 		Sessions.SessionDate,
						Sessions.SessionBegins,
						Sessions.Type,
						'VOL' AS Expr1,
						DepartmentName AS Expr2,
						CASE
							WHEN [Game Masters].[Alias] = '' then [Game Masters].[FirstName] + ' ' + [Game Masters].[LastName]
							ELSE [Game Masters].[Alias]
						END AS GM,
						[Game Masters].GMId,
						'' AS Description,
						0 AS AdultOnly,
						0 AS NumPlayers,
						1 AS RoleplayingStressede,
						VolunteerSessions.VolId,
						Sessions.SessionLen,
						''
			FROM (((Volunteers INNER JOIN VolunteerSessions ON Volunteers.VolId = VolunteerSessions.VolId)
			INNER JOIN Sessions ON VolunteerSessions.SessionId = Sessions.SessionID)
			INNER JOIN Departments ON Sessions.Type = Departments.DepartmentCode)
			INNER JOIN [Game Masters] ON Volunteers.GmId = [Game Masters].GMId
			WHERE VOLUNTEERS.GMID=#SESSION.LOGGEDINGMN#
	</cfquery>


	<Cfquery name="schedule" dbtype="query">
		select * from schedulegames
		union
		select * from schedulelarps
		union
		select * from ScheduleVolunteering
		ORDER BY 	SessionDate, SessionBegins, Type, System, Title

	</cfquery>

<cfset STARTMONTH = MonthAsString(DatePart( "m", avid.ConventionDate))>
<cfset STARTDATE  = DAtePart("d", avid.ConventionDate)>
<cfset STARTYEAR  = DatePart("yyyy", avid.ConventionDate)>

<cfset ENDMONTH = MonthAsString(DatePart("m", avid.ConventionEnds))>
<cfset ENDDATE  = DatePart("d", avid.ConventionEnds)>
<cfset ENDYEAR  = DatePart("yyyy", avid.ConventionEnds)>

<cfset DATESTRING = STARTMONTH & " " & STARTDATE>
<CFIF AVID.CONVENTIONDATE neq AVID.CONVENTIONENDS>
	<CFIF STARTYEAR NEQ ENDYEAR>
		<cfset DATESTRING = DATESTRING & ", " & STARTYEAR & " - " & ENDMONTH & " " & ENDDATE & ", " & ENDYEAR>
	<CFELSE>
		<CFIF STARTMONTH neq ENDMONTH>
			<cfset DATESTRING = DATESTRING & " - " & ENDMONTH & " " & ENDDATE & ", " & ENDYEAR>
		<CFELSE>
			<CFSET DATESTRING = DATESTRING & "-" & ENDDATE & 	", " & ENDYEAR>
		</cfif>
	</cfif>
<CFELSE>
	<CFSET DATESTRING = DATESTRING & ", " & STARTYEAR>
</cfif>


<body>
<center>


<font size="+2"><cfoutput>#avid.ConventionName#</cfoutput></font><br>
<font size="+1"><cfoutput>#DATESTRING#<BR></cfoutput>Tampa, Florida<br></font>
<b>Personalized Schedule</b>
<cfif PSgmID neQ -1>
	<cfoutput query="GMs">
		<br>#FirstName#&nbsp;
		<cfif Alias GT "">
			"#Alias#"&nbsp;
		</cfif>
		#LastName#
	</cfoutput>
</cfif>
<p>
NOTE: Players must sign up for games on-site an hour before game time. There is no way to sign up to <em>play</em> games on-line. 'Liking' a game makes it available on this schedule for your convenience only.
<p>
<cfoutput query="Schedule" group="SessionDate">
		<font size="+2">#DateFormat(SessionBegins, "dddd mmm dd")#</font><br>
		<cfoutput>
		<cfif System NEQ "VOL" and System NEQ "EVENT">
				<span <cfif PSgmID neq GMID >id="GM#GAMEID#"</cfif>
			 STYLE="display: inline; padding-left:  50px;">
			<table width="100%"
				<cfif PSgmID eq GMID>bgcolor="##E4E4E4"</cfif>
			>
			<tr>
				<td colspan="3"><b>#TimeFormat(SessionBegins, "h:mm tt")#</b></td>
			</tr>
			<tr>
				<td width="40px">&nbsp;</td>
				<td width="15%"><b>Game:</b></td>
				<td> #Title#	</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td><b>System:</b></td>
				<td>#System#</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td><b>Type:</b></td>
				<td>#Type#</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td><b>GM:</b></td>
				<td>#GM#</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td><b>## Players:</b></td>
				<td>#NumPlayers#</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td><b>Game Length:</b></td>
				<td>#LengthOfGame# hours</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td valign="top"><b>Description:</b>
				<cfif CLUBICON NEQ ''>
					<P align="center">
					<img src="clubs/clubimages/#CLUBICON#" border="0" align="middle">
					</P>
				</cfif>
				</td>
				<td>#Description#</td>
			</tr>
			<tr>
				<td colspan="3"><hr></td>
			</tr>
			</table>

			</span>
		<cfelseif System EQ "VOL">


			<span STYLE="display: inline; padding-left:  50px;" >
			<table width="100%"
				<cfif PSgmID eq GMID>bgcolor="##E4E4E4"</cfif>
			>
						<tr>
			<td colspan="3"><b>#TimeFormat(SessionBegins, "h:mm tt")#</b></td>
			</tr>
			<tr>
				<td width="40px">&nbsp;</td>
				<td width="15%"><b>Volunteering:</b></td>
				<td> #Title#	</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td><b>Volunteer:</b></td>
				<td>#GM#</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td><b>Length:</b></td>
				<td>#LengthOfGame# hours</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td><strong>Until:</strong></td>
				<td>#TimeFormat(DateAdd("h", LEngthOfGame, SessionBegins), "h:mm tt")#</td>
			</tr>
			</table>
			</span>
		<cfelseif System EQ "EVENT">


			<span STYLE="display: inline; padding-left:  50px;" id="GM#GAMEID#">
			<table width="100%" bgcolor="00FFFF" >
						<tr>
			<td colspan="3"><b>#TimeFormat(SessionBegins, "h:mm tt")#</b></td>
			</tr>
			<tr>
				<td width="40px">&nbsp;</td>
				<td width="15%"><b>Event:</b></td>
				<td> #Title#	</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td><b>Length:</b></td>
				<td>#LengthOfGame# hours</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td><strong>Until:</strong></td>
				<td>#TimeFormat(DateAdd("h", LEngthOfGame, SessionBegins), "h:mm tt")#</td>
			</tr>
			</table>
			</span>
		</cfif>


		</cfoutput>


</cfoutput>
</table>
</center>
<!---<script language="JavaScript">
<cfoutput query="Schedule">
	<cfif PSgmID neq GMID AND System NEQ "VOL">

	if ((psched.g#GameID# != 1) && (psched.g#GameID# != 0))
	{
		psched.g#GameID# = 0;
	}

	if (psched.g#GameID# == 0)
		document.getElementById("GM" + #GAMEID#).style.display ="none"
	</CFIF>
</cfoutput>
</script>--->
</body>
</html>
