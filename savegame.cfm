<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>Untitled</title>


</head>
<link rel="stylesheet" type="text/css" href="styles/main.css">
<body style="margin-left: 25px;"  <!--- onLoad="onLoadPage()" ---> >

<cfif (#form.Title# EQ "") OR (#form.System# EQ "")>
	<cflocation url="gameintro.cfm?GM=#form.GMid#">
</cfif>

<cfparam name="ImageHere" default="">

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



<!--- Adding New Game --->
<cfif #form.GameID# eq -1>
	<cfquery datasource="#ds#" dbtype="ODBC">
		INSERT INTO Games
					(GMid,
					 Cancelled,
					 Approved,
					 Title,
					 Description,
					 System,
					 Link,
					 Request1,
					 Request2,
					 Request3,
					 Session,
					 NumPlayers,
					 AdultOnly,
					 RoleplayingStressed,
					 ExperienceLevel,
					 GameType,
					 Image,
					 ImageApproved,
					 TableType,
					 LengthOfGame,
					 NumTables,
					 AFTERDEADLINE,
					 ROOM,
					 complexity,
					 ExtraTimeNeeded)
		Values		(#form.GMid#,
					 <cfif IsDefined("form.Cancelled")>1<cfelse>0</cfif>,
					 #form.Approved#,
					 '#form.Title#',
					 '#form.Desription#',
					 '#form.system#',
					 '#form.Link#',
					 #form.Request1#,
					 #form.Request2#,
					 #form.Request3#,
					 #form.Session#,
					 #form.NumPlayers#,
					 <cfif IsDefined("form.AdultOnly")>1<cfelse>0</cfif>,
					 <cfif IsDefined("form.RoleplayingStressed")>1<cfelse>0</cfif>,
					 #form.ExperienceLevels#,
					 #form.GameType#,
					 '#ImageHere#',
					 0,
					 #form.TableType#,
					 #form.LengthOfGame#,
					 #form.NumTables#,
					 #CreateODBCDate(Now())#,
					 '#FORM.ROOM#',
					 #form.Complexity#,
					 #form.ExtraTimeNeeded#);


	</cfquery>




	<Cfquery name="GameJustEntered" datasource="#ds#">
		SELECT Max(Games.GameId) AS MaxOfGameId
		FROM Games
		WHERE (((Games.GMid)=#form.GMid#));
	</cfquery>

	<cfset localGameID = GameJustEntered.MaxOfGameId>

	<cfif #form.Image# GT "">
		<!--- adjust name of image... --->

		<cfset newFileName = #form.GMid# & "-" & #GameJustEntered.MaxOfGameId# & "." & ext>

		<cffile action="RENAME"
	        source="#session.ProofLocation#\#ImageHere#"
	        destination="#newFileName#">


		<cfquery datasource="#ds#">
			Update Games
			Set Image = '#newFileName#'
			WHERE   GameID = #GameJustEntered.MaxOfGameId#;
		</cfquery>
		<cfset ImageHere = newfileName>

	</cfif>
	<cfquery name="newGame" datasource="#ds#" dbtype="ODBC">
	SELECT [Game Masters].*
	FROM [Game Masters]
	WHERE ((([Game Masters].GMId)=#form.GMid#));
	</cfquery>


<!---<cfif cgi.SERVER_NAME neq 'localhost'>--->
	<cfinclude template="savegame_email.cfm">
<!---</cfif>--->




<cfelse>
	<cfquery name="originalGame" datasource="#ds#" dbtype="ODBC">
		SELECT Games.Cancelled, [Game Masters].FirstName, [Game Masters].LastName, Games.Title, Games.GameId, 	Sessions.SessionBegins
		FROM (Games INNER JOIN [Game Masters] ON Games.GMid = [Game Masters].GMId) LEFT JOIN Sessions ON Games.Session = Sessions.SessionID
		WHERE (((Games.GameId)=#form.GameId#))
	</cfquery>

	<!--- Updating Game	 --->
	<cfquery datasource="#ds#" dbtype="ODBC">
		UPDATE  Games
		SET     Approved = 0,
				Title = '#form.Title#',
				Description = '#form.Desription#',
				System = '#form.system#',
				Link = '#form.Link#',
				Request1 = #form.Request1#,
				Request2 = #form.Request2#,
				Request3 = #form.Request3#,
				Session = #form.Session#,
				NumPlayers = #form.NumPlayers#,
				AdultOnly = <cfif IsDefined("form.AdultOnly")>1<cfelse>0</cfif>,
				RoleplayingStressed = <cfif IsDefined("form.RoleplayingStressed")>1<cfelse>0</cfif>,
				Cancelled = <cfif IsDefined("form.Cancelled")>1<cfelse>0</cfif>,
				ExperienceLevel = #form.ExperienceLevels#,
				GameType = #form.GameType#,
				TableType = #Form.TableType#,
				LengthOfGame = #Form.LengthOfGame#,
				NumTables    = #Form.NumTables#,
				Room		 = '#Form.Room#',
				Complexity   = #form.complexity#,
				ExtraTimeNeeded = #form.ExtraTimeNeeded#
		WHERE   GameID = #form.GameId#;
	</cfquery>

	<cfset localGameID = form.GameId>


	<cfif #form.Image# GT "">
		<cfquery datasource="#ds#" dbtype="ODBC">
			UPDATE  Games
			SET    	ImageApproved = 0,
					Image = '#ImageHere#'
			WHERE   GameID = #form.GameId#;
		</cfquery>
	</cfif>


	<cfif IsDefined("form.Cancelled") and (originalGame.Cancelled NEQ 1)>

	<Cfsavecontent variable="cancellationEmail">
<cfoutput query="originalGame">
A Game Was Cancelled by #FirstName# #LastName#!
<p></p>
<strong>#form.Title# </strong>
<p></p>
<!---The cancellation occurred at #TimeFormat(dateadd("h", -4, Now()), "h:mm tt")# on #DateFormat(Now(), "dddd, mmmm dd")#
	<p></p>--->
<Cfif IsDate(SessionBegins)>
The game was scheduled for #TimeFormat(SessionBegins, "h:mm tt")# on #DateFormat(SessionBegins, "dddd, mmmm dd")#
<Cfelse>
The game was not yet scheduled.
</Cfif>
</cfoutput>
		</Cfsavecontent>

 	<cfmail to="#SESSION.EMAIL#"
        from="#SESSION.ROBSEMAIL#"
        subject="A Game Was Cancelled for #SESSION.CONVENTIONNAME#" type="html"
		query="originalGame"
		 server="#SESSION.SMTPServer#" port="25" username="mr@rjritchie.com" password="belladonna"
       >#cancellationEmail#</cfmail>
	</cfif>
</cfif>


<cfset SESSION.ADDGMFORM = SESSION.SESSIONNUMBER>



   <cflocation url="gameintro.cfm?GM=#form.GMid#" addtoken="no">

<cfif isDefined("ImageHere")>
<cfoutput>
<img name="newimg"  style="visibility:hidden"  name="gameimage" src="#Session.ProofURL#/#ImageHere#">
</cfoutput>
</cfif>




<!--- <cfoutput>
<form name="smallform" method="post" action="gameform.cfm">
<input type="hidden" name="GameId" value="#localGameID#">
<input type="hidden" name="GMId" value="#form.GMid#">
</form>
</cfoutput>
 --->
</body>

<cfoutput>
<script language="javascript">
	function onLoadPage()
	{
		//document.smallform.submit();
		w = document.images.newimg.width
		h = document.images.newimg.height

		if ((w > 500) || (h > 225))
		{
			alert("The image you have uploaded is too large.\nPlease resize, or select an image smaller than 500 x 225 pixels.")
			window.location.href="savegame_removeimage.cfm?GMid=#form.GMid#&gameID=#localGameID#"
		}



		else
			window.location.href="gameintro.cfm?GM=#form.GMid#"
	}
</script>
</cfoutput>

</html>
