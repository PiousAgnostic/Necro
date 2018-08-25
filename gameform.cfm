
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


<script language="JavaScript">
ver=parseInt(navigator.appVersion)
ie4=(ver>3  && navigator.appName!="Netscape")?1:0
ns4=(ver>3  && navigator.appName=="Netscape")?1:0
ns3=(ver==3 && navigator.appName=="Netscape")?1:0


	function eleven()
	{
		 alert("This one goes to eleven.")
	}

	function adjustImages()
	{
		var i;
		var img;
		var ratio;

		for (i = 0; i < document.images.length; i++)
		{
			img = document.images[i];

			if (img.width > 500)
			{
				ratio = 500 / img.width;
				img.width = 500;
				img.height = img.height * ratio;
			}

			if (img.height > 500)
			{
				ratio = 500 / img.height;
				img.height = 500;
				img.width = img.width * ratio;
			}
		}
	}


	function ask()
	{
		var msg = "   Please note that saving your game information\n" +
				  "will require it to be Approved by the site master\n" +
				  "       even if no changes have been made.\n\n" +
				  "              Do you wish to continue?";


		if ((document.gform.Title.value == "-- required --") ||
		    (document.gform.Title.value == ""))
		{
			alert("A game title is required")
			document.gform.Title.select()
		}
		else if ((document.gform.System.value == "-- required --") ||
				 (document.gform.System.value == ""))
		{
			alert("A game system is required")
			document.gform.System.select()
		}
		else if (document.gform.Desription.value == "")
		{
			alert("Please give this game a description")
			document.gform.Desription.focus()
		}
		else
			if (confirm(msg))
				document.gform.submit();
	}

	function newTime()
	{
		var msg = "By requesting a new time, your game will become unapproved,\n" +
				  "and it will no longer appear on the game schedule.\n\n" +
				  "           Do you wish to continue?";

		if (confirm(msg))
			document.gform.submit();
	}


	function testURL(url)
	{

		var h = (screen.availHeight - 100);
		var w = (screen.availWidth - 100);
		window.open(url,"Test", "scrollbars,resizable,height="+h.toString()+",width="+w.toString()+",left=50,top=50");
	}

	function loadGameImage(d)
	{
		return

	}

	function noRequiredIn(t)
	{
		if (t.value == "-- required --")
			t.value = "";
		return null;

	}

	function noRequiredOut(t)
	{
		if (t.value == "")
			t.value = "-- required --";
		return null;
	}

</script>


<cfparam name="LTitle" default="-- required --">
<cfparam name="LSystem" default="-- required --">
<cfparam name="LDescription" default="">
<cfparam name="LLink" default="">
<cfparam name="LRequest1" default=0>
<cfparam name="LRequest2" default=0>
<cfparam name="LRequest3" default=0>
<cfparam name="LSession" default=0>
<cfparam name="LNumPlayers" default=6>
<cfparam name="LAdultOnly" default=0>
<cfparam name="LRoleplayingStressed" default=0>
<cfparam name="LExperienceLevel" default=1>
<cfparam name="LApproved" default=0>
<cfparam name="LSession" default=0>
<cfparam name="LType" default="RPG">
<cfparam name="LImage" default="">
<cfparam name="LImageApproved" default=0>
<cfparam name="LCancelled" default="0">
<cfparam name="LTableType" default="2">
<cfparam name="LLengthOfGame" default=4>
<cfparam name="LNUMTABLES" default="1">
<cfparam name="LComplexity" default="5">
<cfparam name="LExtraTimeNeeded" default="0">

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

<cfquery name="GMs" datasource="#ds#" dbtype="ODBC">
	SELECT * FROM [Game Masters]
	WHERE GmId = #form.GMId#
</cfquery>

<cfset ThisDropDeadDate = avid.DropDeadDate>

<cfif IsDate(GMs.ExtendedDeadline)>
	<CFIF DateCompare(GMs.ExtendedDeadline,avid.DropDeadDate, "D") GT 0>
		<cfset ThisDropDeadDate = GMs.ExtendedDeadline>
	</cfif>
</cfif>

<cfquery name="Game" datasource="#ds#" dbtype="ODBC">
	SELECT * FROM GameInfo
	WHERE GameID = #form.GameID#
</cfquery>

<cfquery name="Sessions" datasource="#ds#" dbtype="ODBC">
	SELECT * FROM Sessions
	WHERE Type = 'Game'
	ORDER BY SessionDate, SessionBegins;
</cfquery>

<cfquery name="ELevels" datasource="#ds#" dbtype="ODBC">
	SELECT * FROM ExperienceLevels
	ORDER BY ExperienceID
</cfquery>

<cfquery name="GTypes" datasource="#ds#" dbtype="ODBC">
	SELECT * FROM GameTypes
	WHERE Type Not in ('Larp', 'Event', 'Top Secret')
	ORDER BY GameTypeId
</cfquery>

<script language="JavaScript">
	var defaultrooms = new Array;

	<cfoutput query="GTypes">
		defaultrooms['#Type#'] = '#DefaultRoom#';
	</cfoutput>

	function updateRoom(gametype)
	{
		document.gform.Room.value = defaultrooms[gametype];
	}

	function updateRoomByTableShape(tableshape)
	{


		if (tableshape == "Round")
			document.gform.Room.value = "Round"
		else
			document.gform.Room.value = "Rectangular"

	}


</script>

<cfquery name="Tables" datasource="#ds#" dbtype="ODBC">
	SELECT * FROM TableTypes
	Order by TypeID
</cfquery>

<cfif Game.RecordCount eq 1>
	<cfset LTitle = #Game.Title#>
	<cfset LSystem = #Game.System#>
	<cfset LDescription = #Game.Description#>
	<cfset LLink = #Game.Link#>
	<cfset LRequest1 = #Game.Request1#>
	<cfset LRequest2 = #Game.Request2#>
	<cfset LRequest3 = #Game.Request3#>
	<cfset LSession  = #Game.Session#>
	<cfset LNumPlayers  = #Game.NumPlayers#>
	<cfset LAdultOnly  = #Game.AdultOnly#>
	<cfset LRoleplayingStressed  = #Game.RoleplayingStressed#>
	<cfset LExperienceLevel  = #Game.ExperienceLevel#>
	<cfset LApproved = #Game.Approved#>
	<cfset LSession = #Game.Session#>
	<cfset LType = #Game.Type#>
	<cfset LImage = #Game.Image#>
	<cfset LImageApproved = #Game.ImageApproved#>
	<cfset LCancelled = #Game.Cancelled#>
	<cfset LTableType = #Game.TableType#>
	<CFSET LLengthOfGame = #Game.LEngthOfGame#>
	<cfset LNUMTABLES = #Game.NumTables#>
	<cfset LComplexity = #Game.Complexity#>
	<cfset LExtraTimeNeeded = #Game.ExtraTimeNeeded#>

	<cfquery name="ApprovedSession" datasource="#ds#" dbtype="ODBC">
		SELECT * FROM Sessions
		Where SessionID = #LSession#
	</cfquery>

</cfif>



</head>
<body onLoad="updateRoomByTableShape(document.gform.TableType.options[document.gform.TableType.selectedIndex].text);">
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
				<span class="byline">This Game Information</span>
			</div>
			<p>
				<div class="announcement">


<!---<h2>Game Display Screen</h2>
<p></p>--->
<cfoutput query="GMs">
<h2>#FirstName# #MiddleName# <cfif #Alias# GT "">"#Alias#" </cfif> #LastName#</h2>
</cfoutput>

<cfoutput>
<form action="savegame.cfm"
      method="post"
      enctype="multipart/form-data"
	  name="gform"
	  <!--- onSubmit="ask()" --->>

<input type="Hidden" name="GMid" value="#form.GMId#">
<input type="Hidden" name="Approved" value="#LApproved#">
<input type="Hidden" name="Session" value="#LSession#">
<input type="Hidden" name="GameId" value="#form.GameId#">
<input type="Hidden" name="Room">

<table>
	<tr>
		<td><b>Game Title</b></td>
		<td><input type="text" name="Title" onfocus="noRequiredIn(this);" onblur="noRequiredOut(this);" size="50" value="#replace(LTitle, '"', '&quot;','ALL')#">

		</td>
	</tr>
	<tr>
		<td><b>Game System</b></td>
		<td><input type="text" name="System" onfocus="noRequiredIn(this);" onblur="noRequiredOut(this);" value="#replace(LSystem, '"', '&quot;',"ALL")#" size="50"></td>
	</tr>
	<tr>
		<td><b>Game Type</b></td>
		<td>
<!--- 			<select name="GameType"
				onChange="updateRoom(this.options[this.selectedIndex].text); if (this.value==1) {document.gform.TableType.value = 2} else {document.gform.TableType.value = 1};"
			> --->
			<select name="GameType"
				onChange="updateRoom(this.options[this.selectedIndex].text); if (this.value==1) {document.gform.TableType.value = 2; document.gform.Room.value = 'Round'} else {document.gform.TableType.value = 1; document.gform.Room.value = 'Rectangular'};"
			>
			<cfloop query="GTypes">
				<option value=#GameTypeId# <cfif #Type# EQ #LType#>selected</cfif>>#Type#</option>
			</cfloop>
			</select>
		</td>
	</tr>
	<tr>
		<td valign="top"><b>Game Description</b></td>
		<td><textarea cols="50" rows="4" name="Desription">#replace(LDescription, '"', '&quot;',"ALL")#</textarea></td>
	</tr>
	<tr>
		<td><b>Number of Players</b></td>
		<td>
			<select name="NumPlayers">
			<cfloop index="X" from="4" to="10">
				<option <cfif #LNumPlayers# EQ #X#>selected</cfif> value=#x#>#X#</option>
			</cfloop>
			<cfloop index="X" from="20" to="100" step="10">
				<option <cfif #LNumPlayers# EQ #X#>selected</cfif> value=#x#>#X#</option>
			</cfloop>
			</select>
		</td>
	</tr>
	<tr>
		<td><b>Length of Game</b></td>
		<td>
			<select name="LengthOfGame">
<!---				<cfloop index="x" from="2" to="6" step="2">'--->
				<cfloop index="x" from="1" to="7" step="1">
					<option <cfif #LLengthOfGame# EQ #x#>selected</cfif> value=#x#>#x# hours</option>
				</cfloop>
			</select>
		</td>
	</tr>
	<tr>
		<td><strong>Extra Time Needed?</strong></td>
		<td>
			<input type="radio" name="ExtraTimeNeeded" value="0" <cfif LExtraTimeNeeded EQ 0>checked</cfif>> No
			<input type="radio" name="ExtraTimeNeeded" value="1" <cfif LExtraTimeNeeded EQ 1>checked</cfif>> Yes
			<strong>&lt;--- If you would like some time after your game ends to break down your gear, please indicate that here.</strong>
		</td>
	</tr>
	<tr>
		<td><b>Table Shape Required</b></td>
		<td>
			<select name="TableType"
				onChange="updateRoomByTableShape(this.options[this.selectedIndex].text)"
			>
			<cfloop query="Tables">
				<option value=#TYpeID# <cfif #TYpeID# EQ #LTableType#>selected</cfif>>#Shape#</option>
			</cfloop>

			</select>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td>
			<font size="+1">
				If you are running an RPG, round tables are preferred. If you wish to
				run an RPG at a square table, please click
				<a href="mailto:#SESSION.EMAIL#?subject=I Do Want To Role Play at a Square Table">here</a>
				and send an email telling us that you are doing this on purpose!
			</font>
		</td>
	</tr>
	<tr>
		<td><b>Number of Tables Required</b></td>
		<td>
			<select name="NumTables">
			<cfloop index="x" from="0" to="4" step="1">
				<option value=#x# <cfif #LNumTables# EQ #x#>selected</cfif>>#x#</option>
			</cfloop>

			</select>
		</td>
	</tr>

	<tr>
		<td><b>Experience Level</b></td>
		<td>
			<select name="ExperienceLevels">
			<cfloop query="ELevels">
				<option value=#ExperienceId# <cfif #ExperienceId# EQ #LExperienceLevel#>selected</cfif>>#Level#</option>
			</cfloop>
			</select>
		</td>
	</tr>
	<tr>
		<td><strong>Complexity</strong></td>
		<td>
			<select name="Complexity"
				onChange="if (this.value == 11) eleven()">
				<cfloop from="1" to="11" index="i">
					<option value=#i# <cfif i eq LComplexity>selected</cfif>>#i#</option>
				</cfloop>
			</select>

			<font size="-1">1=Checkers, 10=Star Fleet Battles</font>
		</td>
	</tr>


	<tr>
		<td><b>Mature Content?</b></td>
		<td><input type="checkbox" name="AdultOnly" value="1" <cfif #LAdultOnly# NEQ 0>checked</cfif>></td>
	</tr>
	<tr>
		<td><b>Roleplaying Stressed?</b></td>
		<td><input type="checkbox" name="RoleplayingStressed" value="1" <cfif #LRoleplayingStressed# NEQ 0>checked</cfif>></td>
	</tr>
	<tr>
		<td><b>Game Specific Link</b></td>
		<td><input type="text" name="Link" value="#LLink#" size="50">

			&nbsp;<input type="button" name="Test" value="Test URL" onClick="testURL(document.gform.Link.value)">

		</td>
	</tr>


	<cfif #LApproved# EQ 0>
		<TR>
			<TD colspan=2 align="left"><b>Session</b></td>
		</tr>
		<tr>
			<td align="right"><b>First Choice</b></td>
			<td>
				<select name="Request1">
				<cfloop query="Sessions">
					<option value=#SessionId# <cfif #SessionId# EQ #LRequest1#>selected</cfif>>#DateFormat(SessionDate, "dddd")#, #TimeFormat(SessionBegins, "h:mmtt")#</option>

				</cfloop>
				</select>
			</td>
		</tr>
		<tr>
			<td align="right"><b>Second Choice</b></td>
			<td>
				<select name="Request2">
				<cfloop query="Sessions">
					<option value=#SessionId# <cfif #SessionId# EQ #LRequest2#>selected</cfif>>#DateFormat(SessionDate, "dddd")#, #TimeFormat(SessionBegins, "h:mmtt")#</option>

				</cfloop>
				</select>
			</td>
		</tr>
		<tr>
			<td align="right"><b>Third Choice</b></td>
			<td>
				<select name="Request3">
				<cfloop query="Sessions">
					<option value=#SessionId# <cfif #SessionId# EQ #LRequest3#>selected</cfif>>#DateFormat(SessionDate, "dddd")#, #TimeFormat(SessionBegins, "h:mmtt")#</option>

				</cfloop>
				</select>
			</td>
		</tr>
	<cfelse>
		<TR>
			<TD align="left"><b>Session</b></td>
			<td>
				<input type="Hidden" name="Request1" value="#LRequest1#">
				<input type="Hidden" name="Request2" value="#LRequest2#">
				<input type="Hidden" name="Request3" value="#LRequest3#">
				<b>#DateFormat(ApprovedSession.SessionDate, "dddd")#, #TimeFormat(ApprovedSession.SessionBegins, "h:mmtt")#</b>
				&nbsp;&nbsp;<input type="button" name="newTimeButton" value="Request Different Time" onClick="newTime();">
			</td>
		</tr>


	</cfif>
	<cfif LImage GT "">
	<tr>
		<td colspan="3">
			<img name="gameimage" src="#Session.ProofURL#/#LImage#">
		</td>
	</tr>
	<tr>
		<td colspan="3">
			<i><b><cfif #LImageApproved# GT 0>Image Approved<cfelse>Image Not Approved</cfif></b></i>
		</td>
	</tr>
	</cfif>
	<tr>
		<td><b>Image</b></td>
		<td>
			<input name="Image" type="file" onChange="loadGameImage(this)" size="50">
			<br>
			<font size="-1">Maximum image size: 500px x 225px.</font>
		</td>
	</tr>
	<tr>
		<td><b>Game Cancelled?</b></td>
		<td><input type="checkbox" name="Cancelled" value="1" <cfif #LCancelled# NEQ 0>checked</cfif>></td>
	</tr>

</table>

<p><b>If you have any additional information about yourself or this game that
you would like to send directly to the convention manager, please
click <a href="mailto:#SESSION.EMAIL#">here</a>.</b>
</cfoutput>
<p>
<b>Please note that saving your game information will require it to be<br>reapproved by the site master, <i><font color="Red">even if no changes have been made.</font></i></b>
<p>

<cfif DateCompare(ThisDropDeadDate,Now(), "D") LT 0>
	<cfoutput>
		<font size="+1" color="Red">
			The deadline for adding new games was #DateFormat(ThisDropDeadDate, "mm/dd/yyyy")#.
			Click <a href="mailto:#SESSION.EMAIL#">here</a> to beg for an extension.
		</font>
	</cfoutput>
<cfelse>
<input type="button" name="fromGameForm" value="Save" onClick="ask()">&nbsp;&nbsp;<input type="Reset">&nbsp;&nbsp;<input type="button" value="Cancel" onClick="javascript:history.back()">

</cfif>

</form>

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
