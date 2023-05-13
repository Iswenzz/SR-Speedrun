main()
{
	maps\mp\_load::main();
	game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";


	setDvar("r_glowbloomintensity0",".25");
    setDvar("r_glowbloomintensity1",".25");
    setDvar("r_glowskybleedintensity0",".3");
	setDvar("bg_falldamagemaxheight", 200000 );
	setDvar("bg_falldamageminheight", 150000 );


	thread sr\api\_map::createSpawnOrigin((417, 3420, 432), 270);
    thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Secret Way;");
	thread sr\api\_speedrun::createEndMap((10246.6, -15038, 361.038), 525, 240);
	thread sr\api\_speedrun::createTeleporter((-4683.31, -5898.16, 352.125), 160, 140, (-4684, -6386, 916), 269, "freeze", "blue");


	thread startdoor();
	thread tunnel();
	thread interstart();
	thread interfinish();
	thread startslider();
	thread startslider2();
	thread startslider3();

}

startdoor()
{
door = getEnt("startdoor", "targetname");

door delete();

}

tunnel()
{
	trig = getEnt("trig_tunnel", "targetname");
	arrivo = getEnt("o_tunnel", "targetname");
	end = getEnt("o_wormend", "targetname");
  for (;;)
  {
	trig waittill("trigger", player);

	player setOrigin(end.origin);
	player SetPlayerAngles(end.angles);
  }
}

interstart()
{
	trig = getEnt("trig_interenter", "targetname");
	arrivo = getEnt("o_interenter", "targetname");
  for (;;)
  {
	trig waittill("trigger", player);

	player thread sr\api\_speedrun::changeWay("secret_0");

	player setOrigin(arrivo.origin);
	player SetPlayerAngles(arrivo.angles);
  }
}

interfinish()
{
trig = getEnt("trig_210secretend", "targetname");
o = getEnt("o_210secretend", "targetname");

for(;;)
{

trig waittill("trigger", player);

player thread sr\api\_speedrun::finishWay("secret_0");

}
}

startslider()
{
	slider = getEntArray("rightslider", "targetname");

	slider[0] moveX(-1960, 1);
}

startslider2()
{
	slider = getEntArray("leftslider", "targetname");

	slider[0] moveX(2175, 1);
}

startslider3()
{
	slider = getEntArray("rightslider2", "targetname");

	slider[0] moveX(-1960, 1);
}
