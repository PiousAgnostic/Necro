<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>GM Guidelines</title>
<cfquery name="avid" datasource="#ds#" dbtype="ODBC">
	SELECT TOP 1 HoursForFree, DropDeadDate, ConventionName
	FROM ADMIN
</cfquery>	

<CFSET DAYSTILL = DateDiff("y", Now(), avid.DropDeadDate) + 1>

<cfif DAYSTILL GT 1>
	<CFSET DAYMST = "days">
<CFELSE>
	<CFSET DAYMST = "day">
</cfif>
	
</head>
<link rel="stylesheet" type="text/css" href="styles/main.css">
<body style="margin-left: 25px;">

<h1 style="color: #FF8000;">I Don't Want To Pay To Get In!!!!!</h1>
<cfif DAYSTILL GT 0>
<cfoutput>
<h2>
All GM's who are scheduled to work #Avid.HoursForFree# hours at #Avid.ConventionName#
(running games or working the info table or volunteering at other areas or all three) before <font color="##FF8040">#DateFormat(Avid.DropDeadDate, "mmmm d")#</font> 
will receive refunded admission!
<P>
That's only #DAYSTILL# #DAYMST# away! What are you waiting for?????
<p>
Start Clickin' on the links up top!
</h2>
</cfoutput>
<cfelse>
<cfoutput>
<h2>
Sorry, but the deadline has passed. If you had been scheduled to work #Avid.HoursForFree# hours at #Avid.ConventionName#
(running games or working the info table or both) before <font color="##FF8040">#DateFormat(Avid.DropDeadDate, "mmmm d")#</font> 
<br>you would have received refunded admission!
<P>
That's what you get for waiting. Sorry!
</h2>
</cfoutput>

</cfif>
</body>
</html>
