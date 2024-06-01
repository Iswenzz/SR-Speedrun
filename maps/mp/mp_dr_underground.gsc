main()
{
	maps\mp\_load::main();	
	
	setExpFog(100, 1000, 0.2, 0.25, 0.5, 0.0);

	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";
	
	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_map::createSpawn((-169, 0, 77), 180);
	thread sr\api\_speedrun::createEndMap((3270.47, -2917.15, -831.875), 150, 100);

	thread door();
	thread Teleport_trigger();
	thread round();
	thread round2();
	
	
}

door()
{
    trig = getEnt( "door2_trigger", "targetname" );
    brush = getEnt( "door2_brush", "targetname" );
	brush2 = getEnt( "door1_brush1", "targetname" );
    brush3 = getEnt( "door1_brush3", "targetname" );
	hurt1 = getEnt( "trap8_hurt1", "targetname" );
	hurt2 = getEnt( "trap8_hurt2", "targetname" );

   
    brush delete();
	brush2 delete();
	brush3 delete();
	hurt1 delete();
	hurt2 delete();

}

Teleport_trigger()
{
    trig = getEnt( "teleport_trigger", "targetname" );
	target =getEnt( "teleport_target", "targetname" );
	
	for(;;)
{
	trig waittill ("trigger", player);
	
	player SetOrigin(target.origin);
	player SetPlayerAngles( target.angles );
	player FreezeControls(1);
	wait 0.1;
	player FreezeControls(0);
}
}

Round()
{
	brush1 = getent( "round1", "targetname" );
	brush3 = getent( "round3", "targetname" );
	brush4 = getent( "round4", "targetname" );
	
	brush1 delete();
	brush3 delete();
	brush4 delete();
 

}

Round2()
{
	brush2 = getent( "round2", "targetname" );

	
    brush2 moveZ( 80, 0.1 );
	brush2 waittill("movedone");
	brush2 moveX( 150, 0.1 );
	brush2 waittill("movedone");
	brush2 rotateYaw (90,0.1);
 

}
	