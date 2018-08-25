<cfapplication name="New Game Schedule" clientmanagement="Yes" sessionmanagement="Yes" setclientcookies="Yes" sessiontimeout="#CreateTimeSpan(0, 3, 0, 0)#">
<CFSET THISFILE = GETFILEFROMPATH(GETTEMPLATEPATH())>

<cfset SESSION.ProofLocation = #GetDirectoryFromPath(GetBaseTemplatePath())# & "upimages">
<cfset SESSION.ProofURL = "upimages">

<cfset SESSION.ROBSEMAIL = "scorn@rjritchie.com">
<cfset ds = "Necrosql">
<cfset SESSION.SMTPServer = "mail.rjritchie.com">


<CFIF Not IsDefined("SESSION.CONVENTIONNAME")>
	<Cfquery name="lavid" datasource="#ds#" dbtype="ODBC">
	SELECT TOP 1 HoursForFree,
				 DropDeadDate,
				 ConventionDate,
				 ConventionName,
				 MaxNumRoundTables,
				 MaxNumSquareTables,
				 email
	FROM Admin;
	</cfquery>

	<cfset SESSION.CONVENTIONNAME = #lavid.ConventionName#>
	<cfset SESSION.EMAIL = #lavid.email#>
</CFIF>


<cfif isDefined("SESSION.LoggedInGmn")>
	<cfif Not IsDefined("SESSION.LOGGEDINNAME")>
		<CFQUERY name="lavid" datasource="#ds#">
			select FirstName, LastName, Alias
			from [Game Masters]
			where GMid = #SESSION.LOGGEDINGMN#
		</CFQUERY>

		<cfif lavid.Alias GT "">
			<CFSET SESSION.LoggedInName = LAVID.Alias>
		<cfelse>
			<cfset SESSION.LoggedInName = LAVID.FirstName & " " & LAVID.LastName>
		</cfif>
	</cfif>
</cfif>


<cfset SESSION.TWITTERNAME = "NecroGaming">

<CFIF NOT IsDefined("Session.SessionNumber")>
	<CFSET SESSION.SESSIONNUMBER = #CreateUUID()#>
</cfif>




<!---
<cfoutput>
#cfid#.#cftoken#
</cfoutput> --->