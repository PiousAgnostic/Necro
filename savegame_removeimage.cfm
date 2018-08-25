<cfquery datasource="#ds#">
	Update Games
	Set Image = '',
	ImageApproved = 0
	WHERE   GameID = #GameId#;
</cfquery>


<cflocation url="gameintro.cfm?GM=#GMid#">