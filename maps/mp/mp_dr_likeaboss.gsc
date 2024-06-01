main()
{
    maps\mp\_load::main();
	
	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";
	
	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");
	setDvar("bg_falldamagemaxheight", 20000 );
	setDvar("bg_falldamageminheight", 15000 );

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_map::createSpawn((-448, -737, 89), 90);
	thread sr\api\_speedrun::createTeleporter((3895.18, 776.409, 227.125), 85, 100, (3396, 863, 469), 270, "freeze");
	thread sr\api\_speedrun::createEndMap((3735.71, -1732.63, 448.125), 195, 100);
	
	thread trap2();
	thread pusher1();
	thread pusher2();
	thread pusher3();
	thread pusher4();
	
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
		entTarget = getEnt( self.target, "targetname" );
		player FreezeControls (true);
		player setOrigin( entTarget.origin );
		player setplayerangles( entTarget.angles );
		wait 0.1;
		player FreezeControls (false);
	}
}

trap2()
{
	trig = getEnt ("trap2_trig", "targetname");
	spikes = getEnt ("spikes", "targetname");
	killer = getEnt ("hurt", "targetname");
	
	
	spikes delete();
	killer delete();
}

pusher1()
{
	pusher1 = getEnt("pusher1","targetname");
	hurt1 = getEnt("hurt1","targetname");
	
	hurt1 delete();

}

pusher2()
{
    pusher2 = getEnt("pusher2","targetname");
	hurt2 = getEnt("hurt2","targetname");
	
	hurt2 delete();

}

pusher3()
{
    pusher3 = getEnt("pusher3","targetname");
	hurt3 = getEnt("hurt3","targetname");
	
	hurt3 delete();	

}

pusher4()
{
    pusher4 = getEnt("pusher4","targetname");
	hurt4 = getEnt("hurt4","targetname");
	
	hurt4 delete();	

}