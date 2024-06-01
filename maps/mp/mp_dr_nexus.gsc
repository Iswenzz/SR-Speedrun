main()
{
maps\mp\_load::main();

    game["allies"] = "sas";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "woodland";
    game["axis_soldiertype"] = "woodland";

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("Secret Way;");
	thread sr\api\_map::createSpawn((1, -9, -664), 270);
	thread sr\api\_speedrun::createTeleporter((121.827, -194.334, -719.875), 60, 100, (-5185, -6076, 1608), 90, "freeze", "yellow", "secret_0");
	thread sr\api\_speedrun::createEndMap((-5235.53, -465.486, 616.125), 355, 100, "secret_0");

	thread trap9();
	thread lift();
	thread mover();
	thread mozgo();
	thread fail();

}

mozgo()
{
	mozgo=getent("mozog","targetname");
	
	mozgo moveY(-380, 0.1);
	mozgo waittill ("movedone");
	mozgo rotateYaw(90,0.1);
	
}

trap9()
{
	trig=getent("trap9_t", "targetname");
	trap9_1=getent("trap9_1","targetname");
	trap9_2=getent("trap9_2","targetname");
	dama1=getent("dmg9_1","targetname");
	dama2=getent("dmg9_2","targetname");

	trap9_1 delete();
	trap9_2 delete();
	dama1 delete();
	dama2 delete();
}

mover()
{
	mover=getent("mozgo","targetname");
	
	
	mover moveY (450, 0.1);
	mover rotateYaw (90,0.1);
	
}

fail()
{
	trig = getent ("sec_tele", "targetname");
	end = getent ("telep", "targetname");

	while(1)
	{
	trig waittill ("trigger", player);
	
	player Suicide();
	
	}
}

lift()
{
	lift=getent("lift","targetname");
	
	lift moveZ (-740, 0.1);
	
}
	