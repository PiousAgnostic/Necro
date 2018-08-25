<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>Administration</title>

<CFIF Not IsDefined("Session.Administrator")>
	<cflocation url="admin.cfm" addtoken="No">
</cfif>	
	
<cfset flag = 0>

<cfif IsDefined("form.fromchgpassword")>
	<cfif #form.new1# eq #form.new2#>

		<CFQUERY datasource="#DS#" dbtype="ODBC">
			UPDATE ADMIN
			SET PASSWORD = '#form.new1#';
		</cfquery>
		<cfset flag = 1>
		
		<cfquery name="newPswd" datasource="#ds#" dbtype="ODBC">
			SELECT TOP 1 PASSWORD
			FROM ADMIN;
		</cfquery>		
 <cftry>		
		<cfmail to="#SESSION.ROBSEMAIL#"
	        from="#SESSION.ROBSEMAIL#"
	        subject="Password Changed"
			query="newPswd"
			server="#SESSION.SMTPServer#"
	
	       >Password changed to "#PASSWORD#"</cfmail>			
<cfcatch>
</cfcatch>
</cftry>
		   
	<cfelse>
		<cfset flag = 2>
	</cfif>
</cfif>

<script language="JavaScript">
	function checkSubmit()
	{
	
		if ((document.gform.new1.value != "") &&
		   (document.gform.new2.value != ""))
		   	document.gform.fromchgpassword.disabled = false;

		else
			document.gform.fromchgpassword.disabled = true;

	}
</script>

</head>

<link rel="stylesheet" type="text/css" href="styles/main.css">
<body style="margin-left: 25px;">
<h1>Change Administrative Password</h1>
<cfif flag eq 0>
From this screen you can change the access password to the Administrative system. Please observe
normal security measures to ensure that your passwords cannot be easily guessed.
</cfif>

<cfif flag eq 1>
Password has been changed.
</cfif>

<cfif flag eq 2>
Password Fields were different, so password was not changed
</cfif>
<p>
<form action="chgpassword.cfm" method="post" name="gform">
<table>
	<tr>
		<td>
			<b>New Password</b>
		</td>
		<td>
			<input type="password" name="new1" onChange="checkSubmit()">
		</td>
	</tr>
	<tr>
		<td>
			<b>Retype Password</b>
		</td>
		<td>
			<input type="password" name="new2" onChange="checkSubmit()">
		</td>
	</tr>	
	<tr>
		<td>&nbsp;
			
		</td>
		<td>
			<input type="submit" disabled value="Change" name="fromchgpassword">
		</td>
	</tr>		
</table>
</form>
<p>
<p>
<font size="-1">Problems?<cfoutput> <a href="mailto:#SESSION.ROBSEMAIL#"></cfoutput>Email the Site Admin</a>.</font>
</body>
</html>
