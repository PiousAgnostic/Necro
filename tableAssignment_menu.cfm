<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>Table Assignment</title>
<cfquery name="LockedLocations" datasource="#ds#">
SELECT Schedule.Tables, Schedule.TableCounts, Schedule.SessionBegins, Schedule.SessionEnds, 
Schedule.Room, Schedule.GM, Schedule.LengthOfGame, GameID, TablesPerRoom.FirstRoomNumber, Schedule.Title, Schedule.NumTables
FROM Schedule
 INNER JOIN TablesPerRoom ON (Schedule.TableType = TablesPerRoom.TableType) AND (Schedule.Room = TablesPerRoom.RoomName)
WHERE Schedule.TableLocked<>0
ORDER BY SESSIONBEGINS, TITLE
;
</cfquery>
	

</head>


<link rel="stylesheet" type="text/css" href="styles/main.css">

<h1>Table Assignments</h1>
<p>


<h3>
You are about to begin a process that will reassign games to the available tables.
<p>

<cfif LockedLocations.RECORDCOUNT GT 0>
There are some games that have been locked into particular rooms:

<ul>
	<cfoutput query="LockedLocations">
	
		<cfset TABLESTOUSE = "">
	
		<cfloop index="Piece" from="1" to="#ListLen(LockedLocations.Tables)#">
			
			<cfset UpperBound = ListGetAt(LockedLocations.TableCounts, Piece)-1>
			<CFLOOP index="C" from="0" to="#UpperBound#">
				<cfset pp = ListGetAT(LockedLocations.Tables, Piece) + C >
				<cfset TABLESTOUSE = LISTAPPEND(TABLESTOUSE, PP)>
			</CFLOOP>
		</cfloop>	
	<li><a target="adminmain" href="needapproval.cfm?scheduledGame=#GameID#">#Title#</a> will use #NumTables# Tables #DateFormat(SessionBegins, "DDD")# #TimeFormat(SessionBegins, "hTT")# for #LengthOFGame# Hours at  #Room# #TABLESTOUSE#</li>
	</cfoutput>
</ul>
</cfif>


<a href="tableAssignment_wait.cfm">Begin the Process</a> 

</h3>
<p>




</body>
</html>
