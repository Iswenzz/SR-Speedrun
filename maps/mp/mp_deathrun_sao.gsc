main()
{
thread sr\api\_map::createSpawnOrigin((-246, 512, 0), 270);
maps\mp\_load::main();
maps\mp\mp_deathrun_sao\legendchallange::main();

	precacheItem("deserteagle_mp");
	precacheItem("ak47_mp");
	precacheItem("remington700_acog_mp");
	precacheItem("sao_sword_mp");

	preCacheStatusIcon("sao_start");
	preCacheShader("sao_start");
	preCacheShader("black");

	preCacheModel("body_mp_usmc_cqb");
	preCacheModel("sao_sword");
	preCacheModel("viewmodel_sword");

	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	setdvar( "r_specularcolorscale", "2" );

	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");
	setdvar("bg_fallDamageMaxHeight","400");
	setdvar("bg_fallDamageMinHeight","200");

thread sr\api\_speedrun::createNormalWays("Dungen Way;City Way;Ruby Way;");
thread sr\api\_speedrun::createSecretWays("Secret Way;");
secretorigin = getent("secretspot","targetname");
thread sr\api\_speedrun::createTeleporter((-561,562,53),100,150,secretorigin.origin,secretorigin.angles[1],"unfreeze", "blue", "secret_0");

thread secfinish();
thread door_on_edge();
thread arrows();
thread watersuicide();
level.arrow1 hide();
level.arrow2 hide();
level.arrow3 hide();
thread dungenendtp();
thread cityendtp();
thread rubyendtp();
thread randomroompick();

box = getEnt("wepbox","targetname");
box delete();

hurt = getEnt("trap20_killtrig","targetname");
hurt delete();

}

secfinish()
{
   trig = getent("secretendtrig", "targetname");

   for(;;)
    {
     trig waittill("trigger", player);
    player thread sr\api\_speedrun::finishWay("secret_0");
    }

}

door_on_edge()
{
	trig = getent("door_trig","targetname");
	door1 = getent("door1","targetname");
	door2 = getent("door2","targetname");

		door1 rotateYaw(90, 1);
		door2 rotateYaw(-90, 1);
		trig delete();
}

randomroompick()
{
		level thread dungen();
		level thread arrow1();
		thread removeglass();

		level thread rubypalace();
		level thread arrow2();

		level thread city();
		level thread arrow3();
}

removeglass()
{
	door = getent("glassdoor","targetname");
	{
		door moveX(144,2,1);
		door waittill("movedone");
		door delete();
	}
}

dungen()
{
	trig = getent("dungen_trig","targetname");
	spot = getent("dungen_tele_spot","targetname");
	while(true)
	{
		trig waittill("trigger", player);
		player thread sr\api\_speedrun::changeWay("normal_0");
		player setOrigin( spot.origin );
		player setplayerangles( spot.angles );
	}
}

rubypalace()
{
	trig = getent("rubypalace_trig","targetname");
	spot = getent("rubypalace_tele_spot","targetname");
	while(true)
	{
		trig waittill("trigger", player);
		player thread sr\api\_speedrun::changeWay("normal_1");
		player setOrigin( spot.origin );
		player setplayerangles( spot.angles );
	}
}

city()
{
	trig = getent("city_trig","targetname");
	spot = getent("city_tele_spot","targetname");
	while(true)
	{
		trig waittill("trigger", player);
		player thread sr\api\_speedrun::changeWay("normal_2");
		player setOrigin( spot.origin );
		player setplayerangles( spot.angles );
	}
}

arrows()
{
	level.arrow1 = getent("arow1","targetname");
	level.arrow2 = getent("arow2","targetname");
	level.arrow3 = getent("arow3","targetname");
}

arrow1()
{
	level.arrow1 = getent("arow1","targetname");
	level.arrow1 show();
}

arrow2()
{
	level.arrow2 = getent("arow2","targetname");
	level.arrow2 show();
}

arrow3()
{
	level.arrow3 = getent("arow3","targetname");
	level.arrow3 show();
}

watersuicide()
{
	trig = getent("watersuicide","targetname");
	for(;;)
	{
		trig waittill("trigger", player);
		player suicide();
		PlayFX(level._effect["watersuicide"],( player.origin ));
	}
}

dungenendtp()
{
	level.mapfinish = getent("origin_finish","targetname");
	trig = getent("endteleport_trig","targetname");
	while(true)
	{
		trig waittill("trigger", player);
		player thread sr\api\_speedrun::finishWay("normal_0");
		player setOrigin( level.mapfinish.origin );
		player setplayerangles( level.mapfinish.angles );
	}
}

cityendtp()
{
	trig = getent("cityendtp","targetname");
	for(;;)
	{
		trig waittill("trigger", player);
		player thread sr\api\_speedrun::finishWay("normal_1");
		player setOrigin(level.mapfinish.origin);
		player setplayerangles(level.mapfinish.angles);
	}
}

rubyendtp()
{
	trig = getent("rubyendtp","targetname");
	for(;;)
	{
		trig waittill("trigger", player);
		player thread sr\api\_speedrun::finishWay("normal_2");
		player setOrigin(level.mapfinish.origin);
		player setplayerangles(level.mapfinish.angles);
	}
}