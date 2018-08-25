<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>Participant List</title>
</head>

<CFIF Not IsDefined("Session.Administrator")>
	<cflocation url="admin.cfm" addtoken="No">
</cfif>


<cfinclude template="DeadLineInclude.cfm">

<link rel="stylesheet" type="text/css" href="styles/main.css">
<body style="margin-left: 25px;" >

<h1>Participant List</h1>
<font size="+2">Below is a list of all GM's and all Volunteers, along with the date
which they signed on to do their thing. </font>

<p>
<cfset GMFileName = #GetDirectoryFromPath(GetBaseTemplatePath())# & "Participants">



<p>To export this data in an Excell format, click <a href="Participant_report.xls">here</a>.<br>


<cfset filename = expandPath("./Participant_report.xls")>
<!--- Make a spreadsheet object --->
<cfset s = spreadsheetNew()>
<cfset RowCounter = 0>
<cfset FormattedRows = "">

<table border="0" cellspacing="3" cellpadding="3">

<cfoutput query="Participants" group="GmID">
<cfset TotalHours = 0>
<cfset RowCounter = RowCounter + 1>
<cfset FormattedRows = ListAppend(FormattedRows, RowCounter)>

<tr bgcolor="Olive">
	<!--- <td>#DateFormat(GMDate, "mm/dd")#</td> --->
	<td><FONT color="##FFFFFF">#FirstName# #LastName#</FONT></td>
	<td><FONT color="##FFFFFF">#Telephone#</FONT></td>
	<td><FONT color="##FFFFFF">#email#</FONT></td>
</tr>
<cfset spreadsheetAddRow(s, "#FirstName# #LastName#,#Telephone#,#email#")>

<tr>
	<td colspan="14">
		<table cellspacing="3" cellpadding="3">
<cfoutput>
	<cfset RowCounter = RowCounter + 1>
			<tr>
				<td width="10">&nbsp;</td>
				<td>#Title#</td>
				<td>#DateFormat(SessionBegins, "ddd")# @ #timeformat(SessionBegins, "h:mm tt")#</td>
				<td>#LengthOfGame# hours
					<cfif multiplier gt 1> (counts as #evaluate(LengthofGame * Multiplier)# hours)</cfif>
				</td>
			</tr>

			<CFSET STR = "#REREPLACE(trim(TITLE),",", "", "ALL")#,#DateFormat(SessionBegins, "ddd")# @ #timeformat(SessionBegins, "h:mm tt")#, #LengthOfGame# hours">
			<cfif multiplier gt 1><cfset STR = STR + " (counts as #evaluate(LengthofGame * Multiplier)# hours)"></cfif>
			<cfset spreadsheetAddRow(s, STR)>

			<cfif multiplier gt 1>
				<cfset TotalHours = TotalHours + #evaluate(LengthofGame * Multiplier)#>
			<cfelse>
				<cfset TotalHours = TotalHours + LengthofGame>
			</cfif>

</cfoutput>
		</table>

	</td>
</tr>
			<cfset spreadsheetAddRow(s, ",,#TotalHours# hours total")>
</cfoutput>

<cfset myFormat=StructNew()>
<cfset myFormat.color="white">
<cfset myFormat.bold=true>
<cfset myFormat.fgcolor="sea_green">
<cfset SpreadsheetFormatRows (s, myFormat, FormattedRows)>


<cfset spreadsheetWrite(s, filename, true)>
</table>
</body>
</html>
