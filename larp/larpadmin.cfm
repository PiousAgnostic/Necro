
<cfquery datasource="#ds#" name="Larps">
	SELECT * FROM Larps
	Order by APPROVED DESC, DATEOFLARP,  LarpID
</cfquery>

<cfquery datasource="#ds#" name="Dates">
	SELECT [DATE] FROM ConventionDays
	Order by [Date]
</cfquery>

<cfif Larps.RecordCount EQ 0>
<FONT SIZE="+1">There are currently no Larps in the System</font>
</cfif>

<script language="javascript">


function checkTime(b)
{
	
	var tm = b.value.toUpperCase()
	var good = false
	var p
	
	if ((tm.indexOf("PM-") >0))
	{

		p = tm.indexOf("PM-")
		
		tm = tm.substring(0, p+2) + " -" + tm.substring(p+3, tm.length)
	}		
	if ((tm.indexOf("AM-") >0))
	{

		p = tm.indexOf("AM-")
		
		tm = tm.substring(0, p+2) + " -" + tm.substring(p+3, tm.length)
	}		
	
	if ((tm.indexOf("PM - ") == -1) && (tm.indexOf("PM -") >0))
	{
		p = tm.indexOf("PM -")
		
		tm = tm.substring(0, p+4) + " " + tm.substring(p+4, tm.length)
	}

	
	if ((tm.indexOf("AM - ") == -1) && (tm.indexOf("AM -") >0))
	{
		p = tm.indexOf("AM -")
		
		tm = tm.substring(0, p+4) + " " + tm.substring(p+4, tm.length)
	}	

	
	if ((tm.substring(1,5) == "PM -") && !isNaN(tm.substring(0,1)))
		good = true
	if ((tm.substring(1,5) == "AM -") && !isNaN(tm.substring(0,1)))
		good = true	
	if ((tm.substring(2,6) == "PM -") && !isNaN(tm.substring(0,2)))
		good = true
	if ((tm.substring(2,6) == "AM -") && !isNaN(tm.substring(0,2)))
		good = true		
	
	if (!good)
	{
		alert('There is something wrong with the time.')
		b.focus()	
	}

	
	b.value = tm

}

function fixTime(f)
{
	f.DATEOFLARPSTRING.value = f.beginTime.value + " - " + f.endTime.value

}

</script>


<cfoutput query="Larps">

<form action="#thisfile#" method="post" enctype="multipart/form-data" name="lform" id="lform" onSubmit="fixTime(this)">
	<input type="Hidden" name="LarpID" value="#LarpID#">
	<table width="100%" border="1" cellpadding="2" 
		<cfif Approved EQ 1>bgcolor=##00CCFF</cfif>
	>
	  <TR>
	    <TD valign="bottom" align="left">
		<cfif (#imageurl# GT "")>
			<table align="left">
			<tr><td align="center">
				<A href="#imageurl#" target="_blank">
					<img src="#imageurl#"  BORDER="0" width="250px">
				</a>
			</td></tr>
			<tr>
				<td>
					<input type="file" name="ImageURL" size="50" accept="image/gif,image/jpeg,image/x-MS-bmp"><br>
					<font size="-1">Images will be displayed 250 pixels wide</font>
				</td>
			</tr>			
			</table>
		<cfelse>
			<table align="right">
				<tr>
					<td><b>Image</b><br>
						<input type="file" name="ImageURL" size="50" accept="image/gif,image/jpeg,image/x-MS-bmp"><br>
						<font size="-1">Images will be displayed 250 pixels wide</font>
					</td>
				</tr>
			</table>		
		</cfif>
		</TD>
	</TR>
	<TR>
	    <TD><font size="+1">Game Title</font></TD>
	    <TD><font size="+1"><input type="text" name="Game_Title" value="#GAME_TITLE#" size="60" maxlength="255"></font>&nbsp<input type="submit" name="SAVELARP" value="Save"></TD>
	  </TR>
	  <TR>
	  	<TD><font size="+1">Game System</font></TD>
		<TD><font size="+1"><input type="text" name="GAME_SYSTEM" value="#GAME_SYSTEM#" size="60" maxlength="255">&nbsp;<input type="submit" name="DELETELARP" value="Delete" onClick="return confirm('Are you sure you want to delete this LARP?');"></font></TD>
	  </TR>
	  <TR>
		<TD><font size="+1">Recomended ## of Players<br>Max ## of Players</font></TD>
	    <TD><font size="+1"><input type="Text" name="MINPLAYERS" value="#MINPLAYERS#" size="4" maxlength="4"><br>
							<input type="Text" name="MAXPLAYERS" value="#MAXPLAYERS#" size="4" maxlength="4"></font></TD>
	  </TR>
	  <tr>
	  		<td valign="top"><font size="+1">Requested Times</font></td>
			<td><font size="+1">#DATE_TIME_REQ_1#<br>#DATE_TIME_REQ_2#<br>#DATE_TIME_REQ_3#</font></td>
	  </tr>
	  <TR>
		<TD valign="top"><font size="+1">Assigned 	Time<br></font><font size="-1">(Appears on Schedule)</font></TD>
	    <TD>
		<font size="+1"><input type="hidden" name="DATEOFLARPSTRING" value="#DATEOFLARPSTRING#"  size="60" maxlength="255"></font>
		
		<CFSET lbeginTime = "">
		<cfset lendTime = "">
		<cfif DATEOFLARPSTRING GT "">
		
			<cfset bt = TRIM(left(DATEOFLARPSTRING, 4))>
			<CFSET et = TRIM(RIGHT(DATEOFLARPSTRING, 4))>
			
			<CFSET lbeginTime = VAL(BT) + IIF(FIND("PM",BT) GT 0, 12, 0)>
			<CFSET lendTime = VAL(ET) + IIF(FIND("PM",ET) GT 0, 12, 0)>		
		</cfif>		
		
		
		<select name="beginTime">
			<cfloop index="i" from="1" to="24">
				<option  <cfif i eq lbeginTime>selected</cfif>><cfif i LT 12>#i#AM<cfelseif i eq 12>12PM<cfelseif i lt 24>#evaluate("i-12")#PM<cfelse>12AM</cfif></option>
			</cfloop>		
		</select>
		&nbsp;-&nbsp;
		<select name="endTime">
			<cfloop index="i" from="1" to="24">
				<option  <cfif i eq lendTime>selected</cfif>><cfif i LT 12>#i#AM<cfelseif i eq 12>12PM<cfelseif i lt 24>#evaluate("i-12")#PM<cfelse>12AM</cfif></option>
			</cfloop>		
		</select>
		</TD>
	  </TR>
	  <tr>
	   	<td><font size="+1">Length of Game</font></td>
	  	<td>
			<select name="LengthOfGame">
				<cfloop index="i" from="1" to="12">
					<option <cfif i eq LengthOfgame>selected</cfif> value="#i#">#i# hour<cfif i GT 1>s</cfif>
				</cfloop>
			</select>
		</td>
	  
	  </tr>	  
	   <tr>
	   		<td><font size="+1">Select Day</font><font size="-1"><br>(for sorting)</font></font></td>
			<td>
				<CFSET COMPAREDATE = DateFormat(DATEOFLARP, "dddd")>
				<select name="DATEOFLARP" size="1">
					<option value=""></option>
					<cfloop query="Dates">
						<option value="#Date#" <cfif COMPAREDATE eq #DateFormat(Date, "dddd")#>selected</cfif>>#DateFormat(Date, "dddd")#</option>					
					</cfloop>
				</select>
			&nbsp;<font size="+1">
				<input type="checkbox" name="Approved" value="1"
					<cfif Approved eq 1>checked</cfif>>Approved for Schedule
			</td>
	   </tr>	  
	  <TR>
		<TD valign="top"><font size="+1">Game Master(s)</font></TD>
	    <TD><input type="text" name="GM_NAME" value="#GM_NAME#" size="60" maxlength="255"><br>
			<textarea name="GM_NAMES" cols="50" rows="3">#GM_NAMES#</textarea></TD>
	  </TR>
	  <TR>
	  	<TD><font size="+1">Email</font></TD>
		<TD><font size="+1"><input type="text" name="EMAIL_ADDRESS" value="#EMAIL_ADDRESS#" size="60" maxlength="255"></font></TD>
	  </TR>	  
	  <TR >
	  	<td valign="top"><font size="+1">Synopsis</font></td>
	    <TD >
			<textarea name="SYNOPSIS" cols="50" rows="5">#SYNOPSIS#</textarea>
		</TD>
	   </TR>
	  <TR >
	  	<td valign="top"><font size="+1">Add'l Comments</font></td>
	    <TD >
			<textarea name="ADDLCOMMENTS" cols="50" rows="5">#ADDLCOMMENTS#</textarea>
		</TD>
	   </TR>	   
	  <TR >
	  	<TD><font size="+1">Space Requirements</font></td>
	    <TD >
			<B>
			#SPACEREQ#
			</b>
		</TD>
	   </TR>
	  <TR>
	  	<TD><font size="+1">Game Web Site</font></TD>
		<TD><font size="+1"><input type="text" name="WEBSITE" value="#WEBSITE#" size="60" maxlength="255"></font></TD>
	  </TR>
	</TABLE>
</form>
</cfoutput>
<hr />
<cfoutput>
	<h2>Add New Game </h2>
	<form action="#thisfile#" method="post" enctype="multipart/form-data" name="nform" id="nform" onSubmit="fixTime(this)">

	<table width="100%" border="1" cellpadding="2">
	  <TR>
	    <TD valign="bottom" align="left">
			<table align="right">
				<tr>
					<td><b>Image</b><br>
						<input type="file" name="ImageURL" size="50" accept="image/gif,image/jpeg,image/x-MS-bmp"><br>
						<font size="-1">Images will be displayed 250 pixels wide</font>
					</td>
				</tr>
			</table>		
		</TD>
	</TR>
	<TR>
	    <TD><font size="+1">Game Title</font></TD>
	    <TD><font size="+1"><input type="text" name="Game_Title" value="" size="60" maxlength="255"></font>&nbsp<input type="submit" name="NEWLARP" value="Save"></TD>
	  </TR>
	  <TR>
	  	<TD><font size="+1">Game System</font></TD>
		<TD><font size="+1"><input type="text" name="GAME_SYSTEM" value="" size="60" maxlength="255"></font></TD>
	  </TR>
	  <TR>
		<TD><font size="+1">Recomended ## of Players<br>Max ## of Players</font></TD>
	    <TD><font size="+1"><input type="Text" name="MINPLAYERS" value="" size="4" maxlength="4"><br>
							<input type="Text" name="MAXPLAYERS" value="" size="4" maxlength="4"></font></TD>
	  </TR>

	  <TR>
		<TD valign="top"><font size="+1">Assigned 	Time<br></font><font size="-1">(Appears on Schedule)</font></TD>
	    <TD>
		

		
		<select name="beginTime">
			<cfloop index="i" from="1" to="24">
				<option  ><cfif i LT 12>#i#AM<cfelseif i eq 12>12PM<cfelseif i lt 24>#evaluate("i-12")#PM<cfelse>12AM</cfif></option>
			</cfloop>		
		</select>
		&nbsp;-&nbsp;
		<select name="endTime">
			<cfloop index="i" from="1" to="24">
				<option  ><cfif i LT 12>#i#AM<cfelseif i eq 12>12PM<cfelseif i lt 24>#evaluate("i-12")#PM<cfelse>12AM</cfif></option>
			</cfloop>		
		</select>
		</TD>
	  </TR>
	  <tr>
	   	<td><font size="+1">Length of Game</font></td>
	  	<td>
			<select name="LengthOfGame">
				<cfloop index="i" from="1" to="12">
					<option value="#i#">#i# hour<cfif i GT 1>s</cfif>
				</cfloop>
			</select>
		</td>
	  
	  </tr>	  
	   <tr>
	   		<td><font size="+1">Select Day</font><font size="-1"><br>(for sorting)</font></font></td>
			<td>
				<select name="DATEOFLARP" size="1">
					<option value=""></option>
					<cfloop query="Dates">
						<option value="#Date#" >#DateFormat(Date, "dddd")#</option>					
					</cfloop>
				</select>
		</td>
	   </tr>	  
	  <TR>
		<TD valign="top"><font size="+1">Game Master(s)</font></TD>
	    <TD><input type="text" name="GM_NAME" value="" size="60" maxlength="255"><br>
			<textarea name="GM_NAMES" cols="50" rows="3"></textarea></TD>
	  </TR>
	  <TR>
	  	<TD><font size="+1">Email</font></TD>
		<TD><font size="+1"><input type="text" name="EMAIL_ADDRESS" value="" size="60" maxlength="255"></font></TD>
	  </TR>	  
	  <TR >
	  	<td valign="top"><font size="+1">Synopsis</font></td>
	    <TD >
			<textarea name="SYNOPSIS" cols="50" rows="5"></textarea>
		</TD>
	   </TR>
	  <TR >
	  	<td valign="top"><font size="+1">Add'l Comments</font></td>
	    <TD >
			<textarea name="ADDLCOMMENTS" cols="50" rows="5"></textarea>
		</TD>
	   </TR>	   

	  <TR>
	  	<TD><font size="+1">Game Web Site</font></TD>
		<TD><font size="+1"><input type="text" name="WEBSITE" value="" size="60" maxlength="255"></font></TD>
	  </TR>
	</TABLE>
</cfoutput>	
</form>

