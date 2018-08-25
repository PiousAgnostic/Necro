<h3>Guidebook Download</h3>
<cfflush>

<Cfquery name="q1" datasource="#ds#">
	SELECT TITLE,
		   SESSIONDATE,
		   SESSIONBEGINS,
		   SESSIONENDS,
		   ROOM,
		   SYSTEM
	FROM SCHEDULE
	ORDER BY SESSIONBEGINS
</cfquery>


<cfset filename = expandPath("./Guidebook_Schedule_Template-3.xls")>
<!--- Make a spreadsheet object --->
<cfset s = spreadsheetNew()>
<!--- Add header row --->
<cfset spreadsheetAddRow(s, "Session Title,Date,Time Start,Time End,Room/Location,Schedule Track,Description")>
<!--- format header --->

<!--- Add query --->
<CFOUTPUT QUERY="Q1">
	<CFSET STR = "#REREPLACE(trim(TITLE),",", "", "ALL")#,#DATEFORMAT(SESSIONDATE, "mm/dd/yyyy")#,#TIMEFORMAT(SESSIONBEGINS, "hh:mm tt")#,#TIMEFORMAT(dateadd("n", 1, SESSIONENDS), "hh:mm tt")#,#ROOM#,GAMING,#trim(SYSTEM)#">
<!---#STR#<BR>--->
<cfset spreadsheetAddRow(s, STR)>
</CFOUTPUT>


<!---<cfset spreadsheetAddRows(s, q)> --->
<cfset spreadsheetWrite(s, filename, true)>

Your spreadsheet is ready. You may download it <a href="Guidebook_Schedule_Template-3.xls">here</a>.