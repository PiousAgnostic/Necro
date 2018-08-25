<CFIF Not IsDefined("Session.Administrator")>
	<cflocation url="admin.cfm" addtoken="No">
</cfif>

<html>
<head>
	<title>Table Assignment</title>


    <SCRIPT LANGUAGE="JavaScript">
    <!-- Begin
    function xL(){
    document.X.submit();
    }
    // End -->
    </SCRIPT>
    </HEAD>


<cfquery name="roomstables" datasource="#ds#">
	SELECT TablesPerRoom.RoomName, TablesPerRoom.Count, TableTypes.Shape, FirstRoomNumber
	FROM TablesPerRoom INNER JOIN TableTypes ON TablesPerRoom.TableType = TableTypes.TypeId
	GROUP BY TablesPerRoom.RoomName, TablesPerRoom.Count, TableTypes.Shape, FirstRoomNumber
	HAVING (((TablesPerRoom.Count)>0));
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
<cfset NOFLUSH="true">
<cfinclude template="ta_showtables.cfm">

    <cfheader
    name="Content-Type"
    value="application/msexcel">
    <cfheader
    name="Content-Disposition"
    value="attachment; filename=TableAssignments.xls">

</body>
</html>
