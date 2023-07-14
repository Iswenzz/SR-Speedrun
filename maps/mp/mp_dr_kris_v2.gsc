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
	setdvar("bg_fallDamageMinHeight","100000000");

    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("Easy Secret;Hard Secret;");
	thread sr\api\_map::createSpawn((-234, 17, 61), 360);
	thread sr\api\_speedrun::createTeleporter((-234.036, -154.478, 1.125), 60, 100, (-865, 5241, 318), 360, "freeze", "green", "secret_0");
	thread sr\api\_speedrun::createTeleporter((-233.992, 166.433, 1.125), 60, 100, (-767, 9468, 654), 90, "freeze", "orange", "secret_1");
		
	thread startdoors();
	thread area2();
	thread area3();
	thread tank();
	thread ezsecrettp1();
	thread ezsecrettp2();
	thread ezsecrettp3();
	thread ezsecrettp4();
	thread ezsecrettp5();
	thread ezsecretexit();
	thread hdsecrettp1();
	thread hdsecrettp2();
	thread hdsecrettp3();
	thread hdsecrettp4();
	thread hdsecrettp5();
	thread hdsecrettp6();
	thread hdsecrettp7();
	thread hdsecrettp8();
	thread hdsecretexit();
	thread tank2();
	thread helicaptur();
	thread migend();
	
}


startdoors()
{
door1 = getent ("startdoor1","targetname");
door2 = getent ("startdoor2","targetname");

door1 delete();
door2 delete();


}

area2()
{
trig = getent("trig_area2", "targetname");
area2org = getent("origin_area2", "targetname");
	
	for(;;)
	{
	trig waittill("trigger", player);

	player FreezeControls(1);
	player SetOrigin(area2org .origin);
	player SetPlayerAngles( area2org .angles );
	wait 0.1;
	player FreezeControls(0);
	}
}

area3()
{
trig = getent("trig_area3", "targetname");
area3org = getent("origin_area3", "targetname");
	
	for(;;)
	{
	trig waittill("trigger", player);

	player SetOrigin(area3org .origin);
	}
}

tank()
{
trig = getent("boom_trigger", "targetname");
muzzle = getent("tankboom_origin", "targetname");
boom = getent("boomdoor_origin", "targetname");
door = getent("boomdoor", "targetname");


door delete();


}

ezsecrettp1()
{
trig = getent("ezsecret_trig1", "targetname");
ezsecretorigin1 = getent("ezsecret_origin1","targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player Suicide();
	}
}

ezsecrettp2()
{
trig = getent("ezsecret_trig2", "targetname");
ezsecretorigin2 = getent("ezsecret_origin2","targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player Suicide();
	}
}

ezsecrettp3()
{
trig = getent("ezsecret_trig3", "targetname");
ezsecretorigin3 = getent("ezsecret_origin3","targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player Suicide();
	}
}

ezsecrettp4()
{
trig = getent("ezsecret_trig4", "targetname");
ezsecretorigin4 = getent("ezsecret_origin4","targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player Suicide();
	}
}

ezsecrettp5()
{
trig = getent("ezsecret_trig5", "targetname");
ezsecretorigin5 = getent("ezsecret_origin5","targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player Suicide();
	}
}

ezsecretexit()
{
trig = getent("ezsecret_exit_trig", "targetname");
ezsecretexitorigin = getent("ezsecret_exit_origin","targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);

		player thread sr\api\_speedrun::finishWay("secret_0");
	}
}

hdsecrettp1()
{
trig = getent("hdsecret_trig1", "targetname");
hdsecretorigin1 = getent("hdsecret_origin1","targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player Suicide();
	}
}

hdsecrettp2()
{
trig = getent("hdsecret_trig2", "targetname");
hdsecretorigin2 = getent("hdsecret_origin2","targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player Suicide();
	}
}

hdsecrettp3()
{
trig = getent("hdsecret_trig3", "targetname");
hdsecretorigin3 = getent("hdsecret_origin3","targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player Suicide();
	}
}

hdsecrettp4()
{
trig = getent("hdsecret_trig4", "targetname");
hdsecretorigin4 = getent("hdsecret_origin4","targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player Suicide();
	}
}

hdsecrettp5()
{
trig = getent("hdsecret_trig5", "targetname");
hdsecretorigin5 = getent("hdsecret_origin5","targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player Suicide();
	}
}

hdsecrettp6()
{
trig = getent("hdsecret_trig6", "targetname");
hdsecretorigin6 = getent("hdsecret_origin6","targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player Suicide();
	}
}

hdsecrettp7()
{
trig = getent("hdsecret_trig7", "targetname");
hdsecretorigin7 = getent("hdsecret_origin7","targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player Suicide();
	}
}

hdsecrettp8()
{
trig = getent("hdsecret_trig8", "targetname");
hdsecretorigin8 = getent("hdsecret_origin8","targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player Suicide();
	}
}

hdsecretexit()
{
trig = getent("hdsecret_exit_trig", "targetname");
hdsecretexitorigin = getent("hdsecret_exit_origin","targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);

		player thread sr\api\_speedrun::finishWay("secret_1");
	}
}


tank2()
{
bridgerotate = getent ("tank2bridgerotate", "targetname");
bridge = getent ("tank2bridge", "targetname");
boom2 = getent ("boomdoor2_origin", "targetname");
boomdoor2 = getent ("boomdoor2", "targetname");
muzzle2 = getent("tankboom2_origin", "targetname");
trig = getent("tank2_trig", "targetname");


boomdoor2 delete();

}

helicaptur()
{
trig = getent("heli_trig", "targetname");
heli = getent ("heli", "targetname");
origin1 = getent("heliway1", "targetname");
origin2 = getent("heliway2", "targetname");
brush1 = getent("helibrush", "targetname");
brush2 = getent("helibrush2", "targetname");
	
		
	brush1 delete();
	brush2 delete();
	heli delete();

}

migend()
{
trig = getent("migtrig", "targetname");
mig1 = getent ("mig1", "targetname");
mig2 = getent ("mig2", "targetname");
mig3 = getent ("mig3", "targetname");
mis1 = getent ("mis1", "targetname");
mis2 = getent ("mis2", "targetname");
mis3 = getent ("mis3", "targetname");
mis4 = getent ("mis4", "targetname");
mis5 = getent ("mis5", "targetname");
mis6 = getent ("mis6", "targetname");
endorg1 = getent("endorg1", "targetname");
endorg2 = getent("endorg2", "targetname");
endorg3 = getent("endorg2", "targetname");
end1 = getent("end1", "targetname");
end2 = getent("end2", "targetname");
end3 = getent("end3", "targetname");
end4 = getent("end4", "targetname");
end5 = getent("end5", "targetname");
end6 = getent("end6", "targetname");


end1 delete();
end2 delete();
end3 delete();
end4 delete();
end5 delete();
end6 delete();
mis1 delete();
mis2 delete();
mis3 delete();
mis4 delete();
mis5 delete();
mis6 delete();

}