
<cfparam name="ImageHere" default=""> 


<cfif #form.ImageURL# GT "">
	<cffile action="UPLOAD"
        filefield="Imageurl"
        destination="#GetDirectoryFromPath(GetBaseTemplatePath())#"
        nameconflict="OVERWRITE">
		<cfset ImageHere = #file.ServerFile#>
</cfif>

<cfquery datasource="#ds#">
	UPDATE 	Larps
		SET ADDLCOMMENTS = '#FORM.ADDLCOMMENTS#',
			EMAIL_ADDRESS = '#form.email_address#',
			GAME_SYSTEM = '#form.GAME_SYSTEM#',
			GAME_TITLE = '#form.GAME_TITLE#',
			<cfif ImageHere GT "">
			IMAGEURL = '#IMAGEHERE#',
			</cfif>
			GM_NAME = '#form.GM_NAME#',
			GM_NAMES = '#form.GM_NAMES#',
			MAXPLAYERS = '#form.MAXPLAYERS#',
			MINPLAYERS = '#form.MINPLAYERS#',
			SYNOPSIS = '#form.SYNOPSIS#',
			WEBSITE = '#form.WEBSITE#',
			<cfif IsDate(Form.DateOFLARP)>
			DATEOFLARP = #CREATEODBCDATE(FORM.DATEOFLARP)#,
			</cfif>
			DATEOFLARPSTRING = '#FORM.DATEOFLARPSTRING#',
			LENGTHOFGAME = #FORM.LENGTHOFGAME#,
			APPROVED = <cfif IsDefined("form.Approved")>1<cfelse>0</cfif>
	WHERE LARPID = #FORM.LARPID#
			

</cfquery>


<!---<cfif isDefined("form.Approved")>

 	<cfset TwitterStatus = "New LARP Posted! " & form.GAME_TITLE & " / " & #form.GM_NAME# & " http://tinyurl.com/l9hyz4 ##necrocon09">
	
	<cfset TwitterStatus = Left(TwitterStatus, 140)>
	<cfset twitterObj = createObject('component', 'twitterCFC').init('NecroStonechat','yell0wc@p') />
	<cfset twitterObj.postToTwitter("#TwitterStatus#") />
	<cfset twitterObj = createObject('component', 'twitterCFC').init('gaming@stonehill.org','n3cr0n0m1c0n') />
	<cfset twitterObj.postToTwitter("#TwitterStatus#") />

</cfif>--->
