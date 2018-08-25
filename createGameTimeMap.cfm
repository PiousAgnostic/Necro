<cfsetting enablecfoutputonly="Yes"	>
<cfquery datasource="#ds#" dbtype="ODBC">
	DELETE FROM GameTimeTableMap
</cfquery>

<cfinvoke component="necronomicon"
	method="retriveClock"
	GamesOnly="Yes"
	returnvariable="tableclock"></cfinvoke>


<cfoutput query="tableclock">
	<cfset numHrs = DateDiff("h", MinOFSessionBegins, MaxOfSessionEnds)+LastOfMaxLengthGame-1>
	<cfset oneHr  = CreateTimeSpan(0,1,0,0)>
	<cfset oneMn  = CreateTimeSpan(0,0,1,0)>
	<cfset thisHour = MinOFSessionBegins>
	<cfset thisHourPlus = thisHour + oneMn>

<!--- 	NumHrs = #numHrs#<br> --->


	<cfloop index="x" from="1" to="#numHrs#">

<!--- 		Hour = #x#<br> --->


		<cfquery name="gamesThisHour" datasource="#ds#" dbtype="odbc">
			SELECT 	ActiveGamesBeginEnd.GameStarts,
					ActiveGamesBeginEnd.GameEnds,
					ActiveGamesBeginEnd.TableType,
					Games.NumTables,
					Games.Title,
					Games.GameID,
					Games.Room
			FROM 	ActiveGamesBeginEnd INNER JOIN Games ON
						ActiveGamesBeginEnd.GameId = Games.GameId
			WHERE 	(((ActiveGamesBeginEnd.GameStarts)<=#CreateODBCDateTime(thisHour)#) AND
					 ((ActiveGamesBeginEnd.GameEnds)>#CreateODBCDateTime(thisHourPlus)#) AND
					 (Games.GameID <> #TheGame#) AND
					 ((Games.Room = '#theroom#')))
			ORDER BY ActiveGamesBeginEnd.TableType
		</cfquery>

<!---Games this hour = #gamesthishour.recordcount#<br />	--->



<!--- 			SELECT ActiveGamesBeginEnd.*, Games.NumTables
			FROM ActiveGamesBeginEnd INNER JOIN Games ON ActiveGamesBeginEnd.GameId = Games.GameId
			WHERE (#CreateODBCDateTime(thisHour)# >= GameStarts) and
			      (#CreateODBCDateTime(thisHour)# < GameEnds) --->
<!--- 		Games This Hour = #gamesThisHour.Recordcount#<br> --->


		<cfloop query="gamesThisHOur">

<!--- 			#CreateODBCDateTime(thisHour)#, #GameID# , #TableType#, #NumTables#<br> --->

			<cfquery datasource="#ds#" dbtype="ODBC">
				INSERT INTO GameTimeTableMap (Room, Hour, TableType, GameId, ActualGameID)
				VALUES ('#room#', #CreateODBCDateTime(thisHour)#, #TableType#, #NumTables#, #GameID#);
			</cfquery>
		</cfloop>
		<cfset thisHour = thisHour + oneHr>
		<cfset thisHourPlus = thisHour + oneMn>
	</cfloop>
</cfoutput>

<!---<cfquery name="test" datasource="#ds#">
select * from GameTimeTableMap
</cfquery>

<cfdump var="#test#">--->
<cfsetting enablecfoutputonly="no"	>