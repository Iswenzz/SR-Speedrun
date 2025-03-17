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
    setdvar( "r_glowbloomintensity0", ".25" );
    setdvar( "r_glowbloomintensity1", ".25" );
    setdvar( "r_glowskybleedintensity0", ".3" );
    setdvar( "compassmaxrange", "1800" );
	setDvar("bg_falldamagemaxheight", 15000 );
	setDvar("bg_falldamageminheight", 10000 );

	thread startdoor();
	thread on_rope("trigger_rope_1", "rope_origin_1_1", "rope_origin_1_2");
	thread on_rope("trigger_rope_2", "rope_origin_2_1", "rope_origin_2_2");
	thread trap_3("trap_3_spikes_1", "trap_3_spikes_2", "trap_3_spikes_3", "trap_3_hurt_1", "trap_3_hurt_2", "trap_3_hurt_3");
	thread do_trigger_death("trigger_death_01");
	thread do_trigger_death("trigger_death_02");
	thread do_trigger_death("trigger_death_03");
	thread do_trigger_death("trigger_death_04");
	thread do_trigger_death("trigger_death_05");
	thread do_trigger_death("trigger_death_06");
	thread do_trigger_death("trigger_death_07");
	thread do_trigger_death("trigger_death_08");
	thread do_trigger_death("trigger_death_09");
	thread do_trigger_death("trigger_death_10");
	thread do_trigger_death("trigger_death_11");
	thread do_trigger_death("trigger_death_12");
	thread do_trigger_death("trigger_death_13");

	thread sr\api\_map::createSpawn((-406,-13,-388),1);
    thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread fix((-916, 1433, -900));
	thread fix((314, 1879, -805));
	thread fix((1142, 1928, -805));
}

fix(origin)
{
	trigger = spawn("trigger_radius", origin, 0, 300, 1000);
	trigger.targetname = "fix";
	trigger.radius = 300;

	while (true)
	{
		trigger waittill("trigger", player);
		player suicide();
	}
}

startdoor()
{
	start = getEnt("startdoor","targetname");
	trap6 = getEnt("trap_6_object","targetname");

	start delete();
	trap6 delete();
}

on_rope(trigger_entity, origin_1_entity, origin_2_entity)
{
	trigger = getEnt(trigger_entity, "targetname");
	start = getEnt(origin_1_entity, "targetname");
	end = getEnt(origin_2_entity, "targetname");

	for(;;)
	{
		trigger waittill("trigger", player);

		if (isalive(player) && isdefined(player) && !player.isOnRope)
		{
			player disableWeapons();
			player.isOnRope = true;
			thread do_rope(player, start, end);
		}

		wait .05;
	}
}

do_rope(player, start, end)
{
    player sr\api\_player::antiElevator(false);

	src_model = spawn ( "script_model", (5, 7, 1));
	src_model.origin = player.origin;

	player LinkTo(src_model);
	src_model moveTo(start.origin, 2, 1, 1);
	wait 2;

	player enableWeapons();
	src_model moveTo(end.origin, .5, .25, .25);
	wait .5;

    player sr\api\_player::antiElevator(true);

	player UnLink();
	src_model delete();
	player.isOnRope = false;
}

trap_3(spikes_1_entity, spikes_2_entity, spikes_3_entity, hurt_1_entity, hurt_2_entity, hurt_3_entity)
{
	spikes_1 = getEnt(spikes_1_entity, "targetname");
	spikes_2 = getEnt(spikes_2_entity, "targetname");
	spikes_3 = getEnt(spikes_3_entity, "targetname");
	hurt_1 = getEnt(hurt_1_entity, "targetname");
	hurt_2 = getEnt(hurt_2_entity, "targetname");
	hurt_3 = getEnt(hurt_3_entity, "targetname");

	hurt_1 enableLinkTo();
	hurt_1 linkTo(spikes_1);

	hurt_2 enableLinkTo();
	hurt_2 linkTo(spikes_2);

	hurt_3 enableLinkTo();
	hurt_3 linkTo(spikes_3);

	spikes_1 notSolid();
	spikes_2 notSolid();
	spikes_3 notSolid();

	spikes_1 moveZ(-92, .1);
	spikes_2 moveZ(-92, .1);
	spikes_3 moveZ(-92, .1);
	wait .2;

}

do_trigger_death(trigger_entity)
{
	trigger = getEnt(trigger_entity, "targetname");

	for(;;)
	{
		trigger waittill("trigger", player);

		if(isDefined(player) && isAlive(player) && isDefined(player.isDead) && !player.isDead)
		{
			player.isDead = true;
			thread on_death(player);
		}
	}
}

on_death(player)
{
	while(isDefined(player) && isAlive(player))
	{
		wait .05;

		if(player IsOnGround())
			break;
	}

	player.isDead = false;

	if(isAlive(player))
		player suicide();
}
