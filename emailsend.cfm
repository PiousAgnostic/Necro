

<html>
<head>
	<title>Untitled</title>

<!---<cfquery name="gmlist" datasource="#ds#" dbtype="ODBC">
SELECT [Game Masters].email, [Game Masters].LastName, [Game Masters].FirstName
FROM [Game Masters] INNER JOIN Games ON [Game Masters].GMId = Games.GMid
GROUP BY [Game Masters].email, [Game Masters].cancelled, Games.Approved, Games.Cancelled, [Game Masters].LastName, [Game Masters].FirstName
HAVING ((([Game Masters].[email])<>'') AND (([Game Masters].[cancelled])=0) AND ((Games.Approved)=True) AND ((Games.Cancelled)=False) AND ((Count(Games.GameId))>0))
ORDER BY [Game Masters].LastName, [Game Masters].FirstName;
</cfquery>	

 <cfquery name="vollist" datasource="#ds#" dbtype="ODBC">
SELECT Volunteers.VoleMail, Volunteers.LastName, Volunteers.FirstName
FROM Volunteers INNER JOIN VolunteerSessions ON Volunteers.VolId = VolunteerSessions.VolId
GROUP BY Volunteers.VoleMail, Volunteers.LastName, Volunteers.FirstName
HAVING (((Count(VolunteerSessions.SessionId))>0))
ORDER BY Volunteers.LastName, Volunteers.FirstName;
 </cfquery>

<CFQUERY NAME="mailinglist" datasource="#ds#" dbtype="ODBC">
	SELECT 	EMAIL
	FROM    MailingList
</cfquery>

<cfset sentemails = 0>--->

<!---<Cftry>
		<cfquery datasource="#ds#" dbtype="ODBC">
			DROP TABLE outgoingemails;
		</cfquery>
<cfcatch></cfcatch>
</Cftry>--->
	
<!---<Cfquery datasource="#ds#" dbtype="ODBC">
	CREATE TABLE outgoingemails
	(
		email	varchar(128) PRIMARY KEY
	)
</cfquery>--->

<H1>THIS IS CURRENTLY BORKED-UP SO DON'T USE IT.</H1>

<Cfdump var="#form#">

<cfoutput>MSG Len: #Len(form.msg)#<p></p></cfoutput>
<cfabort>
<cfif IsDefined("form.mail")>
	<cfif #form.mail# eq "Send">
		<cfif isDefined("form.gms")>
			<cfloop query="gmlist">
				<cftry>
				<CFQUERY datasource="#DS#" dbtype="ODBC">
					INSERT INTO outgoingemails(email)
					values ('#email#');
				</cfquery>
				<cfcatch>
				</cfcatch>
				</cftry>
			</cfloop>
		</cfif>
		<cfif isDefined("form.vols")>
 			<cfloop query="vollist">
				<cftry>
				<CFQUERY datasource="#DS#" dbtype="ODBC">
					INSERT INTO outgoingemails(email)
					values ('#volemail#');
				</cfquery>
				<cfcatch>
				</cfcatch>
				</cftry>
			</cfloop>
		</cfif>
		
		<cfif isDefined("form.list")>
			<cfloop query="mailinglist">
				<cftry>
				<CFQUERY datasource="#DS#" dbtype="ODBC">
					INSERT INTO outgoingemails(email)
					values ('#email#');
				</cfquery>
				<cfcatch>
				</cfcatch>
				</cftry>

			</cfloop>		
		</cfif>
		
		<cfquery name="outgoingemails" datasource="#ds#" dbtype="ODBC">
			SELECT distinct email FROM outgoingemails;
		</cfquery>
		<cfset sentemails = #outgoingemails.recordcount#>
		
<Cfdump var="#outgoingemails#"	>
		
		<cfoutput query="outgoingemails" group="email">
			<cftry>
<!---			<cfmail to="#email#" from="#form.from#" subject="#form.subject#"  port="25" server="#SESSION.SMTPServer#" username="mr@rjritchie.com" password="belladonna">#form.msg#</cfmail>--->	
to="#email#" from="#form.from#" subject="#form.subject#"  port="25" server="#SESSION.SMTPServer#" username="mr@rjritchie.com" password="belladonna">#form.msg#
<hr>

			<cfcatch></cfcatch>
			</cftry>		
		</cfoutput>
		
<!---		<cfquery datasource="#ds#" dbtype="ODBC">
			DROP TABLE outgoingemails;
		</cfquery>--->
	</cfif>
</cfif>	
	

	
</head>
<link rel="stylesheet" type="text/css" href="styles/main.css">
<body style="margin-left: 25px;">
<h1>Blanket eMail Sent!</h1>

<b>
<cfoutput>
	<b>You sent #sentemails# email(s).</b>

<p>
<b>Text of message follows:</b>
<p><p>
<table width="80%">
<tr>
	<td width="100%" bgcolor="white">
		<pre style="color: Black; font-variant: normal; font-size: larger;">#form.msg#</pre>
	</td>
</tr>
</table>
</cfoutput>
</body>
</html>
