

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
<script src="../assets/javascripts/socialProfiles.min.js"></script></script>
<script type="text/javascript" src="../jquery.slidertron-1.1.js"></script>


<cfif Not IsDefined("session.LoggedInGMn")>
	<cflocation addtoken="no" url="index.cfm">
</cfif>

<CFPARAM name="SENDEMAIL" default="FALSE">

<CFQUERY name="CURRENTLARPS" datasource="#DS#">
	SELECT MAX(LARPID)+1 AS NEWLARPNUM
	FROM LARPS
</cfquery>

<CFIF CURRENTLARPS.NEWLARPNUM EQ "">
	<CFSET LARPID = 1>
<CFELSE>
	<CFSET LARPID = CURRENTLARPS.NEWLARPNUM>
</cfif>

<cftry>

<!---	The Larp Page is being attacked by mother-frackin' cylons! Not available at this time.--->


 <CFQUERY datasource="#DS#">
	INSERT INTO LARPS
		(LarpID,
		ADDLCOMMENTS,
		DATE_TIME_REQ_1,
		DATE_TIME_REQ_2,
		DATE_TIME_REQ_3,
		EMAIL_ADDRESS,
		GAME_SYSTEM,
		GAME_TITLE,
		GM_NAME,
		GM_NAMES,
		GMID,
		MAXPLAYERS,
		MINPLAYERS,
		SPACEREQ,
		SYNOPSIS,
		WEBSITE,
		DATEADDED)
	VALUES (#LARPID#,
		    '#FORM.ADDLCOMMENTS#',
			'#FORM.DATE_TIME_REQ_1#',
			'#FORM.DATE_TIME_REQ_2#',
			'#FORM.DATE_TIME_REQ_3#',
			'#FORM.EMAIL_ADDRESS#',
			'#FORM.GAME_SYSTEM#',
			'#FORM.GAME_TITLE#',
			'#FORM.GM_NAME#',
			'#FORM.GM_NAMES#',
			<CFIF ISDEFINED("SESSION.LOGGEDINGMN")>#SESSION.LOGGEDINGMN#<CFELSE>-1</CFIF>,
			'#FORM.MAXPLAYERS#',
			'#FORM.MINPLAYERS#',
			'#FORM.SPACEREQ#',
			'#FORM.SYNOPSIS#',
			'#FORM.WEBSITE#',
			#CreateODBCDateTime(Now())#)

</cfquery>
<cfcatch>
	<b>there was a problem adding the larp</b>
	<pre>
<cfoutput>		INSERT INTO LARPS
		(LarpID,
		ADDLCOMMENTS,
		DATE_TIME_REQ_1,
		DATE_TIME_REQ_2,
		DATE_TIME_REQ_3,
		EMAIL_ADDRESS,
		GAME_SYSTEM,
		GAME_TITLE,
		GM_NAME,
		GM_NAMES,
		MAXPLAYERS,
		MINPLAYERS,
		SPACEREQ,
		SYNOPSIS)
	VALUES (#LARPID#,
			'#FORM.ADDLCOMMENTS#',
			'#FORM.DATE_TIME_REQ_1#',
			'#FORM.DATE_TIME_REQ_2#',
			'#FORM.DATE_TIME_REQ_3#',
			'#FORM.EMAIL_ADDRESS#',
			'#FORM.GAME_SYSTEM#',
			'#FORM.GAME_TITLE#',
			'#FORM.GM_NAME#',
			'#FORM.GM_NAMES#',
			'#FORM.MAXPLAYERS#',
			'#FORM.MINPLAYERS#',
			'#FORM.SPACEREQ#',
			'#FORM.SYNOPSIS#')</cfoutput>
	</pre>

	<CFSET SENDEMAIL = FALSE>

</cfcatch>
</cftry>



	<CFQUERY name="newlarp" datasource="#ds#" dbtype="ODBC">
		SELECT * FROM LARPS
		WHERE LARPId = #LARPID#
	</CFQUERY>
<CFIF SENDEMAIL>
<cfinclude template="larpemail.cfm">
</CFIF>

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
				<h2>Game Schedule</h2>
				<span class="byline">Live Action Role Playing</span>
			</div>
			<p>
			<div class="announcement">


	<cfoutput>


	Thank you, <b>#GM_NAME#</b>, for submitting the exciting LARP entitled "<i>#GAME_TITLE#</i>" to #SESSION.CONVENTIONNAME#!
<p>	 You will soon be contacted by Jack & Marna Faber about your entry.
<p>
	If you have any problems or concerns, please email them directly at <a href="mailto:grendel@stonehill.org">grendel@stonehill.org</a>
	 </cfoutput>
	 <p>
	 Click <a href="index.cfm" >here</a> to view the LARP schedule.


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
					<li><a href="../schedule_by_gm.cfm">View By GM</a></li>
					<li><a href="../schedule_map.cfm">Map View</a></li>
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

