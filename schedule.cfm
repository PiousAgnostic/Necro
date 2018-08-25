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

<script src="http://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script src="assets/javascripts/socialProfiles.min.js"></script>
<script type="text/javascript" src="jquery.slidertron-1.1.js"></script>

 <cfparam name="SESSION.NEWGAMEDAYS" default="3">

<style type="text/css">
<!--
.cursor {  cursor: hand}
.posts {
	COLOR: #000000; FONT-FAMILY: Verdana, Arial, sans-serif; FONT-SIZE: 12px; MARGIN: 10px
}

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


-->
</style>



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
			</div>
			<p>

<!--BEGINNING OF SCHEDULE-->

<CFQUERY name="latestGame" datasource="#ds#" dbtype="ODBC">
SELECT * FROM GAMES
	WHERE GameID = (
	SELECT Max(Games.GameId) AS MaxOfGameId
	FROM Games
	GROUP BY Games.Cancelled, Games.Approved
	HAVING (((Games.Cancelled)=0) AND ((Games.Approved)<>0)))
</CFQUERY>


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
				AFTERDEADLINE,
				(select count(*) from GameInterest where GameID = Schedule.GameID) as Likes

	FROM 		Schedule
					inner join  (select GameID, HideOnSchedule, AFTERDEADLINE from Games) dd  on Schedule.GameID = dd.GameID
				where HideOnSchedule = 0 or HideOnSchedule is null
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
				GetDate(),
				(select count(*) from GameInterest where GameID = LarpID+10000) as Likes
	FROM        Larps
	WHERE APPROVED = 1

</cfquery>


<Cfquery name="Schedule" dbtype="query">
	select * from ScheduleGames
	union
	select * from ScheduleLarps
	ORDER BY 	SessionDate, SessionBegins, Type, System, Title
</cfquery>


<link rel="stylesheet" type="text/css" href="styles/main.css">


<A id="top"></a>

<FORM name="gform">
<table width="100%" align="center">
<cfoutput query="Schedule" group="SessionDate">
	<tr>
		<td><h2>#DateFormat(SessionDate, "dddd mmmm dd, yyyy")#</h2></td>
	</tr>
	<tr>
		<td>
			<table width="100%" cellspacing="0" cellpadding="3">
				<cfoutput group="SessionBegins">
				<tr  id="gi_heading">
					<td width="40%"><b>#TimeFormat(SessionBegins, "h:mm tt")#</b></td>
						<td width="20%"><b>System</b></td>
						<td width="20%" nowrap><b>Game Master</b></td>
						<td></td>
						<td width="10%"><b>Game Type</b></td>

					</tr>
						<cfoutput>
							<tr onClick="showRecent(#GameID#)"
								style="cursor: pointer"

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
													<img id="likegameimg#gameID#" c src="images/green_thumb_off.gif"  align="left"  hspace="4"
														onClick="javascript:GameInterest(#GameID#); return false" style="cursor: pointer;"
														title="Like" />
												</CFIF>
											<cfelse>
													<img src="images/green_thumb_off.gif"  align="left" hspace="4"
														title="Log in to 'Like' this game" />
											</cfif>
										  <h3 class="NumLikes" id="NumLikes#GameID#"><cfif Likes GT 0>#Likes#</cfif></h3>

										</div>

								<B>#Title#</B>
									<CFIF Type NEQ "LARP">
										<CFIF DateDiff("d", AFTERDEADLINE, Now()) LTE SESSION.NEWGAMEDAYS>
											<img src="../necro/images/new.jpg" border="0" alt="" align="middle">
										</cfif>

									</CFIF>
								</td>
								<td valign="top">#System#</td>

								<td valign="top" nowrap="nowrap">
									#GM#
								</td>
								<td valign="top">
									<CFIF CLUBICON GT ''>
										<cfif CLUBGRAPHIC GT ''>
											<img src="clubs/clubimages/#CLUBICON#" border="0" title="#CLUBNAME#">
										</cfif>
									</CFIF>
									</td>

								<td valign="top" align="Center">
									<CFIF Type NEQ "LARP">
										#Type#
									<CFELSE>
										<img src="../necro/images/LARP_GIF.GIF" border="0" alt="" align="middle">
									</CFIF>
								</td>
							</tr>
							<tr onClick="showDetail(#GameID#)" style="cursor: pointer">
								<td  id="GAMEDESCArea#GameID#" class="GAMEDESCArea#GameID#" colspan="10" style="display: none" ></td>
							</tr>
						</cfoutput>

				</cfoutput>

			</table>
		</td>
	</tr>
	<tr>
		<td height="10">&nbsp;</td>
	</tr>

</cfoutput>

</table>
</form>


<cfquery name="clubs" datasource="#ds#">
select * from clubs
</cfquery>
<cfoutput query="clubs">
<img src="clubs/clubimages/#CLUBGRAPHIC#" style="display:none">
</cfoutput>



<!--END OF SCHEDULE-->

		</div>
		<div id="sidebar">
			<div class="box1">
				<div class="title">
					<h2>Our Schedule</h2>
				</div>
				<ul class="style2">

					<li><a href="schedule.cfm">Game Schedule</a></li>

					<li><a href="larp/index.cfm">LARP Schedules</a></li>
					<cfif IsDefined("SESSION.LOGGEDINGMN")><li><a href="personal_schedule.cfm" target="_blank">Your Schedule</a></li></cfif>

				</ul>
			</div>

<cfinclude template="sidebar.cfm">

	<!-- end #page -->
<div id="footer">
	<p>Copyright (c) 2013 rjritchie.com. All rights reserved. | Design by <a href="http://www.freecsstemplates.org/" rel="nofollow">FreeCSSTemplates.org</a>.</p>
</div>
<!-- end #footer -->

</body>
</html>

