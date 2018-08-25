<cfset tempvariable = StructDelete(session,"LOGGEDINGMN")> 
<cfset tempvariable = StructDelete(session,"LOGGEDINNAME")> 
<cfset tempvariable = StructDelete(session,"Administrator")> 

<cflocation addtoken="no" url="index.cfm">