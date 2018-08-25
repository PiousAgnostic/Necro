

<cfset KnowledgeList = ArrayNew(1)>

<cfset temp = ArraySet(KnowledgeList, 1,17, "")>

<!--- set some elements --->
<cfset KnowledgeList[1] = "The Keeper of Deep Secrets">
<cfset KnowledgeList[2] = "Heir to Obscure Knowledge">
<cfset KnowledgeList[3] = "Holder of the Golden Key">
<cfset KnowledgeList[4] = "A 75<sup>&deg;</sup> Illiminatus">
<cfset KnowledgeList[5] = "A Knight of the Silver Veil">
<cfset KnowledgeList[6] = "A Distressed Worthy Brother">
<cfset KnowledgeList[7] = "The Ancient Container of Woe">
<cfset KnowledgeList[8] = "A Whisperer of Incantations">
<cfset KnowledgeList[9] = "An Escapee from Arkam">
<cfset KnowledgeList[10] = "The Dweller in the Well">
<cfset KnowledgeList[11] = "A Shadow Beyond Time">
<cfset KnowledgeList[12] = "Exsanguinated and Thirsty">
<cfset KnowledgeList[13] = "The Knower of the Way">
<cfset KnowledgeList[14] = "A Golden Bowl To Be Broken">
<cfset KnowledgeList[15] = "The Room Without Door or Window">
<cfset KnowledgeList[15] = "Who Am">
<cfset KnowledgeList[16] = "The Dreamer in the Deep">
<cfset KnowledgeList[17] = "A Scrivner of Spells">
<!--- <cfset i = Randomize()> --->

<cfset ShowList = "">

<cfloop condition="(ListLen(ShowList) LT 4)">
	<cfset i = Int(Rand() * ArrayLen(KnowledgeList)) + 1>
	
	<cfif ListContains(ShowList, i) EQ 0>
		<cfset ShowList = ListAppend(ShowList, i)>
	</cfif>

</cfloop>

<cfif ListContains(ShowList, 13) NEQ 0>
	<script language="JavaScript">
		
		function toggleDisplay(gid) 
		{ 
			if (document.getElementById(gid) != null)
			{
			
				if (document.getElementById(gid).style.display)
				{
					if ( document.getElementById(gid).style.display == "block" ) 
						 document.getElementById(gid).style.display = "none"
					else 
						document.getElementById(gid).style.display = "block"; 
				}
				else
				{
					document.getElementById(gid).style.display = "none"; 
				}
			}
		}
	</script>
</cfif>

<table>

	<cfset IAM = TRUE>
	<cfloop list="#ShowList#" Index="i">
<tr>	
	<td><font size="+1"><CFIF IAM>I am:<CFSET IAM = FALSE></cfif></td>
	<td><font size="+1">
		<cfoutput><input type="radio" name="areyou" value="#I#" <cfif I EQ 13>onClick='toggleDisplay("secretknowledge")'</cfif>>#KnowledgeList[Val(i)]#</cfoutput></td>
</tr>	
	</cfloop>
<tr>
	<td>&nbsp;</td>
	<td><cfoutput><button onClick="document.location='#thisfile#'"style="font-size: 10px;">Or Am I</button></cfoutput></td>
</tr>	
	
</table>
<p>

<p>
<cfif ListContains(ShowList, 13) NEQ 0>
<div id="secretknowledge" style="display: none">
<form action="<cfoutput>#thisfile#</cfoutput>" method="post">
<font size="-1">Choose wisely, Traveler</font><br>
<input type="password" NAME="secretword" size="12" maxlength="12" style="font-size: 10px;">
<input type="submit" name="Enter" value="Enter" style="font-size: 10px;">
</form>
</div>
</cfif>
</font>
