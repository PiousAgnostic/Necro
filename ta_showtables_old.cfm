
<CFIF Not IsDefined("Session.Administrator")>
	<cflocation url="admin.cfm" addtoken="No">
</cfif>	
	


<cfloop query="roomstables"	>


	<cfset ShapeName = #shape#>
	<cfset MaxNumTables = #count#>
	<cfset FirstRoomNumber = #FirstRoomNumber#>
<!---	<cfif roomname eq "Citrus">
		<cfset FirstRoomNumber = 1>
	<cfelseif roomname eq "Cypress">
		<cfset FirstRoomNumber = 10>
	<cfelseif roomname eq "Magnolia">
		<cfset FirstRoomNumber = 20>
	<cfelseif roomname eq "Palm">
		<cfset FirstRoomNumber = 30>
	<cfelse>
		<cfset FirstRoomNumber = 50>
	</cfif>	--->
	
	
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
			<td valign="top" align="right" width="40"><font size="-1">#TimeFormat(thisHour, "h tt")#</font></td>
			<cfloop index="tbl" from="1" to="#MaxNumTables#">
				<cfset tblnum = FirstRoomNUmber + tbl - 1>
				
<!---					<CFQUERY name="SLOTCONTENTS" datasource="#DS#">
						SELECT * FROM TABLEASSIGNMENT
						WHERE ROOM = '#mROOMNAME#' and
							  TABLE = #tblnum# AND
					    	  TimeSlot = #CreateODBCDateTime(thisHour)# AND
							  USEDBY <> 0
							  
					</cfquery>
--->
					<CFQUERY name="SLOTCONTENTS" datasource="#DS#">
						SELECT * FROM SCHEDULE
						WHERE ROOM = '#mROOMNAME#' and
							  '#TBLNUM#' IN (TABLES) AND
					    	  SessionBegins = #CreateODBCDateTime(thisHour)# 
					</cfquery>
					
					<cfif slotcontents.recordcount eq 0>
					
						<!---SEE IF THIS SLOT IS USED -- IF NOT, PUT IN A TD--->
					
<!---						<CFQUERY name="SLOTUSED" datasource="#DS#">
							SELECT ROOM, TABLES, SESSIONBEGINS, SESSIONENDS 
							FROM SCHEDULE
							WHERE ROOM = '#mROOMNAME#' and
								  '#TBLNUM#' IN (TABLES) AND
								  #CreateODBCDateTime(thisHour)#  > SessionBegins 
								  and 
								  #CreateODBCDateTime(thisHour)# < SessionEnds	
						</CFQUERY>--->
		
						<CFQUERY name="SLOTUSED" datasource="#DS#">
							SELECT ROOM, TABLES, SESSIONBEGINS, SESSIONENDS 
							FROM SCHEDULE
							WHERE ROOM = '#mROOMNAME#' and	
							(
								( '#TBLNUM#' IN (TABLES) AND
								  #CreateODBCDateTime(thisHour)#  > SessionBegins 
								  and 
								  #CreateODBCDateTime(thisHour)# < SessionEnds	
								)
								OR
								(
								
								)
							)	
						</CFQUERY>
		
						<cfif SLOTUSED.RECORDCOUNT EQ 0>
							<td width="100" align="center" valign="top">&nbsp;
							</td>						
						</cfif>
					

					<cfelse>
<!---						<cfif slotcontents.usedby NEQ -1
---><!---							<cfquery name="thisgame" datasource="#ds#">
								SELECT * FROM SCHEDULE
								WHERE GAMEID = #slotcontents.usedby#
							</cfquery>--->
						
						
							<cfset Piece = ListFind(SLOTCONTENTS.tables, #TBLNUM#)>
							<CFSET theTableCount = ListGetAt(SLOTCONTENTS.tableCounts, Piece)>
						
						
<!---							<cfset HEXBGCOLOR = FormatBaseN(RandRange(1,InputBaseN("FFFFFE", 16)), 16)>--->
							<cfset HEXBGCOLOR = "FCDB1F">
							
							<cfset HEXBGCOLOR = FormatBaseN((InputBaseN("FCDB00",16) + (SLOTCONTENTS.GMid* 3)), 16)>
							
							<CFIF LEN(HEXBGCOLOR) LT 6>
								<CFSET HEXBGCOLOR = LEFT("000000", (6-Len(HEXBGCOLOR))) & HEXBGCOLOR>
							</cfif>			
						
						
							<td rowspan="#SLOTCONTENTS.LengthOfGame#" 
<!--- 							COLSPAN="#thisgame.NumTables#" --->
							COLSPAN="#theTableCount#"
							bgcolor="#HEXBGCOLOR#" 
							align="center" 
							valign="top"
<!---							id="#NumberFormat(SLOTCONTENTS.NumTables)#"--->
							class="drag"
							>
							<font size="+1" color="Black">
							<b>#SLOTCONTENTS.Title#<CFIF PIECE EQ 2><BR>(Continued)</cfif></b><br>
							#SLOTCONTENTS.Type#<br>
							<i>#SLOTCONTENTS.GM#</i><br>
							## tables: <cfif SLOTCONTENTS.TABLES NEQ SLOTCONTENTS.NUMTABLES>#NumberFormat(theTableCount)# of </cfif>#NumberFormat(SLOTCONTENTS.NumTables)#<bR>
							#SLOTCONTENTS.LengthOfGame# hour<cfif #SLOTCONTENTS.LengthOfGame# GT 1>s</cfif>
							<br />#SLOTCONTENTS.GameID#<br />
							tables: #slotcontents.Tables#<br />
							##tabs: #slotcontents.tablecounts#<br />
							tablenumber: #TBLNUM#
							</font>
							</td>	
				
<!---						</cfif>--->
					
										
					</cfif>

			</cfloop>
	</tr>
	<cfset thisHour = thisHour + oneHr>
	</cfloop>
		
	
</table>
</div>
<p>
</cfoutput>

</cfloop>
