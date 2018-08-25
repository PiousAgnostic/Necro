
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!--
Design by Free CSS Templates
http://www.freecsstemplates.org
Released for free under a Creative Commons Attribution 2.5 License

Name       : StylePrecision
Description: A two-column, fixed-width design with dark color scheme.
Version    : 1.0
Released   : 20130720

-->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<title><cfoutput>#SESSION.CONVENTIONNAME#</cfoutput> Gaming Site</title>
<link href='http://fonts.googleapis.com/css?family=Open+Sans:400,300,600,700|Open+Sans+Condensed:300,700' rel='stylesheet' type='text/css'>
<link href="styles/style.css" rel="stylesheet" type="text/css" media="screen" />
<link href="styles/fonts.css" rel="stylesheet" type="text/css" media="all" />
<link href="styles/main.css" rel="stylesheet" type="text/css" media="all" />
<!---<script type="text/javascript" src="jquery-1.7.1.min.js"></script>--->
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.0/jquery.min.js"></script>
<script src="assets/javascripts/socialProfiles.min.js"></script>
<script type="text/javascript" src="jquery.slidertron-1.1.js"></script>

<CFIF Not isDefined("SESSION.LOGGEDINGMN") >
	<cflocation url="gmindex.cfm" addtoken="No">
</cfif>


<CFSET GM = SESSION.LOGGEDINGMN>

<CFQUERY name="avid" datasource="#ds#" dbtype="ODBC">
SELECT TOP 1 *
	FROM ADMIN
</CFQUERY>



<CFQUERY name="GMs" datasource="#ds#" dbtype="ODBC" cachedWithin="#CreateTimeSpan(0,0,10,0)#">
SELECT COUNT(GMid) AS NumGMS
from (
SELECT distinct Games.GMid
FROM Games
WHERE (((Games.Approved)<>0) AND ((Games.HideOnSchedule)=0 Or (Games.HideOnSchedule) Is Null))
) GS
</CFQUERY>

<CFQUERY name="Games" datasource="#ds#" dbtype="ODBC" cachedWithin="#CreateTimeSpan(0,0,10,0)#">
SELECT  COUNT(GMid) AS NumGames
	FROM Games
	WHERE (((Games.[Approved])<>0) AND ((Games.HideOnSchedule)=0 Or (Games.HideOnSchedule) Is Null));
</CFQUERY>


<cfquery datasource="#ds#" name="Larps">
	SELECT count(*) as NumLarps FROM Larps
	WHERE APPROVED = 1
</cfquery>

<cfset TOTALNUMBEROFGAMES = Games.NumGames + Larps.NumLarps>

<CFSET DAYSTILL = DateDiff("y", DateFormat(Now()), avid.ConventionDate)>

<CFSET DAYSSINCE = DateDiff("y", DateFormat(Now()), avid.ConventionEnds)>

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


<cfif IsDefined("GmId")>



	<cfset GmId = ListFirst(GmID)>

	<cfquery name="temp" datasource="#ds#" dbtype="ODBC">
		SELECT * FROM [Game Masters]
		Where GMId = #GmId#;
	</cfquery>


	<cfquery name="GmVol" datasource="#ds#" dbtype="ODBC">
	SELECT * FROM Volunteers
	Where VoleMail  = '#temp.email#'
	</cfquery>


	<cfif GmVol.recordcount eq 1>
		<cfset ThisVolId = #GmVol.VolId#>

		<cfif GmVol.GmId Eq 0>
			<cfquery datasource="#ds#" dbtype="ODBC">
				UPDATE Volunteers
				SET GmId = #GmId#
				WHERE VolId = #GmVol.VolId#;
			</cfquery>
		</cfif>


	<cfelse>
		<cfquery datasource="#ds#" dbtype="ODBC">
			INSERT INTO Volunteers
						(FirstName, LastName, voleMail, Telephone, GmId, AFTERDEADLINE)
			Values		('#temp.FirstName#', '#temp.LastName#','#temp.email#', '#temp.Telephone#', #GmID#, #CreateODBCDate(Now())#);
		</cfquery>

		<cfquery name="temp" datasource="#ds#" dbtype="ODBC">
			SELECT Max(VolId) as MaxId From Volunteers;
		</cfquery>

		<cfset ThisVolId = #temp.MaxId#>

		<cfquery name="GmVol" datasource="#ds#" dbtype="ODBC">
		SELECT * FROM Volunteers
		Where VolID  = #ThisVolId#
		</cfquery>

	</cfif>



	<cfset form.email= #GmVol.Volemail#>
	<cfset VolGm = #GmId#>
</cfif>



<!---
<cfif form.email eq "">
	<cflocation url="vol1.cfm">
</cfif>
 --->

<cfif IsDefined("form.fromVol2")>

	<cfset VolGm = 0>

	<cfif form.GameMaster EQ 1>
		<CFQUERY name="GM" datasource="#ds#" dbtype="ODBC">
		SELECT * FROM [Game Masters]
		WHERE LastName = '#form.LastName#' AND
			  FirstName = '#form.Firstname#' AND
			  email   = '#form.email#'
		</cfquery>

		<cfif Gm.RecordCount EQ 1>
			<cfset VolGm = Gm.GmId>
		</cfif>
	</cfif>



	<!--- Update Volunteer Information --->
	<cfquery datasource="#ds#" dbtype="ODBC">
		UPDATE 	Volunteers
		SET		FirstName = '#Form.FirstName#',
				LastName = '#Form.LastName#',
				Telephone = '#Form.Telephone#',
				GmId = #VolGm#
		Where   VolId = #form.VolId#;
	</cfquery>

	<!--- Delete Old Volunteer Sessions --->
	<cfquery datasource="#ds#" dbtype="ODBC">
		DELETE FROM VolunteerSessions
		Where VolId = #form.VolID#;
	</cfquery>

<!--- 	<cfquery name="allVolSessions" datasource="#ds#" dbtype="ODBC">
		SELECT 	SessionID
		From	Sessions
		Where	Type <> 'Game';
	</cfquery> --->

	<cfquery name="allSessions" datasource="#ds#" dbtype="ODBC">
		SELECT Sessions.SessionBegins, Sessions.SessionID
		FROM Sessions
		WHERE (((Sessions.Type)<>'Game'))
		GROUP BY Sessions.SessionBegins, SessionID
		ORDER BY Sessions.SessionBegins;
	</cfquery>
	<cfset RB = 0>
	<cfoutput query="allSessions">
<!--- 		<cfset RB = RB + 1>
		<cfif IsDefined("form.RB" & RB)>
			<CFSET RBVAL = EVALUATE("form.RB" & RB)>
			<cfif RBVAL NEQ -1>
				<cfquery datasource="#ds#" dbtype="ODBC">
					INSERT INTO VolunteerSessions (VolId, SessionId)
					VALUES (#form.VolId#, #RBVAL#);
				</cfquery>
			</cfif>
		</cfif> --->

		<cfif IsDefined("form.OS" & SessionId)>
			<cfquery datasource="#ds#" dbtype="ODBC">
				INSERT INTO VolunteerSessions (VolId, SessionId)
				VALUES (#form.VolId#, #SessionId#);
			</cfquery>
		</cfif>
	</cfoutput>

<!--- 	<cfoutput query="allVolSessions">
		<cfif IsDefined("form.OS" & #SessionId#)>
			<cfquery datasource="#ds#" dbtype="ODBC">
				INSERT INTO VolunteerSessions (VolId, SessionId)
				VALUES (#form.VolId#, #SessionID#);
			</cfquery>
		</cfif>
	</cfoutput> --->


	<!---  record this client's name --->

	<cfset ClientID = #cfid# & "." & #cftoken#>
	<Cfset ClientName = Trim(form.FirstName) & " " & Trim(form.LastName)>
	<CFSET IP=#CGI.REMOTE_ADDR#>
 	<cftry>
		<cfquery datasource="#ds#">
			UPDATE Clients
			Set ClientName = '#ClientName#'
			WHERE ClientID= '#ClientID#' AND
			      ClientName Is NULL
		</cfquery>
	<cfcatch>
	</cfcatch>
	</cftry>

	 <cftry>
		<cfquery datasource="#ds#">
			UPDATE Clients
			Set ip = '#ip#'
			WHERE ClientID= '#ClientID#' AND
			      ip Is NULL
		</cfquery>
	<cfcatch>
	</cfcatch>
	</cftry>

<cfset SESSION.ADDGMFORM = SESSION.SESSIONNUMBER>
<cflocation url="gameintro.cfm?GM=#Gm.GmId#">


<!--- 	<body bgcolor="#000000" text="#FFFFFF">
	<h1>Volunteer Information</h1>
	<b>Thank you for volunteering for <cfoutput>#HourCount#</cfoutput> Hours!</b>
	</body> --->

</html>
<cfabort>
</cfif>

<cfquery name="avid" datasource="#ds#" dbtype="ODBC">
	SELECT TOP 1 HoursForFree, DropDeadDate, ConventionName
	FROM ADMIN
</cfquery>


<cfquery name="temp" datasource="#ds#" dbtype="ODBC">
	SELECT * FROM Volunteers
	WHERE VoleMail = '#form.email#' ;
</cfquery>

<cfif temp.recordcount eq 1>
	<cfset ThisVolId = #temp.VolId#>
<cfelse>
	<!--- Add this new volunteer	 --->

	<cfquery datasource="#ds#" dbtype="ODBC">
		INSERT INTO Volunteers
					( voleMail, GmId, AFTERDEADLINE)
		Values		('#form.email#', 0, #CREATEODBCDATE(NOW())#);
	</cfquery>

	<cfquery name="temp" datasource="#ds#" dbtype="ODBC">
		SELECT Max(VolId) as MaxId From Volunteers;
	</cfquery>

	<cfset ThisVolId = #temp.MaxId#>
</cfif>

<cfquery name="Volunteer" datasource="#ds#" dbtype="ODBC">
	SELECT * FROM Volunteers
	WHERE VolId = #ThisVolId#;
</cfquery>

<cfquery name="VolSessions" datasource="#ds#" dbtype="ODBC">
	SELECT * FROM VolunteerSessions
	WHERE VolId = #ThisVolId#
</cfquery>

<cfset HerSessions = "">
<cfoutput query="VolSessions">
	<CFSET HerSessions = ListAppend(HerSessions, "#SessionId#", ",")>
</cfoutput>

<cfquery name="OpenSessions" datasource="#ds#" dbtype="ODBC">
SELECT Count(VolunteerSessions.VolId) AS CountOfVolId, Sessions.SessionID, Sessions.SessionBegins, Sessions.SessionEnds, Departments.DepartmentName, Departments.VolunteersPerSession, Departments.Multiplier, Departments.HoursPerSession, Departments.DepartmentCode
FROM (VolunteerSessions RIGHT JOIN Sessions ON VolunteerSessions.SessionId = Sessions.SessionID) INNER JOIN Departments ON Sessions.Type = Departments.DepartmentCode
GROUP BY Sessions.SessionID, Sessions.SessionBegins, Sessions.SessionEnds, Departments.DepartmentName, Departments.VolunteersPerSession, Sessions.Type, Departments.Multiplier, Departments.HoursPerSession, Departments.DepartmentCode
HAVING (((Sessions.Type)<>'Game'))
ORDER BY Departments.DepartmentName, Sessions.SessionBegins;
</cfquery>

<cfparam name="VolGm" default="0">

<cfif #Volunteer.GmId# GT 0>
	<cfset VolGm = Volunteer.GmId>
</cfif>

<cfif #VolGm# GT 0>
	<cfquery datasource="#ds#" dbtype="ODBC">
		DELETE FROM GMGameMap
		Where GMId = #VolGm#
	</cfquery>

	<cfquery name="GmGames" datasource="#ds#" dbtype="ODBC">
		SELECT * FROM GameWithSession
		Where GMId = #VolGm# AND
		      Cancelled = 0 AND
			  Session <> 0;
	</cfquery>

	<cfoutput query="GmGames">
		<cfset BeginTime = #SessionBegins#>
		<cfset TimeSpan = CreateTimeSpan(0, LengthOfGame-1, 59,59)>
		<cfset EndTime = BEginTime + TimeSpan>

		<cfquery datasource="#ds#" dbtype="ODBC">
			INSERT INTO GMGameMap (GMId, GameId, GameStarts, GameEnds)
			VALUES	(#VolGm#, #GameId#, #CreateODBCDAteTime(BeginTime)#, #CreateODBCDateTime(DateAdd("h", ExtraTimeNeeded, EndTime))#);
		</cfquery>

	</cfoutput>
</cfif>

</head>
<body>
<div id="wrapper">
	<div id="page" class="container">
		<div id="header" class="container">
			<div id="logo">
				<h1><a href="#"><cfoutput>#SESSION.CONVENTIONNAME#</cfoutput></a></h1>
			</div>

<cfinclude template="menu.cfm">


		</div>
		<div id="banner">
			<div id="slider">
				<div class="viewer">
					<div class="reel">
						<div class="slide"> <img src="images/2013-1.jpg" alt="" /> </div>
						<div class="slide"> <img src="images/2013-3.jpg" alt="" /> </div>
						<div class="slide"> <img src="images/2013-4.jpg" alt="" /> </div>
						<div class="slide"> <img src="images/2013-2.jpg" alt="" /> </div>
					</div>
				</div>
			</div>
			<script type="text/javascript">
				$('#slider').slidertron({
					viewerSelector: '.viewer',
					reelSelector: '.viewer .reel',
					slidesSelector: '.viewer .reel .slide',
					advanceDelay: 4000,
					speed: 'slow'
				});
			</script>
		</div>



		<div id="content">

 			<div class="title">
				<h2><cfoutput>#DateString#</cfoutput></h2>
				<span class="byline">Your Gaming and Volunteer Commitments</span>
			</div>
			<p>
				<div class="announcement">


<cfform action="vol2.cfm" method="POST" name="gform">

<cfoutput query="Volunteer">
<font size="+2"><b>#Firstname# #Lastname#</b></font>&nbsp;<input type="submit" name="fromVol2" value="Volunteer!" >
			<input type="hidden" name="LastName" value="#LastName#" >
			<input type="hidden" name="FirstName" value="#FirstName#">
			<input type="hidden" name="Telephone" value="#Telephone#">
			<input type="hidden" name="VolId" value="#ThisVolId#">
			<input type="hidden" name="email" value="#VoleMail#">
			<input type="hidden" name="GameMaster" value="1">


</cfoutput>
<p>
<cfoutput>
<b>Please select the sessions and departments for which you'd like to volunteer.<br>
 If you sign up to work <font size="+1">#Avid.HoursForFree# hours</font> at #Avid.ConventionName#
 <!--- before <font color="##FF8040">#DateFormat(Avid.DropDeadDate, "mmmm d")#</font> ---> you will receive refunded admission!<br>
 Your offer to volunteer is subject to <font size="+1">approval</font> by the responsible department head.</b>
<p></cfoutput>
<table cellpadding="3" cellspacing="3">

<cfset RB = 0>

<cfoutput query="OpenSessions" group="DepartmentName">
			<tr >
				<td colspan="4">
					<font size="+2"><b>#DepartmentName#</b></font>
				</td>
			</tr>
<!--- <cfoutput group="SessionBegins">
	<cfset RB = RB + 1>
	<cfset NONESELECTED = TRUE>

			<tr class="#DepartmentCode#" >
				<td width="25">&nbsp;&nbsp;&nbsp;</td>
				<td colspan="3">
					<font size="+1"><b>#DateFormat(SessionBegins, "dddd")# #TimeFormat(SessionBegins, "h tt")#</b></font>
				</td>
			</tr>	 --->
	<cfoutput>
	<cfset gameoverlaps = 0>

	<cfif #Volunteer.GmId# GT 0>
		<cfquery name="CheckGames" datasource="#ds#" dbtype="ODBC">
			SELECT Games.Title, GMGameMap.GmId, GameStarts, GameEnds
			FROM GMGameMap INNER JOIN Games ON GMGameMap.GameId = Games.GameId
			WHERE (((#CreateODBCDAteTime(SessionBegins)# >= GameStarts) AND
				    (#CreateODBCDateTime(SessionBegins)# <= GameEnds   )) OR
				   ((#CreateODBCDAteTime(SessionEnds)# > GameStarts) AND
				    (#CreateODBCDateTime(SessionEnds)# <= GameEnds  ))) AND
					GMGameMap.GmId = #Volunteer.GmId#
		</cfquery>
		<cfif #checkgames.recordcount# neq 0>
			<cfset gameoverlaps = 1>
		</cfif>
	</cfif>

	<cfif gameoverlaps eq 0>
		<cfif (ListFind(HerSessions, #SessionId#) EQ 0) AND
		      (CountOfVolId gte VolunteersPerSession)>
			<tr>
				<td>&nbsp;&nbsp;&nbsp;</td>
				<td>
 					<input type="checkbox" name="OS#SessionId#" value="#SessionId#" disabled>
<!--- 					<input type="Radio" name="RB#RB#" value="#SessionId#" disabled class="rb"> --->

				</td>
				<td>
					<font color="Gray"><b>#DateFormat(SessionBegins, "dddd")# #TimeFormat(SessionBegins, "h tt")#</b>- #DateFormat(SessionEnds, "dddd")# #TimeFormat(SessionEnds, "h tt")# </font>
					<cfif Multiplier GT 1><br>(counts as #Evaluate(Multiplier * HoursPerSession)# hours)</cfif>
				</td>
				<td>This Session is Full</td>
			</tr>
		<CFELSE>
			<tr>
				<td>&nbsp;&nbsp;&nbsp;</td>
				<td>
<!--- 				<input type="Radio" name="RB#RB#" value="#SessionId#"  class="rb" <cfif ListFind(HerSessions, #SessionId#) NEQ 0>checked<cfset NONESELECTED = FALSE></cfif>> --->
					<input type="checkbox" name="OS#SessionId#" value="#SessionId#" <cfif ListFind(HerSessions, #SessionId#) NEQ 0>checked<cfset NONESELECTED = FALSE></cfif>

				</td>
				<td>
					<b>#DateFormat(SessionBegins, "dddd")# #TimeFormat(SessionBegins, "h tt")#</b>- #DateFormat(SessionEnds, "dddd")# #TimeFormat(SessionEnds, "h tt")#  </b>
					<cfif Multiplier GT 1><br>(counts as #Evaluate(Multiplier * HoursPerSession)# hours)</cfif>
				</td>
				<td></td>
			</tr>
		</cfif>
	<cfelse>
		<tr>
				<td>&nbsp;&nbsp;&nbsp;</td>
			<td>
 				<input type="checkbox" name="OS#SessionId#" value="#SessionId#" disabled>
<!--- 					<input type="Radio" name="RB#RB#" value="#SessionId#" disabled  class="rb">		 --->
			</td>
			<td>
				<font color="Gray"> <b>#DateFormat(SessionBegins, "dddd")# #TimeFormat(SessionBegins, "h tt")#</b>-'till #DateFormat(SessionEnds, "dddd")# #TimeFormat(SessionEnds, "h tt")#  </font>
					<cfif Multiplier GT 1><br>(counts as #Evaluate(Multiplier * HoursPerSession)# hours)</cfif>
			</td>
			<td><i>#checkgames.Title#</i> overlaps this session </td>
		</tr>
	</cfif>
	</cfoutput>

<!--- 	<tr>
		<td>
				<input type="Radio" name="RB#RB#" value="-1"<CFIF NONESELECTED> checked</cfif>  class="rb">
		</td>
		<td>
			<i>Not Volunteering this Session</i>
		</td>
		<td></td>
	</tr>
</cfoutput>--->
<tr>
	<td colspan="4"><hr></td>
</tr>
</cfoutput>
</table>
<!--- <p>
<input type="submit" name="fromVol2" value="Volunteer!"> --->

</cfform>
</div>
			 </p>

		</div>
		<div id="sidebar">
			<div class="box1">
				<div class="title">
					<h2>Our Schedule</h2>
				</div>
				<ul class="style2">
				<!---
					<li><a href="schedule.cfm">Game Schedule</a></li>
					<li><a href="schedule_by_gm.cfm">View By GM</a></li>
				--->
					<li><a href="schedule.cfm">Game Schedule</a></li>

					<!--- <li><a href="schedule_map.cfm">Map View</a></li>
					<cfinclude template="Map_View_Menu.cfm">--->

					<li><a href="larp/index.cfm">LARP Schedules</a></li>
					<cfif IsDefined("SESSION.LOGGEDINGMN")><li><a href="personal_schedule.cfm" target="_blank">Your Schedule</a></li></cfif>

				</ul>
			</div>
<cfinclude template="sideBar.cfm">

	<!-- end #page -->
</div>
<div id="footer">
	<p>Copyright (c) 2013 rjritchie.com. All rights reserved. | Design by <a href="http://www.freecsstemplates.org/" rel="nofollow">FreeCSSTemplates.org</a>.</p>
</div>
<!-- end #footer -->
</body>
</html>

