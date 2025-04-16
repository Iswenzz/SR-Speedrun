
main()
{
	maps\mp\_load::main();

	VisionSetNaked( "mp_deathrun_easy" );

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setdvar("compassmaxrange","2000");

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_map::createSpawn((-544,-128,78), 0);
	thread sr\api\_speedrun::createEndMap((8062.25, -127.489, 16.125), 125, 120, "normal_0");

	thread start_door();
	thread trap4();
	thread trap8();
	thread plat1();
	thread plat2();


}

start_door()
{
	door = getent( "door_start", "targetname" );
	plat = getEnt ("trapx_11_0" , "targetname");
	
	door delete();
	plat delete();
}

trap4()
{
	trap4 = getent( "trap4x", "targetname" );
	
    trap4 moveY (-200, 0.1);
	wait 0.1;
	trap4 rotateYaw (90, 0.1);
}

trap8()
{
	trig = getent( "trap8", "targetname" );
	rotate = [];
	for(i = 0;i < 3;i++)
	{
		rotate[i] = getent( "trap8x_"+i, "targetname" );
		rotate[i] delete();
	}
	
}

plat1()
{
	plat = getEnt ("trapx_11_1" , "targetname");

	plat moveX (140 , 0.1);
	wait 0.1;

}

plat2()
{
	plat = getEnt ("trapx_11_2" , "targetname");

	plat moveX (-140 , 0.1 );
	wait 0.1;
	
}