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
<link href="../styles/style.css" rel="stylesheet" type="text/css" media="screen" />
<link href="../styles/fonts.css" rel="stylesheet" type="text/css" media="all" />
<!---<script type="text/javascript" src="../jquery-1.7.1.min.js"></script>--->
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.0/jquery.min.js"></script>
<script src=../../necro/&quot;assets/javascripts/socialProfiles.min.js&quot;></script></script>
<script type="text/javascript" src="../jquery.slidertron-1.1.js"></script>


<cfparam default="SAVE" name="DISPLAY">

<script type="text/javascript" src="../ckeditor/ckeditor.js"></script>

<CFIF DISPLAY EQ "SAVE" AND
	  ISDEFINED("form.guidelines")>

	<cfquery datasource="#ds#">
		UPDATE ADMIN
		SET LARPGuidelines = '#form.guidelines#'
		</cfquery>


</CFIF>

<script type="text/javascript">
function testURL(url)
{

	var h = (screen.availHeight - 200);
	var w = (screen.availWidth - 100);
	window.open(url,"Test", "toolbar,status,scrollbars,resizable,height="+h.toString()+",width="+w.toString()+",left=50,top=50");
}
</script>


<CFQUERY name="avid" datasource="#ds#" dbtype="ODBC" cachedWithin="#CreateTimeSpan(0,0,10,0)#">
SELECT TOP 1 CONVENTIONDATE, DropDeadDate, ConventionName, ConventionEnds, Announcement, ParticipationText, LarpText, HOURSFORFREE, lastgametime, LarpGuidelines
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

<cfquery name="firstgame" datasource="#ds#">
	SELECT TOP 1  Sessions.SessionBegins
	FROM Sessions
	WHERE (((Sessions.Type)='Game'))
	ORDER BY Sessions.SessionBegins;
</cfquery>

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
<cfset larpmenu="TRUE">
<cfinclude template="../menu.cfm">


		</div>
		<div id="banner">
			<div id="slider">
				<div class="viewer">
					<div class="reel">
						<div class="slide"> <img src="../images/sched-1.jpg" alt="" /> </div>
						<div class="slide"> <img src="../images/sched-3.jpg" alt="" /> </div>
						<div class="slide"> <img src="../images/sched-2.jpg" alt="" /> </div>
						<div class="slide"> <img src="../images/sched-6.jpg" alt="" /> </div>
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
				<span class="byline">Please Read and Confirm our Guidelines</span>
			</div>
			<p>
				<div class="announcement">

<span>

<CFIF DISPLAY EQ "SAVE">
	<div class="guidelines">
	<cfoutput>#avid.LARPGuidelines#</cfoutput>
	<div>
	<FORM method="post">
		<INPUT TYPE="submit" name="DISPLAY" value="EDIT">
	</FORM>
<CFELSE>
	<div id="guidelinesClass">

	<FORM method="post">

		<textarea cols="70"
		  rows="60"
		  id="guidelines"
		  name="guidelines"><cfoutput>#avid.LARPGuidelines#</cfoutput></textarea>

		<INPUT TYPE="submit" name="DISPLAY" value="SAVE">
	</FORM>
	</div>

</CFIF>

</span>
			</div>


			 </p>
		</div>

		<div id="sidebar">
			<div class="box1">
				<div class="title">
					<h2>Our Schedule</h2>
				</div>
				<ul class="style2">
					<li><a href="../schedule.cfm">View By Date</a></li>
					<!---<li><a href="../schedule_by_gm.cfm">View By GM</a></li>
					<li><a href="../schedule_map.cfm">Map View</a></li>--->
					<li><a href="index.cfm">LARP Schedules</a></li>
					<cfif IsDefined("SESSION.LOGGEDINGMN")><li><a href="../personal_schedule.cfm" target="_blank">Your Schedule</a></li></cfif>

				</ul>
			</div>
			<div class="box2">

<cfquery datasource="#ds#" name="recentGames">
SELECT top 10  GameInfo.Title, GameID, Type
FROM GameInfo
WHERE (((GameInfo.Cancelled)=0) AND ((GameInfo.Approved)=-1)) and ((GameInfo.HideOnSchedule = 0))
ORDER BY GameInfo.GameId DESC;
</cfquery>

				<div class="title">
					<h2>Most Recent Games</h2>
				</div>
				<ul class="style2">
					<cfoutput query="recentGames">
						<li><a  <CFIF Type NEQ "LARP">
									href="javascript:testURL('../popup_game.cfm?GameID=#GameID#')"
								<cfelse>
									href="index.cfm"
								</cfif>
						target="_blank"">#Title#</a></li>					</cfoutput>
				</ul>
					<a href="../schedule.cfm" class="icon icon-file-alt button">See All</a> </div>
			</div>
		</div>



	</div>
	<!-- end #page -->
</div>
<div id="footer">
	<p>Copyright (c) 2013 rjritchie.com. All rights reserved. | Design by <a href="http://www.freecsstemplates.org/" rel="nofollow">FreeCSSTemplates.org</a>.</p>
</div>
<!-- end #footer -->
</body>
</html>




<script type="text/javascript">
	CKEDITOR.replace( 'guidelines',
	{
		customConfig : 'ckeditor/config.js',
		toolbar : 'Full',
		height:550,
		resize_enabled:true,
		width:600
	});
</script>
