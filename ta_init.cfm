<CFIF Not IsDefined("Session.Administrator")>
	<cflocation url="admin.cfm" addtoken="No">
</cfif>

<cfif showstuff>
	<h1>ta_init</h1>
</cfif>


<CFSETTING ENABLECFOUTPUTONLY="YES">
<CFTRY>
<cfquery datasource="#ds#">
	DROP TABLE TableAssignment
</cfquery>
<CFCATCH>
</CFCATCH>
</CFTRY>

<cfquery datasource="#ds#">
CREATE TABLE [TableAssignment]
(   [idnumber] int identity(1,1),
   [room] VARCHAR(50),
   [Table] INTEGER,
   [TIMESLOT] DATETIME,
   [USEDBY] INTEGER,
   [GM] VARCHAR(150),
   [PIECE] INTEGER,
   [TABLES] INTEGER

)

</cfquery>



<!--- 		 room Varchar(20),
		 [Table] Integer DEFAULT 0,
		 TIMESLOT DATETIME,
		 USEDBY INTEGER DEFAULT 0) --->

<!--- <cfset IDNUMBER = 0>	 --->

<!--- <cfloop index="sh" from="1" to="4">

	<cfif sh eq 1>
		<cfset ShapeName = 'Round'>
		<cfset MaxNumTables = #avid.MaxNumRoundTables#>
		<cfset FirstRoomNumber = 1>
		<cfset RoomName = 'RPG'>
<!--- 		<cfset Having = "(Shape = 'Round')"> --->
	</cfif>

	<cfif sh eq 2>
		<cfset ShapeName = 'Square'>
		<cfset MaxNumTables = 12>
		<cfset FirstRoomNumber = 1>
		<cfset RoomName = 'CCG1'>
<!--- 		<cfset Having = "(Shape = 'Square') AND (GameTypeId in (1,2))"> --->
	</cfif>

	<cfif sh eq 3>
		<cfset ShapeName = 'Square'>
		<cfset MaxNumTables = 8>
		<cfset FirstRoomNumber = 13>
		<cfset RoomName = 'CCG2'>
<!--- 		<cfset Having = "(Shape = 'Square') AND (GameTypeId in (3,4,6))"> --->
	</cfif>

	<cfif sh eq 4>
		<cfset ShapeName = 'Square'>
		<cfset MaxNumTables = 7>
		<cfset FirstRoomNumber = 21>
		<cfset RoomName = 'Computer'>
<!--- 		<cfset Having = "(Shape = 'Square') AND (GameTypeId in (7,8))"> --->
	</cfif> --->

<cfloop query="roomstables"	>


	<cfset ShapeName = #shape#>
	<cfset MaxNumTables = #count#>
	<cfset FirstRoomNumber = #FirstRoomNumber#>
	<cfset mroomname = #roomname#>


	<cfoutput query="clock">
		<cfloop index="tbl" from="1" to="#MaxNumTables#">
			<cfset tblnum = FirstRoomNUmber + tbl - 1>
			<cfset numHrs = DateDiff("h", MinOFSessionBegins, MaxOfSessionEnds)+LastOfMaxLengthGame-1>
			<cfset oneHr  = CreateTimeSpan(0,1,0,0)>
			<cfset thisHour = MinOFSessionBegins>



			<cfloop index="x" from="1" to="#numHrs#">
			<!--- 	<CFSET IDNUMBER = IDNUMBER + 1> --->
				<CFQUERY datasource="#DS#">
				INSERT INTO TableAssignment ( Room, [Table], TimeSlot,usedby, GM)
				VALUES ( '#mroomname#', #TBLNUM#, #CreateODBCDateTime(thisHour)#,0, '')
				</cfquery>


				<cfset thisHour = thisHour + oneHr>
			</CFLOOP>
		</cfloop>
	</cfoutput>

</cfloop>

<!---<cfquery name="theTableAssignment" datasource="#ds#">
select * from TableAssignment
</cfquery>
<cfsetting requestTimeOut = "6000">
<cfdump var="#theTableAssignment#">

<cfabort>--->

<CFSETTING ENABLECFOUTPUTONLY="No">

