main()
{
	entTransporter = getentarray( "enter", "targetname" );

	if(isdefined(entTransporter))
		for( i = 0; i < entTransporter.size; i++ )
			entTransporter[i] thread transporter();
}
 
transporter()
{
	for(;;)
	{
		self waittill( "trigger", player );

		if(self.target == "Vo1")
			player thread sr\api\_map::change_way("ns1");

		if(self.target == "Jo1")
			player thread sr\api\_map::change_way("ns2");

		if(self.target == "Oo1")
			player thread sr\api\_map::change_way("ns3");

		if(self.target == "Ro1")
			player thread sr\api\_map::change_way("ns4");

		entTarget = getEnt( self.target, "targetname" );
		player setOrigin( entTarget.origin );
		player setplayerangles( entTarget.angles );
	}
}