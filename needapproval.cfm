<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>Administration</title>

<style>
<!--
.drag{cursor:hand}
-->
</style>

<CFIF Not IsDefined("Session.Administrator")>
	<cflocation url="admin.cfm" addtoken="No">
</cfif>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.0/jquery.min.js"></script>


<script language="JavaScript">







	function adjustImages()
	{
		var i;
		var img;
		var ratio;
		var imgwidth = 100;

	  if (navigator.appVersion.indexOf("4.") != -1 &&
	      navigator.appName.indexOf("Explorer") != -1)
	  {
	     imgwidth = screen.width / 2.5;
	  }
	  if (navigator.appVersion.indexOf("4.") != -1 &&
	      navigator.appName.indexOf("Netscape") != -1)
	  {
	     imgwidth = screen.width / 2.5;
	  }
	  if (navigator.appVersion.indexOf("5.") != -1 &&
	      navigator.appName.indexOf("Netscape") != -1)
	  {
	     imgwidth = screen.width / 2.5;
 	  }

		for (i = 0; i < document.images.length; i++)
		{

			img = document.images[i];

			// if (img.noadj != "Yes")
			if (img.id != "pagetitle")
			{
				if (img.width > imgwidth)
				{
					ratio = imgwidth / img.width;
					img.width = imgwidth;
					img.height = img.height * ratio;
				}

				if (img.height > imgwidth)
				{
					ratio = imgwidth / img.height;
					img.height = imgwidth;
					img.width = img.width * ratio;
				}
			}
		}
	}


	function app(apprvl, session)
	{
		var i;

		for (i=0; i < document.gform.elements.length; i++)
		{
			if (document.gform.elements[i].name == apprvl)
			{
				break;
			}
		}

		if (session.value == 0)
		{
//					document.gform.elements[i].disabled=true;
			document.gform.elements[i].checked = false;
//					document.gform.elements[i+1].disabled=true;
			document.gform.elements[i+1].checked = true;

		}
		else
		{
//					document.gform.elements[i].disabled=false;
			document.gform.elements[i].checked = true;
//					document.gform.elements[i+1].disabled=false;
			document.gform.elements[i+1].checked = false;
		}


	}


 	function setSesion(GameId, approval)
	{
		var session;
		var zeroelement;
		var checkedelement;
		var firstelement = -1;

		session = "Session" + GameId;

		for (i=0; i < document.gform.elements.length; i++)
		{
			if (document.gform.elements[i].name == session)
			{
				if (document.gform.elements[i].checked == true)
					checkedelement = i;
				if (document.gform.elements[i].value == 0)
					zeroelement = i;
				if (firstelement == -1)
					firstelement = i;
			}
		}

		if (approval.value == 0)
		{
			if (checkedelement != zeroelement)
			{
				alert("By choosing to Un-Approve this game,\nit's Session becomes Unassigned.");
				document.gform.elements[checkedelement].checked = false;
				document.gform.elements[zeroelement].checked = true;
			}
		}
		if (approval.value == 1)
		{
			if (checkedelement == zeroelement)
			{
				document.gform.elements[zeroelement].checked = false;
				document.gform.elements[firstelement].checked = true;
			}
		}
	}

 	function enableAll()
	{
		var i;

		for (i=0; i < document.gform.elements.length; i++)
		{
			document.gform.elements[i].disabled = false;
		}

	}


 	function Adminchange(thing, originalvalue, displayvalue)
	{
		var i;

		if (thing.value != originalvalue)
		{
 			i = confirm("You are changing this value from what was\nentered by the Game Master (" + displayvalue + "). Proceed?");

			if (!i)
//				return false;
				thing.value = originalvalue;


		}
		return true;

	}

	function BigAdminChange(thing, originalvalue, sessionbutton, approvalbutton)
	{
		var i;

		if (thing.value != originalvalue)
		{
			i = confirm("By changing this value, you will un-assign a game session (if any has \nbeen assigned) You must then save this game and reassign the session.\nDo you wish to proceed?");

			if (!i)
				thing.value = originalvalue;
			else
			{

				for (i=0; i < document.gform.elements.length; i++)
				{
					if (document.gform.elements[i].name == sessionbutton)
					{
						//alert('found ' + sessionbutton);
						if (document.gform.elements[i].value == 0)
							document.gform.elements[i].checked = true;
						else
							document.gform.elements[i].checked = false;
					}

					if (document.gform.elements[i].name == approvalbutton)
					{
						//alert('found ' + approvalbutton);
						if (document.gform.elements[i].value == 0)
							document.gform.elements[i].checked = true;
						else
							document.gform.elements[i].checked = false;
					}
				}
			}
		}

		return true;
	}


 var XMLHttpRequestObject = false;
if (window.XMLHttpRequest)  {
								XMLHttpRequestObject = new XMLHttpRequest();
							}
else if (window.ActiveXObject) {
								  XMLHttpRequestObject = new ActiveXObject("Microsoft.XMLHTTP");
								}


  function showRoomsAndSessions()
  {

		if(XMLHttpRequestObject)
		{

			var b = "na_RoomsAndSessions";
			var lookupURL = "na_RoomsAndSessions.cfm?dGameID=" + document.getElementById("GameId").value    + "&dTableType="    + document.getElementById("TableType").value
							+ "&dLengthOfGame=" +  document.getElementById("LengthOfGame").value
							+ "&dNumberOfTables=" +  document.getElementById("NumTables").value

			//alert(lookupURL);

			var obj = document.getElementById(b);
			var rtext;

			XMLHttpRequestObject.open("GET", lookupURL,1);
			XMLHttpRequestObject.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			XMLHttpRequestObject.onreadystatechange = function()
				{
					if (XMLHttpRequestObject.readyState == 4) {
							rtext = XMLHttpRequestObject.responseText;
                            obj.innerHTML = rtext;
                           }
				}
			XMLHttpRequestObject.send(null);

		}
	}


 </script>



<cfif IsDefined("scheduledGame")>

	<cfquery name="NA" datasource="#ds#" dbtype="ODBC">
		SELECT 		Type, System, Title, GmId,
					GM, email, emailVisable, Link, Description, AdultOnly,
					NumPlayers, RoleplayingStressed, [Level], GameId, HomePage,
					Image, ImageApproved, Approved, Request1, Request2, Request3, Session,
					Request1Date, Request1Time, Request2Date, Request2Time,
					Request3Date, Request3Time, Telephone, LengthOfGame,
					TableType AS naTableType, Shape,
					NumTables, Room, Tables, TableCounts, TableLocked
		FROM 		[Display Schedule]
		WHERE		GameId = #scheduledGame#
		ORDER BY    Title
	</cfquery>

	<cfset GameId = #scheduledGame#>


	<cfquery name="HideItem" datasource="#ds#">
		SELECT CASE when [HideOnSchedule]=1 then 1 else 0 end as Hide
		FROM Games
		WHERE (((Games.GameId)=#scheduledGame#));
	</cfquery>


<cfelse>

	<cfquery name="NA" datasource="#ds#" dbtype="ODBC">
		SELECT 		Type, System, Title, GmId,
					GM, email, emailVisable, Link, Description, AdultOnly,
					NumPlayers, RoleplayingStressed, [Level], GameId, HomePage,
					Image, ImageApproved, Approved, Request1, Request2, Request3, Session,
					Request1Date, Request1Time, Request2Date, Request2Time,
					Request3Date, Request3Time, Telephone, LengthOfGame,
					TableType AS naTableType, Shape,
					NumTables, Room, Tables, TableCounts, TableLocked
		FROM 		[Needing Approval]
		WHERE		GameId = #GameId#
		ORDER BY    Title
	</cfquery>


	<cfquery name="HideItem" datasource="#ds#">
	SELECT
		CASE when [HideOnSchedule]=1 then 1 else 0 end as Hide
	FROM Games
	WHERE (((Games.GameId)=#GameId#));
</cfquery>
</cfif>

<cfset TheRoom = na.room>
<!---<CFSET TheGame = na.GameID>
<cfinclude template="createGameTimeMap.cfm">--->

<cfquery name="AllTables" datasource="#ds#" dbtype="ODBC">
	SELECT * FROM TableTypes
	Order by TypeID
</cfquery>

<cfquery name="Rooms" datasource="#ds#">
	SELECT * FROM ROOMS
	ORDER BY ROOMNAME
</cfquery>

<cfquery name="GTypes" datasource="#ds#" dbtype="ODBC">
	SELECT * FROM GameTypes
	ORDER BY GameTypeId
</cfquery>

</head>

<link rel="stylesheet" type="text/css" href="styles/main.css">
<body style="margin-left: 25px;" onLoad="adjustImages();showRoomsAndSessions();load();">
<cfif NA.Recordcount GT 0>

<cfoutput>
	<form action="approvegames.cfm" method="post" enctype="multipart/form-data" name="gform" onSubmit="enableAll()">
		<input type="hidden" id="GameId" name="GameId" value="#GameId#">
		<input type="hidden" name="GMID" value="#NA.GMID#">
</cfoutput>
	<cfoutput query="NA">
		<cfset LType = #NA.Type#>

		<cfquery name="TableTypeName" datasource="#ds#">
			SELECT SHAPE
			FROM TABLETYPES
			WHERE TYPEID = #naTableType#
		</cfquery>

		<cfif (#Image# GT "")>
			<table align="right">
			<tr><td align="center">
				<A href="#Session.ProofURL#/#Image#" target="_blank">
					<img name="gimg" src="#Session.ProofURL#/#Image#" align="right" BORDER="0">
				</a>
			</td></tr>
			<tr><td align="Center"><b>Approve Image:</b> <input type="radio" name="ImageApproved#GameID#" value="1" <cfif #ImageApproved# GT 0>checked</cfif>>Yes&nbsp;<input type="radio" name="ImageApproved#GameID#" <cfif #ImageApproved# EQ 0>checked</cfif> value="0">No&nbsp;<input type="radio" name="ImageApproved#GameID#" value="99">Delete</td></tr>
			<tr>
				<td>
					<input type="file" name="Image" size="50" accept="image/gif,image/jpeg,image/x-MS-bmp">
				</td>
			</tr>
			</table>
		<cfelse>
			<table align="right">
				<tr>
					<td><b>Image</b></td>
					<td>
						<input type="file" name="Image" size="50" accept="image/gif,image/jpeg,image/x-MS-bmp">
					</td>
				</tr>
			</table>
		</cfif>
		<h1>#Title#</h1>
		<br>
		<input name="title" type="text" value="#Title#" size="50" maxlength="128">
		<cfif Session EQ 0>
			<font size="+1"><font color="RED">Session has not been Assigned</font></font><br>
		<cfelse>
			<font size="+1"><font color="Green">Session has been Assigned</font></font><br>
		</cfif>
		<cfif Approved EQ 0>
			<font size="+1"><font color="RED">Game is Unapproved</font></font><br>
		<cfelse>
			<font size="+1"><font color="Green">Game is Approved</font></font><br>
		</cfif>

		<cfif (#Image# GT "")>
			<cfif ImageApproved EQ 0>
				<font size="+1"><font color="RED">Image is Unapproved</font></font><br>
			<cfelse>
				<font size="+1"><font color="Green">Image is Approved</font></font><br>
			</cfif>
		</cfif>
		<p>
		<b>Game System:</b>
			<input name="system" type="text" maxlength="128" value="#system#">

<BR>
		<b>Game Type:</b>
			<select name="GameType" >
			<cfloop query="GTypes">
				<option value=#GameTypeId# <cfif #Type# EQ #LType#>selected</cfif>>#Type#</option>
			</cfloop>
			</select>
		<BR>
		<b>Game Master:</b> <cfif (emailVisable GT 0) AND (email GT "")><a href="mailto:#email#"></cfif>#GM#</a><BR>
		<cfif #HomePage# GT ""><b>Game Masters's Homepage:</b> <a href="#HomePage#" target="_blank">#HomePage#</a></cfif><br>
		<b>GM Telephone:</b> #Telephone#<BR>
		<b>Description:</b> #Description#<br>
		<button style="font-size:10px"onClick="javascript:document.getElementById('newDescArea').style.display = 'block'; return false">Edit Description</button><br>
		<span id="newDescArea" style="display:none">
			<textarea name="NewDescription" rows="10" cols="80">#Description#</textarea><br>
		</span>



		<b>Length of Game:</b>
					<select name="LengthOfGame" id="LengthOfGame" onChange="showRoomsAndSessions();">
				<cfloop index="x" from="1" to="7" step="1">
					<option <cfif #LengthOfGame# EQ #x#>selected</cfif> value=#x#>#x# hours</option>
				</cfloop>
			</select><br>

<!---		 #LengthOfGame# Hours--->

		<!--- <b>Number of Tables Required: </b>#NumberFormat(NumTables)#<br> --->
		<b>Number of Tables Required:
			<select name="NumTables" id="NumTables"  onChange="showRoomsAndSessions();">
			<cfloop index="x" from="0" to="12" step="1">
				<option value=#x# <cfif #NumTables# EQ #x#>selected</cfif>>#x#</option>
			</cfloop>

			</select>

		<br>

		<cfif #link# GT ""><b>More Info at:</b> <a href="#Link#" target="_blank">#Link#</a><br></cfif>
		<!--- <b>Number of Players:</b> #NumPlayers#<br> --->
		<b>Number of Players:</b>

			<select name="NumPlayers" onChange="return Adminchange(this, #NumPlayers#, #NumPlayers#);">
			<cfloop index="X" from="4" to="10">
				<option <cfif #NumPlayers# EQ #X#>selected</cfif> value=#x#>#X#</option>
			</cfloop>
			<cfloop index="X" from="20" to="100" step="10">
				<option <cfif #NumPlayers# EQ #X#>selected</cfif> value=#x#>#X#</option>
			</cfloop>
			</select>
		<BR>

		<b>Player Level:</b> #Level#<br>
		<b>Mature Content:</b> <cfif #AdultOnly# GT 0>Yes<cfelse>No</cfif><BR>
		<b>Roleplaying Stressed:</b> <cfif #RoleplayingStressed# GT 0>Yes<cfelse>Not Really</cfif>

		<p>

			<fieldset style="padding: 2">
      		<legend style="color: green; font-variant: small-caps;">Table / Room / Session Assignment</legend>

			<p>
<!---			<b>Room:</b>
			<select name="Room" onChange="return BigAdminChange(this, '#na.room#', 'Session#GameID#', 'Approved#GameId#');">
			<cfloop query="Rooms">
				<option value="#RoomName#" <cfif #RoomName# EQ #na.room#>selected</cfif>>#RoomName#</option>
			</cfloop>

			</select>
			&nbsp;&nbsp;
--->
			<b>Table Shape:</b>
<!---			<select id="TableType" name="TableType"onChange="return BigAdminChange(this, #naTableType#, 'Session#GameID#', 'Approved#GameId#');">
--->
			<select id="TableType" name="TableType" onChange="showRoomsAndSessions();">
			<cfloop query="AllTables">
				<option value=#TYpeID# <cfif #TYpeID# EQ #na.naTableType#>selected</cfif>>#Shape#</option>
			</cfloop>

			</select>
			&nbsp;&nbsp;
<!---			<b>Approve Game:</b> <input type="radio" onClick="setSesion(#GameID#, this)" name="Approved#GameID#" value="1" <cfif #Approved# GT 0>checked</cfif>>Yes
								&nbsp;
							 <input type="radio" onClick="setSesion(#GameId#, this)" name="Approved#GameID#" value="0" <cfif #Approved# EQ 0>checked</cfif>>No--->

			<b>Approve Game:</b> <input type="radio" onClick="" id="ApprovedYes" name="Approved#GameID#" value="1" <cfif #Approved# GT 0>checked</cfif>>Yes
								&nbsp;
							 <input type="radio" onClick="" id="ApprovedNo" name="Approved#GameID#" value="0" <cfif #Approved# EQ 0>checked</cfif>>No
			&nbsp;&nbsp;
			<b>Just Holding Tables:</b>	<input type="radio" name="HideItem" value="1" <cfif HideItem.Hide eq 1>checked</cfif>>Yes
			&nbsp;
			<input type="radio" name="HideItem" value="0" <cfif HideItem.Hide eq 0>checked</cfif>>No
			<br>
			<INPUT type="checkbox" value="locked" name="TableLocked"
				<cfif na.TableLocked eq 1>checked</cfif>
			> Lock Tables
			<Br>
		<p>
<!---		<b>Session: </b>
			<input type="radio" onClick='app("Approved#GameID#", this)' name="Session#GameID#" value="#Request1#" <cfif #Session# eq #Request1#>checked</cfif>> #TimeFormat(Request1Time, "h:mm tt")# #DateFormat(Request1Date, "dddd")#
			<input type="radio" onClick='app("Approved#GameID#", this)' name="Session#GameID#" value="#Request2#" <cfif #Session# eq #Request2#>checked</cfif>> #TimeFormat(Request2Time, "h:mm tt")# #DateFormat(Request2Date, "dddd")#
			<input type="radio" onClick='app("Approved#GameID#", this)' name="Session#GameID#" value="#Request3#" <cfif #Session# eq #Request3#>checked</cfif>> #TimeFormat(Request3Time, "h:mm tt")# #DateFormat(Request3Date, "dddd")#
			<input type="radio" onClick='app("Approved#GameID#", this)' name="Session#GameID#" value="0" <cfif #Session# eq 0>checked</cfif>> Unassigned
			<p>

			<a href="javascript:showRoomsAndSessions()">click</a>
--->
			<div id="na_RoomsAndSessions"></div>


							 <p>

<!---				<cfif na.room GT "">
						<cfquery name="AvailableTables" datasource="#ds#">
							select Count, FirstRoomNumber
							from TablesPerRoom
							where Count <> 0
							  and RoomName = '#na.room#'
							  and TableType = #na.naTableType#
						</cfquery>
						<cfif AvailableTables.RECORDCOUNT gt 0>
							<fieldset style="padding: 2">
							<legend style="color: green; font-variant: small-caps;">Tables</legend>
								<cfset assignedTables = "">

								<cfloop list="#na.Tables#" index="t">
									<cfset pos = ListFind(na.Tables, t)>
									<cfset tablecount = ListGetAt(na.TableCounts, pos)>
									<cfset lasttable = t + tablecount - 1>
									<cfloop index="j" from="#t#" to="#lasttable#">
										<cfset assignedTables = listappend(assignedtables, j)>
									</cfloop>
								</cfloop>


								<cfset lastTable = AvailableTables.FirstRoomNumber + AvailableTables.Count>
								<cfloop index="x" from="#AvailableTables.FirstRoomNumber#" to="#lastTable#">
									<input type="checkbox" value="#x#" name="AssignedTables"
										<cfif ListFind(assignedTables, x) GT 0> checked</cfif>
									> #x#
								</cfloop>

								<INPUT type="checkbox" value="locked" name="TableLocked"
									<cfif na.TableLocked NEQ 0>checked</cfif>
								> Locked
							</fieldset>

					</cfif>
				 </cfif>

			</fieldset>
		<br>	--->
<!---		<CFSET TimeArray = ArrayNew(1)>
		<Cfset TimeArray[1] = #Request1Time#>
		<Cfset TimeArray[2] = #Request2Time#>
		<Cfset TimeArray[3] = #Request3Time#>
		<CFSET RequestArray = ArrayNew(1)>
		<Cfset RequestArray[1] = #Request1#>
		<Cfset RequestArray[2] = #Request2#>
		<Cfset RequestArray[3] = #Request3#>--->
</cfoutput>
		<p>
	<input type="submit" name="fromNeedApproval" value="Save">&nbsp;<input type="Reset">
	&nbsp;<input type="submit"
			name="fromNeedApproval"
			value="Delete Game"
			title="Delete this game for ever and ever."
			onClick="return confirm('Do you relly want to delete this game entirely?');">

	</form>

<!---
<cfset GMActivityGmId = #Na.GmId#>
<cfset GmActivityLengthOfGame = #Na.LengthOfGame#>
<cfset GMActivityTableType = #NA.naTableType#>
<cfset TheRoom = #NA.Room#>
<cfset ShowSessions = "False">


<cfinclude template="showGMActivity.cfm">
--->

<cfelse>
	<i>This game does not need approval.</i>
</cfif>
<P>
Click <a target="_top" href="schedule.cfm">here</a> to inspect the Game Schedule.<br>




</body>
</html>
