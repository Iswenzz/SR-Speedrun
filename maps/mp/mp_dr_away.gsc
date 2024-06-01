main()
{
maps\mp\_load::main();


thread sr\api\_speedrun::createEndMap((33733, -2495, 2300), 300, 150);
thread sr\api\_map::createSpawnOrigin((-1616, -1408, 1120), 90);
thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_speedrun::createSecretWays("^2Easy Secret;^1Hard Secret;^5Acti Secret;");
thread sr\api\_speedrun::createTeleporter((-1787.3, -1194.2, 1120.08), 60, 100, (-7601, -16415, 1084), 90, "freeze", "orange", "secret_1");
thread sr\api\_speedrun::createTeleporter((-1442.64, -1401.11, 1120.02), 60, 100, (-4762, -24889, 732), 180, "freeze", "orange", "secret_2");
thread sr\api\_speedrun::createEndMap((-17365.4, -11613.8, 320.125), 215, 200, "secret_1");

game["allies"] = "marines";
game["axis"] = "opfor";
game["attackers"] = "axis";
game["defenders"] = "allies";
game["allies_soldiertype"] = "desert";
game["axis_soldiertype"] = "desert";

	setdvar("r_drawDecals" ,"1");
	setdvar("r_specularcolorscale" ,"1");
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");

	thread startdoor();
	thread sr_tp();
	thread teleport1();
	thread teleport2();
	thread teleport3();
	thread teleport5();
	thread teleport6();
	thread teleport7();
	thread teleport9();
	thread teleport12();
	thread teleport13();
	thread teleport15();
	thread teleport16();
	thread teleport17();
	thread teleport19();
	thread teleport21();
	thread teleport22();
	thread teleport23();
	thread teleport24();
	thread teleport25();
	thread teleport26();
	thread teleport27();
	thread teleport28();
	thread teleport29();
	thread teleport30();
	thread teleport31();
	thread teleport32();
	thread teleport33();
	thread teleport35();
	thread teleport38();


	thread endoor();
	thread rpg3();
}


startdoor()
{
door = getent("startdoor","targetname");

door delete();

}

sr_tp()
{
	trig = spawn("trigger_radius",(-874.137, -1593.95, -655.875), 0, 125, 100);
	trig.radius = 125;
	ori_t = getEnt("origin_teleport11","targetname");

	thread sr\api\_map::createTriggerFx(trig, "blue");

	for(;;)
	{
		trig waittill("trigger",player);

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
	}
}

teleport1()
{
	trig = getent("trigger_teleport1", "targetname");
	tele1 = getent("origin_teleport1", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele1.angles);
		player setOrigin(tele1.origin);
	}
}

teleport2()
{
	trig = getent("trigger_teleport2", "targetname");
	tele2 = getent("origin_teleport2", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele2.angles);
		player setOrigin(tele2.origin);
	}
}

teleport3()
{
	trig = getent("trigger_teleport3", "targetname");
	tele3 = getent("origin_teleport3", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele3.angles);
		player setOrigin(tele3.origin);
	}
}

teleport5()
{
	trig = getent("trigger_teleport5", "targetname");
	tele5 = getent("origin_teleport5", "targetname");
	ladder = getent("ladder", "targetname");
	ladder2 = getent("ladder2", "targetname");

	ladder moveZ(-900, 0.1);
	ladder2 moveZ(-900, 0.1);

	for(;;)
	{
		trig waittill("trigger", player);
		player thread sr\api\_speedrun::changeWay("secret_0");
		player setPlayerAngles(tele5.angles);
		player setOrigin(tele5.origin);
	}
}


teleport6()
{
	trig = getent("trigger_teleport6", "targetname");
	tele6 = getent("origin_teleport6", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele6.angles);
		player setOrigin(tele6.origin);
	}
}


teleport7()
{
	trig = getent("trigger_teleport7", "targetname");
	tele7 = getent("origin_teleport7", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele7.angles);
		player setOrigin(tele7.origin);
	}
}


teleport9()
{
	trig = getent("trigger_teleport9", "targetname");
	tele9 = getent("origin_teleport9", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);

		player thread sr\api\_speedrun::finishWay("secret_0");

	}
}


teleport12()
{
	trig = getent("trigger_teleport12", "targetname");
	tele12 = getent("origin_teleport12", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele12.angles);
		player setOrigin(tele12.origin);
	}
}


teleport13()
{
	trig = getent("trigger_teleport13", "targetname");
	tele13 = getent("origin_teleport13", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele13.angles);
		player setOrigin(tele13.origin);
	}
}


teleport14()
{
	trig = getent("trigger_teleport14", "targetname");
	tele14 = getent("origin_teleport14", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele14.angles);
		player setOrigin(tele14.origin);
	}
}


teleport15()
{
	trig = getent("trigger_teleport15", "targetname");
	tele15 = getent("origin_teleport15", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele15.angles);
		player setOrigin(tele15.origin);
	}
}


teleport16()
{
	trig = getent("trigger_teleport16", "targetname");
	tele16 = getent("origin_teleport16", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele16.angles);
		player setOrigin(tele16.origin);
	}
}


teleport17()
{
	trig = getent("trigger_teleport17", "targetname");
	tele17 = getent("origin_teleport17", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele17.angles);
		player setOrigin(tele17.origin);
	}
}

teleport19()
{
	trig = getent("trigger_teleport19", "targetname");
	tele19 = getent("origin_teleport19", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		
		player Suicide();

	}
}

teleport21()
{
	trig = getent("trigger_teleport21", "targetname");
	tele21 = getent("origin_teleport21", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);

		player thread sr\api\_speedrun::finishWay("secret_1");
	}
}


teleport22()
{
	trig = getent("trigger_teleport22", "targetname");
	tele22 = getent("origin_teleport22", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele22.angles);
		player setOrigin(tele22.origin);
	}
}


teleport23()
{
	trig = getent("trigger_teleport23", "targetname");
	tele23 = getent("origin_teleport23", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele23.angles);
		player setOrigin(tele23.origin);
	}
}


teleport24()
{
	trig = getent("trigger_teleport24", "targetname");
	tele24 = getent("origin_teleport24", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele24.angles);
		player setOrigin(tele24.origin);
	}
}


teleport25()
{
	trig = getent("trigger_teleport25", "targetname");
	tele25 = getent("origin_teleport25", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele25.angles);
		player setOrigin(tele25.origin);
	}
}


teleport26()
{
	trig = getent("trigger_teleport26", "targetname");
	tele26 = getent("origin_teleport26", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele26.angles);
		player setOrigin(tele26.origin);
	}
}


teleport27()
{
	trig = getent("trigger_teleport27", "targetname");
	tele27 = getent("origin_teleport27", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele27.angles);
		player setOrigin(tele27.origin);
	}
}


teleport28()
{
	trig = getent("trigger_teleport28", "targetname");
	tele28 = getent("origin_teleport28", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele28.angles);
		player setOrigin(tele28.origin);
	}
}


teleport29()
{
	trig = getent("trigger_teleport29", "targetname");
	tele29 = getent("origin_teleport29", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele29.angles);
		player setOrigin(tele29.origin);
	}
}


teleport30()
{
	trig = getent("trigger_teleport30", "targetname");
	tele30 = getent("origin_teleport30", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele30.angles);
		player setOrigin(tele30.origin);
	}
}


teleport31()
{
	trig = getent("trigger_teleport31", "targetname");
	tele31 = getent("origin_teleport31", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele31.angles);
		player setOrigin(tele31.origin);
	}
}


teleport32()
{
	trig = getent("trigger_teleport32", "targetname");
	tele32 = getent("origin_teleport32", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele32.angles);
		player setOrigin(tele32.origin);
	}
}


teleport33()
{
	trig = getent("trigger_teleport33", "targetname");
	tele33 = getent("origin_teleport33", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele33.angles);
		player setOrigin(tele33.origin);
	}
}

teleport35()
{
	trig = getent("trigger_teleport35", "targetname");
	tele34 = getent("origin_teleport34", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player Suicide();
		
	}
}

teleport38()
{
	trig = getent("trigger_teleport38", "targetname");
	tele38 = getent("origin_teleport38", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setPlayerAngles(tele38.angles);
		player setOrigin(tele38.origin);
		player freezecontrols(true);
		wait 0.1;
		player freezecontrols(false);
	}
}
endoor()
{
	d1 = getent("endoor1", "targetname");
	d2 = getent("endoor2", "targetname");
	trig = getent("trigger_endoor", "targetname");
	trig waittill("trigger", player);

	d1 delete();
	d2 delete();
	
}

rpg3()
{
	trig = getent("rpg3", "targetname");

	for(;;)
	{

		trig waittill("trigger", player);
		player GiveWeapon("rpg_mp"); 
		player SwitchToWeapon("rpg_mp"); 
		player GiveMaxAmmo("rpg_mp"); 
		player SetClientDvar("g_speed" ,"500");
	}
}
