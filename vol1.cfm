
<html>
<head>
	<title>Game Master Entry</title>
<style type="text/css">
<!--
.cursor {  cursor: hand}
.posts {
	COLOR: #000000; FONT-FAMILY: Verdana, Arial, sans-serif; FONT-SIZE: 12px; MARGIN: 10px
}
-->
</style>	

<cfset SESSION.GMINDEX = SESSION.SESSIONNUMBER>


</head>
<link rel="stylesheet" type="text/css" href="styles/main.css">
<body>
<center>
<img src="../necro/images/volunteer-title.gif"  alt="" border="0">
</center>
<table width="100%">
<tr><td>
<h4 style="color:red">
If you plan on volunteering your time at the Game Table of <cfoutput>#SESSION.CONVENTIONNAME#</cfoutput>,here's where you register.

</h4></td></tr>
</table>

<form action="guidelines.cfm" method="post">

<h3>Click here if you are volunteering for the <input type="submit" name="fromIndex" value="First Time"></h3>

</form>

<h3>Or, fill in the following information if you've already Agreed to the GM Guidelines....</h3>



<form action="gmform.cfm" method="post">
<div align="center">
<table>
	<tr>
		<td>First Name</td>
		<td colspan=2><input type="text" name="FirstName" size="20"></td>
	</tr>
<!--- 	<tr>
		<td>Middle Name</td>
		<td colspan=2><input type="text" name="MiddleName" size="20"></td>
	</tr>
 --->	<tr>
		<td>Last Name</td>
		<td colspan=2><input type="text" name="LastName" size="20"></td>
	</tr>
	<tr>
		<td>Password</td>
		<td><input type="password" name="Password" size="20"></td>
		<td><input type="submit" name="fromIndex" value="Let Me In!"></td>
	</tr>		
</table>	
</form>	
<font size="+1" color="Black" style="background-color: Lime; font-variant: small-caps; font-style: italic;">Please note that you must re-register even if you registered last year!</font>

</div>	
</body>
</html>
