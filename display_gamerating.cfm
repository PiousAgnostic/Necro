	<cfquery name="gamerating" datasource="#ds#" dbtype="ODBC">
		SELECT Ratings.GameId, r1, r2, r3, r4, r5, Games.Title
		FROM Ratings RIGHT JOIN Games ON Ratings.GameId = Games.GameId
		Where Games.GameID = #GameId#;
	</cfquery>
	
	<cfoutput query="gamerating">
	<cfif R1 NEQ "">
		<cfset Lr1 = R1>
		<cfset Lr2 = R2>
		<CFSET lr3 = R3>
		<cfset lr4 = r4>
		<cfset lr5 = r5>
		<cfset rtotal = R1 + R2 + r3 + r4 + r5>
	<cfelse>
		<cfset Lr1 = 0>
		<cfset Lr2 = 0>
		<CFSET lr3 = 0>
		<cfset lr4 = 0>
		<cfset lr5 = 0>	
		<cfset rtotal = 1>
	</cfif>
	<cfif rtotal eq 0><cfset rtotal = 1></cfif>
	<table cellspacing="3" cellpadding="3">
		<tr>
			<th bgcolor="Olive" style="color: White;">#gamerating.Title#</th>
			<th bgcolor="Maroon" style="color: White;">Count</th>
			<th bgcolor="Maroon" style="color: White;">Percent</th>
		</tr>
		<tr>
			<td align="center"><img src="../necro/images/d5.gif" border="0" alt="" align="middle"></td>
			<td align="center">#LR5#</td>
			<td align="center">#NumberFormat(LR5*100 / rtotal)#%</td>
		</tr>
		<tr>
			<td align="center"><img src="../necro/images/d4.gif" border="0" alt="" align="middle"></td>
			<td align="center">#LR4#</td>
			<td align="center">#NumberFormat(LR4*100 / rtotal)#%</td>
		</tr>
		<tr>
			<td align="center"><img src="../necro/images/d3.gif" border="0" alt="" align="middle"></td>
			<td align="center">#LR3#</td>
			<td align="center">#NumberFormat(LR3*100 / rtotal)#%</td>
		</tr>
		<tr>
			<td align="center"><img src="../necro/images/d2.gif" border="0" alt="" align="middle"></td>
			<td align="center">#LR2#</td>
			<td align="center">#NumberFormat(LR2*100 / rtotal)#%</td>
		
		</tr>
		<tr>
			<td align="center"><img src="../necro/images/d1.gif" border="0" alt="" align="middle"></td>
			<td align="center">#LR1#</td>
			<td align="center">#NumberFormat(LR1*100 / rtotal)#%</td>
		</tr>
	</table>
	<p>
</cfoutput>