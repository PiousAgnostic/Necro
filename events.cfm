
<!---
<CFIF Not IsDefined("Session.Administrator")>
	<cflocation url="admin.cfm" addtoken="No">
</cfif>	--->

<cftry>

<cfquery datasource="#ds#">
UPDATE EVENTS
	SET LENGTHOFEVENT = LENGTHOFEVENT * 60
WHERE LENGTHOFEVENT < 30
</cfquery>

<cfcatch>
</cfcatch>
</cftry>



<CFQUERY name="avid" datasource="#ds#" dbtype="ODBC" cachedWithin="#CreateTimeSpan(0,0,10,0)#">
SELECT TOP 1 CONVENTIONDATE, DropDeadDate, ConventionName, ConventionEnds, Announcement, ParticipationText, LarpText, PASSWORD, HOURSFORFREE
	FROM ADMIN
</CFQUERY>

<cfset DateList = "">
<cfset dd = avid.ConventionDate>

<cfloop condition="dd LTE avid.ConventionEnds">

	<cfset DateList = ListAppend(DateList, DateFormat(dd, "mm/dd/yyyy"))>

	<Cfset dd = Dateadd("d", 1, dd)>
</cfloop>

<cfset timeList = "">
<cfset tt = CreateDateTime(1960, 1, 1, 9, 0, 0)>

<cfloop condition="tt LTE CreateDateTime(1960, 1, 1, 23, 0, 0)">
	<cfset TimeList = ListAppend(TimeList, TimeFormat(tt, "HH:MM"))>
	<Cfset tt = Dateadd("n", 30, tt)>
</cfloop>

<script language="JavaScript">
	function newold(btn)
	{
		//alert(btn.checked);

		btn.form.title0.disabled = !btn.checked;
		btn.form.sd0.disabled = !btn.checked;
		btn.form.st0.disabled = !btn.checked;
		btn.form.l0.disabled = !btn.checked;
		btn.form.d0.disabled = !btn.checked;
		btn.form.title0.focus();
	}
</script>





</head>

<link rel="stylesheet" type="text/css" href="styles/main.css">

<cfif IsDefined("form.op")>

	<cfquery name="events" datasource="#ds#" dbtype="ODBC">
		SELECT * FROM Events
		Order by Starts
	</cfquery>

	<cfoutput query="events">
		<cfif IsDefined("form.del" & #EventID#)>
			<cfquery datasource="#ds#">
				DELETE from EVENTS
				WHERE EventID = #EventID#
			</cfquery>

		<cfelseif IsDefined("form.title" & #EventID#)>

			<CFSET TTL = Evaluate("form.title" & #EventID#)>
			<cfset LNG = Evaluate("form.l" & #EventID#)>
			<cfset DSC = Evaluate("form.D" & #EventID#)>
			<CFSET STS = Evaluate("form.sd" & #EventID#) & " " & Evaluate("form.st" & #EventID#)>
			<cfquery datasource="#ds#">
				UPDATE EVENTS
					SET TITLE = '#TTL#',
					    LENGTHOFEVENT = #LNG# * 60,
						DESCRIPTION = '#DSC#',
						STARTS = #CreateODBCDateTime(sts)#
				WHERE EventID = #EventID#
			</cfquery>


		</cfif>
	</cfoutput>


	<CFIF IsDefined("form.new")>
			<CFSET TTL = Evaluate("form.title0")>
			<cfset LNG = Evaluate("form.l0")>
			<cfset DSC = Evaluate("form.D0" )>
			<CFSET STS = Evaluate("form.sd0") & " " & Evaluate("form.st0")>

		<cfquery datasource="#ds#">
			INSERT INTO EVENTS (TITLE, LENGTHOFEVENT, DESCRIPTION, STARTS)
			VALUES ('#TTL#',#LNG#*60,'#DSC#',#CreateODBCDateTime(sts)#)
		</cfquery>
	</cfif>

</cfif>

<cfquery name="events" datasource="#ds#" dbtype="ODBC">
	SELECT * FROM Events
	Order by Starts
</cfquery>

<h2>Event Maintenance</h2>
Con events defined here will appear on the Schedule Map as an aid to con attendees
<p>
<center>
<form action="#thisfile#" method="post">

<table cellpadding="5" bgcolor="Teal" style="border-color: White ; border: thin solid;">
	<tr>
		<td colspan="2" bgcolor="Gray">
			<input type="checkbox" name="new" value="" onClick="newold(this)">Add New Event
		</td>
	</tr>
	<tr>
		<td><b>Title</b></td>
		<td><input type="text" name="title0" value="" size="60" maxlength="128" disabled>  </td>
	</tr>
	<tr>
		<td><b>Start Date</b></td>
		<td>
			<!---<input type="text" name="sd0" value="" size="10" maxlength="10"  disabled> --->
			<cfoutput>
			<select name="sd0" disabled>
				<cfloop list="#DateList#" index="dd">
					<option>#DD#</option>
				</cfloop>
			</select>
			</cfoutput>
		</td>
	</tr>
	<tr>
		<td><b>Start Time</b></td>
		<td>
			<!---
			<input type="text" name="st0" value="" size="5" maxlength="5" disabled>&nbsp;
			<font size="-1" color="white">Please use military 24-hour times, such as 5PM = 17:00</font>
			--->
			<cfoutput>
			<select name="st0" disabled>
				<cfloop list="#TimeList#" Index="tt">
				<option>#tt#</option>
				</cfloop>

			</select>
			</cfoutput>
		</td>
	</tr>
	<tr>
		<td><b>Length of Event</b></td>
		<td>
			<!---
			<input type="text" name="l0" value="" size="3" maxlength="3" disabled>
			<font size="-1">Please round up to full hours</font>
			--->
			<cfoutput>
			<select name="l0" disabled>
			<cfloop from="1" to="4" index="l">
				<option>#l#</option>
			</cfloop>
			</select>
			</cfoutput>
		</td>
	</tr>
	<tr>
		<td><b>Description</b>
		</td>
		<td>
			<textarea cols="60" rows="5" name="d0" disabled></textarea>

		</td>
	</tr>
</table>

<p>
<CFOUTPUT query="events">

<table cellpadding="5" bgcolor="Teal" style="border-color: White ; border: thin solid;">
	<tr>
		<td><b>Title</b></td>
		<td><input type="text" name="title#EventID#" value="#Title#" size="60" maxlength="128">  </td>
	</tr>
	<tr>
		<td><b>Start Date</b></td>
		<td>
			<!---<input type="text" name="sd#EventID#" value="#DateFormat(Starts, "mm/dd/yyyy")#" size="10" maxlength="10" mm=""> --->

			<select name="sd#EventID#" >
				<cfloop list="#DateList#" index="dd">
					<option <cfif DateFormat(DD, "mm/dd/yyyy") EQ DateFormat(Starts, "mm/dd/yyyy")>selected</cfif>>#DD#</option>
				</cfloop>
			</select>

		</td>
	</tr>
	<tr>
		<td><b>Start Time</b></td>
		<td>
			<!---
			<input type="text" name="st#EventID#" value="#TimeFormat(Starts, "HH:mm")#" size="5" maxlength="5" hh="" mm="">&nbsp;
			<font size="-1" color="white">Please use military 24-hour times, such as 5PM = 17:00</font>
			--->

			<select name="st#EventID#" >
				<cfloop list="#TimeList#" Index="tt">
				<option <cfif TimeFormat(Starts, "HH:mm") EQ TimeFormat(tt, "HH:mm")>selected</cfif>>#tt#</option>
				</cfloop>

			</select>

		</td>
	</tr>
	<tr>
		<td><b>Length of Event</b></td>
		<td>
			<CFSET LEOFEV = LENGTHOFEVENT  / 60>
			<!---
			<input type="text" name="l#EventID#" value="#LEOFEV#" size="3" maxlength="3">
			<font size="-1">Please enter as decimals, e.g. 1.5 or 2</font>
			--->


			<select name="l#EventID#" >
			<cfloop from="1" to="4" index="l">
				<option <cfif L EQ LEOFEV>selected</cfif>>#l#</option>
			</cfloop>
			</select>


		</td>
	</tr>
	<tr>
		<td><b>Description</b><br><BR>
				<input type="checkbox" name="del#EventID#" value=""><b>Delete Event</b></td>
		<td>
			<textarea cols="60" rows="5" name="d#EventID#">#Description#</textarea>

		</td>
	</tr>
</table>
<p>
</cfoutput>

<input type="submit" name="op" value="Submit">&nbsp;<input type="Reset">



</center>
</form>
