<CFIF Not IsDefined("Session.Administrator")>
	<cflocation url="admin.cfm" addtoken="No">
</cfif>

<cfif Not IsDefined("URL.GMID")>
<cfabort>
</cfif>

<CFPARAM NAME="URL.GMID" DEFAULT="1">

<cfquery name="gmInfo" datasource="#ds#" dbtype="ODBC">
SELECT [GM Information].*, [Game Masters].EXTENDEDDEADLINE, [Game Masters].AFTERDEADLINE, [Game Masters].GeoCode, [Game Masters].Cancelled, [Game Masters].BlackListedReason
FROM [GM Information]
	INNER JOIN [Game Masters] ON [GM Information].GMId = [Game Masters].GMId
WHERE [GM Information].GMID = #URL.GMID#
ORDER BY [GAME MASTERS].cancelled , [GM Information].LastName, [GM Information].FirstName
;
</cfquery>

<cfset flag = 0>

<CFQUERY name="avid" datasource="#ds#" dbtype="ODBC">
SELECT TOP 1 CONVENTIONDATE, DropDeadDate, ConventionName, ConventionEnds, Announcement
	FROM ADMIN
</CFQUERY>

<h2>Game Master Information</h2>


<cfoutput query="gmInfo">
	<Cfquery name="gameInfo" datasource="#ds#">
	SELECT Games.*
	FROM Games
	WHERE Games.GMid=#gmInfo.GmId#;
	</Cfquery>


	<Cfquery name="VolInfo" datasource="#ds#">
	SELECT Volunteers.GmId, Count(VolunteerSessions.SessionId) AS CountOfSessionId
	FROM Volunteers INNER JOIN VolunteerSessions ON Volunteers.VolId = VolunteerSessions.VolId
	GROUP BY Volunteers.GmId
	HAVING (((Volunteers.GmId)=#gmInfo.GMID# ));
	</Cfquery>

	<a id="GM#GMID#"></a>
	<table border="1">


	<Cfif CountOfGameID GT 0>
		<!--- <h1>GAMER</h1> --->
		<CFSET BGCOLOR = "FF6666">
	<CFELSEIF VolInfo.CountOfSessionID GT 0>
		<!--- <h1>VOLUNTEER</h1> --->
		<CFSET BGCOLOR = "00CC66">
	<CFELSE>
		<!--- <h1>INACTIVE</h1> --->
		<CFSET BGCOLOR = "6699FF">
	</Cfif>


	<tr bgcolor="#BGCOLOR#">
		<td >
			<cfquery name="isApproved" datasource="#ds#">
				select * from [Game Masters]
				where GmID = #GmId#
			</cfquery>
			<cfset UnApproved = isApproved.Approved EQ 0>

			<cfif (#Cancelled# neq 0) and (#flag# EQ 0)>
				<hr>
				<h3>Cancelled Game Masters</h3><p>
				<cfset flag = 1>
			</cfif>

			<cfif Cancelled eq 0>
				<cfif UnApproved>
					<font size="+3" color="Red">
				<cfelse>
					<font size="+1" color="Black">
				</cfif>

			<cfelse>
				<font size="+1" color="BLUE">
			</cfif>

			<form action="gminfoupdate.cfm" method="post">
			<a id="GMID#GMId#">
			#FirstName# #MiddleName# <cfif #Alias# GT "">"#Alias#" </cfif> #LastName#<br></a>
			<cfif Address1 GT "">#Address1#<br></cfif>
			<cfif Address2 GT "">#Address2#<br></cfif>
			<cfif City GT "">#City# #State# #Zip#<br></cfif>
			<cfif Telephone GT "">#Telephone#<br></cfif>
<!---			//Geocode: #Geocode# &nbsp; <a  style="font-size:9px" href="geocodeGM.cfm?gmid=#gmid#">Geocode</a><br>
--->
			<cfif email GT "">email : <a href="mailto:#email#">#email#</a><br></cfif>
			<cfif homepage gt "">homepage : <a href="#homepage#" target="_blank">#homepage#</a><br></cfif>
			Registered: #DateFormat(AFTERDEADLINE, "mmMM d, yyyy")#<br>
			Games Listed: #CountOfGameID#<br>
			Hours Gaming: #NumberFormat(SumOfLengthOfGame)#<br>
			<cfloop query="VolInfo">
			Sessions Volunteered: #CountOfSessionId#<br>
			</cfloop>



			<div title="#password#">PASSWORD</div>


			<cfif Cancelled eq 0>
				<cfif UnApproved>
					<font color="White">Approve this Game Master? </font>
					&nbsp;
					<input type="submit" name="fromGmForm" value="Approve"><br>
				</cfif>
				<font color="White">Cancel Game Master and all scheduled Games? </font>
				<input type="radio" name="delete" value="No" checked>No&nbsp;&nbsp;
				<input type="radio" name="delete" value="Yes">Yes&nbsp;&nbsp;
				<input type="submit" name="fromGmForm" value="Cancel">
				<input type="hidden" name="GMId" value="#GmId#">
			<cfelse>

				<font color="White">Reinstate Game Master and all scheduled Games? </font>
				<input type="radio" name="reinstate" value="No" checked>No&nbsp;&nbsp;
				<input type="radio" name="reinstate" value="Yes">Yes&nbsp;&nbsp;
				<input type="submit" name="fromGmForm" value="Reinstate">
				<input type="hidden" name="GMId" value="#GmId#">
				<br>
				<font color="White">Permanently Delete this GM from Database?</font>
				<input type="submit" name="fromGmForm" value="Delete"><br>
				<font color="White">If you wish to BLACKLIST this GM, enter a reason below.</font><BR>
				<font color="White">(Or, clear this area if they are no longer blacklisted.)</font><br>
				<input type="submit" name="fromGMForm" value="Blacklist">
				<br>
				<textarea name="BlackListedReason" style="width:100%; height:75px">#BlackListedReason#</textarea>
			</cfif>
			<br>
			<font color="White">Extend Deadline: </font>

			<select name="ExtendedDeadline">
				<option value="NULL"></option>

				<cfloop index="D" from="#avid.DropDeadDate#" to="#avid.CONVENTIONDATE#" step="#CreateTimeSpan(1,0,0,0)#">
					<option value="#DateFormat(D, "mm/dd/yyyy")#"
						<cfif IsDate(ExtendedDeadLine)>
							<cfif DateCompare(D,ExtendedDeadline) EQ 0> selected</cfif>
						</cfif>
					>#DateFormat(D, "mm/dd/yyyy")#</option>
				</cfloop>
			</select>
			&nbsp;
			<input type="submit" name="fromGMForm" value="Extend">
			</form>
			<p>
			</font>

		</td>
	</tr>
	</table>
</cfoutput>
</body>

<script language="javascript">
window.top.scrollTo(0, 0);
</script>

</html>
