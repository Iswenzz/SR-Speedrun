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
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");

thread sr\api\_map::createSpawn((-10,1008,92),270);
thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_speedrun::createSecretWays("Secret Way;");	
thread sr\api\_speedrun::createTeleporter((1692.65, 615.119, -1143.88), 80, 50, (2146, 9732, 4), 90, "freeze", "blue", "normal_0");

	thread startdoor();
	thread jumperarea2();
	thread jumperarea3();
	thread lift();
	thread moveto();
	thread trap10();
	thread secrets();
	
}

startdoor()
{
door = getent ("boomdoor", "targetname");
door1 = getent ("startdoor1", "targetname");
door2 = getent ("startdoor2", "targetname");
door3 = getent ("startdoor3", "targetname");
door4 = getent ("startdoor4", "targetname");
door5 = getent ("startdoor5", "targetname");
door6 = getent ("startdoor6", "targetname");
gate = getent ("elevatorgate", "targetname");

door delete();
door1 delete();
door2 delete();
door3 delete();
door4 delete();
door5 delete();
door6 delete();
gate delete();
	
}

jumperarea2()
{
	trig = getent("trigger_teleportarea2", "targetname");
	teleportarea2 = getent("origin_teleportarea2", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin (teleportarea2.origin);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}

jumperarea3()
{
	trig = getent("trigger_teleportarea3", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);

		player thread sr\api\_speedrun::finishWay("normal_0");
	}
}


lift()
{
lift = getent ("lift", "targetname");

lift moveX(100,0.1);
}

moveto()
{
origin = getent ("origin_slidetp", "targetname");
trig = getent("trig_slidetp", "targetname");

for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin (origin.origin);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}

}

trap10()
{
rotater1 = getent ("trap10a", "targetname");
rotater2 = getent ("trap10b", "targetname");
rotater3 = getent ("trap10c", "targetname");

rotater1 moveX(20,0.1);
rotater2 moveX(-600,0.1);
rotater3 moveX(-1200,0.1);
wait 0.3;
rotater1 moveY(1945,0.1);
rotater2 moveY(1560,0.1);
rotater3 moveY(1175,0.1);

}

//////////SECRETS/////////


secrets()

{
thread secretenter();
thread secrettp1();
thread secrettp2();
thread secrettp3();
thread secrettp4();
thread secrettp5();
thread secrettp6();
thread secrettp7();
thread secrettp8();
thread secrettp9();
thread secrettp10();
thread secrettp11();
thread secretexit();
}

secretenter()
{ 
trigsecret1 = getent ("trigger_secret1enter", "targetname");
originsecret1 = getent ("origin_secret1enter", "targetname");

	for(;;)
	{
		trigsecret1 waittill("trigger", player);
		player thread sr\api\_speedrun::changeWay("secret_0");
		player setOrigin (originsecret1.origin);
		player.secret_finished = false;
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
		
	}           
}	

secrettp1()
{
trig1 = getent ("trig1", "targetname");
orig1 = getent ("orig1", "targetname");

for(;;)
	{
		trig1 waittill("trigger", player);
		player setOrigin (orig1.origin);
	}

}

secrettp2()
{
trig2 = getent ("trig2", "targetname");
orig2 = getent ("orig2", "targetname");

for(;;)
	{
		trig2 waittill("trigger", player);
		player setOrigin (orig2.origin);
	}

}

secrettp3()
{
trig3 = getent ("trig3", "targetname");
orig3 = getent ("orig3", "targetname");

for(;;)
	{
		trig3 waittill("trigger", player);
		player setOrigin (orig3.origin);
	}

}

secrettp4()
{
trig4 = getent ("trig4", "targetname");
orig4 = getent ("orig4", "targetname");

for(;;)
	{
		trig4 waittill("trigger", player);
		player setOrigin (orig4.origin);
	}

}

secrettp5()
{
trig5 = getent ("trig5", "targetname");
orig5 = getent ("orig3", "targetname");

for(;;)
	{
		trig5 waittill("trigger", player);
		player setOrigin (orig5.origin);
	}

}

secrettp6()
{
trig6 = getent ("trig6", "targetname");
orig6 = getent ("orig6", "targetname");

for(;;)
	{
		trig6 waittill("trigger", player);
		player setOrigin (orig6.origin);
	}

}

secrettp7()
{
trig7 = getent ("trig7", "targetname");
orig7 = getent ("orig7", "targetname");

for(;;)
	{
		trig7 waittill("trigger", player);
		player setOrigin (orig7.origin);
	}

}

secrettp8()
{
trig8 = getent ("trig8", "targetname");
orig8 = getent ("orig7", "targetname");

for(;;)
	{
		trig8 waittill("trigger", player);
		player setOrigin (orig8.origin);
	}

}

secrettp9()
{
trig9 = getent ("trig9", "targetname");
orig9 = getent ("orig8", "targetname");

for(;;)
	{
		trig9 waittill("trigger", player);
		player setOrigin (orig9.origin);
	}

}

secrettp10()
{
trig10 = getent ("trig10", "targetname");
orig10 = getent ("orig10", "targetname");

for(;;)
	{
		trig10 waittill("trigger", player);
		player setOrigin (orig10.origin);
	}

}

secrettp11()
{
trig11 = getent ("trig11", "targetname");
orig11 = getent ("orig11", "targetname");

for(;;)
	{
		trig11 waittill("trigger", player);
		player setOrigin (orig11.origin);
	}

}

secretexit()
{ 
trig = getent ("trigger_secret1exit", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		
		player.secret_finished = true;
		player thread sr\api\_speedrun::finishWay("secret_0");
	
	}           
}	
