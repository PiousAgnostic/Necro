


<html>
<head>
	<title>Untitled</title>
	

</head>

<!--- <body> --->

<cfquery name="GameRpt" datasource="#ds#">
	Select SessionDate, SessionBegins, System, Title, GM
	From Schedule
	Order by SessionDate, SessionBegins, System, Title, GM
</cfquery>

<center><h1>Gaming Schedule</h1></center>

<table  align="center" cellspacing="0">

<cfoutput query="GameRpt" group="SessionDate">
	<tr>
		<td colspan="2" align="center">
			<font size="+2">#DateFormat(SessionDate, "dddd MMMM dd, yyyy")#</font>
		</td>
	</tr>

	<cfoutput group="SessionBegins">
	<tr bgcolor="Maroon">
		<td colspan="2" align="left"><font color="white"><strong>#TimeFormat(SessionBegins, "h:mm TT")#</strong></font></td>
	</tr>
	<tr bgcolor="Maroon" align="left">
		<td><font color="white"><strong>System & Title</strong></font></td>
		<td><font color="white"><strong>Game Master</strong></font></td>
	</tr>
	
		<cfoutput>
			<TR>
				<TD>
					#System#
							
					<cfif Trim(Title) NEQ Trim(System)>
						&nbsp;-&nbsp;#Title#
					</cfif>	
				</TD>
				<TD>
					#gm#
				</TD>
			</TR>
								
		</cfoutput>
	
	</cfoutput>


</cfoutput>


</table>




    <cfheader 
    name="Content-Type" 
    value="application/msexcel">
    <cfheader 
    name="Content-Disposition" 
    value="attachment; filename=gamereport.xls"> 

</body>
</html>
