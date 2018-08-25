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
<!---<script type="text/javascript" src="jquery-1.7.1.min.js"></script>--->
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.0/jquery.min.js"></script>
<script src="assets/javascripts/socialProfiles.min.js"></script>
<script type="text/javascript" src="jquery.slidertron-1.1.js"></script>




<CFQUERY name="avid" datasource="#ds#" dbtype="ODBC" cachedWithin="#CreateTimeSpan(0,0,10,0)#">
SELECT TOP 1 CONVENTIONDATE, DropDeadDate, ConventionName, ConventionEnds, Announcement, ParticipationText, LarpText, PASSWORD, HOURSFORFREE
			 ,ENCRYPTKEY, RTRIM(ENCRYPTED_PASSWORD) AS ENCRYPTED_PASSWORD
	FROM ADMIN
</CFQUERY>


<CFIF Not IsDefined("Session.Administrator")>

	<cfif IsDefined("form.password")>
		<!--- <CFIF #form.password# neq #AVID.PASSWORD#> --->
		<CFIF trim(ENCRYPT(form.password, avid.ENCRYPTKEY)) NEQ trim(AVID.ENCRYPTED_PASSWORD)>
			<cflocation url="admin.cfm">
		</cfif>
	<cfelse>
			<cflocation url="admin.cfm">
	</cfif>

	<cfset SESSION.ADMINISTRATOR = TRUE>
	<cfset tempvariable = StructDelete(session,"LOGGEDINGMN")>
	<cfset tempvariable = StructDelete(session,"LOGGEDINNAME")>
</cfif>

<cfset SESSION.HOURSFORFREE = #AVID.HOURSFORFREE#>

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
<link rel="stylesheet" type="text/css" href="styles/main.css">
<body onLoad="document.gform.password.focus()">


<div id="wrapper">
	<div id="page" class="container">
		<div id="header" class="container">
			<div id="logo">
				<h1><a href="#"><cfoutput>#SESSION.CONVENTIONNAME#</cfoutput></a></h1>
			</div>

<cfinclude template="menu.cfm">

		</div>
<!---		<div id="banner">
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
		</div>--->



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
				<span class="byline"><cfoutput>#BYLINETEXT#</cfoutput></span>
			</div>




			<iframe name="adminmain" frameborder="0" scrolling="auto" width="750px" height="2000px"></iframe>


			 </p>
		</div>
		<div id="sidebar">
			<div class="box1">
				<div class="title">
					<h2>Administration</h2>
				</div>
<cfinclude template="admincontents.cfm">
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



<!---<frameset cols="200,*" border="0" frameborder="0">
  <frame src="admincontents.cfm" name="contents" frameborder="0" scrolling="Auto" target="main">
  <frame src="adminhome.cfm" name="adminmain" frameborder="0" scrolling="Auto">
  <noframes>
  <body>

  <p>This page uses frames, but your browser doesn't support them.</p>

  </body>
  </noframes>
</frameset>--->

