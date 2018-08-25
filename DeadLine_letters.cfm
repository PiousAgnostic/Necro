<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>Untitled</title>
</head>

<cfparam name="SENDLETTERS" default="FALSE">


<CFSET EMAILLETTERS = (SENDLETTERS NEQ FALSE)>


<cfinclude template="DeadLineInclude.cfm">


<CFQUERY name="avid" datasource="#ds#" dbtype="ODBC">
SELECT TOP 1 CONVENTIONDATE, DropDeadDate, ConventionName, ConventionEnds, HoursForFree
	FROM ADMIN
</CFQUERY>


<CFSET DAYSTILL = DateDiff("y", DateFormat(Now()), avid.ConventionDate)>

<CFSET DAYSSINCE = DateDiff("y", DateFormat(Now()), avid.ConventionEnds)>

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
			<cfset DATESTRING = DATESTRING & " - " & ENDMONTH & " " & ENDDATE >
		<CFELSE>
			<CFSET DATESTRING = DATESTRING & "-" & ENDDATE>
		</cfif>	
	</cfif>
<CFELSE>
	<CFSET DATESTRING = DATESTRING>
</cfif>


<link rel="stylesheet" type="text/css" href="styles/reports.css">
<body style="margin-left: 25px;" >

<cfquery name="p2" dbtype="query">
SELECT * FROM Participants
</cfquery>

<H2>Send all these letters automatically by clicking <a href="DeadLine_letters.cfm?SENDLETTERS">HERE</a></H2>


<cfoutput query="P2" group="GmID">
<cfsavecontent variable="Letter">
<cfif NOT EMAILLETTERS>
	<a href="mailto:#email#" subject="#Avid.ConventionName#">#email#</a>  
	<p>
</CFIF>

<cfquery name="someGames" dbtype="query">
select * from Participants
where GMID = #GMID#
and TITLE not like 'Volunteering%'
</cfquery>
<cfset GAMERLETTER = someGames.Recordcount Neq 0>

<cfset LARPSTUFF = FALSE>
<cfset ANYNONLARPSTUFF = FALSE>

Dear #FirstName# #LastName#,
<p>
Thank you for all your help in making Necronomicon a continued 
success. This note is to confirm your schedule at #Avid.ConventionName#, 
#DATESTRING#.
<p>
Your schedule is as follows:
<p>
<cfoutput>

<CFSET LARPSTUFF = LARPSTUFF OR (FindNoCase("LARP", title) GT 0)>
<CFSET ANYNONLARPSTUFF = ANYNONLARPSTUFF OR (FindNoCase("LARP", title) eq 0)>


<cfset EndTime = DateAdd("h", LengthOfGame, SessionBegins)>

#DateFormat(SessionBegins, "ddd")# #timeformat(SessionBegins, "htt")# - #DateFormat(EndTime, "ddd")# #timeformat(EndTime, "htt")# : #Title# (#LengthOfGame# hours)
<br>

</cfoutput>
<p>

<CFIF LARPSTUFF>
For LARP volunteers please contact <a href="mailto:grendel@stonehill.org">grendel@stonehill.org</a> in regards to your schedule and any LARP questions.
<P>
</CFIF>




<CFIF GAMERLETTER>

<CFIF LARPSTUFF>
For Tabletop gameers and volunteers, please
<cfelse>
Please

</CFIF>

 check in at the info table as early as possible, but at least 
one hour before your game. Any GM that does not check in at least one 
hour prior to their game will have that game cancelled and those hours 
will not count towards refunded admission. If, for any reason, you cannot 
make it on time, please call us as soon as possible, either at 813-391-5685 or at the hotel if some emergency happens on the day of the 
con. Please keep in mind that if your schedule does not add up to #avid.HoursForFree#
hours, you are not eligible for refunded admission.
<p>

This year to make things more organized (and stop GMs from hunting us down), we have set times that we will have someone available to sign off on GM timesheets. A schedule will be posted at Gaming Info with all of the times that either Dean or Heather will be available. This year we also plan to have a Lieutenant who will be able to sign in our place, more details available at the convention.
<p></p>
The current SET hours that you will find one of us at gaming info are as follows:<br>
<ul>


<!---<li>Friday 9pm - 9:15pm</li>--->
<li>Saturday 8:30am - 9am</li>
<li>Saturday 9pm - 9:15pm</li>
<li>Sunday 8:30am - 9am</li>
<li>Sunday 1pm - 1:15pm</li>
</ul>
<p></p>
Thanks again and we look forward to seeing you at #Avid.ConventionName#. 
<p>
Dean &amp; Heather Dryer<br>
Necronomicon Gaming Directors
<CFIF ANYNONLARPSTUFF>
<br>
Cell 813-391-5685
</CFIF>

<CFELSE>

Thanks again and we look forward to seeing you at #Avid.ConventionName#. 
<p>
Dean &amp; Heather Dryer<br>
Necronomicon Gaming Directors
<CFIF ANYNONLARPSTUFF>
<br>
Cell 813-391-5685
</CFIF>
</cFIF>

<cfif NOT EMAILLETTERS>
	<HR>
</cfif>

</cfsavecontent>


<cfif NOT EMAILLETTERS >
#LETTER#
<CFELSE>
	<cfmail to="#EMAIL#"
			from="#SESSION.EMAIL#"
			subject="#SESSION.CONVENTIONNAME# GM & Volunteer confirmation!" type="html" 
		    server="#SESSION.SMTPServer#"
			port="25"
			username="mr@rjritchie.com" 
		    password="belladonna">#LETTER#</CFMAIL>
	Sending email notification to #FirstName# #LastName# at #email#<br>
</cfif>

</cfoutput>

<!---<CFDUMP var="#SESSION#">--->
</body>
</html>
