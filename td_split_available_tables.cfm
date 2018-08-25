<Cfif showstuff>
<h1>td_split_available_tables</h1>
</cfif>

 <cfquery name="AvailableTablesAtThisHour" datasource="#ds#">
 SELECT TableAssignment.[Table], COUNT(idNumber) as HourCount
 FROM TableAssignment
 WHERE (((TableAssignment.room)='#mroomname#')
 AND ((TableAssignment.TIMESLOT) BETWEEN #CreateODBCDateTime(thisHour)# AND #DateAdd("n", -1, DateAdd("h", (thisgame.LengthOfGame), thisHour))#)
 AND ((TableAssignment.USEDBY)=0))
 GROUP BY [Table]
Having Count(idNumber) = #thisGame.LengthOfGame#
  ORDER BY [Table]
 ;
 </cfquery>

<!---
AND #CreateODBCDateTime(thisGame.SessionEnds)#)
<Cfquery name="testQ" datasource="#ds#">
select * from TableAssignment
</cfquery>
--->

<cfif showstuff>
<cfdump var="#thisGame#">
AvailableTablesAtThisHour<br>
<cfdump var="#AvailableTablesAtThisHour#">
</cfif>

 <cfset AR = ValueList(AvailableTablesAtThisHour.Table)>

<cfset ARLen = ListLen(AR)>

<cfset Tablesets = ArrayNew(1)>
<cfset nt = ArraySet(Tablesets,1,20, "")>

<cfloop index="x" from="#ARLen#" to="1" step="-1">
	<cfloop list="#AR#" index="ari">
		<cfset goodset = true>

		<cfloop index="tc" from="1" to="#x#" step="1">
			<cfset goodset = goodset and (ListFind(AR, tostring(ari + tc - 1)) gt 0)>
		</cfloop>

		<cfif goodset is true>
			<cfset Tablesets[x] = ListAppend(Tablesets[x], ari) >
		</cfif>
	</cfloop>
</cfloop>
