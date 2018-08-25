<CFIF Not IsDefined("Session.Administrator")>
	<cflocation url="../../necro/clubs/../admin.htm" addtoken="No">
</cfif>	


<cfif IsDefined("form.submit")>

	<cfquery name="Clubs" datasource="#ds#">
	SELECT CLUBS.CLUBID FROM CLUBS;
	</cfquery>


	<cfloop query="Clubs">
	
		<cfset name = Evaluate("ClubName#ClubID#")>
		<cfset icon = Evaluate("ClubIcon#ClubID#")>
		<cfset graphic = Evaluate("ClubGraphic#ClubID#")>
		
		<cfquery datasource="#ds#">
		
			UPDATE CLUBS
			SET ClubName = '#name#',
			    ClubIcon = '#icon#',
				ClubGraphic = '#graphic#'
			where ClubID = #ClubID#
		</cfquery>
	
	</cfloop>

	<cfif Trim(form.ClubNameNew) GT "">
	
		<cfquery datasource="#ds#">
		INSERT INTO CLUBS (ClubName, ClubIcon, ClubGraphic)
			values ('#FORM.CLUBNAMENEW#', '#FORM.CLUBICONNEW#', '#FORM.CLUBGRAPHICNEW#')
		</cfquery>
	</cfif>

</cfif>

<cfif isDefined("form.gmsubmit")>

	<cfquery name="GMs" datasource="#ds#">
		SELECT  [Game Masters].GMId
		FROM [Game Masters]
		ORDER BY [Game Masters].LastName, [Game Masters].FirstName;
	</cfquery>

	<cfloop query="gms">
	
		<cfquery datasource="#ds#">
			UPDATE [Game Masters]
				set clubid = <cfif Evaluate("form.club#gmid#") EQ -1>null<cfelse>#Evaluate("form.club#gmid#")#</cfif>
			where gmid = #gmid#
		</cfquery>
	
	</cfloop>

</cfif>


<CFQUERY name="avid" datasource="#ds#" dbtype="ODBC">
SELECT TOP 1 CONVENTIONDATE, DropDeadDate, ConventionName, ConventionEnds
	FROM ADMIN
</CFQUERY>

<cfquery name="Clubs" datasource="#ds#">
SELECT CLUBS.CLUBID, CLUBS.CLUBNAME, CLUBS.CLUBICON, CLUBS.CLUBGRAPHIC ,
(SELECT COUNT(*) FROM [GAME MASTERS] WHERE CLUBID = CLUBS.CLUBID) AS MEMBERCOUNT
FROM CLUBS;
</cfquery>

<link rel="stylesheet" type="text/css" href="../styles/main.css">



<h2>Club Administration</h2>
<p>

<form method="post" name="fform">
<table>

<tr>
	<th>&nbsp</th>
	<th>Club Name</th>
	<th>Icon</th>
	<th>Splash</th>
	<TH>Members</TH>
</tr>

<cfoutput query="CLubs">

<tr>
	<td>#ClubID#</td>
	<td><input name="ClubName#ClubID#" value="#ClubName#" type="text" size="25"/></td>
	<td><input name="ClubICON#ClubID#" value="#ClubICON#" type="text" size="25"/></td>
	<td><input name="clubGraphic#ClubID#" value="#clubGraphic#" type="text" size="25"/></td>
	<td>#MemberCount#</td>
</tr>

</cfoutput>


<tr>

	<td>New</td>
	<td><input name="ClubNameNew" value="" type="text" size="25"/></td>
	<td><input name="ClubICONNew" value="" type="text" size="25"/></td>
	<td><input name="ClubGraphicNew" value="" type="text" size="25"/></td>	
</tr>


</table>

<input type="submit" name="submit"/>

</form>

<p><hr /></p>

<cfquery name="GMs" datasource="#ds#">
	SELECT  [Game Masters].GMId, 
			[Game Masters].CLUBID, 
			[Game Masters].LastName, 
			[Game Masters].FirstName
	FROM [Game Masters]
	ORDER BY [Game Masters].LastName, [Game Masters].FirstName;
</cfquery>


<FORM name="GMFORM" method="post" >

<TABLE>

<CFOUTPUT query="GMS">

<TR>
	<TD> #LASTNAME#, #FIRSTNAME#</TD>
	<TD>
	
		<select name="CLUB#GMID#"
		>
			<OPTION value="-1"></OPTION>
			<CFLOOP query="Clubs">
				<OPTION value="#CLUBS.CLUBID#" <CFIF GMS.CLUBID EQ CLUBS.CLUBID>SELECTED</CFIF>>#CLUBNAME#</OPTION>	
			</CFLOOP>
		</SELECT>

		
		
	</TD>
</TR>

</CFOUTPUT>

</TABLE>

<input name="GMSubmit" type="submit" />
</FORM>
