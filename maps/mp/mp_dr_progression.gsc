main()
{
trigger = getEnt("greentele", "targetname");
trigger.targetname = "endmap_trig";

	maps\mp\_load::main();

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("Secret Way;");
	thread sr\api\_map::createSpawn((-153, 27, 76), 270);
	thread sr\api\_speedrun::createTeleporter((0, 0, 0), 60, 650, (-1284, 5812, -1636), 180, "freeze", "yellow", "secret_0");
	
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";
	
	setdvar("bg_fallDamageMaXHeight","300000");
	setdvar("bg_fallDamageMinHeight","200000");

	thread startdoor();
	thread trap3();
	thread tele1();
	thread tele2();
	thread secretrespawn();
	thread secretexit();


}

startdoor()
{
	door1 = getent("startdoor1", "targetname");
	door2 = getent("startdoor2", "targetname");
	plat = getent("platformpurp", "targetname");
	
	door1 delete();
	door2 delete();
	plat RotateYaw(90,0.1);
	wait 0.1;
	plat moveY(-100,0.1);

}

trap3(){
	trig = getent("trap3orgmove", "targetname");
	trig2 = getent("trap3_trig", "targetname");
	trig waittill ("trigger", player);
	trig delete();
	trap3_1 = getent("trap3_1", "targetname");
	trap3_2 = getent("trap3_2", "targetname");
	trap3_3 = getent("trap3_3", "targetname");
	trap3_4 = getent("trap3_4", "targetname");
	trap3_5 = getent("trap3_5", "targetname");
	trap3_6 = getent("trap3_6", "targetname");
	trap3_7 = getent("trap3_7", "targetname");
	trap3_8 = getent("trap3_8", "targetname");
	trap3_9 = getent("trap3_9", "targetname");
	trap3_10 = getent("trap3_10", "targetname");
	trap3_11 = getent("trap3_11", "targetname");
	trap3_12 = getent("trap3_12", "targetname");
	trap3_13 = getent("trap3_13", "targetname");
	trap3_14 = getent("trap3_14", "targetname");
	trap3_15 = getent("trap3_15", "targetname");
	trap3_16 = getent("trap3_16", "targetname");
	trap3_17 = getent("trap3_17", "targetname");
	trap3_18 = getent("trap3_18", "targetname");
	{
		trap3_1 moveY (650, 0.1);
		trap3_2 moveY (650, 0.1);
		trap3_3 moveY (650, 0.1);
		trap3_4 moveY (650, 0.1);
		trap3_5 moveY (650, 0.1);
		trap3_6 moveY (650, 0.1);
		trap3_7 moveY (650, 0.1);
		trap3_8 moveY (650, 0.1);
		trap3_9 moveY (650, 0.1);
		trap3_10 moveY (650, 0.1);

	}
}

tele1(){
	{
		tele= GetEnt("teleport_trig1","targetname");
		origin = GetEnt("teleport_origin1","targetname");
		while(1)
		{
			tele waittill("trigger", player);

			player SetPlayerAngles( origin.angles );
			player setOrigin( origin.origin );

		}	
	}

}

tele2(){
	{
		tele= GetEnt("yellowtele","targetname");
		origin = GetEnt("yelloworigin","targetname");
		for(;;)
		{
			tele waittill("trigger", player);

			player SetPlayerAngles( origin.angles );
			player setOrigin( origin.origin );

		}	
	}

}

secretrespawn()
{
	jumptele= GetEnt("secretrespawn","targetname");
	origin = GetEnt("secretrespawnorigin","targetname");

	for(;;)
	{
		jumptele waittill("trigger", player);

		player Suicide();
	}	
}


secretexit()
{
	secretexit = GetEnt("backtomap_trigger","targetname");
	origin = GetEnt( "backtomap_target", "targetname" );

	while(1)
	{
	secretexit waittill("trigger", player);

	player thread sr\api\_speedrun::finishWay("secret_0");
		
	}
}