<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>Untitled</title>

 <CFIF Not IsDefined("Session.Administrator")>
	<cflocation url="admin.cfm" addtoken="No">
</cfif>	
	
<cfinclude template="createGameTimeMap.cfm">	
	
<cfquery name="TableUsage" datasource="#ds#" dbtype="ODBC">
	SELECT 	GameTimeTableMap.Hour, 
			TableTypes.Shape, 
			GameTimeTableMap.GameId AS TablesRequired,
			ActiveGamesBeginEnd.GameStarts, 
			ActiveGamesBeginEnd.GameEnds, 
			Games.Title, 
			[Game Masters].[FirstName],
			[Game Masters].[LastName], 
			GameTypes.Type
	FROM 	((((GameTimeTableMap 
				INNER JOIN ActiveGamesBeginEnd ON GameTimeTableMap.ActualGameID = ActiveGamesBeginEnd.GameId) 
				INNER JOIN TableTypes ON GameTimeTableMap.TableType = TableTypes.TypeId) 
				INNER JOIN Games ON ActiveGamesBeginEnd.GameId = Games.GameId) 
				INNER JOIN [Game Masters] ON Games.GMid = [Game Masters].GMId) 
				INNER JOIN GameTypes ON Games.GameType = GameTypes.GameTypeId
	GROUP BY 	GameTimeTableMap.Hour, 
				TableTypes.Shape, 
				GameTimeTableMap.GameId, 
				ActiveGamesBeginEnd.GameStarts, 
				ActiveGamesBeginEnd.GameEnds, 
				Games.Title, 
				[Game Masters].[FirstName],
				[Game Masters].[LastName], 
				GameTypes.Type
	ORDER BY 	GameTimeTableMap.Hour, 
				TableTypes.Shape, 
				ActiveGamesBeginEnd.GameStarts;
</cfquery>
</head>

<link rel="stylesheet" type="text/css" href="styles/main.css">
<body  style="margin-left: 25px;">
<h1>Table Usage</h1>
<p>

<cfoutput query="TableUsage" group="Hour">
	<h2>#DateFormat(hour, "ddd")# #TimeFormat(hour, "h:mm tt")# </h2>
	<cfoutput group="Shape">
		<cfset tottable = 0>
	
		&nbsp;&nbsp;<font size="+2" color="Green">#Shape#</font><br>
		<table width="75%" border="0" cellspacing="0" cellpadding="3" style="margin-left: 50px;">		
		<cfoutput>
			<tr>
				<td><b>
					<CFIF Len(Title) LT 30>
						#Title#
					<cfelse>
						#Left(Title, 27)#...
					</cfif>
				
				
				</b></td>
				<td align="center"><b>#FirstName# #LastName#</b></td>
				<td align="center"><b>#TimeFormat(GameStarts, "h:mm")#-#TimeFormat(GameEnds, "h:mm")#</b></td>
				<td align="center"><b>#TablesRequired#</b></td>
			</tr>
			<cfset tottable = tottable + #TablesRequired#>
		</cfoutput>
			<tr bgcolor="White" style="height: 5px;">
				<td></td>
				<td></td>
				<td></td>
				<td></td>
			</tr> 
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td align="center"><b>#tottable#</b></td>
			</tr>			
		</table>
	</cfoutput>
</cfoutput>


</body>
</html>
