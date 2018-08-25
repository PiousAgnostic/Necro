<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>Welcome Letters</title>
</head>

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

<cfset p1 = QueryNew("GmID, FirstName, LastName,  Title, SessionBegins, LengthOfGame")>


<cfoutput query="Participants">

<!--- <cfif Left(title, 12) neq "Volunteering" OR
	  title eq "Volunteering - Gaming Table"> --->
		<cfset temp = QueryAddRow(p1)>
		<cfset temp = querySetCell(p1, "GmID", GMID)>
		<cfset temp = querySetCell(p1, "FirstName", FirstName)>
		<cfset temp = querySetCell(p1, "LastName", LastName)>
		<cfset temp = querySetCell(p1, "Title", title)>
		<cfset temp = querySetCell(p1, "SessionBegins", SessionBegins)>
		<cfset temp = querySetCell(p1, "LengthOfGame", LengthOfGame)>
<!--- </cfif> --->
</cfoutput>

<Cfquery name="p2" dbtype="query">
	select * from p1
	order by LastName, FirstName, SessionBegins
</Cfquery>


<cfoutput query="P2" group="GmID">


<cfquery name="someGames" dbtype="query">
select * from p2
where GMID = #GMID#
and (TITLE not like 'Volunteering%' or
    TITLE  = 'Volunteering - Gaming Table')
</cfquery>
<cfset GAMERLETTER = someGames.Recordcount Neq 0>

<cfif GAMERLETTER>

<img src="../necro/images/raffle_image.gif" align="right">
<h1 align="center">Welcome Game Masters</h1>
<p></p>
Dear #FirstName# #LastName#,
<p>
The Staff of #Avid.ConventionName# and the Stonehill Science Fiction Association would like to welcome you to #Avid.ConventionName# and thank you for efforts and invaluable help in making our convention a success. Below are a few things you will need to do while you are here.
<p>
<ul>
<li><strong>Con Rules</strong> - All GM’s are expected to enforce the con rules. A complete list of these rules can be found in the program book. The most important rule, however, is about badges. Only players visibly displaying the proper badge may play in your game or sit a table in the gaming rooms. Remember that one-day badges are good only from Fri noon to Sat 9am, after that, one-day badges should not be honored. 2-day badges should only be honored from Fri noon to Sun 9am. Of course, anyone with a 3-day, staff, Guest, or dealers’ badge may play anytime.</li>
<li><strong>Refunds</strong> - This year your Volunteer “timesheet” is located in your GM packet (where you found this letter). You'll notice that your games/shifts are already filled in for you. You’ll need to have that filled out and signed by the department head once you’ve worked your hours, in order to get your refund. Refund requests MUST be made at convention registration <strong>BEFORE 3pm Sunday.</strong></li>
<li><strong>Suvivor's Raffle</strong> - We're bringing back our Survivor's raffle this year as it was such a hit last year. Everyone who is in the gaming room at 4pm on Sunday will receive an entry into the raffle. We'll be giving away all of the prize support we have received, including the very popular "GAMING BAGS OF CRAP" that everyone loved last year. Don't miss it and be sure and let your players know about it. </li>
<li><strong>Mailing list</strong> - If you are not receiving our Gaming Updates please visit our gaming website to sign up.
</li>
</ul>
<hr size="7" noshade color="000000">
<br style="page-break-after: always">
Your schedule is as follows:
<p>
<cfoutput>
<cfset EndTime = DateAdd("h", LengthOfGame, SessionBegins)>

#DateFormat(SessionBegins, "ddd")# #timeformat(SessionBegins, "htt")# - #DateFormat(EndTime, "ddd")# #timeformat(EndTime, "htt")# : #Title# (#LengthOfGame# hours)
<br>

</cfoutput>
<p>
IMPORTANT! So important we're repeating ourselves here. Don't forget to get your timesheet signed off by Dean or Heather Dryer! You’ll need to have the timesheet filled out and signed by one of us once you’ve worked your 10 hours, in order to get your refund. Refund requests MUST be made at convention registration BEFORE Sunday afternoon.
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
Thanks again for making #Avid.ConventionName# a success!
<p>
Dean &amp; Heather Dryer<br>
Necronomicon Gaming Directors <br>
Cell 813-391-5685 <br>

<br style="page-break-after: always">
</cfif>
</cfoutput>


</body>
</html>
