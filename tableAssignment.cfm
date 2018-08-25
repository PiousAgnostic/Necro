<CFIF Not IsDefined("Session.Administrator")>
	<cflocation url="admin.cfm" addtoken="No">
</cfif>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>Table Assignment</title>

<style>
<!--
.drag{cursor:hand}
-->
</style>

<script language="JavaScript">
function select(element)
{
  var e, r, c, m;

  if (element == null)
  {
    e = window.event.srcElement;
  }
  else {
    e = element;
  }

  if (e.tagName == "TABLE")
  	return;


//  if ((window.event.altKey) || (e.tagName == "TR")) {
//    r = findRow(e);
//    if (r != null) {
//      if (lastSelection != null) {
//        deselectRowOrCell(lastSelection);
//      }
//      selectRowOrCell(r);
//      lastSelection = r;
//    }
//  } else {
    c = findCell(e);
//    if (c != null) {
//      if (lastSelection != null) {
//        deselectRowOrCell(lastSelection);
//      }
//      selectRowOrCell(c);
//      lastSelection = c;
//    }
//  }

  if (c.id =="")
  	return;

//  m = c.innerText + "\n" + c.id + " table";
//  if (c.id != "1") m = m + "s";

  alert(c.innerText);
  window.event.cancelBubble = true;



}

function findCell(e) {
  if (e.tagName == "TD") {
    return e;
  } else if (e.tagName == "BODY") {
    return null;
  } else {
    return findCell(e.parentElement);
  }
}

</script>

</head>

<cfquery name="roomstables" datasource="#ds#">
	SELECT  TablesPerRoom.RoomName, TablesPerRoom.Count, TableTypes.Shape, FirstRoomNumber
	FROM TablesPerRoom INNER JOIN TableTypes ON TablesPerRoom.TableType = TableTypes.TypeId
	GROUP BY TablesPerRoom.RoomName, TablesPerRoom.Count, TableTypes.Shape, FirstRoomNumber
	HAVING (((TablesPerRoom.Count)>0))
	ORDER BY tablesperRoom.RoomName desc
	;

</cfquery>

<cfinvoke component="necronomicon"
	method="retriveClock"
	GamesOnly="Yes"
	returnvariable="clock"></cfinvoke>


<cfquery name="notassigned" datasource="#ds#">
SELECT [All Games].*
FROM [All Games] LEFT JOIN TableAssignment ON [All Games].GameId = TableAssignment.USEDBY
WHERE (((TableAssignment.TIMESLOT) Is Null) AND (([All Games].Approved)=1))
ORDER BY SESSIONBEGINS
</cfquery>


<link rel="stylesheet" type="text/css" href="styles/main.css">
<body style="margin-left: 25px;">
<!--- <cfinclude template="ta_init.cfm">
<cfinclude template="ta_assigntables.cfm"> --->

<A ID="TOP"></a>
<h1>Table Assignments</h1>
<p>
<b>This page will attempt to assign games to tables. Please note that some games require
multiple tables, which may not appear adjacent to each other on this screen. Click on a game
to get table information.
<p>
<cfoutput>
<cfif notassigned.recordcount GT 0>


	<hr>
	<font size="+1" color="Red">
	WARNING! There <cfif notassigned.recordcount eq 1>is 1 game<cfelse>are #notassigned.recordcount# games</cfif>
	that, due to space restrictions, were not able to be assigned:
	</font>
	<p>
	<UL>

	<cfloop query="notassigned">
		<LI><a href="needapproval.cfm?ScheduledGame=#GameId#" target="main">#Title#</a> - Tables requested: #Int(NumTables)# in the #room# room on #DateFormat(SessionBegins, "ddd")# at #TimeFormat(SessionBegins, "htt")# for #LengthOFGame# hours<br>
	</cfloop>
	</ul><hr>
	<p>
</cfif>
</cfoutput>

<cfoutput query="roomstables">
	<A HREF="###Roomname#">#Roomname# ROOM</a> |
</cfoutput>
<!--- <A HREF="#RPG">RPG ROOM</a> | <A HREF="#CCG1">CCG1 TABLES</a> | <A HREF="#CCG2">CCG2 TABLES</a> | <A HREF="#COMPUTER">COMPUTER TABLES</a> |
 --->
<a href="signupsheets.cfm" target="_blank">Sign Up Sheets</a> | <a href="tableAssignment_excell.cfm">Download</a>
 <p>
<!---If you don't like the color scheme, click <a href="tableAssignment.cfm">here</a>.
--->

</b>

<cfinclude template="ta_showtables.cfm">


<script language="javascript">
window.top.scrollTo(0, 0);
</script>


</body>
</html>
