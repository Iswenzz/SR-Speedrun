main()
{
	maps\mp\_load::main();
	maps\mp\_compass::setupMiniMap("compass_mp_sr_pure_cancer");
 
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

	thread sr\api\_map::createSpawn((-10682, -6165, -20876), 270);
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createEndMap((6488.62, -20289.6, -19815.9), 205, 30, "normal_0");

	thread tp1();
}

tp1()
{
   trig = getent("enter", "targetname");
   ori = spawn("script_origin",(5480,-18762,-19756));
   ori.angles = (0,267,0);

   for(;;)
    {   
     trig waittill("trigger", player);
	 player thread sr_tp_safe(ori);
    }
}

sr_tp_safe(ori)
{
	self setOrigin(ori.origin);
	self SetPlayerAngles(ori.angles);
	self FreezeControls(1);
	wait 0.05;
	self FreezeControls(0);
}