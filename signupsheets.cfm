<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>Signup Sheets</title>

<CFIF Not IsDefined("Session.Administrator")>
	<cflocation url="admin.cfm" addtoken="No">
</cfif>

<style type="text/css">
    .pb { page-break-before: always; }
</style>

<CFTRY>
<CFQUERY datasource="#DS#">
	DROP TABLE SignupTables
</cfquery>
<CFCATCH>
</CFCATCH>
</CFTRY>

<cfquery datasource="#ds#">
	CREATE TABLE SignupTables
		(GAMEID	Integer,
		 TABLES Varchar(50)
		 )
</cfquery>

<cfquery name="tablez" datasource="#ds#">
SELECT TableAssignment.USEDBY, TableAssignment.[Table], TableAssignment.TABLES, TableAssignment.PIECE
FROM TableAssignment
WHERE ((Not (TableAssignment.USEDBY)=-1))
ORDER BY TableAssignment.USEDBY, TableAssignment.PIECE;
</cfquery>



<cfoutput query="tablez" group="USEDBY">
		<cfset tablesused = "">
		<CFOUTPUT>
			<cfloop index="i" from ="1" to="#Tables#">
				<cfset tbl = Table + i - 1>
				<cfset tablesused = ListAppend(tablesused, tbl)>
			</cfloop>
		</cfoutput>
		<CFQUERY datasource="#DS#">
			INSERT INTO SIGNUPTABLES (GAMEID, TABLES)
			VALUES (#USEDBY#,'#TABLESUSED#');
		</cfquery>
</cfoutput>

<cfquery name="games" datasource="#ds#" dbtype="ODBC">
SELECT Schedule.*, SignupTables.TABLES AS TABLESUSED, Games.HideOnSchedule
FROM (Schedule INNER JOIN SignupTables ON Schedule.GameId = SignupTables.GAMEID) INNER JOIN Games ON Schedule.GameId = Games.GameId
WHERE (((Schedule.Type)<>'Computer') AND ((Games.HideOnSchedule)=0 Or (Games.HideOnSchedule) Is Null))
ORDER BY Schedule.SessionBegins, Schedule.Room;
<!---

SELECT Schedule.*, SignupTables.TABLES AS TABLESUSED
FROM Schedule INNER JOIN SignupTables ON Schedule.GameId = SignupTables.GAMEID
			  INNER JOIN Games ON Schedule.GameID = Games.GameID
WHERE (Schedule.Type)<>'Computer') and
		((Games.HideOnSchedule = 0) OR (Games.HideOnSchedule is null))
ORDER BY Schedule.SessionBegins, Schedule.Room;

	SELECT Schedule.*, TableAssignment.Table, SignupTables.TABLES AS TABLESUSED
	FROM (Schedule INNER JOIN TableAssignment ON Schedule.GameId = TableAssignment.USEDBY) INNER JOIN SignupTables ON Schedule.GameId = SignupTables.GAMEID
	WHERE (((Schedule.Type)<>'Computer') AND ((TableAssignment.PIECE)=1))
	ORDER BY Schedule.SessionBegins, Schedule.Room, TableAssignment.Table; --->
</cfquery>


<cfset flag = 0>

</head>

<link rel="stylesheet" type="text/css" href="styles/reports.css">
<body>
<div align="center">
<cfoutput query="games">


<font style="font-size: 24pt; font-weight: bold;">#SESSION.CONVENTIONNAME#</font>
<p>
<font style="font-size: 20pt; font-weight: bold; text-decoration: underline; text-transform: uppercase;"> #title#</u></font>
<br>
GM: #GM#
<table width="100%" border="1" bordercolor="Black"  style="border-collapse: collapse">
<tr>
	<td align="center">Day</td>
	<td align="center">Time</td>
	<td align="center">Room</td>
	<td align="center">Tables</td>
	<td align="center">Shape</td>
</tr>
<tr>
	<td align="center">#DayOfWeekAsString(DatePart("w",SessionDate))#</td>
	<td align="center">#TimeFormat(SessionBegins,"htt")#</td>
	<td align="center">#Room#</td>
	<td align="center">#tablesused#</td>
	<td align="center">
<!--- 		<cfif Shape EQ "Round">RPG<cfelse>CCG</cfif> --->
			#shape#
	</td>
</tr>
</table>
<p>
<table width="100%" border="1" cellpadding="10" bordercolor="Black" style="border-collapse: collapse">
<tr>
	<td align="center">
	<font style="font-size: 14pt; font-family: "Times New Roman";">
	    Description of Game:<br>
		<b>#System#</b> (#Type#)
		<cfif Trim(Description) GT "">
			<cfset pdl = 600>
			<cfset printed_description = Description>
			<cfif len(printed_description) gt pdl>
				<cfset printed_description = reverse(left(printed_description, pdl))>
				<cfset pd = Find(".", printed_description)>
				<cfset printed_description = reverse(mid(printed_description, pd, pdl))>
			</cfif>
		</cfif>

		 - #printed_description#<br><i><b>#LengthofGame# hours</b></i>
	</font>
	<CFIF CLUBICON gt "">
		<BR>
		<img src="clubs/clubimages/#CLUBICON#" border="0" align="middle">
		<BR>
		<FONT size="-2">#CLUBNAME#</FONT>
	</CFIF>

	</td>
</tr>
</table>
<p>
<u><b>Players</b></u>
<p>

<cfif NumPlayers LT 8>
	<cfset NumCols = 2>
	<cfset tdw = "50%">
<cfelse>
	<cfif NumPlayers LT 16>
		<cfset NumCols = 3>
		<cfset tdw = "33%">
	<cfelse>
		<cfset NumCols = 4>
		<cfset tdw = "25%">
	</cfif>

</cfif>


<!--- <cfif NumPlayers GT 8>
	<cfset NumCols = 3>
	<cfset tdw = "33%">
<cfelse>
	<cfset NumCols = 2>
	<cfset tdw = "50%">
</cfif> --->

<cfset Rows = Ceiling(NumPlayers / NumCols)>

<table width="100%" cellspacing="10" cellpadding="10" bordercolor="Black">
<cfloop index="i" from="1" to="#rows#">
<!--- 	<CFSET A = I*2-1>
	<CFSET B = I*2> --->
<tr>
	<cfloop index= "c" from="1" to="#NumCols#">
		<cfset namenum = (I * NumCols) - NumCols + C>
		<td width="#tdw#" <cfif namenum LTE NumPlayers> style="border-collapse: collapse; border-style: none none solid none; border-width: thin;">#namenum#<cfelse>></cfif>&nbsp;</td>
	</cfloop>

<!--- 	<td width="50%" <cfif A LTE NumPlayers> style="border-collapse: collapse; border-style: none none solid none; border-width: thin;">#A#<cfelse>></cfif>&nbsp;</td>
	<td width="50%" <cfif B LTE NumPlayers> style="border-collapse: collapse; border-style: none none solid none; border-width: thin;">#B#<cfelse>></cfif>&nbsp;</td>
 ---></tr>

</cfloop>

</table>
<cfif NumPlayers LT 10>
<p>
<u><b>Alternates</u></b>
<p>
<table width="100%" cellspacing="10" cellpadding="10"  bordercolor="Black" >
<tr>
	<td width="50%" style="border-collapse: collapse; border-style: none none solid none; border-width: thin;">1</td>
	<td width="50%" style="border-collapse: collapse; border-style: none none solid none; border-width: thin;">2</td>
</tr>

</table>
</cfif>


<div class="pb"></div>
</cfoutput>
</div>
<!---    <cfheader
    name="Content-Type"
    value="application/msword">
    <cfheader
    name="Content-Disposition"
    value="attachment; filename=SignUpSheets.doc">--->

</body>
</html>
