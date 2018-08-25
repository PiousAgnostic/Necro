<cfheader
name="Content-Type"
value="application/msexcel">
<cfheader
name="Content-Disposition"
value="attachment; filename=participantreport.xls">


<html>
<head>
	<title>Untitled</title>


</head>

<!--- <body> --->
<cfinclude template="DeadLineInclude.cfm">


<center><h1>Participant List</h1></center>

<table border="0" cellspacing="3" cellpadding="3">

<cfoutput query="Participants" group="GmID">

<cfset TotalHours = 0>

<tr>
	<!--- <td>#DateFormat(GMDate, "mm/dd")#</td> --->
	<td>#FirstName# #LastName#</td>
	<td>#Telephone#</td>
	<td>#email#</td>
</tr>
<tr>
	<td colspan="14">
		<table cellspacing="3" cellpadding="3">
<cfoutput>
			<tr>
				<td width="10">&nbsp;</td>
				<td nowrap="nowrap">#Title#</td>
				<td>#DateFormat(SessionBegins, "ddd")# @ #timeformat(SessionBegins, "h:mm tt")#</td>
				<td>#LengthOfGame# hours
					<cfif multiplier gt 1> (counts as #evaluate(LengthofGame * Multiplier)# hours)</cfif>
				</td>
			</tr>

			<cfif multiplier gt 1>
				<cfset TotalHours = TotalHours + #evaluate(LengthofGame * Multiplier)#>
			<cfelse>
				<cfset TotalHours = TotalHours + LengthofGame>
			</cfif>

</cfoutput>
			<tr>
				<td width="10">&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td align="left"><font color="00CC00" size="+1">#TotalHours# hours total</font></td>
			</tr>


		</table>

	</td>
</tr>
</cfoutput>

</table>




</body>
</html>
