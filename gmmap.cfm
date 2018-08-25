<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <title>GM Maps</title>
	
<cfquery name="gmInfo" datasource="#ds#" dbtype="ODBC">
SELECT   [GM Information].*, [Game Masters].EXTENDEDDEADLINE, [Game Masters].AFTERDEADLINE
,[Game Masters].Geocode
FROM [GM Information] INNER JOIN [Game Masters] ON [GM Information].GMId = [Game Masters].GMId
where [GAME MASTERS].cancelled = 0 and
geocode <> 'unknown'
;
</cfquery>	
	
	
    <script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAATjLCn9ha1cPSJ_PdU8e2khT3WAzTGN0x74M95aejdctR2qbwsRSXpr5IQcjSPRHS80u9h8pbRlCtWg"
            type="text/javascript"></script>
		
    <script type="text/javascript">
	
	function geoLat(geocode)
	{
		var c = geocode.indexOf(",");
		return geocode.substring(1, c);
	}

	function geoLong(geocode)
	{
		var c = geocode.indexOf(",");
		return geocode.substring(c+1, geocode.length-1);
	}	
	

 	var balloons = [
	<cfoutput query="gmInfo">
		"#JSStringFormat(FirstName)# #JSStringFormat(MiddleName)# <cfif #Alias# GT "">'#JSStringFormat(Alias)#' </cfif> #JSStringFormat(LastName)#<br>#JSStringFormat(Address1)#<br>#JSStringFormat(City)# #JSStringFormat(State)# #JSStringFormat(Zip)#",
	</cfoutput>
	""
	]; 
	
	var gmGeoCodes = [<cfoutput query="gmInfo"><cfif GEOCODE GT "">"#GEOCODE#"<CFELSE>"unknown"</cfif>,</cfoutput>-1];	
	
function initialize() {
  if (GBrowserIsCompatible()) 
  {
    var map = new GMap2(document.getElementById("map_canvas"));
    map.setCenter(new GLatLng(27.92, -82.68), 7);
	
	function createMarker(latlng, number) 
	{
		var marker = new GMarker(latlng);

		return marker;
	}
	
	
		for (var i = 0; i < <cfoutput>#gminfo.recordcount#</cfoutput>; i++) 
		{
			
		
		  	var point = new GLatLng(geoLat(gmGeoCodes[i]), geoLong(gmGeoCodes[i]));
			var marker = createMarker(point, i)
			map.addOverlay( marker);
			var myHtml = "<b><font color='black'>" + balloons[i] + "</b></font>";
			marker.bindInfoWindowHtml(myHtml)
		}	
	


	map.addControl(new GSmallMapControl());
	map.addControl(new GMapTypeControl());
  }
}
    </script>
  </head>
<link rel="stylesheet" type="text/css" href="styles/main.css">

  <body onload="initialize()" onunload="GUnload()" style="margin-left: 25px;">
    <div id="map_canvas" style="width: 800px; height: 500px"></div>
  </body>
</html>

