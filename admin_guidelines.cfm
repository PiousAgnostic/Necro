<CFIF Not IsDefined("Session.Administrator")>
	<cflocation url="admin.cfm" addtoken="No">
</cfif>	

<cfparam default="SAVE" name="DISPLAY">


<script type="text/javascript" src="ckeditor/ckeditor.js"></script>

	
<link rel="stylesheet" type="text/css" href="styles/main.css">


<CFIF DISPLAY EQ "SAVE" AND
	  ISDEFINED("form.guidelines")>

	<cfquery datasource="#ds#">
		UPDATE ADMIN
		SET GMGuidelines = '#form.guidelines#'
		</cfquery>


</CFIF>


<CFQUERY name="Avid" datasource="#ds#">
	select top 1 * from Admin
</CFQUERY>


<h2>Game Guidelines</h2>

<CFIF DISPLAY EQ "SAVE">
	<div class="guidelines">
	<cfoutput>#avid.GMGuidelines#</cfoutput>
	<div>
	<FORM method="post">
		<INPUT TYPE="submit" name="DISPLAY" value="EDIT">
	</FORM>
<CFELSE>
	<div id="guidelinesClass">
		
	<FORM method="post">
	
		<textarea cols="70"
		  rows="60"
		  id="guidelines"
		  name="guidelines"><cfoutput>#avid.GMGuidelines#</cfoutput></textarea>		
	
		<INPUT TYPE="submit" name="DISPLAY" value="SAVE">
	</FORM>
	</div>

</CFIF>

<script type="text/javascript">
	CKEDITOR.replace( 'guidelines', 
	{
		customConfig : 'ckeditor/config.js',
		toolbar : 'Full',
		height:550,
		resize_enabled:true,
		width:600
	});
</script>	