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
			
			player thread sr\api\_speedrun::finishWay("secret_0");
		}
		if(!isDefined(player.secret_1) && self.target == "gohere11")
		{
			player sr\api\_speedrun::changeWay("secret_0");
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