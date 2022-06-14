main()
{
	entTransporter = getentarray( "enter", "targetname" );
 
	level waittill("round_started");
 
	if(isdefined(entTransporter))
	{
		for( i = 0; i < entTransporter.size; i++ )
		{
			entTransporter[i] thread transporter(i);
		}
	}
}

transporter(i)
{	
	while(true)
	{
		self waittill( "trigger", player );
		
		// iprintlnbold(i);
		// iprintlnbold(self.target);
		
		if(!isDefined(player.secret_1_endtrig) && self.target == "auto552")
		{
			player.secret_1_endtrig = true;
			
			player thread sr\api\_speedrun::finishWay("secret_0");
		}
		
		else
		{
			entTarget = getEnt( self.target, "targetname" );
			player setOrigin( entTarget.origin );
			player setplayerangles( entTarget.angles );
		}
	}
}