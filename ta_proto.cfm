<CFIF Not IsDefined("Session.Administrator")>
	<cflocation url="admin.cfm" addtoken="No">
</cfif>


<cfquery name="avid" datasource="#ds#" dbtype="ODBC">
	SELECT TOP 1 MaxNumRoundTables, MaxNumSquareTables
	FROM ADMIN
</cfquery>


<cfinvoke component="necronomicon"
	method="retriveClock"
	GamesOnly="Yes"
	returnvariable="clock"></cfinvoke>


<cfquery name="roomstables" datasource="#ds#" dbtype="ODBC">
	SELECT TablesPerRoom.RoomName, TablesPerRoom.Count, TableTypes.Shape, TablesPerRoom.FirstRoomNumber
	FROM TablesPerRoom INNER JOIN TableTypes ON TablesPerRoom.TableType = TableTypes.TypeId
	GROUP BY TablesPerRoom.RoomName, TablesPerRoom.Count, TableTypes.Shape, TablesPerRoom.FirstRoomNumber
	HAVING (((TablesPerRoom.Count)>0))
	ORDER BY TablesperRoom.FirstRoomNumber
</cfquery>

<cfset showstuff = FALSE>

<Cfif showstuff>
roomstables<br>
<cfdump var="#roomstables#">
</cfif>

<cfinclude template="ta_init.cfm">

<cfsetting requestTimeOut = "6000">



<cfinclude template="ta_assigntables.cfm">

Click <a href="tableAssignment.cfm" target="_blank">here</a> to see results.
<!---
<cfif not showstuff>
	<cflocation url="tableAssignment.cfm">
</cfif>
--->
