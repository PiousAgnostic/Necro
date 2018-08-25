

<style type="text/css">
<!--


div.slider{
display:none;
}

a.flippy {
text-decoration:none;
}

-->
</style>

<cfquery name="NA" datasource="#ds#" dbtype="ODBC">
	SELECT 		Type, System, Title,
				GM, email, emailVisable, Link, Description, AdultOnly,
				NumPlayers, RoleplayingStressed, [Level], GameId, HomePage,
				Image, ImageApproved, Approved, Request1, Request2, Request3, Session,
				Request1Date, Request1Time, Request2Date, Request2Time,
				Request3Date, Request3Time, Telephone
	FROM 		[Needing Approval]
	ORDER BY    Title
</cfquery>

<cfquery name="ScheduledGames" datasource="#ds#" dbtype="ODBC">
	SELECT TITLE, GameID
FROM Games INNER JOIN [Game Masters] ON Games.GMid = [Game Masters].GMId
WHERE Games.Approved=1 AND [Game Masters].Cancelled=0 AND Games.Cancelled=0 and [Game Masters].Approved=1
	Order by Title
</cfquery>



<!---<script language="javascript" src="jquery-1.2.6.js"></script>--->
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.0/jquery.min.js"></script>
<script src="assets/javascripts/socialProfiles.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
    $('a.flippy').click(function() {
        var heading = $(this).html().substr(1);
        var content = $(this).parent('p').next('div.slider');
        if ($(content).is(':hidden')) {
            $(this).html('&#x25BC;' + heading);
            $(content).slideDown('slow');
        } else {
            $(this).html('&#x25BA;' + heading);
            $(content).slideUp('fast');
        }
        return false;
    });
});

</script>


	<cfif Na.RecordCount NEQ 0>

		<p><a href="#" class="flippy">&#x25BA; <b>Approve Games</b></a></p>
		<div class="slider">
		<cfoutput query="NA">
			<a href="needapproval.cfm?GameId=#GameId#" target="adminmain">#Title#</a><br>
		</cfoutput>
		</div>

		<p>
	</cfif>

	<cfquery name="gm_info" datasource="#ds#">
		SELECT GMID, FIRSTNAME, LASTNAME,
		CASE
			WHEN APPROVED = 0 AND CANCELLED = 0 THEN 'New'
			WHEN APPROVED = 1 AND CANCELLED = 0 THEN 'Active'
			WHEN CANCELLED = 1 AND Len(rTrim(CAST (isnull(BlackListedReason, '') AS VARCHAR(1000)))) = 0 THEN 'Cancelled'
			WHEN CANCELLED = 1 AND Len(rTrim(CAST (isnull(BlackListedReason, '') AS VARCHAR(1000)))) > 0 THEN 'Blacklisted'
			ELSE CAST(APPROVED AS VARCHAR) + ' / ' + CAST(CANCELLED AS VARCHAR) + ' / ' +  CAST( Len(rTrim(CAST (isnull(BlackListedReason, '') AS VARCHAR(1000)))) AS VARCHAR)
		END AS CAT,
		CASE
			WHEN APPROVED = 0 AND CANCELLED = 0 THEN 1
			WHEN APPROVED = 1 AND CANCELLED = 0 THEN 2
			WHEN CANCELLED = 1 AND Len(rTrim(CAST (isnull(BlackListedReason, '') AS VARCHAR(1000)))) = 0 THEN  3
			WHEN CANCELLED = 1 AND Len(rTrim(CAST (isnull(BlackListedReason, '') AS VARCHAR(1000)))) > 0 THEN 4
		END AS CATSORT
		FROM [GAME MASTERS]
		ORDER BY CATSORT, LASTNAME, FIRSTNAME

	</cfquery>



	<CFIF GM_INFO.RECORDCOUNT NEQ 0>
	<p><a href="#" class="flippy">&#x25BA; <b>GM Information</b>
			<div class="slider">
				<CFOUTPUT query="gm_info" GROUP="CAT">
					<p>&nbsp;&nbsp;&nbsp;<a href="##" class="flippy">&##x25BA; <b>#CAT# GM's</b></a></p>
					<div class="slider">
					<CFOUTPUT>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="gminfo.cfm?GMID=#GMID#" target="adminmain">#lASTNAME#, #firstname# </a><br />
					</CFOUTPUT>
					</div>
				</CFOUTPUT>
			</div>

	</CFIF>


	<CFIF ScheduledGames.RECORDCOUNT gt 0>

	<p><a href="#" class="flippy">&#x25BA; <b>Scheduled Games</b></a></p>
<div class="slider">

		<cfoutput query="ScheduledGames">
			<a target="adminmain" href="needapproval.cfm?scheduledGame=#GameID#">#Title#</a><br>
		</cfoutput>

</div>

	</cfif>

<p>
<a href="volunteers.cfm" target="adminmain"><b>Volunteers</b></a>

	<p><a href="#" class="flippy">&#x25BA; <b>Table Assignment</b></a></p>
<div class="slider">
		<a href="tableAssignment.cfm" target="adminmain">Review Table Assignments</a> <br>
		<a href="tableAssignment_menu.cfm" target="adminmain">Auto-Assign Tables</a> <br>
<!---	    <a href="javascript:alert('Disabled Until Next Year!');" target="adminmain">Auto-Assign Tables</a> <br> --->
</div>
	<p><a href="#" class="flippy">&#x25BA; <b>Emails and Exports</b></a></p>
<div class="slider">
		<a href="DeadLine.cfm" target="adminmain">Review Participants</a> <br>
		<a href="DeadLine_letters.cfm" target="_blank">Confirmation Letters (email)</a><br />
		<a href="DeadLine_WelcomeLetters.cfm" target="_blank">Welcome Letters</a> <br>
		<a href="signupsheets.cfm" target="_blank">Signup-Sheets</a><br />
		<a href="todo.cfm" target="adminmain">Time Sheets (ToDo)</a> <br>
		<a href="gamereport.cfm" target="adminmain">Program Book Download</a> <br>
		<a href="tableAssignment_download.cfm" target="adminmain">Guidebook App Download</a> <br>
</div>

 	<p>
	<a href="administration.cfm" target="adminmain"><b>Site Admin</b></a>

	<p>
	<a href="admin_guidelines.cfm" target="adminmain"><b>Guidelines</b></a>

	<p>
	<a href="clubs/clubadmin.cfm" target="adminmain"><b>Club Admin</b></a>

	<p>
	<a href="index.cfm" target="_top"><b>Go to Site!</b></a>

