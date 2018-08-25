<style>
td.drag {cursor : pointer}

</style>


<cfquery name="GMActivityGMInfo" datasource="#ds#">
	select * from [Game Masters]
	Where GmId = #GmActivityGmId#
</cfquery>

<cfquery name="VolSchedule" datasource="#ds#" dbtype="ODBC">
	SELECT Sessions.SessionDate, Sessions.SessionBegins, Volunteers.GmId, Sessions.SessionLen, Departments.DepartmentName
	FROM (Volunteers INNER JOIN (VolunteerSessions
					 INNER JOIN Sessions ON VolunteerSessions.SessionId = Sessions.SessionID) ON Volunteers.VolId = VolunteerSessions.VolId)
					 INNER JOIN Departments ON Sessions.Type = Departments.DepartmentCode
	WHERE (GmID = #GmActivityGmId#)
</cfquery>

<Cfquery name="NumTableDerived" datasource="#ds#">
SELECT TablesPerRoom.RoomName,
       CASE WHEN TableType = 1 then 'MaxNumSquareTables' else 'MaxNumRoundTables' END AS Expr1,
	   TablesPerRoom.Count as maxNum
FROM TablesPerRoom
</cfquery>

<cfquery name="numRectangular" dbtype="query">
SELECT maxNum from NumTableDerived where RoomName = 'Rectangular'
</cfquery>
<cfquery name="numRound" dbtype="query">
SELECT maxNum from NumTableDerived where RoomName = 'Round'
</cfquery>



<cfset rooms_and_tables = QueryNew("RoomName, MaxNumRoundTables, MaxNumSquareTables")>

<cfset temp = QueryAddRow(rooms_and_tables, 2)>
<cfset temp = QuerySetCell(rooms_and_tables, "RoomName", "Rectangular", 1)>
<cfset temp = QuerySetCell(rooms_and_tables, "RoomName", "Round", 2)>
<cfset temp = QuerySetCell(rooms_and_tables, "MaxNumSquareTables", numRectangular.maxNum, 1)>
<cfset temp = QuerySetCell(rooms_and_tables, "MaxNumRoundTables", numRound.maxNum,2)>



<cfquery name="NumTables" dbtype="query">
SELECT sum(rooms_and_tables.MaxNumRoundTables) as MaxNumRoundTables, sum(rooms_and_tables.MaxNumSquareTables) as MaxNumSquareTables
FROM rooms_and_tables
<CFIF Not IsDefined("SHOWALLROOMS")>
	where roomname = '#theroom#'
</cfif>
</cfquery>

<cfif NumTables.MaxNumRoundTables EQ "">
	<cfset Temp = QuerySetCell(NumTables, "MaxNumRoundTables", 0)>
</cfif>
<cfif NumTables.MaxNumSquareTables EQ "">
	<cfset Temp = QuerySetCell(NumTables, "MaxNumSquareTables", 0)>
</cfif>

<Cfset MinimumHour = 9>

<cfinvoke component="necronomicon"
	method="retriveClock"
	GamesOnly="No"
	returnvariable="clock"></cfinvoke>

<p />

<font size="+2"><b>Scheduled Activity Map
<CFIF Not IsDefined("SHOWALLROOMS")>
	 - Room: <cfoutput>#theroom#</cfoutput>
</cfif>
</b></font><br>
<table border="0" cellspacing="10" width="630px">
<tr>
<cfoutput query="clock">
<td valign="top" width="33%">
<table cellspacing="3" cellpadding="3" >
	<tr>
		<th colspan="25" bgcolor="Maroon" align="left" width="210px" colspan="2" >
			<font color="White">#DateFormat(SessionDate, "ddd")#</font>
		</th>
	</tr>

	<cfset numHrs = DateDiff("h", MinOFSessionBegins, MaxOfSessionEnds)+1>
	<cfset oneHr  = CreateTimeSpan(0,1,0,0)>
	<cfset thisHour = MinOFSessionBegins>

	<cfset fluffHour = DatePart("h", thisHour) - 1>

	<cfloop index="x" from="#MinimumHour#" to="#fluffHour#">
			<tr>
				<td valign="top" align="left" width="40" nowrap>
<!---				<font size="-1">
					<cfif X LTE 12>
						#X#&nbsp;AM
					<Cfelse>
						#Evaluate("X - 12")#&nbsp;PM
					</cfif>
				</font>
--->
				&nbsp;
				</td>
	</cfloop>


	<cfloop index="x" from="1" to="#numHrs#">
		<tr>
			<td valign="top" align="left" width="40" nowrap><font size="-1">#TimeFormat(thisHour, "htt")#</font></td>

			<cfquery name="Schedule" datasource="#ds#" dbtype="ODBC">
				SELECT 		SessionDate, SessionBegins, Type, Title, Shape,
							LengthOfGame, System, GM, NumPlayers, GameTypeId, GmId, room, GameID
				FROM 		Schedule
				GROUP BY 	SessionDate, SessionBegins, Shape, Title, Type,
							LengthOfGame, System, GM, NumPlayers, GameTypeId, GmId, room, GameID
				HAVING		(SessionBegins = #CreateODBCDateTime(thisHour)#) and (GmID = #GmActivityGmId#)
				ORDER BY 	SessionDate, SessionBegins, Shape, Title
			</cfquery>


			<cfloop query="Schedule">
					<td width="100"
						rowspan="#LengthOfGame#"
						align="center"
						valign="top"
						onClick="editGame(#GameID#)"
						class="drag"
						bgcolor="Olive">
						<font color="White">
						<b>#Left(Title, 60)#<cfif len(title) GT 60> ...</cfif> </b><br>
<!---
						#System#<BR>
						<i>#GM#</i><br>
						#LengthofGame# hours

						<Cfif (IsDefined("SHOWALLROOMS"))>
							<br>
							[#room#]
						<Cfelse>
							<cfif (room NEQ #theroom#)>
							<br>
							[#room#]
							</cfif>
						</cfif>
--->
						</font>
					</td>
			</cfloop>

			<cfquery name="VolSchedule" datasource="#ds#" dbtype="ODBC">
				SELECT Sessions.SessionDate, Sessions.SessionBegins, Volunteers.GmId, Sessions.SessionLen, Departments.DepartmentName
				FROM (Volunteers INNER JOIN (VolunteerSessions
								 INNER JOIN Sessions ON VolunteerSessions.SessionId = Sessions.SessionID) ON Volunteers.VolId = VolunteerSessions.VolId)
								 INNER JOIN Departments ON Sessions.Type = Departments.DepartmentCode
				WHERE (SessionBegins = #CreateODBCDateTime(thisHour)#) and (GmID = #GmActivityGmId#)
			</cfquery>
			<cfloop query="VolSchedule">
					<td width="100" rowspan="#SessionLen#" align="center" valign="top" bgcolor="Fuchsia" class="drag"
						title="Volunteer" onclick="if (volun) volun()"  nowrap>
						<font color="Black"><i>#DepartmentName#</i></font>
					</td>

			</cfloop>

			<cfquery name="LarpSchedule" datasource="#ds#" dbtype="ODBC">

				SELECT *
				FROM (

					SELECT *,
						CAST (
						CONVERT(char(10), [DateOfLarp],126) + ' ' +
						(Left([Larps].[DATEOFLARPSTRING],CHARINDEX (' ',[DATEOFLARPSTRING])-3) + ':00:00 ' + SUBSTRING ([DATEOFLARPSTRING],CHARINDEX (' ',[DATEOFLARPSTRING])-2,2)) AS DATETIME) as SessionBegins
					FROM Larps
					WHERE APPROVED = 1 and GmID = #GmActivityGmId#) ddd
				WHERE (SessionBegins = #CreateODBCDateTime(thisHour)#)
			</cfquery>


			<cfloop query="LarpSchedule">
					<td width="100" rowspan="#LengthOfGame#" align="center" valign="top" bgcolor="Cyan" class="drag"
						title="Larp: #Game_Title#"  nowrap>
						<font color="Black">#Left(Game_Title, 60)#<cfif len(Game_Title) GT 60> ...</cfif></font>
					</td>

			</cfloop>

<!---
			<cfif IsDefined("ShowSessions")>
				<cfloop index="i" from="1" to="3">
					<cfif #CreateODBCDateTime(thisHour)# EQ #CreateODBCDateTime(TimeArray[i])#>
						<cfset EndOfSEssion = thisHour + CreateTimeSpan(0,GmActivityLengthOfGame,0,0)>

						<cfquery name="tablesUsed" datasource="#ds#" dbtype="ODBC">
							SELECT CountOfTablesByHour.TableType, Max(CountOfTablesByHour.SUMOFGAMEID) AS MaxOfCountOfTableType
							FROM CountOfTablesByHour
							WHERE (CountOfTablesByHour.Hour >= #CreateODBCDAteTime(thisHour)#) And
								  (CountOfTablesByHour.Hour  < #CreateODBCDateTime(EndOfSession)#) AND
								  (TableType = #GMActivityTableType#)
							GROUP BY CountOfTablesByHour.TableType;
						</cfquery>

						<cfif tablesUsed.RecordCount EQ 0>
							<cfset UsedTables = 0>
						<cfelse>
							<cfset UsedTables = #tablesUsed.MaxOfCountOfTableType#>
						</cfif>



						<cfif GMActivityTableType eq 1>
							<cfset AvailableTables = NumTables.MaxNumSquareTables - UsedTables>
						<cfelse>
							<cfset AvailableTables = NumTables.MaxNumRoundTables - UsedTables>
						</cfif>

						<td width="100"
							rowspan="#GmActivityLengthOfGame#"
							align="center"
							valign="top"
							onmouseover="this.style.backgroundColor='Cyan';"
							onmouseout="this.style.backgroundColor='Teal';"
							bgcolor="Teal"
							onclick='setSession("Session#Na.GameId#", "Approved#Na.GameId#", #RequestArray[i]#);'
							class="drag"
							 nowrap
							>
						  <b>
						  	<i>
								<font color="Black">
								Session<br>
								Request<br>
								###i#<br>
								(#AvailableTables# Tables<br>
								Available)
								</font>
							</i>
						  </b>
						</td>

					</cfif>

				</cfloop>
			</cfif>
--->
		</tr>
	<cfset thisHour = thisHour + oneHr>
	</cfloop>


</table>
</td>

</cfoutput>
</tr>
</table>