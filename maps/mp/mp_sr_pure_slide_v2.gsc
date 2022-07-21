main()
{
thread sr\api\_map::createSpawnOrigin((126656, -126048, 768), 90);
    maps\mp\_load::main();

    game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setdvar("r_specularcolorscale","1");
	setdvar("compassmaxrange","1600");
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setDvar("bg_falldamagemaxheight", 20000000 );
	setDvar("bg_falldamageminheight", 15000000 );

    thread slide();
	thread song1();
    thread song2();
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	}

slide()
{
    slide = getEnt("xd", "targetname");
    slide rotatePitch(180, 0.26, 0.15, 0.1);
}

song1()
{
    trig = getEnt("song1_trig", "targetname");
    trig waittill("trigger",player);
    ambientStop("song2");
    ambientPlay("song1");
}

song2()
{
    trig = getEnt("song2_trig", "targetname");
    trig waittill("trigger",player);
    ambientStop("song1");
    ambientPlay("song2");
}


