<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<CFIF Not IsDefined("Session.Administrator")>
	<cflocation url="admin.cfm" addtoken="No">
</cfif>	

<html>
<head>
	<title>Department Volunteer Information</title>


<style>
<!--
.drag{cursor:hand}
-->	
</style>	

<CFIF IsDefined("form.SubmitBottom")>

<!--- 	<cfquery name="GameSessions" datasource="#ds#" dbtype="ODBC">
		SELECT * from ConventionDays
		ORDER BY [Date];
	</cfquery> --->

	<cfquery name="VolunteerDays" datasource="#ds#" dbtype="ODBC">
		SELECT 	DepartmentDays.ID, 
				DepartmentDays.FirstVolSession, 
				DepartmentDays.NumVolSessions, 
				Departments.DepartmentCode, 
				Departments.DepartmentName, 
				DepartmentDays.Date, 
				Departments.VolunteersPerSession, 
				Departments.HoursPerSession,
				Departments.DepartmentID
		FROM DepartmentDays INNER JOIN Departments ON DepartmentDays.DepartmentID = Departments.DepartmentID
		ORDER BY Departments.DepartmentName, DepartmentDays.Date;
	</cfquery>

	<cfloop query="VolunteerDays">
			
		<CFSET FirstV = Evaluate('form.FirstV' & ID)>
		<CFSET NumV   = Evaluate('form.NumV' & ID)>
		
		
		<CFIF IsDate(FirstV)>
				<cfquery datasource="#ds#" dbtype="ODBC">
					UPDATE DepartmentDays
					SET FirstVolSession  = #CreateODBCTime(FirstV)#,
						NumVolSessions   = #NumV#
					WHERE ID = #ID#;
				</cfquery>
		</cfif>		
	</cfloop>
	
	
	<cfquery name="Departments" datasource="#ds#" dbtype="ODBC">
		SELECT * FROM DEPARTMENTS
		ORDER BY DEPARTMENTNAME
	</cfquery>	

	<cfloop query="Departments">
		<cfquery datasource="#ds#" dbtype="ODBC">
			UPDATE DEPARTMENTS
			SET VolunteersPerSession = #Evaluate('form.NumVols' & DepartmentID)#,
				HoursPerSession = #Evaluate('form.NumHrs' & DepartmentID)#
			WHERE DEPARTMENTID = #DEPARTMENTID#
		</cfquery>
	
	</cfloop>
	
	<cflocation url="administration.cfm">
	
</cfif>


<cftry>
	<cfquery name="VolunteerDays" datasource="#ds#" dbtype="ODBC">
		SELECT 	DepartmentDays.ID, 
				DepartmentDays.FirstVolSession, 
				DepartmentDays.NumVolSessions, 
				Departments.DepartmentCode, 
				Departments.DepartmentName, 
				DepartmentDays.Date, 
				Departments.VolunteersPerSession, 
				Departments.HoursPerSession, 
				Departments.DepartmentID
		FROM DepartmentDays INNER JOIN Departments ON DepartmentDays.DepartmentID = Departments.DepartmentID
		ORDER BY Departments.DepartmentName, DepartmentDays.Date;
	</cfquery>
<cfcatch>
	<cfset VolunteerDays = QueryNew("DepartmentName")>
</cfcatch>
</cftry>

	
<link rel="stylesheet" type="text/css" href="styles/main.css">
<body style="margin-left: 25px;">
<h1>Department Administration Screen</h1>

<form action="#thisfile#" method="post">



<table width="50%" cellspacing="3" cellpadding="3">
<CFOUTPUT query="VolunteerDays" GROUP="DepartmentName">


	<tr id="gi_heading">
		<th colspan = 2 align="left">#DepartmentName# Department</th>
		<th align="right">## Volunteers Per Session 
				<select name="NumVols#DepartmentID#">
					<cfloop index="x" from="1" to="4">
					<option value="#x#"
						<CFIF X EQ VolunteersPerSession>selected</cfif>>#x#
					</cfloop>
				</select><br>
				## Hours Per Session 
				<select name="NumHrs#DepartmentID#">
					<cfloop index="x" from="1" to="4">
					<option value="#x#"
						<CFIF X EQ HoursPerSession>selected</cfif>>#x#
					</cfloop>
				</select>
		</th>
	</tr>

	<tr id="gi_heading">
		<th valign="bottom">Date</th>
		<th>First Volunteer Session</th>
		<th>Number Volunteer Sessions</th>
	</tr>
	
		
	<CFOUTPUT>
	<tr>
		<td align="center">
		
			<b>#DateFormat(Date, "mm/dd/yyyy")#</b>
		</td>
	
		<td align="center">
			<input type="text" name="FirstV#Id#" value='#TimeFormat(FirstVolSession, "h:mm tt")#' style="text-align: center;">
		</td>
		<td align="Center">
			<select name="NumV#id#">
				<cfloop index="x" from="0" to="24">
					<option value="#x#"
						<CFIF X EQ NumVolSessions>selected</cfif>>#x#
				
				</cfloop>
			</select>	
		</td>		
		
	</tr>
	</cfoutput>
 



</cfoutput>
	<tr id="gi_heading">
		<th colspan = 10>
			<input type="submit" name="SubmitBottom" value="Update">&nbsp;<input type="Reset">
		</td>
	</tr>	
<!--- 	<tr id="gi_heading">
		<th colspan = 10>
			<button onClick="if (confirm('Do you really want to do this?')) document.location = 'NewVolDBStuff_initialize.cfm'">Refresh Departments</button>
		</td>
	</tr> --->		
</table>
</form>

</body>
</html>