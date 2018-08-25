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

<cfquery name="GMs" datasource="#ds#" dbtype="ODBC">
	SELECT * FROM [Game Masters]
	WHERE GmId = #gmId#
</cfquery>



<script language="JavaScript">

function checkout(frm)
{
	if (frm.GM_name.value == "")
	{
		alert("Please enter your name, Storyteller!")
		return false
	}

	if (frm.email_address.value == "")
	{
		alert("Please enter your email address, Storyteller!")
		return false
	}

	return confirm("Are you sure you're ready to submit your Larp?")
}

</script>


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



If you would like to sign up to run a LARP, fill out the following registration form and send it in. <p></p>

<!--<h3>	The Larp Page is being attacked by mother-frackin' cylons! Not available at this time.</h3>

-->

<cfoutput query="GMs">

<FORM ACTION="formmail.cfm" name="fform" METHOD="post" onSubmit="return checkout(this)">

<input type=hidden name="subject" value="LARP GM Reg Form">
<table width="100%">
<tr>
	<td width="20%" valign="top"><b>Storyteller Name:</b></td>
	<td><INPUT NAME="GM_name" TYPE="text" value="#FirstName# #LastName#" size=40></td>
</tr>
<tr>
	<td width="20%" valign="top"><b>Email address:</b></td>
	<td><INPUT TYPE="Text" NAME="email_address" size=40 value="#email#" readonly="true" ></td>
</tr>
<tr>
	<td width="20%" valign="top"><b>Game Title:</b></td>
	<td><INPUT TYPE="Text" NAME="Game_Title" size=60 value=""></td>
</tr>
<tr>
	<td width="20%" valign="top"><b>Game System (if applicable):</b></td>
	<td><INPUT TYPE="Text" NAME="Game_System" size=60 value=""></td>
</tr>
<tr>
	<td width="20%" valign="top"><b>Recommended ## of Players:</b></td>
	<td>Min:<INPUT TYPE="Text" NAME="MinPlayers" size=2 >&nbsp;
	    Max:<INPUT TYPE="Text" NAME="MaxPlayers" size=2 ></td>
</tr>
<tr>
	<td colspan="2"><b>Day(s) and Time(s) Requested:</b></td>
</tr>
<tr>
	<td width="20%" valign="top"><b>1st choice</b></td>
	<td><INPUT TYPE="Text" NAME="Date_time_req_1" size=30 value=""></td>
</tr>
<tr>
	<td width="20%" valign="top"><b>2nd choice</b></td>
	<td><INPUT TYPE="Text" NAME="Date_time_req_2" size=30 value=""></td>
</tr>
<tr>
	<td width="20%" valign="top"><b>3rd choice</b></td>
	<td><INPUT TYPE="Text" NAME="Date_time_req_3" size=30 value=""></td>
</tr>
<tr>
	<td width="20%" valign="top"><b>Add'l Storyteller Names:</b></td>
	<td><TEXTAREA NAME="GM_Names"  ROWS="3" COLS="65" onFocus="this.select()">(Up to three additional Storytellers are eligible for discounted admission.)</TEXTAREA></td>
</tr>
<tr>
	<td width="20%" valign="top"><b>Game Synopsis:</b></td>
	<td><TEXTAREA NAME="Synopsis" ROWS="6" COLS="65" WRAP="virtual" onFocus="this.select()"></TEXTAREA></td>
</tr>
<tr>
	<td width="20%" valign="top"><b>Additional Comments:</b></td>
	<td><TEXTAREA NAME="AddlComments" ROWS="6" COLS="65" WRAP="virtual" onFocus="this.select()"></TEXTAREA></td>
</tr>
<tr>
	<td width="20%" valign="top"><b>Space Requirements:</b></td>
	<td><TEXTAREA NAME="SpaceReq" ROWS="6" COLS="65" WRAP="virtual" onFocus="this.select()">(If you need some sort of base or headquarters space, please let us know.)</TEXTAREA></td>
</tr>
<tr>
	<td width="20%" valign="top"><b>Game Web Site (if any):</b></td>
	<td><INPUT TYPE="Text" NAME="WEBSITE" size=60 value=""></td>
</tr>
</table>
<INPUT TYPE="Submit" NAME="Submit" VALUE="Save"><!--- &nbsp; <sup>*</sup> Required fields --->
</FORM>
</p>

</font>
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



