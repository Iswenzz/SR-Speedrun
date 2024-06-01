main()
{
	
maps\mp\_load::main();	

	
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");
	setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_map::createSpawn((0, 2, -1731), 360);
	thread sr\api\_speedrun::createTeleporter((2498.41, -1281.06, -2703.88), 60, 100, (2497, -1193, -2052), 90, "freeze");
	
	thread begin();
	thread mover();
	thread screen();
	thread lift2();
	thread teleport();
	thread door();
	thread trap1();
	thread trap1_1();

}


begin()
{
	brush = getEnt( "begin_brush", "targetname" );

	brush moveZ (-1696,0.1);
}

Mover()
{
	brush1 = getEnt( "trap12_brush1", "targetname" );


	brush1 moveY (80,0.1);

}

screen()
{
	brush = getEnt( "screen_brush", "targetname" );
	trig = getent("screen_trigger", "targetname");

	brush delete();

}

lift2()
{
	brush = getEnt( "lift2_brush", "targetname" );
	

	brush moveZ (-140,0.1);

}

teleport()
{
	target = getEnt( "teleport_target", "targetname" );
	trig = getent("teleport_trigger", "targetname");
	
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
	
door()
{
	brush = getEnt( "door_brush", "targetname" );
	trig = getent("door_trigger", "targetname");

	brush delete();

}

trap1()
{
	brush1 = getent ("trap1_brush1", "targetname");
	brush2 = getent ("trap1_brush2", "targetname");

	brush1 delete();
	brush2 delete();

}

trap1_1()
{
	brush1 = getent ("trap1_brush3", "targetname");
	brush2 = getent ("trap1_brush4", "targetname");

	brush1 delete();
	brush2 delete();

}
