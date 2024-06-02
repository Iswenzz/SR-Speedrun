main()
{
 maps\mp\_load::main();

 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"] = "desert";

  level.gas = loadfx ("customfx/gas2");
  level.gas1 = loadfx ("customfx/gas2");

	setdvar( "r_specularcolorscale", "1" );

	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setdvar("bg_fallDamageMaxHeight", "99999");
    setdvar("bg_FallDamageMinHeight","99998");
    precacheshader("mtl_johnwick_hair");
    precacheshader("mtl_johnwick_head");
    precacheshader("mtl_johnwick_suit");
    precacheModel("plr_terry_johnwick");

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_map::createSpawn((248,496,36),270);

thread slide();
thread pewpew();




}

slide()
{
    slide = getEnt("xd", "targetname");
    slide rotatePitch(180, 0.26, 0.15, 0.1);
	thread slide2();
}

slide2()
{
    slide = getEnt("xd1", "targetname");
    slide rotatePitch(180, 0.26, 0.15, 0.1);
	thread slide3();

}

slide3()
{
    slide = getEnt("xd2", "targetname");
    slide rotatePitch(180, 0.26, 0.15, 0.1);

}

pewpew()
{
	trig = getEnt("lol", "targetname");

	while(true)
	{
		trig waittill("trigger", player);
	 	player detachAll();
	    player setModel("plr_terry_johnwick");
		wait 0.1;
	}
}