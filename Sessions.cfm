<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>Untitled</title>
	
<cfquery name="AllSessions" datasource="#ds#" dbtype="ODBC">
	SELECT * FROM SESSIONS
	ORDER BY SessionDate, SessionBegins, Type
</cfquery>	
</head>
<link rel="stylesheet" type="text/css" href="styles/main.css">
<body style="margin-left: 25px;">
<h1>Sessions</h1>
<p>
The table below shows the current sessions defined for your convention.

<table border="1" cellspacing="3" cellpadding="3" bordercolorlight="Silver" bordercolordark="Gray" bgcolor="Olive">
<tr>
	<th bgcolor="Maroon">Day</th>
	<th bgcolor="Maroon">Begins</th>
	<th bgcolor="Maroon">Ends</th>
	<th bgcolor="Maroon">Type</th>
<!--- 	<th bgcolor="Maroon">Max Game<br>Length</th> --->
</tr>

<cfoutput query="AllSessions">
<tr align="center">
	<td>#DateFormat(SessionDate, "dddd, mmm d")#</td>
	<td>#TimeFormat(SessionBegins, "h tt")#</td>
	<td>#TimeFormat(SessionEnds, "h tt")#</td>
	<td>#Type#</td>
<!--- 	<td>#MaxLengthGame#</td> --->
</tr>

</cfoutput>
</table>

</body>
</html>
