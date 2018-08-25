<cfparam name="dGameID" default="983">
<cfparam name="dTableType" default="1">
<cfparam name="dLengthOfGame" default="4">
<cfparam name="dNumberOfTables" default="1">

<style type="text/css">

table.na_RoomsAndSessions {
	/*border: 1px solid black */
}

th.na_RoomsAndSessions {
	background-color:#BCBCBC;
}

td.na_RoomsAndSessions {
	<!---border: 1px solid black --->
	cursor:hand;
	text-align:center;
	font-weight: bold;
}

td.na_Rooms {
}

td.na_RoomsAndSessions_nohand {
	text-align:center;
	font-style:italic;
}

td.na_Selected {
	background-color:FFFF00;
	text-align:center;
	font-weight: bold;
	cursor:hand
}

</style>

<script language="javascript">

function td_click(r)
{
	alert(r);
}
</script>


<CFQUERY name="dGame" datasource="#ds#">
SELECT  Games.GameId, 
		Games.GMid, 
		Games.Session, 
		Games.Request1, 
		Games.Request2, 
		Games.Request3,
		Games.Room,
		Games.NumTables, 
		Games.Tables,
		Games.TableCounts,
		Games.LengthOfGame+Games.ExtraTimeNeeded AS LengthOfGame, 
		Sessions.SessionBegins AS Session1Begins,
		Sessions_1.SessionBegins AS Session2Begins, 
		Sessions_2.SessionBegins AS Session3Begins
FROM (((Games 
	LEFT JOIN Sessions 
		ON Games.Request1 = Sessions.SessionID )
	LEFT JOIN Sessions AS Sessions_1 
		ON Games.Request2 = Sessions_1.SessionID) 
	LEFT JOIN Sessions AS Sessions_2 
		ON Games.Request3 = Sessions_2.SessionID )
where Games.GameID = #dGameID#
</CFQUERY>
<!---<cfdump var="#dgame#">--->
<CFSET TimeArray = ArrayNew(1)>
<Cfset TimeArray[1] = #dGame.Session1Begins#>
<Cfset TimeArray[2] = #dGame.Session2Begins#>
<Cfset TimeArray[3] = #dGame.Session3Begins#>
<CFSET RequestArray = ArrayNew(1)>
<Cfset RequestArray[1] = #dGame.Request1#>
<Cfset RequestArray[2] = #dGame.Request2#>
<Cfset RequestArray[3] = #dGame.Request3#>	


<cfquery name="dRooms" datasource="#ds#">
	SELECT   Rooms.RoomName, 
			(SELECT [COUNT] FROM TablesPerRoom WHERE RoomName = Rooms.RoomName and TableType = #dTableType#) AS TableCount, 
			TablesPerRoom.Count, 
			TablesPerRoom.FirstRoomNumber
	FROM Rooms 
		INNER JOIN TablesPerRoom ON Rooms.RoomName = TablesPerRoom.RoomName
	ORDER BY FirstRoomNumber;
</cfquery>


<cfset assignedTables = "">

<cfloop list="#dGame.Tables#" index="t">
	<cfset pos = ListFind(dGame.Tables, t)>
	<cfset tablecount = ListGetAt(dGame.TableCounts, pos)>
	<cfset lasttable = t + tablecount - 1>
	<cfloop index="j" from="#t#" to="#lasttable#">
		<cfset assignedTables = listappend(assignedtables, j)>
	</cfloop>
</cfloop>


<cfoutput query="dGame">
<table class="na_RoomsAndSessions">
	<tr class="na_RoomsAndSessions">
		<th class="na_RoomsAndSessions">
			<input name="SelectedSession" type="radio" value="0" <cfif 0 eq dgame.Session>checked</cfif> onCLick="document.getElementById('ApprovedNo').checked=true;o=document.getElementsByClassName('na_Selected');if (o.length==1) { o.item(0).className='na_RoomsAndSessions' };"/>	Unassigned	
		</th>
		<cfloop index="i" from="1" to="3">
		
		<th class="na_RoomsAndSessions">
			<input id="SelectedSession#i#" name="SelectedSession" type="radio" value="#RequestArray[i]#" <cfif RequestArray[i] EQ dgame.Session>checked</cfif> />
			#TimeFormat(TimeArray[i], "h:mm tt")# #DateFormat(TimeArray[i], "dddd")#
		</th>
		</cfloop>
	</tr>
	
	<cfset row = 0>
	<cfloop query="dRooms">
		<cfset row = row + 1>
		<tr class="na_RoomsAndSessions">
			<td class="na_Rooms">
				<input id="Room#row#" name="Room" type="radio" value="#RoomName#" <CFIF dGame.Room EQ RoomName>checked </cfif>
					onChange="<cfloop query="dRooms">document.getElementById('#RoomName#').style.display='none';</cfloop>document.getElementById(this.value).style.display='block';"
				/>
				#RoomName#
			</td>

			<cfset TheRoom = RoomName>
			<CFSET TheGame = dGameID>
		
			<cfinclude template="createGameTimeMap.cfm">	
					
			<cfloop index="i" from="1" to="3">
				<cfset EndOfSEssion = TimeArray[i] + CreateTimeSpan(0,dLengthOfGame,0,0)>
				
				<cfquery name="tablesUsed" datasource="#ds#" dbtype="ODBC">
					SELECT CountOfTablesByHour.TableType, Max(CountOfTablesByHour.SUMOFGAMEID) AS MaxOfCountOfTableType, Room
					FROM CountOfTablesByHour
					WHERE (CountOfTablesByHour.Hour >= #CreateODBCDAteTime(TimeArray[i])#) And 
						  (CountOfTablesByHour.Hour  < #CreateODBCDateTime(EndOfSession)#) AND
						  (CountOFTablesByHour.Room = '#TheRoom#') AND
						  (TableType = #dTableType#) 
					GROUP BY CountOfTablesByHour.TableType, Room;
				</cfquery>			
				
<!---				<CFDUMP var="#tablesUsed#">--->
				
				<cfif tablesUsed.RecordCount EQ 0>
					<cfset UsedTables = 0>
				<cfelse>
					<cfset UsedTables = #tablesUsed.MaxOfCountOfTableType#>
				</cfif>
				<cfif dRooms.TableCount GT "">
					<cfset AvailableTables = dRooms.TableCount - UsedTables>
				<cfelse>
					<cfset AvailableTables = 0>						
				</cfif>				
		
			<td 
				<cfif RequestArray[i] EQ dgame.Session and
				      dGame.Room EQ RoomName>class="na_Selected" style="border: 1px dashed black;" title="This is the currently-saved session."
					  <cfelseif AvailableTables LT dNumberOfTables>class="na_RoomsAndSessions_nohand"  title="Insufficient tables available."<cfelse>class="na_RoomsAndSessions"</cfif>
			class="na_RoomsAndSessions"
				id="intersect"
				<cfif AvailableTables GTE dNumberOfTables>
				onClick="document.getElementById('Room#row#').checked=true;document.getElementById('SelectedSession#i#').checked=true;o=document.getElementsByClassName('na_Selected');if (o.length==1) { o.item(0).className='na_RoomsAndSessions' };this.className='na_Selected';<cfloop query="dRooms">document.getElementById('#RoomName#').style.display='none';</cfloop>document.getElementById('#RoomName#').style.display='block';document.getElementById('ApprovedYes').checked=true;"
				</cfif>
			>#AvailableTables#</td>
			</cfloop>			
					
		</tr>
	</cfloop>
</table>
</cfoutput>


<fieldset style="padding: 2">
<legend style="color: green; font-variant: small-caps;">Tables</legend>


<cfoutput query="dRooms">
	<div id="#RoomName#" <CFIF dGame.Room NEQ RoomName>style="display:none" </cfif> >
	<cfset lastTable = FirstRoomNumber + Count>
	<cfloop index="x" from="#FirstRoomNumber#" to="#lastTable#">
		<input type="checkbox" value="#x#" name="AssignedTables" 
			<cfif ListFind(assignedTables, x) GT 0> checked</cfif>
		> #x#
	</cfloop>
	</div>
</cfoutput>

</fieldset>

<cfoutput>
<script language="javascript">
function test(t)
{
	<cfloop query="dRooms">document.getElementById('#RoomName#').style.display='none';</cfloop>document.getElementById(t).style.display='block';

}
</script>
</cfoutput>