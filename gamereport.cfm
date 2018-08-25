

<CFIF Not IsDefined("Session.Administrator")>
	<cflocation url="admin.cfm" addtoken="No">
</cfif>

<cfparam name="ORDERBY" default="[Game Masters].LastName, [Game Masters].FirstName, Games.Title">


<cfquery name="gameInfo" datasource="#ds#" dbtype="ODBC">
	SELECT 	[Game Masters].LastName,
			[Game Masters].FirstName,
			[Game Masters].MiddleName,
			[Game Masters].Alias,
			[Game Masters].GMId,
			Games.GameID,
			Games.Title,
			Games.ImageApproved,
			GameTypes.Type,
			GameViews.Views,
			gi.Interest,
			Sessions.SessionBegins

	FROM (((([Game Masters]
		INNER JOIN Games
			ON [Game Masters].GMId = Games.GMid)
		LEFT JOIN Sessions
			ON Games.Session = Sessions.SessionID)
		LEFT JOIN (select GameID, Count([IPAddress]) as Interest from GameInterest group by GameID) gi
			ON Games.GameID = gi.GameID)
		INNER JOIN GameTypes
			ON Games.GameType = GameTypes.GameTypeId)
		LEFT JOIN GameViews ON Games.GameId = GameViews.GameID

	GROUP BY [Game Masters].LastName,
			 [Game Masters].FirstName,
			 [Game Masters].GMId,
			 Games.GameID,
			 [Game Masters].Cancelled,
			 Games.Title,
			 Games.Approved,
			 Games.ImageApproved,
			 GameTypes.Type,
			 GameViews.Views,
			 Sessions.SessionBegins,
			 Games.Cancelled,
			 Games.Approved,
			 [Game Masters].MiddleName,
			 [Game Masters].Alias,
			 gi.Interest
	HAVING   [Game Masters].Cancelled=0
		AND   Games.Approved=1
		AND   Games.Cancelled=0
ORDER BY #ORDERBY#
</cfquery>


<link rel="stylesheet" type="text/css" href="styles/main.css">

<style>

.reportstyle {
				border-style:solid;
				border-color:#FFFFFF;
				border-width:thin;
				}

a.reportstyle2 {
				color: #FFFFFF;
				text-decoration: none;
}

</style>

<body style="margin-left: 25px;">
<h1>Game Report</h1>

To download game information in a format for the program book, click <a href="download_gamereport.cfm">here</a>.
<p></p>
<table  class="reportstyle" cellpadding="2" cellspacing="0">
<tr>
	<th class="reportstyle" bgcolor="maroon"><a class="reportstyle2" href="gamereport.cfm?ORDERBY=[Game Masters].LastName, [Game Masters].FirstName, Games.Title">Game Master</a></th>
	<th class="reportstyle" bgcolor="maroon"><a class="reportstyle2" href="gamereport.cfm?ORDERBY=Title">Game</a></th>
	<th class="reportstyle" bgcolor="maroon"><a class="reportstyle2" href="gamereport.cfm?ORDERBY=GameTypes.Type">Type</a></th>
	<th class="reportstyle" bgcolor="maroon"><a class="reportstyle2" href="gamereport.cfm?ORDERBY=Views DESC">Views</a></th>
	<th class="reportstyle" bgcolor="maroon"><A class="reportstyle2" HREF="gamereport.cfm?ORDERBY=Interest DESC">Likes</A></th>
	<th class="reportstyle" bgcolor="maroon"><A class="reportstyle2" HREF="gamereport.cfm?ORDERBY=SessionBegins">Assigned</a></th>
</tr>
<cfoutput query="gameInfo">
<tr>

	<td align="left">
		<a href="gminfo.cfm?gmid=#gmid#">
		#FirstName# <cfif #Alias# GT "">"#Alias#" </cfif> #LastName#</a>
	</td>
	<td align="left">
		<a href="needapproval.cfm?scheduledGame=#GameID#">
		#title#</a>
	</td>
	<td   align="center">
		#type#
	</td>
	<td  align="center">
		#Views#
	</td>
	<td align="center">
		#Interest#
	</td>
	<td  align="center">
		#DateFormat(SessionBegins, "ddd")# #Timeformat(SessionBegins, "h tt")#
	</td>
</tr>
</cfoutput>
</table>

