<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>The Games</title>
</head>

<cfquery name="games" datasource="#ds#">
	SELECT 	Sessions.SessionDate, 
			Sessions.SessionBegins, 
			GameTypes.Type, 
			Games.System, 
			Games.Title, 
			[Game Masters].FirstName,
			[Game Masters].LastName,
			[Game Masters].email, 
			[Game Masters].emailVisable, 
			Games.Link, 
			Games.Description, 
			Games.AdultOnly, 
			Games.NumPlayers, 
			Games.RoleplayingStressed, 
			ExperienceLevels.Level, 
			Games.GameId, 
			[Game Masters].HomePage, 
			Games.Image, 
			Games.ImageApproved, 
			Games.Approved, 
			[Game Masters].Cancelled, 
			Games.LengthOfGame, 
			Games.TableType, 
			TableTypes.Shape, 
			GameTypes.GameTypeId, 
			[Game Masters].GMId, 
			Games.NumTables
	FROM 	((((Games INNER JOIN [Game Masters] ON Games.GMid = [Game Masters].GMId) LEFT JOIN Sessions ON Games.Session = Sessions.SessionID) LEFT JOIN GameTypes ON Games.GameType = GameTypes.GameTypeId) INNER JOIN ExperienceLevels ON Games.ExperienceLevel = ExperienceLevels.ExperienceId) INNER JOIN TableTypes ON Games.TableType = TableTypes.TypeId
</cfquery>

<body>
<cfoutput query="games">

	<cfif (#Image# GT "")>
		<img src="#Session.ProofURL#/#Image#" align="right" BORDER="0">
	</cfif>
	<h2>#Title#</h2></a>
	<b>Game System:</b> #System#<BR>
	<b>Game Type:</b> #Type#<BR>
	<b>Game Master:</b> #firstname# #lastname#<BR>
	<b>Description:</b> #Description#<br>
	<b>Length of Game:</b> #LengthOfGame# Hour(s)<br>
	<b>Number of Players:</b>#NumPlayers#<br>
	<b>Player Level:</b>#Level#<br>
	<b>Mature Content:</b> <cfif #AdultOnly# GT 0>Yes<cfelse>No</cfif><BR>
	<b>Roleplaying Stressed:</b> <cfif #RoleplayingStressed# GT 0>Yes<cfelse>Not Really</cfif><br>
<hr>
</cfoutput>


</body>
</html>
