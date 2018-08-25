

<cfquery datasource="#ds#">
	Delete from Larps
	WHERE LARPID = #FORM.LARPID#
</cfquery>

