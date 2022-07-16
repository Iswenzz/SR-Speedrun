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
		
		if(!isDefined(player.secret_1_endtrig) && self.target == "gohere13")
		{
			player.secret_1_endtrig = true;
			
			if(isDefined(player.sr_secret))
				player thread braxi\_mod::endTimer();
		}
		if(!isDefined(player.secret_1) && self.target == "gohere11")
		{
			player speedrun\_way_name::startSecret(); //Speedrun Copy Paste
			player.secret_1 = true;
			entTarget = getEnt( self.target, "targetname" );
			player setOrigin( entTarget.origin );
			player setplayerangles( entTarget.angles );
		}
		else
		{
			entTarget = getEnt( self.target, "targetname" );
			player setOrigin( entTarget.origin );
			player setplayerangles( entTarget.angles );
		}
	}
}