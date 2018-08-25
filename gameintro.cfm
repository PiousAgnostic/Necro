
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

<cfset tempvariable = StructDelete(session,"ADDGMFORM")>

<script language="JavaScript">
	function editGame(gameNo)
	{
		document.smallform.GameId.value = gameNo;
		document.smallform.submit();
	}


	function volun()
	{
		document.volunteer.submit();
	}


	function goBack()
	{
		document.goBack.submit();
	}

	function goLarp()
	{

		document.larper.submit();


	}

	function openPersonalSchedule(url)
	{

		var h = (screen.availHeight - 400);
		var w = (screen.availWidth - 400);
		var l = (screen.availWidth / 2) - (w / 2)
		window.open(url,"Test", "toolbar,menubar,status,scrollbars,resizable,height="+h.toString()+",width="+w.toString()+",left="+l.toString()+",top=50");
	}

	function testURL(url)
	{

		var h = (screen.availHeight - 200);
		var w = (screen.availWidth - 100);
		window.open(url,"Test", "toolbar,status,scrollbars,resizable,height="+h.toString()+",width="+w.toString()+",left=50,top=50");
	}
</script>


>


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

<!---PUT PAGE STUFF HERE--->

<cfquery name="GMs" datasource="#ds#" dbtype="ODBC">
	SELECT * FROM [Game Masters]
	WHERE GmId = #GM#
</cfquery>

<cfset ThisDropDeadDate = avid.DropDeadDate>

<cfif IsDate(GMs.ExtendedDeadline)>
	<CFIF DateCompare(GMs.ExtendedDeadline,avid.DropDeadDate, "D") GT 0>
		<cfset ThisDropDeadDate = GMs.ExtendedDeadline>
	</cfif>
</cfif>

<cfif GMs.APPROVED EQ 0>
	<CFLOCATION url="gmnotyetapproved.cfm">
</cfif>

<cfquery name="Games" datasource="#ds#" dbtype="ODBC">
	SELECT GMID, Title, System, Session, SessionDate, SessionBegins, LengthOfGame, Cancelled, Approved, Image, ImageApproved, GameID
	FROM Games
		left join Sessions on games.session = sessions.SessionID
	WHERE GmId = #GM#
	ORDER BY Approved, TITLE
</cfquery>

<cfquery name="LarpSchedule" datasource="#ds#" dbtype="ODBC">

	SELECT *
	FROM (

		SELECT *,

			DATENAME(dw, [DateOfLarp]) as WeekDay,
			CONVERT(char(10), [DateOfLarp],126) as SessionDate,
			Left([Larps].[DATEOFLARPSTRING],CHARINDEX (' ',[DATEOFLARPSTRING])-3) + ':00' +  SUBSTRING ([DATEOFLARPSTRING],CHARINDEX (' ',[DATEOFLARPSTRING])-2,2) AS SessionStart,
			'' AS SessionEnd
		FROM Larps
		WHERE GmID = #Gm#
	) SUBQ
	ORDER BY APPROVED
</cfquery>


<cfquery name="VolSessions" datasource="#ds#" dbtype="ODBC">
	SELECT Volunteers.GmId, Count(VolunteerSessions.SessionId) AS CountOfSessionId, Sum([SessionLen]*[Multiplier]) AS SumOfSessionLen, Max(Departments.Multiplier) AS MaxOfMultiplier
	FROM ((Volunteers INNER JOIN VolunteerSessions ON Volunteers.VolId = VolunteerSessions.VolId) INNER JOIN Sessions ON VolunteerSessions.SessionId = Sessions.SessionID) INNER JOIN Departments ON Sessions.Type = Departments.DepartmentCode
	GROUP BY Volunteers.GmId
	HAVING Volunteers.GmId=#GM#;
</cfquery>
<!---
<cfquery name="LarpVolunteerSessions" datasource="#ds#">
SELECT Volunteers.GmId, Count(VolunteerSessions.SessionId) AS CountOfSessionId, Sum([SessionLen]*[Multiplier]) AS SumOfSessionLen, Max(Departments.Multiplier) AS MaxOfMultiplier
FROM ((Volunteers INNER JOIN VolunteerSessions ON Volunteers.VolId = VolunteerSessions.VolId) INNER JOIN Sessions ON VolunteerSessions.SessionId = Sessions.SessionID) INNER JOIN Departments ON Sessions.Type = Departments.DepartmentCode
WHERE (((Departments.DepartmentCode)='LARPHQ'))
GROUP BY Volunteers.GmId
HAVING (((Volunteers.GmId)=#GM#));
</cfquery>

<CFQUERY name="CurrentLarpVolunteerSituations" datasource="#ds#">
SELECT Departments.VolunteersPerSession * Count(Sessions.SessionID) AS CountOfLarpSlots, Count(VolunteerSessions.VolId) AS CountOfLarpVolunteers
FROM (Sessions INNER JOIN Departments ON Sessions.Type = Departments.DepartmentCode) LEFT JOIN VolunteerSessions ON Sessions.SessionID = VolunteerSessions.SessionId
GROUP BY Sessions.Type, Departments.VolunteersPerSession
HAVING (((Sessions.Type)='LARPHQ'));
</CFQUERY>
--->

<cfset VolModified = "">
<cfif VolSessions.RECORDCOUNT GT 0>
	<cfset VolHours = VolSessions.SumOfSessionLen>
	<cfif VolSessions.MaxOfMultiplier GT 1>
		<cfset VolModified = "&nbsp;(modified)">
	</cfif>
<cfelse>
	<cfset VolHours = 0>
</cfif>


<cfset DaysTillOpenSite = DateDiff("d", Now(), avid.DateToOpenSite)>
<cfset DaysLeftToVolunteer = DateDiff("d", Now(), avid.LastDateToVolunteer)>

<cfoutput query="GMs">

<table width="100%">
<tr>
	<td align="left">
		<input type="Button" value="#FirstName# #MiddleName# <cfif #Alias# GT "">"#Alias#" </cfif> #LastName#" onClick="document.location.href='gmform.cfm'"/>
<b> is currently  <input type="Button"  <cfif (over18 NEQ "Yes") or (DaysTillOpenSite GT 0) or (DaysLeftToVolunteer LT 0)> disabled  title="You must be 18 years or older to volunteer"</cfif> onClick="if (volun) volun()" value="Volunteering">
 for #VolHours# hours#VolModified#. </b>
	</td>
	<td align="right">
		<b><a href="guidelines.cfm?review="Yes"">GM Guidelines</a></b>
	</td>
</tr>
</table>
</cfoutput>
<p>
<cfif DateCompare(ThisDropDeadDate,Now(), "D") LT 0>
	<cfoutput>
		<font size="+1" color="Red">
			The deadline for adding new games was #DateFormat(ThisDropDeadDate, "mm/dd/yyyy")#.
			Click <a href="mailto:#SESSION.EMAIL#">here</a> to beg for an extension.
		</font>
	</cfoutput>
</cfif>
<table cellpadding="3">
	<tr >
		<th></th>
		<th id="gi_heading">Game Title</th>
		<th id="gi_heading">Game System</th>
		<th id="gi_heading">Session</th>
		<th id="gi_heading">Game Length</th>
		<th id="gi_heading">Status</th>
		<th id="gi_heading">Image</th>
		<th id="gi_heading">Views</th>
		<th id="gi_heading">Likes</th>
 </tr>
<cfoutput query="Games">
	<tr>
		<td><Button onClick="editGame(#GameID#)">Edit</button></td>
		<td id="gi_row">#Title#</td>
		<td id="gi_row">#System#</td>
		<td id="gi_row" align="Center">
		<cfif #Session# GT 0>
			#DateFormat(SessionDate, "dddd")#, #TimeFormat(SessionBegins, "h:mmtt")#
		<cfelse>
				<i>Not Assigned</i>
		</cfif>
		</td>
		<td id="gi_row" align="Center">
			#LengthOfGame# hours
		</td>
		<td id="gi_row" align="Center">
		<cfif #Cancelled# NEQ 0>
			Cancelled
		<Cfelse>
			<cfif #Approved# NEQ 0>
				Approved
			<cfelse>
				Unapproved
			</cfif>
		</cfif>
		</td>
		<td id="gi_row" align="Center">
			<cfif #Image# EQ "">
				<i>None</i>
			<cfelse>
				<cfif #ImageApproved# NEQ 0>
					Approved
				<cfelse>
					Unapproved
				</cfif>
			</cfif>
		</td>

		<td id="gi_row" align="Center">
			<cfset NumberOfViews = 0>

			<cfquery name="numviews" datasource="#ds#">
				SELECT GameViews.Views
				FROM GameViews
				WHERE (((GameViews.GameID)=#GameID#));
			</cfquery>

			<CFIF numviews.recordcount eq 1><cfset NumberOfViews = numviews.Views></CFIF>
			<span title="Your game description has been viewed this many times" style="cursor:help">#NumberOfViews#</span>
		</td>

		<td id="gi_row" align="Center">
			<cfset AmountOfInterest = 0>

			<cfquery name="amtint" datasource="#ds#">
				SELECT GameInterest.GameID, Count(IPAddress) AS Interest
				FROM GameInterest
				where GameID = #GameID#
				GROUP BY GameInterest.GameID

			</cfquery>

			<CFIF amtint.recordcount eq 1><cfset AmountOfInterest = amtint.Interest></CFIF>
			<span title="This many people have clicked the 'I'll Play' button" style="cursor:help">#AmountOfInterest#
		</td>

	</tr>
</cfoutput>

<cfoutput QUERY="LarpSchedule">
	<tr>
		<td><!---<Button>Edit</button>---></td>
		<td id="li_row">#GAME_Title#</td>
		<td id="li_row">#GAME_SYSTEM#</td>
		<td id="li_row" align="Center">
		<cfif #weekday# GT "">
			#WeekDay#, #SessionStart#
		<cfelse>
				<i>Not Assigned</i>
		</cfif>
		</td>
		<td id="li_row" align="Center">
			#LengthOfGame# hours
		</td>
		<td id="li_row" align="Center">
			<cfif #Approved# NEQ 0>
				Approved
			<cfelse>
				Unapproved
			</cfif>
		</td>
		<td id="li_row" align="Center">
			<i><CFIF IMAGEURL GT "">Yes<cfelse>None</cfif></i>
		</td>

		<td id="li_row" align="Center">n/a</td>

		<td id="li_row" align="Center">n/a</td>

	</tr>

</CFOUTPUT>

 	<tr>
		<td>&nbsp;</td>
		<td colspan=17>
		<CFIF (DaysTillOpenSite gt 0)>
					<font size="+1" font-variant: small-caps; font-style: italic;">Game registration will open on <cfoutput>#Dateformat(avid.DateToOpenSite, "MMMM d, yyyy")#</font></cfoutput>

		<CFELSE>
 			<table width="100%">
			<tr>

				<td width="33%" align="left">
					<cfif (DateCompare(ThisDropDeadDate,Now(), "D") GTE 0) >
						<button onClick="editGame(-1)">Add Game</button>
						&nbsp;
						<input type="Button"  onClick="goLarp()" value="Add LARP">
					</cfif>
				</td>
				<td width="33%" align="center">
				<cfoutput query="GMs">
				<input type="Button"  <cfif (over18 NEQ "Yes") or (DaysTillOpenSite GT 0) or (DaysLeftToVolunteer LT 0)> disabled  title="You must be 18 years or older to volunteer"</cfif> onClick="if (volun) volun()" value="Click Here to Volunteer">
				</cfoutput>
				</td>
				<cfoutput>
				<td width="33%" align="right">
					<button onClick="javascript:openPersonalSchedule('personal_schedule.cfm?PSgmID=#GM#');">Your Schedule</button>
				</td>
				</cfoutput>
			</tr>


			</table>

		</CFIF>






		</td>
	</tr>


</table>
<cfoutput>

</cfoutput><p>
<cfset GMActivityGmId = #GMs.GMID#>
<cfset GmActivityLengthOfGame = 4>

<cfset ShowAllRooms = TRUE>

<cfinclude template="showGMActivity.cfm">

<form name="smallform" method="post" action="gameform.cfm">
<input type="Hidden" name="GameId">
<input type="Hidden" name="GMId" value=<cfoutput>"#GM#"</cfoutput>>
</form>
<p>
Click <a href="schedule.cfm">here</a> to inspect the Game Schedule<br>
<!---Click <a href="javascript:goBack()">here</a> to return to GM Information Maintenance.<br>
 Click <a href="gmindex.cfm">here</a> to log out completely.<br> --->
<cfoutput query="GMs">
<form name="goBack" method="post" action="gmform.cfm">

<input type="Hidden" name="FirstName" value="#FirstName#">
<input type="Hidden" name="LastName" value="#LastName#">
<input type="Hidden" name="Password" value="#Password#">
<input type="hidden" name="fromIndex" value="Let Me In!">

</form>

<form name="volunteer" method="post" action="vol2.cfm">
	<input type="Hidden" name="gmId" value=#GMID#>
</form>

<form name="larper" method="post" action="larp/gmrules.cfm">
	<input type="hidden" name="gmId" value=#GMID#>
</form>

</cfoutput>


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
