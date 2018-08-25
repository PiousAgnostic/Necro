<html>

<head>
<meta http-equiv="Content-Language" content="en-us">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>Home Page for</title>
<base target="_self">
</head>

<cfif SESSION.ADMINISTRATOR EQ "YES">

<cfinclude template="../necro/cleanvisitors.cfm">
<cfinclude template="../necro/visitqueries.cfm">

</cfif>

<script language="JavaScript1.2">

/*
Add-to-favorites Script
Created by David Gardner (toolmandav@geocities.com)
No warranty of any kind comes with this script!
Permission granted to Dynamic Drive (http://dynamicdrive.com) 
to post and feature this script on their DHTML archive
*/

//configure the two variables below to match yoursite's own info
var bookmarkurl="http://www.qwsolutions.net/necro02/admin.htm"
var bookmarktitle="<cfoutput>#SESSION.CONVENTIONNAME# </cfoutput>Administration Site"

function addbookmark(){
if (document.all)
window.external.AddFavorite(bookmarkurl,bookmarktitle)
}

</script>

<CFQUERY name="avid" datasource="#ds#" dbtype="ODBC">
SELECT TOP 1 CONVENTIONDATE, DropDeadDate, ConventionName, ConventionEnds
	FROM ADMIN
</CFQUERY>

<cfset STARTMONTH = MonthAsString(DatePart( "m", avid.ConventionDate))>
<cfset STARTDATE  = DAtePart("d", avid.ConventionDate)>
<cfset STARTYEAR  = DatePart("yyyy", avid.ConventionDate)>

<cfset ENDMONTH = MonthAsString(DatePart("m", avid.ConventionEnds))>
<cfset ENDDATE  = DatePart("d", avid.ConventionEnds)>
<cfset ENDYEAR  = DatePart("yyyy", avid.ConventionEnds)>

<cfset DATESTRING = STARTMONTH & " " & STARTDATE>
<CFIF AVID.CONVENTIONDATE neq AVID.CONVENTIONENDS>
	<CFIF STARTYEAR NEQ ENDYEAR>
		<cfset DATESTRING = DATESTRING & ", " & STARTYEAR & " - " & ENDMONTH & " " & ENDDATE & ", " & ENDYEAR>
	<CFELSE>
		<CFIF STARTMONTH neq ENDMONTH>
			<cfset DATESTRING = DATESTRING & " - " & ENDMONTH & " " & ENDDATE & ", " & ENDYEAR>
		<CFELSE>
			<CFSET DATESTRING = DATESTRING & "-" & ENDDATE & 	", " & ENDYEAR>
		</cfif>	
	</cfif>
<CFELSE>
	<CFSET DATESTRING = DATESTRING & ", " & STARTYEAR>
</cfif>

<link rel="stylesheet" type="text/css" href="styles/main.css">
<body bgcolor="#000000" text="#FFFFFF">
<center>
<h1>Welcome to the</h1>
<center>

		<div id="logo">

	<h1>Necronomicon</h1>
</div></center>

<h1>Administrative Web Site!</h1>
<p>
<font size="+1"><cfoutput>#DATESTRING#<BR></cfoutput>Tampa, Florida<br></font>

<p>
<cfif SESSION.ADMINISTRATOR EQ "YES">
<!---<cfoutput>
Number of Site Visits since <b>#DateFormat(daterange.MinOFWhen, "dddd mmmm dd yyyy")#</b> :
	<font size="+1" color="Lime"><b>#NumberOFSiteVisits#</b></font>
	(#numadminvisits# by administrators)<br>
Number of Site Visits Today :
	<font size="+1" color="Lime"><b>#NumberOFSiteVisitsToday#</b></font><br>
Number of Unique Visitors since <b>#DateFormat(daterange.MinOFWhen, "dddd mmmm dd yyyy")#</b> :
	<font size="+1" color="Lime"><b>#NumberOFUniqueVisitors#</b></font><br>
Number of Unique Visitors Today :
	<font size="+1" color="Lime"><b>#NumberOFUniqueVisitorsToday#</b></font><br>
The latest visitor stopped by 
<b>
	#DateFormat(daterange.MaxOFWhen, "dddd mmmm dd yyyy")# at
	#TimeFormat(daterange.MaxOfWhen, "h:mm:ss tt")#

</b>.
<p>

</cfoutput>--->
<CFELSE>
	<cflocation url="volunteers.cfm">
</CFIF>

</center>
<table width="600" align="center">
<tr>
<td align="Center">
<script>
//if the user is using IE 4+
if (document.all)
document.write('<a href="javascript:addbookmark()">Bookmark this site!</a>')
</script> 
</td>
</tr>
</table>

</body>

</html>
