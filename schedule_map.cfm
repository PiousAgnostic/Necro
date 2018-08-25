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
	.RPG 		  { text-align:center; vertical-align: top; background: Olive;   color: white; text-decoration: none; }
	.Miniatures   { text-align:center; vertical-align: top; background: Gray;    color: white; text-decoration: none; }
	.CCG 		  { text-align:center; vertical-align: top; background: Navy;    color: white; text-decoration: none; }
	.Board 	      { text-align:center; vertical-align: top; background: Green;   color :white; text-decoration: none; }
	.Cards 	      { text-align:center; vertical-align: top; background: Maroon;  color: white; text-decoration: none; }
	.Computer     { text-align:center; vertical-align: top; background: Blue;    color: white; text-decoration: none; }
	.Event        { text-align:center; vertical-align: top; background: Teal;    color: white; text-decoration: none; }
	.LARP 	      { text-align:center; vertical-align: top; background: black;   color: white; text-decoration: none; }
	.Dice		  { text-align:center; vertical-align: top; background: #FFFF00; color: black; text-decoration: none; }

	.mapschedule {
	font-size:10px;
	border-spacing:1;
	}

	.image {
	   position: relative;
	   width: 100%; /* for IE 6 */
	}


	.NumLikes {
	   position: absolute;
	   top: 10px;
	   left: 10px;
	   width: 100%;
	   font-size:14px;
	   font-weight:bold;
	   color:#FF0000;
	}
</style>




<cfquery name="AllGames" datasource="#ds#" dbtype="ODBC">
	SELECT 		Type,  GameID, GameTypeID
	FROM 		Schedule

	UNION
	SELECT      'LARP', LarpID + 10000, 999
	From Larps
	where Approved = 1

	ORDER BY 	GameTypeID,  GameID
</cfquery>

 <cfquery name="AllEvents" datasource="#ds#" dbtype="ODBC">
	select *
	from Events
</cfquery>

<cfquery name="GameTypesX" datasource="#ds#" dbtype="odbc">
	SELECT GameTypeID, Type FROM GameTypes
	WHERE TYPE not in ( 'Event', 'Top Secret', 'Computer')
</cfquery>
<cfset temp = QueryAddRow(GameTypesX)>
<cfset Temp = QuerySetCell(GameTypesX, "GameTypeID", 999)>
<cfset Temp = QuerySetCell(GameTypesX, "Type", "LARP")>

<CFQUERY name="GameTypes" dbtype="query">
SELECT * FROM GAMETYPESX ORDER BY TYPE
</CFQUERY>
<!---
<cfquery name="qsession_data" datasource="#ds#">
SELECT Sessions.SessionDate, Sessions.SessionBegins, Sessions.SessionEnds, Sessions.MaxLengthGame
FROM Sessions
WHERE (((Sessions.Type)='Game'))
ORDER BY Sessions.SessionDate
</cfquery>


<cfquery name="qsession_data_grouped" dbtype="query">
SELECT SessionDate, Min(SessionBegins) AS MinOfSessionBegins, Max(SessionEnds) AS MaxOfSessionEnds
FROM qsession_data
GROUP BY SessionDate
</cfquery>

<cfset clock = QueryNew("SessionDate, MinOfSessionBegins, MaxOfSessionEnds, LastOfMaxLengthGame")>


<cfoutput query="qsession_data_grouped">
	<CFSET L_DATE = MaxOfSessionEnds>

	<cfquery name="lookup" dbtype="query">
		select MaxLengthGame
		From qsession_data
		where SessionEnds = '#L_DATE#'
	</cfquery>

	<cfset temp = QueryAddRow(clock)>

	<cfset Temp = QuerySetCell(clock, "SessionDate", SessionDate)>
	<cfset Temp = QuerySetCell(clock, "MinOfSessionBegins", MinofSessionBegins)>
	<cfset Temp = QuerySetCell(clock, "MaxOfSessionEnds", MaxOfSessionEnds)>
	<cfset Temp = QuerySetCell(clock, "LastOfMaxLengthGame", lookup.MaxLengthGame)>
</cfoutput>
--->

<!---
<Cfquery name="clock" datasource="#ds#" dbtype="ODBC">
	SELECT 		Sessions.SessionDate,
				Min(Sessions.SessionBegins) AS MinOfSessionBegins,
				Max(Sessions.SessionEnds) AS MaxOfSessionEnds,
				Type, Last(Sessions.MaxLengthGame) AS LastOfMaxLengthGame
	FROM 		Sessions
	GROUP BY 	Sessions.SessionDate, Type
	HAVING      Type = 'Game';
</cfquery>
--->

<cfinvoke component="components.necronomicon"
	method="retriveClock"
	returnvariable="clock"></cfinvoke>


<script language="JavaScript" src="cookie.js"></script>

<script language="javascript">
<!-- Begin

/* define the function getElementByID for older browsers

if(!document.getElementById){
  if(document.all)
  document.getElementById=function(){
    if(typeof document.all[arguments[0]]!="undefined")
    return document.all[arguments[0]]
    else
    return null
  }
  else if(document.layers)
  document.getElementById=function(){
    if(typeof document[arguments[0]]!="undefined")
    return document[arguments[0]]
    else
    return null
  }
}
*/
function testURL(url)
{

	var h = (screen.availHeight - 200);
	var w = (screen.availWidth - 100);
	window.open(url,"Test", "toolbar,status,scrollbars,resizable,height="+h.toString()+",width="+w.toString()+",left=50,top=50");
}

function toggleDisplay(gid)
{
	//alert("document.getElementById = " + document.getElementById)

	//alert("'" + gid + "' found: " + document.getElementById(gid) )

	var showstyle

	if (navigator.appName == "Microsoft Internet Explorer")
		showstyle = "block"
	else
		showstyle = "table-cell"

	if (document.getElementById(gid) != null)
	{
		//alert("inside")

		if (document.getElementById(gid).style.display)
		{
			//alert(document.getElementById(gid).style.display);

			if ( document.getElementById(gid).style.display == showstyle )
				 document.getElementById(gid).style.display = "none"
			else
				document.getElementById(gid).style.display = showstyle;
		}
		else
		{
			//alert("display not here yet")
			document.getElementById(gid).style.display = "none";
		}
	}
}

function toggleVisiblity(gid)
{
	//alert(document.getElementById(gid) != null)
	//alert(document.getElementById(gid).style.visibility)

	if (document.getElementById(gid) != null)
	{
		if (document.getElementById(gid).style.visibility)
		{
			if ( document.getElementById(gid).style.visibility == "visible" )
				 document.getElementById(gid).style.visibility = "hidden"
			else
				document.getElementById(gid).style.visibility = "visible";
		}
		else
			document.getElementById(gid).style.visibility = "hidden";
	}
}


// this cookie NEVER expires
var mapprefinfo = new Cookie(document, "mapprefs",120);


mapprefinfo.load();


<cfoutput query="AllGames" group="GameTypeID">
function toggle_#GameTypeID#() {<cfoutput>toggleDisplay("Game#GameID#");</cfoutput> }
</cfoutput>

function toggle_events()
{

	if (navigator.appName == "Microsoft Internet Explorer")
	{
	 <cfoutput query="AllEvents">
		toggleVisiblity("EV#EventID#");
	 </cfoutput>
	}
	else
	{
		var p = document.getElementsByName("allevents")

		for( var i = 0; i < p.length; ++i )
		{

			if (p[i].style.visibility)
			{
				if ( p[i].style.visibility == "visible" )
					 p[i].style.visibility = "hidden"
				else
					p[i].style.visibility = "visible";
			}
			else
				p[i].style.visibility = "hidden";
		}
	}
}

function onBoxClick(box, num)
{
	if (box.checked)
	{
		eval("mapprefinfo.t" + num + "= 1")
	}
	else
	{
		eval("mapprefinfo.t" + num + "= 0")
	}
	//alert(eval("mapprefinfo.t" + num))

	mapprefinfo.store();
	//document.gform.submit()
	eval("toggle_" + num + "()")
}

function onEventBoxClick(box)
{
	//alert("in onEventBoxClick")
	if (box.checked)
		mapprefinfo.e = 1
	else
		mapprefinfo.e = 0
	mapprefinfo.store();

	toggle_events()
}


function showEventInfo(msg)
{
	alert(msg)
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

var psched = new Cookie(document, "psched",120);

psched.load();

<!---function onBoxClick2(box, num)
{
	//alert(box.checked)

	if (box.checked)
	{
		eval("psched.g" + num + "= 1")
	}
	else
	{
		eval("psched.g" + num + "= 0")
	}
	psched.store();
}--->

	function openPersonalSchedule(url)
	{

		var h = (screen.availHeight - 400);
		var w = (screen.availWidth - 400);
		var l = (screen.availWidth / 2) - (w / 2)
		window.open(url,"Test", "toolbar,menubar,status,scrollbars,resizable,height="+h.toString()+",width="+w.toString()+",left="+l.toString()+",top=50");
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

// End -->
</script>

</head>

<link rel="stylesheet" type="text/css" href="styles/main.css">
<body  >

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
				<span class="byline">Map View</span>
			</div>
			<p>

<!--BEGINNING OF SCHEDULE-->

<form action="schedule_map.cfm" method="post" name="gform">
	<input type="checkbox" name="EM" value="1" onClick="onEventBoxClick(this)">Events&nbsp;&nbsp;
 <cfoutput query="GameTypes">
	<input type="checkbox" name="GT#GameTypeID#" value="#Type#" onClick="onBoxClick(this, #GameTypeID#)">#Type#&nbsp;&nbsp;
</cfoutput>
</form>
<form method="post" name="sform">
<cfoutput query="clock">
<table cellspacing="5" cellpadding="3">
	<tr>
		<td class="Event" width=30><strong>Events</strong></td>
		<cfloop query="GameTypes">
			<td class="#Type#"><strong>#Type#</strong></td>
		</cfloop>
<!---		<td class="Event" width=30>Events</td>
		<td class="RPG">RPG</td>
		<td class="Miniatures">Miniatures</td>
		<td class="CCG">CCG</td>
		<td class="Board">Board</td>
		<td class="Cards">Cards</td>
		<td class="Dice" >Dice</td>
		<td class="Larp" >Larps</td>--->
	</tr>
</table>

<table class="mapschedule">
	<tr>

		<td>&nbsp;</td>
		<th colspan="25" bgcolor="Maroon" align="left" >
			<font color="White">#DateFormat(SessionDate, "dddd, mmmm dd")#</font>
		</th>
	</tr>

	<cfset numHrs = (DateDiff("n", MinOFSessionBegins, MaxOfSessionEnds) / 30 +LastOfMaxLengthGame-1)>
	<cfset oneHr  = CreateTimeSpan(0,0,30,0)>
	<cfset thisHour = MinOFSessionBegins>

	<cfset SKIPCOUNT = 0>

	<cfloop index="x" from="1" to="#numHrs#">
		<tr >
			<cftry>
			<cfquery name="Events" datasource="#ds#">
				SELECT 	EventID, EventID + 50000 as UseID, Starts, LengthOfEvent / 60 as LengthOfEventInHours, Title, Description
				FROM 	Events
				WHERE   (Starts = #CreateODBCDateTime(thisHour)#)
			</cfquery>

			<cfquery name="MaxLen" datasource="#ds#">
				SELECT MAX(LENGTHOFEVENT / 60)*2 AS MAXL
				FROM EVENTS
				WHERE   (Starts = #CreateODBCDateTime(thisHour)#)
			</cfquery>

 			<cfif Events.RecordCount GT 0>
			<td	 ROWSPAN="#MAXLEN.MAXL#"  valign="top" align="center" class="Event" width="100" name="allevents">
				<table  width="100%" height="100%">
				<tr>
		 			<CFLOOP query="Events">
					<cfset dDescription = replace(Description, '"', '&quot;','ALL')>
					<cfset LOE = LengthOfEventInHours * 2>
					<td height="100%"
						align="center"
						id="EV#EventID#"
						title="#dDescription#">
					<b><a href="javascript:showEventInfo('#JSStringFormat(dDescription)#')"
					style="color: White; text-decoration: none; display: inline">#Title#</a></b>
					<br>
<!---					<input type="checkbox"
				   name="SEL#UseID#"
				   title="Add Event to Your Schedule"
				   onClick="onBoxClick2(this, #UseID#)">--->


					</td>
					<CFSET SKIPCOUNT = LengthOfEventInHours * 2 - 1>
					</cfloop>
				</tr>
				</table>
			</td>
 			<cfelse>
				<CFIF SKIPCOUNT LTE 0>
					<td>&nbsp;</td>
				<CFELSE>
					<cfset skipcount = skipcount - 1>
				</cfif>
			</cfif>
			<cfcatch>
			</cfcatch>
			</cftry>

			<td valign="top" align="right" width="40">
				<cfif DatePart("n", thishour) NEQ 30 or Events.RecordCount GT 0>
					<font size="-1">#TimeFormat(thisHour, "h:mm tt")#</font>
				</cfif>
			</td>


<!---
				<cfquery name="Schedule" datasource="#ds#" dbtype="ODBC">
					SELECT 		SessionDate, SessionBegins, Type, Title, Shape, Description,
								LengthOfGame, System, GM, NumPlayers, GameTypeId, NumTables, GameID,
								CLUBICON, CLUBGRAPHIC, Likes


					FROM

								(SELECT SessionDate, SessionBegins, Type, Title, Shape, Description,
								LengthOfGame, System, GM, NumPlayers, GameTypeId, NumTables, Schedule.GameID,
								CLUBICON, CLUBGRAPHIC, HideOnSchedule,
								(select count(*) from GameInterest where GameID = Schedule.GameID) as Likes
								FROM Schedule
									inner join  (select GameID, HideOnSchedule from Games) dd  on Schedule.GameID = dd.GameID
								where HideOnSchedule = 0 or HideOnSchedule is null

								UNION

								SELECT	    DateOfLarp as SessionDate,

											CDate	([DATEOFLARP] & ' ' & UCase(Left([Larps]![DATEOFLARPSTRING],InStr(1,[DATEOFLARPSTRING],' ')-3) & ':00:00 ' & Mid([DATEOFLARPSTRING],InStr(1,[DATEOFLARPSTRING],' ')-2,2))) as SessionBegins,
											'LARP' as Type,
											GAME_TITLE as title,
											'LARP' AS Shape,
											[SYNOPSIS] as Description,
											LengthOfGame,
											GAME_SYSTEM as System,
											GM_NAME as GM,
											MINPLAYERS as NumPlayers,
											999 as gmtypeid,
											1 as NumTables,
											LarpID+10000  as GameID,
											'' AS CLUBICON,
											'' AS CLUBGRAPHIC,
											0 as HideOnSchedule,
											(select count(*) from GameInterest where GameID = LarpID+10000) as Likes
								FROM        Larps
								WHERE APPROVED = 1

								)



					GROUP BY 	SessionDate, SessionBegins, Shape, Description, Title, Type,
								LengthOfGame, System, GM, NumPlayers, GameTypeId, NumTables, GameID,
								CLUBICON, CLUBGRAPHIC, Likes
					HAVING		(SessionBegins = #CreateODBCDateTime(thisHour)#)
					ORDER BY 	Type DESC,SessionDate, SessionBegins, Shape, Title
				</cfquery>
--->

<cfquery name="ScheduleGames" datasource="#ds#" dbtype="ODBC">
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
				(select count(*) from GameInterest where GameID = Schedule.GameID) as Likes,
				LengthOfGame

	FROM 		Schedule
					inner join  (select GameID, HideOnSchedule from Games) dd  on Schedule.GameID = dd.GameID
				where HideOnSchedule = 0 or HideOnSchedule is null
				GROUP BY 	SessionDate, SessionBegins, Shape, Description, Title, Type,
							LengthOfGame, System, GM, NumPlayers, GameTypeId, NumTables, GameID,
							CLUBICON, CLUBGRAPHIC, Likes
					HAVING		(SessionBegins = #CreateODBCDateTime(thisHour)#)
</cfquery>

<cfquery name="ScheduleLarps" datasource="#ds#">

	SELECT	    DateOfLarp as SessionDate,
				CAST (
				CONVERT(char(10), [DateOfLarp],126) + ' ' +
				(Left([Larps].[DATEOFLARPSTRING],CHARINDEX (' ',[DATEOFLARPSTRING])-3) + ':00:00 ' + SUBSTRING ([DATEOFLARPSTRING],CHARINDEX (' ',[DATEOFLARPSTRING])-2,2)) AS DATETIME) as aab,
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
				CAST(MINPLAYERS AS INT) as NumPlayers,
				1 as RoleplayingStressed ,
				'' as [Level],
				LarpID+10000  as GameID,
				'' as HomePage,
				'' as Image,
				0 as ImageApproved,
				NULL AS CLUBID,
				'' AS CLUBNAME,
				'' AS CLUBICON,
				'' AS CLUBGRAPHIC,
				0 as HideOnSchedule,
				(select count(*) from GameInterest where GameID = LarpID+10000) as Likes,
				LengthOfGame
	FROM        Larps
	WHERE APPROVED = 1

</cfquery>


<Cfquery name="Schedule" dbtype="query">

	select * from ScheduleGames
	ORDER BY 	SessionDate, SessionBegins, Type, System, Title
</cfquery>
<!---
	union
	select * from ScheduleLarps
--->


				<cfloop query="Schedule">
 					<cfset dDescription = replace(Description, '"', '&quot;','ALL')>
					<cfset LOE = LengthOfGame * 2>
					<td rowspan="#LOE#"
						class="#type#"
						width=100
						title="#dDescription#"
						id="Game#GameID#"
						>


						<a  <CFIF Type NEQ "LARP">
									href="javascript:testURL('popup_game.cfm?GameID=#GameID#')"
								<cfelse>
									href="larp/index.cfm"
								</cfif>
<!---							style=" text-decoration: none; display: inline"--->
								class="#type#"
							>


							<b>#Title#</b><br>
							<cfif Trim(Title) NEQ Trim(System)>
								#System#<BR>
							</cfif>
							<i>#GM#</i><br>
							#LengthofGame# hours
						</a>
<!---									<CFIF CLUBICON GT ''>
										<cfif CLUBGRAPHIC GT ''>
											<BR>
											<A HREF="javascript:show_image('clubs/clubimages/#CLUBGRAPHIC#')">
											<img src="clubs/clubimages/#CLUBICON#" border="0" >
											</a>
										</cfif>
									</CFIF>
							<br>--->
<!---							<input type="checkbox"
								   name="SEL#GameID#"
								   title="Add game to Your Schedule"
								   onClick="onBoxClick2(this, #GameID#)"
							>	--->
<!---							<div class="image">

								<cfif IsDefined("SESSION.LOGGEDINGMN")>
									<cfquery name="alreadyLike" datasource="#ds#">
										select count(IPAddress) AS LIKING
										from GameInterest
										where GAMEID = #gameid#
											AND IPADDRESS = '#SESSION.LOGGEDINGMN#'

									</cfquery>
									<CFIF AlreadyLike.LIKING gt 0>
										<img id="likegameimg#gameID#"  src="images/green_thumb.gif" hspace="4"
											onClick="javascript:GameInterest(#GameID#); return false" style="cursor: pointer;"
											title="Unlike" />
									<cfelse>
										<img id="likegameimg#gameID#" c src="images/green_thumb_off.gif"   hspace="4"
											onClick="javascript:GameInterest(#GameID#); return false" style="cursor: pointer;"
											title="Like" />
									</CFIF>
								<cfelse>
										<img src="images/green_thumb_off.gif"  hspace="4"
											title="Log in to 'Like' this game" />
								</cfif>
							  <h3 class="NumLikes" id="NumLikes#GameID#"><cfif Likes GT 0>#Likes#</cfif></h3>

							</div>	--->
					</td>
				</cfloop>
		</tr>
	<cfset thisHour = thisHour + oneHr>
	</cfloop>
</table>


<p>
</cfoutput>

</form>


<!---<cfquery name="clubs" datasource="#ds#">
select * from clubs
</cfquery>
<cfoutput query="clubs">
<img src="clubs/clubimages/#CLUBGRAPHIC#" style="display:none">
</cfoutput>--->

<script language="JavaScript">
	if ((mapprefinfo.e != 1) && (mapprefinfo.e != 0))
	{
		mapprefinfo.e= 1;
	}
	if (mapprefinfo.e == 1)
	{
		if (document.gform.EM)
			document.gform.EM.checked = true;
	}
	else
		toggle_events()

<cfoutput query="GameTypes">
	// alert("mapprefinfo.t#GametypeID# = " + mapprefinfo.t#GametypeID#)

	if ((mapprefinfo.t#GameTypeID# != 1) && (mapprefinfo.t#GameTypeID# != 0))
	{
		mapprefinfo.t#GameTypeID# = 1;
	}

	if (mapprefinfo.t#GameTypeID# == 1)
	{
		if (document.gform.GT#GameTypeID#)
			document.gform.GT#GameTypeID#.checked = true;
	}
	else
		toggle_#GameTypeID#()
</cfoutput>


<!--- <cfoutput query="AllGames">
	if (psched.g#GameID# == 1)
	{
		if (document.sform.SEL#GameID#)
		{
			document.sform.SEL#GameID#.checked = true;
		}
	}

</cfoutput>--->

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
					<!--- <li><a href="schedule_map.cfm">Map View</a></li>
					<cfinclude template="Map_View_Menu.cfm">--->
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

</body>
</html>
