main()
{
	maps\mp\_load::main();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("Secret Way;");
    thread sr\api\_map::createSpawn((512, -128, 316), 270);
    thread sr\api\_speedrun::createTeleporter((643.606, -128.075, 256.125), 60, 100, (-1533, -201, 90), 270, "freeze", "yellow", "secret_0");
	

	thread secretplat();
	thread platformmove1();
	thread platformmove2();
	thread platformmove3();
    thread secret0_end();

}


secretplat()
{
	secplatform = getEnt("secret_plat","targetname");
	
	
	secplatform delete();
	
}

platformmove1()
{
	platform = getEnt("platform1","targetname");
	
	
	platform movey (-200,0.1);

}

platformmove2()
{
	platform2 = getEnt("platform2","targetname");
	
	platform2 movez (48,0.1);
	
}

platformmove3()
{
	platform3 = getEnt("platform3","targetname");
	
	platform3 movez (-65,0.1);
	
}

secret0_end()
{
	trig = getEnt("trigger_finish_secret","targetname");
	

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::finishWay("secret_0");
		
	}
}