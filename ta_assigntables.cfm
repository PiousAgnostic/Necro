<CFSETTING ENABLECFOUTPUTONLY="NO">

<cfif showstuff>
	<h1>ta_assigntables</h1>
</cfif>


<!---PROCESS THE 'LOCKED' TABLE GAMES--->

<cfquery name="LockedLocations" datasource="#ds#">
SELECT Schedule.Tables, Schedule.TableCounts, Schedule.SessionBegins, Schedule.SessionEnds,
Schedule.Room, Schedule.GM, Schedule.LengthOfGame, GameID, TablesPerRoom.FirstRoomNumber
FROM Schedule
 INNER JOIN TablesPerRoom ON (Schedule.TableType = TablesPerRoom.TableType) AND (Schedule.Room = TablesPerRoom.RoomName)
WHERE Schedule.TableLocked=1;
</cfquery>

<cfif showstuff>
LockedLocations<br>
<cfdump var="#LockedLocations#">
</cfif>

<cfloop query="LockedLocations">

<cfif showstuff>
	<cfoutput>FOUND A LOCKED GAME: #gameid# - #room# / #Tables# / #TableCounts# / #LengthOfGame# hours -- ListLen = #ListLen(LockedLocations.Tables)#"<br /></cfoutput>
</cfif>
	<cfset TABLESTOUSE = "">

	<cfloop index="PC" from="1" to="#ListLen(LockedLocations.Tables)#">

		<cfset UpperBound = ListGetAt(LockedLocations.TableCounts, PC)-1>
		<CFLOOP index="C" from="0" to="#UpperBound#">
			<cfset pp = ListGetAT(LockedLocations.Tables, PC) + C >
			<cfset TABLESTOUSE = LISTAPPEND(TABLESTOUSE, PP)>
		</CFLOOP>
	</cfloop>

	<CFSET PIECE = PC - 1>
<cfif showstuff>
	<cfoutput>Tables To Use: #TABLESTOUSE#<br />	</cfoutput>
</cfif>
<!---	<CFQUERY name="test" datasource="#DS#">
		select * from TableAssignment
		WHERE (((TableAssignment.Room)='#LockedLocations.Room#') AND
		((TableAssignment.Table) In (#TABLESTOUSE#)) AND
		(TableAssignment.TimeSlot Between #CreateODBCDateTime(LockedLocations.SessionBegins)#
		 And #CreateODBCDateTime(LockedLocations.SessionEnds)#));
	</cfquery>

	<cfdump var="#test#">
	<cfabort>
			--->

<cfif showstuff>
	<CFOUTPUT>BEFORE UPDATE<BR /></CFOUTPUT>

	<CFOUTPUT>
			UPDATE TableAssignment
		SET TableAssignment.UsedBy = #LockedLocations.GameID#,
		gm = '#LockedLocations.gm#',
		piece = #Piece#,
		TABLES = #ListGetAt(LockedLocations.TableCounts, Piece)#
		WHERE (((TableAssignment.Room)='#LockedLocations.Room#') AND
		((TableAssignment.Table) In (#TABLESTOUSE#)) AND
		(TableAssignment.TimeSlot Between #CreateODBCDateTime(LockedLocations.SessionBegins)#
		 And #CreateODBCDateTime(LockedLocations.SessionEnds)#));
	</CFOUTPUT>
</cfif>

	<CFQUERY datasource="#DS#">
		UPDATE TableAssignment
		SET TableAssignment.UsedBy = #LockedLocations.GameID#,
		gm = '#LockedLocations.gm#',
		piece = #Piece#,
		TABLES = #ListGetAt(LockedLocations.TableCounts, Piece)#
		WHERE (((TableAssignment.Room)='#LockedLocations.Room#') AND
		((TableAssignment.[Table]) In (#TABLESTOUSE#)) AND
		(TableAssignment.TimeSlot Between #CreateODBCDateTime(LockedLocations.SessionBegins)#
		 And #CreateODBCDateTime(LockedLocations.SessionEnds)#));
	</cfquery>

<cfif showstuff>
	<CFOUTPUT>AFTER UPDATE<BR /></CFOUTPUT>
</cfif>


</cfloop>


<!---**********************************************************--->


<cfloop query="roomstables"	>
	<cfset mroomname = #roomname#>

<cfif showstuff>
	<cfoutput>
	<h3>#roomname#</h3>
	FirstRoomNumber = #FirstRoomNumber#<br />
	</cfoutput>
</cfif>

<cfoutput query="clock">

	<cfset numHrs = DateDiff("h", MinOFSessionBegins, MaxOfSessionEnds)+LastOfMaxLengthGame-1>
	<cfset oneHr  = CreateTimeSpan(0,1,0,0)>
	<cfset thisHour = MinOFSessionBegins>

<cfif showstuff>
	#DateFormat(THIShOUR, "mm/dd/yyyy")#<BR />
</cfif>

	<cfloop index="x" from="1" to="#numHrs#">


		<cfquery name="Schedule" datasource="#ds#" dbtype="ODBC">
			SELECT 		 s.LengthOfGame, s.GM,  s.NumTables, s.GameID, s.SessionBegins, s.SessionEnds, s.ExtraTimeNeeded
			FROM 		Schedule s
			WHERE s.LengthOfGame>0
			  AND SessionBegins = #CreateODBCDateTime(thisHour)#
			  AND s.Room='#mroomname#'
			  AND S.TableLocked=0
			ORDER BY 	NumTables DESC, LengthOfGame DESC
		</cfquery>



		<cfif Schedule.RecordCount GT 0>


			<cfset TheMill = ValueList(Schedule.GameID)>
<cfif showstuff>
			&nbsp;&nbsp;The Time: #TimeFormat(THISHOUR, "HH:MM")#<br />
	games this hour in this room<br>
	<cfdump var="#Schedule#">
</cfif>
			<!---PROCESS THE MILL (GM CHECKING)--->


			<CFIF ListLen(TheMill) GT 1>
				<CFSET ReverseMill = Reverse(TheMill)> <!---SMALL TABLES FIRST--->
			<cfelse>
				<CFSET ReverseMill = TheMill> <!---SMALL TABLES FIRST--->
			</CFIF>


			<!---<CFSET ReverseMill = TheMill>--->
<cfif showstuff>
	    CHECKING FOR GM PRIOR GAME: #ReverseMill#<br />
</cfif>
			<CFLOOP list="#TheMill#" index="Game">
				<cfquery dbtype="query" NAME="thisGame">
					SELECT *
					FROM SCHEDULE
					where GameID = #Game#
				</cfquery>

<cfif showstuff>
thisGame<br>
<cfdump var="#thisGame#">
</cfif>

				<CFSET LASTSESSION = DATEADD("H", -1, thisHour)>

				<cfquery datasource="#ds#" name="priorGameForThisGM">
					SELECT TOP 1 [Table], Tables
					FROM TableAssignment
					WHERE TIMESLOT = #CreateODBCDateTime(LASTSESSION)#
					  AND GM = '#ThisGame.GM#'
					  and Room = '#mRoomname#'
					ORDER BY [Table]
				</cfquery>

				<CFSET REUSETABLE = FALSE>

				<cfif priorGameForThisGM.RECORDCOUNT EQ 1>
<cfif showstuff>
					GM #thisGame.GM# (#thisGame.GameID#) Had a prior game at table #priorGameForThisGM.Table#<br />
</cfif>

					<!---CHECK TO SEE IF THE TABLE(S) IS AVAILABLE FOR THE WHOLE LENGTHOFGAME--->
					<cfquery datasource="#ds#" name="tableusedcurrentsession">
						select top 1 [table]
						from tableassignment
						where TIMESLOT between #CreateODBCDateTime(thisHour)# AND #CreateODBCDateTime(thisGame.SessionEnds)#
						  and Room = '#mRoomname#'
						  and [Table] BETWEEN #priorGameForThisGM.Table# AND (#priorGameForThisGM.Table# + #thisGame.NumTables# - 1)
						  and usedby <> 0
					</cfquery>


					<cfif tableusedcurrentsession.recordcount EQ 1>
<cfif showstuff>
						BUT THIS TABLE IS ALREADY SPOKEN FOR. <BR />
</cfif>
					<cfelse>
						<CFIF thisGame.NumTables LTE priorGameForThisGM.Tables>
							<CFSET REUSETABLE = TRUE>
						<CFELSE>
							<cfinclude template="td_split_available_tables.cfm">

							<CFIF (ListLen(tablesets[thisGame.NumTables]) GT 0) AND
								  (ListFind(tablesets[thisGame.NumTables], priorGameForThisGM.Table) GT 0)>
								  <CFSET REUSETABLE = TRUE>
							</CFIF>
						</CFIF>

						<CFIF REUSETABLE EQ TRUE>
							<cfset STARTTABLE = priorGameForThisGM.Table>
							<cfset TABLESTOUSE = "">

							<CFLOOP INDEX = "T" FROM="1" TO="#thisGame.NumTables#">
								<CFSET TABLESTOUSE = ListAppend(TABLESTOUSE, (STARTTABLE + T - 1))>
							</cfloop>


							<cfset tablehours = CreateTimeSpan(0,thisGame.LengthOfGame-1,59,0)>
							<cfset SessionEnds = thisGame.SessionBegins +  TableHours>

							<CFQUERY datasource="#DS#">
								UPDATE TableAssignment
								SET TableAssignment.UsedBy = #thisGame.GameID#,
									gm = '#thisGame.gm#',
									piece = 1,
									TABLES = #thisGame.NumTables#
								WHERE (((TableAssignment.Room)='#mRoomname#') AND
									   ((TableAssignment.[Table]) In (#TABLESTOUSE#)) AND
									   (TableAssignment.TimeSlot Between #CreateODBCDateTime(thisGame.SessionBegins)#
										 And #CreateODBCDateTime(SessionEnds)#));
							</cfquery>
							<!---REMOVE THIS GAME FROM THE MILL!--->

							<CFSET theMill = ListDeleteAt(theMill, ListFind(theMill, GAME))>
						</CFIF>

					</cfif>

				</cfif>


			</CFLOOP>
<cfif showstuff>
			&nbsp;The Mill: #TheMill#<br />
			mRoomname = #mroomname#<br />

</cfif>
			<!---PROCESS THE MILL (WITHOUT GM CHECKING)--->

			<CFLOOP list="#TheMill#" index="Game">
				<cfquery dbtype="query" NAME="thisGame">
					SELECT *
					FROM SCHEDULE
					where GameID = #Game#
				</cfquery>

				<cfinclude template="td_split_available_tables.cfm">
<cfif showstuff>
				Game #Game# needs #thisGame.NumTables# tables.<br />
				tablesets[#thisGame.NumTables#] = #tablesets[thisGame.NumTables]#<br />
</cfif>
				 <!---if there is room for this game --->

				<cfif ListLen(tablesets[thisGame.NumTables]) GT 0>
					<cfset STARTTABLE = ListFirst(tablesets[thisGame.NumTables])>

					<cfset TABLESTOUSE = "">

					<CFLOOP INDEX = "T" FROM="1" TO="#thisGame.NumTables#">
						<CFSET TABLESTOUSE = ListAppend(TABLESTOUSE, (STARTTABLE + T - 1))>
					</cfloop>
<cfif showstuff>
					THERE IS ROOM FOR THIS GAME IN TABLES: #TABLESTOUSE#<BR />
</cfif>
					<cfset tablehours = CreateTimeSpan(0,thisGame.LengthOfGame-1,59,0)>
					<cfset SessionEnds = thisGame.SessionBegins +  TableHours>

					<CFQUERY datasource="#DS#">
						UPDATE TableAssignment
						SET TableAssignment.UsedBy = #thisGame.GameID#,
							gm = '#thisGame.gm#',
							piece = 1,
							TABLES = #thisGame.NumTables#
						WHERE (((TableAssignment.Room)='#mRoomname#') AND
							   ((TableAssignment.[Table]) In (#TABLESTOUSE#)) AND
							   (TableAssignment.TimeSlot Between #CreateODBCDateTime(thisGame.SessionBegins)#
								 And #CreateODBCDateTime(SessionEnds)#));
					</cfquery>
				<CFELSE>

					<!---THERE ARE NO CONTIGUOUS TABLES FOR THIS GAME...MAYBE WE CAN SPLIT THEM UP?--->
<cfif showstuff>
					<h1>Sorry, no room for game #thisGame.GameID#! </h1>
</cfif>
					<CFIF thisGame.NumTables GT 1>
						<CFSET LOWERHALF_TABLE = CEILING(thisGame.NumTables / 2)>
						<CFSET UPPERHALF_TABLE = INT(thisGame.NumTables / 2)>

<cfif showstuff>
						<h2>
							LOWERHALF_TABLE = #LOWERHALF_TABLE#<br />
							UPPERHALF_TABLE = #UPPERHALF_TABLE#<br />
							tablesets[#LOWERHALF_TABLE#] = #tablesets[LOWERHALF_TABLE]#<br />
							tablesets[#UPPERHALF_TABLE#] = #tablesets[UPPERHALF_TABLE]#<br />
</CFIF>
							<cfif ((LOWERHALF_TABLE EQ UPPERHALF_TABLE) AND (ListLen(tablesets[LOWERHALF_TABLE]) GTE 2))
								   OR
								  ((LOWERHALF_TABLE NEQ UPPERHALF_TABLE) AND (ListLen(tablesets[LOWERHALF_TABLE]) GTE 1) AND (ListLen(tablesets[UPPERHALF_TABLE]) GTE 1))>

<cfif showstuff>
								  LOOKS LIKE IT MIGHT FIT!<BR />
</cfif>
								  <!---LOWERHALF--->
									<cfset STARTTABLE = ListFirst(tablesets[LOWERHALF_TABLE])>
									<CFSET tablesets[LOWERHALF_TABLE] = ListDeleteAt(tablesets[LOWERHALF_TABLE], 1)>

									<cfset TABLESTOUSE = "">

									<CFLOOP INDEX = "T" FROM="1" TO="#LOWERHALF_TABLE#">
										<CFSET TABLESTOUSE = ListAppend(TABLESTOUSE, (STARTTABLE + T - 1))>
									</cfloop>

<cfif showstuff>
									THERE IS ROOM FOR LOWERHALF THIS GAME IN TABLES: #TABLESTOUSE#<BR />
</cfif>
									<cfset tablehours = CreateTimeSpan(0,thisGame.LengthOfGame-1,59,0)>
									<cfset SessionEnds = thisGame.SessionBegins +  TableHours>

									<CFQUERY datasource="#DS#">
										UPDATE TableAssignment
										SET TableAssignment.UsedBy = #thisGame.GameID#,
											gm = '#thisGame.gm#',
											piece = 1,
											TABLES = #LOWERHALF_TABLE#
										WHERE (((TableAssignment.Room)='#mRoomname#') AND
											   ((TableAssignment.Table) In (#TABLESTOUSE#)) AND
											   (TableAssignment.TimeSlot Between #CreateODBCDateTime(thisGame.SessionBegins)#
												 And #CreateODBCDateTime(SessionEnds)#));
									</cfquery>

									<!---UPPERHALF--->

									<cfset STARTTABLE = ListFirst(tablesets[UPPERHALF_TABLE])>
									<CFSET tablesets[UPPERHALF_TABLE] = ListDeleteAt(tablesets[UPPERHALF_TABLE], 1)>

									<cfset TABLESTOUSE = "">

									<CFLOOP INDEX = "T" FROM="1" TO="#UPPERHALF_TABLE#">
										<CFSET TABLESTOUSE = ListAppend(TABLESTOUSE, (STARTTABLE + T - 1))>
									</cfloop>

<cfif showstuff>
									THERE IS ROOM FOR UPPERHALF THIS GAME IN TABLES: #TABLESTOUSE#<BR />
</cfif>
									<cfset tablehours = CreateTimeSpan(0,thisGame.LengthOfGame-1,59,0)>
									<cfset SessionEnds = thisGame.SessionBegins +  TableHours>

									<CFQUERY datasource="#DS#">
										UPDATE TableAssignment
										SET TableAssignment.UsedBy = #thisGame.GameID#,
											gm = '#thisGame.gm#',
											piece = 2,
											TABLES = #UPPERHALF_TABLE#
										WHERE (((TableAssignment.Room)='#mRoomname#') AND
											   ((TableAssignment.Table) In (#TABLESTOUSE#)) AND
											   (TableAssignment.TimeSlot Between #CreateODBCDateTime(thisGame.SessionBegins)#
												 And #CreateODBCDateTime(SessionEnds)#));
									</cfquery>

							<CFELSE>
<cfif showstuff>
								  NOPE!
</cfif>
							</cfif>


<cfif showstuff>
						</h2>
</cfif>

					</CFIF>


				</cfif>


			</CFLOOP>



		</cfif>
		<cfset thisHour = thisHour + oneHr>
	</cfloop>

</cfoutput>


</cfloop>



<!--- get rid of the unused slots --->

<CFQUERY datasource="#DS#" dbtype="ODBC">
	DELETE FROM TABLEASSIGNMENT
	WHERE USEDBY = 0
</cfquery>

<!--- Now mark the subordinate slots  --->

<CFQUERY datasource="#DS#" dbtype="ODBC">

UPDATE TableAssignment
SET TableAssignment.UsedBy = -1
WHERE (((TableAssignment.idnumber) Not In
	(SELECT top 10000 Min(TableAssignment.idnumber) AS MinOfidnumber
	 FROM TableAssignment
	 GROUP BY TableAssignment.Room, TableAssignment.UsedBy, TableAssignment.[Table]
 	 ORDER BY TableAssignment.Room, TableAssignment.UsedBy, TableAssignment.[Table], Min(TableAssignment.TimeSlot)))
	);
</cfquery>

 <CFQUERY datasource="#DS#" dbtype="ODBC">
UPDATE TableAssignment
SET TableAssignment.USEDBY = -1
WHERE (((TableAssignment.idnumber) Not In (SELECT  Min(TableAssignment.idnumber) AS MinOfidnumber
	 FROM TableAssignment
	 Where UsedBy <> -1
	 	 GROUP BY TableAssignment.UsedBy, Piece
     )) AND ((TableAssignment.[UsedBy])<>-1));
</CFQUERY>

<!---UPDATE GAMES WITH TABLE ASSIGNMENTS--->

<CFQUERY datasource="#DS#">
UPDATE GAMES
	SET TABLES = NULL,
		TABLECOUNTS = NULL
WHERE TABLELOCKED = 0
</CFQUERY>


<cfQUERY datasource="#DS#" name="ALLGAMES">
	SELECT GAMEID FROM SCHEDULE
</cfQUERY>

<CFLOOP query="ALLGAMES">
	<CFQUERY datasource="#DS#" name="ASSIGNEDTABLES">
		SELECT DISTINCT [Table], Tables
		FROM TableAssignment
		WHERE USEDBY=#GAMEID#
		ORDER BY [TABLE]
	</CFQUERY>

	<CFIF ASSIGNEDTABLES.RECORDCOUNT GT 0>
		<CFSET THETABLES = ValueList(ASSIGNEDTABLES.TABLE)>
		<CFSET THETABLECOUNTS = ValueList(ASSIGNEDTABLES.Tables)>

		<CFQUERY datasource="#DS#">
			UPDATE GAMES
				SET TABLES = '#THETABLES#',
					TABLECOUNTS = '#THETABLECOUNTS#'
			WHERE GAMEID = #GAMEID#
			  AND TABLELOCKED = 0
		</CFQUERY>
	</CFIF>

</CFLOOP>


<CFSETTING ENABLECFOUTPUTONLY="No">