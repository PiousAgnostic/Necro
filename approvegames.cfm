<cfif Not IsDefined("form.fromNeedApproval")>
	<cflocation url="gmindex.cfm" addtoken="No">
</cfif>

<cfparam name="ImageHere" default="">
<CFPARAM NAME="form.tablelocked" default="unlocked">
<cfparam name="form.AssignedTables" default=""	>
<cfparam name="form.selectedsession" default="0">
<cfparam name="TableCounts" default="0">
<cfset TableStarts = "">
<cfset TableCounts = "">


<cfif ListLen(form.AssignedTables) EQ 1>
	<cfset TableStarts = form.AssignedTables>
	<cfset TableCounts = 1>
<cfelseif ListLen(form.AssignedTables) GT 1>
	<cfset counter = 0>
	<cfset TableStarts = ListGetAt("#form.ASSIGNEDTABLES#", 1)>

	<cfset priorTable = TableStarts-1>
	<cfset gap = false>
	<cfset gapcounter = 0>
	<cfloop index="I" list="#form.ASSIGNEDTABLES#">
		<cfset gapcounter = gapcounter + 1>
		<cfif I NEQ (priorTable + 1)>
			<cfset gap = true>
			<cfbreak>
		</cfif>
		<cfset priorTable = i>

	</cfloop>

	<cfif gap eq false>
		<cfset TableCounts = ListLen(form.AssignedTables)>
	<cfelse>
		<cfset TableStarts = ListAppend(TableStarts, ListGetAt(form.AssignedTables, gapcounter))>
		<cfset TableCounts = ListAppend(TableCounts, gapcounter - 1)>
		<cfset TableCounts = ListAppend(TableCounts, ListLen(form.assignedTables) - gapcounter + 1)>
	</cfif>


</cfif>


<!--- <cfdump var="#form#">
 <cfdump var="#TableStarts#"><br>
 <cfdump var="#TableCounts#">
<cfabort>
		--->

<cfif #form.Image# GT "">
	<cffile action="UPLOAD"
        filefield="Image"
        destination="#SESSION.ProofLocation#"
        nameconflict="OVERWRITE">
	<cfset ImageHere = #file.ServerFile#>

	<cfset ext = Right(ImageHere, Len(ImageHere) - Find(".",ImageHere))>

	<cfset newFileName = #form.GMid# & "-" & #form.GameID# >

<!--- 	<cftry> --->
	<cfdirectory action="LIST"
             directory="#session.ProofLocation#"
             name="imgqry"
             filter="#newFileName#.*">

<!--- <cfoutput>	There are #imgqry.Recordcount# images that look like 		"#session.ProofLocation#\#newFileName#.*"	</cfoutput>  --->

	<cfoutput query="imgqry">
		<cffile action="DELETE"
	        file="#session.ProofLocation#\#name#">
	</cfoutput>

<!--- 	<cffile action="DELETE"
        file="#session.ProofLocation#\#newFileName#.*"> --->
<!--- 	<cfcatch>
	</cfcatch>
	</cftry> --->

	<cffile action="RENAME"
        source="#session.ProofLocation#\#ImageHere#"
        destination="#newFileName#.#ext#">


	<CFSET ImageHere = newFileName& "." & ext>
<!--- 				ImageApproved = 0,
<cfoutput>				Image = '#ImageHere#', newFileName = #newFileName#</cfoutput> --->
</cfif>

<cfif form.fromNeedApproval eq "Save">
	<cfset LApproved = Evaluate("form.Approved" & #GameID#)>
	<cfif IsDefined("form.ImageApproved" & #GameID#)>
		<cfset LImageApproved = Evaluate("form.ImageApproved" & #GameID#)>
	<cfelse>
		<cfset LImageApproved = 1>
	</cfif>
<!---	<cfset LSession = Evaluate("form.Session" & #GameID#)>--->

	<cfif LImageApproved eq 99>
		<cfset LImageApproved = 1>
		<cfset DeleteImage = TRUE>
	<CFELSE>
		<CFSET DELETEIMAGE = FALSE>
	</cfif>


	<cfquery datasource="#ds#" dbtype="ODBC">
		UPDATE Games
		Set Approved = #LApproved#,
		    ImageApproved = #LImageApproved#,
			<CFIF DELETEIMAGE>
				IMAGE = '',
			</cfif>
			Session = #Form.SelectedSession#,
			NumTables = #Form.NumTables#,
			NumPlayers = #Form.NumPlayers#,
			TableType = #form.TableType#,
			GameType = #form.GameType#,
			Description = '#form.NewDescription#',
			System = '#form.system#',
			LengthOfGame = #form.LengthOfGame#,
			<cfif ImageHere GT "">
				Image = '#ImageHere#',
			</cfif>
			Room = '#form.room#',
			HideOnSchedule = #form.HideItem#,
			NumberApprovals = NumberApprovals + #LApproved#
			,Tables = '#TableStarts#'
			,TableCounts = '#TableCounts#'
			,TableLocked = <cfif form.TableLocked EQ "locked">1<cfelse>0</cfif>
			,Title = '#Title#'
		WHERE GameID = #GameID#
	</cfquery>

<!---


--->

	 <!---post game notice to Twitter --->


<!---	<Cfquery name="theGame" datasource="#ds#">
		select * from Games
		where GameID = #GameID#
	</Cfquery>
	<cftry>
	<cfif theGame.NumberApprovals EQ 1 AND theGame.HideOnSchedule eq 0>
		<cfset TwitterStatus = "New Game Posted! " & theGame.Title & " / " & theGame.System & " http://tinyurl.com/l9hyz4 ##necrocon">

		<cfset TwitterStatus = Left(TwitterStatus, 140)>
		<cfset twitterObj = createObject('component', 'twitterCFC').init('NecroStonechat','yell0wc@p') />
		<cfset twitterObj.postToTwitter("#TwitterStatus#") />
		<cfset twitterObj = createObject('component', 'twitterCFC').init('gaming@necrogaming.org','n3cr0n0m1c0n') />
		<cfset twitterObj.postToTwitter("#TwitterStatus#") />
	</cfif>
	<cfcatch>
		<DIV>FAILURE TRYING TO TWEET THIS, SORRY!</DIV>
	</cfcatch>
	</cftry>--->

</cfif>

<cfif form.fromNeedApproval eq "Delete Game">
	<cfquery datasource="#ds#" dbtype="ODBC">
		DELETE FROM Games
		WHERE GameID = #GameID#
	</cfquery>
</cfif>

<html>
<head>
<script language="JavaScript">
	function doIt()
	{
		top.location="adminindex.cfm";
		//top.adminmain.location="schedule.cfm";
	}
</script>
</head>
<link rel="stylesheet" type="text/css" href="styles/main.css">
<body onLoad="doIt()" >

<!--- <CF_GetVariables
	 	SCOPES="ALL"
		DUMP="Yes"
		DUMPTITLE="Displaying Form Variables"> --->

</body>
</html>
<!--- <cflocation url="home.cfm" addtoken="No"> --->