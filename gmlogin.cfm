<cfdump var="#form#">
<cfset tempvariable = StructDelete(session,"LOGGEDINGMN")>

<CFQUERY name="GM" datasource="#ds#" dbtype="ODBC">
	SELECT * FROM [Game Masters]
	WHERE Email = '#trim(form.Email)#' AND
		  Password = '#trim(form.password)#'
</cfquery>

<cfdump var="#GM#">

<cfif GM.RECORDCOUNT EQ 0>
	<cflocation addtoken="no" url="gmindex.cfm?nologin=notfound">
</CFIF>

<Cfif GM.Cancelled EQ 1>
	<cflocation addtoken="no" url="gmindex.cfm?nologin=cancelled">
</cfif>

<CFSET SESSION.LOGGEDINGMN = GM.GMID>
<cflocation url="gameintro.cfm"  addtoken="No">
