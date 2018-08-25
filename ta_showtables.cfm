
<CFIF Not IsDefined("Session.Administrator")>
	<cflocation url="../necro/admin.htm" addtoken="No">
</cfif>



<cfloop query="roomstables"	>


	<cfset ShapeName = #shape#>
	<cfset MaxNumTables = #count#>
	<cfset FirstRoomNumber = #FirstRoomNumber#>
	<cfset mroomname = #roomname#>

<P>
<cfoutput>
<A ID="#mROOMNAME#">
<FONT size="+2"> Room: #mRoomName#</font> <font size="-1"><b>(return to <a href="##top">Top</a>)</b></font>
</a>
</cfoutput>
<P>
<cfoutput query="clock">

<div id="Table#mRoomName##CurrentRow#">

<SCRIPT>
Table#mRoomName##CurrentRow#.onclick = select;
</script>

<cfset colspan = MaxNumTables + 1>
<table cellspacing="3" cellpadding="3">
	<tr>
		<th colspan="#colspan#" bgcolor="Maroon" align="left" >
			<font color="White">#mRoomName# - #DateFormat(SessionDate, "dddd, mmmm dd")#</font>
		</th>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<cfloop index="tbl" from="1" to="#MaxNumTables#">
			<cfset tblnum = FirstRoomNUmber + tbl - 1>
			<td width="100" align="center" valign="top" bgcolor="White"><font size="+1" color="Black">Table#tblnum#</font></td>
		</cfloop>
	</tr>

	<cfset numHrs = DateDiff("h", MinOFSessionBegins, MaxOfSessionEnds)+LastOfMaxLengthGame-1>
	<cfset oneHr  = CreateTimeSpan(0,1,0,0)>
	<cfset thisHour = MinOFSessionBegins>

	<cfloop index="x" from="1" to="#numHrs#">
		<tr>
			<td valign="top" align="right" width="40"><font size="-1">#TimeFormat(thisHour, "htt")#</font></td>
			<cfloop index="tbl" from="1" to="#MaxNumTables#">
				<cfset tblnum = FirstRoomNUmber + tbl - 1>

					<CFQUERY name="SLOTCONTENTS" datasource="#DS#">
						SELECT * FROM TABLEASSIGNMENT
						WHERE ROOM = '#mROOMNAME#' and
							  [TABLE] = #tblnum# AND
					    	  TimeSlot = #CreateODBCDateTime(thisHour)#
					</cfquery>

					<cfif slotcontents.recordcount eq 0>
						<td width="100" align="center" valign="top">&nbsp;

						</td>
					<cfelse>
						<cfif slotcontents.usedby NEQ -1>
							<cfquery name="thisgame" datasource="#ds#">
								SELECT * FROM SCHEDULE
								WHERE GAMEID = #slotcontents.usedby#
							</cfquery>

<!---							<cfset HEXBGCOLOR = FormatBaseN(RandRange(1,InputBaseN("FFFFFE", 16)), 16)>--->
							<cfset HEXBGCOLOR = "FCDB1F">
							<cfif thisGame.RecordCount NEQ 0>
								<cfset HEXBGCOLOR = FormatBaseN((InputBaseN("FCDB00",16) + (thisgame.GMid* 3)), 16)>

								<CFIF LEN(HEXBGCOLOR) LT 6>
									<CFSET HEXBGCOLOR = LEFT("000000", (6-Len(HEXBGCOLOR))) & HEXBGCOLOR>
								</cfif>
							</cfif>



							<td rowspan="#thisgame.LengthOfGame#"
<!--- 							COLSPAN="#thisgame.NumTables#" --->
							COLSPAN="#SLOTCONTENTS.TABLES#"
							bgcolor="#HEXBGCOLOR#"
							align="center"
							valign="top"
							id="#NumberFormat(thisgame.NumTables)#"
							class="drag"
							>
							<font size="+1" color="Black">
							<b>#thisgame.Title#<CFIF SLOTCONTENTS.PIECE EQ 2><BR>(Continued)</cfif></b><br>
							#thisgame.Type#<br>
							<i>#thisgame.GM#</i><br>
							## tables: <cfif SLOTCONTENTS.TABLES NEQ THISGAME.NUMTABLES>#NumberFormat(SLOTCONTENTS.TABLES)# of </cfif>#NumberFormat(thisgame.NumTables)#<bR>
							#thisgame.LengthOfGame# hour<cfif #thisgame.LengthOfGame# GT 1>s</cfif><br />
							#thisgame.GameID#<br />
							Table: #thisGame.Tables#
							<CFIF thisGame.TableLocked NEQ 0><img src="images/lock_32.gif" align="bottom" /></cfif>

							</font>
							</td>

						</cfif>


					</cfif>

			</cfloop>
	</tr>
	<cfset thisHour = thisHour + oneHr>
	</cfloop>


</table>
</div>
<p>
<!---
<Cfif not IsDefined("NoFLUSH")>
<cfflush>
</CFIF>
--->
</cfoutput>

</cfloop>
