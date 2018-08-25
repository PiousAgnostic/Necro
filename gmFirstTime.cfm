
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!--
Design by Free CSS Templates
http://www.freecsstemplates.org
Released for free under a Creative Commons Attribution 2.5 License

Name       : StylePrecision
Description: A two-column, fixed-width design with dark color scheme.
Version    : 1.0
Released   : 20130720

-->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<title><cfoutput>#SESSION.CONVENTIONNAME#</cfoutput> Gaming Site</title>
<link href='http://fonts.googleapis.com/css?family=Open+Sans:400,300,600,700|Open+Sans+Condensed:300,700' rel='stylesheet' type='text/css'>
<link href="styles/style.css" rel="stylesheet" type="text/css" media="screen" />
<link href="styles/fonts.css" rel="stylesheet" type="text/css" media="all" />
<!---<script type="text/javascript" src="jquery-1.7.1.min.js"></script>--->
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.0/jquery.min.js"></script>
<script src="assets/javascripts/socialProfiles.min.js"></script>
<script type="text/javascript" src="jquery.slidertron-1.1.js"></script>



<CFQUERY name="avid" datasource="#ds#" dbtype="ODBC" cachedWithin="#CreateTimeSpan(0,0,10,0)#">
SELECT TOP 1 CONVENTIONDATE, DropDeadDate, ConventionName, ConventionEnds, Announcement, ParticipationText, LarpText, HOURSFORFREE, lastgametime
	FROM ADMIN
</CFQUERY>

<script language="javascript">

	function checkEmail() {
	if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,4})+$/.test(document.gmform.email.value)){
	return (true)
	}
	alert("Invalid E-mail Address! Please re-enter.")
	return (false)
	}


</script>


<CFIF Not isDefined("form.fromIndex") AND Not isDefined("form.fromGMFirstTimeForm") >
	<cflocation url="gmindex.cfm" addtoken="No">
</cfif>

<cfset tempvariable = StructDelete(session,"GMINDEX")>

<cfset SESSION.GMFORM = SESSION.SESSIONNUMBER>

<cfparam name="Lemail" default="">

</head>
<body>
<div id="wrapper">
	<div id="page" class="container">
		<div id="header" class="container">
			<div id="logo">
				<h1><a href="#"><cfoutput>#SESSION.CONVENTIONNAME#</cfoutput></a></h1>
			</div>

<cfinclude template="menu.cfm">


		</div>
		<div id="banner">
			<div id="slider">
				<div class="viewer">
					<div class="reel">
						<div class="slide"> <img src="images/2013-1.jpg" alt="" /> </div>
						<div class="slide"> <img src="images/2013-3.jpg" alt="" /> </div>
						<div class="slide"> <img src="images/2013-4.jpg" alt="" /> </div>
						<div class="slide"> <img src="images/2013-2.jpg" alt="" /> </div>
					</div>
				</div>
			</div>
			<script type="text/javascript">
				$('#slider').slidertron({
					viewerSelector: '.viewer',
					reelSelector: '.viewer .reel',
					slidesSelector: '.viewer .reel .slide',
					advanceDelay: 4000,
					speed: 'slow'
				});
			</script>
		</div>



		<div id="content">

 			<div class="title">
				<h2>Creating a New Account</h2>
				<span class="byline">Please enter your email below to participate in<cfoutput> #Avid.ConventionName# </cfoutput>Gaming!</span>
			</div>
			<p>
				<div class="announcement">

<cfif isDefined("form.fromGMFirstTimeForm")>



		<cfquery name="findGM" datasource="#ds#">
			SELECT GMID, EMAIL, isnull(BlacklistedReason, '') as BlackListedReason, Approved, Cancelled
			FROM [Game Masters]
			WHERE EMAIL = <cfqueryparam value = "#FORM.EMAIL#" CFSQLType = "CF_SQL_VARCHAR">
		</cfquery>


		<CFQUERY NAME="approvedGM" dbtype="query">
			SELECT * FROM findGM
			Where Approved = 1 and BlacklistedReason = ''
			   or (APPROVED = 0 AND CANCELLED = 0)
		</cfquery>

		<cfquery name="blacklistedGM" dbtype="query">
			SELECT * FROM findGM
			Where BlacklistedReason > '';
		</cfquery>

<!---
		<Cfdump var="#form#">
		<CFDUMP VAR="#approvedGM#">
		<cfdump var="#BlacklistedGM#">
--->
		<cfif approvedGM.RECORDCOUNT gt 0>
			<H4>There is already a GM registered with this email address. Have you already joined?</h4>
			Please contact the <cfoutput><a href="mailto:#SESSION.EMAIL#"></cfoutput>Gaming Administrator</a> if you continue having problems.
			<input type="button" value="Continue" onClick="self.location.href='gmindex.cfm'; return false">
		<cfelseif BlacklistedGM.RECORDCOUNT gt 0>
			<font color="Red">Your account has been deactivated.<br> Please contact the <cfoutput><a href="mailto:#SESSION.EMAIL#"></cfoutput>Gaming Administrator</a>.</font>
			<input type="button" value="Continue" onClick="self.location.href='gmindex.cfm'; return false">
		<Cfelse>
			<cflocation url="gmform.cfm?LoginEmail=#form.email#" addtoken="No">
		</CFIF>


<cfelse>


	<cfform action="gmFirstTime.cfm" method="post" name="gmform">

	<cfoutput>


	<table cellpadding="3" cellspacing="3">

		<tr>
			<td>Email</td>
			<td><cfinput type="Text" name="email" value="#Lemail#" message="You must enter your email address" required="Yes" size="40" onChange="return checkEmail();"></td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<input type="submit" name="fromGMFirstTimeForm" value="Continue">
				<input type="Reset">
			</td>
		</tr>
	</table>
	<p>
	<b>Review the <a href="guidelines.cfm?review="Yes"">GM Guidelines</a>.</b>





	</cfoutput>

	</cfform>
</cfif>
</div>
			 </p>
		</div>
	</div>
	<!-- end #page -->
</div>
<div id="footer">
	<p>Copyright (c) 2013 rjritchie.com. All rights reserved. | Design by <a href="http://www.freecsstemplates.org/" rel="nofollow">FreeCSSTemplates.org</a>.</p>
</div>
<!-- end #footer -->
</body>
</html>

