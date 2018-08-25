<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>Raffle Tickets</title>
</head>

<CFIF Not IsDefined("Session.Administrator")>
	<cflocation url="admin.cfm" addtoken="No">
</cfif>	




<cfset Tickets = QueryNew("GmID, FirstName, LastName,  Title, SessionBegins")>


<cfinclude template="DeadLineInclude.cfm">



<cfoutput query="Participants">

<cfif Left(title, 12) neq "Volunteering" OR
	  title eq "Volunteering - Gaming Table">
		<cfset temp = QueryAddRow(Tickets)>
		<cfset temp = querySetCell(Tickets, "GmID", GMID)>
		<cfset temp = querySetCell(Tickets, "FirstName", FirstName)>
		<cfset temp = querySetCell(Tickets, "LastName", LastName)>
		<cfset temp = querySetCell(Tickets, "Title", title)>
		<cfset temp = querySetCell(Tickets, "SessionBegins", SessionBegins)>	  
</cfif>


</cfoutput>



<CFQUERY name="avid" datasource="#ds#" dbtype="ODBC">
SELECT TOP 1 CONVENTIONDATE, DropDeadDate, ConventionName, ConventionEnds, Announcement
	FROM ADMIN
</CFQUERY>

<link rel="stylesheet" type="text/css" href="styles/reports.css">
<body style="margin-left: 25px;" >

<cfset ticketCounter = 1>
<cfset perpagecounter = 0>
<cfoutput query="Tickets" group="GmID">
<table border="1" width=600 cellpadding="5" cellspacing="5">
<tr>
	<td width="50%">

		<table cellpadding="3">
			<tr>
				<td colspan=10>
					<img src="../necro/images/raffle_image.gif" align="left" width="50px">
					<font size="+2">#avid.ConventionName#<br>Champion's Raffle!</font>
				</td>
			</tr>
			<tr>
				<td colspan=10>
					<font size="-1">Raffle to be held 6PM #DateFormat(Avid.ConventionEnds, "mm/dd/yyyy")#</font>
				</td>
			</tr>
			<tr>
				<td colspan=10 align="right">
					<font size="-1">&gt;&gt;Lots of Great Gaming Prizes</font>
				</td>
			</tr>	
			<tr>
				<td colspan=10>
					<font size="-1">Winners MUST be present to win.</font>
				</td>
			</tr>
			<tr>
				<td colspan=5>
					<font size="-1">KEEP THIS STUB</font>
				</td>
				<td colspan=5 align="right">
					<font size="-1">No. G#NumberFOrmat(ticketCounter, "000")#</font>
				</td>				
			</tr>								
		</table>


	</td>

	<td width="50%" valign="top">
	
		<table cellpadding="3">
			<tr valign="top">
				<td colspan=8 valign="middle">
					<img src="../necro/images/dice.gif" align="left" width="50px">
					<font size="+2"><strong>Enter To Win</strong></font>
				</td>
				<td colspan = 2 valign="middle">
					<font size="-1">No. G#NumberFOrmat(ticketCounter, "000")#</font>
				</td>
			</tr>
			<tr align="center">
				<td colspan="10">
					<cfif Left(title, 12) eq "Volunteering">
				Volunteer Entry:
					<cfelse>
				GM Entry:
					</cfif>
				</td>
			</tr>
			<tr align="center">
				<td colspan="10">
					<font size="+2"><strong>#FirstName# #LastName#</strong></font>
				</td>
			</tr>		

		</table>	
	

	</td>
</tr>

</table>
<br>
<cfset perpagecounter = perpagecounter + 1>
<cfif perpagecounter eq 4>
	<br style="page-break-after: always">
	<cfset perpagecounter = 0>
</cfif>


<cfset ticketCounter = ticketCounter + 1>

<tr>
	<td colspan="14">
		<table cellspacing="3" cellpadding="3">
<cfoutput>

<cfif Left(title, 12) neq "Volunteering">

<table border="1" width=600 cellpadding="5" cellspacing="5" bordercolor="black">
<tr>
	<td width="50%">
		<table cellpadding="3">
			<tr>
				<td colspan=10>
					<img src="../necro/images/raffle_image.gif" align="left" width="50px">
					<font size="+2">#avid.ConventionName#<br>Champion's Raffle!</font>
				</td>
			</tr>
			<tr>
				<td colspan=10>
					<font size="-1">Raffle to be held 6PM #DateFormat(Avid.ConventionEnds, "mm/dd/yyyy")#</font>
				</td>
			</tr>
			<tr>
				<td colspan=10 align="right">
					<font size="-1">&gt;&gt;Lots of Great Gaming Prizes</font>
				</td>
			</tr>	
			<tr>
				<td colspan=10>
					<font size="-1">Winners MUST be present to win.</font>
				</td>
			</tr>
			<tr>
				<td colspan=5>
					<font size="-1">KEEP THIS STUB</font>
				</td>
				<td colspan=5 align="right">
					<font size="-1">No. G#NumberFOrmat(ticketCounter, "000")#</font>
				</td>				
			</tr>								
		</table>
	</td>

	<td width="50%">
		<table cellpadding="3">
			<tr valign="top">
				<td colspan=8 valign="middle">
					<img src="../necro/images/dice.gif" align="left" width="50px">
					<font size="+2"><strong>Enter To Win</strong></font>
				</td>
				<td colspan = 2 valign="middle">
					<font size="-1">No. G#NumberFOrmat(ticketCounter, "000")#</font>
				</td>
			</tr>
			<tr align="center">
				<td colspan="10"><font size="-1">Name:</font> _________________</td>
			</tr>
			<tr align="center">
				<td colspan="10">
					<font size="-1">Game: <strong>#Title#</strong></font>
				</td>
			</tr>
			<tr align="center">
				<td colspan="10">
					<font size="-1">Date/Time: <strong>#DateFormat(SessionBegins, "ddd")# @ #timeformat(SessionBegins, "h:mm tt")#</strong></font>
				</td>
			</tr>
			<tr align="center">
				<td colspan="10">
					<font size="-1">GM: <strong>#FirstName# #LastName#</strong></font>
				</td>
			</tr>						
		</table>	
	</td>
</tr>

</table>
<br>
<cfset perpagecounter = perpagecounter + 1>
<cfif perpagecounter eq 4>
	<br style="page-break-after: always">
	<cfset perpagecounter = 0>
</cfif>
<cfset ticketCounter = ticketCounter + 1>
</cfif>
</cfoutput>

</cfoutput>


</body>
</html>
