
<!---<script src="http://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script> --->


<script language="javascript">
	function showDetail(gameid) {

		var b = "GAMEDESCArea" + gameid;
		var lookupURL = "inlineGameDesc.cfm?GameID=" + gameid

		if ($("#"+b).text() > "")
		{
			$( "#"+b ).slideToggle(400, "swing", function() {$( "#"+b).text("") });
		}
		else
		{
			$.ajax({
			  url: lookupURL,
			  success: function( result ) {
				$( "#"+b ).html(result );
				$( "#"+b ).slideToggle();
			  }
			});
		}
	}

	function showRecent(gameid) {
		var lookupURL = "inlineGameDesc.cfm?GameID=" + gameid

		if ($(".exactCenter").text() > "")
		{
			$(".exactCenter" ).fadeToggle(200, function() {$( ".exactCenter" ).text("") });
		}
		else
		{
			$.ajax({
			  url: lookupURL,
			  success: function( result ) {
				$( ".exactCenter" ).html(result );
				$( ".exactCenter" ).fadeToggle("slow");
			  }
			});
		}


	}

</script>

			<div class="box2">

<cfquery datasource="#ds#" name="recentGames">
SELECT top 10
	   Games.GameId,
	   Games.Title,
	   GameTypes.Type
FROM (Games INNER JOIN [Game Masters] ON Games.GMid = [Game Masters].GMId) LEFT JOIN GameTypes ON Games.GameType = GameTypes.GameTypeId
WHERE (((Games.Cancelled)=0) AND ((Games.Approved)=1)) and ((Games.HideOnSchedule = 0))
ORDER BY Games.GameId DESC;
</cfquery>


				<div class="title">
					<h2>Most Recent Games</h2>
				</div>
				<ul class="style2">
					<cfoutput query="recentGames">
						<li onclick="showRecent(#gameid#)" style="cursor: pointer">#Title#</li>
					</cfoutput>
				</ul>
					<a href="schedule.cfm" class="icon icon-file-alt button">See All</a> </div>
			</div>
		</div>
	</div>
<style>

.exactCenter {
	width:800px;
	height:400px;
	position: fixed;
  	background-color: #f7f8f9;
	top: 50%;
	left: 50%;
	margin-top: -200px;
	margin-left: -400px;
	border: 1px solid black;
	border-radius: 5px;
	display: none;
	padding: 50px 30px 50px 30px;
	cursor: pointer;
}
</style>
	<div class="exactCenter" onclick="showRecent(-1)"></div>
