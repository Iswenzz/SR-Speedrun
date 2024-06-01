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

	entTransporter = getentarray( "enter1", "targetname" );
	if(isdefined(entTransporter))
		for( i = 0; i < entTransporter.size; i++ )
			entTransporter[i] thread transporter1();

	entTransporter = getentarray( "enter3", "targetname" );
	if(isdefined(entTransporter))
		for( i = 0; i < entTransporter.size; i++ )
			entTransporter[i] thread transporter2();
			

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_map::createSpawn((1863, -10, 276), 0);
	thread sr\api\_speedrun::createEndMap((103.783, 4375.83, 104.125), 150, 100);
	

	thread start_door();	
	
}


start_door()
{
object = getent("start_door","targetname");

object delete();

}

transporter1()
{
	for(;;)
	{
		self waittill( "trigger", player );
		entTarget = getEnt( self.target, "targetname" );
		player setOrigin( entTarget.origin );
		player setplayerangles( entTarget.angles );
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}

transporter2()
{
	for(;;)
	{
		self waittill( "trigger", player );
		entTarget = getEnt( self.target, "targetname" );
		player setOrigin( entTarget.origin );
		player setplayerangles( entTarget.angles );
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}
