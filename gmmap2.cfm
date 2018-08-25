<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <title>GM Maps</title>
	
	<cfquery name="gmInfo" datasource="#ds#" dbtype="ODBC">
SELECT  [GM Information].*, [Game Masters].EXTENDEDDEADLINE, [Game Masters].AFTERDEADLINE, [Game Masters].GEOCode
FROM [GM Information] INNER JOIN [Game Masters] ON [GM Information].GMId = [Game Masters].GMId
where [GAME MASTERS].cancelled = 0 and
(geocode = 'unknown' or geocode is null)
ORDER BY [GM Information].GMID
;

</cfquery>	

    <script src="http://maps.google.com/maps?file=api&amp;v=2.x&amp;key=ABQIAAAATjLCn9ha1cPSJ_PdU8e2khT3WAzTGN0x74M95aejdctR2qbwsRSXpr5IQcjSPRHS80u9h8pbRlCtWg" type="text/javascript"></script>
    <script type="text/javascript">

    var map = null;
    var geocoder = null;
	
	var currentSelectedIndex;
	
	
	var gmIDs = [<cfoutput query="gmInfo">#gmid#,</cfoutput>-1];
	var gmGeoCodes = [<cfoutput query="gmInfo"><cfif GEOCODE GT "">"#GEOCODE#"<CFELSE>"unknown"</cfif>,</cfoutput>-1];	
 	var balloons = [
	<cfoutput query="gmInfo">
		"#JSStringFormat(FirstName)# #JSStringFormat(MiddleName)# <cfif #Alias# GT "">'#JSStringFormat(Alias)#' </cfif> #JSStringFormat(LastName)#<br>#JSStringFormat(Address1)#<br>#JSStringFormat(City)# #JSStringFormat(State)# #JSStringFormat(Zip)#",
	</cfoutput>
	""
	];
	
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


    function initialize() {
      if (GBrowserIsCompatible()) {
        map = new GMap2(document.getElementById("map_canvas"));
        map.setCenter(new GLatLng(27.92, -82.68), 10);
        geocoder = new GClientGeocoder();
		map.addControl(new GSmallMapControl());
 		map.addControl(new GMapTypeControl());
      }
    }

    function showAddress(address) {
	
	  currentSelectedIndex = document.fform.address.selectedIndex;
	  
	  document.getElementById("message").value = gmGeoCodes[currentSelectedIndex]
	  document.getElementById("GMID").value = gmIDs[currentSelectedIndex];
	  //alert(currentSelectedIndex);
	  
	  
	  if (gmGeoCodes[currentSelectedIndex].toString() == "unknown")
	  {
	  
		  if (geocoder) {
			geocoder.getLatLng(
			  address,
			  function(point) {
				if (!point) {
				  //alert(address + " not found");
				  document.getElementById("message").value = "unknown";
				  document.getElementById("GMID").value = gmIDs[currentSelectedIndex];
				} else {
				  map.closeInfoWindow();
				  map.setCenter(point);
				  var marker = new GMarker(point);
				  map.addOverlay(marker);
				  //marker.bindInfoWindowHtml(address)
				  marker.bindInfoWindowHtml(balloons[currentSelectedIndex]);
				 // marker.openInfoWindowHtml(address);
				  document.getElementById("message").value = map.getCenter().toString();
				  gmGeoCodes[currentSelectedIndex] = map.getCenter().toString();
/*				  GEvent.addListener(marker, "click", function() {
						  var center = map.getCenter();
						  document.getElementById("message").innerHTML = center.toString();
						});	*/		  
				}
			  }
			);
		  }
	  }
	  else 
	  	{
			 map.setCenter(new GLatLng(geoLat(gmGeoCodes[currentSelectedIndex]), 
			 						   geoLong(gmGeoCodes[currentSelectedIndex])));
		}
    }
	
	function automate()
	{
		var i = document.fform.address.selectedIndex;
		var m = document.fform.address.options.length;
		
		//alert(i)
		
		
		if (i < m)
		{
			document.fform.address.selectedIndex++;
			
			//alert(document.fform.address.options[document.fform.address.selectedIndex].value)
			//showAddress(document.fform.address.options[document.fform.address.selectedIndex].value)
		}
		diaplayAll()
	}
	
	
	function diaplayAll()
	{
		var o = document.getElementById("geocodes");
		var otxt = "";
		var i;
		
		for (i=0; i < gmIDs.length; i++)
		{
			otxt = otxt + gmIDs[i] + "|" + gmGeoCodes[i] +"|";
		}
		
		o.innerHTML = otxt;
	}
	
    </script>
  </head>

  <body onload="initialize()" onunload="GUnload()">
    <form name="fform" action="#" onsubmit="showAddress(this.address.value); return false">
      <p>
		<select name="address" onChange="showAddress(this.value); return false">
		<cfoutput query="gmInfo">
			<option value="#JSStringFormat(Address1)# #JSStringFormat(City)# #JSStringFormat(State)# #JSStringFormat(Zip)#">#FirstName# #LastName#</option>
		</cfoutput>
		</select>
		
		
        <input type="submit" value="Go!" />
    </form>
	<button onclick="automate()">Automate</button>
	  </p>
      <div id="map_canvas" style="width: 800px; height: 500px"></div>
	  <input id="message" value="" />
	  <input id="GMID" value="" />

	<button onclick="diaplayAll()">Display</button>
	<p></p>
	<form action="savegeocodes.cfm" method="post" name="sform">
	<textarea name="geocodes" cols="80" rows="40" id="geocodes"></textarea>
	<br />
	<input type="submit" />
	</form>

  </body>
</html>

