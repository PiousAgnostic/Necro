<cfif IsDefined("form.fromGMForm")>
	<cfif form.fromGMForm EQ "Cancel">
		<cfif #form.delete# EQ "Yes">
			<cfquery datasource="#ds#" dbtype="odbc">
				UPDATE [Game Masters]
				SET Cancelled = 1
				WHERE GMId =#FORM.GMID#;
			</cfquery>

			<cfquery datasource="#ds#" dbtype="odbc">
				UPDATE Games
				SET Cancelled = 1,
					Approved  = 0,
					ImageApproved = 0
				WHERE GMId=#FORM.GMID#;
			</cfquery>

			<cfquery datasource="#ds#" dbtype="ODBC">
				DELETE FROM VolunteerSessions
				WHERE VolunteerSessions.VolId In
						(SELECT Volunteers.VolId
						FROM Volunteers
						where GMid = #FORM.GMID#);
			</cfquery>

		</cfif>

	</cfif>

	<cfif form.fromGMForm EQ "Blacklist">
			<cfquery datasource="#ds#" dbtype="odbc">
				UPDATE [Game Masters]
				SET  BlackListedReason = '#FORM.BLACKLISTEDREASON#'
				WHERE GMId =#FORM.GMID#;
			</cfquery>
	</cfif>

	<cfif form.fromGMForm EQ "Reinstate">
		<cfif #form.reinstate# EQ "Yes">
			<cfquery datasource="#ds#" dbtype="odbc">
				UPDATE [Game Masters]
				SET Cancelled = 0,
					Approved = 0,
					BlackListedReason = ''
				WHERE GMId =#FORM.GMID#;
			</cfquery>

			<cfquery datasource="#ds#" dbtype="odbc">
				UPDATE Games
				SET Cancelled = 0,
					Approved  = 0,
					ImageApproved = 0
				WHERE GMId=#FORM.GMID#;
			</cfquery>

<!--- 			<cflocation url="needapproval.cfm"> --->

		</cfif>

	</cfif>

	<cfif form.fromGMForm EQ "Extend">
		<cfif IsDate(form.ExtendedDeadLine)>
			<cfquery datasource="#ds#" dbtype="odbc">
				UPDATE [Game Masters]
				SET ExtendedDeadline = #CreateODBCDate(form.ExtendedDeadline)#
				WHERE GMId =#FORM.GMID#;
			</cfquery>
		<cfelse>
			<cfquery datasource="#ds#" dbtype="odbc">
				UPDATE [Game Masters]
				SET ExtendedDeadline = NULL
				WHERE GMId =#FORM.GMID#;
			</cfquery>
		</cfif>
	</CFIF>

	<cfif form.fromGMForm EQ "Approve">
		<cfquery datasource="#ds#">
			UPDATE [GAME MASTERS]
			SET APPROVED = 1
			WHERE GMId = #form.gmid#
		</cfquery>

	</cfif>

	<cfif form.fromGMForm EQ "Delete">
		<cfquery datasource="#ds#">
			DELETE [GAME MASTERS]
			WHERE GMId = #form.gmid#
		</cfquery>

	</cfif>

</cfif>



	<cfif form.fromGMForm EQ "Reinstate">

</cfif>

<html>
<head>
<script language="JavaScript">
	function doIt()
	{

		top.location.href="adminindex.cfm";
	}
</script>
</head>
<link rel="stylesheet" type="text/css" href="styles/main.css">
<body onLoad="doIt()" >



</body>
</html>

