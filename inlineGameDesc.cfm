
<style type="text/css">
<!--
.cursor {  cursor: hand}
.posts {
	COLOR: #000000; FONT-FAMILY: Verdana, Arial, sans-serif; FONT-SIZE: 12px; MARGIN: 10px
}
-->
</style>

<Cfif GameID LT 10000>
	<cfquery name="game" datasource="#ds#">
		SELECT 		SessionDate,
					SessionBegins,
					Type,
					System,
					Title,
					GM,
					email,
					emailVisable,
					Link,
					Description,
					AdultOnly,
					NumPlayers,
					RoleplayingStressed,
					[Level],
					GameId,
					HomePage,
					Image,
					ImageApproved,
					LengthOfGame,
					Complexity
		FROM 		Schedule
		where GameID = #GameID#
	</cfquery>
<Cfelse>
	<cfquery name="game" datasource="#ds#">
	SELECT	    DateOfLarp as SessionDate,
				CAST (
				CONVERT(char(10), [DateOfLarp],126) + ' ' +
				(Left([Larps].[DATEOFLARPSTRING],CHARINDEX (' ',[DATEOFLARPSTRING])-3) + ':00:00 ' + SUBSTRING ([DATEOFLARPSTRING],CHARINDEX (' ',[DATEOFLARPSTRING])-2,2)) AS DATETIME) as SESSIONBEGINS,
				'LARP' as Type,
				GAME_SYSTEM as System,
				GAME_TITLE as title,
				GM_NAME as GM,
				'' as email,
				1 as emailVisable,
				'' as Link,
				[SYNOPSIS] as Description,
				0 as AdultOnly,
				CAST(MINPLAYERS AS INT) as NumPlayers,
				1 as RoleplayingStressed ,
				'Beginner' as [Level],
				LarpID+10000  as GameID,
				'' as HomePage,
				'' as Image,
				0 as ImageApproved,
				LengthOfGame,
				3 AS COMPLEXITY

	FROM        Larps
	WHERE LarpID = ( #GameID# -10000 )
	</cfquery>
</cfif>


<hr />
<!---<div style="border-color:#FFFFFF; border-width:thin; border-style:solid; margin:10,10,10,10;">--->
<cfoutput query="game">

	<cfinclude template="gamedescription.cfm">
</cfoutput>
<hr />
<!---</div>--->