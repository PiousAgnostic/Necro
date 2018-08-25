<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>Untitled</title>
</head>
<link rel="stylesheet" type="text/css" href="styles/main.css">
<body>
<cfif Not IsDefined("form.fromGMForm")>
	<cflocation url="gmindex.cfm">
</cfif>

<CFIF Not isDefined("SESSION.GMFORM") OR
	  (SESSION.GMFORM NEQ SESSION.SESSIONNUMBER)>
	<cflocation url="gmindex.cfm" addtoken="No">	  
</cfif>

<cfset tempvariable = StructDelete(session,"GMFORM")> 

<cfset SESSION.ADDGMFORM = SESSION.SESSIONNUMBER>


<cfif Not (	(#form.FirstName# GT "") AND
	  		(#form.LastName# GT "") AND
	  		(#form.Password# GT ""))>
	<script language="JavaScript">
		alert("You must fill in First Name, Last Name\n       and Password to proceed");
		history.back();
	</script>
<cfelse>	

	<!--- before anything else, record this client's name --->

<!--- 	<cfset ClientID = #cfid# & "." & #cftoken#>
	<Cfset ClientName = Trim(form.FirstName) & " " & Trim(form.LastName)>
	<CFSET IP=#CGI.REMOTE_ADDR#> 
	
 	<cftry>
		<cfquery datasource="#ds#">
			UPDATE Clients
			Set ClientName = '#ClientName#'
			WHERE ClientID= '#ClientID#'
		</cfquery>
	<cfcatch>
	</cfcatch>
	</cftry> 
	
	 <cftry>
		<cfquery datasource="#ds#">
			UPDATE Clients
			Set ip = '#ip#'
			WHERE ClientID= '#ClientID#' AND
			      ip Is NULL
		</cfquery>
	<cfcatch>
	</cfcatch>
	</cftry> 
 --->

	<!--- Says he's in for the first time.... --->
	<cfif #form.GMid# eq -1>
		<!--- see if he's already in here.... --->
		<CFQUERY name="GM" datasource="#ds#" dbtype="ODBC">
			SELECT * FROM [Game Masters]
			WHERE LastName = '#trim(form.LastName)#' AND
				  FirstName = '#trim(form.Firstname)#' and
				  Email      = '#trim(form.email)#'
		</cfquery>	
	<!--- 	  AND PASSWORD = '#trim (form.password)#'; --->
		<!--- If He's already here, show what he put in originally. --->
		<cfif #GM.RecordCount# NEQ 0>
		
<!--- 			<cfset SESSION.GMINDEX = SESSION.SESSIONNUMBER>
		
			<cfoutput>	
				<form name="smallform" action="gmform.cfm" method="post">
				<input type="hidden" name="FirstName" value="#Form.FirstName#">
				<input type="hidden" name="MiddleName" value="#Form.MiddleName#">
				<input type="hidden" name="LastName" value="#Form.LastName#">
				<input type="hidden" name="Password" value="#Form.Password#">
				<input type="hidden" name="fromIndex" value="Let Me In!">
				<input type="hidden" name="email" value="#form.email#"
				</form>	
				
				<script language="JavaScript">
					alert("Hey! You're already in the system!\nHere's what you originally put in.")
					document.smallform.submit();		
				</script>
			</cfoutput>	 --->
<cfoutput>			
			<h3>
			Our records show that you are already registered with this site with this same Name and Email Address, and have Agreed to the GM Guidelines back on #DateFormat(gm.AFTERDEADLINE, "mmmm d, yyyy")#. Why don't you <a href='gmindex.cfm'>go back</a> and try logging in.
			<p>
			</p>
			
			If you have forgotten your password, contact the <a href="mailto:#SESSION.EMAIL#">Gaming Administrator</a>.</h3>
</cfoutput>			
		<cfelse>
			<!--- If we're here, then it's a new person --->
			<cfquery datasource="#ds#" dbtype="ODBC">
				INSERT INTO [Game Masters]
						(FirstName,
						 MiddleName,
						 LastName,
						 Alias,
						 Address1,
						 Address2,
						 City,
						 State,
						 Zip,
						 Telephone,
						 email,
						 emailVisable,
						 HomePage,
						 Password,
						 Cancelled,
						 AFTERDEADLINE,
						 over18,
						 APPROVED)
				Values   ('#form.FirstName#',
						  '#form.MiddleName#',
						  '#form.LastName#',
						  '#form.Alias#',
						  '#form.Address1#',
						  '#form.Address2#',
						  '#form.City#',
						  '#form.State#',
						  '#form.Zip#',
						  '#form.Telephone#',
						  '#form.email#',
						  #form.emailVisable#,
						  '#form.HomePage#',
						  '#form.Password#',
						  0,
						  #CreateODBCDate(Now())#,
						  '#form.over18#',
						  0);
			</cfquery>
			
			<cftry>
			<CFQUERY datasource="#DS#" dbtype="ODBC">
				INSERT INTO MailingList (email, AddDate)
				Values ('#form.email#', #CreateODBCDate(Now())#);
			</cfquery>
			<cfcatch>
			</cfcatch>
			</cftry>

			<CFQUERY NAME="Last" DATASOURCE="#ds#" DBTYPE="ODBC">
			SELECT 	Max(GMid) as LastGMid
			FROM    [Game Masters]
			</CFQUERY>


			<CFSET SESSION.LOGGEDINGMN = Last.LastGmid>

			<cflocation url="gameintro.cfm"  addtoken="No">
		</cfif>
	<cfelse>
	<!--- It's a returning GM --->
 		<cfquery datasource="#ds#" dbtype="ODBC">
			UPDATE 	 [Game Masters]
			SET		 FirstName  = '#trim(form.FirstName)#',
					 MiddleName = '#form.MiddleName#',
					 LastName   = '#trim(form.LastName)#',
					 Alias      = '#form.Alias#',
					 Address1   = '#form.Address1#',
					 Address2   = '#form.Address2#',
					 City       = '#form.City#',
					 State      = '#form.State#',
					 Zip        = '#form.Zip#',
					 Telephone  = '#form.Telephone#',
					 email      = '#trim(form.email)#',
					 emailVisable= #form.emailVisable#,
					 HomePage    = '#form.HomePage#',
					 Password    = '#form.Password#',
					 over18		 = '#form.over18#'
			WHERE  GMid = #form.GMid#;
		</cfquery> 
		
	<cftry>
	<CFQUERY datasource="#DS#" dbtype="ODBC">
		INSERT INTO MailingList (email, AddDate)
		Values ('#form.email#', #CreateODBCDate(Now())#);	
	</cfquery>
	<cfcatch>
	</cfcatch>
	</cftry>	
	
			<CFSET SESSION.LOGGEDINGMN = form.GMid>

			<cflocation url="gameintro.cfm"  addtoken="No">

	</cfif>
</cfif>

</body>
</html>
