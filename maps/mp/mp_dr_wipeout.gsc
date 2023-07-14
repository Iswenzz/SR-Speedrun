main()
{
trigger = getEnt("finaldoor", "targetname");
trigger.targetname = "endmap_trig";


  	maps\mp\_load::main();
	
	maps\mp\_compass::setupMiniMap ("compass_map_mp_dr_wipeout");
	

	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setdvar("compassmaxrange","1400");

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_map::createSpawn((-896, -28, 380), 0);

	thread jumper();
		
}

jumper()
{
jump1 = getent ("jump1","targetname");

big_air1 = getent ("big_air_1","targetname");
big_air2 = getent ("big_air_2","targetname");
big_air3 = getent ("big_air_3","targetname");
big_air4 = getent ("big_air_4","targetname");
big_air5 = getent ("big_air_5","targetname");


	for(;;)
	{
	jump1 waittill ("trigger",player);
		if (player istouching(jump1))
		{
        player sr\api\_player::antiElevator(false);

		airbig = spawn ("script_model",(0,0,0));

		airbig.origin = player.origin;
		airbig.angles = player.angles;
		player linkto (airbig);
		time = .1;
			airbig moveto (big_air1.origin, 1);
		wait .1;
			airbig moveto (big_air2.origin, 1);
		wait .1;
			airbig moveto (big_air3.origin, 1);
		wait .1;
			airbig moveto (big_air4.origin, 1);
		wait 1;
			airbig moveto (big_air5.origin, 1);
		wait 1;
		player sr\api\_player::antiElevator(true);
		player unlink();
		wait 1;
		}
	}
}