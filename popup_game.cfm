<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>

<head>
	<title>Schedule</title>
	
	
<style type="text/css">
<!--
.cursor {  cursor: hand}
.posts {
	COLOR: #000000; FONT-FAMILY: Verdana, Arial, sans-serif; FONT-SIZE: 12px; MARGIN: 10px
}
-->
</style>	

	
<script language="JavaScript">
	function adjustImages()
	{
		var i;
		var img;
		var ratio;
		var imgwidth = 100;
		
	  if (navigator.appVersion.indexOf("4.") != -1 && 
	      navigator.appName.indexOf("Explorer") != -1) 
	  {
	     imgwidth = screen.width / 2.5;
	  }
	  if (navigator.appVersion.indexOf("4.") != -1 && 
	      navigator.appName.indexOf("Netscape") != -1) 
	  {
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
		window.open(url,"Test2", "toolbar,status,scrollbars,resizable,height="+h.toString()+",width="+w.toString()+",left=50,top=50");	
	}
	
	function openPersonalSchedule(url)
	{
	
		var h = (screen.availHeight - 400);
		var w = (screen.availWidth - 400);
		var l = (screen.availWidth / 2) - (w / 2)
		window.open(url,"Test", "toolbar,menubar,status,scrollbars,resizable,height="+h.toString()+",width="+w.toString()+",left="+l.toString()+",top=50");	
	}
</script>	
	
	
</head>	
<cfquery name="game" datasource="#ds#">
	SELECT 		SessionDate, SessionBegins, Type, System, Title, 
				GM, email, emailVisable, Link, Description, AdultOnly, 
				NumPlayers, RoleplayingStressed, [Level], GameId, HomePage,
				Image, ImageApproved, LengthOfGame, Complexity
	FROM 		Schedule
	where GameID = #GameID#
</cfquery>

<link rel="stylesheet" type="text/css" href="styles/main.css">
<body onLoad="adjustImages();"> 


<cfoutput query="game">
	<cfinclude template="gamedescription.cfm">
</cfoutput>

</body>
</html>