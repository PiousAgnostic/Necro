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

<style type="text/css">
.image {
   position: relative;
   width: 100%; /* for IE 6 */
}


.NumLikes {
   position: absolute;
   top: 10px;
   left: 15px;
   width: 100%;
   font-size:14px;
   font-weight:bold;
   color:#FF0000;
}
</style>

<script language="JavaScript" src="cookie.js"></script>
<script language="JavaScript">
// this cookie NEVER expires
var psched = new Cookie(document, "psched",120);

psched.load();

function onBoxClick(box, num)
{
	if (box.checked)
	{
		eval("psched.g" + num + "= 1")
	}
	else
	{
		eval("psched.g" + num + "= 0")
	}

	psched.store();
}

	function adjustImages()
	{
		var i;
		var img;
		var ratio;
		var imgwidth = 100;

	  if (navigator.appVersion.indexOf("4.") != -1 &&
	      navigator.appName.indexOf("Explorer") != -1) {
	     imgwidth = screen.width / 2.5;
	  }
	  if (navigator.appVersion.indexOf("4.") != -1 &&
	      navigator.appName.indexOf("Netscape") != -1) {
	     imgwidth = screen.width / 2.5;
  }

	  if (navigator.appVersion.indexOf("5.") != -1 &&
	      navigator.appName.indexOf("Netscape") != -1)
	  {
	     imgwidth = screen.width / 2.5;
 	  }

		for (i = 0; i < document.images.length; i++)
		{
			img = document.images[i];

			// if (img.noadj != "Yes")
			if (img.id != "pagetitle")
			{
				if (img.width > imgwidth)
				{
					ratio = imgwidth / img.width;
					img.width = imgwidth;
					img.height = img.height * ratio;
				}

				if (img.height > imgwidth)
				{
					ratio = imgwidth / img.height;
					img.height = imgwidth;
					img.width = img.width * ratio;
				}
			}
		}
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

	function testURL(url)
	{

		var h = (screen.availHeight - 200);
		var w = (screen.availWidth - 100);
		window.open(url,"Test", "toolbar,status,scrollbars,resizable,height="+h.toString()+",width="+w.toString()+",left=50,top=50");
	}

	function openPersonalSchedule(url)
	{

		var h = (screen.availHeight - 400);
		var w = (screen.availWidth - 400);
		var l = (screen.availWidth / 2) - (w / 2)
		window.open(url,"Test", "toolbar,menubar,status,scrollbars,resizable,height="+h.toString()+",width="+w.toString()+",left="+l.toString()+",top=50");
	}

var XMLHttpRequestObject = false;
if (window.XMLHttpRequest)  {
								XMLHttpRequestObject = new XMLHttpRequest();
							}
else if (window.ActiveXObject) {
								  XMLHttpRequestObject = new ActiveXObject("Microsoft.XMLHTTP");
								}

  function showGameDesc(gameid)
  {

		if(XMLHttpRequestObject)
		{

			var b = "GAMEDESCArea" + gameid;
			var lookupURL = "inlineGameDesc.cfm?GameID=" + gameid
			var obj = document.getElementById(b);
			var rtext

			if (obj.innerHTML.length <= 5)
			{

			XMLHttpRequestObject.open("GET", lookupURL,1);
			XMLHttpRequestObject.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			XMLHttpRequestObject.onreadystatechange = function()
				{
					if (XMLHttpRequestObject.readyState == 4) {
							rtext = XMLHttpRequestObject.responseText;
                            obj.innerHTML = rtext;
                           }
				}
			XMLHttpRequestObject.send(null);
			}
			else
				obj.innerHTML = ""
		}

		else testURL("popup_game.cfm?GameID=" + gameid)
	}

	if (typeof String.prototype.endsWith !== 'function') {
		String.prototype.endsWith = function(suffix) {
			return this.indexOf(suffix, this.length - suffix.length) !== -1;
		};
	}

	function GameInterest(gameid)
	{

		var likes = document.getElementById("NumLikes" + gameid);
		var img = document.getElementById("likegameimg" + gameid);
		var emptyimg = "images/green_thumb_off.gif";
		var shineimg = "images/green_thumb.gif";

		//alert(likes.innerHTML);

		var numlikes = likes.innerHTML;
		if (numlikes == "")
			numlikes = 0;

		if (img.src.endsWith(emptyimg))
		{
			//alert("empty -> shine");
			img.src = shineimg;
			img.title ="Unlike";
			likevalue = "Like";
			numlikes = parseInt(numlikes) + 1;
		}
		else
		{
			//alert("shine -> empty");
			img.src = emptyimg;
			img.title = "Like";
			likevalue = "Unlike";
			numlikes = parseInt(numlikes) - 1;
			if (numlikes == 0)
				numlikes = "";
		}

		likes.innerHTML = numlikes;
		//alert(likes.innerHTML);


		var XMLHttpRequestObjectB = false;
		if (window.XMLHttpRequest)  {
										XMLHttpRequestObjectB = new XMLHttpRequest();
									}
		else if (window.ActiveXObject) {
										  XMLHttpRequestObjectB = new ActiveXObject("Microsoft.XMLHTTP");
										}

//		likevalue = 	obj.innerHTML;
//
//		if (likevalue == "Like")
//			obj.innerHTML = "Unlike";
//		else
//			obj.innerHTML = "Like";


//		if (


//		obj.disabled = true


		if(XMLHttpRequestObjectB)
		{

			var lookupURL = "registerGameInterest.cfm?GameID=" + gameid + "&LIKEVALUE=" + likevalue;

			var obj = document.getElementById("showresults");
			var rtext


			XMLHttpRequestObjectB.open("GET", lookupURL,1);
			XMLHttpRequestObjectB.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			XMLHttpRequestObjectB.onreadystatechange = function()
				{
					if (XMLHttpRequestObjectB.readyState == 4) {
							rtext = XMLHttpRequestObjectB.responseText;
							 obj.innerHTML = rtext;
                           }
				}
			XMLHttpRequestObjectB.send(null);

		}

	}
</script>


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
						<div class="slide"> <img src="images/sched-1.jpg" alt="" /> </div>
						<div class="slide"> <img src="images/sched-3.jpg" alt="" /> </div>
						<div class="slide"> <img src="images/sched-2.jpg" alt="" /> </div>
						<div class="slide"> <img src="images/sched-6.jpg" alt="" /> </div>
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
				<h2>Game Schedule</h2>
				<span class="byline">View By GM</span>
			</div>
			<p>

<!--BEGINNING OF SCHEDULE-->

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

<style type="text/css">
.image {
   position: relative;
   width: 100%; /* for IE 6 */
}


.NumLikes {
   position: absolute;
   top: 10px;
   left: 15px;
   width: 100%;
   font-size:14px;
   font-weight:bold;
   color:#FF0000;
}
</style>

<script language="JavaScript" src="cookie.js"></script>
<script language="JavaScript">
// this cookie NEVER expires
var psched = new Cookie(document, "psched",120);

psched.load();

function onBoxClick(box, num)
{
	if (box.checked)
	{
		eval("psched.g" + num + "= 1")
	}
	else
	{
		eval("psched.g" + num + "= 0")
	}

	psched.store();
}

	function adjustImages()
	{
		var i;
		var img;
		var ratio;
		var imgwidth = 100;

	  if (navigator.appVersion.indexOf("4.") != -1 &&
	      navigator.appName.indexOf("Explorer") != -1) {
	     imgwidth = screen.width / 2.5;
	  }
	  if (navigator.appVersion.indexOf("4.") != -1 &&
	      navigator.appName.indexOf("Netscape") != -1) {
	     imgwidth = screen.width / 2.5;
  }

	  if (navigator.appVersion.indexOf("5.") != -1 &&
	      navigator.appName.indexOf("Netscape") != -1)
	  {
	     imgwidth = screen.width / 2.5;
 	  }

		for (i = 0; i < document.images.length; i++)
		{
			img = document.images[i];

			// if (img.noadj != "Yes")
			if (img.id != "pagetitle")
			{
				if (img.width > imgwidth)
				{
					ratio = imgwidth / img.width;
					img.width = imgwidth;
					img.height = img.height * ratio;
				}

				if (img.height > imgwidth)
				{
					ratio = imgwidth / img.height;
					img.height = imgwidth;
					img.width = img.width * ratio;
				}
			}
		}
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

	function testURL(url)
	{

		var h = (screen.availHeight - 200);
		var w = (screen.availWidth - 100);
		window.open(url,"Test", "toolbar,status,scrollbars,resizable,height="+h.toString()+",width="+w.toString()+",left=50,top=50");
	}

	function openPersonalSchedule(url)
	{

		var h = (screen.availHeight - 400);
		var w = (screen.availWidth - 400);
		var l = (screen.availWidth / 2) - (w / 2)
		window.open(url,"Test", "toolbar,menubar,status,scrollbars,resizable,height="+h.toString()+",width="+w.toString()+",left="+l.toString()+",top=50");
	}

var XMLHttpRequestObject = false;
if (window.XMLHttpRequest)  {
								XMLHttpRequestObject = new XMLHttpRequest();
							}
else if (window.ActiveXObject) {
								  XMLHttpRequestObject = new ActiveXObject("Microsoft.XMLHTTP");
								}

  function showGameDesc(gameid)
  {

		if(XMLHttpRequestObject)
		{

			var b = "GAMEDESCArea" + gameid;
			var lookupURL = "inlineGameDesc.cfm?GameID=" + gameid
			var obj = document.getElementById(b);
			var rtext

			if (obj.innerHTML.length <= 5)
			{

			XMLHttpRequestObject.open("GET", lookupURL,1);
			XMLHttpRequestObject.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			XMLHttpRequestObject.onreadystatechange = function()
				{
					if (XMLHttpRequestObject.readyState == 4) {
							rtext = XMLHttpRequestObject.responseText;
                            obj.innerHTML = rtext;
                           }
				}
			XMLHttpRequestObject.send(null);
			}
			else
				obj.innerHTML = ""
		}

		else testURL("popup_game.cfm?GameID=" + gameid)
	}

	if (typeof String.prototype.endsWith !== 'function') {
		String.prototype.endsWith = function(suffix) {
			return this.indexOf(suffix, this.length - suffix.length) !== -1;
		};
	}

	function GameInterest(gameid)
	{

		var likes = document.getElementById("NumLikes" + gameid);
		var img = document.getElementById("likegameimg" + gameid);
		var emptyimg = "images/green_thumb_off.gif";
		var shineimg = "images/green_thumb.gif";

		//alert(likes.innerHTML);

		var numlikes = likes.innerHTML;
		if (numlikes == "")
			numlikes = 0;

		if (img.src.endsWith(emptyimg))
		{
			//alert("empty -> shine");
			img.src = shineimg;
			img.title ="Unlike";
			likevalue = "Like";
			numlikes = parseInt(numlikes) + 1;
		}
		else
		{
			//alert("shine -> empty");
			img.src = emptyimg;
			img.title = "Like";
			likevalue = "Unlike";
			numlikes = parseInt(numlikes) - 1;
			if (numlikes == 0)
				numlikes = "";
		}

		likes.innerHTML = numlikes;
		//alert(likes.innerHTML);


		var XMLHttpRequestObjectB = false;
		if (window.XMLHttpRequest)  {
										XMLHttpRequestObjectB = new XMLHttpRequest();
									}
		else if (window.ActiveXObject) {
										  XMLHttpRequestObjectB = new ActiveXObject("Microsoft.XMLHTTP");
										}

//		likevalue = 	obj.innerHTML;
//
//		if (likevalue == "Like")
//			obj.innerHTML = "Unlike";
//		else
//			obj.innerHTML = "Like";


//		if (


//		obj.disabled = true


		if(XMLHttpRequestObjectB)
		{

			var lookupURL = "registerGameInterest.cfm?GameID=" + gameid + "&LIKEVALUE=" + likevalue;

			var obj = document.getElementById("showresults");
			var rtext


			XMLHttpRequestObjectB.open("GET", lookupURL,1);
			XMLHttpRequestObjectB.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			XMLHttpRequestObjectB.onreadystatechange = function()
				{
					if (XMLHttpRequestObjectB.readyState == 4) {
							rtext = XMLHttpRequestObjectB.responseText;
							 obj.innerHTML = rtext;
                           }
				}
			XMLHttpRequestObjectB.send(null);

		}

	}
</script>


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
						<div class="slide"> <img src="images/sched-1.jpg" alt="" /> </div>
						<div class="slide"> <img src="images/sched-3.jpg" alt="" /> </div>
						<div class="slide"> <img src="images/sched-2.jpg" alt="" /> </div>
						<div class="slide"> <img src="images/sched-6.jpg" alt="" /> </div>
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
				<h2>Game Schedule</h2>
				<span class="byline">View By GM</span>
			</div>
			<p>

<!--BEGINNING OF SCHEDULE-->
<cfquery name="Schedule" datasource="#ds#" dbtype="ODBC">
select * from
(
	SELECT 		SessionDate,
				SessionBegins,
				Type,
				Schedule.System,
				Title,
				GM,
				GMid,
				email,
				emailVisable,
				Link,
				Description,
				AdultOnly,
				NumPlayers,
				RoleplayingStressed,
				[Level],
				schedule.GameId,
				HomePage,
				Image,
				ImageApproved,
				CLUBID,
				CLUBNAME,
				CLUBICON,
				CLUBGRAPHIC,
				HideOnSchedule,
				(select count(*) from GameInterest where GameID = Schedule.GameID) as Likes

	FROM 		Schedule
					inner join  (select GameID, HideOnSchedule from Games) dd  on Schedule.GameID = dd.GameID
				where HideOnSchedule = 0 or HideOnSchedule is null

) alm
ORDER BY 	SessionDate, SessionBegins, Type, System, Title

</cfquery>

<!---
<cfquery name="Schedule" datasource="#ds#" dbtype="ODBC">
select * from
(

	SELECT 		SessionDate, SessionBegins, Type, System, Title,
				GM, GMid,email, emailVisable, Link, Description, AdultOnly,
				NumPlayers, RoleplayingStressed, [Level], schedule.GameId, HomePage,
				Image, ImageApproved, CLUBICON, CLUBGRAPHIC, CLUBNAME, HideOnSchedule,

				(select count(*) from GameInterest where GameID = Schedule.GameID) as Likes

	FROM 		Schedule
					inner join  (select GameID, HideOnSchedule from Games) dd  on Schedule.GameID = dd.GameID
				where HideOnSchedule = 0 or HideOnSchedule is null
union
	SELECT	    DateOfLarp as SessionDate,

				[DATEOFLARP] & ' ' & UCase(Left([Larps]![DATEOFLARPSTRING],InStr(1,[DATEOFLARPSTRING],' ')-3) & ':00:00 ' & Mid([DATEOFLARPSTRING],InStr(1,[DATEOFLARPSTRING],' ')-2,2)) as SessionBegins,


				'LARP' as Type,
				GAME_SYSTEM as System,
				GAME_TITLE as title,
				GM_NAME as GM,
				-1 as GMid,
				'' as email,
				0 as emailVisible,
				'' as Link,
				[SYNOPSIS] as Description,
				0 as AdultOnly,
				MINPLAYERS as NumPlayers,
				1 as RoleplayingStressed ,
				'' as [Level],
				LarpID+10000  as GameID,
				'' as HomePage,
				'' as Image,
				0 as ImageApproved,
				'' AS CLUBICON,
				'' AS CLUBGRAPHIC,
				'' AS CLUBNAME,
				0 as HideOnSchedule,
				(select count(*) from GameInterest where GameID = LarpID+10000) as Likes
	FROM        Larps
	WHERE APPROVED = 1
)
	ORDER BY 	GM, SessionDate, SessionBegins, Type, System, Title;
</cfquery>
--->

<cfquery name="Descriptions" datasource="#ds#" dbtype="ODBC">
	SELECT 		SessionDate, SessionBegins, Type, System, Title,
				GM, email, emailVisable, Link, Description, AdultOnly,
				NumPlayers, RoleplayingStressed, [Level], GameId, HomePage,
				Image, ImageApproved, LengthOfGame, Complexity
	FROM 		Schedule
	ORDER BY    Title
</cfquery>

<cfquery name="AllGames" datasource="#ds#" dbtype="ODBC">
	SELECT 		Type,  GameID
	FROM 		Schedule

	UNION
	SELECT      'LARP', LarpID + 10000
	From Larps

	ORDER BY 	 GameID
</cfquery>
<link rel="stylesheet" type="text/css" href="styles/main.css">

<center>

</center>
<A id="top"></a>
<!---<table width="775" align="center">
<tr>
	<td align="left" valign="top"><font size="-1"><a href="schedule.cfm" target="_self">View Schedule in Calendar Order</a></font></td>
	<td align="center" valign="top"><font size="-1"><a href="javascript:openPersonalSchedule('personal_schedule.cfm');" >Open Your Schedule</a></font><br></td>
	<td align="right" valign="top"><font size="-1"><a href="schedule_map.cfm"  target="_self">View Schedule as a Map</a></font></td>
</tr>
</table>--->

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<FORM name="gform">
<table width="775" align="center" cellspacing="0" cellpadding="3" >

<!---	<tr>
		<td align="center" colspan="50">
			<cfinclude template="trollscave/index.cfm">
		</td>
	</tr>
--->
<!--- <table width="100%" > --->
				<cfoutput query="Schedule" group="GM">
				<tr id="gi_heading">
					<td width="40%" colspan="2" ><b><a id="GM#GMid#">&nbsp;</a>#GM#</b></td>
<!---					<td width="20%"><b>Title</b></td>
--->					<td width="15%"><b>System</b></td>
					<td width="10%"><b>Game Type</b></td>
					<td width="10%"><b>Day</b></td>
					<td width="10%"><b>Time</b></td>

				</tr>
						<cfoutput>
							<CFQUERY NAME="getDate" datasource="#ds#" dbtype="ODBC">
								SELECT AFTERDEADLINE
								FROM GAMES
								WHERE GameID = #GameID#;
							</cfquery>

				<tr
								<cfif IsDefined("SESSION.LOGGEDINGMN")>
									<CFIF GMID EQ SESSION.LOGGEDINGMN>
										 bgcolor="CCCCCC"
									</CFIF>
								</CFIF>
				>
								<td align="left" valign="top">
										<div class="image">

											<cfif IsDefined("SESSION.LOGGEDINGMN")>
												<cfquery name="alreadyLike" datasource="#ds#">
													select count(IPAddress) AS LIKING
													from GameInterest
													where GAMEID = #gameid#
														AND IPADDRESS = '#SESSION.LOGGEDINGMN#'

												</cfquery>
												<CFIF AlreadyLike.LIKING gt 0>
													<img id="likegameimg#gameID#"  src="images/green_thumb.gif" align="left" hspace="4"
														onClick="javascript:GameInterest(#GameID#); return false" style="cursor: pointer;"
														title="Unlike" />
												<cfelse>
													<img id="likegameimg#gameID#" c src="images/green_thumb_off.gif"  align="left" hspace="4"
														onClick="javascript:GameInterest(#GameID#); return false" style="cursor: pointer;"
														title="Like" />
												</CFIF>
											<cfelse>
													<img src="images/green_thumb_off.gif"  align="left" hspace="4"
														title="Log in to 'Like' this game" />
											</cfif>
									  <h3 class="NumLikes" id="NumLikes#GameID#"><cfif Likes GT 0>#Likes#</cfif></h3>

								</div>

<!---								</td>--->


<!---								<td valign="bottom">--->
<!--- 									<a href=###GameID#>#Title#</a> --->
								<a
								<CFIF Type NEQ "LARP">
<!---									href="javascript:testURL('popup_game.cfm?GameID=#GameID#')"
--->									href="javascript:showGameDesc(#GameID#)"
								<cfelse>
									href="larp/index.cfm##L#GameID#"
								</cfif>><strong>#Title#</strong></a>
								</td>
								<td align="center" valign="top">
									<CFIF CLUBICON GT ''>
										<cfif CLUBGRAPHIC GT ''>
											<A HREF="javascript:show_image('clubs/clubimages/#CLUBGRAPHIC#')">
											<img src="clubs/clubimages/#CLUBICON#" border="0" title="#CLUBNAME#">
											</a>
										</cfif>
									</CFIF>
								</td>								<td  valign="top">#System#</td>
								<td valign="top" align="Center">
									<CFIF Type NEQ "LARP">
										#Type#
									<CFELSE>
										<img src="../necro/images/LARP_GIF.GIF" border="0" alt="" align="middle">
									</CFIF>
								</td>
								<td valign="top">#DateFormat(SessionDate, "dddd")#</td>
								<td valign="top">#TimeFormat(SessionBegins, "h tt")#</td>
							</tr>
							<tr>
								<td  valign="top" id="GAMEDESCArea#GameID#" colspan="10"></td>
							</tr>
						</cfoutput>

				</cfoutput>
</table>
</form>
<cfif ISDEFINED("SESSION.SHOWGAMELIST")>
	<CFIF SESSION.SHOWGAMELIST EQ TRUE>
		 <cfinclude template="gamelist.cfm">
	</CFIF>
</cfif>

<cfquery name="clubs" datasource="#ds#">
select * from clubs
</cfquery>
<cfoutput query="clubs">
<img src="clubs/clubimages/#CLUBGRAPHIC#" style="display:none">
</cfoutput>

<script language="JavaScript">
<cfoutput query="AllGames">
	if (psched.g#GameID# == 1)
	{
		if (document.gform.SEL#GameID#)
			document.gform.SEL#GameID#.checked = true;
	}

</cfoutput>
</script>

<!--END OF SCHEDULE-->


			 </p>
		</div>
		<div id="sidebar">
			<div class="box1">
				<div class="title">
					<h2>Our Schedule</h2>
				</div>
				<ul class="style2">
					<li><a href="schedule.cfm">Game Schedule</a></li>
					<!---					<li><a href="schedule_by_gm.cfm">View By GM</a></li>
 <li><a href="schedule_map.cfm">Map View</a></li>
					<cfinclude template="Map_View_Menu.cfm"> --->
					<li><a href="larp/index.cfm">LARP Schedules</a></li>
					<cfif IsDefined("SESSION.LOGGEDINGMN")><li><a href="personal_schedule.cfm" target="_blank">Your Schedule</a></li></cfif>

				</ul>
			</div>
			<div class="box2">

<cfquery datasource="#ds#" name="recentGames">
SELECT top 10  GameInfo.Title, GameID, type
FROM GameInfo
WHERE (((GameInfo.Cancelled)=0) AND ((GameInfo.Approved)=-1)) and ((GameInfo.HideOnSchedule = 0))
ORDER BY GameInfo.GameId DESC;
</cfquery>

				<div class="title">
					<h2>Most Recent Games</h2>
				</div>
				<ul class="style2">
					<cfoutput query="recentGames">
						<li><a  <CFIF Type NEQ "LARP">
									href="javascript:testURL('popup_game.cfm?GameID=#GameID#')"
								<cfelse>
									href="larp/index.cfm"
								</cfif>
						target="_blank"">#Title#</a></li>					</cfoutput>
				</ul>
					<a href="schedule.cfm" class="icon icon-file-alt button">See All</a> </div>
			</div>
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




<cfquery name="Descriptions" datasource="#ds#" dbtype="ODBC">
	SELECT 		SessionDate, SessionBegins, Type, System, Title,
				GM, email, emailVisable, Link, Description, AdultOnly,
				NumPlayers, RoleplayingStressed, [Level], GameId, HomePage,
				Image, ImageApproved, LengthOfGame, Complexity
	FROM 		Schedule
	ORDER BY    Title
</cfquery>

<cfquery name="AllGames" datasource="#ds#" dbtype="ODBC">
	SELECT 		Type,  GameID
	FROM 		Schedule

	UNION
	SELECT      'LARP', LarpID + 10000
	From Larps

	ORDER BY 	 GameID
</cfquery>
<link rel="stylesheet" type="text/css" href="styles/main.css">

<center>

</center>
<A id="top"></a>
<!---<table width="775" align="center">
<tr>
	<td align="left" valign="top"><font size="-1"><a href="schedule.cfm" target="_self">View Schedule in Calendar Order</a></font></td>
	<td align="center" valign="top"><font size="-1"><a href="javascript:openPersonalSchedule('personal_schedule.cfm');" >Open Your Schedule</a></font><br></td>
	<td align="right" valign="top"><font size="-1"><a href="schedule_map.cfm"  target="_self">View Schedule as a Map</a></font></td>
</tr>
</table>--->

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<FORM name="gform">
<table width="775" align="center" cellspacing="0" cellpadding="3" >

<!---	<tr>
		<td align="center" colspan="50">
			<cfinclude template="trollscave/index.cfm">
		</td>
	</tr>
--->
<!--- <table width="100%" > --->
				<cfoutput query="Schedule" group="GM">
				<tr id="gi_heading">
					<td width="40%" colspan="2" ><b><a id="GM#GMid#">&nbsp;</a>#GM#</b></td>
<!---					<td width="20%"><b>Title</b></td>
--->					<td width="15%"><b>System</b></td>
					<td width="10%"><b>Game Type</b></td>
					<td width="10%"><b>Day</b></td>
					<td width="10%"><b>Time</b></td>

				</tr>
						<cfoutput>
							<CFQUERY NAME="getDate" datasource="#ds#" dbtype="ODBC">
								SELECT AFTERDEADLINE
								FROM GAMES
								WHERE GameID = #GameID#;
							</cfquery>

				<tr
								<cfif IsDefined("SESSION.LOGGEDINGMN")>
									<CFIF GMID EQ SESSION.LOGGEDINGMN>
										 bgcolor="CCCCCC"
									</CFIF>
								</CFIF>
				>
								<td align="left" valign="top">
										<div class="image">

											<cfif IsDefined("SESSION.LOGGEDINGMN")>
												<cfquery name="alreadyLike" datasource="#ds#">
													select count(IPAddress) AS LIKING
													from GameInterest
													where GAMEID = #gameid#
														AND IPADDRESS = '#SESSION.LOGGEDINGMN#'

												</cfquery>
												<CFIF AlreadyLike.LIKING gt 0>
													<img id="likegameimg#gameID#"  src="images/green_thumb.gif" align="left" hspace="4"
														onClick="javascript:GameInterest(#GameID#); return false" style="cursor: pointer;"
														title="Unlike" />
												<cfelse>
													<img id="likegameimg#gameID#" c src="images/green_thumb_off.gif"  align="left" hspace="4"
														onClick="javascript:GameInterest(#GameID#); return false" style="cursor: pointer;"
														title="Like" />
												</CFIF>
											<cfelse>
													<img src="images/green_thumb_off.gif"  align="left" hspace="4"
														title="Log in to 'Like' this game" />
											</cfif>
									  <h3 class="NumLikes" id="NumLikes#GameID#"><cfif Likes GT 0>#Likes#</cfif></h3>

								</div>

<!---								</td>--->


<!---								<td valign="bottom">--->
<!--- 									<a href=###GameID#>#Title#</a> --->
								<a
								<CFIF Type NEQ "LARP">
<!---									href="javascript:testURL('popup_game.cfm?GameID=#GameID#')"
--->									href="javascript:showGameDesc(#GameID#)"
								<cfelse>
									href="larp/index.cfm##L#GameID#"
								</cfif>><strong>#Title#</strong></a>
								</td>
								<td align="center" valign="top">
									<CFIF CLUBICON GT ''>
										<cfif CLUBGRAPHIC GT ''>
											<A HREF="javascript:show_image('clubs/clubimages/#CLUBGRAPHIC#')">
											<img src="clubs/clubimages/#CLUBICON#" border="0" title="#CLUBNAME#">
											</a>
										</cfif>
									</CFIF>
								</td>								<td  valign="top">#System#</td>
								<td valign="top" align="Center">
									<CFIF Type NEQ "LARP">
										#Type#
									<CFELSE>
										<img src="../necro/images/LARP_GIF.GIF" border="0" alt="" align="middle">
									</CFIF>
								</td>
								<td valign="top">#DateFormat(SessionDate, "dddd")#</td>
								<td valign="top">#TimeFormat(SessionBegins, "h tt")#</td>
							</tr>
							<tr>
								<td  valign="top" id="GAMEDESCArea#GameID#" colspan="10"></td>
							</tr>
						</cfoutput>

				</cfoutput>
</table>
</form>
<cfif ISDEFINED("SESSION.SHOWGAMELIST")>
	<CFIF SESSION.SHOWGAMELIST EQ TRUE>
		 <cfinclude template="gamelist.cfm">
	</CFIF>
</cfif>

<cfquery name="clubs" datasource="#ds#">
select * from clubs
</cfquery>
<cfoutput query="clubs">
<img src="clubs/clubimages/#CLUBGRAPHIC#" style="display:none">
</cfoutput>

<script language="JavaScript">
<cfoutput query="AllGames">
	if (psched.g#GameID# == 1)
	{
		if (document.gform.SEL#GameID#)
			document.gform.SEL#GameID#.checked = true;
	}

</cfoutput>
</script>

<!--END OF SCHEDULE-->


			 </p>
		</div>
		<div id="sidebar">
			<div class="box1">
				<div class="title">
					<h2>Our Schedule</h2>
				</div>
				<ul class="style2">
				<!---
					<li><a href="schedule.cfm">Game Schedule</a></li>
					<li><a href="schedule_by_gm.cfm">View By GM</a></li>
				--->
					<li><a href="schedule.cfm">Game Schedule</a></li>
					<!--- <li><a href="schedule_map.cfm">Map View</a></li> --->
					<cfinclude template="Map_View_Menu.cfm">
					<li><a href="larp/index.cfm">LARP Schedules</a></li>
					<cfif IsDefined("SESSION.LOGGEDINGMN")><li><a href="personal_schedule.cfm" target="_blank">Your Schedule</a></li></cfif>

				</ul>
			</div>
			<div class="box2">

<cfquery datasource="#ds#" name="recentGames">
SELECT top 10  GameInfo.Title, GameID, type
FROM GameInfo
WHERE (((GameInfo.Cancelled)=0) AND ((GameInfo.Approved)=-1)) and ((GameInfo.HideOnSchedule = 0))
ORDER BY GameInfo.GameId DESC;
</cfquery>

				<div class="title">
					<h2>Most Recent Games</h2>
				</div>
				<ul class="style2">
					<cfoutput query="recentGames">
						<li><a  <CFIF Type NEQ "LARP">
									href="javascript:testURL('popup_game.cfm?GameID=#GameID#')"
								<cfelse>
									href="larp/index.cfm"
								</cfif>
						target="_blank"">#Title#</a></li>					</cfoutput>
				</ul>
					<a href="schedule.cfm" class="icon icon-file-alt button">See All</a> </div>
			</div>
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

