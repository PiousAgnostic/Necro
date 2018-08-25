<cfif isDefined("LARPMENU")>
	<CFSET INITPATH = "../">
<CFELSE>
	<CFSET INITPATH = "">
</cfif>


<CFOUTPUT>
<link rel="stylesheet" href="#INITPATH#assets/stylesheets/arthref.css">

			<div id="menu">
				
				<ul>
					<li class="current_page_item"><a href="#INITPATH#index.cfm">Home</a></li>
					<li><a href="#INITPATH#schedule.cfm">Schedule</a></li>
					<li><a href="#INITPATH#admin.cfm" target="_top">Admin</a></li>
					<cfif IsDefined("SESSION.LOGGEDINGMN")>
						<li><a href="#INITPATH#gmindex.cfm">Your Games</a></li>
					<CFELSE>
						<CFIF NOT IsDefined("SESSION.Administrator")>
							<li><a href="#INITPATH#gmindex.cfm">Log In</a></li>
						</CFIF>
					</cfif>
					
					<CFIF IsDefined("SESSION.LOGGEDINGMN") OR
						  IsDefined("SESSION.Administrator")>
						<li><a href="#INITPATH#logout.cfm">Log Out</a></li>
					</cfif>		
					<li><a href="##" class="btn followSelector">Follow</a></li>
</CFOUTPUT>		
						



		
				</ul>
			</div>


<script>
	$(document).ready(function () {
//launchpad, launchpadReverse, slideTop, slideRight, slideBottom, slideLeft, chain
//http://www.jqueryscript.net/demo/List-Social-Accounts-Share-Any-Page-social/#
		$('.followSelector').socialProfiles({
			animation: 'launchpadReverse',
			blur: true,
			email: 'necronomicon-gaming@googlegroups.com',
			facebook: 'NecroGaming',
			google: '116704636126512558365',
			twitter: 'NecroGaming',

		});
	});
</script>