main()
{
	//maps\mp\mp_strike_fx::main();
	//maps\createart\mp_strike_art::main();
	maps\mp\_load::main();
	
	//aps\mp\_compass::setupMiniMap("compass_map_mp_strike");

	//setExpFog(500, 2700, .46, 0.49, 0.47, 0);
	//setExpFog(0, 7000, 168/255, 158/255, 135/255, 3.0);	
	//ambientPlay("ambient_strike_day");
	//VisionSetNaked( "mp_strike" );

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setdvar( "r_specularcolorscale", "1" );

	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setdvar("compassmaxrange","1900");

	setdvar( "r_specularcolorscale", "1.86" );

	thread sr\api\_map::createSpawn((170, 311, 95), 180);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createEndMap((-5991.97, 405.936, 41.3309), 110, 125, "normal_0");

	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap5();
	thread trap6();
	thread trap7();
	thread trap8();
	//thread lastdoor();
	//thread welcomemsg ();
}

trap1 ()
	{
		trig_1 = getent("trig_1","targetname");
		brush1 = getent("brush1","targetname");
		trig_1 waittill("trigger");
	
	}
	
trap2 ()
	{
	trig_2 = getent ("trig_2","targetname");
	brush2 = getent("brush2","targetname");
	killing = getent ("killing","targetname");
	trig_2 waittill("trigger");

	}
	
trap3 ()
	{
		trig_3 = getent("trig_3","targetname");
		brush3 = getent("brush3","targetname");
		trig_3 waittill("trigger");
	
	}
	
trap4 ()
{
	part1 = getentarray ("part1" ,"targetname");
	part2 = getentarray ("part2" ,"targetname");
	trig_4 = getent ("trig_4" , "targetname");

	trig_4 waittill ("trigger" , player );

			
}

trap5 ()
{
	brush5 = getent ("brush5","targetname");
	orgi = getent (brush5.target,"targetname");
	trig_5 = getent ("trig_5","targetname");
	oldorigin = brush5.origin ;
	trig_5 waittill ("trigger",player);

}


trap6()
{
	door = getent ("brush6","targetname");
	kill = getent ("kill","targetname");
	trig_6 = getent ("trig_6","targetname");
	
	kill.origin = kill.origin - (0,0,10000); //deactivate kill trigger

	trig_6 waittill ("trigger");

}

trap7 ()
{
	brush7 = getent ("brush7","targetname");
	trig_7 = getent ("trig_7","targetname");
	trig_7 waittill ("trigger");

}

trap8 ()
	{
	brush8 = getent ("brush8","targetname");
	wait 0.1;

	brush8 delete();
	
	}

lastdoor ()
	{
	door1 = getent ("dooropen","targetname");
	door2 = getent ("door1","targetname");
	door1 waittill ("trigger");
	door1 delete ();
	door2 delete ();

	}
	
welcomemsg ()
	{
	level waittill ("spawned",player);
	level endon ("disconnect");
	level endon ("joined_spectator");
	wait 5 ;
	player iprintlnbold ("^2 T^7his map was created by ^1 iNext,xfears ^7Script by ^0iNext,Mr-X");
	wait 0.2 ;
	player iprintlnbold ("^0Shotgun^7 Down");
	}