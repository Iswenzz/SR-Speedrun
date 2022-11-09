main()
{
	maps\mp\_load::main();
 	ambientPlay("ambient1");

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

thread sr\api\_map::createSpawn((1389,1159,28),2);
thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_speedrun::createTeleporter((2105.02, 1937.5, 80.125), 50, 50, (2105, 1969, 300), 90, "freeze", "blue");

	thread begin();
	thread Teleport1();
	thread Teleport2();
	thread Teleport3();
	thread blokje3();
	thread trap6();
	thread secret();
	thread secret_exit();
}

begin()
{
brush1 = getent("begin_brush1","targetname");
brush2 = getent("begin_brush2","targetname");
brush3 = getent("begin_brush3","targetname");
brush4 = getent("begin_brush4","targetname");
plat = getent("brick","targetname");

brush1 delete();
brush2 delete();
brush3 delete();
brush4 delete();
plat moveX(-16.5,0.1);


}

Teleport1()
{
	trig = getEnt ("teleport_trigger1", "targetname");
	target = getEnt ("teleport_target1", "targetname");

	for(;;)
	{
	trig waittill ("trigger", player);

	player SetOrigin(target.origin);
	player SetPlayerAngles( target.angles );
	player freezeControls(1);
	wait 0.01;
	player freezeControls(0);
	}
}

Teleport2()
{
	trig = getEnt ("teleport_trigger2", "targetname");
	target = getEnt ("teleport_target2", "targetname");

	for(;;)
	{
	trig waittill ("trigger", player);

	player SetOrigin(target.origin);
	player SetPlayerAngles( target.angles );
	player freezeControls(1);
	wait 0.01;
	player freezeControls(0);
	}
}


Teleport3()
{
	trig = getEnt ("teleport_trigger3", "targetname");
	target = getEnt ("teleport_target3", "targetname");

	for(;;)
	{
	trig waittill ("trigger", player);

	player SetOrigin(target.origin);
	player SetPlayerAngles( target.angles );
	player freezeControls(1);
	wait 0.01;
	player freezeControls(0);
	}
}

blokje3()
{
brush1 = getent("blokje4_1","targetname");
brush2 = getent("blokje4_2","targetname");
brush3 = getent("blokje4_3","targetname");
brush4 = getent("blokje4_4","targetname");

brush1 moveY(160,0.1);
brush2 moveY(-90,0.1);
brush3 moveY(-90,0.1);
brush4 moveY(160,0.1);
wait 0.5;
brush1 moveX(-130,0.1);
brush4 moveX(130,0.1);
}

trap6()
{
brush1 = getEnt( "trap6_brush1", "targetname" );
brush2 = getEnt( "trap6_brush2", "targetname" );

brush1 moveX(-96,0.1);
brush2 moveX(96,0.1);
wait 0.2;
brush1 RotateYaw(-90,0.1);
brush2 RotateYaw(-90,0.1);

}

Secret()
{
brush = getent("secretsong_brush","targetname");
sec1 = getent("secret_open_brush1","targetname");
sec2 = getent("secret_open_brush2","targetname");

brush delete();
sec1 delete();
sec2 delete();

}

Secret_exit()
{
	trig = getEnt ("secret_exit", "targetname");

	for(;;)
	{
	trig waittill ("trigger", player);

	player thread sr\api\_speedrun::finishWay("secret_0");

	}
}
