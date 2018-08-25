
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!--
Design by Free CSS Templates
http://www.freecsstemplates.org
Released for free under a Creative Commons Attribution 2.5 License

Name       : StylePrecision
Description: A two-column, fixed-width design with dark color scheme.
Version    : 1.0
Released   : 20130720

-->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<title><cfoutput>#SESSION.CONVENTIONNAME#</cfoutput> Gaming Site</title>
<link href='http://fonts.googleapis.com/css?family=Open+Sans:400,300,600,700|Open+Sans+Condensed:300,700' rel='stylesheet' type='text/css'>
<link href="styles/style.css" rel="stylesheet" type="text/css" media="screen" />
<link href="styles/fonts.css" rel="stylesheet" type="text/css" media="all" />
<!---<script type="text/javascript" src="jquery-1.7.1.min.js"></script>--->
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.0/jquery.min.js"></script>
<script src="assets/javascripts/socialProfiles.min.js"></script>
<script type="text/javascript" src="jquery.slidertron-1.1.js"></script>

<script type="text/javascript">
function testURL(url)
{

	var h = (screen.availHeight - 200);
	var w = (screen.availWidth - 100);
	window.open(url,"Test", "toolbar,status,scrollbars,resizable,height="+h.toString()+",width="+w.toString()+",left=50,top=50");
}
</script>


<CFQUERY name="avid" datasource="#ds#" dbtype="ODBC" cachedWithin="#CreateTimeSpan(0,0,10,0)#">
SELECT TOP 1 CONVENTIONDATE, DropDeadDate, ConventionName, ConventionEnds, Announcement, ParticipationText, LarpText, HOURSFORFREE, lastgametime
	FROM ADMIN
</CFQUERY>

<script language="javascript">
	function testURL(url)
	{

		var h = (screen.availHeight - 100);
		var w = (screen.availWidth - 100);
		window.open(url,"Test", "scrollbars,resizable,height="+h.toString()+",width="+w.toString()+",left=50,top=50");
	}

	function checkage()
	{
		//alert ("|" + document.gmform.over18.value + "|" )

		if (document.gmform.over18.value == "")
		{
				alert("Please indicate if you are 18 or older.")
			return false
		}
		else return checkEmail()
	}

	function checkEmail() {
	if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,4})+$/.test(document.gmform.email.value)){
	return (true)
	}
	alert("Invalid E-mail Address! Please re-enter.")
	return (false)
	}

	function show_image(image)
	{

		var h = 250;
		var w = 500;
		var img = new Image();
		img.src = image;

		h = img.height+20;
		w = img.width+50;
		var x = screen.width / 2 - w / 2;
		var y = screen.height / 2 - h / 2;

		if (x <= 0)
			x = 1;
		if (y <=0)
			y = 1;

		w = window.open("","Test", "resizable,height="+h.toString()+",width="+w.toString()+",left="+x.toString()+",top="+y.toString());
		w.document.write("<html><body bgcolor='Black'><center>");
		w.document.write("<img src='" + image + "' BORDER='0'></body></html>");

	}

</script>



<!---<cfif Not isDefined("form.fromIndex")>
	<cflocation url="gmindex.cfm" addtoken="No">
</cfif>



<CFIF Not isDefined("SESSION.GMINDEX") OR
	  (SESSION.GMINDEX NEQ SESSION.SESSIONNUMBER)>
	<cflocation url="gmindex.cfm" addtoken="No">
</cfif>--->

<CFIF Not isDefined("SESSION.LOGGEDINGMN") and Not isDefined("form.fromIndex") and not isDefined("LoginEmail")>
	<cflocation url="gmindex.cfm" addtoken="No">
</cfif>
<cfset tempvariable = StructDelete(session,"GMINDEX")>

<cfset SESSION.GMFORM = SESSION.SESSIONNUMBER>

<cfparam name="LoginEmail" default="">

<cfparam name="GMId" default="-1">
<cfparam name="LLastName" default="">
<cfparam name="LMiddleName" default="">
<cfparam name="LFirstName" default="">
<cfparam name="LAlias" default="">
<cfparam name="LAddress1" default="">
<cfparam name="LAddress2" default="">
<cfparam name="LCity" default="">
<cfparam name="LState" default="">
<cfparam name="LZip" default="">
<cfparam name="LTelephone" default="">
<cfparam name="Lemail" default="#LoginEmail#">
<cfparam name="LemailVisable" default="1">
<cfparam name="LHomepage" default="">
<cfparam name="LPassword" default="">
<cfparam name="Lover18" default="">
<cfparam name="LClubID" default="-1">

<cfif IsDefined("session.LOGGEDINGMN")>
	<CFQUERY name="GM" datasource="#ds#" dbtype="ODBC">
		SELECT * FROM [Game Masters]
		WHERE gmid = #SESSION.LOGGEDINGMN#
	</cfquery>
	<cfif #GM.RecordCount# EQ 1>
		<cfset GMId = #GM.GMId#>
		<cfset LLastName = #trim(GM.LastName)#>
		<cfset LMiddleName = #GM.MiddleName#>
		<cfset LFirstName = #trim(GM.FirstName)#>
		<cfset LAlias = #GM.Alias#>
		<cfset LAddress1 = #GM.Address1#>
		<cfset LAddress2 = #GM.Address2#>
		<cfset LCity = #GM.CIty#>
		<cfset LState = #GM.State#>
		<cfset LZip = #GM.Zip#>
		<cfset LTelephone = #GM.Telephone#>
		<cfset Lemail = #trim(GM.email)#>
		<cfset LemailVisable = #GM.emailVisable#>
		<cfset LHomepage = #GM.HomePage#>
		<cfset LPassword = #GM.Password#>
		<cfset Lover18 = #GM.over18#>
		<cfif GM.CLUBID NEQ "">
			<cfset LClubID = #GM.CLUBID#>
		</cfif>


	<cfelse>
		<cflocation url="gmindex.cfm" addtoken="No">
	</cfif></cfif>

<!--- ---			   --->




<cfquery name="clubinfo" datasource="#ds#">
	select * from clubs where clubid = #LClubID#
</cfquery>

</head>
<body>
<div id="wrapper">
	<div id="page" class="container">
		<div id="header" class="container">
			<div id="logo">
				<h1><a href="#"><cfoutput>#SESSION.CONVENTIONNAME#</cfoutput></a></h1>
			</div>

<cfinclude template="menu.cfm">


		</div>
		<div id="banner">
			<div id="slider">
				<div class="viewer">
					<div class="reel">
						<div class="slide"> <img src="images/2013-1.jpg" alt="" /> </div>
						<div class="slide"> <img src="images/2013-3.jpg" alt="" /> </div>
						<div class="slide"> <img src="images/2013-4.jpg" alt="" /> </div>
						<div class="slide"> <img src="images/2013-2.jpg" alt="" /> </div>
					</div>
				</div>
			</div>
			<script type="text/javascript">
				$('#slider').slidertron({
					viewerSelector: '.viewer',
					reelSelector: '.viewer .reel',
					slidesSelector: '.viewer .reel .slide',
					advanceDelay: 4000,
					speed: 'slow'
				});
			</script>
		</div>



		<div id="content">

 			<div class="title">
				<h2>Personal Information </h2>
				<span class="byline">Please Enter and/or Review your info</span>
			</div>
			<p>
				<div class="announcement">


<cfform action="addgmform.cfm" method="post" name="gmform" onSubmit="return checkage()">

<cfoutput>

<input type="hidden" name="GMid" value="#GMId#">

<table>
	<tr valign="top">
		<td valign="top">First Name</td>
		<td valign="top"><cfinput type="Text" name="FirstName" value="#LFirstName#" message="You Must enter your First Name" required="Yes" size="20">

&nbsp;
			<cfif clubinfo.recordcount EQ 0>
				<font size="-1"><!---<a href="http://www.rjritchie.com/gameforums/index.php?topic=62.0" target="_blank">---><i>you are not a member of a club</i></a></font>

			<cfelse>
					<CFIF clubinfo.CLUBICON GT ''>
						<cfif clubinfo.CLUBGRAPHIC GT ''>
							<A HREF="javascript:show_image('clubs/clubimages/#clubinfo.CLUBGRAPHIC#')">
							<img align="top" src="clubs/clubimages/#clubinfo.CLUBICON#" border="0" title="#clubinfo.CLUBNAME#">
							</a>
						</cfif>
					</CFIF>
			</cfif>


		</td>
	</tr>
	<tr>
		<td>Middle Name</td>
		<td><input type="text" name="MiddleName" size="20" value="#LMiddleName#"></td>
	</tr>
	<tr>
		<td>Last Name</td>
		<td><cfinput type="Text" name="LastName" value="#LLastName#" message="You Must enter your Last Name" required="Yes" size="20"></td>
	</tr>
	<tr>
		<td>Password</td>
		<td>
			<cfinput type="Password" name="Password" value="#LPassword#" size="20">
			&nbsp;<font>Be sure to safeguard your password</font>
		</td>
	</tr>

	<tr>
		<td>Alias</td>
		<td><input type="text" name="Alias" size="20" value="#LAlias#">
			&nbsp;If you like to game under a nickname, please enter it here.

		</td>
	</tr>
	<tr>
		<td>Address Line 1</td>
		<td><input type="text" name="Address1" size="40" value="#LAddress1#"></td>
	</tr>
	<tr>
		<td>Address Line 2</td>
		<td><input type="text" name="Address2" size="40" value="#LAddress2#"></td>
	</tr>
	<tr>
		<td>City</td>
		<td><input type="text" name="City" size="20" value="#LCity#"></td>
	</tr>
	<tr>
		<td>State</td>
		<td><input type="text" name="State" size="2" value="#LState#"></td>
	</tr>
	<tr>
		<td>Zip</td>
		<td><input type="text" name="Zip" size="10" value="#LZip#"></td>
	</tr>
	<tr>
		<td>Telephone</td>
		<td><cfinput type="Text" name="telephone" value="#LTelephone#" message="You must enter your Telephone Number" required="Yes" size="20"></td>
	</tr>
	<tr style="display: none">
		<td>email</td>
		<td><cfinput type="Text" name="email" value="#Lemail#" message="You must enter your email address" required="Yes" size="40"></td>
	</tr>
	<tr>
		<td>Do you want your<br>email address to<br>be listed?</td>
		<td><select name="emailVisable" size="1">
				<option value="1" <Cfif #LemailVisable# NEQ 0>selected</cfif>>Yes</option>
				<option value="0" <Cfif #LemailVisable# EQ 0>selected</cfif>>No!</option>
			</select>

		</td>
	</tr>

	<tr>
		<Td>Are you 18+<br>years old?</td>
		<td>
			<select name="over18" size="1">
				<option value=""></option>
				<option value="0" <cfif Lover18 EQ "No">selected</cfif>>No</option>
				<option value="1" <cfif Lover18 EQ "Yes">selected</cfif>>Yes</option>
			</select>&nbsp; You must be 18 years old or older in order to volunteer.
		</td>
	</tr>
	<tr>
		<td>HomePage</td>
		<td><input type="text" name="homePage" size="40" value="#LHomepage#">
			&nbsp;<input type="button" name="Test" value="Test URL" onClick="testURL(document.gmform.homePage.value)">
		</td>
	</tr>


	<tr>
		<td colspan="2" align="center">
			<input type="submit" name="fromGMForm" value="Continue">
			<input type="Reset">
		</td>
	</tr>


</table>
<p>
<b>Review the <a href="guidelines.cfm?review="Yes"">GM Guidelines</a>.</b>





</cfoutput>

</cfform>

<cfoutput query="clubinfo">
<img src="clubs/clubimages/#CLUBgraphic#" style="display:none">

</cfoutput>


</div>
			 </p>
		</div>
	</div>
	<!-- end #page -->
</div>
<div id="footer">
	<p>Copyright (c) 2013 rjritchie.com. All rights reserved. | Design by <a href="http://www.freecsstemplates.org/" rel="nofollow">FreeCSSTemplates.org</a>.</p>
</div>
<!-- end #footer -->
</body>
</html>

