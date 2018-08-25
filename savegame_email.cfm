<cfmail to="#SESSION.ROBSEMAIL#"
        from="#SESSION.ROBSEMAIL#"
        subject="New Game Was Added to #SESSION.CONVENTIONNAME#"
		query="newGame"
		type="HTML" username="gaming" password="necrogaming10"
		 server="#SESSION.SMTPServer#"
       >A New Game Was Added by #newgame.firstname# #newgame.middlename# "#newgame.alias#" #newgame.lastname#
	   <p>
<b>#form.Title# </b>
<p>
<i>#form.system# </i>
<p>
#form.Desription#</cfmail>