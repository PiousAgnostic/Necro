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

<!---BYPASS THE LOGIN IF THEY'VE ALREADY LOGGED-IN--->

<cfif IsDefined("session.loggedingmn")>
<cflocation addtoken="no" url="gameintro.cfm">
</cfif>



<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<title><cfoutput>#SESSION.CONVENTIONNAME#</cfoutput> Gaming Site</title>
<link href='http://fonts.googleapis.com/css?family=Open+Sans:400,300,600,700|Open+Sans+Condensed:300,700' rel='stylesheet' type='text/css'>
<link href="styles/style.css" rel="stylesheet" type="text/css" media="screen" />
<link href="styles/fonts.css" rel="stylesheet" type="text/css" media="all" />
<!---<script type="text/javascript" src="jquery-1.7.1.min.js"></script>--->
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.0/jquery.min.js"></script>
<script src="assets/javascripts/socialProfiles.min.js"></script>
<script type="text/javascript" src="jquery.slidertron-1.1.js"></script>


<CFQUERY name="avid" datasource="#ds#" dbtype="ODBC" cachedWithin="#CreateTimeSpan(0,0,10,0)#">
SELECT TOP 1 CONVENTIONDATE, DropDeadDate, ConventionName, ConventionEnds, Announcement, ParticipationText, LarpText
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

<cfset SESSION.GMINDEX = SESSION.SESSIONNUMBER>


</head>
<link rel="stylesheet" type="text/css" href="styles/main.css">

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
<CFSET BYLINETEXT = "">
<CFIF #TOTALNUMBEROFGAMES# GT 5>
		<cfif DAYSSINCE GT -1>
			<CFSET BYLINETEXT = "There ARE #TOTALNUMBEROFGAMES# games run by #GMs.NumGMs# GMs on the <A href='schedule.cfm'>schedule</A>! "  >
		 <cfelse>
		 	<CFSET BYLINETEXT = "There were #TOTALNUMBEROFGAMES# games run by #GMs.NumGMs# GMs on the <A href='schedule.cfm'>schedule</A>! "  >
		</cfif>
		</FONT>
 </CFIF>
 			<div class="title">
				<h2><cfoutput>#DateString#</cfoutput></h2>
				<span class="byline">Would you like to Participate?</span>
			</div>


			<div class="announcement">

					Log in to volunteer, run a tabletop game, run a LARP, or just to participate in our gaming community.


<!---					If you wish to volunteer, run a tabletop game, or run a LARP, you are at the right place. You'll need to register on the following pages and have your registration approved. Then, you'll be able to volunteer to help out at departments and enter information on games you wish to run at the con.--->
					<p></p>
					Please note that all game information and images must be approved by the <cfoutput><a href="mailto:#SESSION.EMAIL#"></cfoutput>Gaming Administrator</a> before it'll actually appear on the <a href="schedule.cfm">Game Schedule</a>.
					<p>
<!---					<center>

				<table width="75%" align="center" border="1">

					<tr>
					<td>--->


					<form action="guidelines.cfm" method="post">

					<p>Create a new account for the <input type="submit" name="fromIndex" value="First Time">

					</form>

					<p>Or, log in if you've already registered....


					<p>
					<form action="gmlogin.cfm" method="post">
					<div align="center">
					<table>

						<tr>
						<td>Email</td>
							<td colspan=2><input type="text" name="Email" size="20"></td>
						</tr>
						<tr>
							<td>Password</td>
							<td><input type="password" name="Password" size="20"></td>
							<td><input type="submit" name="fromIndex" value="Login"></td>
						</tr>
					</table>
					</form>

					<cfif IsDefined("URL.nologin")>
						<cfif URL.nologin eq "notfound">
							<font color="Red">Error logging in...please try again</font>
						</cfif>
						<cfif URL.nologin eq "cancelled">
							<font color="Red">Your account has been deactivated.<br> Please contact the <cfoutput><a href="mailto:#SESSION.EMAIL#"></cfoutput>Gaming Administrator</a>.</font>
						</cfif>
					</cfif>

<!---					</td>
					</tr>
					</table>--->
</div>
			 </p>
		</div>
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



