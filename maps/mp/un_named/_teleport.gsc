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
		if(self.target == "secretend")
		{
			if(!isDefined(player.secret_1))
			{
				player.secret_1 = true;
				player sr\api\_speedrun::changeWay("secret_0");
				entTarget = getEnt( self.target, "targetname" );
				player setOrigin( entTarget.origin );
				player setplayerangles( entTarget.angles );
				continue;
			}
		}
		// iprintlnbold(i);
		// iprintlnbold(self.target);
		entTarget = getEnt( self.target, "targetname" );
		player setOrigin( entTarget.origin );
		player setplayerangles( entTarget.angles );
	}
}