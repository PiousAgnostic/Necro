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
<!---<!---<script type="text/javascript" src="../jquery-1.7.1.min.js"></script>--->
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.0/jquery.min.js"></script>
<script src="../../necro/larp/assets/javascripts/socialProfiles.min.js"></script></script>--->
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.0/jquery.min.js"></script>
<script src="../assets/javascripts/socialProfiles.min.js"></script>
<script type="text/javascript" src="../jquery.slidertron-1.1.js"></script>

<script type="text/javascript">

	function testURL(url)
	{

		var h = (screen.availHeight - 200);
		var w = (screen.availWidth - 100);
		window.open(url,"Test", "toolbar,status,scrollbars,resizable,height="+h.toString()+",width="+w.toString()+",left=50,top=50");
	}

	function openPersonalSchedule(url)
	{

		var h = (screen.availHeight - 400);
		var w = (screen.availWidth - 400);
		var l = (screen.availWidth / 2) - (w / 2)
		window.open(url,"Test", "toolbar,menubar,status,scrollbars,resizable,height="+h.toString()+",width="+w.toString()+",left="+l.toString()+",top=50");
	}

</script>

<cfquery datasource="#ds#" name="Larps">
	SELECT * FROM Larps
	WHERE APPROVED = 1	Order by DATEOFLARP,  LarpID
</cfquery>

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

<cfoutput query="Larps" group="DATEOFLARP">

<FONT size="+3">#DateFormat(DateOfLarp, "dddd")#</font>
	<cfoutput>

	<cfset anchor = 10000 + LarpID>
	<a name="L#anchor#"></a>
		<table width="100%" border="1" cellpadding="2" >
		  <TR>
		    <TD rowspan="7" valign="top" align="left">
			<cfif (#imageurl# GT "")>
				<table align="left">
				<tr><td align="center">
<!---					<A href="#imageurl#" target="_blank">
--->						<img src="#imageurl#"  BORDER="0" width="250px">
<!---					</a>
--->				</td></tr>
				</table>
			</cfif>
			</TD>
		    <TD valign="top"><font size="+1">Game Title</font></TD>
		    <TD valign="top"><font size="+1"><cfif TRIM(WEBSITE) gt ""><A HREF="#WEBSITE#" target="_blank" title="Click here to visit our website!"></cfif>#GAME_TITLE#</a></font></TD>
		  </TR>
		  <TR>
		  	<TD valign="top"><font size="+1">Game System</font></TD>
			<TD valign="top"><font size="+1">#GAME_SYSTEM#</font></TD>
		  </TR>
		  <TR>
			<TD valign="top"><font size="+1">Recomended ## of Players</font></TD>
		    <TD valign="top"><font size="+1">#MINPLAYERS#</TD>
		  </TR>
		  <TR>
			<TD valign="top"><font size="+1">Max ## of Players</font></TD>
		    <TD valign="top"><font size="+1">#MAXPLAYERS#</TD>
		  </TR>
		  <TR>
			<TD valign="top"><font size="+1">Time<br></font></TD>
		    <TD valign="top"><font size="+1">#DATEOFLARPSTRING#</font></TD>
		  </TR>
		  <TR>
			<TD valign="top"><font size="+1">Game Master(s)</font></TD>
		    <TD valign="top"><font size="+1">#GM_NAME#<br>
				#GM_NAMES#</font></TD>
		  </TR>
		  <TR >
		  	<td valign="top"><font size="+1">Synopsis</font></td>
		    <TD colspan="2" valign="top">
				<font size="+1">#SYNOPSIS#<br>#ADDLCOMMENTS#</font>
			</TD>
		   </TR>

		</TABLE>
	</form>

	<p></p>
</cfoutput>
<p>
</cfoutput>
<hr>
<center>
<font size="-1">
<a href="admin.cfm">Larp Administration</a>
</font>
</center>


			</div>


			 </p>
		</div>

		<div id="sidebar">
			<div class="box1">
				<div class="title">
					<h2>Our Schedule</h2>
				</div>
				<ul class="style2">
					<li><a href="../schedule.cfm">Game Schedule</a></li>
					<!---<li><a href="../schedule_by_gm.cfm">View By GM</a></li>
					<li><a href="../schedule_map.cfm">Map View</a></li>--->
					<li><a href="index.cfm">LARP Schedules</a></li>
					<cfif IsDefined("SESSION.LOGGEDINGMN")><li><a href="../personal_schedule.cfm" target="_blank">Your Schedule</a></li></cfif>

				</ul>
			</div>
<cfinclude template="..\sideBar.cfm">

	<!-- end #page -->
</div>
<div id="footer">
	<p>Copyright (c) 2013 rjritchie.com. All rights reserved. | Design by <a href="http://www.freecsstemplates.org/" rel="nofollow">FreeCSSTemplates.org</a>.</p>
</div>
<!-- end #footer -->
</body>
</html>


