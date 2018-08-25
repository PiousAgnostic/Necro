<cfoutput>



	<a id="#GameId#">
	<cfif (#Image# GT "") AND (#ImageApproved# GT 0)>
		<img src="#Session.ProofURL#/#Image#" align="right" BORDER="0">
	</cfif>
</a>
	 <font size="+3">#Title#</font><br />
	<b>Game System:</b> #System#<BR>
	<b>Game Type:</b> #Type#<BR>
	<b>Game Master:</b> <cfif (emailVisable GT 0) AND (email GT "")><a href="mailto:#email#"></cfif>#GM#</a><BR>
<!--- 	<cfif #HomePage# GT ""><b>Game Masters's Homepage:</b> <a href="#HomePage#" target="_blank">#HomePage#</a></cfif><br>
	<b>Description:</b> #Description#<br>--->
 	<b>Starts:</b> #DateFormat(SessionDate, "dddd")# #TimeFormat(SessionBegins, "h:mm tt")# <br>
	<b>Length of Game:</b> #LengthOfGame# Hour(s)<br>
	<cfif #link# GT "">
		<cfset LLink = #Link#>
		<cfif Left(LLINK, 7) NEQ "http://">
			<cfset LLink = "http://" & LLINK>
		</cfif>
		<b>More Info at:</b> <a href="javascript:testURL('#LLink#');">(link)</a><br>
	</cfif>
	<b>Number of Players:</b>
	#NumPlayers#
	 <br>
	<b>Player Level:</b>
	#Level#
	 <br>
	<b>Mature Content:</b> <cfif #AdultOnly# GT 0>Yes<cfelse>No</cfif><BR>
	<b>Roleplaying Stressed:</b> <cfif #RoleplayingStressed# GT 0>Yes<cfelse>Not Really</cfif><br>
	<table cellpadding="0" cellspacing="0">
	<tr>
		<td><strong>Complexity:&nbsp;</strong></td>
		<td>
	<div class="progress-container">
    							<div style="width: #Evaluate("complexity * (100/11)")#%" class="progress-container-bar"></div>
	</div></td>
	</tr>
	</table>
	<!-- the drop cap -->
<span style="margin-right:6px;margin-top:5px;float:left;color:white;background:##7CFF7C;border:1px solid darkkhaki;font-size:80px;line-height:60px;padding-top:2px;padding-right:5px;font-family:times; text-transform:capitalize">#LEFT(Description,1)#</span>#MID(Description,2,5000)#
<div style="clear:both;"><br></div>




	<!---register game view--->

	<cftry>
		<cfquery datasource="#ds#">
			insert into GameViews (GameID, Views) values (#GameID#,1)
		</cfquery>


	<cfcatch>
		<cfquery datasource="#ds#">
			update GameViews
			Set Views = Views+1
			where GameID = #GameID#
		</cfquery>
	</cfcatch>


	</cftry>


</cfoutput>