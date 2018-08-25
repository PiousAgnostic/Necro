
<CFIF Not IsDefined("Session.Administrator")>
	<cflocation url="admin.cfm" addtoken="No">
</cfif>

<script type="text/javascript" src="ckeditor/ckeditor.js"></script>

<html>
<head>
	<title>Administration Form</title>


<style>
<!--
.drag{cursor:hand}
-->
</style>




<link rel="stylesheet" type="text/css" href="styles/main.css">
<body style="margin-left: 25px;">
<h1>Convention Administration Screen</h1>

<cfif IsDefined("form.SubmitTop")>

<!--- <cfoutput><pre>
			UPDATE 	Admin
			SET		ConventionName = '#form.ConventionName#',
					ConventionDate = #CreateODBCDate(form.ConventionDate)#,
					ConventionEnds = #CreateODBCDate(form.ConventionEnds)#,
					LastGameTime   = #CreateODBCTime(form.LastGameTime)#,
					DropDeadDate =   #CreateODBCDate(form.DropDeadDate)#,
					HoursForFree =   #form.HoursForFree#,
					MaxNumRoundTables = #form.MaxNumRoundTables#,
					MaxNumSquareTables = #form.MaxNumSquareTables#,
					EMAIL			   = '#form.email#',
					Announcement = '#form.announcement#'
</pre></cfoutput>	 --->
  	<CFTRY>
		<cfquery datasource="#ds#" dbtype="ODBC">
			UPDATE 	Admin
			SET		ConventionName = '#form.ConventionName#',
					ConventionDate = #CreateODBCDate(form.ConventionDate)#,
					ConventionEnds = #CreateODBCDate(form.ConventionEnds)#,
					LastGameTime   = #CreateODBCTime(form.LastGameTime)#,
					DropDeadDate =   #CreateODBCDate(form.DropDeadDate)#,
					DateToOpenSite = #CreateODBCDate(form.DateToOpenSite)#,
					HoursForFree =   #form.HoursForFree#,
					MaxNumRoundTables = #form.MaxNumRoundTables#,
					MaxNumSquareTables = #form.MaxNumSquareTables#,
					EMAIL			   = '#form.email#',
					VolunteerAdminPassword = '#form.VolunteerAdminPassword#',
					Announcement = '#form.announcement#',
					ParticipationText = '#form.participationtext#',
					LarpText = '#form.larptext#',
					LastDateToVolunteer = #CreateODBCDate(form.LastDateToVolunteer)#
		</cfquery>


<!--- 		<cflocation url="adminhome.cfm"> --->
<CFCATCH>
		<b style="color: Red;">There was a problem updating to your new data.</b>
<!--- 		<br>
		<cfoutput><font color="White">'#form.announcement#'</font></cfoutput>
		<br> --->
		<cfset lConventionName = #form.ConventionName#>
		<cfset lConventionDate = #form.ConventionDate#>
		<cfset lConventionEnds = #form.ConventionEnds#>
		<cfset lLastGameTime    = #form.LastGAmeTime#>
		<cfset lDropDeadDate   = #form.DropDeadDate#>
		<cfset lDateToOpenSite = #form.DateToOpenSite#>
		<cfset lHoursForFree = #form.HoursForFree#>
		<cfset lMaxNumRoundTables = #form.MaxNumRoundTables#>
		<cfset lMaxNumSquareTables = #form.MaxNumSquareTables#>
		<cfset lemail = #form.email#>
		<cfset lAnnouncement = #form.announcement#>
		<cfset lparticipationtext = #form.participationtext#>
		<cfset llarptext = #form.larptext#>
		<cfset lVolunteerAdminPassword = #form.VolunteerAdminPassword#>
		<cfset lLastDateToVolunteer = #form.LastDateToVolunteer#>

 		<cfset badupdate = 1>
 	</CFCATCH>

	</CFTRY>
</cfif>

<cfif Not IsDefined("badupdate")>
	<Cfquery name="Avid" datasource="#ds#" dbtype="ODBC">
		SELECT TOP 1 HoursForFree,
					 DropDeadDate,
					 ConventionDate,
					 ConventionEnds,
					 LastGameTime,
					 ConventionName,
					 DateToOpenSite,
					 MaxNumRoundTables,
					 MaxNumSquareTables,
					 email,
					 announcement,
					 participationtext,
					 larptext,
					 VolunteerAdminPassword,
					 LastDateToVolunteer
		FROM Admin;
	</cfquery>

	<cfset lConventionName = #avid.ConventionName#>
	<cfset lConventionDate = #DateFormat(avid.ConventionDate, "mm/dd/yyyy")#>
	<cfset lConventionEnds = #DateFormat(avid.ConventionEnds, "mm/dd/yyyy")#>
	<cfset lLastGameTime   = #TimeFormat(avid.LastGameTime, "h:mm tt")#>
	<cfset lDropDeadDate   = #DateFormat(avid.DropDeadDate, "mm/dd/yyyy")#>
	<cfset lDateToOpenSite = #DateFormat(avid.DateToOpenSite, "mm/dd/yyyy")#>
	<cfset lHoursForFree = #avid.HoursForFree#>
	<cfset lMaxNumRoundTables = #avid.MaxNumRoundTables#>
	<cfset lMaxNumSquareTables = #avid.MaxNumSquareTables#>
	<cfset lemail = #avid.email#>
	<cfset lannouncement = #avid.announcement#>
	<cfset lparticipationtext = #avid.participationtext#>
	<cfset llarptext= #avid.larptext#>
	<cfset lVolunteerAdminPassword = #avid.VolunteerAdminPassword#>
	<cfset lLastDateToVolunteer = #DateFormat(avid.LastDateToVolunteer, "mm/dd/yyyy")#>
</cfif>

<cfif IsDate(lConventionDate) AND IsDate(lConventionEnds)>

	<cfset BeginD = CreateODBCDate(lConventionDate)>
	<cfset EndD = CreateODBCDate(lConventionEnds)>
	<cfset oneDay = CreateTimeSpan(1,0,0,0)>
	<cfset NumDays = DateDiff("d", BeginD, EndD) + 1>

	<Cfloop index="x" from="1" to="#NumDays#">
		<cftry>
			<cfquery datasource="#ds#" dbtype="ODBC">
				INSERT INTO ConventionDays ([Date])
				VALUES (#CreateODBCDate(BeginD)#);
			</cfquery>
		<cfcatch>
		</cfcatch>
		</cftry>

		<cfset BeginD = BeginD + oneDay>
	</cfloop>

</cfif>


<CFIF IsDefined("form.SubmitBottom")>

<!--- 	<cfquery name="GameSessions" datasource="#ds#" dbtype="ODBC">
		SELECT * from ConventionDays
		ORDER BY [Date];
	</cfquery> --->


	<cfquery name="GameSessions" datasource="#ds#" dbtype="ODBC">
		SELECT * from ConventionDays
		ORDER BY [Date];
	</cfquery>


	<cfloop query="GameSessions">



		<CFSET FirstG = Evaluate('form.FirstG' & ID)>
		<CFSET FirstV = Evaluate('form.FirstV' & ID)>
		<CFSET NumG   = Evaluate('form.NumG' & ID)>
		<CFSET NumV   = Evaluate('form.NumV' & ID)>


	    <CFIF IsDefined("REM" & ID)>
			<cfquery datasource="#ds#">
				DELETE from ConventionDays
				WHERE ID = #ID#;
			</cfquery>
		<cfelse>
			<CFIF IsDate(FirstG) and IsDate(FirstV)>
				<cfquery datasource="#ds#" dbtype="ODBC">
					UPDATE ConventionDays
					SET FirstGameSession = #CreateODBCTime(FirstG)#,
						NumGameSessions  = #NumG#,
						FirstVolSession  = #CreateODBCTime(FirstV)#,
						NumVolSessions   = #NumV#
					WHERE ID = #ID#;
				</cfquery>
			</cfif>
		</cfif>
	</cfloop>


</cfif>

<cfquery name="GameSessions" datasource="#ds#" dbtype="ODBC">
	SELECT * from ConventionDays
	ORDER BY [Date];
</cfquery>


<form action="#thisfile#" method="post">

<cfoutput>
<table cellspacing="5" cellpadding="3" style="margin-left: 50px;">
	<tr>
		<td id="gi_heading"><b class="drag" title="This is the name of the convention">Convention Name</b></td>
		<td colspan="3"><input type="text" name="ConventionName" value="#lConventionName#" size="50"></td>
	</tr>

	<tr>
		<td id="gi_heading"><b class="drag" title="Enter the starting date of the convention">Convention Begins</b></td>
		<td colspan="3"><input type="text" name="ConventionDate" value="#lConventionDate#" size="10"></td>
	</tr>
	<tr>
		<td id="gi_heading"><b class="drag" title="Enter the ending date of the convention">Convention Ends</b></td>
		<td><input type="text" name="ConventionEnds" value="#lConventionEnds#" size="10"></td>
	</tr>
	<tr>
		<td id="gi_heading"><b class="drag" title="Enter the 'kick-out' time on the last day of the convention">Kick-out time</b></td>
		<td><input type="text" name="LastGameTime" value="#lLaStGameTime#" size="10"></td>
	</tr>


	<tr>
		<td id="gi_heading"><b class="drag" title="Hours Required to get into convention free">Hours Required</b></td>
		<td><input type="text" name="HoursForFree" value="#lHoursForFree#" size="2"></td>
	</tr>

	<tr>
		<td id="gi_heading"><b class="drag" title="Participant must enroll prior to this date in order to get in free">Drop Dead Date</b></td>
		<td><input type="text" name="DropDeadDate" value="#lDropDeadDAte#" size="10">
		<input type="hidden" name="MaxNumRoundTables" value="#lMaxNumRoundTables#" size="2">
		<input type="hidden" name="MaxNumSquareTables" value="#lMaxNumSquareTables#" size="2">
		</td>
	</tr>

	<tr>
		<td id="gi_heading"><b class="drag" title="Date games may begin being added">Date Site Opens Up</b></td>
		<td><input type="text" name="DateToOpenSite" value="#lDateToOpenSite#" size="10">
		</td>
	</tr>

	<tr>
		<td id="gi_heading"><b class="drag" title="Last date to Volunteer">Last Volunteer Date</b></td>
		<td><input type="text" name="LastDateToVolunteer" value="#lLastDateToVolunteer#" size="10">
		</td>
	</tr>

<!--- 	<tr>
		<td b
		gcolor="Maroon"><b class="drag" title="Enter the total number of Round Tables available for gaming">Round Tables</b></td>
		<td colspan="3"><input type="text" name="MaxNumRoundTables" value="#lMaxNumRoundTables#" size="2"></td>
	</tr>

	<tr>
		<td bgcolor="Maroon"><b class="drag" title="Enter the total number of Square Tables available for gaming">Square Tables</b></td>
		<td colspan="3"><input type="text" name="MaxNumSquareTables" value="#lMaxNumSquareTables#" size="2"></td>
	</tr>
 --->
	<tr>
		<td id="gi_heading"><b class="drag" title="Enter the email address of the gaming coordinator">Email</b></td>
		<td colspan="3"><input type="text" name="email" value="#lemail#" size="40"></td>
	</tr>
	<tr>
		<td colspan="4" id="gi_heading"><b class="drag" title="Main Text on front page">Main Text</b></td>
	</tr>
	<tr>
		<td colspan="4">
					<textarea cols="35"
			          rows="10"
					  id="Announcement"
			          name="Announcement">#lannouncement#</textarea>
		</td>
	</tr>
	<tr>
		<td colspan="4" id="gi_heading"><b class="drag" title="Text below Tabletop">Tabletop Text</b></td>
	</tr>
	<tr>
		<td colspan="4">
					<textarea cols="35"
			          rows="10"
					  id="participationtext"
			          name="participationtext">#lparticipationtext#</textarea>
		</td>
	</tr>
	<tr>
		<td colspan="4" id="gi_heading"><b class="drag" title="Text below Larps">Larp Text</b></td>
	</tr>
	<tr>
		<td colspan="4">
					<textarea cols="35"
			          rows="10"
					  id="larptext"
			          name="larptext">#llarptext#</textarea>
		</td>
	</tr>

	<tr style="visibility:collapse">
		<td id="gi_heading"><b class="drag" title="Volunteer Admin Password">Vol. Admin Password</b></td>
		<td colspan="3"><input type="text" name="VolunteerAdminPassword" value="#lVolunteerAdminPassword#" size="40"></td>
	</tr>
<!---	<tr>
		<td id="gi_heading">
			<a href="chgpassword.cfm" style="text-decoration:none"><button>Change Password</button></a>

		</td>
		<td>&nbsp;</td>
	</tr>--->
	<tr>
		<td id="gi_heading">
			<a href="events.cfm" >Con Events</a>

		</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td id="gi_heading">
			<input type="submit" name="SubmitTop" value="Update"><input type="Reset">
		</td>
	</tr>

</table>
</cfoutput>
</form>


<cfif GameSessions.RecordCount GT 0>
<hr>
<table width="100%" cellspacing="3" cellpadding="3">
	<tr id="gi_heading">
		<th colspan = 10>Convention Day Information</th>
	</tr>

	<tr id="gi_heading">
<!--- 		<th></th> --->
		<th valign="bottom">Date</th>
		<th>First Game Session</th>
		<th>Number Game Sessions</th>
		<th>First Volunteer Session</th>
		<th>Number Volunteer Sessions</th>
	</tr>


	<form action="#thisfile#" method="post">

	<cfoutput query="GameSessions">
	<tr>
<!--- 		<td><input type="submit" name="Delete#ID#" value="Delete"></td> --->
		<td align="center">
			<input type="Checkbox" name="REM#ID#">

			<b>#DateFormat(Date, "mm/dd/yyyy")#</b>
		</td>
		<td align="center">
			<input type="text" name="FirstG#Id#" value='#TimeFormat(FirstGameSession, "h:mm tt")#' style="text-align: center;">
		</td>
		<td align="Center">
			<select name="NumG#id#">
				<cfloop index="x" from="1" to="24">
					<option value="#x#"
						<CFIF X EQ NumGameSessions>selected</cfif>>#x#

				</cfloop>
			</select>
		</td>

		<td align="center">
			<input type="text" name="FirstV#Id#" value='#TimeFormat(FirstVolSession, "h:mm tt")#' style="text-align: center;">
		</td>
		<td align="Center">
			<select name="NumV#id#">
				<cfloop index="x" from="1" to="24">
					<option value="#x#"
						<CFIF X EQ NumVolSessions>selected</cfif>>#x#

				</cfloop>
			</select>
		</td>

	</tr>
	</cfoutput>
	<tr id="gi_heading">
		<th colspan = 10>
			<input type="submit" name="SubmitBottom" value="Update">&nbsp;<input type="Reset">&nbsp;<input type="submit" name="SubmitBottom" value="Create / View Sessions">
<!---  			&nbsp;<button onClick="javascript:document.location.href='departments.cfm'">Department Setup</button>
			&nbsp;<button onClick="javascript:alert(document.location.href)">Department Setup</button> --->
			<a href="departments.cfm">Department Setup</a>
	</td>
	</tr>
</table>

</form>



	<cfif IsDefined("form.SubmitBottom")>
		<cfif form.SubmitBottom EQ "Create / View Sessions">

		<hr>
		<p>
			<cfinclude template="CreateSessions.cfm">
		</cfif>
	</cfif>
</cfif>

<script type="text/javascript">
	CKEDITOR.replace( 'Announcement',
	{
		customConfig : 'ckeditor/config.js',
		toolbar : 'Full',
		height:150,
		resize_enabled:true,
		width:600
	});

		CKEDITOR.replace( 'participationtext',
	{
		customConfig : 'ckeditor/config.js',
		toolbar : 'Full',
		height:150,
		resize_enabled:true,
		width:600
	});

	CKEDITOR.replace( 'larptext',
	{
		customConfig : 'ckeditor/config.js',
		toolbar : 'Full',
		height:150,
		resize_enabled:true,
		width:600
	});
</script>

